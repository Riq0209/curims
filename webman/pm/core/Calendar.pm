###########################################################################################

# GMM_CGI_Lib Pre-Release 5

# This library intended to be released under GNU General Public License. 
# Please visit http://www.gnu.org/ or contact the author for more info 
# about copied and disribution of this library.

# Copyright 2002-2005, Mohd Razak bin Samingan

# Faculty of Computer Science & Information System,
# 81310 UTM Skudai,
# Johor, MALAYSIA.

# e-mail: mrazak@fsksm.utm.my

###########################################################################################

package Calendar;

sub new {
    my $class = shift @_;
    my $this = {};
    
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

sub set_CGI {
    my $this = shift @_;
    
    $this->{cgi} = shift @_;
}

sub set_DBI_Conn { 
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($this->{db_conn});
    
    $this->{dbu} = $dbu;
}

sub set_DB_Table {
    my $this = shift @_;
    
    $this->{calendar_table} = shift @_;
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

sub init_Task {
    my $this = shift @_;
    
    ### 03/12/2014
    my $local_time_str = shift @_; ### Example: "Wed Jan 1 xx:xx:xx 2020";     
    
    my $cgi = $this->{cgi};
    
    $this->{day_num} = {Sun => "1", Mon => "2", Tue => "3", Wed => "4", Thu => "5", Fri => "6", Sat => "7"};

    $this->{num_day} = {1 => "Sun", 2 => "Mon", 3 => "Tue", 4 => "Wed", 5 => "Thu", 6 => "Fri", 7 => "Sat"};

    $this->{month_num} = {Jan => "1", Feb => "2", Mar => "3", Apr => "4",
                          May => "5", Jun => "6", Jul => "7", Aug => "8", Sep => "9",
                          Oct => "10", Nov => "11", Dec => "12"};

    $this->{num_month} = {1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr", 5 => "May", 6 => "Jun", 
                          7 => "Jul", 8 => "Aug", 9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec"};

    $this->{month_days} = {1 => "31", 2 => "29", 3 => "31", 4 => "30", 5 => "31", 6 => "30", 
                           7 => "31", 8 => "31", 9 => "30", 10 => "31", 11 => "30", 12 => "31"};       
    
    my $local_time = localtime;
    
    ### 03/12/2014
    if ($local_time_str ne "") {
        $local_time = $local_time_str;
    }    
    
    $local_time =~ s/\b  \b/ /g;
    
    my @t = split(/ /, $local_time);
    
    $this->{current_year} = $t[4];
    $this->{current_month} = $t[1];
    $this->{current_date} = $t[2];
    $this->{current_day} = $t[0];
    
    #$this->{cgi}->add_Debug_Text("$local_time", __FILE__, __LINE__, "TRACING");
    
    my $dbu = $this->{dbu};
    
    if (!defined($this->{calendar_table})) {
        $this->{calendar_table} = "webman_" . $cgi->param("app_name") . "_calendar";
    }

    $dbu->set_Table($this->{calendar_table});
    
    my $need_merge_Cal_ID_Link_Year = 0;
    
    my $current_year = $this->{current_year};
    
    #$cgi->add_Debug_Text("Try to init calendar table: $this->{calendar_table}", __FILE__, __LINE__);
    
    if (!$dbu->find_Item("year", "$current_year")) {
        $this->init_Calendar_Table;
        $need_merge_Cal_ID_Link_Year = 1;
    }
    
    ### at least have the next & previous year data in the calendar table 
    ### for current selected year
    
    ### next year #############################################################
    
    my $next_year = $current_year + 1;
    
    if (!$dbu->find_Item("year month date", "$next_year 1 1")) {
        my $next_year_first_day = $dbu->get_Item("day", "year month date", "$current_year 12 31");
        
        if ($next_year_first_day == 7) {
            $next_year_first_day = 1;
            
        } else {
            $next_year_first_day += 1;
        }
        
        $cgi->add_Debug_Text("Need to generate next year table data with current date info: $next_year-1-1 / $next_year_first_day", __FILE__, __LINE__, "TRACING");
        
        $this->init_Calendar_Table($next_year, "1", "1", $next_year_first_day);
        
        $need_merge_Cal_ID_Link_Year = 1;
    }
    
    ### previous year #########################################################
    
    my $prev_year = $current_year - 1;
    
    if (!$dbu->find_Item("year month date", "$prev_year 12 31")) {
        my $prev_year_last_day = $dbu->get_Item("day", "year month date", "$current_year 1 1");
        
        if ($prev_year_last_day == 1) {
            $prev_year_last_day = 7;
            
        } else {
            $prev_year_last_day -= 1;
        }
        
        $cgi->add_Debug_Text("Need to generate previous year table data with current date info: $prev_year-12-31 / $prev_year_last_day", __FILE__, __LINE__, "TRACING");
        
        $this->init_Calendar_Table($prev_year, "12", "31", $prev_year_last_day);
        
        $need_merge_Cal_ID_Link_Year = 1;
    }
    
    if ($need_merge_Cal_ID_Link_Year == 1) {
        $this->merge_Cal_ID_Link_Year;
    }
    
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
    
    my $month_to_num = $this->{month_num}->{$active_month};
    
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
    
    $next_active_month = $this->{num_month}->{$next_active_month};
    $prev_active_month = $this->{num_month}->{$prev_active_month};
    
    
    $this->{prev_active_year} = $prev_active_year;
    $this->{prev_active_month} = $prev_active_month;
    $this->{active_year} = $active_year;
    $this->{active_month} = $active_month;
    $this->{next_active_year} = $next_active_year;
    $this->{next_active_month} = $next_active_month;
}

sub get_Weekly_Date_Info {
    my $this = shift @_;
    
    my $iso_ymd = shift @_;
    
    #print "\$iso_ymd = $iso_ymd <br>";
        
    my $cgi = $this->{cgi};
    
    my $current_year = undef;
    my $current_month = undef;
    my $current_date = undef;
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table($this->{calendar_table});
    
    if ($iso_ymd eq "") {            
        $current_year = $this->{current_year};
        $current_month = $this->{month_num}->{$array[1]};
        $current_date = $this->{current_date};
        
    } else {
        my @array =  split(/-/, $iso_ymd);
        
        $current_year = $array[0];
        $current_month = $array[1];
        $current_date = $array[2];
    }   
    
    ### at least have the next & previous year data in the calendar table 
    ### for current selected year
    
    ### next year #####################################################
    
    my $need_merge_Cal_ID_Link_Year = 0;
    
    my $next_year = $current_year + 1;
    
    if (!$dbu->find_Item("year month date", "$next_year 1 1")) {
        my $next_year_first_day = $dbu->get_Item("day", "year month date", "$current_year 12 31");
        
        if ($next_year_first_day == 7) {
            $next_year_first_day = 1;
            
        } else {
            $next_year_first_day += 1;
        }
        
        $cgi->add_Debug_Text("Need to generate next year table data with current date info: $next_year-1-1 / $next_year_first_day", __FILE__, __LINE__);
        
        $this->init_Calendar_Table($next_year, "1", "1", $next_year_first_day);
        
        $need_merge_Cal_ID_Link_Year = 1;
    }
    
    ### previous year #################################################
    
    my $prev_year = $current_year - 1;
    
    if (!$dbu->find_Item("year month date", "$prev_year 12 31")) {
        my $prev_year_last_day = $dbu->get_Item("day", "year month date", "$current_year 1 1");
        
        if ($prev_year_last_day == 1) {
            $prev_year_last_day = 7;
            
        } else {
            $prev_year_last_day -= 1;
        }
        
        $cgi->add_Debug_Text("Need to generate previous year table data with current date info: $prev_year-12-31 / $prev_year_last_day", __FILE__, __LINE__);
        
        $this->init_Calendar_Table($prev_year, "12", "31", $prev_year_last_day);
        
        $need_merge_Cal_ID_Link_Year = 1;
    }
    
    if ($need_merge_Cal_ID_Link_Year == 1) {
        $this->merge_Cal_ID_Link_Year;
    }
    
    #print "$current_year - $current_month - $current_date <br>";
    
    my $cal_id = $dbu->get_Item("cal_id", "year month date", "$current_year $current_month $current_date");
    my $key_day = $dbu->get_Item("day", "year month date", "$current_year $current_month $current_date");
    
    my $i = 0;
    my $cal_id_str = undef;
    my $cal_id_temp = $undef;
    
    $cal_id_temp = $cal_id;
    
    for ($i = $key_day; $i > 1; $i--) { ### backward cal_id trace
        $cal_id_temp = $dbu->get_Item("prev_cal_id", "cal_id", $cal_id_temp);
        $cal_id_str .= "'$cal_id_temp'" . ", ";
    }
    
    $cal_id_temp = $cal_id;
    
    for ($i = $key_day; $i < 7; $i++) { ### forward cal_id trace
        $cal_id_temp = $dbu->get_Item("next_cal_id", "cal_id", $cal_id_temp);
        $cal_id_str .= "'$cal_id_temp'" . ", ";
    }
    
    $cal_id_str .= " '$cal_id'";
    
    #print $cal_id_str;
    
    $dbu->set_Keys_Str("cal_id in ($cal_id_str)");
    
    my @array_hash_ref = $dbu->get_Items("cal_id year month date day month_abbr day_abbr iso_ymd", "undef", "undef", "year asc, month asc, date asc");
    
    $dbu->set_Keys_Str(undef);
    
    return @array_hash_ref;
}

sub get_Monthly_Date_Info {
    my $this = shift @_;
    
    my $year = shift @_;
    my $month_abbr = shift @_;
        
    my $cgi = $this->{cgi};
    
    my $dbu = $this->{dbu};

    $dbu->set_Table($this->{calendar_table});
    
    my @array_hash_ref = $dbu->get_Items("cal_id year month date day month_abbr day_abbr iso_ymd", "year month_abbr", "$year $month_abbr", "iso_ymd");
    
    #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
    
    return @array_hash_ref;
}

sub get_Intermediate_Date_Info { ### 02/01/2007
    my $this = shift @_;
    
    my $iso_ymd_start= shift @_;
    my $iso_ymd_end= shift @_;
    
    my @date_start_info = split(/-/, $iso_ymd_start);
    my @date_end_info = split(/-/, $iso_ymd_end);
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table($this->{calendar_table});
    
    my @ahr = $dbu->get_Items("cal_id year month date day month_abbr day_abbr iso_ymd", "year month date", "$date_start_info[0] $date_start_info[1] $date_start_info[2]");
    
    my $cal_id_next = $ahr[0]->{cal_id};
    my $cal_id_str = "'$cal_id_next'";
    
    my $date_current = $ahr[0]->{iso_ymd};
    
    #$this->{cgi}->add_Debug_Text("$cal_id_next", __FILE__, __LINE__);
    
    my $finish = 0;
    
    while (!$finish) {
        $cal_id_next = $dbu->get_Item("next_cal_id", "cal_id", "$cal_id_next");
        
        @ahr = $dbu->get_Items("cal_id year month date day month_abbr day_abbr iso_ymd", "cal_id", "$cal_id_next");
        
        $date_current = $ahr[0]->{iso_ymd};
        
        if ($cal_id_next eq "" ||  $date_current gt $iso_ymd_end) {
            $finish = 1;
            
        } else {
            $cal_id_str = "$cal_id_str,'$cal_id_next'";
        }
        
        #$this->{cgi}->add_Debug_Text("$cal_id_next", __FILE__, __LINE__);
    }
    
    #$this->{cgi}->add_Debug_Text("\$cal_id_str = $cal_id_str", __FILE__, __LINE__);
    
    $dbu->set_Keys_Str("cal_id in ($cal_id_str) order by iso_ymd");
    
    my @array_hash_ref = $dbu->get_Items("cal_id year month date day month_abbr day_abbr iso_ymd", undef, undef, undef);
    
    $dbu->set_Keys_Str(undef);
    
    return @array_hash_ref;
}

sub get_Next_Days_Date { ### 30/10/2013
    my $this = shift @_;
    
    my $iso_ymd_current= shift @_;
    my $days_num = shift @_;
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table($this->{calendar_table});    
    
    my $cal_id = $dbu->get_Item("cal_id", "iso_ymd", "$iso_ymd_current");
    
    for (my $i = 1; $i < $days_num; $i++) {
        $cal_id = $dbu->get_Item("next_cal_id", "cal_id", $cal_id);
    }
    
    return $dbu->get_Item("iso_ymd", "cal_id", "$cal_id"); 
}

sub get_Prev_Days_Date { ### 30/10/2013
    my $this = shift @_;
    
    my $iso_ymd_current= shift @_;
    my $days_num = shift @_;
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table($this->{calendar_table});    
    
    my $cal_id = $dbu->get_Item("cal_id", "iso_ymd", "$iso_ymd_current");
    
    for (my $i = 1; $i < $days_num; $i++) {
        $cal_id = $dbu->get_Item("prev_cal_id", "cal_id", $cal_id);
    }
    
    return $dbu->get_Item("iso_ymd", "cal_id", "$cal_id"); 
}

sub init_Calendar_Table {
    my $this = shift @_;
    
    my $key_year = int(shift @_);
    my $key_month = int(shift @_);
    my $key_date = int(shift @_);
    my $key_day = int(shift @_);  
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table($this->{calendar_table});
    
    my $current_year = undef;
    my $current_month = undef;
    my $current_date = undef;
    my $current_day = undef;
    
    if ($key_year > 0 && $key_month > 0 && $key_date > 0 && $key_day > 0) {
        $current_year = $key_year;
        $current_month = $key_month;
        $current_date = $key_date;
        $current_day = $key_day;
        
    } else {
        $current_year = $this->{current_year};
        $current_month = $this->{month_num}->{$this->{current_month}};
        $current_date = $this->{current_date};
        $current_day = $this->{day_num}->{$this->{current_day}};
    }
    
    if ($current_year % 4 == 0) {
        $this->{month_days}->{2} = 29;
        
    } else {
        $this->{month_days}->{2} = 28;
    }
    
    #$this->{cgi}->add_Debug_Text("$current_year - $current_month - $current_date - $current_day", __FILE__, __LINE__, "TRACING");
    #$this->{cgi}->add_Debug_Text($current_year % 4, __FILE__, __LINE__, "TRACING");
    #$this->{cgi}->add_Debug_Text($this->{month_days}->{2}, __FILE__, __LINE__, "TRACING");
    
    my $prev_month = $current_month;
    my $prev_date = $current_date - 1;
    my $prev_day = $current_day - 1;
    
    if ($prev_date < 1) {
        $prev_month--; ### if 0 then while ($current_month >= 1) { ... } 
                       ### not proceeded for backward tracing 
                       ### (not relevance since ### 29/10/2103 )
                   
        $prev_date = $this->{month_days}->{$prev_month};
    }
    
    if ($prev_day < 1) { $prev_day = 7; }
    
    if (!$dbu->find_Item("year", "$current_year")) {
        if ($prev_month > 0) { ### 30/10/2013
            $this->init_Calendar_Table_Backward($current_year, $prev_month, $prev_date, $prev_day);
        }
    
        $this->init_Calendar_Table_Forward($current_year, $current_month, $current_date, $current_day);
    }
    
}

sub init_Calendar_Table_Backward {
    my $this = shift @_;
    
    my $current_year = shift @_;
    my $current_month = shift @_;
    my $current_date = shift @_;
    my $current_day = shift @_;
    
    my @year_b = undef;
    my @month_b = undef;
    my @date_b = undef;
    my @day_b = undef;
    
    #$this->{cgi}->add_Debug_Text("init_Calendar_Table_Backward is called: $current_year/$current_month/$current_date/$current_day<br>", __FILE__, __LINE__);
    
    if ($current_year % 4 == 0) {
        ### do nothing
    } else {
        $this->{month_days}->{2} = 28;
    }
    
    my $counter = 0;
    my $i = 0;
    
    while ($current_month >= 1) {
        while ($current_date >= 1) {
            $year_b[$counter] = $current_year;
            $month_b[$counter] = $current_month;
            $date_b[$counter] = $current_date;
            $day_b[$counter] = $current_day;

            #print "$current_year - $current_month - $current_date - $current_day <br>";

            $current_day--;
            $current_date--;

            if ($current_day < 1) { $current_day = 7; }

            $counter++;
        }
        
        $current_month--;

        $current_date = $this->{month_days}->{$current_month};        
    }
    
    my $dbu = $this->{dbu};

    $dbu->set_Table($this->{calendar_table});
    
    #$this->{cgi}->add_Debug_Text("\$this->{calendar_table} = " . $this->{calendar_table}, __FILE__, __LINE__);
    
    my $cal_id = undef;
    
    for ($i = @year_b - 1; $i >= 0; $i--) {
        my $iso_month = $month_b[$i];
        my $iso_date = $date_b[$i];

        if ($iso_month < 10) { $iso_month = "0" . $iso_month; }
        if ($iso_date < 10) { $iso_date = "0" . $iso_date; }

        my $iso_ymd = "$year_b[$i]-$iso_month-$iso_date";

        if ($i == (@year_b - 1)) {
            $dbu->insert_Row("year month date day month_abbr day_abbr iso_ymd", 
                             "$year_b[$i] $month_b[$i] $date_b[$i] $day_b[$i] $this->{num_month}->{$month_b[$i]} $this->{num_day}->{$day_b[$i]} $iso_ymd");
            #$this->{cgi}->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);

            ### Get the auto-increment value of "cal_id" 
            $cal_id = $dbu->get_Item("cal_id", "year month date", "$year_b[$i] $month_b[$i] $date_b[$i]");

            my $next_cal_id = $cal_id + 1;
            my $prev_cal_id = $cal_id - 1;
            
            $dbu->update_Item("next_cal_id prev_cal_id", "$next_cal_id $prev_cal_id", "year month date", "$year_b[$i] $month_b[$i] $date_b[$i]");

        } else {
            ### Force manual-increment value to "cal_id" 
            $cal_id++;
            
            my $next_cal_id = $cal_id + 1;
            my $prev_cal_id = $cal_id - 1;
            
            $dbu->insert_Row("cal_id year month date day month_abbr day_abbr iso_ymd next_cal_id prev_cal_id", 
                             "$cal_id $year_b[$i] $month_b[$i] $date_b[$i] $day_b[$i] $this->{num_month}->{$month_b[$i]} $this->{num_day}->{$day_b[$i]} $iso_ymd $next_cal_id $prev_cal_id");
            
        }
    }
}

sub init_Calendar_Table_Forward {
    my $this = shift @_;
    
    my $current_year = shift @_;
    my $current_month = shift @_;
    my $current_date = shift @_;
    my $current_day = shift @_;
    
    my @year_f = undef;
    my @month_f = undef;
    my @date_f = undef;
    my @day_f = undef;
    
    #$this->{cgi}->add_Debug_Text("init_Calendar_Table_Forward is called: $current_year/$current_month/$current_date/$current_day", __FILE__, __LINE__);
    
    if ($current_year % 4 == 0) {
        ### do nothing
    } else {
        $this->{month_days}->{2} = 28;
    }
    
    my $counter = 0;
    my $i = 0;
    
    while ($current_month <= 12) {
        #$this->{cgi}->add_Debug_Text("$current_month", __FILE__, __LINE__);
        
        while ($current_date <= $this->{month_days}->{$current_month}) {
            $year_f[$counter] = $current_year;
            $month_f[$counter] = $current_month;
            $date_f[$counter] = $current_date;
            $day_f[$counter] = $current_day;
            
            #print "$current_year - $current_month - $current_date - $current_day <br>";
            
            $current_day++;
            $current_date++;
            
            if ($current_day > 7) { $current_day = 1; }
            
            $counter++;
        }
        
        $current_date = 1;
        
        $current_month++;
    }
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table($this->{calendar_table});
    
    my $year_last = undef;
    my $month_last = undef;
    my $date_last = undef;
    my $day_last = undef;
    
    my $cal_id = undef;
    
    for ($i = 0; $i < @year_f; $i++) {
        my $iso_month = $month_f[$i];
        my $iso_date = $date_f[$i];

        if ($iso_month < 10) { $iso_month = "0" . $iso_month; }
        if ($iso_date < 10) { $iso_date = "0" . $iso_date; }

        my $iso_ymd = "$year_f[$i]-$iso_month-$iso_date";    

        if ($i == 0) {
            $dbu->insert_Row("year month date day month_abbr day_abbr iso_ymd", 
                             "$year_f[$i] $month_f[$i] $date_f[$i] $day_f[$i] $this->{num_month}->{$month_f[$i]} $this->{num_day}->{$day_f[$i]} $iso_ymd");
            #$this->{cgi}->add_Debug_Text("$year_f[$i] $month_f[$i] $date_f[$i] $day_f[$i] $this->{num_month}->{$month_f[$i]} $this->{num_day}->{$day_f[$i]}", __FILE__, __LINE__);
            
            ### Get the auto-increment value of "cal_id" 
            $cal_id = $dbu->get_Item("cal_id", "year month date", "$year_f[$i] $month_f[$i] $date_f[$i]");
            
            my $next_cal_id = $cal_id + 1;
            my $prev_cal_id = $cal_id - 1;
            
            $dbu->update_Item("next_cal_id prev_cal_id", "$next_cal_id $prev_cal_id", "year month date", "$year_f[$i] $month_f[$i] $date_f[$i]");
        
        } else {
            ### Force manual-increment value to "cal_id" 
            $cal_id++;
            
            my $next_cal_id = $cal_id + 1;
            my $prev_cal_id = $cal_id - 1;
            
            $dbu->insert_Row("cal_id year month date day month_abbr day_abbr iso_ymd next_cal_id prev_cal_id", 
                             "$cal_id $year_f[$i] $month_f[$i] $date_f[$i] $day_f[$i] $this->{num_month}->{$month_f[$i]} $this->{num_day}->{$day_f[$i]} $iso_ymd $next_cal_id $prev_cal_id");
            
        }
    }
}

sub construct_Cal_ID_Link { ### this is no longer use since ### 30/10/2013
    my $this = shift @_;
    
    my $cgi = $this->{cgi};
    my $dbu = $this->{dbu};
        
    $dbu->set_Table($this->{calendar_table});
    
    my $item = undef;
    
    my @ahr = $dbu->get_Items("cal_id", undef, undef, "year, month, date", undef);
    
    my $prev_id = 0;
    my $next_id = 0;
    
    my $cal_id = 0;
    
    foreach $item (@ahr) {
        #print $item->{cal_id} . "<br>\n";
        
        $cal_id = $item->{cal_id};
        
        $dbu->update_Item("prev_cal_id", "$prev_id", "cal_id", "$cal_id");
        
        $dbu->update_Item("next_cal_id", "$cal_id", "cal_id", "$prev_id");
        
        $prev_id =  $cal_id;
    }
}

sub merge_Cal_ID_Link_Year { ### 30/10/2013
    my $this = shift @_;
    
    my $cgi = $this->{cgi};
    my $dbu = $this->{dbu};
        
    $dbu->set_Table($this->{calendar_table});
    
    my @ahr = $dbu->get_Items("year", undef, undef, "year", 1);
    
    my $count_item = 0;
    
    my $iso_ymd_begin_prev = undef;
    my $cal_id_begin_prev = undef;
    
    my $iso_ymd_end_prev = undef;
    my $cal_id_end_prev = undef;
    
    foreach my $item (@ahr) {
        $count_item++;
        
        my $iso_ymd_begin = "$item->{year}-01-01";
        my $cal_id_begin = $dbu->get_Item("cal_id", "iso_ymd", $iso_ymd_begin);
        
        my $iso_ymd_end = "$item->{year}-12-31";
        my $cal_id_end =  $dbu->get_Item("cal_id", "iso_ymd", $iso_ymd_end);
        
        if ($count_item == 1) {
            $dbu->update_Item("prev_cal_id", "-1", "iso_ymd", "$iso_ymd_begin");
            
        } elsif ($count_item < @ahr) {
            $dbu->update_Item("next_cal_id", "$cal_id_begin", "iso_ymd", "$iso_ymd_end_prev");
            $dbu->update_Item("prev_cal_id", "$cal_id_end_prev", "iso_ymd", "$iso_ymd_begin");
        } else {
            $dbu->update_Item("next_cal_id", "-1", "iso_ymd", "$iso_ymd_end");
            $dbu->update_Item("prev_cal_id", "$cal_id_end_prev", "iso_ymd", "$iso_ymd_begin");
        }
        
        $iso_ymd_begin_prev = $iso_ymd_begin;
        $cal_id_begin_prev = $cal_id_begin;

        $iso_ymd_end_prev = $iso_ymd_end;
        $cal_id_end_prev = $cal_id_end;        
        
        #$this->{cgi}->add_Debug_Text("$item->{year}: $cal_id_begin - $cal_id_end", __FILE__, __LINE__);
    }
}

1;
