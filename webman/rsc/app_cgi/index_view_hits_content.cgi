#! __path_perl_bin__ 

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/__app_name__");

use DBI;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf"); ### 15/05/2009

my $hit_id = $cgi->param("hit_id");
my $app_name_in_control = $cgi->param("app_name_in_control");
my $link_id = $cgi->param("link_id");
my $session_id = $cgi->param("session_id");

$dbu->set_DBI_Conn($dbi_conn);   ### option 1

$dbu->set_Table("webman_" . $app_name_in_control . "_hit_info_content");
my $hit_content = $dbu->get_Item("content", "hit_id", "$hit_id");

my $sql = $dbu->get_SQL;

$dbu->set_Table("webman_" . $app_name_in_control . "_hit_info_query_string");
my $query_string = $dbu->get_Item("query_string", "hit_id", "$hit_id");
my @query_array = split(/\&/, $query_string);

$dbu->set_Table("webman_" . $app_name_in_control . "_hit_info");
my $hit_session_id = $dbu->get_Item("session_id", "hit_id", "$hit_id");

my @ahr = $dbu->get_Items("hit_id", "session_id", "$hit_session_id", "date, time", undef);

my $hit_id_prev = undef;
my $hit_id_next = undef;

for (my $i =0; $i < @ahr; $i++) {
    if ($ahr[$i]->{hit_id} eq $hit_id) {
        if ($i > 0) {
            $hit_id_prev = $ahr[$i-1]->{hit_id};
        }
        
        if ($i < $#ahr) {
            $hit_id_next = $ahr[$i+1]->{hit_id};
        }        
    }
}

my $prev_link = "&lt;&lt;";
my $next_link = "&gt;&gt;";

if ($hit_id_prev ne undef) {
    $prev_link = "<a href=\"index_view_hits_content.cgi?hit_id=$hit_id_prev&app_name_in_control=$app_name_in_control&link_id=$link_id&session_id=$session_id\"><font color=\"##0099FF\">$prev_link</font></a>";

}

if ($hit_id_next ne undef) {
    $next_link = "<a href=\"index_view_hits_content.cgi?hit_id=$hit_id_next&app_name_in_control=$app_name_in_control&link_id=$link_id&session_id=$session_id\"><font color=\"##0099FF\">$next_link</font></a>";
}
my $back_link = "<a href=\"../appAdmin/index.cgi?&link_id=$link_id&session_id=$session_id\"><b>Back to Hits Content List</b></a>";

###############################################################################

my $page_properties .= "<link href=\"../../../webman/__app_name__/css/wm_tag_std.css\" rel=\"stylesheet\" type=\"text/css\">\n";
   $page_properties .= "<link href=\"../../../webman/__app_name__/css/wm_class_std.css\" rel=\"stylesheet\" type=\"text/css\">\n";


$cgi->print_Header;

$cgi->start_HTML($app_name, $page_properties);

#print "SQL: $sql<br>\n";

print "<center><p><font size=\"2\"><b>Trace Hit IDs Content:</b> $prev_link | $hit_id | $next_link &nbsp; &nbsp; &nbsp;  [ $back_link ]</font></p></center>\n";

$hit_content =~ s/\\ / /g;
$hit_content =~ s/\\"/"/g;
print $hit_content;

print "<p>\n<table border=\"1\">\n";
print "<tr><td><b>Variable Name</b></td><td><b>Value</b></td><tr>\n";

foreach my $item (@query_array) {
    my @data = split(/=/, $item);
    
    print "<tr><td>" . $data[0] . "</td><td>" . $data[1] . "</td><tr>\n";
}

print "</table>\n";

$cgi->end_HTML();
