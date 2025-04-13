package webman_calendar_interactive;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
    
    my $this = $class->SUPER::new();
    
    $this->{template_default} = undef;
    
    $this->{text_color_date} = undef;
    $this->{text_color_date_current} = undef;
    $this->{text_color_date_selected} = undef;
    
    $this->{cell_color_date} = undef;
    $this->{cell_color_date_current} = undef;
    $this->{cell_color_date_selected} = undef;
    
    $this->{column_color_odd} = undef;
    $this->{column_color_even} = undef;    
    
    $this->{row_color_odd} = undef;
    $this->{row_color_even} = undef;    
    
    #$this->set_Debug_Mode(1, 1);
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    $this->{template_default} = shift @_;
}

###############################################################################

sub set_Default_Text_Colors {
    my $this = shift @_;
    
    $this->{text_color_date} = shift @_;
    $this->{text_color_date_current} = shift @_;
    $this->{text_color_date_selected} = shift @_;
}

sub set_Default_Cell_Colors {
    my $this = shift @_;
    
    $this->{cell_color_date} = shift @_;
    $this->{cell_color_date_current} = shift @_;
    $this->{cell_color_date_selected} = shift @_;
}

sub set_Default_Column_Color {
    my $this = shift @_;
    
    $this->{column_color_odd} = shift @_;
    $this->{column_color_even} = shift @_;    
}

sub set_Default_Row_Color {
    my $this = shift @_;
    
    $this->{row_color_odd} = shift @_;
    $this->{row_color_even} = shift @_;     
}

###############################################################################

sub set_Date_Text_Color {
    my $this = shift @_;
    
    my $date_ISO = shift @_;
    my $color = shift @_;
    
    if (!defined($this->{map_date_text_color})) {
        $this->{map_date_text_color} = {};
    }
    
    $this->{map_date_text_color}->{$date_ISO} = "bgcolor=\"$color\"";
}

