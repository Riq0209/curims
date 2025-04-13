=pod
=HEAD1 webman_calendar
Display basic calendar for current active month. 
=HEAD2 CGI Data Control
-
=HEAD3 View Template
C <
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<!-- start_view_ //-->
<table width="315" border="1">
  <tr>
    <td width="45" colspan="7" align="center">$active_month_ &nbsp;&nbsp; $active_year_</td>
  </tr>
  <tr>
    <td align="center" width="45">Mon</td>
    <td align="center" width="45">Tue</td>
    <td align="center" width="45">Wed</td>
    <td align="center" width="45">Thu</td>
    <td align="center" width="45">Fri</td>
    <td align="center" width="45">Sat</td>
    <td align="center" width="45">Sun</td>
  </tr>
  <!-- start_list_ //-->
  <tr>
    <td align="center" valign="top" width="45" $tld_cell1_color_>$tld_date1_ $tld_date1_content_</td>
    <td align="center" valign="top" width="45" $tld_cell2_color_>$tld_date2_ $tld_date2_content_</td>
    <td align="center" valign="top" width="45" $tld_cell3_color_>$tld_date3_ $tld_date3_content_</td>
    <td align="center" valign="top" width="45" $tld_cell4_color_>$tld_date4_ $tld_date4_content_</td>
    <td align="center" valign="top" width="45" $tld_cell5_color_>$tld_date5_ $tld_date5_content_</td>
    <td align="center" valign="top" width="45" $tld_cell6_color_>$tld_date6_ $tld_date6_content_</td>
    <td align="center" valign="top" width="45" $tld_cell7_color_>$tld_date7_ $tld_date7_content_</td>
  </tr>
  <!-- end_list_ //-->
</table>
<!-- end_view_ //-->
</body>
</html>
>
=cut

package webman_calendar;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{cell_color_date} = undef;
    $this->{cell_color_date_current} = undef;
    
    $this->{text_color_date} = undef;
    $this->{text_color_date_current} = undef;
    
    $this->{column_color_odd} = undef;
    $this->{column_color_even} = undef;
    
    $this->{row_color_odd} = undef;
    $this->{row_color_even} = undef;    
    
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

sub set_Default_Text_Colors {
    my $this = shift @_;
    
    $this->{text_color_date} = shift @_;
    $this->{text_color_date_current} = shift @_;
}

