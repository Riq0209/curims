package webman_calendar_weekly_timerow;

use webman_calendar_weekly;

@ISA=("webman_calendar_weekly");

sub new {
    my $class = shift @_;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{hour_start} = undef;
    $this->{hour_end} = undef;
    
    $this->{time_row_style} = undef;
    
    $this->{time_row_style_odd} = undef;
    $this->{time_row_style_even} = undef;
    
    $this->{time_row_style_current} = undef;
    $this->{time_row_style_selected} = undef;
    
    $this->{cell_style_current} = undef;
    $this->{cell_style_selected} = undef;
    
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

sub set_Default_Hour_Range {
    my $this = shift @_;
    
    $this->{hour_start} = shift @_;
    $this->{hour_end} = shift @_;
}

sub set_Default_Row_Style {
    my $this = shift @_;
    
    $this->{time_row_style} = shift @_;
    
    $this->{time_row_style_odd} = shift @_;
    $this->{time_row_style_even} = shift @_;
    
    $this->{time_row_style_current} = shift @_;
    $this->{time_row_style_selected} = shift @_;
}

sub set_Default_Cell_Style {
    my $this = shift @_;
    
    $this->{cell_style_current} = shift @_;
    $this->{cell_style_selected} = shift @_;
}

### 05/12/2011
sub add_Date_Content {
    my $this = shift @_;
    
    ### just overide the base module method 
}

### 6/12/2011
sub add_Date_Time_Content {
    my $this = shift @_;
    
    my $date_ISO = shift @_;
    my $time_ISO_start = shift @_;
    my $time_ISO_end = shift @_;
    my $date_time_content = shift @_;
    
    if (!defined($time_ISO_end)) {
        $time_ISO_end = $time_ISO_start;
    }
    
    if (!defined($this->{map_date_time_content})) {
        $this->{map_date_time_content} = {};
    }
    
    if (!defined($this->{map_date_time_content}->{$date_ISO})) {
        $this->{map_date_time_content}->{$date_ISO} = {};
    }
    
    my $time_key = $time_ISO_start . "-" . $time_ISO_end;
    
    if (!defined($this->{map_date_time_content}->{$date_ISO}->{$time_key})) {
        $this->{map_date_time_content}->{$date_ISO}->{$time_key} = {};
    }
    
    $this->{map_date_time_content}->{$date_ISO}->{$time_key}->{time_ISO_start} = $time_ISO_start;
    $this->{map_date_time_content}->{$date_ISO}->{$time_key}->{time_ISO_end} = $time_ISO_end;
    $this->{map_date_time_content}->{$date_ISO}->{$time_key}->{content} .= $date_time_content;
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
    
    ### generate $this->{tld_dtrc_data} and $this->{tld_dtrc_view}
    $this->generate_DTRC_TLD;
    
    $this->{tld_dtrc_view} = $this->process_TLD_DTRC_View($this->{tld_dtrc_view});
    
    $this->{tld_dtrc_data} = $this->customize_TLD($this->{tld_dtrc_data});
    $this->{tld_dtrc_view} = $this->customize_TLD($this->{tld_dtrc_view});
    
    #$cgi->add_Debug_Text($this->{tld_dtrc_data}->get_Table_List, __FILE__, __LINE__);
    #$cgi->add_Debug_Text($this->{tld_dtrc_view}->get_Table_List, __FILE__, __LINE__);
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
                
    } elsif ($te_type_name eq "row_view_content") { 
        $tld = $this->{tld_dtrc_view};
    }    
    
    
    my $tldhtml = new TLD_HTML_Map;
    
    $tldhtml->set_Table_List_Data($tld);
    $tldhtml->set_HTML_Code($te_content);

    my $html_result = $tldhtml->get_HTML_Code;    

    $this->add_Content($html_result);
}

