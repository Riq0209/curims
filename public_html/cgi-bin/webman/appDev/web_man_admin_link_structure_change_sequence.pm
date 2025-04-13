package web_man_admin_link_structure_change_sequence;

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
    my $parent_link_id = $cgi->param("link_struct_id");
    my $seq_link_id = $cgi->param("seq_link_id");
    my $sequence = $cgi->param("sequence");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my ($related_seq, $related_link_id) = undef;
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my $max_seq = $dbu->get_MAX_Item("sequence", "parent_id", "$link_struct_id");
    
    if ($task eq "sequence_up" && $sequence == 0) {
        ### do nothing
        
    } elsif ($task eq "sequence_down" && $sequence == $max_seq) {
        ### do nothing
        
    } else {
        #print "<p>$task : $parent_link_id : $seq_link_id : $max_seq : $sequence</p>";
        
        my $sth = undef;
        
        if ($task eq "sequence_up") {
            $related_seq = $sequence - 1;
            $related_link_id = $dbu->get_Item("link_id", "parent_id sequence", "$parent_link_id $related_seq");
            
        } else {
            $related_seq = $sequence + 1;
            $related_link_id = $dbu->get_Item("link_id", "parent_id sequence", "$parent_link_id $related_seq");
        }
        
        #print "update $pre_table_name" . "link_structure set sequence='$sequence' where link_id='$related_link_id'<br>\n";
        
        $sth = $db_conn->prepare("update $pre_table_name" . "link_structure set sequence='$sequence' where link_id='$related_link_id'");
        $sth->execute;
        $sth->finish;
        
        #print "update $pre_table_name" . "link_structure set sequence='$related_seq' where link_id='$seq_link_id' <br>\n";
        
        $sth = $db_conn->prepare("update $pre_table_name" . "link_structure set sequence='$related_seq' where link_id='$seq_link_id'");
        $sth->execute;
        $sth->finish;
    }
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