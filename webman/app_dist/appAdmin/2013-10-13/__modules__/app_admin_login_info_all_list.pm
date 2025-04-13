package app_admin_login_info_all_list;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $type = shift;
    
    my $this = webman_db_item_view_dynamic->new();
    
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
    
    $this->SUPER::run_Task();
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $users_table = "webman_" . $cgi->param("app_name_in_control") . "_user";
    
    my $s_opt = new Select_Option;

    $s_opt->set_DBI_Conn($db_conn);
    $s_opt->set_Values_From_DBI_SQL("select distinct description from $users_table order by description");
    $s_opt->set_Options_From_DBI_SQL("select distinct description from $users_table order by description");


    #$s_opt->set_Values("value_1", "value_2", "...", "value_n");
    #$s_opt->set_Options("option_1", "option_2", "...", "option_n");

    $s_opt->set_Selected($cgi->param("limit_description"));

    my $content = $s_opt->get_Selection;
    
    $this->add_Content($content);
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $caller_get_data = $this->generate_GET_Data("link_name link_id dmisn app_name ...");
    my $get_data = undef;
    
    $tld->add_Column("row_color");
    $tld->add_Column("previous_get_data");
    
    my $row_color = "#FFFFFF";
    
    my $previous_get_data = $cgi->generate_GET_Data("session_id app_name_in_control dbisn_login_list dmisn_login_list order_by_login_list limit_description");
    
    for ($i = 0; $i < $tld->get_Row_Num; $i++) { 
        #$tld_data = $tld->get_Data($i, "nama");
        
        #$get_data = $caller_get_data . "&" . "nama=" . $tld_data;
        #$get_data =~ s/ /+/g;
        
        #$tld_data = "<font color=\"#0099FF\">$tld_data</font>";
            
        #$tld->set_Data($i, "nama", $tld_data);
        #$tld->set_Data_Get_Link($i, "nama", "index.cgi?$get_data");
        
        $tld->set_Data($i, "row_color", "$row_color");
        
        if ($row_color eq "#FFFFFF") {
            $row_color = "#E3E6FB";
        } else {
            $row_color = "#FFFFFF";
        }
        
        $tld->set_Data($i, "previous_get_data", $previous_get_data);
    }
    
    return $tld;
}

1;