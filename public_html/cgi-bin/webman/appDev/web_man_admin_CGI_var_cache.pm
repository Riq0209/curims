package web_man_admin_CGI_var_cache;

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_CGI_var_cache_list;

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
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_CGI_var_cache.html");
    
    $this->SUPER::process_Content;  
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
    
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $blob_content_link_name = $cgi->param("blob_content_link_name");
    if ($blob_content_link_name eq "") { $blob_content_link_name = "Link Reference"; }
    
    my $task = $cgi->param("task");
    
    my $component = undef;
    
    
    $component = new web_man_admin_CGI_var_cache_list;

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn); ### option 2
    
    $component->set_Template_Default("template_admin_CGI_var_cache_list.html");
    
    #$component->set_SQL("select * from webman_aims_cgi_var_cache order by $cgi_order_var_cache_");
    $component->set_Table_Name("webman_" . $cgi->param("app_name") . "_cgi_var_cache");
    
    $component->set_Order_Field_CGI_Var("order_var_cache");
    $component->set_Order_Field_Caption("Session ID:Link ID:Name:Value:Active Mode");
    $component->set_Order_Field_Name("session_id:link_id:name:value:active_mode"); ### can be 1 or many fields following standard SQL order syntax: fname_ | fname_ desc | fname_1_ , ..., fname_2 desc | ...  
    $component->set_Default_Order_Field_Selected(1);
    #$component->set_Map_Caption_Field("caption_1_ => field_1_, ..., caption_n_ => field_n_"); ### it's only [1 to 1] mapping
    
    $component->set_INL_Var_Name("inl_cgi_var_cache"); ### Items Num./List, default is "inl"
    $component->set_LSN_Var_Name("lsn_cgi_var_cache"); ### List Set Num., default is "lsn"
    
    #$component->set_Carried_Previous_GET_Data("link_name app_name");
    
    $component->set_DB_Items_Set_Num_Var("dbisn_cgi_var_cache"); ### default is: "dbisn_" . $cgi->param("task");
    $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_cgi_var_cache"); ### default is: "dmisn_" . $cgi->param("task");
    
    my $carried_get_data = $cgi->generate_GET_Data("link_name app_name inl_cgi_var_cache lsn_cgi_var_cache filter_session_id filter_link_id");
    my $carried_hidden_data = $cgi->generate_GET_Data("link_name app_name dmisn_cgi_var_cache order_var_cache");
    
    $component->set_Additional_GET_Data($carried_get_data);
    $component->set_Additional_Hidden_POST_Data($carried_hidden_data);

    $component->run_Task;
    $component->process_Content;
            
    $te_content = $component->get_Content;
    
    $this->add_Content($te_content);
}


1; 