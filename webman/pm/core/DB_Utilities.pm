###########################################################################################

# GMM_CGI_Lib Pre-Release 5

# This library intended to be released under GNU General Public License. 
# Please visit http://www.gnu.org/ or contact the author for more info 
# about copied and disribution of this library.

# Copyright 2002-2011, Mohd Razak bin Samingan

# Faculty of Computer Science & Information System,
# 81310 UTM Skudai,
# Johor, MALAYSIA.

# e-mail: mrazak@fsksm.utm.my

###########################################################################################

package DB_Utilities;

use DBI; ### 19/02/2011 
         ### no need to use DBI inside the main script that using this module 
         ### the webman framework creator himself always forgot about it ;-p
         
use GMM_CGI;

sub new {
    my $class = shift;
    my $this = {};
    
    $this->{table} = undef;
    
    $this->{db_conn} = undef;
    $this->{db_interface} = undef;
    $this->{sql} = undef;
    
    $this->{keys_str} = undef; ### 29/08/2005
    
    $this->{escape_HTML_tag} = 0; ### 01/04/2009
    
    $this->{field_value_hash_ref} = undef; ### hash ref. of DB field=>value
    
    $this->{auth_mode} = 0;
    
    $this->{login_name} = undef; ### 11/03/2006
    $this->{groups} = undef; ### 11/03/2006 (array ref.)
    $this->{db_item_auth_table_name} = undef; ### 11/03/2006
    $this->{user_group_table_name} = undef; ### 16/05/2006
    
    $this->{db_item_access_error_message} = undef; ### 11/03/2006
    
    $this->{error_back_link} = undef; ### 16/05/2006
    
    $this->{debug_sql} = 0; 
    
    bless $this, $class;
    
    return $this;
}

