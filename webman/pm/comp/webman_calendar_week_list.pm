package webman_calendar_week_list;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{key_date_start} = undef;
    $this->{key_date_end} = undef;
    
    $this->{row_style} = undef;
    $this->{row_style_odd} = undef;
    $this->{row_style_even} = undef;
    
    $this->{row_style_current} = undef;
    $this->{row_style_selected} = undef;
    
    $this->{date_column_style} = undef;
    $this->{content_column_style} = undef;
    
    $this->{icon_select} = undef;
    $this->{icon_deselect} = undef;
    
    bless $this, $class;
    
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

sub set_Key_Date_Start {
    my $this = shift @_;
    
    $this->{key_date_start} = shift @_;
}

sub set_Key_Date_End {
    my $this = shift @_;
    
    $this->{key_date_end} = shift @_;
}

sub set_Default_Row_Style {
    my $this = shift @_;
    
    $this->{row_style} = shift @_;
    $this->{row_style_odd} = shift @_;
    $this->{row_style_even} = shift @_;
    $this->{row_style_current} = shift @_;
    $this->{row_style_selected} = shift @_;
}

sub set_Default_Column_Style {
    my $this = shift @_;
    
    $this->{date_column_style} = shift @_;
    $this->{content_column_style} = shift @_;
}

sub set_Week_Selection_Icon {
    my $this = shift @_;
    
    $this->{icon_select} = shift @_;
    $this->{icon_deselect} = shift @_;
}

