#! /usr/bin/perl

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

require Webman_Config_Tools;

my $os = $^O;
my $opr_result = undef;
my $wmct = new Webman_Config_Tools;

my $perl_bin_path = $ARGV[0];
my $db_user_name = $ARGV[1];
my $db_password = $ARGV[2];
my $db_name = $ARGV[3];

print "+----------------------------------------+\n";
print "|Webman-framework quick configurations.  |\n";
print "+----------------------------------------+\n\n";

print "Running in $os OS\n\n";

print "Perl binary path: ";
if ($perl_bin_path eq "") { $perl_bin_path = <STDIN>; } else { print "$perl_bin_path\n"; }
$perl_bin_path =~ s/\n//;
$perl_bin_path =~ s/\r//;

   
$opr_result = `perl config_perl_bin.pl $perl_bin_path`;
print $opr_result;

###############################################################################
   
print "\nDatabase account...\n";

print "DB username: ";
if ($db_user_name eq "") { $db_user_name = <STDIN>; } else { print "$db_user_name\n"; }
$db_user_name =~ s/\n//;
$db_user_name =~ s/\r//;


print "DB password: ";
if ($db_password eq "") { $db_password = <STDIN>; } else { print "$db_password\n"; }
$db_password =~ s/\n//;
$db_password =~ s/\r//;

print "    DB name: ";
if ($db_name eq "") { $db_name = <STDIN>; } else { print "$db_name\n"; }
$db_name  =~ s/\n//;
$db_name  =~ s/\r//;

   
my $content_new = undef;

if (open(MYFILE, "<./conf/dbi_connection.conf")) {
    my @lines = <MYFILE>;
    
    foreach my $line (@lines) {
        print $line;
        
        if ($line =~ /^db_name      =/) {
            $line = "db_name      = $db_name\n";
        }
        
        if ($line =~ /^db_user_name =/) {
            $line = "db_user_name = $db_user_name\n";
        }
        
        if ($line =~ /^db_password  =/) {
	    $line = "db_password  = $db_password\n";
        }
        
        $content_new .= $line;
    }
    
    close(MYFILE);
}

print $content_new;

if (open(MYFILE, ">./conf/dbi_connection.conf")) {
    print MYFILE $content_new;
    close(MYFILE);
}
###############################################################################

print "\nLoad 'appAdmin' (AAT) database tables...\n";

$opr_result = `perl app_dbt_logic_load.pl appAdmin 2013-10-13`;
print $opr_result;