sub make_DBI_Conn { ### 15/05/2009
    my $this = shift @_;
    
    my $conn_cnf = shift @_;
    
    if ($conn_cnf eq "") {
        $conn_cnf = "./webman/conf/dbi_connection.conf";
    }
    
    my %cnf_info = ();
    
    $cnf_info{"host"} = "localhost";
    
    if (open(CNF_FILE, "<$conn_cnf")) {
        my @file_content = <CNF_FILE>;
        
        close(CNF_FILE);
        
        foreach my $line (@file_content) {
            while ($line =~ s/^ //) { }
            
            if (!($line =~ /^#/)) {
                $line =~ s/\n//;
                $line =~ s/\r//;
                $line =~ s/ //g;
                
                my @data = split(/=/, $line);
                
                $cnf_info{$data[0]} = $data[1];
            }
        }
        
        my $host = $cnf_info{"db_host"};
        my $db_name = $cnf_info{"db_name"};
        my $user_name = $cnf_info{"db_user_name"};
        my $password = $cnf_info{"db_password"};
        my $socket = $cnf_info{"db_socket"};
        
        #print __FILE__ . ":" . __LINE__ . ":$host - $db_name - $user_name - $password - $socket\n";

        my $dbi_conn = undef;
        
        if ($socket eq "") {
            $dbi_conn = DBI->connect("DBI:mysql:dbname=$db_name:$host", $user_name, $password);
            
        } else {
            $dbi_conn = DBI->connect("DBI:mysql:dbname=$db_name:$host;mysql_socket=$socket", $user_name, $password);
        }
        
        #print "\$dbi_conn = $dbi_conn<br>\n";
        
        return $dbi_conn;
    }
    
    return undef;
}

sub set_Pg_Conn { 
    $this = shift @_;
    $this->{db_conn} = shift @_;
    $this->{db_interface} = "Pg"; 
}

sub set_DBI_Conn { 
    $this = shift @_;
    $this->{db_conn} = shift @_;
    $this->{db_interface} = "DBI";
}

sub set_Table {
    $this = shift @_;
    $this->{table} = shift @_;
}

sub set_Keys_Str {
    $this = shift @_;
    $this->{keys_str} = shift @_;
    
    
}

sub set_Escape_HTML_Tag { ### 01/04/2009
    my $this = shift @_;
    
    $this->{escape_HTML_tag} = shift @_;
}

sub set_Debug_SQL {
    $this = shift @_;
    $this->{debug_sql} = shift @_;
}

sub set_DB_Item_Auth_Info { ### 11/03/2006
    my $this = shift @_;
    
    $this->{login_name} = shift @_; 
    $this->{groups} = shift @_; ### array ref.
    $this->{db_item_auth_table_name} = shift @_;
    $this->{user_group_table_name} = shift @_;
    
    $this->{auth_mode} = 1;
}

sub set_Error_Back_Link { ### 16/05/2006
    my $this = shift @_;
    $this->{error_back_link} = shift @_;
}

sub set_CGI {
    my $this = shift @_;
    $this->{cgi} = shift @_; 
}

### 21/04/2014
sub set_Login_Info {
    my $this = shift @_;
    
    $this->{login_name} = shift @_; 
    
    ### 29/12/2018
    my $prev_tablename = $this->{table};
    
    $this->set_Table("webman_" . $this->{cgi}->param("app_name") . "_user");
    $this->{user_fullname} = $this->get_Item("full_name", "login_name", $this->{login_name});
    
    ### 29/12/2018
    $this->set_Table($prev_tablename);
}

sub get_Auth_Error_Message {
    my $this = shift @_;
    
    return $this->{db_item_access_error_message};
}

sub get_SQL {
    $this = shift @_;
    
    return $this->{sql};
}

sub generate_Error_Message {
    my $this = shift @_;
    
    my $table = $this->{table};
    
    my $error_message  = undef;
    
    $error_message .= "<center><pre><font face=\"Verdana, Arial, Helvetica, sans-serif\" size=2>\n";
    $error_message .= "<h3>FSKSM_CGI_lib</h3>\n";
    $error_message .= "<b>Error:</b> Don't have privilege to access current database table item.<p>\n";
    $error_message .= "<b>Table:</b> " . $table . "\n\n";
    $error_message .= "$this->{error_back_link}\n";
    $error_message .= "</font></pre></center>\n";
    
    return $error_message;
}

sub insert_Row {
    my $this = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $execute = shift @_;
    
    if ($execute eq "") {
        $execute = 1;
    }
    
    my $sql = "insert into " . $this->{table} . " (";
    
    $values = $this->translate_Esc_Char_To_Code($values);
    
    $values =~ s/\\ /_space_/g;
    
    my @k = split(/ /, $keys);
    my @v = split(/ /, $values);
    
    ### 08/02/2011 #########################################################
    
    if (@k != @v) {
        $this->{error} = "Insert fields and values doesn't match in number."; 
        return 0;
    }
    
    $this->generate_ISO_Date_Time;
    
    if ($this->field_Exist("date_created") && !grep(/^date_created$/, @k)) {
        push(@k, "date_created");
        push(@v, $this->{iso_date});
    }
    
    if ($this->field_Exist("time_created") && !grep(/^time_created$/, @k)) {
        push(@k, "time_created");
        push(@v, $this->{iso_time});
    }
    
    if ($this->field_Exist("_item_order") && !grep(/^_item_order$/, @k)) {
        my $next_order_num = $this->get_MAX_Item("_item_order", undef, undef) + 1;
        
        push(@k, "_item_order");
        push(@v, $next_order_num);
    }
    
    ### 21/04/2014
    if ($this->{user_fullname} ne "" && $this->field_Exist("wmf_created") && !grep(/^wmf_created$/, @k)) {
        push(@k, "wmf_created");
        push(@v, "$this->{login_name}-$this->{user_fullname}, $this->{iso_date}, $this->{iso_time}");
    }    
    
    ### 01/11/2011 ############################################################
    ### auto insert support for 36base & 62base primary key id based on 
    ### Webman's convention over configuration (CoC) for table's primary key 
    my $rnd362base = undef;
    my @ahr = $this->get_Table_Structure;
    
    my $first_field_name = $ahr[0]->{field_name};
    my $first_field_length = $ahr[0]->{field_length};
    
    if (!grep(/^$first_field_name$/, @k)) {
     
        if ($first_field_name =~ /^id_.+_36base$/) { 
            $rnd362base = $this->get_Unique_Random_36Base($first_field_name, $first_field_length);
        }

        if ($first_field_name =~ /^id_.+_62base$/) {
            $rnd362base = $this->get_Unique_Random_62Base($first_field_name, $first_field_length);
        }
    }
    
    if (defined($rnd362base)) {
        push(@k, $first_field_name);
        push(@v, $rnd362base);        
    }    
    
    ########################################################################    
    
    my $i = 0;
    
    my $idx_num = @k;
    
    for ($i = 0; $i < @k; $i++) {
        if (($i + 1) == $idx_num) {
            $sql = $sql . "$k[$i]";
        } else {
            $sql = $sql . "$k[$i], ";
        }
    }
    
    $sql = $sql . ") values (";
    
    for ($i = 0; $i < @v; $i++) {
        $v[$i] =~ s/_space_/ /g;
        
        $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
        
        $v[$i] = $this->escape_DB_Special_Char($v[$i]);
                
        if (($i + 1) == $idx_num) {
            $sql = $sql . "'$v[$i]'";
        } else {
            $sql = $sql . "'$v[$i]', ";
        }
    }
    
    $sql = $sql . ")";
    
    $this->{sql} = $sql;
    
    ### 21/04/2014
    #if ($this->{cgi}) {
    #    $this->{cgi}->add_Debug_Text($sql, __FILE__, __LINE__);
    #}    
    
    ###########################################################################
    
    my %field_value = undef;
    
    ### 22/02/2011
    ### For insert operation, putting all table fields inside %field_value
    ### can facilitate the implemention of database item access control using 
    ### wildcard '*' value for table's auto increment primary key
    
    my @ahr = $this->get_Table_Structure;
    
    foreach my $item (@ahr) {
        $field_value{$item->{field_name}} = undef;
    }
    
    ###########################################################################
    
    my $pass_auth = 1;
    
    $this->{db_error} = "";
    
    if ($this->{auth_mode}) { ### 30/06/2006
        my %hash_key_value = undef;
        
        for ($i = 0; $i < @k; $i++) {
            $hash_key_value{$k[$i]} = $v[$i];
        }

        my $hash_ref = \%hash_key_value;
        
        
        my $key = undef;
        
        foreach $key (keys %{$hash_ref}) {
            #print "$key = $hash_ref->{$key} <br>\n";
            $field_value{$key} = $hash_ref->{$key};
        }
        
        $this->{field_value_hash_ref} = \%field_value;
        
        $pass_auth = $this->authenticate_DB_Item_Access("INSERT");
    }
    
    ###########################################################################
    
    if ($pass_auth) {
        $this->{db_item_access_error_message} = undef; ### 02/01/2007
        
        if ($this->{db_interface} eq "Pg") {
            $result = $this->{db_conn}->exec($sql);

        } elsif ($this->{db_interface} eq "DBI") {
            $sth = $this->{db_conn}->prepare($sql);
            if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }

            if ($execute && $this->{db_error} eq "") {
                $sth->execute;
                if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
            }
            
            $sth->finish;
        }
    }
    
    ###########################################################################
    
    if ($this->{db_error} ne "") {
        return 0;
        
    } else {
        return 1;
    }    
}

sub update_Item { ### 04/06/2005
    my $this = shift @_;
    
    my $update_keys = shift @_;
    my $update_values = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $execute = shift @_;
    
    if ($execute eq "") {
        $execute = 1;
    }    
    
    my $sql = "update " . $this->{table} . " set "; 
    
    ### 08/02/2011 #########################################################
    
    $update_values = $this->translate_Esc_Char_To_Code($update_values);
    
    $update_values =~ s/\\ /_space_/g;    
    
    my @uk = split(/ /, $update_keys);
    my @uv = split(/ /, $update_values);
    
    if (@uk != @uv) {
        $this->{error} = "Update fields and values doesn't match in number."; 
        return 0;
    }
    
    $this->generate_ISO_Date_Time;
    
    if ($this->field_Exist("date_modified") && !grep(/^date_modified$/, @uk)) {
        push(@uk, "date_modified");
        push(@uv, $this->{iso_date});
    }
    
    if ($this->field_Exist("time_modified") && !grep(/^time_modified$/, @uk)) {
        push(@uk, "time_modified");
        push(@uv, $this->{iso_time});
    }
    
    ### 21/04/2014
    if ($this->{user_fullname} ne "" && $this->field_Exist("wmf_modified") && !grep(/^wmf_modified$/, @uk)) {
        push(@uk, "wmf_modified");
        push(@uv, "$this->{login_name}-$this->{user_fullname}, $this->{iso_date}, $this->{iso_time}");
    }
    
    for (my $i = 0; $i < @uk; $i++) {
        $uv[$i] =~ s/_space_/ /g;
        $uv[$i] = $this->translate_Esc_Code_To_Char($uv[$i]);
        $uv[$i] = $this->escape_DB_Special_Char($uv[$i]);
        
        $sql .= "$uk[$i]='$uv[$i]', ";
    }
    
    $sql  =~ s/, $//;
    $sql .= " where ";
    
    ###########################################################################
            
    $values = $this->translate_Esc_Char_To_Code($values);
        
    $values =~ s/\\ /_space_/g;
    
    my @k = split(/ /, $keys);
    my @v = split(/ /, $values);
    
    if (@uk != @uv) {
        $this->{error} = "Update key fields and key values doesn't match in number."; 
        return 0;
    }    
    
    if ($this->{keys_str} eq "") { ### 29/08/2005
    
        my $i = 0;
    
        for ($i = 0; $i < @k; $i++) {
            $v[$i] =~ s/_space_/ /g;
            $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
            $v[$i] = $this->escape_DB_Special_Char($v[$i]);
            
            $sql = $sql . "$k[$i] = '$v[$i]' and ";
        }
    
        $sql = substr($sql, 0, length($sql) - 5);
        
    } else {
        $sql = $sql . $this->{keys_str};
    }
    
    $this->{sql} = $sql;
    
    ### 21/04/2014
    #if ($this->{cgi}) {
    #    $this->{cgi}->add_Debug_Text($sql, __FILE__, __LINE__);
    #}    
    
    ###########################################################################
    
    my $pass_auth = 1;
    
    $this->{db_error} = "";
    
    if ($this->{auth_mode}) { ### 01/01/2012
        my @str_parts = split(/where/i, $this->{sql});
        
        my $sql_select = "select * from $this->{table}"; 
        
        if ($str_parts[1] ne "") {
            $sql_select .= " where $str_parts[1]";
        }
        
        $sth = $this->{db_conn}->prepare($sql_select);
        $sth->execute;

        my $hash_ref = $sth->fetchrow_hashref;
        
        $sth->finish;
        
        my $key = undef;
        my %field_value = ();
        
        foreach $key (keys %{$hash_ref}) {
            #print "$key = $hash_ref->{$key} <br>\n";
            $field_value{$key} = $hash_ref->{$key};
        }
        
        $this->{field_value_hash_ref} = \%field_value;
        
        $pass_auth = $this->authenticate_DB_Item_Access("UPDATE");    
    }
    
    ###########################################################################
    
    if ($pass_auth) { ### 01/01/2012
        $this->{db_item_access_error_message} = undef; ### 02/01/2007
        
        if ($this->{db_interface} eq "Pg") {
            $result = $this->{db_conn}->exec($sql);

        } elsif ($this->{db_interface} eq "DBI") {
            $sth = $this->{db_conn}->prepare($sql);
            if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }

            if ($execute && $this->{db_error} eq "") {
                $sth->execute;
                if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
            }

            $sth->finish;
        }
    }
    
    ###########################################################################
    
    if ($this->{db_error} ne "") {
        return 0;
        
    } else {
        return 1;
    }    
}