### 05/12/2011
sub add_Date_Content {
    my $this = shift @_;
    
    my $date_ISO = shift @_;
    my $date_content = shift @_;
    
    if (!defined($this->{map_date_content})) {
        $this->{map_date_content} = {};
    }
    
    $this->{map_date_content}->{$date_ISO} .= $date_content;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    #$this->set_Error("???");
    
    $this->SUPER::run_Task();
    
    ###########################################################################
    
    if (!defined($this->{icon_select})) {
        $this->{icon_select} = "*";
    }
    
    if (!defined($this->{icon_deselect})) {
        $this->{icon_deselect} = "<font color=\"#ff0000\">*</font>";
    }    
    
    my $calendar = new Calendar;
    
    $calendar->set_CGI($cgi);
    $calendar->set_DBI_Conn($db_conn);
    $calendar->set_DB_Table("webman_" . $cgi->param("app_name") . "_calendar");
    
    #$cgi->add_Debug_Text("Try to init calendar table: " . $calendar->{calendar_table}, __FILE__, __LINE__);
    
    $calendar->init_Task;
    
    $this->{current_year} = $calendar->{current_year};
    $this->{current_month} = $calendar->{current_month};
    $this->{current_date} = $calendar->{current_date};
    
    $this->{calendar} = $calendar;    
    
    ###########################################################################
    
    my @date_list = ();
    
    if ($cgi->param("calendar_key_date_start") ne "") { 
        $this->{key_date_start} = $cgi->param("calendar_key_date_start");
    } 
    
    if ($cgi->param("calendar_key_date_end") ne "") { 
        $this->{key_date_end} = $cgi->param("calendar_key_date_end");
    }    
    
    if (defined($this->{key_date_start}) && defined($this->{key_date_end})) {
        @date_list = $calendar->get_Intermediate_Date_Info($this->{key_date_start}, $this->{key_date_end});
        
    } else {
        $dbu->set_Table("webman_" . $cgi->param("app_name") . "_calendar");
        @date_list = $dbu->get_Items("year month date month_abbr day_abbr iso_ymd", "year month_abbr", "$this->{current_year} $this->{current_month}", "iso_ymd");

        $this->{key_date_start} = "$date_list[0]->{iso_ymd}";
        $this->{key_date_end}   = "$date_list[@month_list - 1]->{iso_ymd}";    
    }
    
    $this->{date_list_ref} = \@date_list;
    
    #$cgi->add_Debug_Text("$this->{key_date_start} --- $this->{key_date_end}", __FILE__, __LINE__);    
    
    $this->{tld} = $this->customize_TLD($this->generate_Week_List_TLD);
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_name = $te->get_Name;
    
    my $content = undef;
    
    my $std_get_data = $cgi->generate_GET_Data("link_id");

    if ($te_type_name eq "cal_prev_week_set") {
        $content = "index.cgi?$std_get_data&calendar_key_date_start=$this->{key_date_prev_start}&calendar_key_date_end=$this->{key_date_prev_end}";
        
    } elsif ($te_type_name eq "cal_next_week_set") {
        $content = "index.cgi?$std_get_data&calendar_key_date_start=$this->{key_date_next_start}&calendar_key_date_end=$this->{key_date_next_end}";
    }
    
    $this->add_Content($content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    my $tld = $this->{tld};
    
    my $row_num = $tld->get_Row_Num;
    
    ### default all rows style
    if (defined($this->{row_style})) {
        for (my $i = 0; $i < $row_num; $i++) {
            $tld->set_Data($i, "row_style", $this->{row_style});
        }
    }
    
    ### both odd & even will overwrite previous default column style if any
    if (defined($this->{row_style_odd})) {
        for (my $i = 0; $i < $row_num; $i += 2) {
            $tld->set_Data($i, "row_style", $this->{row_style_odd});
        }
    }
    
    if (defined($this->{row_style_even})) {
        for (my $i = 1; $i < $row_num; $i += 2) {
            $tld->set_Data($i, "row_style", $this->{row_style_even});
        }
    }
    
    ### all will overwrite previous default column style if any
    for (my $i = 0; $i < $row_num; $i++) {
        if (defined($this->{row_style_current}) && $tld->get_Data($i, "current_week")) {
            $tld->set_Data($i, "row_style", $this->{row_style_current});
        }
        
        if (defined($this->{row_style_selected}) && $tld->get_Data($i, "selected")) {
            $tld->set_Data($i, "row_style", $this->{row_style_selected});
        }        
    
        if (defined($this->{date_column_style})) {
            $tld->set_Data($i, "date_column_style", $this->{date_column_style});
        }
        
        if (defined($this->{content_column_style})) {
            $tld->set_Data($i, "content_column_style", $this->{content_column_style});
        }        
        

    }
    
    #$cgi->add_Debug_Text($tld->get_Table_List, __FILE__, __LINE__);
    
    my $tldhtml = new TLD_HTML_Map;

    $tldhtml->set_Table_List_Data($tld);
    $tldhtml->set_HTML_Code($te_content);

    my $html_result = $tldhtml->get_HTML_Code;

    $this->add_Content($html_result);
}

sub generate_Week_List_TLD {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ###########################################################################
    
    ### get the week list data
    
    my @week_list = $this->get_Week_List;
    
    ###########################################################################
    my $today_ISO = $this->get_Today_ISO;
    
    my $calendar_ymd_selected = $cgi->param("calendar_ymd_selected");
    
    my $std_get_data = $cgi->generate_GET_Data("link_id");
    
    my @blank_row = ("", "", "", "", "", "", "", "", "");
    my @column_name = ("row_style", "date_column_style", "content_column_style", 
                       "current_week", "icon_selection", "selected",
                       "week_date_start", "week_date_end", "week_list_content");
               
    my $tld = new Table_List_Data;
    
    for ($i = 0; $i < @column_name; $i++) {
        $tld->add_Column($column_name[$i]);
    }
    
    foreach (my $i = 0; $i < @week_list; $i++) {
        $tld->add_Row_Data(@blank_row);
        
        if ($today_ISO ge $week_list[$i]->{iso_wd_start} && $today_ISO le $week_list[$i]->{iso_wd_end}) {
            $tld->set_Data($i, "current_week", 1);
            
        } else {
            $tld->set_Data($i, "current_week", 0);
        }
        
        if ($calendar_ymd_selected ge $week_list[$i]->{iso_wd_start} &&
            $calendar_ymd_selected le $week_list[$i]->{iso_wd_end}) {
            $tld->set_Data($i, "selected", 1);
            $tld->set_Data($i, "icon_selection", $this->{icon_deselect});
            $tld->set_Data_Get_Link($i, "icon_selection", "index.cgi?$std_get_data&calendar_ymd_selected=", "title=\"Click to deselect week\"");
            
        } else {
            $tld->set_Data($i, "selected", 0);
            $tld->set_Data($i, "icon_selection", $this->{icon_select});
            $tld->set_Data_Get_Link($i, "icon_selection", "index.cgi?$std_get_data&calendar_ymd_selected=$week_list[$i]->{iso_wd_start}", "title=\"Click to select week\"");
        }
        
        $tld->set_Data($i, "week_date_start", $week_list[$i]->{iso_wd_start});
        $tld->set_Data($i, "week_date_end", $week_list[$i]->{iso_wd_end});
        
        my @week_date = @{$week_list[$i]->{week_date_ref}};
        
        my $week_list_content = undef;
        
        foreach my $item (@week_date) {
            my $date_content = $this->{map_date_content}->{$item->{iso_ymd}};

            if (defined($date_content)) {
                $week_list_content .= $date_content;
            }        
        }
        
        if (defined($week_list_content)) {
            $tld->set_Data($i, "week_list_content", $week_list_content);
        }
    }
    
    return $tld;
}

sub get_Week_List {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";    
    
    my @date_list = @{$this->{date_list_ref}};
    
    my @week_list = ();
    
    my $idx = 0; ### accross 7 days
    
    my $cal_id_first = undef;
    my $cal_id_last = undef;
    
    while ($idx < @date_list) {
        my $iso_date = $date_list[$idx]->{iso_ymd};
        
        my @week_date = $this->{calendar}->get_Weekly_Date_Info($iso_date);
        
        if ($idx == 0) {
            $cal_id_first = $week_date[0]->{cal_id};
        }

        my $last_idx = @week_date - 1;
        my $iso_wd_start = $week_date[0]->{iso_ymd};
        my $iso_wd_end = $week_date[$last_idx]->{iso_ymd};
        
        $cal_id_last = $week_date[$last_idx]->{cal_id};

        #$cgi->add_Debug_Text("$iso_wd_start - $iso_wd_end", __FILE__, __LINE__);

        push(@week_list, {iso_wd_start => $iso_wd_start, iso_wd_end => $iso_wd_end, week_date_ref => \@week_date});

        ### jump accross 7 days to make sure  
        ### the next date is for the next week
        $idx += 7;
    }
    
    ### need to do the next extra task in case of $this->{key_date_end} 
    ### is not covered in @week_list 
    if ($this->{key_date_end} gt $week_list[@week_list - 1]->{iso_wd_end} ) {
        my @week_date = $this->{calendar}->get_Weekly_Date_Info($this->{key_date_end});
        
        my $last_idx = @week_date - 1;
        my $iso_wd_start = $week_date[0]->{iso_ymd};
        my $iso_wd_end = $week_date[$last_idx]->{iso_ymd};
        
        $cal_id_last = $week_date[$last_idx]->{cal_id};
        
        push(@week_list, {iso_wd_start => $iso_wd_start, iso_wd_end => $iso_wd_end, week_date_ref => \@week_date});
    }
    
    ###########################################################################
    
    my $num_of_days = 7 * @week_list;
    
    #$cgi->add_Debug_Text("Num of days = " . $num_of_days, __FILE__, __LINE__);
    
    my $cal_id_prev_start = $cal_id_first;
    my $cal_id_prev_end = undef;
    
    my $cal_id_next_start = undef;
    my $cal_id_next_end = $cal_id_last;
    
    $dbu->set_Table($pre_table_name . "calendar");
    
    for (my $i = 0; $i < $num_of_days; $i++) {
        if ($i == 0) {
            $cal_id_prev_end = $dbu->get_Item("prev_cal_id", "cal_id", $cal_id_first);
            $cal_id_next_start = $dbu->get_Item("next_cal_id", "cal_id", $cal_id_last);  
        }
        
        $cal_id_prev_start = $dbu->get_Item("prev_cal_id", "cal_id", $cal_id_prev_start);
        $cal_id_next_end = $dbu->get_Item("next_cal_id", "cal_id", $cal_id_next_end);
    }
    
    $this->{key_date_prev_start} = $dbu->get_Item("iso_ymd", "cal_id", $cal_id_prev_start);
    $this->{key_date_prev_end} = $dbu->get_Item("iso_ymd", "cal_id", $cal_id_prev_end);
    
    $this->{key_date_next_start} = $dbu->get_Item("iso_ymd", "cal_id", $cal_id_next_start);
    $this->{key_date_next_end} =  $dbu->get_Item("iso_ymd", "cal_id", $cal_id_next_end);
    
    ###########################################################################
    
    return @week_list;
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    return $tld;
}

1;