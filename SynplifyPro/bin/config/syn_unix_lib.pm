package syn_unix_lib;

# PlatformLib perl module file
# $Header: //synplicity/ui2019q3p1/unix_scripts/bin/config/syn_unix_lib.pm#1 $

sub new {  # constructor
    my $class = shift;
    my $info_ptr = { "hostname"    => undef,
                     "os"          => undef,
                     "os_version"  => undef
                   };
    bless ($info_ptr, $class);
    return $info_ptr;
}

sub checkPlatformVersion {
    my $self = shift;
    my $result = shift;
    $uname = `uname -a`;
    @uname_array = split(' ', $uname);
    $self->{hostname} = $uname_array[1];
    $self->{os_version} = $uname_array[2] ;
    if ( $uname_array[0] eq "Linux" ) {
        $self->{os} = "linux" ;
        $self->{os_version} = $uname_array[2] ;
        $self->{os_arch} = $uname_array[11] ;
        $self->{hardware} = $uname_array[12] ;
        chomp($self->{linux_gui} = `/bin/cat /etc/redhat-release`) ;

	#minimum kernel version is 2.4.18
        if ( $self->{os_version} =~ /^2\.4\.([0-9]+)/ ) {
          my $kernel_subversion = $1;
          $message = "$self->{hostname} " . "$self->{os} " . "$self->{os_version}";
          if ($kernel_subversion>=18) {
            $result{$message} = "OK";
	      }
          else {
            $result{$message} = "Not supported";
          }
          getSubPackages($result, "kernel");
        }

        #always support 2.6.x kernels
        elsif ( $self->{os_version} =~ /^2\.6\.([0-9]+)/ ) {
          $result{$message} = "OK";
          getSubPackages($result, "kernel");
        }
        else {
            $message = "$self->{hostname} " . "$self->{os} " . "$self->{os_version}";
            $result{$message} = "Not supported";
        }
        if ( $self->{linux_gui} =~ /^Red Hat Linux release (7.1|7.2|7.3|8.0).*/ ) {
            $result{$self->{linux_gui}} = "OK";
        }
        elsif ( $self->{linux_gui} =~ /^Red Hat Enterprise Linux (AS|ES|WS) release [3-4].*/ ) {
            $result{$self->{linux_gui}} = "OK";
        }
        else {
            $result{$self->{linux_gui}} = "Not Supported";
        }
    }
    else {
        $self->{os} = "Not Supported" ;
        $self->{os_version} = "Unknown" ;
        $self->{os_arch} = "Unknown" ;
        $self->{hardware} = "Unknown" ;
        $self->{linux_gui} = "Unknown" ;

        $message = "$self->{hostname} " . "$self->{os} " . "$self->{os_version}";
        $result{$message}         = "Not Supported";
        $result{$self->{os_arch}} = "Not Supported";
        $result{$self->{hardware}} = "Not Supported";
    }
}

sub checkDirSpaces {
    my $self = shift;
    my $tmp_min_size = shift ;
    my $vartmp_min_size = shift ;
    my $homedir_min_size = shift ;
    my $result = shift;

    @dirinfo = `/bin/df -k /tmp`;
    if ($self->{os} eq "linux" ) {
        ($name, $actual_size, $used_size, $available_size) = split(' ', $dirinfo[1]);
    }
    $self->{tmp_actual_size} = $actual_size;
    $self->{tmp_used_size}   = $used_size;
    $self->{tmp_avail_size}  = $available_size;
    $message = "/tmp " . "available size == " . "$self->{tmp_avail_size}" . " KB";
    if ( $self->{tmp_avail_size} >= $tmp_min_size ) {
        $result{$message} = "OK";
    }
    else {
        $result{$message} = "$tmp_min_size KB needed";
    }

    @dirinfo = `/bin/df -k /var/tmp`;
    if ($self->{os} eq "linux" ) {
        ($name, $actual_size, $used_size, $available_size) = split(' ', $dirinfo[1]);
    }
    $self->{vartmp_actual_size} = $actual_size;
    $self->{vartmp_used_size}   = $used_size;
    $self->{vartmp_avail_size}  = $available_size;
    $message = "/var/tmp " . "available size == " . "$self->{vartmp_avail_size}" . " KB";
    if ( $self->{vartmp_avail_size} >= $vartmp_min_size ) {
        $result{$message} = "OK";
    }
    else {
        $result{$message} = "$vartmp_min_size KB needed";
    }

    @dirinfo = `/bin/df -k $ENV{HOME}`;
    if ($self->{os} eq "linux" ) {
        ($name, $actual_size, $used_size, $available_size) = split(' ', $dirinfo[1]);
        if ( $#dirinfo eq 2) {
            ($actual_size, $used_size, $available_size) = split(' ', $dirinfo[2]);
        }
    }

    $self->{homedir_actual_size} = $actual_size;
    $self->{homedir_used_size}   = $used_size;
    $self->{homedir_avail_size}  = $available_size;
    $message = "$ENV{HOME} " . "available size == " . "$self->{homedir_avail_size}" . " KB";
    if ( $self->{homedir_avail_size} >= $homedir_min_size ) {
        $result{$message} = "OK";
    }
    else {
        $result{$message} = "$homedir_min_size KB needed";
    }
}