sub delete_Item {
    my $this = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $execute = shift @_;
    
    if ($execute eq "") {
        $execute = 1;
    }
    
    my $sth = undef;
    my $sql = "delete from " . $this->{table} . " where ";
    
    $values = $this->translate_Esc_Char_To_Code($values);
    
    $values =~ s/\\ /_space_/g;
    
    my @k = split(/ /, $keys);
    my @v = split(/ /, $values);
    
    if (@k != @v) {
        $this->{error} = "Delete key fields and key values doesn't match in number."; 
        return 0;
    }    
    
    if ($this->{keys_str} eq "") { ### 29/08/2005
        my $i = 0;
    
        for ($i = 0; $i < @k; $i++) {
                $v[$i] =~ s/_space_/ /g;
                
                $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
                
                $v[$i] = $this->escape_DB_Special_Char($v[$i]);
            
            $sql = $sql . "$k[$i] = '$v[$i]' and ";
        }
    
        $sql = substr($sql, 0, length($sql) - 5);
        
    } else {
        $sql = $sql . $this->{keys_str};
    }
    
    $this->{sql} = $sql; 
    
    ###########################################################################
    
    my $pass_auth = 1;
    
    $this->{db_error} = "";
    
    if ($this->{auth_mode}) { ### 11/03/2006
        my $sql_select = $this->{sql};
        
        $sql_select =~ s/delete/select */;
        
        $sth = $this->{db_conn}->prepare($sql_select);
        $sth->execute;

        my $hash_ref = $sth->fetchrow_hashref;
        
        $sth->finish;
        
        my $key = undef;
        my %field_value = undef;
        
        foreach $key (keys %{$hash_ref}) {
            #print "$key = $hash_ref->{$key} <br>\n";
            $field_value{$key} = $hash_ref->{$key};
        }
        
        $this->{field_value_hash_ref} = \%field_value;
        
        $pass_auth = $this->authenticate_DB_Item_Access("DELETE");
    }
    
    ###########################################################################
    
    if ($pass_auth) {
        $this->{db_item_access_error_message} = undef; ### 02/01/2007
        
        if ($this->{db_interface} eq "Pg") {
            $result = $this->{db_conn}->exec($sql);

        } elsif ($this->{db_interface} eq "DBI") { 
            $sth = $this->{db_conn}->prepare($sql);
            if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
            
            if ($execute && $this->{db_error} eq "") {
                $sth->execute;
                if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
            }
            
            $sth->finish;
        }
    }
    
    ###########################################################################
    
    if ($this->{db_error} ne "") {
        return 0;
        
    } else {        
        return 1;
    }    
}

sub generate_ISO_Date_Time { ### 08/02/2011
    my $this = shift @_;
    
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

    $year += 1900;
    $mon += 1;

    ### 21/04/2014
    if ($mon < 10) { $mon = "0" . $mon; }
    if ($mday < 10) { $mday = "0" . $mday; }
    
    if ($hour < 10) { $hour = "0" . $hour; }
    if ($min < 10) { $min = "0" . $min; }
    if ($sec < 10) { $sec = "0" . $sec; }
    
    $this->{iso_date} = "$year-$mon-$mday";
    $this->{iso_time} = "$hour:$min:$sec";
}


sub find_Item {
    my $this = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $sql = "select * from " . $this->{table} . " where ";
    
    $values = $this->translate_Esc_Char_To_Code($values);
    
    $values =~ s/\\ /_space_/g;
    
    my @k = split(/ /, $keys);
    my @v = split(/ /, $values);
    
    if ($this->{keys_str} eq "") { ### 29/08/2005
        my $i = 0;
    
        for ($i = 0; $i < @k; $i++) {
                $v[$i] =~ s/_space_/ /g;
                
                $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
                
                $v[$i] = $this->escape_DB_Special_Char($v[$i]);
            
            $sql = $sql . "$k[$i] = '$v[$i]' and ";
        }
    
        $sql = substr($sql, 0, length($sql) - 5);
        
    } else {
        $sql = $sql . $this->{keys_str};
    }
    
    $this->{sql} = $sql;
    
    if ($this->{db_interface} eq "Pg") {
        $result = $this->{db_conn}->exec($sql);
        @data = $result->fetchrow;

    } elsif ($this->{db_interface} eq "DBI") {
        $sth = $this->{db_conn}->prepare($sql);
        if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
        
        $sth->execute;
        if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
        
        @data = $sth->fetchrow_array;
        $sth->finish;
    }

    if ($#data > -1) {
        return 1;
    } else {
        return 0;
    }   
}

