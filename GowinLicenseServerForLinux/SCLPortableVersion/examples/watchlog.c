/***********************************************************************

	THIS SOFTWARE IS DISTRIBUTED "AS IS" WITH NO GUARANTEE THAT
	IT WILL WORK FOR ANY INTENDED PURPOSES.

	THIS SOFTWARE IS NOT COPYRIGHTED. USE IT AS YOU WISH.

************************************************************************
*
* FILE: watchlog.c
*
* DATE: 28-Nov-2005
*
*	This tool can be used to monitor FLEXlm's lmgrd output log
* for events. When found, a script/program can be run to take a
* specific action.
*
*	For example, you could monitor the log file for the word
* "DENIED" and run a script that emailed the license administrator
* about the denial.
*
* BUILDING THE TOOL
*
*	Since the tool is contained in one file, the build is very
* straight forward:
*
*		cc -o watchlog watchlog.c
*
* RUNNING THE TOOL
*
*	The tool is run from the piped output of the lmgrd rather
* than specifying a log file for lmgrd (the "-l" option to lmgrd
* is not used):
*
*	lmgrd -c license.lic | watchlog watchlog.conf -o lmgrd.log &
*
* Note that the command must be sent into the background even though
* lmgrd normally backgrounds itself. This is because watchlog does not
* automatically go into the background.
*
* SETTING UP "watchlog.conf"
*
*	The configuration file for watchlog (which can be named anything
* you like as long as you use the same name when you run watchlog) is
* a two column, tab delimited file with the '#' sign as the first character
* denoting a comment line. The first column is the regular expression
* you wish to look for in the log file. The second column is the action
* to take when that expression is matched. There are three actions that
* can be taken: drop the line from the log, remove the timestamp on the
* line and create a new one (restamp), or execute a program.
*
*	To drop a line from the log, the action is just the single
* word "drop". The single word "restamp" means to modify the timestamp
* of the line to the current time. (This is usefull in getting around timezone
* issues that are croping up in the vendor daemons.) To send a mail upon occurance of 
* a pattern action is single word "mailto" followed by email Ids in " ". Email ids should
* be seperated using a ','.
* Anything else in the action column is assumed to be a program to run.
*
*	For example:
*
*  #
*  # This is the site "watchlog" configuration file for server
*  # "foo". We're going to filter out "bad handshake" messages and
*  # notify a sys-admin if we see DENIED or WARNING messages.
*  #
*
*  # Regular Expression           Action
*  # ------------------           ------
*  [bB]ad [hH]andshake            drop
*  DENIED                         adminmail dave
*  WARNING                        adminmail john
*  .                              restamp
*  expires 						  mailto="user1@company.com,user2@company.com"
*  EXPIRATION WARNING 			  mailto="user1@company.com,user2@company.com"
*
*  # end
*
* Note that there can be multiple tabs between the two columns,
* allowing you to lineup the columns; but there must be at least
* one tab between the regular expression and the action. Any spaces
* in the regular expression are considered part of the expressions.
*
* 	In this example we're droping the "bad handshake" messages
* from the final output log. When a DENIED line comes through,
* we're executing the program (binary or script) "adminmail" with
* the parameter "dave." The first word in the action column is
* the program name. All other words are the program parameters.
* When the program is executed, watchlog will put the line that
* triggered the action as the last parameter to the program call.
* Then, when the word WARNING shows up, we're executing "adminmail"
* with the parameter "john." Finally, we're re-timestamping all lines.
*
*	Good luck.
*
*	Your SCL development Staff: RK, CM, SS, SV.
*
*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>
#include <sys/wait.h>
#include <signal.h>

#define MAX_CATCHES 10
#define MAX_IN_LINE 5000
#define MAX_REGEX 100
#define MAX_CMD_LINE 2048

#define MAILFILE "./.mailto.log"
#define SUBJECT  "Alert: Expiring License keys found"

typedef enum {drop, restamp, runprogram, mailto} catchaction;

typedef struct {
	regex_t expression;
	catchaction action;
	char cmd[MAX_CMD_LINE+1];
} catchitem;

static catchitem CatchList[MAX_CATCHES+1];
static int NumCatches;
static char *OurName;
static FILE *ConfFP;
static FILE *OutFP;
static FILE *InFP;
static int debugging;

FILE *MailFP;

char EmailID[MAX_CMD_LINE];

static void usageThenQuit()
{
	fprintf(stderr,
		"Usage: %s <config file> [-o outfile] [-i infile] [-x]\n"
		"  stdin/stdout are used if not specified.\n",
		OurName);
	exit(13);
}

static void fatalError(int errorNumber, char *format, ...)
{
	va_list vArgs;

	fprintf(stderr, "Fatal Error");
	if (NULL != format)
	{
		fprintf(stderr, ": ");
		va_start(vArgs, format);
		vfprintf(stderr, format, vArgs);
	}
	if (0 != errorNumber)
		fprintf(stderr, ": %s", strerror(errorNumber));
	fprintf(stderr, "\n");
	exit(13);
}

static void processArgs(int argc, char **argv)
{
	int i;
	int parm;

	OurName = argv[0];
	OutFP = stdout;
	InFP = stdin;
	ConfFP = NULL;
	debugging = 0;

	i = 1;
	parm = 0;
	while(i < argc)
	{
		if ('-' == *argv[i])
		{
			if (0 == strcmp("-i", argv[i]))
			{
				if (++i >= argc)
					usageThenQuit();
				InFP = fopen(argv[i], "r");
				if (NULL == InFP)
					fatalError(errno,
						"Can't read file %s",
						argv[i]);
			}
			else if (0 == strcmp("-o", argv[i]))
			{
				if (++i >= argc)
					usageThenQuit();
				OutFP = freopen(argv[i], "w", stdout);
				if (NULL == OutFP)
					fatalError(errno,
						"Can't write file %s",
						argv[i]);
			}
			else if (0 == strcmp("-x", argv[i]))
				debugging = 1;
		}
		else
		{
			switch(++parm)
			{
			case 1:
				ConfFP = fopen(argv[i], "r");
				if (NULL == ConfFP)
					fatalError(errno,
						"Can't read file %s",
						argv[i]);
				break;
			}
		}
		++i;
	}

	if (NULL == ConfFP)
		usageThenQuit();
}

static char *getConfLine()
{
	static char buff[MAX_CMD_LINE+MAX_REGEX+10];
	int len;

	for(;;)
	{
		if (feof(ConfFP))
		{
			if (debugging)
				fprintf(stderr, "\tIN:EOF\n");
			return NULL;
		}

		buff[0] = '\0';
		fgets(buff, sizeof(buff), ConfFP);
		if ('#' == buff[0])	/* Comment line */
			continue;
		len = strlen(buff);
		if (0 >= len)
			return NULL;
		if ('\n' == buff[len-1])
			buff[len-1] = '\0';
		if (0 == strlen(buff))	/* Empty line */
			continue;
		if (debugging)
			fprintf(stderr, "\tIN:%s\n", buff);
		return buff;
	}
}

