#!/usr/bin/perl

use FindBin;
use Math::BigInt;
use Getopt::Long;
use File::Basename;
use MIME::Base64 qw(encode_base64);

#############################################################
## Get Options
#############################################################
$get_opt_return_flag = GetOptions(
		   "list|l:s",
		   "i|input:s",
		   "o|output:s",
           "pk|public_keys:s",
		   "verilog!",
		   "vhdl!",
           "log:s",
           ## Args for old key block style
           "key_version|kv=f",
           "output_method|om:s",
		   "tier:s",
           "license:s",
           "old_synplify_style_key_block!",
		   #"av|allowed_vendor:s",
		   #"allowed_technology:s",
           #"allowed_view:s",
           #"log_messages:s",
           "kx|keyx:s",
		   "ivx|intialization_vectorx:s",
           "sk|showkey!",
           "verbose:s",
           "debug:s",
           "quiet!",
           "help|h!");

$encrypt_agent = "Synplify encryptP1735.pl";
$encrypt_agent_info = "Synplify encryptP1735.pl Version 1.1";

if(defined $opt_log) {
	open(LOG, ">$opt_log") || dying ("ERROR: Unable to open log file $opt_log, $!\n");
	select LOG;
}

if(!$get_opt_return_flag) { usage(); }

if(defined $opt_help or defined $opt_usage) { usage(); }