sub count_Item {
    my $this = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    my $distinct_field = shift @_;
    
    #print "\$distinct_field = $distinct_field <br>";

    my $sql = undef;
    
    if ($this->{keys_str} eq "") { ### 09/02/2006
    
        if ($distinct_field ne "") { ### 12/02/2006
            # $sql = "select distinct $distinct_field from " . $this->{table};
            
            $sql = "select count(distinct $distinct_field) as counter from " . $this->{table}; ### 31/08/2006

        } else {
            # $sql = "select * from " . $this->{table};
            
            $sql = "select count(*) as counter from " . $this->{table}; ### 31/08/2006
        }
        
        if ($keys ne "" && $values ne "") {
        
            $sql .= " where ";
            
            $values = $this->translate_Esc_Char_To_Code($values);

            $values =~ s/\\ /_space_/g;

            my @k = split(/ /, $keys);
            my @v = split(/ /, $values);

            my $i = 0;

            for ($i = 0; $i < @k; $i++) {
                $v[$i] =~ s/_space_/ /g;
                
                $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
                
                $v[$i] = $this->escape_DB_Special_Char($v[$i]);

                $sql = $sql . "$k[$i] = '$v[$i]' and ";
            }

            $sql = substr($sql, 0, length($sql) - 5);
        }
        
    } else {
        if ($distinct_field ne "") { ### 12/02/2006
            # $sql = "select distinct $distinct_field from " . $this->{table} . " where " . $this->{keys_str};
            
            $sql = "select count(distinct $distinct_field) as counter from " . $this->{table} . " where " . $this->{keys_str}; ### 31/08/2006
            
        } else {
            # $sql = "select * from " . $this->{table} . " where " . $this->{keys_str};
            
            $sql = "select count(*) as counter from " . $this->{table} . " where " . $this->{keys_str}; ### 31/08/2006
        }
    }
    
    $this->{sql} = $sql;
    
    my $counter = 0;
    
    if ($this->{db_interface} eq "Pg") {
        $result = $this->{db_conn}->exec($sql);
        
        #while (@data = $result->fetchrow) {
        #   $counter++;
        #}
        
        @data = $result->fetchrow;
        
        $counter = $data[0];

    } elsif ($this->{db_interface} eq "DBI") {
        $sth = $this->{db_conn}->prepare($sql);
        if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }

        $sth->execute;
        if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
        
        #while (@data = $sth->fetchrow_array) {
        #   $counter++;
        #}
        
        @data = $sth->fetchrow_array;
        
        $counter = $data[0];
        
        $sth->finish;
    }
    
    return $counter;
}

sub get_Item {
    my $this = shift @_;
    
    my $item_field = shift @_; 
    
    my $keys = shift @_;
    my $values = shift @_;    
    
    my $sql = undef;
    
    if ($this->{keys_str} eq "") { ### 04/07/2006
    
        if ($keys ne "" && $values ne "") { ### 30/01/2005

            $sql = "select $item_field from " . $this->{table} . " where ";

            $values = $this->translate_Esc_Char_To_Code($values);

            $values =~ s/\\ /_space_/g;

            my @k = split(/ /, $keys);
            my @v = split(/ /, $values);

            my $i = 0;

            for ($i = 0; $i < @k; $i++) {
                $v[$i] =~ s/_space_/ /g;

                $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
                
                $v[$i] = $this->escape_DB_Special_Char($v[$i]);

                $sql = $sql . "$k[$i] = '$v[$i]' and ";
            }

            $sql = substr($sql, 0, length($sql) - 5);

        } else {
            $sql = "select $item_field from " . $this->{table};
        }
        
    } else {
        $sql = "select $item_field from " . $this->{table} . " where " . $this->{keys_str};
    }
    
    $this->{sql} = $sql;
    
    my @data = ();
    
    if ($this->{db_interface} eq "Pg") {
        $result = $this->{db_conn}->exec($sql);
        @data = $result->fetchrow;

    } elsif ($this->{db_interface} eq "DBI") {
        $sth = $this->{db_conn}->prepare($sql);        
        
        if ($DBI::errstr) { 
            $this->{db_error} = $DBI::errstr;
            
        } else {
            $sth->execute;
            
            if ($DBI::errstr) { 
                $this->{db_error} = $DBI::errstr; 
                
            } else {
                @data = $sth->fetchrow_array;
            }
        }
        
        $sth->finish;
    }

    if ($#data > -1) {
        if ($this->{escape_HTML_tag}) {
            $data[0] =~ s/&/&amp;/g; ### 24/08/2005
            $data[0] =~ s/</&lt;/g;
            $data[0] =~ s/>/&gt;/g;
            $data[0] =~ s/"/&quot;/g; ### "
        }
        
        return $data[0];
    } else {
        return "";
    }
}

sub get_Items { ### 27/05/2005
    my $this = shift @_;
    
    my $item_fields = shift @_; 
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $order = shift @_;
    
    my $distinct_mode = shift @_;
    
    my $sql = undef;
    
    my @array_fields = split(/ /, $item_fields);
    $item_fields =~ s/ /,/g;
    
    if ($item_fields eq "*") { ### 15/06/2013
        my @ahr = $this->get_Table_Structure;
        
        for (my $i = 0; $i < @ahr; $i++) {
            $array_fields[$i] = $ahr[$i]->{field_name};
        }
    }
    
    if ($distinct_mode == 1) {
        $distinct_mode = "distinct";
    } else {
        $distinct_mode = undef;
    }
    
    if ($this->{keys_str} ne "") { ### 08/02/2005
        $sql = "select $distinct_mode $item_fields from " . $this->{table} . " where " . $this->{keys_str} . " ";
        
    } else {
        if ($keys ne "" && $values ne "") { ### 30/01/2005

            $sql = "select $distinct_mode $item_fields from " . $this->{table} . " where ";
            
            $values = $this->translate_Esc_Char_To_Code($values);
            
            $values =~ s/\\ /_space_/g;

            my @k = split(/ /, $keys);
            my @v = split(/ /, $values);

            for (my $i = 0; $i < @k; $i++) {
                $v[$i] =~ s/_space_/ /g;
                
                $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
                
                $v[$i] = $this->escape_DB_Special_Char($v[$i]);
                
                $sql = $sql . "$k[$i] = '$v[$i]' and ";
            }

            $sql = substr($sql, 0, length($sql) - 5);

        } else {
            $sql = "select $distinct_mode $item_fields from " . $this->{table};
        }
    }
    
    if ($order ne "") {
        $sql .= " order by $order";
    }
    
    $this->{sql} = $sql; 
    
    if ($this->{debug_sql}) { print "\$sql = $sql <br>"; }; 
    
    my @array_hash_ref = ();
    my $counter = 0;
    
    if ($this->{db_interface} eq "Pg") {
        $result = $this->{db_conn}->exec($sql);
        
        while (@data = $result->fetchrow) {
            my $hash_data = {};
            
            for (my $i = 0; $i < @data; $i++) {
            
                if ($this->{escape_HTML_tag}) { ### 01/04/2009
                    $data[$i] =~ s/&/&amp;/g;
                    $data[$i] =~ s/</&lt;/g;
                    $data[$i] =~ s/>/&gt;/g;
                    $data[$i] =~ s/"/&quot;/g; ### "
                }
                
                $hash_data->{$array_fields[$i]} = $data[$i];
                #print "\$hash_data->{$array_fields[$i]} = $data[$i];<br>";
            }
            
            $array_hash_ref[$counter] = $hash_data;
            $counter++;
        }

    } elsif ($this->{db_interface} eq "DBI") {
        $sth = $this->{db_conn}->prepare($sql);
        if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }

        $sth->execute;
        if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
        
        while (@data = $sth->fetchrow_array) {
            my $hash_data = {};
            
            for ($i = 0; $i < @data; $i++) {
            
                if ($this->{escape_HTML_tag}) { ### 01/04/2009
                    $data[$i] =~ s/&/&amp;/g;
                    $data[$i] =~ s/</&lt;/g;
                    $data[$i] =~ s/>/&gt;/g;
                    $data[$i] =~ s/"/&quot;/g; ### "
                }
                
                $hash_data->{$array_fields[$i]} = $data[$i];
                #print "\$hash_data->{$array_fields[$i]} = $data[$i];<br>";
            }
            
            $array_hash_ref[$counter] = $hash_data;
            $counter++;
        }
        
        $sth->finish;
    }
    
    #for ($i = 0; $i < @array_hash_ref; $i++) {
    #   print "param_name = " . $array_hash_ref[$i]->{param_name} . ", ";
    #   print "param_value = " . $array_hash_ref[$i]->{param_value} . "<br>";
    #}
    
    if ($this->{debug_sql}) { print "\$counter = $counter <br>"; }
    
    return @array_hash_ref;
}

