package webman_calendar_weekly;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{key_date} = undef;
    
    $this->{date_column_style} = undef;
    
    $this->{date_column_style_odd} = undef;
    $this->{date_column_style_even} = undef;
    
    $this->{date_column_style_current} = undef;
    
    ### functional with proposed customized module in code ref.
    $this->{date_column_style_selected} = undef;
    
    $this->{content_column_style} = undef;
    
    $this->{content_column_style_odd} = undef;
    $this->{content_column_style_even} = undef;
    
    $this->{content_column_style_current} = undef;
    
    ### functional with proposed customized module in code ref.
    $this->{content_column_style_selected} = undef;
    
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

sub set_Key_Date {
    my $this = shift @_;
    
    $this->{key_date} = shift @_;
}

sub set_Default_Date_Column_Style {
    my $this = shift @_;
    
    $this->{date_column_style} = shift @_;
    
    $this->{date_column_style_odd} = shift @_;
    $this->{date_column_style_even} = shift @_;
    
    $this->{date_column_style_current} = shift @_;
    $this->{date_column_style_selected} = shift @_;    
}

sub set_Default_Content_Column_Style {
    my $this = shift @_;
    
    $this->{content_column_style} = shift @_;
    
    $this->{content_column_style_odd} = shift @_;
    $this->{content_column_style_even} = shift @_;
    
    $this->{content_column_style_current} = shift @_;
    $this->{content_column_style_selected} = shift @_;    
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
    
    $this->SUPER::run_Task();
    
    ###########################################################################
    
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
    
    $this->{today_iso} = $this->get_Today_ISO;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";

    $dbu->set_Table($pre_table_name . "calendar");
    
    #$cgi->add_Debug_Text("\$this->{key_date} = $this->{key_date}", __FILE__, __LINE__);
    
    if ($cgi->param("calendar_key_date") ne "") { 
        $this->{key_date} = $cgi->param("calendar_key_date");
    }
    
    if (!defined($this->{key_date})) {
        $this->{key_date} = $this->{today_iso};
    }
    
    #$cgi->add_Debug_Text("\$this->{key_date} = $this->{key_date}", __FILE__, __LINE__);
    
    ### really need this style of coding or can't differentiate the 
    ### TLD instance for date and content inside $this->customize_TLD
    ### function
    $this->{tld_col_date} = $this->generate_Week_Date_TLD;
    $this->{tld_col_content} = $this->generate_Week_Date_Content_TLD;
    
    $this->{tld_col_date} = $this->process_TLD_Date($this->{tld_col_date});
    $this->{tld_col_content} = $this->process_TLD_Content($this->{tld_col_content});
    
    $this->{tld_col_date} = $this->customize_TLD($this->{tld_col_date});
    $this->{tld_col_content} = $this->customize_TLD($this->{tld_col_content});
    
    ###########################################################################
    
    #$cgi->add_Debug_Text($this->{tld_col_date}->get_Table_List, __FILE__, __LINE__);
    #$cgi->add_Debug_Text($this->{tld_col_content}->get_Table_List, __FILE__, __LINE__);
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

    if ($te_type_name eq "cal_prev_week") {
        $content = "index.cgi?$std_get_data&calendar_key_date=$this->{key_date_prev}";
        
    } elsif ($te_type_name eq "cal_next_week") {
        $content = "index.cgi?$std_get_data&calendar_key_date=$this->{key_date_next}";
    }
    
    $this->add_Content($content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $tld = undef;
    
    my $calendar_ymd_selected = $cgi->param("calendar_ymd_selected");
    
    if ($te_type_name eq "col_view_day") {
        $tld = $this->{tld_col_date};
                
    } elsif ($te_type_name eq "col_view_content") {
        $tld = $this->{tld_col_content};        
    }    
    
    
    my $tldhtml = new TLD_HTML_Map;
    
    $tldhtml->set_Table_List_Data($tld);
    $tldhtml->set_HTML_Code($te_content);

    my $html_result = $tldhtml->get_HTML_Code;    
    
    $this->add_Content($html_result);
}

sub process_TLD_Date {
    my $this = shift @_;
    my $tld = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my %odd_day = ("Mon" => 1, "Wed" => 1, "Fri" => 1, "Sun" => 1);
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $calendar_ymd_selected = $cgi->param("calendar_ymd_selected");
    
    ### each row inside $tld is actually represent the column date
    my $row_num = $tld->get_Row_Num;

    for (my $i = 0; $i < $row_num; $i++) {
        ### default all date column style
        if (defined($this->{date_column_style})) {
            $tld->set_Data($i, "column_style", $this->{date_column_style});
        }

        if ($odd_day{$tld->get_Data($i, "week_day")}) {
            if (defined($this->{date_column_style_odd})) {
                $tld->set_Data($i, "column_style", $this->{date_column_style_odd});
            }

        } else {
            if (defined($this->{date_column_style_even})) {
                $tld->set_Data($i, "column_style", $this->{date_column_style_even});
            }                
        }

        ### overwrite previous default column style if any
        if (defined($this->{date_column_style_current}) && $tld->get_Data($i, "current_date")) {
            $tld->set_Data($i, "column_style", $this->{date_column_style_current});
        }

        ### overwrite previous default column style if any
        if (defined($this->{date_column_style_selected}) && $tld->get_Data($i, "date_iso") eq $calendar_ymd_selected) {
            $tld->set_Data($i, "column_style", $this->{date_column_style_selected});
        }            
    }
    
    return $tld;
}

sub process_TLD_Content {
    my $this = shift @_;
    my $tld = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my %odd_day = ("Mon" => 1, "Wed" => 1, "Fri" => 1, "Sun" => 1);
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $calendar_ymd_selected = $cgi->param("calendar_ymd_selected");
    
    ### each row inside $tld is actually represent the column date
    my $row_num = $tld->get_Row_Num;

    ### the next loop will overwrite the hard-coded customization
    for (my $i = 0; $i < $row_num; $i++) {
        ### default all content column style
        if (defined($this->{content_column_style})) {
            $tld->set_Data($i, "column_style", $this->{content_column_style});
        }

        if ($odd_day{$tld->get_Data($i, "week_day")}) {
            if (defined($this->{content_column_style_odd})) {
                $tld->set_Data($i, "column_style", $this->{content_column_style_odd});
            }

        } else {                
            if (defined($this->{content_column_style_even})) {
                $tld->set_Data($i, "column_style", $this->{content_column_style_even});
            }                 
        }            

        ### overwrite previous default column style if any
        if (defined($this->{content_column_style_current}) && $tld->get_Data($i, "current_date")) {
            $tld->set_Data($i, "column_style", $this->{content_column_style_current});
        }

        ### overwrite previous default column style if any
        if (defined($this->{content_column_style_selected}) && $tld->get_Data($i, "date_iso") eq $calendar_ymd_selected) {
            $tld->set_Data($i, "column_style", $this->{content_column_style_selected});
        }            
    }
    
    return $tld;
}

sub generate_Week_Date_TLD {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ###########################################################################
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my @blank_row = ("", "", "", "", "0000-00-00");
    my @column_name = ("column_style", "current_date", "week_day", "week_date", "date_iso");
               
    my $tld = new Table_List_Data;
    
    for ($i = 0; $i < @column_name; $i++) {
        $tld->add_Column($column_name[$i]);
    }
    
    ### get the week list data
    my @week_date = $this->{calendar}->get_Weekly_Date_Info($this->{key_date});
    
    $this->{week_date_ref} = \@week_date;
    
    foreach (my $i = 0; $i < @week_date; $i++) {
        $tld->add_Row_Data(@blank_row);
        
        $tld->set_Data($i, "week_day", $week_date[$i]->{day_abbr});
        $tld->set_Data($i, "week_date", $week_date[$i]->{iso_ymd});
        
        if ($week_date[$i]->{iso_ymd} eq $this->{today_iso}) {
            $tld->set_Data($i, "current_date", 1);
            $this->{current_week_day} = $week_date[$i]->{day_abbr};
            
        } else {
            $tld->set_Data($i, "current_date", 0);
        }
        
        $tld->set_Data($i, "date_iso", $week_date[$i]->{iso_ymd});
    }
    
    my $cal_id_first = $week_date[0]->{cal_id};
    my $cal_id_last = $week_date[@week_date - 1]->{cal_id};
    
    $dbu->set_Table($pre_table_name . "calendar");
    
    $this->{key_date_prev} = $dbu->get_Item("iso_ymd", "next_cal_id", $cal_id_first);
    $this->{key_date_next} = $dbu->get_Item("iso_ymd", "prev_cal_id", $cal_id_last);
    
    return $tld;
}

sub generate_Week_Date_Content_TLD {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ###########################################################################
    
    my @blank_row = ("", "", "", "", "", "0000-00-00");
    my @column_name = ("column_style", "current_date", "week_day", "week_date", "week_date_content", "date_iso");
               
    my $tld = new Table_List_Data;
    
    for (my $i = 0; $i < @column_name; $i++) {
        $tld->add_Column($column_name[$i]);
    }
    
    ### get the week list data
    my @week_date = @{$this->{week_date_ref}};
    
    foreach (my $i = 0; $i < @week_date; $i++) {
        $tld->add_Row_Data(@blank_row);
        
        $tld->set_Data($i, "week_day", $week_date[$i]->{day_abbr});
        $tld->set_Data($i, "week_date", $week_date[$i]->{iso_ymd});        
        
        if ($week_date[$i]->{iso_ymd} eq $this->{today_iso}) {
            $tld->set_Data($i, "current_date", 1); 
            
        } else {
            $tld->set_Data($i, "current_date", 0);
        }

        my $date_content = $this->{map_date_content}->{$week_date[$i]->{iso_ymd}};

        if (defined($date_content)) {
            $tld->set_Data($i, "week_date_content", $date_content);
            
        } else {
            $tld->set_Data($i, "week_date_content", "&nbsp;");
        }
        
        $tld->set_Data($i, "date_iso", $week_date[$i]->{iso_ymd});
    }
    
    return $tld;    
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