#############################################################
## Print Usage
#############################################################
sub usage {
    iprint ("$encrypt_agent_info 
Usage: $0
    -l   | -list <list-file>    Input File containing list of files to be encrypted
    [-pk | -public_keys]        Public keys repository file. This file contains all public keys used for encryption
    [-h  | -help]               Display this screen
    [-log <log-file>]           Print messages to a log file
    [-verbose]                  Print verbose messages on screen or in the log file
    
  Command line arguments for advanced use:
    [-sk | -showkey]            Display session key. No value just -sk
    [-verilog]                  HDL file format. No need to specify if file extension is .v or .sv
    [-vhdl]                     HDL file format. No need to specify if file extension is .vhd or .vhdl
    
  Additional advanced command line arguments:
    [-output_method | -om       <Output Method - one of 'plaintext' 'blackbox' 'encrypted'> - Default is 'encrypted']
    [-license                   <Add a Synopsys license requirement to the key block. Format is string>]
    [-tier                      <Tool Tier - one of 'pro' or 'premier' - default is 'all'>]

Example 1: Using default public keys repository file (from Synplify installation)
    perl encryptP1735.pl -l files_list_file

Example 2: Using user specified public keys repository file
    perl encryptP1735.pl -l files_list_file -pk public_keys_file

");
	exit 1;
}

#############################################################
## Process deprecated arguments
#############################################################

if(0) { ## Disabling short-key since it is not supported yet
if(defined $opt_output_method || defined $opt_tier || defined $opt_license || defined $opt_key_version) {
	if(defined $opt_old_synplify_style_key_block) {
		$ext_enc_version = 1;
	} else {
		$string = "";
		$string .= " -output_method" if defined $opt_output_method;
		$string .= " -tier" if defined $opt_tier;
		$string .= " -license" if defined $opt_license;
		$string .= " -key_version" if defined $opt_key_version;
		dying ("ERROR: Deprecated command line argument(s)$string. Add additional argument -old_synplify_style_key_block to allow that for now\n");
	}
} else {
	$ext_enc_version = 1.1;
}

if(defined $opt_old_synplify_style_key_block) {
	$ext_enc_version = 1;
}
}

## Always use long-key for this release
$ext_enc_version = 1;

#############################################################
## Check Encryption Engine Based on Operating System
#############################################################
$platform = $^O;
$path = $ENV{'PATH'};

if ($platform eq "linux") {
    $split_char = ":";
    $engine = "openssl";
} elsif ($platform eq "MSWin32") {
    $split_char = ";";
    $engine = "openssl.exe";
} elsif ($platform eq "cygwin") {
    $split_char = ":";
    $engine = "openssl";
} else {
    dying ("ERROR: $platform is not a supported platform - please use Linux or Windows\n");
}

my $openssl_dir; # first openssl path
my @split_path = split $split_char,$path;
foreach my $dir (@split_path) {
    if (-x $dir."/".$engine) {
        $engine_exists = 1;
        $openssl_dir = $dir unless defined $openssl_dir;
    }
}

if ($engine_exists != 1) {
    dying ("ERROR: $engine encryption engine was not found on your system - please check your PATH variable\n");
} else {
    iprint ("Info: Using $engine encryption engine in $openssl_dir\n");	
}

#############################################################
## Check Inputs and Setup Defaults
#############################################################

local $ifile = $opt_i;
local $ofile = $opt_o;
# check input file
if(defined $opt_i || defined $opt_o) {
	$ofile = $opt_i.'p' if !defined $opt_o;
	if(defined $opt_list) {
		dying ("ERROR: Specify either -i and -o OR -l command line option. Both are not allowed at the same time.\n");
	}	
} elsif (!defined $opt_list) {
    iprint("ERROR: Missing input list file!\n\n", 1);
    usage(); 
} elsif (!(-e $opt_list)) {
    iprint("ERROR: Input list file $opt_list does not exist!\n\n", 1);
    usage();
}

# check public-keys-repository file
if (!defined $opt_pk) {
    $opt_pk = "$FindBin::Bin/keys.txt";
} elsif (!(-e $opt_pk)) {
    iprint("ERROR: public-keys repository file $opt_pk does not exist!\n\n", 1);
    usage();
}

if($ext_enc_version > 1) {
	if (defined $opt_key_version) {
		$key_version = $opt_key_version;
		if ($key_version < 3.6) {
		  iprint("ERROR: Minimum supported key version by this script is 3.6\n\n", 1);
		  usage();
	    }
	} else {
		$key_version = 3.6;
	}
} else {
	$key_version = 3.6;
}

if (defined $opt_ev) {
	$enc_version = $opt_ev;
} else {
	$enc_version = 1;
}

## Setup session key as follows
## if -kx 0 then random key for each envelope
## if -kx 1 then one randomly selected key for all envelopes (default)
## else then use that key for all envelopes, error if cipher length mismatch
%session_keys_repository = ();
if(!defined $opt_kx || $opt_kx eq "1") {
    $session_keys_repository{'des-cbc'} = generate_session_key('des-cbc');	
    $session_keys_repository{'3des-cbc'} = generate_session_key('3des-cbc');	
    $session_keys_repository{'aes128-cbc'} = generate_session_key('aes128-cbc');	
    $session_keys_repository{'aes256-cbc'} = generate_session_key('aes256-cbc');	
} elsif(defined $opt_kx && $opt_kx ne "0") {
    $data_keyx = $opt_kx;
    my $cipher = get_cipher_from_key($data_keyx);
    $session_keys_repository{$cipher} = $data_keyx;
}

## Setup initialization vectors as follows
## if -ivx 0 then random iv for each envelope (default)
## if -ivx 1 then one randomly selected iv for all envelopes
## else then use that iv for all envelopes, error if cipher length mismatch
%initialization_vectors_repository = ();
if (defined $opt_ivx) {
	if($opt_ivx eq "1") {
	    $initialization_vectors_repository{'des-cbc'} = generate_initialization_vector('des-cbc');	
	    $initialization_vectors_repository{'3des-cbc'} = generate_initialization_vector('3des-cbc');	
	    $initialization_vectors_repository{'aes128-cbc'} = generate_initialization_vector('aes128-cbc');	
	    $initialization_vectors_repository{'aes256-cbc'} = generate_initialization_vector('aes256-cbc');	
	} elsif($opt_ivx ne "0") {
	    $data_ivx = $opt_ivx;
	    my ($cipher1, $cipher2) = get_cipher_from_iv($data_ivx);
	    $initialization_vectors_repository{$cipher1} = $data_ivx;
	    $initialization_vectors_repository{$cipher2} = $data_ivx;
	}
}

# set verbose command
if (defined $opt_verbose) {
    $verbose  = "-p";
} else {
    $verbose  = "";
}

##===========================================================
## Check command line 'rights'
##===========================================================

# check output method
if (!defined $opt_output_method) {
    $opt_output_method = "encrypted";
}

if (($opt_output_method ne "plaintext") and
    ($opt_output_method ne "blackbox") and
    ($opt_output_method ne "encrypted") and
    ($opt_output_method ne "persistent_key")) {
    iprint("ERROR: Incorrect output_method $opt_output_method \n\n", 1);
    usage();
} else {
    $output_method  = $opt_output_method;
}

# Check license
if (defined $opt_license) {
	if ($key_version <= 3.0) {
      iprint ("WARNING: -l (license) ignored unless used with key version (-kv) >= 3.0\n\n", 1);
    }
	$license = $opt_license;
} else {
	$license = "";
}

# check tool-tier
if (!defined $opt_tier) {
    $tier = "all";
} elsif (($opt_tier ne "oem") and
         ($opt_tier ne "pro") and
         ($opt_tier ne "premier") and
         ($opt_tier ne "classic")) {
    iprint("ERROR: Incorrect tier $opt_tier\n\n", 1);
    usage();
} else {
    $tier  = $opt_tier;
}

# check log-messages
if (!defined $opt_messages) {
    $log_messages = "none";
} elsif (($opt_messages ne "none") and
         ($opt_messages ne "nonames") and
         ($opt_messages ne "unrestricted")) {
    iprint("ERROR: Incorrect log-messages $opt_messages \n\n", 1);
    usage();
} else {
    $log_messages  = $opt_messages;
}

# check allowed-vendor
if (!defined $opt_av) {
    $allowed_vendor = "all";
} elsif (($opt_av ne "xilinx") and
         ($opt_av ne "altera") and
         ($opt_av ne "lattice")) {
    iprint("ERROR: Incorrect allowed-vendor $opt_av \n\n", 1);
    usage();
} else {
    $allowed_vendor  = $opt_av;
}

# check allowed-technology
if (!defined $opt_allowed_technology) {
	$allowed_technology  = "all";
} else {
    $allowed_technology  = $opt_allowed_technology;
}

# check allowed-view
if (!defined $opt_allowed_view) {
    $allowed_view = "mapped,placed";
} elsif (($opt_allowed_view ne "rtl") and
         ($opt_allowed_view ne "mapped") and
         ($opt_allowed_view ne "placed")) {
    iprint("ERROR: Incorrect allowed-view $opt_allowed_view \n\n", 1);
    usage();
} else {
    $allowed_view  = $opt_allowed_view;
}

#############################################################
## Verbose Messages
#############################################################
if(defined $opt_verbose && 0) { ## disabled
  if (defined $license and $license ne "") {
    $blic = $license;
  } else {
  	$blic = "<UNSPECIFIED>";
  }
  print<<END_OF_VERBOSE
Info:
   input files list     =  $opt_list
   default tier         =  $tier
   default license      =  $blic
   default keyversion   =  $key_version
   default outputmethod =  $output_method
   default encversion   =  $enc_version
   default publickeys   =  $opt_pk

END_OF_VERBOSE
}

#############################################################
## Read in keys from key repository file
#############################################################
local %keys_file_pragmas = ();
local %keys_file_public_keys_repository = (); # keys extracted from keys file
local $keys_file_data_block_marker =
	read_keys_file($opt_pk, \%keys_file_pragmas, \%keys_file_public_keys_repository);

sub read_keys_file {
	my ($keys_file, $my_keys_file_pragmas, $my_keys_file_public_keys_repository) = @_;
	my ($public_key_block_flag, $key_keyowner, $key_keyname, $data_block_marker) = (0, "", "", "");
	# add default values for encrypt agent
	$my_keys_file_pragmas->{header}->{encrypt_agent} = $encrypt_agent;
	$my_keys_file_pragmas->{header}->{encrypt_agent_info} = $encrypt_agent_info;

	if(-f $keys_file) {
		iprint ("Info: Using public keys repository file $keys_file\n");
		open(KEYS, $keys_file) || dying ("ERROR: Opening key-repository file $keys_file, $!\n");
		while(<KEYS>) {
		    next if /^\s*$/; # ignore empty lines
		    next if /^\s*\/\//; # ignore commented lines
		    if(/^\s*`(pragma\s+)?protect\s+(.*)/) {
				add_to_keys_file_pragma_storage($2, $my_keys_file_pragmas);
		    	if($public_key_block_flag) {
					$key_keyowner = "";
					$key_keyname = "";
					$public_key_block_flag = 0;
		    	}
				$key_keyowner = $1 if(/\bkey_keyowner\s*=\s*\"(.*?)\"/);
				$key_keyname = $1 if(/\bkey_keyname\s*=\s*\"(.*?)\"/);
				$public_key_block_flag = 1 if(/key_public_key/);
				$data_block_marker = 'begin' if(/\bbegin\b/);
				$data_block_marker = 'end' if(/\bend\b/);
			}
			elsif($public_key_block_flag) {
				$my_keys_file_public_keys_repository->{"$key_keyowner.$key_keyname"} .= $_ unless (/(BEGIN|END)\s*PUBLIC\s*KEY/i);
			}
		}
		close KEYS;
	} else {
		iprint ("Info: Public keys repository file does not exist at $keys_file\n");
		iprint ("Info: Continuing without public keys repository file\n");
	}
	## print %$my_keys_file_public_keys_repository contents
	foreach my $hkey (keys %$my_keys_file_public_keys_repository) {
	    iprint ("Info: Found public key '$hkey' in repository\n");
		#print "`pragma protect '$hkey'\n";
		#print $keys_file_public_keys_repository{$hash_key} . "\n";
	}
	## print %$my_keys_file_pragmas contents
	foreach my $type (keys %$my_keys_file_pragmas) {
		my $hash = $my_keys_file_pragmas->{$type};
		#print "\%keys_file_params{$type}:\n";
		foreach my $key (keys %$hash) {
			my $hash2 = $hash->{$key};
			#print "  $key: " . (ref $hash2 ? "" : $hash->{$key}) . "\n";
			foreach my $name (keys %$hash2) {
				#print "      $name = $hash2->{$name}\n";
			}
		}
	}
	return $data_block_marker;
}

#############################################################
## Process each file from the list
#############################################################
my @list = ($opt_i);
if(defined $opt_list) {
	iprint ("\nProcessing list file $opt_list\n\n", 1);
	open(LIST, $opt_list) || dying ("ERROR: Opening input list file $opt_list, $!\n");
	@list = <LIST>;
	close LIST;
}

foreach (@list) {
	chomp;
	next if(/^\s*$/); # ignore empty lines
	next if(/^\s*#/); # ignore commented lines
	s/^\s*(.*?)\s*$/$1/; # ignore leading and trailing spaces
	($ifile, $ofile) = get_cmd_line_options_from_list_file($_);

    iprint ("Processing file $ifile\n", 1);
	
	# check file format: verilog or vhdl
	my ($file_type_verilog, $file_type_vhdl) = ();
	my (undef, undef, $extn) = fileparse($ifile, qr/\.[^.]*/);
	if (!defined $opt_verilog && !defined $opt_vhdl) {
	    if($extn eq ".v" or $extn eq ".sv") { $file_type_verilog = 1 }
	    if($extn eq ".vhd" or $extn eq ".vhdl") { $file_type_vhdl = 1 }
	} else {
		$file_type_verilog = $opt_verilog;
		$file_type_vhdl = $opt_vhdl;
	}
	if (!defined $file_type_verilog && !defined $file_type_vhdl) {
	    dying ("ERROR: HDL language of the input file not specified. Use -verilog or -vhdl option to do so.\n");
	}
	if(defined $file_type_vhdl) { iprint ("Info: HDL type is set to VHDL.\n"); }
	if(defined $file_type_verilog) { iprint ("Info: HDL type is set to Verilog.\n"); }
	
	local $pragma_protect = "`pragma protect";
	$pragma_protect = "`protect" if (defined $file_type_vhdl);

	#############################################################
	## First Parse - input file to be encrypted
	## Add encryption envelope to HDL if missing
	#############################################################
	local %hdl_file_pragmas = ();
	local @hdl_file_contents = ();
   	my $insert_index = 0;
	my @temp_contents = ();
	my $first_pragma_line = 0;
	my $key_block_flag = 0;
	my $data_block_flag = 0;
	my $rights_block_flag = 0;
	my $hdl_file_envelopes = 0;
	my $key_blocks_in_envelope = 0;
	my ($key_keyowner, $key_keyname) = ();
	
	my @keys_file_contents = ();
	if(defined $opt_pk && -e $opt_pk) {
		open(KEYS, $opt_pk) || dying ("ERROR: Opening key-repository file $opt_pk, $!\n");
		while(<KEYS>) {
			next if(/^\s*$/); # ignore empty lines
			next if(/^\s*\/\//); # ignore commented lines
			push @keys_file_contents, $_;
		}
		close KEYS;
	}
	
	open(IN, $ifile) || dying ("ERROR: Opening input file $ifile, $!\n");
	my @in_file_contents = <IN>;
	close IN;
	
	open(IN, $ifile) || dying ("ERROR: Opening input file $ifile, $!\n");
	while(<IN>) {
	    my $linenum = $.;
	    if(/^\s*`(pragma\s+)?protect\s+(.*)/) {
			add_to_hdl_file_pragma_storage($2, \%hdl_file_pragmas);
			%hdl_file_pragmas = () if(/\breset\b/); # clear pragma history
	        $key_keyowner = $1 if(/key_keyowner\s*=\s*\"(.*?)\"/);
	        $key_keyname = $1 if(/key_keyname\s*=\s*\"(.*?)\"/);
	        $key_block_flag = 1 if(/\bkey_block\b/);
	        $key_block_flag = 1 if(/\bkey_public_key\b/);
			$rights_block_flag = 'begin' if(/\brights_block\b/ and $rights_block_flag eq '0');
			$rights_block_flag = 'end' if(!/\bcontrol\b/ and $rights_block_flag eq 'begin');
			$data_block_flag = 'begin' if(/\bbegin\b/ and $data_block_flag eq '0');
			$data_block_flag = 'end' if(/\bend\b/ and $data_block_flag eq 'begin');
			$first_pragma_line = $. if $first_pragma_line==0;
			if(defined $key_keyowner || defined $key_keyname) {
				dying ("ERROR: Missing keyword key_block before line $linenum in file $ifile") if $data_block_flag eq 'begin';
			}
		}
		if($key_block_flag) {
	        $key_block_flag = 0;
	        $key_blocks_in_envelope++;
	        $key_keyowner = undef;
	        $key_keyname = undef;
		}
	    if($rights_block_flag eq 'begin') {
	        $found_rights_block{"$key_keyowner:$key_keyname"} = 1; ## Set it to 1 when found
	    }
	    if($rights_block_flag eq 'end') {
	        $rights_block_flag = 0;
	    }
	    if($data_block_flag eq 'begin') {
	    	if($key_blocks_in_envelope==0) {
		    	my $insert_index2 = ($first_pragma_line > 0) ? $first_pragma_line-1 : 0;
		    	push @hdl_file_contents, (@temp_contents[$insert_index..$insert_index2], @keys_file_contents); 
		    	$insert_index = $insert_index2;
	    	}
			$key_blocks_in_envelope = 1;
	    }
		if($data_block_flag eq 'end') {
			$key_blocks_in_envelope = 0;
			$first_pragma_line = 0;
			$hdl_file_envelopes++;
			$data_block_flag = 0;
		}
		push @temp_contents, $_;
	}
	push @hdl_file_contents, @temp_contents[$insert_index..$#temp_contents];

	## Add keys file contents if no envelope found
	if($hdl_file_envelopes==0) {
		if($keys_file_data_block_marker eq "begin") {
			@hdl_file_contents = (@keys_file_contents, @in_file_contents, "$pragma_protect end");			
		} else {
			@hdl_file_contents = (@keys_file_contents, "$pragma_protect begin", @in_file_contents, "$pragma_protect end");
		}
	}
	#print "----------------Begin HDL file-----------------\n";
	#print "@hdl_file_contents\n";
	#print "----------------End HDL file-----------------\n";

	close IN;
	close KEYS;

	#############################################################
	## Second Parse - input file to be encrypted
	## Create session key and IV for each envelope
	#############################################################
	local @init_vectors_list = (); # One entry per envelope
	local @session_keys_list = (); # One entry per envelope
	local @data_methods_list = (); # One entry per envelope
	local %hdl_file_pragmas = ();
	local %found_rights_block = ();
	my $key_block_flag = 0;
	my $data_block_flag = 0;
	my $rights_block_flag = 0;
	my $key_blocks_in_envelope = 0;
	my ($key_keyowner, $key_keyname) = ();
	
	foreach(@hdl_file_contents) {
	    next if /^\s*$/;
	    my $linenum = $.;
	    if(/^\s*`(pragma\s+)?protect\s+(.*)/) {
			add_to_hdl_file_pragma_storage($2, \%hdl_file_pragmas);
			%hdl_file_pragmas = () if(/\breset\b/); # clear pragma history
	        $key_keyowner = $1 if(/key_keyowner\s*=\s*\"(.*?)\"/);
	        $key_keyname = $1 if(/key_keyname\s*=\s*\"(.*?)\"/);
	        $key_block_flag = 1 if(/\bkey_block\b/);
			$rights_block_flag = 'begin' if(/\brights_block\b/ and $rights_block_flag eq '0');
			$rights_block_flag = 'end' if(!/\bcontrol\b/ and $rights_block_flag eq 'begin');
			$data_block_flag = 'begin' if(/\bbegin\b/ and $data_block_flag eq '0');
			$data_block_flag = 'end' if(/\bend\b/ and $data_block_flag eq 'begin');
		}
		if($key_block_flag) {
			my $lookup = $key_keyowner . $key_keyname;
	        $key_block_flag = 0;
	        $key_blocks_in_envelope++;
		}
	    if($rights_block_flag eq 'begin') {
	        $found_rights_block{"$key_keyowner:$key_keyname"} = 1; ## Set it to 1 when found
	    }
	    if($rights_block_flag eq 'end') {
	        $rights_block_flag = 0;
	    }
		if($data_block_flag eq 'end') {
			$hdl_file_pragmas{data_method} = $keys_file_pragmas{footer}->{data_method} if !defined $hdl_file_pragmas{data_method};
			iprint ("WARNING: Undefined data_method (cipher). Needs to be defined in HDL or keys file. Defaulting to aes256-cbc\n", 1) if !defined $hdl_file_pragmas{data_method};
			$hdl_file_pragmas{data_method} = "aes256-cbc" if !defined $hdl_file_pragmas{data_method};
			my $local_data_method = $hdl_file_pragmas{data_method};
			my ($session_keyx, $init_vectorx) = generate_key_and_iv($local_data_method);
			push @session_keys_list, $session_keyx;
			push @init_vectors_list, $init_vectorx;
			push @data_methods_list, $local_data_method;
			$key_blocks_in_envelope = 0;
			$data_block_flag = 0;
		}
	}
	
	#############################################################
	## Third Parse - input file to be encrypted
	## Encrypt neccessary blocks using session key 
	## and IV from previous parse 
	#############################################################
	my $envelopes = 0;
	local $key_public_key_text = "";
	local $rights_block_text = "";
	local $data_block_text = "";
	local $enc_envelope_id = 0;
	local %hdl_file_pragmas = ();
	local %hdl_file_public_keys_repository = (); #key extracted from hdl envelope
	($key_block_flag, $data_block_flag, $rights_block_flag) = (0, 0, 0);
	($key_keyowner, $key_keyname, $data_keyowner, $data_keyname) = ("", "", "", "");
	($key_blocks_count, $rights_blocks_count, $data_blocks_count) = (0, 0, 0);
	$hdl_file_pragmas{version} = 1; # default version=1
	my $begin_protected_flag = 1;
	my $inside_protected = 0;
	
	## Process HDL file
	open(OUT, ">$ofile") || dying ("ERROR: Opening output file $ofile, $!\n");
	foreach(@hdl_file_contents) {
		my $linenum = $.;
		# Print empty spaces outside encryption envelope
		if(/^\s*`(pragma\s+)?protect\s+end\b/) { $inside_protected = 0 }
		elsif(/^\s*`(pragma\s+)?protect\s+/) { $inside_protected = 1 }
	    if(/^\s*$/) { ## blank line
			print OUT unless $inside_protected;
			$data_block_text .= $_ if($data_block_flag eq 'begin');
			next;
		}
		# Generate key block here
	    if(/^\s*`(pragma\s+)?protect\s+(.*)/) {
			# If key_block is followed by key_public_key
			# Order is important for next two if-statements
			if($key_public_key == 1) {
				$key_public_key = 0;
				$key_block_flag = 1;
			}
			# If key_block is not followed by key_public_key
			if($key_block == 1 and !/\bkey_public_key\b/) {
				$key_block_flag = 1;
			}
			$key_block = 0;
		}
		#print;
		#print "**** key_block_flag=$key_block_flag\n";
		if($key_block_flag) {
			merge_keys_file_and_hdl_file_pragmas($key_keyowner, $key_keyname, 'key_block');
			merge_keys_file_and_hdl_file_pragmas($key_keyowner, $key_keyname, 'header') if $begin_protected_flag;
			$hdl_file_public_keys_repository{"$key_keyowner.$key_keyname"} = $key_public_key_text unless $key_public_key_text eq "";
			$hdl_file_pragmas{key_method} = "rsa" if !defined $hdl_file_pragmas{key_method};
			$hdl_file_pragmas{key_method} = lc $hdl_file_pragmas{key_method};
			iprint ("WARNING: Unrecognizable key_method $hdl_file_pragmas{key_method}. Defaulting to rsa\n", 1) if $hdl_file_pragmas{key_method} != 'rsa';
			print OUT generate_key_block($key_keyowner, $key_keyname, $begin_protected_flag), "\n";
			$key_block_flag = 0;
			$key_public_key_text = "";
			$key_blocks_count++;
			$begin_protected_flag = 0; # handles multiple keyblocks
			## In case encryption envelope does not specify a rights block, print an empty one
	        print OUT generate_rights_block($key_keyowner, $key_keyname, $rights_block_text), "\n"
			    if $found_rights_block{"$key_keyowner:$key_keyname"} == 0 and $enc_version > 1;
		}
		# Parse encryption envelope here
	    if(/^\s*`(pragma\s+)?protect\s+(.*)/) {
			add_to_hdl_file_pragma_storage($2, \%hdl_file_pragmas);
			%hdl_file_pragmas = () if(/\breset\b/); # clear pragma history
			$hdl_file_pragmas{version} = 1 if(/\breset\b/); # default version=1
			$key_keyowner = $1 if(/key_keyowner\s*=\s*\"(.*?)\"/);
			$key_keyname = $1 if(/key_keyname\s*=\s*\"(.*?)\"/);
			$data_keyowner = $1 if(/data_keyowner\s*=\s*\"(.*?)\"/);
			$data_keyname = $1 if(/data_keyname\s*=\s*\"(.*?)\"/);
			$rights_block_flag = 'begin' if(/\brights_block\b/ and $rights_block_flag eq '0');
			$rights_block_flag = 'end' if(!/\bcontrol\b/ and $rights_block_flag eq 'begin');
			$data_block_flag = 'begin' if(/\bbegin\b/ and $data_block_flag eq '0');
			$data_block_flag = 'end' if(/\bend\b/ and $data_block_flag eq 'begin');
			$key_public_key = 1 if(/\bkey_public_key\b/);
			$key_block = 1 if(/\bkey_block\b/);
			# Rights block is not supported for version=1 
			if($rights_block_flag ne '0' and $enc_version < 2) {
				dying ("ERROR: Rights block not supported in encryption-version 1. Line $linenum file $ifile\n");
			}
		}
		elsif($rights_block_flag eq 'begin') {
			$rights_block_text .= $_;
			#print OUT;
		}
		elsif($data_block_flag eq 'begin') {
			$data_block_text .= $_;
		}
		elsif($key_public_key == 1) {
			$key_public_key_text .= $_ unless (/(BEGIN|END)\s*PUBLIC\s*KEY/i);
		}
		else {
			print OUT;
			$inside_protected = 0;
		}
		if($rights_block_flag eq 'end') {
			merge_keys_file_and_hdl_file_pragmas($key_keyowner, $key_keyname, 'rights_block');
			print OUT generate_rights_block($key_keyowner, $key_keyname, $rights_block_text), "\n";
			$rights_block_flag = 0;
			$rights_block_text = "";
			$rights_blocks_count++;
		}
		if($data_block_flag eq 'end') {
			merge_keys_file_and_hdl_file_pragmas($data_keyowner, $data_keyname, 'footer');
			$hdl_file_pragmas{data_method} = "aes256-cbc" if !defined $hdl_file_pragmas{data_method};		
			($data_keyowner, $data_keyname) = ($hdl_file_pragmas{data_keyowner}, $hdl_file_pragmas{data_keyname});
			print OUT generate_data_block($data_keyowner, $data_keyname, $data_block_text), "\n";
			$data_block_flag = 0;
			$data_block_text = "";
			$data_blocks_count++;
			$begin_protected_flag = 1; # handles multiple envelopes
			$enc_envelope_id++; # About to start next envelope
			## Check if block count is as required
			dying ("ERROR: No key blocks found. Need minimum of 1 key block in HDL or keys file\n") if($key_blocks_count == 0);
			dying ("ERROR: $data_blocks_count data blocks found. Need exactly 1 data block. Line $linenum file $ifile\n") unless($data_blocks_count == 1);
			dying ("ERROR: $rights_blocks_count rights blocks found. Need minimum of $key_blocks_count rights blocks. Line $linenum file $ifile\n")
				if(($version > 1) && ($rights_blocks_count < $key_blocks_count));
			($key_blocks_count, $rights_blocks_count, $data_blocks_count) = (0, 0, 0);
			%hdl_file_public_keys_repository = ();
			$envelopes++;
		}
	}
	close OUT;
	
	if($envelopes eq 0) {
	    dying ("\nERROR: Processed 0 envelopes - nothing was encrypted - make sure $ifile has atleast one encryption envelope\n");
	} else {
	    iprint ("\nDone. Processed $envelopes envelopes. Generated encrypted file $ofile\n\n");
	}
}

# exiting, delete temporary files, unless in debug mode 2 or higher
unless(defined $opt_debug && $opt_debug > 1) {
    unlink("__encrypt.log") if -f "__encrypt.log";
    unlink("pubkey.pem") if -f "pubkey.pem";
	unlink("randkey.bin") if -f "randkey.bin";
    unlink("keyblock.txt") if -f "keyblock.txt";
    unlink("keyblock.bin") if -f "keyblock.bin";
    unlink("datablock.txt") if -f "datablock.txt";
    unlink("datablock.bin") if -f "datablock.bin";
    unlink("datablock.sha") if -f "datablock.sha";
}

##======================================================
##======================================================
## Functions
##======================================================
##======================================================

## Get commad line options from list file
sub get_cmd_line_options_from_list_file {
	my $line = shift;
	my ($ifile, $ofile);
	# $ifile = $1 if($line =~ /-i\s+(\S+)/);
	if($line =~ /-i\s+(\S+)/) {	$ifile = $1; }
	elsif($line =~ /^\s*(\S+)/) { $ifile = $1; }
        else { $ifile = $line; }
	# $ofile = $1 if($line =~ /-o\s+(\S+)/);
	if($line =~ /-o\s+(\S+)/) {	$ofile = $1; }
	elsif($line =~ /\S+\s+(\S+)\s*$/) { $ofile = $1; }
	else { $ofile = $ifile.'p'; }
        $ofile = $opt_o if defined $opt_o;
	return ($ifile, $ofile);
}

## Returns public key based on keyowner and keyname
sub get_public_key_from_repository {
	my ($keyowner, $keyname) = @_;
	my $key = get_public_key_from_given_repository($keyowner, $keyname, \%hdl_file_public_keys_repository);
	return $key if defined $key and $key ne "";
	$key = get_public_key_from_given_repository($keyowner, $keyname, \%keys_file_public_keys_repository);
	return $key if defined $key and $key ne "";
	dying ("ERROR: No key in public keys repository for keyowner=$keyowner, keyname=$keyname\n");
	close IN; close OUT;
}
## Returns public key based on keyowner and keyname, from a given keys repository hash
sub get_public_key_from_given_repository {
	my ($keyowner, $keyname, $public_keys_repository) = @_;
	#print "Key block for: keyowner=$keyowner, keyname=$keyname\n";
	## print %$my_keys_file_public_keys_repository contents
	#foreach my $hkey (keys %$public_keys_repository) {
	#    print "**** Info: Found public key '$hkey' in repository\n";
	#	print $public_keys_repository->{$hkey} . "\n";
	#}
	my $hash_key = "$keyowner.$keyname";
	my $key = $public_keys_repository->{$hash_key};
	return $key if defined $key;
	foreach $hash_key (keys %$public_keys_repository) {
		$key = $public_keys_repository->{$hash_key};
		return $key if($hash_key =~ /^$keyowner\./ and (!defined $keyname or $keyname eq ""));
		return $key if($hash_key =~ /^\.$keyname/ and (!defined $keyowner or $keyowner eq ""));
	}
	return undef;
}

sub get_session_key_from_repository {
	my ($index) = @_;
	return $session_keys_list[$index];
}
sub get_init_vector_from_repository {
	my ($index) = @_;
	return $init_vectors_list[$index];
}
sub get_data_method_from_repository {
    my ($index) = @_;
    return $data_methods_list[$index];
}

# Add pragma to %hdl_file_pragmas
sub add_to_hdl_file_pragma_storage {
	my $line = shift;
	my $pragma_storage = shift;
	foreach my $pragma (split_skipping_quoted(',', $line)) {
		if($pragma =~ /^\s*(\w+)\s*=\s*\"(.*?)\"\s*$/) {
			$pragma_storage->{$1} = $2;
		} elsif($pragma =~ /^\s*(\w+)\s*=\s*(.*?)\s*$/) {
			$pragma_storage->{$1} = $2;
		}
	}
	$enc_version = $pragma_storage->{version} if(defined $pragma_storage->{version});
}

# Add pragma to %keys_file_pragmas
sub add_to_keys_file_pragma_storage {
	my $line = shift;
	my $pragma_storage = shift;
	#print "add_to_keys_file_pragma_storage(): line=$line\n";
	$pragma_storage->{'header'} = {} if !defined $pragma_storage->{'header'};
	$pragma_storage->{'footer'} = {} if !defined $pragma_storage->{'footer'};
	# extract individual pragmas from multi pragma lines
	foreach my $pragma (split_skipping_quoted(',', $line)) {
		if(($pragma =~ /^\s*(\w+)\s*=\s*\"(.*?)\"\s*$/) || ($pragma =~ /^\s*(\w+)\s*=\s*(.*?)\s*$/) || ($pragma =~ /^\s*(.*?)\s*$/)) {
			my ($pname, $pvalue) = ($1, $2);
			if($pname =~ /(version|author|encrypt)/) {
				$pragma_storage->{'header'}->{$pname} = $pvalue;				
			} else {
				$pragma_storage->{'footer'}->{$pname} = defined $pvalue ? $pvalue : "";
			}
		}
	}
	# footer isn't footer but key block if found keyword key_public_key
	if(defined $pragma_storage->{'footer'}->{'key_public_key'}) {
		my $owner = $pragma_storage->{'footer'}->{'key_keyowner'};
		my $name = $pragma_storage->{'footer'}->{'key_keyname'};
		$pragma_storage->{'key_block'} = {} if !defined $pragma_storage->{'key_block'};
		$pragma_storage->{'key_block'}->{$owner.$name} = $pragma_storage->{'footer'};
		delete $pragma_storage->{'key_block'}->{'key_public_key'};
		$pragma_storage->{'footer'} = {};
	}
	# footer isn't footer but rights block if found keyword begin
	if(defined $pragma_storage->{'footer'}->{'rights_block'}) {
		my $owner = $pragma_storage->{'footer'}->{'key_keyowner'};
		my $name = $pragma_storage->{'footer'}->{'key_keyname'};
		$pragma_storage->{'rights_block'} = {} if !defined $pragma_storage->{'rights_block'};
		$pragma_storage->{'rights_block'}->{$owner.$name} = $pragma_storage->{'footer'};
		delete $pragma_storage->{'rights_block'}->{'rights_block'};
		$pragma_storage->{'footer'} = {};
	}
	$enc_version = $pragma_storage->{version} if(defined $pragma_storage->{version});
}

sub split_skipping_quoted {
	return split(shift, shift);
}

sub merge_keys_file_and_hdl_file_pragmas {
	my $owner = shift;
	my $name = shift;
	my $type = shift;
	#print "merge...(): $owner, $name, $type\n";
	my $keys_file_hash = $keys_file_pragmas{$type};
	$keys_file_hash = $keys_file_pragmas{$type}->{$owner.$name}
		if($type eq 'key_block' || $type eq 'rights_block');
	foreach my $pname (keys %$keys_file_hash) {
		#print "    @ $pname, $keys_file_hash->{$pname}\n";
		$hdl_file_pragmas{$pname} = $keys_file_hash->{$pname}
			unless defined $hdl_file_pragmas{$pname};
	}
}

##-------------------------------------------------------------
## Parsing related functions
##-------------------------------------------------------------
sub generate_key_block {
	my ($keyowner, $keyname, $begin_protected_flag) = @_;
	my ($key_block, $encrypted_data) = ("", "");
	my $public_key = get_public_key_from_repository($keyowner, $keyname);
	my $session_keyx = get_session_key_from_repository($enc_envelope_id);
	if($keyowner eq "Synplicity" and $enc_version == 1 and $ext_enc_version == 1) {
		$encrypted_data .= &CreateKeyBlockSpl($public_key, $session_keyx, $key_version, $license);
	} else {
		$encrypted_data .= &CreateKeyBlock($public_key, $session_keyx, $enc_version);
	}
	$key_block .= get_all_init_block_pragmas() if($begin_protected_flag);
	$key_block .= get_all_key_block_pragmas();
	$key_block .= $encrypted_data;
	return $key_block;
}

sub generate_data_block {
	my ($keyowner, $keyname, $data_block_text) = @_;
	my $session_keyx = get_session_key_from_repository($enc_envelope_id);
	my $init_vectorx = get_init_vector_from_repository($enc_envelope_id);
	my $local_data_method = get_data_method_from_repository($enc_envelope_id);
	my $encrypted_data = &CreateDataBlock($data_block_text, $session_keyx, $init_vectorx, $local_data_method) . "\n";
	my $data_block = get_all_data_block_pragmas();
	$data_block .= $encrypted_data;
	$data_block .= "$pragma_protect end_protected";
	return $data_block;
}

sub generate_rights_block {
	my ($keyowner, $keyname, $rights_block_text) = @_;
    my $local_data_method = get_data_method_from_repository($enc_envelope_id);
	my $local_digest_method = defined $hdl_file_pragmas{digest_method} ? $hdl_file_pragmas{digest_method} : "sha1";
	my $session_keyx = get_session_key_from_repository($enc_envelope_id);
	my $init_vectorx = get_init_vector_from_repository($enc_envelope_id);
    ##my ($ignored_keyx, $init_vectorx) = generate_key_and_iv($local_data_method);
	my $encrypted_digest = &CreateRightsDigest($rights_block_text, $session_keyx, $init_vectorx, $local_data_method, $local_digest_method, $enc_version, $keyowner, $keyname) . "\n";
	my $rights_digest_block = get_all_rights_block_pragmas();
	$rights_digest_block .= $rights_block_text;
	$rights_digest_block .= get_all_rights_digest_block_pragmas();
	$rights_digest_block .= $encrypted_digest;
	##$rights_digest_block .= "$pragma_protect end_protected\n";
	return $rights_digest_block;
}

sub get_all_init_block_pragmas {
	my $string = "";
	$string .= "$pragma_protect begin_protected\n";
	$string .= "$pragma_protect version=$hdl_file_pragmas{version}\n";
	#$string .= get_pragma_line(0, 'author', 'author_info');
	#$string .= get_pragma_line(0, 'encrypt_agent', 'encrypt_agent_info');
	$string .= get_pragma_line(0, 'author');
	$string .= get_pragma_line(0, 'author_info');
	$string .= get_pragma_line(0, 'encrypt_agent');
	$string .= get_pragma_line(0, 'encrypt_agent_info');
	return $string . "\n";
}

sub get_all_key_block_pragmas {
	my $string = "";
	$string .= get_pragma_line(0, 'encoding');
	$string .= get_pragma_line(0, 'key_keyowner', 'key_keyname', 'key_method');
	$string .= "$pragma_protect key_block\n";
	return $string;
}

sub get_all_data_block_pragmas {
	my $string = "";
	
	#$string .= get_pragma_line(0, 'data_keyowner', 'data_keyname', 'data_method');
	$string .= get_pragma_line(0, 'data_keyowner');
	$string .= get_pragma_line(0, 'data_keyname');
	$string .= get_pragma_line(0, 'data_method');
	$string .= get_pragma_line(0, 'encoding');
	$string .= "$pragma_protect data_block\n";
	return $string;
}

sub get_all_rights_block_pragmas {
	my $string = "";
	$string .= get_pragma_line(0, 'encoding');
	$string .= get_pragma_line(0, 'rights_keyowner', 'rights_keyname');
	$string .= "$pragma_protect rights_block\n";
	return $string;
}

sub get_all_rights_digest_block_pragmas {
	my $string = "";
	$string .= get_pragma_line(0, 'encoding');
	$string .= get_pragma_line(0, 'digest_method');
	chomp $string;
	$string .= ", digest_block\n";
	return $string;
}

sub get_pragma_line {
	my $allow_empty = shift;
	my $string = "";
	foreach my $pname (@_) {
		my $pvalue = $hdl_file_pragmas{$pname};
		next if((not $allow_empty) and (!defined $pvalue or $pvalue eq ""));
		if($pvalue =~ /^[\(\"]/) { # quoted
			$string .= " $pname=$pvalue,";
		} else { # not-quoted
			$string .= " $pname=\"$pvalue\",";
		}
	}
	return "" if $string eq "";
	$string = $pragma_protect . $string;
	chop $string;
	return $string . "\n";
}

sub generate_key_and_iv {
	my ($cipher) = @_;
	my ($data_keyx, $data_ivx) = ();
	## Lookup or generate session key
	if(%session_keys_repository == 0) {
		$data_keyx = generate_session_key($cipher);
	} else {
		$data_keyx = $session_keys_repository{$cipher};
	}
	## Lookup or generate iv
	if(%initialization_vectors_repository == 0) {
		$data_ivx = generate_initialization_vector($cipher);
	} else {
		$data_ivx = $initialization_vectors_repository{$cipher};
	}
	return ($data_keyx, $data_ivx);
}

sub generate_initialization_vector {
	my ($cipher) = @_;
    my ($iv, $ivx) = ("", "");
	my ($key_length, $iv_length) = get_cipher_length($cipher);
  	## Generate random initialization vector 
  	$ivlen = ($iv_length + 7) / 8;
  	system "$engine rand -out randkey.bin $ivlen";
  	open(F3,"<randkey.bin") || dying ("ERROR: Cannot open randkey.bin, $!\n");
  	binmode(F3);
  	local($/) = undef;
  	$iv = <F3>;
  	close(F3);
  	$iv = substr $iv, 0, $ivlen;
	## Convert IV Between Text and Hex
  	@asciiiv = unpack("H*", $iv);
  	foreach $char (@asciiiv) {
		$ivx = $ivx.$char;
  	}
	$ivlen = ($iv_length + 3) / 4;
	$ivx = substr $ivx, 0, $ivlen;
	#print "keyx=$data_keyx, iv=$ivx, $klen, $key_length, $iv_length\n";
	return $ivx;
}

sub generate_session_key {
	my ($cipher) = @_;
	my ($data_key, $data_keyx) = ("", "");
	my ($key_length, $iv_length) = get_cipher_length($cipher);
	## Generate random session key
	my $klen = ($key_length + 7) / 8;
	system "$engine rand -out randkey.bin $klen";
	open(F3,"<randkey.bin") || dying ("ERROR: Cannot open randkey.bin, $!\n");
	binmode(F3);
	local($/) = undef;
	$data_key = <F3>;
	close(F3);
	$data_key = substr $data_key, 0, $klen;
	## Convert Key Between Text and Hex
	@asciikey = unpack("H*", $data_key);
	foreach $char (@asciikey) {
		$data_keyx = $data_keyx.$char;
	}
	$klen = 4 * (length $data_keyx);
	return $data_keyx;
}

sub get_cipher_length {
	my $cipher = shift;
	my ($key_length, $iv_length) = (0, 0);
	## Infer key and iv length
	if ($cipher eq "des-cbc") {
	   $key_length = 64;
	   $iv_length = 64;
	} elsif ($cipher eq "3des-cbc") {
	   $key_length = 192;
	   $iv_length = 64;
	} elsif ($cipher eq "aes128-cbc") {
	   $key_length = 128;
	   $iv_length = 128;
	} elsif ($cipher eq "aes256-cbc") {
	   $key_length = 256;
	   $iv_length = 128;
	} else {
	   $key_length = 256;
	   $iv_length = 128;
	}
	return ($key_length, $iv_length);	
}

sub get_cipher_from_key {
	my $keyx = shift;
	my $key_length = 4 * (length $keyx);
	## Infer cipher from key length
	if($key_length == 64) {	return "des-cbc" }
	elsif($key_length == 192) {	return "3des-cbc" }
	elsif($key_length == 128) {	return "aes128-cbc" }
	elsif($key_length == 256) {	return "aes256-cbc" }
	else { return undef }
}

sub get_cipher_from_iv {
	my $ivx = shift;
	my $iv_length = 4 * (length $ivx);
	## Infer cipher from iv length
	if($iv_length == 64) {
		return ("des-cbc", "3des-cbc");
	} elsif($iv_length == 128) {
		return ("aes128-cbc", "aes256-cbc");
	} else {
		return (undef, undef);
	}
}

#############################################################
## Encryption functions
#############################################################

##===========================================================
## Create Synplify Special Key block
##===========================================================
sub CreateKeyBlockSpl {
    my $pubkey = shift;
	my $keyx = shift;
	my $key_version = shift;
	my $license = shift;
    my $keyblock;
    my $keyblock64;
    
	iprint ("\nGenerating Synplicity encryption version $enc_version key-block\n");
	iprint ("Info: key_keyowner=$hdl_file_pragmas{key_keyowner}, key_keyname=$hdl_file_pragmas{key_keyname}, key_method=$hdl_file_pragmas{key_method}\n");
    iprint ("Session Keyx=$keyx\n") if(defined $opt_sk || defined $opt_debug || defined $opt_verbose);
    # write public key to a temporary file
    open(F1,">pubkey.pem") || dying ("ERROR: Cannot create pubkey.pem, $!\n");    
    print F1 "-----BEGIN PUBLIC KEY-----\n";
    print F1 $pubkey;
    print F1 "-----END PUBLIC KEY-----\n";
    close(F1);
	iprint ("Public key:\n$pubkey\n") if defined $opt_debug || defined $opt_verbose;

    # create temporary file that contains the key block to be asymmetrically encrypted
    open(F2,">keyblock.txt") || dying ("ERROR: Cannot create keyblock.txt, $!\n");
    if (defined $output_method && $output_method ne "") {
      print F2 "output_method=$output_method\n";
    }
    if (defined $tier && $tier ne "" && $tier ne "all") {
      print F2 "tier=$tier\n";
    }
	if($enc_version > 1.0) {
		if (defined $log_messages && $log_messages ne "") {
		  print F2 "log_messages=$log_messages\n";
		}
		if (defined $allowed_vendor && $allowed_vendor ne "") {
		  print F2 "allowed_vendor=$allowed_vendor\n";
		}
		if (defined $allowed_technology && $allowed_technology ne "") {
		  print F2 "allowed_technology=$allowed_technology\n";
		}
		if (defined $allowed_view && $allowed_view ne "") {
		  print F2 "allowed_view=$allowed_view\n";
		}
	}
	if ($key_version >= 3.0) {
      print F2 "keyver=$key_version\n";
	  if ($license ne "") {
        print F2 "lic=$license\n";
	  }
	  print F2 "session_keyx=$keyx\n";
    }
    close(F2);
    if(defined $opt_debug) {
		iprint ("---Key block---\n");
		if(open(KEY, "keyblock.txt")) {
			my @keyblock = <KEY>;
			iprint ("@keyblock\n");
			close KEY;
		}
		#system "cat keyblock.txt";
		iprint ("---End key block---\n\n");
    }
    # asymmetrically encrypt with RSA algorithm
    iprint ("Info: using $engine for RSA 2048 bit encryption\n");
    my $error_code = system "$engine rsautl -encrypt -pubin -inkey pubkey.pem -in keyblock.txt -out keyblock.bin &> __encrypt.log";
	if($error_code) {
		my $message = `cat __encrypt.log`; chomp $message;
    	dying ("ERROR: $message. Check your public key for possible problems\n");
	}
    # save encrypted key block in temporary file
    open(F3,"<keyblock.bin") || dying ("ERROR: Cannot open keyblock.bin, $!\n");
    binmode(F3);
    local($/) = undef;
    $keyblock = <F3>;
    close(F3);
    
	# update encoding-type info in %hdl_file_pragmas
	my $bytes = length $keyblock;
	$hdl_file_pragmas{encoding} = "(enctype=\"base64\", line_length=76, bytes=$bytes)";
	
    # base-64 encode key block and return
    $keyblock64  = encode_base64($keyblock);
    return $keyblock64;
}

##===========================================================
## Create Generic Key block
##===========================================================
sub CreateKeyBlock {
    my $pubkey = shift;
	my $keyx = shift;
	my $enc_version = shift;
    my $keyblock;
    my $keyblock64;
    
	iprint ("\nGenerating encryption version $enc_version key-block\n");
	iprint ("Info: key_keyowner=$hdl_file_pragmas{key_keyowner}, key_keyname=$hdl_file_pragmas{key_keyname}, key_method=$hdl_file_pragmas{key_method}\n");
    iprint ("Session Keyx=$keyx\n") if(defined $opt_sk || defined $opt_debug || defined $opt_verbose);
    
    # write public key to a temporary file
    open(F1,">pubkey.pem") || dying ("ERROR: Cannot create pubkey.pem, $!\n");
    print F1 "-----BEGIN PUBLIC KEY-----\n";
    print F1 $pubkey;
    print F1 "-----END PUBLIC KEY-----\n";
    close(F1);
	iprint ("Public key:\n$pubkey\n") if defined $opt_debug || defined $opt_verbose;

    # create temporary file that contains the key block to be asymmetrically encrypted
    open(F2,">keyblock.txt") || dying ("ERROR: Cannot create keyblock.txt, $!\n");
    binmode(F2);
	if ($enc_version > 1) {
        $keyx = '0x' . $keyx unless $keyx =~ /^0x/;
		my $bigint = Math::BigInt->new($keyx);
		$bigint = $bigint + $enc_version - 1;
		my $new_keyx = substr($bigint->as_hex(), 2);
		#print "Salted  Keyx=$new_keyx\n" if(defined $opt_sk);
		my $new_key = pack("H*", $new_keyx); ## convert hex2bin
        #print "Packed  Key =$new_key\n" if(defined $opt_sk);
		print F2 $new_key;
		iprint ("Session key(binary)=$new_key\n") if defined $opt_debug;
    } else {
    	my $key = pack("H*", $keyx); ## convert hex2bin
		print F2 $key;
		iprint ("Session key(binary)=$key\n") if defined $opt_debug;
	}
    close(F2);
    if(defined $opt_debug) {
		iprint ("---Key block---\n");
		if(open(KEY, "keyblock.txt")) {
			my @keyblock = <KEY>;
			iprint ("@keyblock\n");
			close KEY;
		}
		#system "cat keyblock.txt";
		iprint ("---End key block---\n\n");
    }

    # asymmetrically encrypt with RSA algorithm
    iprint ("Info: using $engine for RSA 2048 bit encryption\n");
    my $error_code = system "$engine rsautl -encrypt -pubin -inkey pubkey.pem -in keyblock.txt -out keyblock.bin &> __encrypt.log";
	if($error_code) {
		my $message = `cat __encrypt.log`; chomp $message;
    	dying ("ERROR: $message. Check your public key for possible problems\n");
	}

    # save encrypted key block in temporary file
    open(F3,"<keyblock.bin") || dying ("ERROR: Cannot open keyblock.bin, $!\n");
    binmode(F3);
    local($/) = undef;
    $keyblock = <F3>;
    close(F3);
    
	# update encoding-type info in %hdl_file_pragmas
	my $bytes = length $keyblock;
	$hdl_file_pragmas{encoding} = "(enctype=\"base64\", line_length=76, bytes=$bytes)";
	    
    # base-64 encode key block and return
    $keyblock64  = encode_base64($keyblock);
    return $keyblock64;
}

##===========================================================
## Create Data Block
##===========================================================
sub CreateDataBlock {
    my $data_text = shift;
    my $key = shift;
	my $iv = shift;
    my $data_method = shift;
    my $datablock;
    my $datablock64;

	iprint ("\nGenerating $data_method encrypted data-block\n");
	iprint ("Info: data_keyowner=$hdl_file_pragmas{data_keyowner}, data_keyname=$hdl_file_pragmas{data_keyname}, data_method=$hdl_file_pragmas{data_method}\n");
    iprint ("Session Keyx=$key\n") if(defined $opt_sk || defined $opt_debug || defined $opt_verbose);
    iprint ("Session IVx=$iv\n") if(defined $opt_sk || defined $opt_debug || defined $opt_verbose);
	##print "Keyx=$key, IVx=$iv\n";
    # write public key to a temporary file
    open(F1,">datablock.txt") || dying ("ERROR: Cannot create datablock.txt, $!\n");
    #print F1 $iv, "\n";
    print F1 $data_text;
    close(F1);
	#print "data-length is: " . length $data_text . "\n";
	
    # DES encryption
    my $error_code = 0;
    if($data_method eq "des-cbc") {
    	verify_session_key_and_iv_length($key, 64, $iv, 64);
        iprint ("Info: using $engine for DES-CBC encryption\n");
        $error_code = system "$engine des-cbc -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
    # 3DES encryption
    elsif($data_method eq "3des-cbc") {
    	verify_session_key_and_iv_length($key, 192, $iv, 64);
        iprint ("Info: using $engine for 3DES-CBC encryption\n");
        $error_code = system "$engine des3 -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
    # AES128 encryption
    elsif($data_method eq "aes128-cbc") {
    	verify_session_key_and_iv_length($key, 128, $iv, 128);
        iprint ("Info: using $engine for AES128-CBC encryption\n");
        $error_code = system "$engine aes-128-cbc -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
    # AES256 encryption
    elsif($data_method eq "aes256-cbc") {
    	verify_session_key_and_iv_length($key, 256, $iv, 128);
        iprint ("Info: using $engine for AES256-CBC encryption\n");
        $error_code = system "$engine aes-256-cbc -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
	# Invalid encryption cipher
	else {
        dying ("ERROR: Invalid data_method (cipher) found '$data_method'\n");
	}
	if($error_code) {
		my $message = `cat __encrypt.log`; chomp $message;
    	dying ("ERROR: $message. Check your public key for possible problems\n");
	}

    # save encrypted data block in temporary file
    open(F4,"<datablock.bin") || dying ("ERROR: Cannot open datablock.bin, $!\n");
    binmode(F4);
    local($/) = undef;
    $datablock = <F4>;
    close(F4);

	# add iv as the first line of datablock
	my $biniv = pack("H*", $iv);
	$datablock = $biniv . $datablock;
	
	# update encoding-type info in %hdl_file_pragmas
	my $bytes = length $datablock;
	$hdl_file_pragmas{encoding} = "(enctype=\"base64\", line_length=76, bytes=$bytes)";
	
    # base-64 encode data block and return
    $datablock64  = encode_base64($datablock);
    return $datablock64;
}

##===========================================================
## Create Rights Digest Block
##===========================================================
sub CreateRightsDigest {
    my $data_text = shift;
    my $key = shift;
	my $iv = shift;
    my $data_method = shift;
    my $digest_method = shift;
	my $enc_version = shift;
	my $key_owner = shift;
	my $key_name = shift;
    my $datablock;
    my $datablock64;

	iprint ("\nGenerating $data_method encrypted rights-block-digest for $key_owner($key_name)\n");
	iprint ("Info: key_keyowner=$hdl_file_pragmas{key_keyowner}, key_keyname=$hdl_file_pragmas{key_keyname}, digest_method=$digest_method\n");
	if ($enc_version > 1) {
		$keyx = '0x' . $keyx unless $keyx =~ /^0x/;
		my $bigint = Math::BigInt->new($keyx);
		$bigint = $bigint + $enc_version - 1;
		$keyx = substr($bigint->as_hex(), 2);
	}
	##print "Key=$key, IV=$iv\n";
	iprint ("Info: data_method=$data_method, digest_method=$digest_method, version=$enc_version\n");
	my $major_version = $enc_version;
	if($enc_version =~ /^(\d+)\.(.*)/) {
		$major_version = $1/1; ## Divide by 1 to remove any leading 0s
	}
	$data_text = cleanup_text($data_text);
    # write public key to a temporary file
    open(F1,">datablock.txt") || dying ("ERROR: Cannot create datablock.txt, $!\n");
    binmode(F1);
    print F1 $major_version . "\n" . $key_owner . "\n" . $key_name . "\n" . $data_text;
    close(F1);
	##print "data-length is:= ", length $data_text, "\n";
	##print $major_version . $key_owner . $key_name . $data_text;
	##print "============\n";
    # DES encryption
    my $error_code = 0;
    if($data_method eq "des-cbc") {
    	verify_session_key_and_iv_length($key, 64, $iv, 64);
        iprint ("Info: using $engine for DES-CBC encryption\n");
        $error_code = system "$engine des-cbc -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
    # 3DES encryption
    elsif($data_method eq "3des-cbc") {
    	verify_session_key_and_iv_length($key, 192, $iv, 64);
        iprint ("Info: using $engine for 3DES-CBC encryption\n");
        $error_code = system "$engine des3 -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
    # AES128 encryption
    elsif($data_method eq "aes128-cbc") {
    	verify_session_key_and_iv_length($key, 128, $iv, 128);
        iprint ("Info: using $engine for AES128-CBC encryption\n");
        $error_code = system "$engine aes-128-cbc -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
    # AES256 encryption
    elsif($data_method eq "aes256-cbc") {
    	verify_session_key_and_iv_length($key, 256, $iv, 128);
        iprint ("Info: using $engine for AES256-CBC encryption\n");
        $error_code = system "$engine aes-256-cbc -nosalt -e -in datablock.txt -out datablock.bin -iv $iv -K $key $verbose &> __encrypt.log";
    }
	# Invalid encryption cipher
	else {
        dying ("ERROR: Invalid data_method (cipher) found '$data_method'\n");
	}
	if($error_code) {
		my $message = `cat __encrypt.log`; chomp $message;
    	dying ("ERROR: $message. Check your public key for possible problems\n");
	}
	
	# open file for printing
    open(F4,"<datablock.bin") || dying ("ERROR: Cannot open datablock.bin, $!\n");
    binmode(F4);
    local($/) = undef;
    $datablock = <F4>;
    close(F4);
    # compute digest
    iprint ("Info: using $engine for $digest_method digest computation\n");
    system "cat datablock.bin | $engine $digest_method > datablock.sha";

    # save encrypted data block in temporary file
    open(F4,"<datablock.sha") || dying ("ERROR: Cannot open datablock.sha, $!\n");
    binmode(F4);
    local($/) = undef;
    $datablock = <F4>;
    close(F4);
    chop $datablock; # Remove newline char at the end

	# add iv as the first line of datablock
 	my $biniv = pack("H*", $iv);
	my $binblk = pack("H*", $datablock);
	$datablock = $biniv . $binblk;
    
	# update encoding-type info in %hdl_file_pragmas
	my $bytes = length $datablock;
	$hdl_file_pragmas{encoding} = "(enctype=\"base64\", line_length=76, bytes=$bytes)";
	
    # base-64 encode data block and return
    $datablock64  = encode_base64($datablock);
    return $datablock64;
}

sub cleanup_text {
	my $text = shift;
    ## Change from dos2unix
    $text =~ s/\r\n/\n/mg;
	## Remove all empty lines
    $text =~ s/^\s*$//mg;
    ## Remove spaces at the start of each line
    $text =~ s/^\s+//mg;
	## Remove spaces at the end of each line
    $text =~ s/\s+\n/\n/mg;
	return $text;
}

sub verify_session_key_and_iv_length {
	my ($keyx, $keylen, $ivx, $ivlen) = @_;
	my ($ikeylen, $iivlen) = (length($keyx)*4, length($ivx)*4);
	dying ("ERROR: Actual key length ($ikeylen) not as expected ($keylen)\n") if($ikeylen != $keylen);
	dying ("ERROR: Actual key length ($iivlen) not as expected ($ivlen)\n") if($iivlen != $ivlen);
}

sub iprint {
	my $message = shift;
	my $goto_log_and_stdout = shift;
	print LOG "$message" if defined $opt_log;
	if(!defined $opt_quiet) {
		print STDOUT "$message" if defined $goto_log_and_stdout || !defined $opt_log;
	}
}

sub dying {
	my $message = shift; chomp $message;
	iprint("\n$message. Unable to generate output file $ofile\n\n", 1);
	iprint("ERROR: Interrupted '$opt_list' file processing. Rerun encryption script on this list after fixing above error(s)\n\n", 1)
		if defined $opt_list;
	unlink($ofile) if -f $ofile;
    # exiting, delete temporary files, unless in debug mode 2 or higher
    unless(defined $opt_debug && $opt_debug > 1) {
        unlink("__encrypt.log") if -f "__encrypt.log";
        unlink("pubkey.pem") if -f "pubkey.pem";
		unlink("randkey.bin") if -f "randkey.bin";
        unlink("keyblock.txt") if -f "keyblock.txt";
        unlink("keyblock.bin") if -f "keyblock.bin";
        unlink("datablock.txt") if -f "datablock.txt";
        unlink("datablock.bin") if -f "datablock.bin";
        unlink("datablock.sha") if -f "datablock.sha";
    }
	exit(1);
}
