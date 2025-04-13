package app_admin_login_info_daily;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use webman_calendar_interactive;

use app_admin_login_info_daily_list;

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
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    $this->{app_name_in_control} = $cgi->param("app_name_in_control");

    $this->{session_table} = "webman_" . $this->{app_name_in_control} . "_session";
    $this->{session_table_info_daily} = "webman_" . $this->{app_name_in_control} . "_session_info_daily";
    $this->{session_table_info_monthly} = "webman_" . $this->{app_name_in_control} . "_session_info_monthly";
    
    $this->{session_table_hit_info} = "webman_" . $this->{app_name_in_control} . "_hit_info";
    $this->{session_table_hit_info_content} = "webman_" . $this->{app_name_in_control} . "_hit_info_content";
    $this->{session_table_hit_info_query_string} = "webman_" . $this->{app_name_in_control} . "_hit_info_query_string";    
    
    $this->SUPER::run_Task();
    
    my $date = $cgi->param_Shift("date");
    
    if ($date ne "") {
        #$cgi->add_Debug_Text("Delete session info data for date = $date", __FILE__, __LINE__, "TRACING");
        
        $dbu->set_Table($this->{session_table});
        
        my @ahr = $dbu->get_Items("session_id login_date login_time", "login_date", "$date", "login_time");
        
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        
        foreach my $item (@ahr) {
            #$cgi->add_Debug_Text("$item->{session_id} - $item->{login_date} - $item->{login_time}", 
            #                     __FILE__, __LINE__, "TRACING");
                                 
            $dbu->set_Table($this->{session_table_hit_info});
            
            my @ahr2 = $dbu->get_Items("hit_id", "session_id", "$item->{session_id}");
            
            #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
            
            foreach my $item2 (@ahr2) {
                #$cgi->add_Debug_Text("$item2->{hit_id}", __FILE__, __LINE__);
                
                $dbu->set_Table($this->{session_table_hit_info_content});
                $dbu->delete_Item("hit_id", "$item2->{hit_id}");
                
                $dbu->set_Table($this->{session_table_hit_info_query_string});
                $dbu->delete_Item("hit_id", "$item2->{hit_id}");
            }
            
            $dbu->set_Table($this->{session_table_hit_info});
            $dbu->delete_Item("session_id", "$item->{session_id}");
        }
        
        $dbu->set_Table($this->{session_table});
        $dbu->delete_Item("login_date", "$date");
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        
        ### Only need to update daily session info data.
        $dbu->set_Table($this->{session_table_info_daily});
        
        my $total_user = $dbu->get_Item("total_user", "date", "$date");
        my $total_login = $dbu->get_Item("total_login", "date", "$date");
        my $total_hits = $dbu->get_Item("total_hits", "date", "$date");
        
        $dbu->update_Item("total_user total_login total_hits", "0 0 0", "date", "$date");
        $cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        
        
        ### Only need to update monthly session info data.
        my $yearmonth = substr($date, 0, 7);
        
        $dbu->set_Table($this->{session_table_info_monthly});
        
        $total_user = $dbu->get_Item("total_user", "yearmonth", "$yearmonth") - $total_user;
        $total_login = $dbu->get_Item("total_login", "yearmonth", "$yearmonth") - $total_login;
        $total_hits = $dbu->get_Item("total_hits", "yearmonth", "$yearmonth") - $total_hits;
        
        $dbu->update_Item("total_user total_login total_hits", 
                          "$total_user $total_login $total_hits", "yearmonth", "$yearmonth");
                          
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        
    }
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
    
    my $session_table = $this->{session_table};
    my $session_table_info_daily = $this->{session_table_info_daily};    
    my $calendar_table = "webman_" . $this->{app_name_in_control} . "_calendar";
    
    #$cgi->add_Debug_Text($calendar_table, __FILE__, __LINE__);
    
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);   ### option 1
    
    
    ### below is required to always have up-to-date data inside
    ### calendar table
    my $calendar = new Calendar;
        
    $calendar->set_CGI($cgi);
    $calendar->set_DBI_Conn($db_conn);
    $calendar->set_DB_Table($calendar_table);
    
    $calendar->init_Task;
    
    ##################################################################
    
    my $date_max = undef;
    my $date_min = undef;
    
    my $today_ISO = $this->get_Today_ISO;
    
    $dbu->set_Table($session_table_info_daily);
    $date_max = $dbu->get_MAX_Item("date", undef, undef);
    
    #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
    
    if ($date_max eq "") {
        $dbu->set_Table($session_table);
        $date_min = $dbu->get_MIN_Item("login_date", undef, undef);
        $date_max = $dbu->get_MAX_Item("login_date", undef, undef);
        
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
        
    } else {
        $date_min = $date_max;
    }
    
    #$cgi->add_Debug_Text("$date_min / $date_max / $today_ISO", __FILE__, __LINE__);
    
    my @ahr = undef;
    my $item = undef;
    
    @ahr = $calendar->get_Intermediate_Date_Info($date_min, $today_ISO);
    
    $dbu->set_Keys_Str(undef);
    
    foreach $item (@ahr) {        
        my $date_str = $item->{iso_ymd};
        
        #$cgi->add_Debug_Text($date_str, __FILE__, __LINE__);
        
        ###############################################################################
        $dbu->set_Table($session_table);
        #$cgi->add_Debug_Text($session_table, __FILE__, __LINE__, "DATABASE");
        
        my $user_num = $dbu->count_Item("login_date", $date_str, "login_name");
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        
        my $login_num = $dbu->count_Item("login_date", $date_str);
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        
        my $item2 = undef;
        my $hits_num = 0;
        my @ahr2 = $dbu->get_Items("hits", "login_date", $date_str);
        
        foreach $item2 (@ahr2) {
            $hits_num += $item2->{hits};
        }   
        
        ###############################################################################
        
        $dbu->set_Table($session_table_info_daily);
        
        if ($date_str eq $date_max) {
            $dbu->delete_Item("date", "$date_str");
        }
        
        $dbu->insert_Row("date day day_abbr total_user total_login total_hits", "$date_str " . $item->{day} . " " . $item->{day_abbr} . " $user_num $login_num $hits_num");
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
    }
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from $session_table_info_daily");
    #$dbihtml->set_HTML_Code($te_content);
    #$dbihtml->set_Items_View_Num($...); ### option 1
    #$dbihtml->set_Items_Set_Num($...);  ### option 2

    #my $content = $dbihtml->get_HTML_Code;
    my $tld = $dbihtml->get_Table_List_Data;
    
    my $component = new app_admin_login_info_daily_list;

    $component->set_Template_Default("template_app_admin_login_info_daily_list.html");
    $component->set_TLD($tld);
    $component->set_Items_View_Num(50);
    $component->set_Items_Set_Num(1); ### set for default set num

    #$component->set_INL_Var_Name("???"); ### Items Num./List, default is "inl"
    #$component->set_LSN_Var_Name("???"); ### List Set Num., default is "lsn"

    $component->set_Items_Set_Num_Var("tldisn_daily");
    $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_daily");

    $component->set_List_Selection_Num(10); ### default is 15 (if line/code is disabled)

    $component->set_Order_Field_Caption("Date:Total User:Total Login:Total Hits");
    $component->set_Order_Field_Name_Opt_Mode("date:total_user:total_login:total_hits", "desc:desc:desc:desc", "str:num:num:num");
    $component->set_Order_Field_CGI_Var("order_by_daily");

    #$component->set_Additional_GET_Data($cgi->generate_GET_Data("???")); ### all possible get data except link_name, dmisn, 
                                                                          ### link_id, app_name, and session_id

    #$component->set_Additional_Hidden_POST_Data($cgi->generate_Hidden_POST_Data("???")); ### all possible hidden post data except link_name, dmisn, 
                                                                                          ### link_id, app_name, and session_id

    $component->set_CGI($cgi);
    $component->set_DBI_Conn($db_conn); ### option 2

    #$component->set_Default_Order_Field_Selected(1);

    if ($component->authenticate($login_name, \@groups, "webman_" . $cgi->param("app_name") ."_comp_auth")) {
        $component->run_Task;
        $component->process_Content;
    }

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

