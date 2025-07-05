#! /usr/bin/perl

my $perl_bin_path_latest = $ARGV[0];

my $os = $^O;

print "Perl binary path configuration. (Running in $os)\n\n";

my @cgi_dir_list = ("../public_html/cgi-bin/webman");
my @cgi_script_list = ();

### 31/12/2016
my %dict_dir = ("../public_html/cgi-bin/webman" => 1);
my %dict_script = ();

my $content_dir_org = undef;
my $current_perl_bin_path = undef;

if (open(MYFILE, "<./conf/dir_org.conf")) {
    my @lines = <MYFILE>;
    
    foreach my $line (@lines) {
        if ($line =~ /^perl_bin/) {
            while ($line =~ / /) {
                $line =~ s/ //g;
            }
            
            my @parts = split(/=/, $line );
            
            $current_perl_bin_path = $parts[1];
            $current_perl_bin_path =~ s/\n//;
            
            $line = "perl_bin = __path_perl_bin__\n";
        }

        $content_dir_org .= $line;
    }
    
    close(MYFILE);
}

###############################################################################

if (!defined($perl_bin_path_latest)) {
    print "Current default Perl binary path: $current_perl_bin_path\n\n";
    $perl_bin_path_latest = $current_perl_bin_path;

    if (&get_YN_Options("Update Perl binary path to be applied?")) {
        print "\nNew Perl binary path or just press enter to use the current default: ";
        $perl_bin_path_latest = <STDIN>;
    }
}


###############################################################################

$perl_bin_path_latest =~ s/\n//;
$perl_bin_path_latest =~ s/\r//;

if ($perl_bin_path_latest eq "") {
    $perl_bin_path_latest = $current_perl_bin_path;
}

$content_dir_org =~ s/__path_perl_bin__/$perl_bin_path_latest/;

print "\nModify 'dir_org.conf' configuration file...\n\n";

if (open(MYFILE, ">./conf/dir_org.conf")) {
    print MYFILE $content_dir_org;
    close(MYFILE);
}

### 31/12/2016
### Get all subtree of CGI directories and scripts list 
### (recursive call of "read_Directory" function)
foreach $dir (@cgi_dir_list) {
    &read_Directory($dir);
}

print "Modify CGI scripts header with current Perl binary path...\n";

foreach my $script (@cgi_script_list) {
    print "$script\n";
    &modify_Script_Header("$script", "#! $perl_bin_path_latest\n");
}

print "\n";

print "Modify helper scripts header with current Perl binary path...\n";
opendir(DIRHANDLE, "./");
my @ref_points = readdir(DIRHANDLE);

foreach my $pointer (@ref_points) {
if (-f "./$pointer" && $pointer =~ /\.pl$/) {
    print "./$pointer\n";
    &modify_Script_Header("./$pointer", "#! $perl_bin_path_latest\n");
}
}

print "\n";

###############################################################################

### The next below is particularly for Linux/Unix based system
if ($os eq "linux") {
    print "Make all CGI scripts executable...\n";

    foreach my $script (@cgi_script_list) {
        print "chmod a+x $script \n";
        `chmod a+x $script`;
    }    
    
    print "\n";
    
    print "Make all helper scripts executable...\n";
    opendir(DIRHANDLE, "./");
    my @ref_points = readdir(DIRHANDLE);

    foreach my $pointer (@ref_points) {
        if (-f "./$pointer" && $pointer =~ /\.pl$/) {
            print "chmod u+x ./$pointer\n";
            `chmod u+x ./$pointer`;
        }
    }
}

###############################################################################

sub get_YN_Options {
    my $instruct_str = shift @_;
    my $opt = undef;
    
    while ($opt ne "y" and $opt ne "n") {
        print "$instruct_str [y/n]: ";
        
        $opt = <STDIN>;
        $opt =~ s/\n//;
        $opt =~ s/\r//;
    }
    
    if ($opt eq "y") {
        return 1;
        
    } else {
        return 0;
    }
}

sub read_Directory {
    my $base_dir = shift @_;
    
    opendir(DIRHANDLE, $base_dir);

    my @ref_points = readdir(DIRHANDLE);
    
    #print "$base_dir\n";

    foreach my $pointer (@ref_points) {
        #print "$pointer\n";
        
        if (-f "$base_dir/$pointer" && $pointer =~ /\.cgi$/ && !$dict_script{"$base_dir/$pointer"}) {
            #print "$base_dir/$pointer\n";
            push(@cgi_script_list, "$base_dir/$pointer");
            $dict_script{"$base_dir/$pointer"} = 1;
            
        } elsif (-d  "$base_dir/$pointer") {
            if (!($pointer =~ /\./) && !($pointer =~ /\.\./) && !$dict_dir{"$base_dir/$pointer"}) {
                push(@cgi_dir_list, "$base_dir/$pointer");
                #print "$base_dir/$pointer\n";
                $dict_dir{"$base_dir/$pointer"} = 1;
                
                ### 31/12/2016
                &read_Directory("$base_dir/$pointer");
            }        
        }
    }
}

sub modify_Script_Header {
    my $script_name = shift @_;
    my $header_str = shift @_;
    
    my $content = undef;
    
    if (open(MYFILE, "<$script_name")) {
        my $index = 0;
        my @lines = <MYFILE>;
        
        foreach my $line (@lines) {            
            if ($index == 0) {
                $content .= $header_str;
                
            } else {
                $content .= $line;
            }
            
            $index++;
        }
        
        close(MYFILE);
    }
    
    if (open(MYFILE, ">$script_name")) {
        print MYFILE $content;        
        close(MYFILE);
    }       
}
