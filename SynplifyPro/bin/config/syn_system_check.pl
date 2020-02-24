# Main syn_system_check.pl file should be run with mwperl
# which is available at following localtion
# $Header: //synplicity/ui2019q3p1/unix_scripts/bin/config/syn_system_check.pl#1 $

BEGIN { push(@INC, "$ENV{PWD}"); }
use syn_unix_lib;

$tmp_min_size = 300 ;
$vartmp_min_size = 150 ;
$homedir_min_size = 3000 ;
$result = { "os" => undef };
$explanation = { };

$info = syn_unix_lib->new();

$info->checkPlatformVersion(\%result);

$info->checkDirSpaces($tmp_min_size, $vartmp_min_size, $homedir_min_size, \%result);

$info->checkOsPatches(\%result, \%explanation);

$info->checkLibVersions(\%result);

$info->displayCheck(\%result, \%explanation);

#$info->checkLocale(\%result);

$info->printSummary(\%result, \%explanation);