sub checkLocale {
    my $self = shift;
    my $result = shift;

    if ( $self->{os} eq "linux" ) {
        %localeinfo = `/usr/bin/locale`;
    }
}

sub checkOsPatches {
    my $self = shift;
    my $result = shift;
    my $explanation = shift;

    $rpinfo = {};
    $rpinfo_ptr = \%rpinfo;
    getRequiredPatchInfo($self, \%rpinfo);

    if ( $self->{os} eq "linux" ) {
        $explanation{"Patch checking for $self->{os}"} = "\t\t\t\tSee Above";
    }

    if ( $self->{os} eq "hp11" || $self->{os} eq "hp"  ) {
        chomp (@patchinfo = `/usr/sbin/swlist 2>/dev/null`);
        for ($i = 0 ; $i <= $#patchinfo; $i++ ) {
            if ( $patchinfo[$i] =~ /^\s*([A-Z_-a-z.0-9]+)\s+([A-Z.a-z0-9]+)\s+(.*)/ ) {
                $p = $1;
                $v = $2;
                if ( ! defined ($patch{$p}) ) {
                    $patch{$p} = $v ; 
                }
            }
        }

        foreach $req_p  ( keys(%rpinfo) ) {
            if ( defined ($patch{$req_p}) ) {
                $revision = $patch{$req_p};
                $explanation{"$req_p"} = $rpinfo_ptr->{$req_p}->{info};
                @rev_array = split ('\.', $revision);
                $inst_rev = join ('.', $rev_array[3], $rev_array[4]) ;
                $hp_rev_req = $rpinfo_ptr->{$req_p}->{hp_rev};
                if ($inst_rev < $rpinfo_ptr->{$req_p}->{rev}) {
                    $message = "Upgrade from " . "'$req_p' " . "$patch{$req_p} " . "to " . "$hp_rev_req " ;
                    $result{$message} = "Upgrade Patch";
                } 
                elsif ($inst_rev > $rpinfo_ptr->{$req_p}->{rev}) {
                    $message = "Required " . "'$req_p' " . "$hp_rev_req " . "  have  " . "$patch{$req_p} " ;
                    $result{$message} = "OK";
                }
                elsif ($inst_rev == $rpinfo_ptr->{$req_p}->{rev}) {
                    $message = "Required Patch " . "'$req_p'" . " $patch{$req_p} " . " installed";
                    $result{$message} = "OK";
                }
            }
            else {
                $revision = $rpinfo_ptr->{$req_p}->{rev};
                $explanation{"$req_p"} = $rpinfo_ptr->{$req_p}->{info};
                $message = "Required Patch " . "'$req_p'" . "  version  " . "$revision " ;
                $result{$message} = "Install Patch";
            }
        }
    }
}

sub getRequiredPatchInfo {
    my $self = shift;
    my $rpinfo = shift;

    $filename = "syn_system_requirement";
    open (RFH,  "< $filename") || 
        die "\nError: Can't open $filename file \n$!";
    while ( <RFH> ) {
        chomp($_);
        next; 
    }
    close(RFH);
}

sub checkLibVersions {
  my ($result)=@_;
  $uname = `uname -a`;
  @uname_array = split(' ', $uname);
  if ( $uname_array[0] eq "Linux" ) {
    my $linux_release=`cat /etc/redhat-release`;
    my %versions;
    if ( $linux_release =~ /7\.3/ ) {
      $versions{"XFree86"}=[qw(4 2 0 8)];
      $versions{"glibc"}=[qw(2 2 5 34)];
      $versions{"gdb"}=[qw(6 1)];
    }
    elsif ( $linux_release =~ /8\.0/ ) {
      $versions{"XFree86"}=[qw(4 2 0 72)];
      $versions{"glibc"}=[qw(2 2 93 5)];
      $versions{"libgcc"}=[qw(3 2 7)];
      $versions{"libstdc++"}=[qw(3 2 7)];
      $versions{"gdb"}=[qw(6 1)];
    }
    elsif ($linux_release =~ /release 3/ ) {
      $versions{"XFree86"}=[qw(4 3 0 35EL)];
      $versions{"glibc"}=[qw(2 3 2 95 3)];
      $versions{"libgcc"}=[qw(3 2 3 20)];
      $versions{"libstdc++"}=[qw(3 2 3 20)];
      $versions{"gdb"}=[qw(6 1)];
    }

    #check all our minimum versions against installed versions
    for my $k (keys %versions) {
        getSubPackages($result, $k);
        versionCheck($result, $k, $versions{$k});
    }
    verifyDependencies($result, \%versions);
  }
}

sub getSubPackages {
    my ($result, $name)=@_;
    my $output=`rpm -q -a | sort | uniq | grep $name`;
    my @outarray=split /\n/, $output;
    for my $k (@outarray) {
        $result{$k}="--";
    }
}