sub get_MAX_Item {
    my $this = shift @_;
    
    my $item_field = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $sql = undef;
    
    if ($this->{keys_str} ne "") { ### 14/01/2007
        $sql = "select max($item_field) as max from " . $this->{table} . " where " . $this->{keys_str};
        
    } else {
    
        if ($keys ne "" && $values ne "") { ### 30/01/2005

            $sql = "select max($item_field) as max from " . $this->{table} . " where ";

            $values = $this->translate_Esc_Char_To_Code($values);

            $values =~ s/\\ /_space_/g;

            my @k = split(/ /, $keys);
            my @v = split(/ /, $values);

            my $i = 0;

            for ($i = 0; $i < @k; $i++) {
                $v[$i] =~ s/_space_/ /g;

                $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
                
                $v[$i] = $this->escape_DB_Special_Char($v[$i]);

                $sql = $sql . "$k[$i] = '$v[$i]' and ";
            }

            $sql = substr($sql, 0, length($sql) - 5);

        } else {

            $sql = "select max($item_field) as max from " . $this->{table};
        }
    }
    
    $this->{sql} = $sql;
    
    if ($this->{db_interface} eq "Pg") {
        $result = $this->{db_conn}->exec($sql);
        @data = $result->fetchrow;

    } elsif ($this->{db_interface} eq "DBI") {
        $sth = $this->{db_conn}->prepare($sql);

        $sth->execute;
        @data = $sth->fetchrow_array;
        $sth->finish;
    }

    if ($#data > -1) {
        return $data[0];
    } else {
        return "";
    }
    
}

sub get_MIN_Item { ### 19/09/2005
    my $this = shift @_;
    
    my $item_field = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $sql = undef;
    
    if ($this->{keys_str} ne "") { ### 14/01/2007
        $sql = "select min($item_field) as min from " . $this->{table} . " where " . $this->{keys_str};
        
    } else {
    
        if ($keys ne "" && $values ne "") { 

            $sql = "select min($item_field) as min from " . $this->{table} . " where ";

            $values = $this->translate_Esc_Char_To_Code($values);

            $values =~ s/\\ /_space_/g;

            my @k = split(/ /, $keys);
            my @v = split(/ /, $values);

            my $i = 0;

            for ($i = 0; $i < @k; $i++) {
                $v[$i] =~ s/_space_/ /g;

                $v[$i] = $this->translate_Esc_Code_To_Char($v[$i]);
                
                $v[$i] = $this->escape_DB_Special_Char($v[$i]);

                $sql = $sql . "$k[$i] = '$v[$i]' and ";
            }

            $sql = substr($sql, 0, length($sql) - 5);

        } else {

            $sql = "select min($item_field) as min from " . $this->{table};
        }
    }
    
    $this->{sql} = $sql;
    
    if ($this->{db_interface} eq "Pg") {
        $result = $this->{db_conn}->exec($sql);
        @data = $result->fetchrow;

    } elsif ($this->{db_interface} eq "DBI") {
        $sth = $this->{db_conn}->prepare($sql);

        $sth->execute;
        @data = $sth->fetchrow_array;
        $sth->finish;
    }

    if ($#data > -1) {
        return $data[0];
    } else {
        return "";
    }
    
}

sub translate_Esc_Char_To_Code { ### 30/06/2006
    $this = shift @_;
    
    my $str = shift @_;
    
    $str =~ s/\//__2F__/g;
            
    $str =~ s/\[/__5B__/g;
    $str =~ s/\]/__5D__/g;
            
    $str =~ s/\(/__28__/g;
    $str =~ s/\)/__29__/g;
            
    $str =~ s/\&/__26__/g;
    
    return $str;  
}

sub translate_Esc_Code_To_Char { ### 30/06/2006
    $this = shift @_;
    
    my $str = shift @_;
    
    $str =~ s/__2F__/\//g;
            
    $str =~ s/__5B__/\[/g;
    $str =~ s/__5D__/\]/g;
            
    $str =~ s/__28__/\(/g;
    $str =~ s/__29__/\)/g;
            
    $str =~ s/__26__/\&/g;
    
    return $str;  
}

sub escape_DB_Special_Char { ### 11/04/2008
    $this = shift @_;
    
    my $str = shift @_;
    
    $str =~ s/\\/\\\\/g;
    $str =~ s/\'/\\\'/g; 
    $str =~ s/\"/\\\"/g; ### "
    $str =~ s/\0/\\\0/g;
    
    return $str;
}

sub get_Unique_Random_Num {
    my $this = shift @_;
    
    my $pk_field_name = shift @_;
    my $min_num = shift @_;
    my $max_num = shift @_;
    
    if ($min_num eq "") {
        $min_num = 100000;
    }
    
    if ($max_num eq "") {
        $max_num = 999999;
    }
    
    
    my $exist = 1;
    my $unique_random_num = undef;
    
    while ($exist || $unique_random_num < $min_num) {
        $unique_random_num = int rand $max_num;
            
        $exist = $this->find_Item("$pk_field_name", "$unique_random_num");
    }
    
    return $unique_random_num;
}

