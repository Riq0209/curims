package web_man_admin_link_structure_delete;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    bless $this, $type;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return $this->SUPER::get_Name_Full . "::" . __PACKAGE__;
}

sub run_Task {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }    
    
    $this->SUPER::run_Task;
    
    my $task = $cgi->param("task");
    
    my $child_link_id = $cgi->param("child_link_id");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn); ### option 1
    
    
    ### link_structure ###
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my $parent_id = $dbu->get_Item("parent_id", "link_id", $child_link_id);
    
    #print "delete link_structure where link_id = $child_link_id <br />\n";
    $dbu->delete_Item("link_id", $child_link_id);
    
    
    ### link_reference ##############################################
    $dbu->set_Table($pre_table_name . "link_reference");
    
    my @lrids = $dbu->get_Items("link_ref_id", "link_id", $child_link_id);
    
    foreach my $item (@lrids) {
        my $link_ref_id = $item->{link_ref_id};
        
        #print "delete link_reference where link_ref_id = $link_ref_id <br />\n";
        $dbu->set_Table($pre_table_name . "link_reference");
        $dbu->delete_Item("link_ref_id", $link_ref_id);
    
    
        ### dyna_mod_selector #######################################
        $dbu->set_Table($pre_table_name . "dyna_mod_selector");
        
        my @dmsids = $dbu->get_Items("dyna_mod_selector_id", "link_ref_id", $link_ref_id);
        
        #print "delete dyna_mod_selector where link_ref_id = $link_ref_id <br />\n";
        $dbu->delete_Item("link_ref_id", $link_ref_id);
        
        
        ### dyna_mod_param ##########################################
        $dbu->set_Table($pre_table_name . "dyna_mod_param");
        #print "delete dyna_mod_param where link_ref_id = $link_ref_id <br />\n";
        $dbu->delete_Item("link_ref_id", $link_ref_id);
        
        foreach my $item2 (@dmsids) {
            my $dyna_mod_selector_id = $item2->{dyna_mod_selector_id};
            
            #print "delete dyna_mod_param where dyna_mod_selector_id = $dyna_mod_selector_id <br />\n";
            $dbu->delete_Item("dyna_mod_selector_id", $dyna_mod_selector_id);        
        }
    }
    
    my $sth = $db_conn->prepare("select blob_id from $pre_table_name" . "blob_info where owner_entity_id='$link_ref_id' and owner_entity_name='link_reference'");
        
    $sth->execute;
    
    $dbu->set_Table($pre_table_name . "blob_content");
    
    my $data_hashref = undef;
    
    while ($data_hashref = $sth->fetchrow_hashref) {
        #print "<p>delete: $owner_entity_id - $owner_entity_name - $data_hashref->{blob_id}</p>";
        $dbu->delete_Item("blob_id", $data_hashref->{blob_id});
    }

    $sth->finish;
    
    $dbu->set_Table($pre_table_name . "blob_info");
    $dbu->delete_Item("owner_entity_id owner_entity_name", "$link_ref_id link_reference");
    
    
    ### resequencing base on $parent_id
    
    $sth = $db_conn->prepare("select link_id from $pre_table_name" . "link_structure where parent_id='$parent_id' order by sequence");
    $sth->execute;
    
    my $seq_count = 0;
    $dbu->set_Table($pre_table_name . "link_structure");
    
    while ($data_hashref = $sth->fetchrow_hashref) {
        $dbu->update_Item("sequence", "$seq_count", "link_id", $data_hashref->{link_id});
        $seq_count++;
        
        #print "parent id for resequencing = $parent_id : current link_id = " . $data_hashref->{link_id} . "<br>";
    }
    
    $sth->finish;
    
    
    ### delete link authentication info.
    $dbu->set_Table($pre_table_name . "link_auth");
    $dbu->delete_Item("link_id", $child_link_id);
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    
    my $component = new web_man_admin_link_structure;
        
    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn); ### option 2
                
    $component->run_Task;
    $component->process_Content;
                
    my $content = $component->get_Content;
        
    $this->add_Content($content);
}