static int fieldLen(char *s)
{
	int len;

	len = 0;
	while(*s && ('\t' != *s))
	{
		++len;
		++s;
	}

	return len;
}

static char* nextField(char *s)
{
	s += fieldLen(s);
	while(*s && (('\t' == *s) || (' ' == *s)))
		++s;
	if (!*s)
		return NULL;
	return s;
}

int sendMail()
{
	char command[1025];
	pid_t t;
	int end = 0;

	command[0] = 0;
	
	MailFP = fopen(MAILFILE, "r");
	if(MailFP == NULL){
		if(debugging)
			fprintf(stderr, "Unable to open File: %s for read\n", MAILFILE);
		return 0;	
	}

	fseek (MailFP, 0, SEEK_END);
	end = ftell(MailFP);	

	if(end == 0){ /*Nothing is been written to file */
		if(debugging)
			fprintf(stderr, "\tNo mail body: not sending any mail");
		return 0;
	}
	
	sprintf(command, "/bin/mailx -s \"%s\"  %s < %s ", SUBJECT, EmailID, MAILFILE);

	if (debugging)
		fprintf(stderr,
			"\tEXECUTE: %s\n", command);

	t = fork();
	if ( t == 0){
		execl("/bin/sh", "sh", "-c", command, (char *)0);
		unlink(MAILFILE);
	}
	else
	{
		int ret;
		int statval;
		int exitval;

		do
		{
			ret = waitpid(t, &statval, 0);
		}
		while((-1 == ret) && (EINTR == errno));

		exitval = -1;
		if (t == ret)
		{
			/*
			* Normal process exit.
			*/

			if (WIFEXITED(statval))
				exitval = WEXITSTATUS(statval);
			else if (WIFSIGNALED(statval))
			{
				int sigval;
				sigval = WTERMSIG(statval);
				fprintf(stderr,"Error: command exited with signal %d.", sigval);
			}
			else
				fprintf(stderr, "Warning: command exited with unknown status.\n");
		}
		else
		{
			fprintf(stderr, "Warning: waitpid returned errno %d : %s\n",
				errno, strerror(errno));
		}

		return exitval;
	}	
	unlink(MAILFILE);
	return 0;
}

void alarmCatch(int signo)
{
	sendMail();
	/* Set a alarm for 24 hours */
	alarm(24*60*60);
}