sub get_Unique_Random_36Base { ### 23/02/2011
    my $this = shift @_;
    
    my $pk_field_name = shift @_;
    my $length = shift @_;
    
    if ($length < 1) {
        $length = 6;
    }
    
    my @base36list = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
                      "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", 
                      "W", "X", "Y", "Z");
    
    my $exist = 1;
    my $unique_rand_36Base = undef;
    
    if ($this->field_Exist($pk_field_name)) {
        while ($exist) {
            $unique_rand_36Base = "";
            
            for (my $i = 0; $i < $length; $i++) {
                my $index = int rand 35;
                
                $unique_rand_36Base .= $base36list[$index];
            }
            
            $exist = $this->find_Item("$pk_field_name", "$unique_rand_36Base");
        }
    }
    
    return $unique_rand_36Base;
}

sub get_Unique_Random_62Base { ### 11/03/2011
    my $this = shift @_;
    
    my $pk_field_name = shift @_;
    my $length = shift @_;
    
    if ($length < 1) {
        $length = 6;
    }
    
    my @base62list = ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
                      "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", 
                      "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
                      "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
    
    my $exist = 1;
    my $unique_rand_62Base = undef;
    
    if ($this->field_Exist($pk_field_name)) {
        while ($exist) {
            $unique_rand_62Base = "";
            
            for (my $i = 0; $i < $length; $i++) {
                my $index = int rand 61;
                
                $unique_rand_62Base .= $base62list[$index];
            }
            
            $exist = $this->find_Item("$pk_field_name", "$unique_rand_62Base");
        }
    }
    
    return $unique_rand_62Base;
}

sub field_Exist { ### 08/02/2011
    my $this = shift @_;
    
    my $field_name = shift @_;
    
    my $table_name = $this->{table};
    
    if ($table_name ne "") {
        my @ahr = $this->get_Table_Structure;
        
        foreach my $item (@ahr) {
            if ($item->{field_name} eq $field_name) {
                return 1;
            }
        }
    }
    
    return 0;
}