sub set_Date_Cell_Color {
    my $this = shift @_;
    
    my $date_ISO = shift @_;
    my $color = shift @_;
    
    if (!defined($this->{map_date_cell_color})) {
        $this->{map_date_cell_color} = {};
    }
    
    $this->{map_date_cell_color}->{$date_ISO} = "bgcolor=\"$color\"";    
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
    
    $this->SUPER::run_Task();
    
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
    
    ### handle prev,current, and next active/selected month-year ##############
    
    my $active_year = undef;
    my $active_month = undef;
    
    my $next_active_year = undef;
    my $next_active_month = undef;
    
    my $prev_active_year = undef;
    my $prev_active_month = undef;
    
    if ($cgi->param("calendar_year") ne "") {
        $active_year = $cgi->param("calendar_year");
        
    } else {
        $active_year = $this->{current_year};
    }
    
    $next_active_year = $active_year;
    $prev_active_year = $active_year;
    
    if ($cgi->param("calendar_month") ne "") {
        $active_month = $cgi->param("calendar_month");
        
    } else {
        $active_month = $this->{current_month};
    }
    
    my $month_to_num = $calendar->{month_num}->{$active_month};
    
    $next_active_month = $month_to_num + 1;
    $prev_active_month = $month_to_num - 1;
    
    if ($next_active_month > 12) { 
        $next_active_month = 1; 
        $next_active_year++;
    }
    
    if ($prev_active_month < 1 ) { 
        $prev_active_month = 12;
        $prev_active_year--;
    }
    
    $next_active_month = $calendar->{num_month}->{$next_active_month};
    $prev_active_month = $calendar->{num_month}->{$prev_active_month};
    
    
    $this->{prev_active_year} = $prev_active_year;
    $this->{prev_active_month} = $prev_active_month;
    $this->{active_year} = $active_year;
    $this->{active_month} = $active_month;
    $this->{next_active_year} = $next_active_year;
    $this->{next_active_month} = $next_active_month;    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>";
    
    $this->set_Template_File($this->{template_default});
    
    $this->SUPER::process_Content;  
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    

    $te_content =~ s/\$active_month_/$this->{active_month}/;    
    $te_content =~ s/\$active_year_/$this->{active_year}/;
    
    $this->add_Content($te_content);
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $te_content = $te->get_Content;
    my $te_type_name = $te->get_Name;
    
    my $content = undef;
    
    my $std_get_data = $cgi->generate_GET_Data("link_id");

    if ($te_type_name eq "cal_prev_month_link") {
        $content = "index.cgi?$std_get_data&calendar_year=$this->{prev_active_year}&calendar_month=$this->{prev_active_month}";
        
    } elsif ($te_type_name eq "cal_next_month_link") {
        $content = "index.cgi?$std_get_data&calendar_year=$this->{next_active_year}&calendar_month=$this->{next_active_month}";
    }
    
    $this->add_Content($content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    #if ($this->{cell_color_date} eq undef) { $this->{cell_color_date}= "#F4F5FB"; }
    #if ($this->{cell_color_date_current} eq undef) { $this->{cell_color_date_current} = "#F4F5FB"; }
    #if ($this->{cell_color_date_selected} eq undef) { $this->{cell_color_date_selected} = "#FFE2C4"; }
        
    #if ($this->{text_color_date} eq undef) { $this->{text_color_date} = "#0000FF"; }
    #if ($this->{text_color_date_current} eq undef) { $this->{text_color_date_current} = "#0000FF"; }
    if ($this->{text_color_date_selected} eq undef) { $this->{text_color_date_selected} = "#FF0000"; }
    
    my $current_year = $this->{current_year};
    my $current_month = $this->{current_month};
    my $current_date = $this->{current_date};
    
    my $year = undef;
    my $month = undef;
    my $date = undef;
    my $day = undef;
    
    if ($cgi->param("calendar_year") ne "") {
        $year = $cgi->param("calendar_year");
        
    } else {
        $year = $this->{current_year};
    }
    
    if ($cgi->param("calendar_month") ne "") {
        $month = $cgi->param("calendar_month");
        
    } else {
        $month = $this->{current_month};
    }
    
    $date = $cgi->param("calendar_date");
    $day = $cgi->param("calendar_day");
    
    $dbu->set_Table($pre_table_name . "calendar");
    
    #################################################################################
    ### Next we should check if $year is not exist in DB. If not exist then try to 
    ### get the first day of available years (forward/backward) then call the method
    ### init_Calendar_Table_Forward / init_Calendar_Table_Backward
    
    if (!$dbu->find_Item("year month date", "$year 1 1")) {
        my $year_first_day = undef;
        my $year_last_day = undef;
        
        if ($dbu->find_Item("year month date", $year + 1 . " 1 1")) { ### forward year
            $year_last_day = $dbu->get_Item("day", "year month date", $year + 1 . " 1 1") - 1;
            
            if ($year_last_day < 1) { 
                $year_last_day = 7; 
            }
            
            $this->{calendar}->init_Calendar_Table_Backward($year, "12", "31", $year_last_day);
            
            $this->{calendar}->merge_Cal_ID_Link_Year;
            
        } elsif ($dbu->find_Item("year month date", $year - 1 . " 12 31")) { ### backward year
            $year_first_day = $dbu->get_Item("day", "year month date", $year - 1 . " 12 31") + 1;
            
            if ($year_first_day > 7) { 
                $year_first_day = 1;
            }
            
            $this->{calendar}->init_Calendar_Table_Forward($year, "1", "1", $year_first_day);
            
            $this->{calendar}->merge_Cal_ID_Link_Year;
        }
    }
    
    ###########################################################################
    
    #my @month_list = $dbu->get_Items("date day", "year month_abbr", "$year $month", "date");
    my @month_list = $this->{calendar}->get_Monthly_Date_Info($year, $month);
    
    #print $dbu->get_SQL . "<br>";
    
    my $i = 0;
    my $j = 0;
    my $k = 0;
    my $row_num = 0;
    my @blank_row = ("", "", "", "", "", "", "",
                     "", "", "", "", "", "", "",
                     "", "", "", "", "", "", "",
                     "", "", "", "", "", "", "");
    
    my @column_name = ("date1", "date2", "date3", "date4", "date5", "date6", "date7",
                       "cell1_color", "cell2_color", "cell3_color", "cell4_color", "cell5_color", "cell6_color", "cell7_color",
                       "date1_iso", "date2_iso", "date3_iso", "date4_iso", "date5_iso", "date6_iso", "date7_iso",
                       "date1_content", "date2_content", "date3_content", "date4_content", "date5_content", "date6_content", "date7_content");
               
    my $tld = new Table_List_Data;
    
    for ($i = 0; $i < @column_name; $i++) {
        $tld->add_Column($column_name[$i]);
    }
    
    my $cc = $this->{cell_color_date};
    
    my @date_data = ("", "", "", "", "", "", "");
    my @date_data_iso = ("", "", "", "", "", "", "");
    my @cell_color = ($cc , $cc , $cc , $cc , $cc , $cc , $cc);
    
    my $tld_row_day_start = "0_" .  $month_list[0]->{"day"};

    if ($month_list[0]->{"day"} > 1) {
        for (my $i = $month_list[0]->{"day"} - 1; $i > 0; $i--) {
            $date_data[$i - 1] = "-";
        }
    }
    
    ### set color at column level
    @cell_color = $this->set_Column_Level_Color(\@cell_color);
        
    ### set color at row level
    @cell_color = $this->set_Row_Level_Color(\@cell_color, 1);
    
    for (my $i = 0; $i < @month_list; $i++) {
        $date_data[$month_list[$i]->{"day"} - 1] = $month_list[$i]->{"date"};
        $date_data_iso[$month_list[$i]->{"day"} - 1] = $month_list[$i]->{"iso_ymd"};
        
        if ($month_list[$i]->{"day"} == 7 && $i < @month_list - 1) { ### need $i < @month_list - 1 to check if have reach max days of selected month
            $tld->add_Row_Data(@blank_row);
            
            for (my $j = 0; $j < 7; $j++) {
                $tld->set_Data($row_num, $column_name[$j], $date_data[$j]);
                $tld->set_Data($row_num, $column_name[$j + 7], "bgcolor=" . $cell_color[$j]);
                $tld->set_Data($row_num, $column_name[$j + 14], $date_data_iso[$j]);
            }
            
            @date_data = ("", "", "", "", "", "", "");
            @date_data_iso = ("", "", "", "", "", "", "");
            @cell_color = ($cc , $cc , $cc , $cc , $cc , $cc , $cc);
            $row_num++;
            
            ### set color at column level
            @cell_color = $this->set_Column_Level_Color(\@cell_color);

            ### set color at row level
            @cell_color = $this->set_Row_Level_Color(\@cell_color, $row_num + 1);            
        }
    }
    
    $tld->add_Row_Data(@blank_row);
    
    if ($month_list[@month_list - 1]->{"day"} < 7) {
        for (my $i = $month_list[@month_list - 1]->{"day"} + 1; $i <= 7; $i++) {
            $date_data[$i - 1] = "-";
        }
    }    
    
    for (my $j = 0; $j < @date_data; $j++) {
        $tld->set_Data($row_num, $column_name[$j], $date_data[$j]);
        $tld->set_Data($row_num, $column_name[$j + 7], "bgcolor=" . $cell_color[$j]);
        $tld->set_Data($row_num, $column_name[$j + 14], $date_data_iso[$j]);
    }
    
    my $tld_row_day_end = $tld->get_Row_Num - 1 . "_" .  $month_list[@month_list - 1]->{"day"};
    
    ###########################################################################
    
    my $get_data = undef;
    
    my $std_get_data = $cgi->generate_GET_Data("link_id");
    
    my $col_data_fmt = undef;
    my $date_text_color = undef;
    my $date_cell_color = undef;
    my $day = undef;
    
    my $date_processed = undef;
    my $date_ISO = undef;
    
    my $calendar_ymd_selected = $cgi->param("calendar_ymd_selected");
    
    #$cgi->add_Debug_Text($tld->get_Table_List, __FILE__, __LINE__);
    
    $this->{tld} = $this->customize_TLD($tld);
    
    for (my $i = 0; $i < $tld->get_Row_Num; $i++) {
        for (my $j = 0; $j < 7; $j++) {
            $day = $j + 1;
            
            $date_processed = $tld->get_Data($i, $column_name[$j]);
            
            my $tld_row_day_cur = $i . "_" . $day;
            
            if ($date_processed ne "") {
                my $full_date = "$year-$month-$date_processed";
                
                #$cgi->add_Debug_Text("\$full_date = $full_date", __FILE__, __LINE__);
                
                my @date_info = split(/\-/, $full_date);
            
                $date_info[1] = $this->{calendar}->{month_num}->{$date_info[1]};
            
                if ($date_info[1] < 10) { $date_info[1] = "0" . $date_info[1]; }
                if ($date_info[2] < 10) { $date_info[2] = "0" . $date_info[2]; }
            
                $date_ISO = "$year-$date_info[1]-$date_info[2]";
                
                #if ($date_info[2] > 0) {
                #    $tld->set_Data($i, $column_name[$j + 14], $date_ISO);
                #}
            }
            
            $get_data  = "$std_get_data&calendar_year=$year&calendar_month=$month&";
            $get_data .= "calendar_date=" . $tld->get_Data($i, $column_name[$j]) . "&calendar_day=" . $day . "&";
            $get_data .= "calendar_ymd_selected=$date_ISO";
            
            #$cgi->add_Debug_Text("$tld_row_day_cur : $tld_row_day_start : $tld_row_day_end", __FILE__, __LINE__, "TRACING");
            
            if ($tld_row_day_cur ge $tld_row_day_start && $tld_row_day_cur le $tld_row_day_end) {
                if ($date_ISO eq $calendar_ymd_selected) {
                    $tld->set_Data_Get_Link($i, $column_name[$j], "index.cgi?$std_get_data&calendar_date=&calendar_day=&calendar_ymd_selected=", "title=\"Click to deselect date\"");
                    
                } else {
                    $tld->set_Data_Get_Link($i, $column_name[$j], "index.cgi?$get_data", "title=\"Click to select date\"");
                }

                if ($date_processed == $current_date && $month eq $current_month && $year == $current_year) {
                    if ($date != $date_processed) {
                        $date_text_color = $this->{text_color_date_current};
                        $date_cell_color = $this->{cell_color_date_current};
                        
                    } else {
                        $date_text_color = $this->{text_color_date_selected};
                        $date_cell_color = $this->{cell_color_date_selected};
                    }

                    if ($date_text_color ne "") {
                        $col_data_fmt = "<b><font color=\"$date_text_color\">" . $date_processed . "</font></b>";
                        
                    } else {
                        $col_data_fmt = "<b>$date_processed</b>";
                    }

                } else {
                
                    if ($date_ISO eq $calendar_ymd_selected) {
                        $date_text_color = $this->{text_color_date_selected};
                        $date_cell_color = $this->{cell_color_date_selected};
                        
                    } else {
                        $date_text_color = $this->{text_color_date};
                        $date_cell_color = $this->{cell_color_date};                        
                    }
                    
                    if ($date_text_color ne "") {
                        $col_data_fmt = "<font color=\"$date_text_color\">" . $date_processed . "</font>";
                        
                    } else {
                        $col_data_fmt = $date_processed;
                    }
                }
                
                $tld->set_Data($i, $column_name[$j], $col_data_fmt);
                
                if ($date_cell_color ne "") {
                    $tld->set_Data($i, $column_name[$j + 7], "bgcolor=" . $date_cell_color);
                }                 
                
                
                ### 05/12/2011 
                ###############################################################                
                
                if ($this->{cell_color_date_selected} ne "" && $date != $date_processed) {
                    my $date_cell_color = $this->{map_date_cell_color}->{$date_ISO};

                    if (defined($date_cell_color)) {
                        ### will overwrite the default cell color for date, 
                        ### and date current but not date selected
                        $tld->set_Data($i, $column_name[$j + 7], $date_cell_color);
                    }
                }
                
                if ($this->{text_color_date_selected} ne "" && $date != $date_processed) {
                    my $date_text_color = $this->{map_date_text_color}->{$date_ISO};

                    if (defined($date_text_color)) {
                        ### will overwrite the default text color for date and 
                        ### date current but not date selected
                        $col_data_fmt = "<font color=\"$date_text_color\">" . $date_processed . "</font>";

                        $tld->set_Data($i, $column_name[$j], $col_data_fmt);
                    }
                }
                
                my $date_content = $this->{map_date_content}->{$date_ISO};
                
                if (defined($date_content)) {
                    $tld->set_Data($i, $column_name[$j + 21], $date_content);
                }
                
                ###############################################################
            }
        }
    }
    
    #$cgi->add_Debug_Text($tld->get_Table_List, __FILE__, __LINE__);
    
    my $tldhtml = new TLD_HTML_Map;

    $tldhtml->set_Table_List_Data($this->{tld});
    $tldhtml->set_HTML_Code($te_content);

    my $html_result = $tldhtml->get_HTML_Code;

    $this->add_Content($html_result);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

sub set_Column_Level_Color {
    my $this = shift @_;
    
    my $array_ref = shift @_;
    my @array_data = @{$array_ref};
    
    if (defined($this->{column_color_odd})) {
        for (my $i = 0; $i < 7; $i += 2) {
            $array_data[$i] = "$this->{column_color_odd}";
        }
    }
    
    if (defined($this->{column_color_even})) {
        for (my $i = 1; $i < 7 ; $i += 2) {
            $array_data[$i] = "$this->{column_color_even}";
        }
    }    
    
    return @array_data;
}

sub set_Row_Level_Color {
    my $this = shift @_;
    
    my $array_ref = shift @_;
    my $row_num = shift @_;
    
    my @array_data = @{$array_ref};
    
    if (($row_num % 2) != 0) {
        if (defined($this->{row_color_odd})) {
            for (my $i = 0; $i < 7; $i++) {
                $array_data[$i] = "$this->{row_color_odd}";
            }
        }
        
    } else {
        if (defined($this->{row_color_even})) {
            for (my $i = 0; $i < 7; $i++) {
                $array_data[$i] = "$this->{row_color_even}";
            }
        }    
    }
    
    return @array_data;
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