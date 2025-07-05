#! /usr/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/curims");

use strict;
use warnings;
use CGI;
use DBI;
use JSON;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;
require Web_Service_Auth;

require curims;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;
print CGI::header('application/json');

my $login = $cgi->param('login') // '';
my $password = $cgi->param('password') // '';

# Use the same DB connection config as index.cgi
my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf");
$dbu->set_DBI_Conn($dbi_conn);
$cgi->set_DBI_Conn($dbi_conn);

my $dbh = DBI->connect('dbi:mysql:database=db_webman;host=localhost', 'webman', 'webman', { RaiseError => 1, PrintError => 0 });
if (!$dbh) {
    print encode_json({ success => 0, error => 'Direct DB connection failed' });
    exit;
}

# Debug: Print the query and parameters to the error log
print STDERR "Login attempt - Username: '$login', Password: '$password'\n";

my $query = 'SELECT COUNT(*) FROM webman_curims_user WHERE login_name = ? AND password = ?';
print STDERR "Executing query: $query with params: '$login', '$password'\n";

my $sth = $dbh->prepare($query);
$sth->execute($login, $password);
my ($count) = $sth->fetchrow_array;

# Debug: Print the result of the query
print STDERR "Query matched $count rows\n";
$sth->finish;

# do not disconnect here, dbu manages connection

if ($count) {
    # Successful login - Send a redirect URL along with success
    print encode_json({ success => 1, redirect => 'index.cgi?login=' . $login . '&password=' . $password }); 
} else {
    print encode_json({ success => 0, error => 'Unauthorized user' });
}