sub table_Exist { ### 09/02/2006
    my $this = shift @_;
    
    my $other_table_name = shift @_;
    
    my $current_table_name = $this->{table};
    
    my $table_name = $current_table_name;
    
    #print "\$other_table_name = $other_table_name <br>";
    #print "\$current_table_name = $current_table_name <br>";
    
    if ($other_table_name eq "" && $current_table_name eq "") {
        return 0;
        
    } else {
        if ($other_table_name ne "") {
            $table_name = $other_table_name;
        }
        
        #print "\$table_name = $table_name <br>";
        
        my $item = undef;
        my $dbh = $this->{db_conn};
        my @tables = $dbh->tables;
        
        foreach $item (@tables) {
            #print "\$item = $item <br>";
            
            $item =~ s/\`//g; ### 23/06/2006
            
            if ($item =~ /\./) { ### 04/07/2009
                my @data = split(/\./, $item);
                $item = $data[1];
            }
            
            if ($table_name eq $item) {
                return 1;
            }
        }
    }
    
    return 0;
}

sub get_Table_List { ### 11/12/2009
    my $this = shift @_;
    
    my $dbh = $this->{db_conn};
    my @tables = $dbh->tables;
    
    my $tables_ref = \@tables;
    
    for (my $i = 0; $i < @tables; $i++) {
        $tables_ref->[$i] =~ s/^`//;
        $tables_ref->[$i] =~ s/`$//;
        $tables_ref->[$i] =~ s/^.+`\.`//;
        
        #print "\$tables_ref->[$i] = $tables_ref->[$i]\n";
    }
    
    return @tables;
}

sub get_Table_Structure { ### 15/01/2011
    my $this = shift @_;
    
    my $other_table_name = shift @_;
    
    my $current_table_name = $this->{table};    
    my $table_name = $current_table_name;
    
    if ($other_table_name eq "" && $current_table_name eq "") {
        return undef;
        
    } else {
        if ($other_table_name ne "") {
            $table_name = $other_table_name;
        }
        
        ### below is specifically only for mysql
        
        my $sth = $this->{db_conn}->prepare("describe $table_name");

        $sth->execute;
        
        my @ahr = ();
        
        while (my $data = $sth->fetchrow_hashref) {
            my $field_type = $data->{Type};
            my $field_length = $data->{Type};
            my $can_null = 0;
            my $is_auto_increment = 0;
            my $default_value = undef;
            
            $field_type =~ s/\([0-9]+\)//;
            
            if ($field_length =~ /\([0-9]+\)/) {
                $field_length =~ s/^.+\(//;
                $field_length =~ s/\).*$//;
                
            } else {
                $field_length = undef;
            }
            
            if ($data->{Null} eq "YES") { $can_null = 1; }
            
            if ($data->{Extra} =~ /auto_increment/) { $is_auto_increment = 1; }
           
            if ($data->{Default} ne "") { $default_value = $data->{Default}}
            
            #print "$data->{Field} - $field_type - $field_length\n";
            
            push(@ahr, {field_name=>$data->{Field}, field_type=>$field_type, field_length=>$field_length, 
                        can_null=>$can_null, key=>$data->{Key}, default_value=>$default_value, is_auto_increment=>$is_auto_increment});
            
        }
        
        return @ahr;
    }
}

sub drop_Table { ### 09/02/2006
    my $this = shift @_;
    
    my $other_table_name = shift @_;
    
    my $current_table_name = $this->{table};
    
    my $table_name = $current_table_name;
    
    #print "\$other_table_name = $other_table_name <br>";
    #print "\$current_table_name = $current_table_name <br>";
    
    if ($other_table_name eq "" && $current_table_name eq "") {
        return 0;
        
    } else {
        if ($other_table_name ne "") {
            $table_name = $other_table_name;
        }
        
        #print "\$table_name = $table_name <br>";
    
        if ($this->{db_interface} eq "Pg") {
            $result = $this->{db_conn}->exec("drop table " . $table_name);

        } elsif ($this->{db_interface} eq "DBI") { 
            $sth = $this->{db_conn}->prepare("drop table " . $table_name);
            $sth->execute;
            $sth->finish;
        }
    }
}

sub copy_Table { ### 09/02/2006
    my $this = shift @_;
    
    my $src_dbi_driver = shift @_;
    my $src_table_name = shift @_;
    
    my $target_conn = shift @_;
    my $target_table_name = shift @_;
    
    my $src_fields = shift @_;
    
    my $src_conn = $this->{db_conn};
    
    if ($src_dbi_driver ne "" && $src_table_name ne "" && $target_conn ne "" && $target_table_name ne "") {
        
            my $sth_s = undef;
            my $sth_t = undef;
            
            my $sql = undef;
            
            ### specific variables for Postgresql
            my @ti = undef;
            
            ### specific variables for MySQL
            my $numFields;
            my $field_names;
            my $field_types;
            my $field_lengths;
            my $field_pks;
            
            my $ct_info = "";
        my $pk_info = "primary key(";
        
        
        if ($src_dbi_driver eq "Pg") { ########## Postgresql
            # print "Process for postgres<br>";
            
            my %type_id_field = ("4" => "int", "5" => "smallint", "12" => "varchar",
                         "1" => "char", "9" => "date", "92" => "time");

            my $table_info = $src_conn->func($src_table_name, "table_attributes");

            @ti = @$table_info; 

            for ($i = 0; $i < @ti; $i++) {
                $field_name = $ti[$i]->{NAME}; # print "\$field_name = $field_name <br>";

                $field_type = $ti[$i]->{TYPE};
                $field_type = $type_id_field {$field_type};


                $field_length = $ti[$i]->{SIZE};
                $field_pk = $ti[$i]->{PRIMARY_KEY};

                $ct_info .= "$field_name $field_type";

                #print "$field_name - $field_type - $field_length\n";

                if ($field_type eq "varchar" || $field_type eq "char") {
                    $ct_info .= "($field_length)";
                } 

                if ($field_pk eq "1") {
                    $ct_info .= " not null";
                    $pk_info .= "$field_name, ";
                }

                if ($i + 1 < @ti) {
                    $ct_info .= ", ";
                }
            }

        } elsif ($src_dbi_driver eq "mysql") { ########## MySQL
            my $sth = $src_conn->prepare("select * from $src_table_name");

            $sth->execute;

            $numFields = $sth->{NUM_OF_FIELDS};

            $field_names = $sth->{NAME};
            $field_types = $sth->{mysql_type_name};
            $field_lengths = $sth->{mysql_length};
            $field_pks = $sth->{mysql_is_pri_key};

            for ($i = 0; $i < $numFields; $i++) {
                #print $i + 1 . "\t $$field_names[$i]-$$field_types[$i]-$$field_lengths[$i]-$$field_pks[$i]\n";

                $field_name = $$field_names[$i];
                $field_type = $$field_types[$i];
                $field_length = $$field_lengths[$i];
                $field_pk = $$field_pks[$i];

                $ct_info .= "$field_name $field_type";

                #print "$field_name - $field_type \n";

                if ($field_type eq "varchar" || $field_type eq "char") {
                    $ct_info .= "($field_length)";
                } 

                if ($field_pk eq "1") {
                    $ct_info .= " not null";
                    $pk_info .= "$field_name, ";
                }

                if ($i + 1 < $numFields) {
                    $ct_info .= ", ";
                }
            }
        }


        $pk_info .= ")";
        $pk_info =~ s/, \)/\)/;


        $sql = "create table $target_table_name ($ct_info";

        if (length($pk_info) > 13) {
            $sql .= ", $pk_info)";
        } else {
            $sql .= ")";
        }
        
        $this->set_DBI_Conn($target_conn); 
        
        if (!$this->table_Exist($target_table_name)) {
            #print "SQL for create table:<br>\n$sql <br>";
        
            $sth_t = $target_conn->prepare($sql);
            $sth_t->execute;
            $sth_t->finish;
        }
        
        $this->set_DBI_Conn($src_conn);
        
        $sth_s = $src_conn->prepare("select * from $src_table_name");
        
        $sth_s->execute;
        
        my $hr = undef;
        my $itf_info = undef;
        my $itv_info = undef;
        my $row = 1;
        my $str_value = undef;
        
        while ($hr = $sth_s->fetchrow_hashref) {
            $itf_info = "";
            $itv_info = "";
            
            if ($src_dbi_driver eq "Pg") { ########## Postgresql

                for ($i = 0; $i < @ti; $i++) {
                    $field_name = $ti[$i]->{NAME};

                    if ($hr->{$field_name} eq "") {
                        $hr->{$field_name} = "NULL";
                        $str_value = "";

                    } else {
                        $str_value = $hr->{$field_name};
                        $str_value =~ s/\'/quote_/g;
                        $str_value =~ s/quote_/\\\'/g;

                        #print "\$str_value = $str_value \n";
                    }

                    $itf_info .= $field_name;
                    $itv_info .= "'$str_value'";

                    if ($i + 1 < @ti) {
                        $itf_info .= ", ";
                        $itv_info .= ", ";
                    }
                }

            } elsif ($src_dbi_driver eq "mysql") { ########## MySQL
                for ($i = 0; $i < $numFields; $i++) {
                    $field_name = $$field_names[$i];

                    if ($hr->{$field_name} eq "") {
                        $hr->{$field_name} = "NULL";
                        $str_value = "";

                    } else {
                        $str_value = $hr->{$field_name};
                        $str_value =~ s/\'/quote_/g;
                        $str_value =~ s/quote_/\\\'/g;

                        #print "\$str_value = $str_value \n";
                    }

                    $itf_info .= $field_name;
                    $itv_info .= "'$str_value'";

                    if ($i + 1 < $numFields) {
                        $itf_info .= ", ";
                        $itv_info .= ", ";
                    }
                }
            }

            #print "insert into $target_table_name ($itf_info) values ($itv_info)\n";

            $sth_t = $target_conn->prepare("insert into $target_table_name ($itf_info) values ($itv_info)");
            $sth_t->execute;
            $sth_t->finish;

            #print "insert row # $row\n";

            $row++;
        }
            
        return 1; 
        
    } else {
        return 0; 
    }
    
}

sub check_DB_Item_Auth { ### 15/05/2006
    my $this = shift @_;
    
    my $access_mode = shift @_; ### can be INSERT, UPDATE or DELETE
    
    $this->{field_value_hash_ref} = shift @_;
    
    my $pass_auth = 1;
    
    $pass_auth = $this->authenticate_DB_Item_Access($access_mode);
    
    return $pass_auth;
}

sub authenticate_DB_Item_Access { ### 11/03/2006
    my $this = shift @_;
    
    my $access_mode = shift @_; ### can be INSERT, UPDATE or DELETE
    
    my $login_name = $this->{login_name};
    my $groups_array_ref = $this->{groups};
    my $db_item_auth_table_name = $this->{db_item_auth_table_name};
    my $user_group_auth_table_name = $this->{user_group_table_name};
    
    my $cgi = $this->{cgi};
    
    if ($cgi eq "") {
        $cgi = new GMM_CGI;
    }
    
    if ($db_item_auth_table_name eq "") {
        $db_item_auth_table_name = "webman_" . $cgi->param("app_name") . "_db_item_auth";
    }
    
    if ($user_group_auth_table_name eq "") {
        $user_group_auth_table_name = "webman_" . $cgi->param("app_name") . "_user_group";
    }
    
    my $db_conn = $this->{db_conn};
    my $table = $this->{table};

    my %field_value = %{$this->{field_value_hash_ref}};
    my $key = undef;
    
    #$cgi->add_Debug_Text("\$table = $table", __FILE__, __LINE__, "TRACING");
    #$cgi->add_Debug_Text("\$login_name = $login_name", __FILE__, __LINE__, "TRACING");
    #$cgi->add_Debug_Text("\$db_item_auth_table_name = $db_item_auth_table_name", __FILE__, __LINE__, "TRACING");
    #$cgi->add_Debug_Text("\$user_group_auth_table_name = $user_group_auth_table_name", __FILE__, __LINE__, "TRACING");    
    
    #print "Try to check DB item access authentication for user $login_name (@{$groups_array_ref}) <br>\n";
       
    #######################################################################
    
    my $backup_sql = $this->{sql}; ### store sql for original DBU operation
    my $backup_keys_str = $this->{keys_str}; ### backup keys_str if it's set by user
    
    $this->{keys_str} = undef; ### so it will not disturbing the next following DB item operations 
    
    ### check if current table is authenticated, return 1 if not
    
    $this->set_Table($db_item_auth_table_name);
    
    my $found_item = $this->find_Item("table_name", "$table");
    
    #$cgi->add_Debug_Text("SQL = $this->{sql}", __FILE__, __LINE__, "DATABASE");
    
    if (!$found_item) {
        ### restore back the previous task of DBU set by user
        $this->set_Table($table ); 
        $this->{sql} = $backup_sql;
        $this->{keys_str} = $backup_keys_str;
        
        #print "Debug 1 <br>\n";
        
        return 1;
    }
    
    #######################################################################
    
    my @array_hash_ref = ();
    my $item = undef;
    
    my @user_auth_keys = undef;
    my @group_auth_keys = undef;
    
    my $auth_key = undef;
    
    ### check if current user match for current table #####################
    
    $this->set_Table($db_item_auth_table_name);
    
    my $found_user = $this->find_Item("table_name login_name", "$table $login_name");
    
    #$cgi->add_Debug_Text("SQL = $this->{sql}", __FILE__, __LINE__, "DATABASE");
    
    if ($found_user) {
        @user_auth_keys = $this->get_Items("key_field_name key_field_value mode_insert mode_update mode_delete", "table_name login_name", "$table $login_name");

        foreach $key (keys %field_value) {
            #print "$key = $field_value{$key} <br>\n";
            
            foreach $auth_key (@user_auth_keys) {
                if ($auth_key->{key_field_name} eq $key) {
                    if ($auth_key->{key_field_value} eq $field_value{$key}) {
                        if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                            #print "current user ($login_name) can modified current table ($table) item through login name <br>\n";
                            
                            ### restore back the previous task of DBU set by user
                            $this->set_Table($table ); 
                            $this->{sql} = $backup_sql;
                            $this->{keys_str} = $backup_keys_str;
                            
                            #print "Debug 2 <br>\n";
                            
                            return 1;
                        } 
                    }
                    
                    if ($auth_key->{key_field_value} eq "*") {
                        if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                            #print "current user ($login_name) can modified current table ($table) item through login name <br>\n";
                            
                            ### restore back the previous task of DBU set by user
                            $this->set_Table($table ); 
                            $this->{sql} = $backup_sql;
                            $this->{keys_str} = $backup_keys_str;
                            
                            #print "Debug 3 <br>\n";
                            
                            return 1;
                        } 
                    }
                }
            }
        }
    }
    
    ### check if current user groups match for current table ##############
        
    $this->set_Table($user_group_auth_table_name);
        
    @array_hash_ref = $this->get_Items("group_name", "login_name", "$login_name");
    
    $this->set_Table($db_item_auth_table_name);
    
    foreach $item (@array_hash_ref) {
        #$cgi->add_Debug_Text("\$item->{group_name} = $item->{group_name}", __FILE__, __LINE__, "TRACING");
        
        my $found_item = $this->find_Item("table_name group_name", "$table $item->{group_name}");
        
        #$cgi->add_Debug_Text("SQL = $this->{sql}", __FILE__, __LINE__, "DATABASE");
        
        if ($found_item) {

            @group_auth_keys = $this->get_Items("key_field_name key_field_value mode_insert mode_update mode_delete", "table_name group_name", "$table $item->{group_name}");
            
            #$cgi->add_Debug_Text("SQL = $this->{sql}", __FILE__, __LINE__, "DATABASE");

            foreach $key (keys %field_value) {
                #$cgi->add_Debug_Text("$key = $field_value{$key}", __FILE__, __LINE__, "TRACING");

                foreach $auth_key (@group_auth_keys) {
                    if ($auth_key->{key_field_name} eq $key) {
                        if ($auth_key->{key_field_value} eq $field_value{$key}) {
                            if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                                #print "current user ($login_name) can modified current table ($table) item through group ($item->{group_name}) <br>\n";
                                
                                ### restore back the previous task of DBU set by user
                                $this->set_Table($table ); 
                                $this->{sql} = $backup_sql;
                                $this->{keys_str} = $backup_keys_str;
                                
                                #print "Debug 4 <br>\n";
                                
                                return 1;
                            }
                        }
                        
                        if ($auth_key->{key_field_value} eq "*") {
                            if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                                #print "current user ($login_name) can modified current table ($table) item through group ($item->{group_name}) <br>\n";
                                
                                ### restore back the previous task of DBU set by user
                                $this->set_Table($table ); 
                                $this->{sql} = $backup_sql;
                                $this->{keys_str} = $backup_keys_str;
                                
                                #print "Debug 5 <br>\n";
                                
                                return 1;
                            }
                        }
                    }
                }
            }
        }
    }
    
    #print "current user ($login_name) can't modified current table ($table) item. <br>\n";
    
    if ($this->{error_back_link} eq "") {
        my $session_id = $this->{cgi}->param("session_id");
        my $link_id = $this->{cgi}->param("link_id");
        my $app_name = $this->{cgi}->param("app_name");
        
        $this->{error_back_link} = "<a href=\"index.cgi?session_id=$session_id&link_id=$link_id&task=\">Back to previous possible working page.</a>";
    } 
       
    my $error_message  = "<center>";
       $error_message .= "<h3>Webman Framework Access Control</h3>\n";
       $error_message .= "<b>Error:</b> Don't have privilege to access selected database table [<b>$table</b>] item.<p>\n";
       $error_message .= "$this->{error_back_link}\n";
       $error_message .= "</center>\n";    
    
    $this->{db_item_access_error_message} = $error_message;
    
    ### restore back the previous task of DBU set by user
    $this->set_Table($table ); 
    $this->{sql} = $backup_sql;
    $this->{keys_str} = $backup_keys_str;
    
    return 0;
}

sub check_DB_Item_Access_User {
    my $this = shift @_;
}

sub valid_DB_Item_Access_Mode { ### 15/05/2006
    my $this = shift @_;
    
    my $mode = shift @_; ### can be INSERT, UPDATE or DELETE
    
    my $mode_insert = shift @_;
    my $mode_update = shift @_;
    my $mode_delete = shift @_;
    
    if ($mode ne "") {
        if ($mode eq "INSERT" && $mode_insert != 1) { return 0; }           

        if ($mode eq "UPDATE" && $mode_update != 1) { return 0; }

        if ($mode eq "DELETE" && $mode_delete != 1) { return 0; }

        return 1;

    } else {
        return 1;
    }
}

1;
