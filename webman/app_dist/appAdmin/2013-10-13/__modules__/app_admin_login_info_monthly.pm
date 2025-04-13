package app_admin_login_info_monthly;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use webman_calendar_interactive;

use app_admin_login_info_monthly_list;

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
    
    my $yearmonth = $cgi->param_Shift("yearmonth");
    
    if ($yearmonth ne "") {
        #$cgi->add_Debug_Text("Delete session info data for year-month = $yearmonth", __FILE__, __LINE__, "TRACING");
        
        $dbu->set_Table($this->{session_table});
        $dbu->set_Keys_Str("login_date like '$yearmonth-%'");
        
        my @ahr = $dbu->get_Items("session_id login_date login_time", undef, undef, "login_date, login_time");
        
        $dbu->set_Keys_Str(undef);
        
        foreach my $item (@ahr) {
            #$cgi->add_Debug_Text("$item->{session_id} - $item->{login_date} - $item->{login_time}", 
            #                     __FILE__, __LINE__, "TRACING");
                                 
            $dbu->set_Table($this->{session_table_hit_info});
            
            my @ahr2 = $dbu->get_Items("hit_id", "session_id", "$item->{session_id}");
            
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
        $dbu->set_Keys_Str("login_date like '$yearmonth-%'");
        $dbu->delete_Item(undef, undef);
        $dbu->set_Keys_Str(undef);
        
        $dbu->set_Table($this->{session_table_info_daily});
        $dbu->set_Keys_Str("date like '$yearmonth-%'");
        $dbu->delete_Item(undef, undef);
        $dbu->set_Keys_Str(undef);
        
        $dbu->set_Table($this->{session_table_info_monthly});
        $dbu->delete_Item("yearmonth", "$yearmonth"); 
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
    my $session_table_info_monthly = $this->{session_table_info_monthly};
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
    
    $dbu->set_Table($session_table_info_daily);
    
    my $date_min = $dbu->get_MIN_Item("date", undef, undef);
    my $date_max = $dbu->get_MAX_Item("date", undef, undef);
    
    my $today_ISO = $this->get_Today_ISO;
    my $ym_today = substr($today_ISO, 0, 7);    
    
    my $ym_min = undef;
    my $ym_max = undef;
    
    $dbu->set_Table($session_table_info_monthly);
    $ym_max = $dbu->get_MAX_Item("yearmonth", undef, undef);
    
    #$cgi->add_Debug_Text($dbu->get_SQL . " = $ym_max", __FILE__, __LINE__);
    
    if ($ym_max eq "") {
        $ym_min = substr($date_min, 0, 7);
        $ym_max = substr($date_max, 0, 7);
      
    } else {
        $date_min = "$ym_max-01";
        
        $ym_min = $ym_max;
        $ym_max = substr($date_max, 0, 7);
    }
    
    #$cgi->add_Debug_Text("$date_min : $ym_min | $date_max : $ym_max | $today_ISO : $ym_today", __FILE__, __LINE__);
    
    my @ahr = $calendar->get_Intermediate_Date_Info($date_min, $today_ISO);
    
    my $ym_prev = $ym_min;
    
    my $total_user = 0;
    my $total_login = 0;
    my $total_hits = 0;
    my @ym_info = ();
    
    foreach $item (@ahr) {
        my $date_str = $item->{iso_ymd};
        my $ym_str = substr($date_str, 0, 7);
        
        #$cgi->add_Debug_Text($date_str, __FILE__, __LINE__);
        
        if ($ym_prev ne $ym_str) {      
            push(@ym_info, {yearmonth => $ym_prev, total_user => $total_user, 
                            total_login => $total_login, total_hits => $total_hits});
            
            $total_user = 0;
            $total_login = 0;
            $total_hits = 0;
        }
        
        ### Get total user distinctive by their login name.
        $dbu->set_Table($session_table);
        $total_user += $dbu->count_Item("login_date", $date_str, "login_name");
        #$cgi->add_Debug_Text($dbu->get_SQL . " - total_user = $total_user", __FILE__, __LINE__);   
        
        ### Get total login and hits.
        $dbu->set_Table($session_table_info_daily);
        $total_login += $dbu->get_Item("total_login", "date", "$date_str");
        $total_hits += $dbu->get_Item("total_hits", "date", "$date_str");
        
        $ym_prev = $ym_str;
        
        $idx++;
    }
    
    push(@ym_info, {yearmonth => $ym_prev, total_user => $total_user, 
                    total_login => $total_login, total_hits => $total_hits});
                    
    foreach my $item (@ym_info) {
        ### Just delete any that previously exist.
        $dbu->set_Table($session_table_info_monthly);
        $dbu->delete_Item("yearmonth", "$item->{yearmonth}");
        
        ### Insert year-month info.
        $dbu->insert_Row("yearmonth total_user total_login total_hits", 
                         "$item->{yearmonth} $item->{total_user} $item->{total_login} $item->{total_hits}");
        
        #$cgi->add_Debug_Text("$item->{yearmonth} - $item->{total_user} - $item->{total_login} - $item->{total_hits}", 
        #                     __FILE__, __LINE__);
    }
    
    ###########################################################################
    
    my $dbihtml = new DBI_HTML_Map;

    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from $session_table_info_monthly");
    #$dbihtml->set_HTML_Code($te_content);
    #$dbihtml->set_Items_View_Num($...); ### option 1
    #$dbihtml->set_Items_Set_Num($...);  ### option 2

    #my $content = $dbihtml->get_HTML_Code;
    my $tld = $dbihtml->get_Table_List_Data;
    
    if ($tld) {
    
        my $component = new app_admin_login_info_monthly_list;

        $component->set_Template_Default("template_app_admin_login_info_monthly_list.html");
        $component->set_TLD($tld);
        $component->set_Items_View_Num(50);
        $component->set_Items_Set_Num(1); ### set for default set num

        #$component->set_INL_Var_Name("???"); ### Items Num./List, default is "inl"
        #$component->set_LSN_Var_Name("???"); ### List Set Num., default is "lsn"

        $component->set_Items_Set_Num_Var("tldisn_monthly");
        $component->set_Dynamic_Menu_Items_Set_Number_Var("dmisn_monthly");

        $component->set_List_Selection_Num(10); ### default is 15 (if line/code is disabled)

        $component->set_Order_Field_Caption("Year-Month:Total User:Total Login:Total Hits");
        $component->set_Order_Field_Name_Opt_Mode("yearmonth:total_user:total_login:total_hits", "desc:desc:desc:desc", "str:num:num:num");
        $component->set_Order_Field_CGI_Var("order_by_monthly");

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