sub process_TLD_DTRC_View {
    my $this = shift @_;
    my $tld = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ### $this->{current_week_day} is created from inside 
    ### the base class (webman_calendar_weekly)
    my $day_num_current = $this->{calendar}->{day_num}->{$this->{current_week_day}};
   
    my $day_num_selected = $cgi->param("calendar_day");
    my $calendar_ymd_selected = $cgi->param("calendar_ymd_selected");
    my $calendar_hms_start = $cgi->param("calendar_hms_start");
    my $calendar_hms_end = $cgi->param("calendar_hms_end");
    
    my $row_num = $tld->get_Row_Num;
    
    for (my $i = 0; $i < $row_num; $i++) {
        if (defined($this->{time_row_style})) {
            $tld->set_Data($i, "row_style", $this->{time_row_style});
        }
        
        if (($i % 2) != 0) {
            if (defined($this->{time_row_style_odd})) {
                $tld->set_Data($i, "row_style", $this->{time_row_style_odd});
            }
            
        } else {
            if (defined($this->{time_row_style_even})) {
                $tld->set_Data($i, "row_style", $this->{time_row_style_even});
            }
        }
        
        if (defined($this->{time_row_style_current}) && $tld->get_Data($i, "current_time")) {
            $tld->set_Data($i, "row_style", $this->{time_row_style_current});
        }
        
        if (defined($this->{time_row_style_selected}) && 
            $tld->get_Data($i, "time_start") eq $calendar_hms_start) {
            
            $tld->set_Data($i, "row_style", $this->{time_row_style_selected});
            
            for (my $day = 1; $day <= 7; $day++) {
                $tld->set_Data($i, "day" . $day . "_column_style", $this->{time_row_style_selected});
            }
        }        
        
        if (defined($this->{cell_style_current}) && $tld->get_Data($i, "current_time")) {
            $tld->set_Data($i, "day" . $day_num_current . "_column_style", $this->{cell_style_current});
        }
        
        if (defined($this->{cell_style_selected}) && 
            $tld->get_Data($i, "time_start") eq $calendar_hms_start &&
            $this->{tld_col_date}->get_Data($day_num_selected - 1, date_iso) eq $calendar_ymd_selected) {
            $tld->set_Data($i, "day" . $day_num_selected . "_column_style", $this->{cell_style_selected});
        }        
    
    }
    
    return $tld;
}

sub generate_DTRC_TLD { ### DTRC stand for day-time row content
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $current_time_ISO = $this->get_Time_ISO;
    
    ###########################################################################
    
    my @blank_row = ("", 0, 0, "", "", "", 
                     "0000-00-00", "", "");
    my @column_name = ("column_style", "current_date", "current_time", "week_day", "week_date", "week_date_time_content", 
                       "date_iso", "time_start", "time_end");
               
    my $tld_dtrc_data = new Table_List_Data;
    
    for (my $i = 0; $i < @column_name; $i++) {
        $tld_dtrc_data->add_Column($column_name[$i]);
    }
    
    ###########################################################################
    
    #$cgi->add_Debug_Text($this->{tld_col_content}->get_Table_List, __FILE__, __LINE__);
    
    my $row_idx = 0;
    my $col_total = $this->{tld_col_content}->get_Column_Num;
    
    if (!defined($this->{hour_start})) {
        $this->{hour_start} = 8;
    }
    
    if (!defined($this->{hour_end})) {
        $this->{hour_end} = 17;
    }
    
    #$cgi->add_Debug_Text("From $this->{hour_start} to $this->{hour_end}", __FILE__, __LINE__);
    
    for (my $hour = $this->{hour_start}; $hour < $this->{hour_end}; $hour++) {
        
        for (my $day = 0; $day < 7; $day++) {
            
            $tld_dtrc_data->add_Row_Data(@blank_row);
            
            ### copy all column data from $this->{tld_col_content} to $tld_dtrc_data
            for (my $col_num = 0; $col_num < $col_total; $col_num++) {
                my $column_name = $this->{tld_col_content}->get_Column_Name($col_num);
                
                my $column_data = $this->{tld_col_content}->get_Data($day, $column_name);
                
                $tld_dtrc_data->set_Data($row_idx, $column_name, $column_data);
            }
            
            my $hour_start = $hour;
            my $hour_end = $hour;
            
            if ($hour < 10) {
                $hour_start = "0" . $hour_start;
                $hour_end = "0" . $hour_end;
            }
            
            my $time_start = "$hour_start:00:00";
            my $time_end = "$hour_end:59:59";
            
            if ($current_time_ISO ge $time_start && $current_time_ISO le $time_end) {
                $tld_dtrc_data->set_Data($row_idx, "current_time", 1);
            }
            
            $tld_dtrc_data->set_Data($row_idx, "time_start", $time_start);
            $tld_dtrc_data->set_Data($row_idx, "time_end", $time_end);
            
            
            my $date_ISO = $tld_dtrc_data->get_Data($row_idx, "date_iso");

            if (defined($this->{map_date_time_content}->{$date_ISO})) {
                my $content_str = undef;
                
                my @keys = sort(keys(%{$this->{map_date_time_content}->{$date_ISO}}));
                
                foreach my $key (@keys) {
                    my $time_ISO_start = $this->{map_date_time_content}->{$date_ISO}->{$key}->{time_ISO_start};
                    my $time_ISO_end = $this->{map_date_time_content}->{$date_ISO}->{$key}->{time_ISO_end};
                    
                    if ($time_ISO_start ge $time_start && $time_ISO_start le $time_end) {
                        $content_str .= $this->{map_date_time_content}->{$date_ISO}->{$key}->{content};
                    }
                    
                    if ($time_ISO_start lt $time_start && $time_ISO_end gt $time_start) {
                        $content_str .= $this->{map_date_time_content}->{$date_ISO}->{$key}->{content};
                    }
                    
                    $tld_dtrc_data->set_Data($row_idx, "week_date_time_content", $content_str);
                }
            }
            
            $row_idx++;
        }
    }
    
    #$cgi->add_Debug_Text($tld_dtrc_data->get_Table_List, __FILE__, __LINE__);
    
    $this->{tld_dtrc_data} = $tld_dtrc_data;
    
    ###########################################################################
    
    my @blank_row = ("", 0, "", "", 
                     "", "", "", "", "", "", "",
                     "", "", "", "", "", "", "");
                     
    my @column_name = ("row_style", "current_time", "time_start", "time_end",
                       "day1_content", "day2_content", "day3_content","day4_content","day5_content","day6_content","day7_content",
                       "day1_column_style", "day2_column_style", "day3_column_style","day4_column_style","day5_column_style","day6_column_style","day7_column_style");
    
    ### the $tld_dtrc_view is mainly purpose for presentation only
    ### and the real data structure is stored inside $tld_dtrc_data
    my $tld_dtrc_view = new Table_List_Data;
    
    for (my $i = 0; $i < @column_name; $i++) {
        $tld_dtrc_view->add_Column($column_name[$i]);
    }
    
    my $data_row_num = $this->{tld_dtrc_data}->get_Row_Num;
    
    my $time_idx = -1;
    my $day_num = 1;
    
    for (my $idx = 0; $idx < $data_row_num; $idx++) {
        if ($this->{tld_dtrc_data}->get_Data($idx, "week_day") eq "Mon") {
            ### update $time_idx counter, reset $day_num, and 
            ### add new row in view TLD for each time row
            $time_idx++;
            $day_num = 1;
            $tld_dtrc_view->add_Row_Data(@blank_row);
            
            my $time_start = $this->{tld_dtrc_data}->get_Data($idx, "time_start");
            my $time_end = $this->{tld_dtrc_data}->get_Data($idx, "time_end");
            
            if ($current_time_ISO ge $time_start && $current_time_ISO le $time_end) {
                $tld_dtrc_view->set_Data($time_idx, "current_time", 1);
            }
            
            $tld_dtrc_view->set_Data($time_idx, "time_start", $time_start);
            $tld_dtrc_view->set_Data($time_idx, "time_end", $time_end);
            
            #$cgi->add_Debug_Text("Found Mon", __FILE__, __LINE__);
        }
        
        ### next are applied on each $day_num: Mon -> Sun
        $tld_dtrc_view->set_Data($time_idx, 
                                 "day" . $day_num . "_content", 
                                 $this->{tld_dtrc_data}->get_Data($idx, "week_date_time_content"));
                                 
        $tld_dtrc_view->set_Data($time_idx, 
                                 "day" . $day_num . "_column_style", 
                                 $this->{tld_dtrc_data}->get_Data($idx, "column_style"));
        
        
        $day_num++;
        
    }
    
    #$cgi->add_Debug_Text($tld_dtrc_view->get_Table_List, __FILE__, __LINE__);
    
    $this->{tld_dtrc_view} = $tld_dtrc_view;
}

