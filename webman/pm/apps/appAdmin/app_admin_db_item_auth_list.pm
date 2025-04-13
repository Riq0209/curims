package app_admin_db_item_auth_list;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $type = shift;
    
    my $this = webman_db_item_view_dynamic->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{staff_id};
    
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
    
    $this->SUPER::run_Task();
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $hpd = $cgi->generate_Hidden_POST_Data("link_id session_id");
    
    $this->add_Content($hpd);
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $caller_get_data = $this->generate_GET_Data("link_id session_id");
    #my $caller_get_data = $this->generate_GET_Data("link_name link_id dmisn app_name app_name_in_control app_name_db_auth dbisn_db_item_auth_list dmisn_db_item_auth_list order_by_db_item_auth_list");
    my $get_data = undef;
    
    $tld->add_Column("row_color");
    
    my $row_color = "#FFFFFF";
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_db_item_auth");
    
    my $comp_name = undef;
    
    my $id_dbia = undef;
    
    my $mode_insert = undef;
    my $mode_update = undef;
    my $mode_delete = undef;

    my $mode_insert_new = undef;
    my $mode_update_new = undef;
    my $mode_delete_new = undef;
    
    for ($i < 0; $i < $tld->get_Row_Num; $i++) { 
        $id_dbia = $tld->get_Data($i, "id_dbia");
    
        my $mode_insert = $tld->get_Data($i, "mode_insert");
        my $mode_update = $tld->get_Data($i, "mode_update");
        my $mode_delete = $tld->get_Data($i, "mode_delete");
        
        if ($mode_insert eq "") { $mode_insert = 0; }
        if ($mode_update eq "") { $mode_update = 0; }
        if ($mode_delete eq "") { $mode_delete = 0; }
        
        my $mode_insert_new = 0;
        my $mode_update_new = 0;
        my $mode_delete_new = 0;
        
        if ($mode_insert == 0) { $mode_insert_new = 1; }
        if ($mode_update == 0) { $mode_update_new = 1; }
        if ($mode_delete == 0) { $mode_delete_new = 1; }
        
        ### link for mode_insert
        
        $get_data = $caller_get_data . "\&id_dbia=$id_dbia\&task=db_item_auth_set_insert\&mode_value=$mode_insert_new" ;
        $get_data =~ s/ /+/g;
        
        if ($mode_insert) {
            $tld_data = "<font color=\"#FF0000\">$mode_insert</font>";
            
        } else {
            $tld_data = "<font color=\"#0099FF\">$mode_insert</font>";
        }
            
        $tld->set_Data($i, "mode_insert", $tld_data);
        $tld->set_Data_Get_Link($i, "mode_insert", "index.cgi?$get_data");
        
        
        ### link for mode_update
        
        $get_data = $caller_get_data . "\&id_dbia=$id_dbia\&task=db_item_auth_set_update\&mode_value=$mode_update_new" ;
        $get_data =~ s/ /+/g;

        if ($mode_update) {
            $tld_data = "<font color=\"#FF0000\">$mode_update</font>";

        } else {
            $tld_data = "<font color=\"#0099FF\">$mode_update</font>";
        }

        $tld->set_Data($i, "mode_update", $tld_data);
        $tld->set_Data_Get_Link($i, "mode_update", "index.cgi?$get_data");
        
        
        ### link for mode_delete
                
        $get_data = $caller_get_data . "\&id_dbia=$id_dbia\&task=db_item_auth_set_delete\&mode_value=$mode_delete_new" ;
        $get_data =~ s/ /+/g;

        if ($mode_delete) {
            $tld_data = "<font color=\"#FF0000\">$mode_delete</font>";

        } else {
            $tld_data = "<font color=\"#0099FF\">$mode_delete</font>";
        }

        $tld->set_Data($i, "mode_delete", $tld_data);
        $tld->set_Data_Get_Link($i, "mode_delete", "index.cgi?$get_data");
        
        
        
        $tld->set_Data($i, "row_color", "$row_color");
        
        if ($row_color eq "#FFFFFF") {
            $row_color = "#E3E6FB";
        } else {
            $row_color = "#FFFFFF";
        }
    }
    
    return $tld;
}

1;