sub set_Default_Cell_Colors {
    my $this = shift @_;
    
    $this->{cell_color_date} = shift @_;
    $this->{cell_color_date_current} = shift @_;
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
    
    #$cgi->add_Debug_Text("$calendar->{current_year} - $calendar->{current_month} - $calendar->{current_date} -$calendar->{current_day}", 
    #                     __FILE__, __LINE__);
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
    
    $te_content =~ s/\$active_month_/$this->{current_month}/;
    $te_content =~ s/\$active_year_/$this->{current_year}/;
    
    $this->add_Content($te_content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $year = $this->{current_year};
    my $month = $this->{current_month};
    my $date = $this->{current_date};
    
    my $calendar = $this->{calendar};
    
    my @current_month_list = $this->{calendar}->get_Monthly_Date_Info($year, $month);
    
    #print $dbu->get_SQL . "<br>";
    
    my @column_name = ("date1", "date2", "date3", "date4", "date5", "date6", "date7",
                       "cell1_color", "cell2_color", "cell3_color", "cell4_color", "cell5_color", "cell6_color", "cell7_color",
                       "date1_iso", "date2_iso", "date3_iso", "date4_iso", "date5_iso", "date6_iso", "date7_iso",
                       "date1_content", "date2_content", "date3_content", "date4_content", "date5_content", "date6_content", "date7_content");
    
    my $tld = new Table_List_Data;
    
    for (my $i = 0; $i < @column_name; $i++) {
        $tld->add_Column($column_name[$i]);
    }
    
    my @date_data = ("", "", "", "", "", "", "",
                     "", "", "", "", "", "", "",
                     "", "", "", "", "", "", "",
                     "", "", "", "", "", "", "");
    
    if ($current_month_list[0]->{"day"} > 1) {        
        for (my $i = $current_month_list[0]->{"day"} - 1; $i > 0; $i--) {
            $date_data[$i - 1] = "-";
            
            if ($this->{cell_color_date} ne "") {
                $date_data[$i - 1 + 7] = "bgcolor=$this->{cell_color_date}";
            }            
        }
    }
    
    ### set color at column level
    @date_data = $this->set_Column_Level_Color(\@date_data);
    
    ### set color at row level
    @date_data = $this->set_Row_Level_Color(\@date_data, 1);
    
    for (my $i = 0; $i < @current_month_list; $i++) {       
        
        my $date_ISO = $current_month_list[$i]->{"iso_ymd"};
        
        if ($current_month_list[$i]->{"date"} == $date) {
            if ($this->{text_color_date_current} ne "") {
                $current_month_list[$i]->{"date"} = "<b><font color=\"$this->{text_color_date_current}\">" . $current_month_list[$i]->{"date"} . "</font></b>";
            } else {
                $current_month_list[$i]->{"date"} = "<b>" . $current_month_list[$i]->{"date"} . "</b>";
            }
            
            if ($this->{cell_color_date_current} ne "") {
                $date_data[$current_month_list[$i]->{"day"} - 1 + 7] = "bgcolor=$this->{cell_color_date_current}";
            }
            
        } else {
            if ($this->{text_color_date} ne "") {
                $current_month_list[$i]->{"date"} = "<font color=\"$this->{text_color_date}\">" . $current_month_list[$i]->{"date"} . "</font>";
            } else {
                $current_month_list[$i]->{"date"} = $current_month_list[$i]->{"date"};
            }
            
            if ($this->{cell_color_date} ne "") {
                $date_data[$current_month_list[$i]->{"day"} - 1 + 7] = "bgcolor=$this->{cell_color_date}";
            }        
        }
        
        $date_data[$current_month_list[$i]->{"day"} - 1] = $current_month_list[$i]->{"date"};
        $date_data[$current_month_list[$i]->{"day"} + 13] = $current_month_list[$i]->{"iso_ymd"};
        
        ### 05/12/2011 
        #######################################################################
        my $date_content = $this->{map_date_content}->{$date_ISO};
        
        #$cgi->add_Debug_Text("$date_ISO - $date_content", __FILE__, __LINE__);

        if (defined($date_content)) {
            $date_data[$current_month_list[$i]->{"day"} - 1 + 21] = $date_content;
        }
        #######################################################################
        
        if ($current_month_list[$i]->{"day"} == 7) { 
            $tld->add_Row_Data(@date_data);
            
            @date_data = ("", "", "", "", "", "", "", 
                          "", "", "", "", "", "", "",
                          "", "", "", "", "", "", "",
                          "", "", "", "", "", "", "");
                          
            ### set color at column level
            @date_data = $this->set_Column_Level_Color(\@date_data);
            
            ### set color at row level
            @date_data = $this->set_Row_Level_Color(\@date_data, $tld->get_Row_Num + 1);
        }
    }
    
    if ($current_month_list[@current_month_list - 1]->{"day"} < 7) {       
        for (my $i = $current_month_list[@current_month_list - 1]->{"day"} + 1; $i <= 7; $i++) {
            $date_data[$i - 1] = "-";
            
            if ($this->{cell_color_date} ne "") {
                $date_data[$i - 1 + 7] = "bgcolor=$this->{cell_color_date}";
            }
        }
    }
    
    $tld->add_Row_Data(@date_data);
    
    #$cgi->add_Debug_Text($tld->get_Table_List, __FILE__, __LINE__);
    
    $tld = $this->customize_TLD($tld);
    
    my $tldhtml = new TLD_HTML_Map;

    $tldhtml->set_Table_List_Data($tld);
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
        for (my $i = 7; $i <= 13; $i += 2) {
            $array_data[$i] = "bgcolor=$this->{column_color_odd}";
        }
    }
    
    if (defined($this->{column_color_even})) {
        for (my $i = 8; $i <= 12; $i += 2) {
            $array_data[$i] = "bgcolor=$this->{column_color_even}";
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
            for (my $i = 7; $i <= 13; $i++) {
                $array_data[$i] = "bgcolor=$this->{row_color_odd}";
            }
        }
        
    } else {
        if (defined($this->{row_color_even})) {
            for (my $i = 7; $i <= 13; $i++) {
                $array_data[$i] = "bgcolor=$this->{row_color_even}";
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