#! /usr/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");

use DBI;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;
require Web_Service_Auth;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf"); ### 15/05/2009

$cgi->print_Header;
$cgi->start_HTML("Webman-framework CGI Test");

print "<pre>\n";
print "\$cgi = $cgi\n";
print "\$dbu = $dbu\n";
print "\$dbi_conn = $dbi_conn\n";
print "<pre>\n";

$cgi->end_HTML();
