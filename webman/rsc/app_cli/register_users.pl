#! /usr/bin/perl

use lib '../../../pm/core';

use DBI;
use  DB_Utilities;

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("../../../conf/dbi_connection.conf");

$dbu->set_DBI_Conn($db_conn);

print "Users List File (| login | password | full_name |): ";

my $file_users_list = <STDIN>;


print "Users Description: ";

my $description = <STDIN>;
   $description =~ s/\n//;
   $description =~ s/ /\\ /g;
   
   
print "Webman App. Name: ";

my $app_name = <STDIN>;
   $app_name =~ s/\n//;


my @file_content = undef;
my $line = undef;

if (open(MYFILE, "<./$file_users_list")) {
    @file_content = <MYFILE>;
    
    foreach $line (@file_content) {
        $line =~ s/\n//;
    
        my @data = split (/\| /, $line);
        
        while ($data[1] =~ / /) {
            $data[1] =~ s/ //;
        }
        
        while ($data[2] =~ / /) {
            $data[2] =~ s/ //;
        }
        
        while ($data[3] =~ /  /) {
            $data[3] =~ s/  / /;
        }
        
        $data[3] =~ s/ \|//;
        
        print "-$data[1]-$data[2]-$data[3]-\n";
        
        $data[3] =~ s/ /\\ /g;
        $data[3] =~ s/'/\\'/g;
        
        $dbu->set_Table("webman_" . $app_name . "_user");
        
        $dbu->insert_Row("login_name password full_name description",
                         "$data[1] $data[2] $data[3] $description");
    }
    

    
    close(MYFILE);
}
