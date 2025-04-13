package app_admin_login_info_all;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use app_admin_login_info_all_list;

sub new {
    my $type = shift;
    
    my $this = webman_CGI_component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    my $template_file = shift @_;
    
    $this->{template_default} = $template_file;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    $this->SUPER::run_Task();
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>";
    
    $this->SUPER::process_Content;  
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $app_name_in_control = $cgi->param("app_name_in_control");
    
    my $limit_description = $cgi->param("limit_description");
    my $login_name = $cgi->param("login_name");
    my $login_date = $cgi->param("login_date");
    my $login_time = $cgi->param("login_time");

    if ($login_name eq "") {
        $cgi->push_Param("login_name", "%");
    }

    if ($login_date eq "") {
        $cgi->push_Param("login_date", "%");
    }

    if ($login_time eq "") {
        $cgi->push_Param("login_time", "%");
    }

    my $where_clause_limit = undef;

    if ($limit_description ne "") {
        $where_clause_limit = "and u.description='$limit_description'";
    }

    if ($login_name ne "" && $login_name ne "%") {
        $where_clause_limit .= " and u.login_name='$login_name'";
    }

    if ($login_date ne "" && $login_date ne "%") {
        $where_clause_limit .= " and s.login_date like '$login_date%'";
    }

    if ($login_time ne "" && $login_time ne "%") {
        $where_clause_limit .= " and s.login_time like '$login_time%'";
    }


    my $session_table = "webman_" . $app_name_in_control . "_session";
    my $user_table = "webman_" . $app_name_in_control . "_user";

    $component = new app_admin_login_info_all_list;

    $component->set_Template_Default("template_app_admin_login_info_all_list.html");
    $component->set_SQL("select s.*, u.* from $session_table s, $user_table u where u.login_name=s.login_name $where_clause_limit order by \$cgi_order_by_login_list_");

    $component->set_Order_Field_Caption("Login Name:Full Name:Date/Time:IP:Total Hits");
    $component->set_Order_Field_Name("s.login_name, s.login_date desc, s.login_time desc:u.full_name, s.login_date desc, s.login_time desc:s.login_date desc, s.login_time desc:s.client_ip, s.login_date desc, s.login_time desc:s.hits desc");
    $component->set_Order_Field_CGI_Var("order_by_login_list");

    $component->set_List_Selection_Num(10);
    $component->set_DB_Items_View_Num(100);
    $component->set_DB_Items_Set_Num(1);

    $component->set_DB_Items_Set_Num_Var("dbisn_login_list");
    $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_login_list");

    #$component->set_Additional_GET_Data($cgi->generate_GET_Data("???")); ### all possible get data except link_name, dmisn, 
                                                                          ### link_id, app_name, and session_id

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn);

    $component->set_Default_Order_Field_Selected(2); ### this option must here (after set CGI & DB)

    $component->run_Task;
    $component->process_Content;

    $cgi->add_Debug_Text("SQL = " . $component->get_SQL, __FILE__, __LINE__); 

    my $content = $component->get_Content;
    
    $this->add_Content($content);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

1;