static void loadCatchList()
{
	char regexpstr[MAX_REGEX+1];
	regex_t *regexp;
	char *line;
	int len;
	int index;
	char *temp;

	index = 0;
	while(NULL != (line = getConfLine()))
	{
		if (MAX_CATCHES <= index)
			break;

		if (debugging)
			fprintf(stderr, "\tSTAT:Loading item %d\n", index);

		len = fieldLen(line);
		if (len >= MAX_REGEX)
			len = MAX_REGEX;
		strncpy(regexpstr, line, len);
		regexpstr[len] = '\0';
		regexp = &CatchList[index].expression;
		regcomp(regexp, regexpstr, REG_NOSUB | REG_NEWLINE);
		if (debugging)
			fprintf(stderr, "\tREGEX:%s\n", regexpstr);

		line = nextField(line);
		if (NULL == line)
		{
			if (debugging)
				fprintf(stderr, "\tSTAT:No command field\n");
			free(regexp);
			break;
		}
		len = fieldLen(line);
		strncpy(CatchList[index].cmd, line, len);
		CatchList[index].cmd[len] = '\0';
		if (debugging)
			fprintf(stderr, "\tCMD:%s\n", CatchList[index].cmd);

		if (0 == strcasecmp("drop", CatchList[index].cmd))
			CatchList[index].action = drop;
		else if (0 == strcasecmp("restamp", CatchList[index].cmd))
			CatchList[index].action = restamp;
		else if (0 == strncasecmp("mailto", CatchList[index].cmd,6)){
			CatchList[index].action = mailto;
			/*Extract the email IDs */
			temp = strchr(CatchList[index].cmd, '=');
			if(temp != NULL)
				strcpy(EmailID,temp+1);	
			/*Truncate the mailto file */
			unlink(MAILFILE);
			signal(SIGALRM, alarmCatch);
			alarm(120);
		}
		else
			CatchList[index].action = runprogram;
		if (debugging)
			fprintf(stderr,
				"\tDO:%s\"%s\"\n",
				(drop == CatchList[index].action) ?
					"DROP - " :
					"",
				CatchList[index].cmd);
		++index;
	}

	NumCatches = index;
}

static int takeAction(int i, char *line)
{
	char command[MAX_IN_LINE+MAX_CMD_LINE+10];
	char fixedLine[MAX_IN_LINE+10];
	pid_t t;
	int len;
	char *unstampedLine;
	time_t T;
	struct tm *theTime;

	switch(CatchList[i].action)
	{
	case drop:
		if (debugging)
			fprintf(stderr, "\tSTAT:Dropping - %s", line);
		return 1;

	case restamp:
		time(&T);
		theTime = localtime(&T);
		strftime(fixedLine, sizeof(fixedLine), "%H:%M:%S", theTime);
		unstampedLine = strchr(line, ' ');
		if (NULL != unstampedLine)
			strcat(fixedLine, unstampedLine);
		strcpy(line, fixedLine);
		return 0;

	case runprogram:
		strcpy(command, CatchList[i].cmd);
		strcat(command, " \"");
		strcat(command, line);
		len = strlen(command);
		if ('\n' == command[len-1])
			command[len-1] = '\0';
		strcat(command, "\"");

		if (debugging)
			fprintf(stderr, "\tRUN:Parent:forking\n");

		t = fork();

		if (t == 0)	/* child */
		{
			if (debugging)
				fprintf(stderr, "\tRUN:Child:%s\n", command);
			execl("/bin/sh", "sh", "-c", command, (char *)0);
			perror(command);
			exit(1);
		}
		return 0;

	case mailto:
		MailFP = fopen(MAILFILE, "a+");
		if ( MailFP == NULL)
			fprintf(stderr, "ERROR: Opening file \"%s\" for write\n", MAILFILE);

		fprintf(MailFP, "%s\n", line);
		fclose (MailFP);

		return 0;
	}
	return 0;
}

static int isMatch(int i, char *line)
{
	int err;

	err = regexec(&CatchList[i].expression, line, 0, NULL, 0);
	return (0 == err);
}

int main(int argc, char **argv)
{
	char buff[MAX_IN_LINE];
	int i;
	int drop;

	processArgs(argc, argv);
	if (debugging)
		fprintf(stderr, "\n\t%s starting...\n", OurName);
	if (debugging){
		fprintf(stderr, "\n\t*****************************\n");
		fprintf(stderr, "\t STARTED WATCHLOG MAIN LOOP\n");
		fprintf(stderr, "\t*****************************\n\n");
	}
	loadCatchList();

	/*
	 * Loop reading the input, checking all
	 * of our catches against the string and taking
	 * the desired action if a match is found.
	 */

	while(!feof(InFP))
	{
		fgets(buff, sizeof(buff), InFP);

		drop = 0;
		for(i = 0; i < NumCatches; i++)
		{
			if (isMatch(i, buff))
				drop += takeAction(i, buff);
		}

		if (0 == drop)
		{
			fputs(buff, OutFP);
			fflush(OutFP);
		}
	}

	return 0;
}