sub verifyDependencies {
    my ($result, $rversions)=@_;
    my %versions=%$rversions;
    my @libpaths=(
        "/lib/i686/libc.so.6", 
        "/lib/i686/libm.so.6",
        "/lib/i686/libpthread.so.0",
        "/lib/libdl.so.2",
        "/lib/libnsl.so.1",
        "/lib/libutil.so.1",
        "/usr/X11R6/lib/libX11.so.6",
        "/usr/X11R6/lib/libXext.so.6",
    );

    #if we're looking at a version of linux that requires 
    #libgcc and libstdc++, add them to the array as well.
    if (exists $versions{"libgcc"}) {
        push @libpaths, ("/lib/libgcc_s.so.1");
    }        
    if (exists $versions{"libstdc++"}) {
        push @libpaths, ("/usr/lib/libstdc++.so.5");
    }

    my $returnstr;
    my $failures;
    for my $k (@libpaths) {

        #traverse any symbolic links
        while (-l $k) {
            $k=~/(.*)\//;
            my $dir=$1;
            $k=readlink($k);
            $k=~/(^\/)/;               
            if ($1 ne "/") {
                $k=$dir."/".$k;
            }
        }
        if (stat $k) {
            $returnstr=`rpm -Vf $k | grep $k`;
            if ($returnstr) {
                $returnstr=~ /(.{8})/;
                $failures=$1;
                $result{"Verify $k"}="Failures: $failures";
            }
            else {
                $result{"Verify $k"}="OK";
            }
        }
        else {
            $result{"Verify $k"}="Does not exist";
        }
    }
}

sub versionCheck {
    my ($result, $pkgName, $rversion) = @_;
    my @version=@$rversion;
    my $reportedversion=`rpm -q $pkgName | uniq`;
    chomp($reportedversion);
    my @reportedarray=split /[-.]/, $reportedversion;
    my $comparesize;

    #if there's only one element the package isn't installed
    #print an error to this effect
    if (@reportedarray==1) {
        $result{$pkgName}="Not Installed";
        return;
    }

    #else we need to grab the version info and compare it
    #against @version

    #first element is the package name and can be removed
    shift @reportedarray;
        
    #compare goes through as many elements as are in the 
    #smaller array
    if (@reportedarray>@version) {
        $comparesize=@version;
    }
    else {
        $comparesize=@reportedarray;
    }

    #compare arrays until we find elements that are unequal;
    #if all elements are equal and the arrays are different 
    #sizes, the larger array is the later version
    #if all elements are equal and the arrays are the same 
    #size, the arrays represent the same version; we return 
    #an "OK" result in this case.
    for ($i=0; $i<$comparesize; $i++) {
        if ($reportedarray[$i] > $version[$i]) {
            $result{$reportedversion}="OK";
            return;
        }
        if ($reportedarray[$i] < $version[$i]) {
            $result{$reportedversion}="Upgrade";
            return;
        } 
    }            
    if (@reportedarray >= @version) {
        $result{$reportedversion}="OK";
        return;
    }
    $result{$reportedversion}="Upgrade";
}

sub displayCheck {
    my $self = shift;
    my $result = shift;
    my $explanation = shift;

    $display = $ENV{DISPLAY};
    ($dhost, $dwindow) = split (':', $display);
    if ( $dhost eq "" ) {
     #   donothing because of default display is ok.
    }
    elsif ( ! defined ($display)  ) {
        $result{"DISPLAY not set, assuming it will be set to '$self->{hostname}' "} = " ??? ";
    }
    elsif ( $dhost ne $self->{hostname} ) {
        $result{"Current DISPLAY is set to '$display'"} = "Check $dhost";
    }
}

sub printSummary {
    my $self = shift;
    my $result = shift;
    my $explanation = shift;
    $count = 1;
    print "\n", "+-" x 40, "\n\n";
    printf "\tSynplicity system check summary report for host '$self->{hostname}'\n\n";

    foreach $key ( sort  ( keys (%result) )  ) {
        printf ("  %2d.  %-56s[ %s ]\n",$count++, $key, $result{$key}) ;
    }
    print "\n", "+-" x 40, "\n\n";

    printf "  Explanation of Operating system patches, following patches are \n";
    printf "  available at vendor's ftp site  \n\n";
    foreach $key ( sort  ( keys (%explanation) )  ) {
        printf ("  [ %s ]  %s\n", $key, $explanation{$key}) ;
    }
    print "\n", "+-" x 40, "\n\n";
#
#    print "  $count.\tdate check \t\t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tuptime check \t\t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tulimit -a check \t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tenv output check \t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tipcs check \t\t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tvideo card check  \t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\t$ENV{HOME}/.synplicity check \t\t [ under construction ]\n"; $count++;
#    print "  $count.\tswap space check \t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tphysical memory check \t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tsysdef -i check \t\t\t\t [ under construction ]\n"; $count++;
#    print "  $count.\tdmesg check \t\t\t\t\t [ under construction ]\n"; $count++;
#
}

1; # return of 1 required by perl for package files

