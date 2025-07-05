#! /usr/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/curims");

use DBI;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;

require webman_blob_content_separator;

my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf");

my $blob_id = $cgi->param("blob_id");
my $mode = $cgi->param("mode");
my $pre_table_name = undef;

if ($cgi->param("app_name") ne "") {
    $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
}

if ($blob_id ne "") {
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($dbi_conn); ### option 1
    
    
    $dbu->set_Table($pre_table_name . "blob_info");
    
    my $found = $dbu->find_Item("blob_id", $blob_id);  ### method 1
                                
    if ($found) {                             
        my $mime_type = $dbu->get_Item("mime_type", "blob_id", $blob_id);
        
        $dbu->set_Table($pre_table_name . "blob_content");
        
        my $content = $dbu->get_Item("content", "blob_id", $blob_id);   ### method 3
        
        $dbu->set_Table($pre_table_name . "blob_info");
        
        my $file_name = $dbu->get_Item("filename", "blob_id", $blob_id) . "." . $dbu->get_Item("extension", "blob_id", $blob_id);
        
        if ($mode eq "download") {
            #print "Content-type: $mime_type\n\n";
            print "Content-type: application/octet-stream\n";
            print "Content-Disposition: attachment;filename=$file_name\n\n";
        
        if ($file_name =~ /.html/i || $file_name =~ /.htm/i) {
            $webman_bcs = new webman_blob_content_separator;
            
            $webman_bcs->set_HTML_BLOB_Content($content);
            
            $content = $webman_bcs->get_HTML_Code;
        }
        
        } else {
            print "Content-type: $mime_type\n\n";
        }
        
        print $content;
        
        
    } else {
    
        $cgi->print_Header;
    $cgi->start_HTML("Webman BLOB Content Printer", "");
        
    print "Error: Not found BLOB with the given parameter";
        
    $cgi->end_HTML();
    }

} else {
    $cgi->print_Header;
    $cgi->start_HTML("Webman BLOB Content Printer", "");
    
    print "Error: Not complete parameter to print BLOB content";
    
    $cgi->end_HTML();
}
