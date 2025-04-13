#! C:/xampp/perl/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/appAdmin");

use DBI;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;

use webman_main;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../../webman/conf/dbi_connection.conf");

my $filename = $cgi->param("filename");
my $extension = $cgi->param("extension");
my $owner_entity_id = $cgi->param("owner_entity_id");
my $owner_entity_name = $cgi->param("owner_entity_name");

my $pre_table_name = undef;

if ($cgi->param("app_name") ne "") {
    $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
}

$filename =~ s/'/\\'/g;

if ($filename ne "" && $extension ne "" && $owner_entity_id ne "" && 
    $owner_entity_name ne "") {
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($dbi_conn); ### option 1
    
    
    $dbu->set_Table($pre_table_name . "blob_info");
    
    my $found = $dbu->find_Item("filename extension owner_entity_id owner_entity_name", 
                                "$filename $extension $owner_entity_id $owner_entity_name");  ### method 1
                                
    if ($found) {
        my $blob_id = $dbu->get_Item("blob_id", 
                                     "filename extension owner_entity_id owner_entity_name", 
                                     "$filename $extension $owner_entity_id $owner_entity_name"); 
                                     
        my $mime_type = $dbu->get_Item("mime_type", 
                                       "filename extension owner_entity_id owner_entity_name", 
                                       "$filename $extension $owner_entity_id $owner_entity_name");
        
        $dbu->set_Table($pre_table_name . "blob_content");
        
        my $content = $dbu->get_Item("content", "blob_id", $blob_id);   ### method 3
        
        print "Content-type: $mime_type\n\n";
        print $content;
        
    } else {
    
        $cgi->print_Header;
    $cgi->start_HTML("JSIC BLOB Content Printer", "");
        
    print "Error: Not found BLOB with the given parameter";
        
    $cgi->end_HTML();
    }

} else {
    $cgi->print_Header;
    $cgi->start_HTML("JSIC BLOB Content Printer", "");
    
    print "Error: Not complete parameter to print BLOB content";
    
    $cgi->end_HTML();
}