### synchronize columns inside $this->{tld_dtrc_view} with  
### new columns added to $this->{tld_dtrc_data} 
sub synchronize_Data_View {
    my $this = shift @_;

    ### new column added to $this->{tld_dtrc_data}
    my $column_added = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ### add new column inside $this->{tld_dtrc_view}
    ### to support view for previous new column added 
    ### inside $this->{tld_dtrc_data}
    for (my $cell_num = 1; $cell_num <= 7; $cell_num++) {
        $this->{tld_dtrc_view}->add_Column($column_added . $cell_num);
    }
    
    ### operations on new column inside $this->{tld_dtrc_view}
    ### to support view of previous new column added to
    ### $this->{tld_dtrc_data}
    my $data_row_num = $this->{tld_dtrc_data}->get_Row_Num;

    my $time_idx = -1;
    my $day_num = 1;

    for (my $idx = 0; $idx < $data_row_num; $idx++) {
        if ($this->{tld_dtrc_data}->get_Data($idx, "week_day") eq "Mon") {
            ### update $time_idx counter and 
            ### reset $day_num for each time row
            $time_idx++;
            $day_num = 1;                
        }

        ### next are applied on each $day_num: Mon -> Sun
        $this->{tld_dtrc_view}->set_Data($time_idx, 
                                         $column_added . $day_num,
                                         $this->{tld_dtrc_data}->get_Data($idx, $column_added));

        my $get_link = $this->{tld_dtrc_data}->get_Data_Get_Link($idx, $column_added);
        
        if ($get_link ne "") {
            ### if $this->{tld_dtrc_data}->set_Data_Get_Link(???) 
            ### is applied while customizing $this->{tld_dtrc_data} 
            ### inside $this->customize_TLD
            my $get_link_properties = $this->{tld_dtrc_data}->get_Data_Get_Link_Properties($idx, $column_added);
            $this->{tld_dtrc_view}->set_Data_Get_Link($time_idx, $column_added . $day_num, 
                                                      $get_link, $get_link_properties);
        }

        $day_num++;
    }   
}

1;