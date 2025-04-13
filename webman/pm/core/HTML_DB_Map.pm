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

package HTML_DB_Map;

use DB_Utilities;

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{cgi} = shift @_;
    $this->{table} = shift @_;
    $this->{auto_inc_PK} = shift @_;
    
    $this->{db_conn} = undef; ### 12/03/2004
    $this->{db_interface} = undef; ### 12/03/2004
    
    $this->{exceptional_fields} = undef;
    
    $this->{update_keys_str} = undef; ### 17/08/2005
    
    $this->{field_value_hash_ref} = undef; ### hash ref. of DB field=>value
    
    $this->{auth_mode} = 0;
    
    $this->{login_name} = undef; ### 11/03/2006
    $this->{groups} = undef; ### 11/03/2006 (array ref.)
    $this->{db_item_auth_table_name} = undef; ### 11/03/2006
    
    $this->{db_item_access_error_message} = undef; ### 11/03/2006
    
    $this->{error_back_link} = undef; ### 16/05/2006
    
    $this->{sql} = undef;
        
    bless $this, $class;
    
    return $this;
}

sub set_CGI {
    my $this = shift @_;
    
    $this->{cgi} = shift @_;
}

sub set_Conn {
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
}

sub set_Pg_Conn { ### 12/03/2004
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
    $this->{db_interface} = "Pg"; 
}

sub set_DBI_Conn { ### 12/03/2004
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
    $this->{db_interface} = "DBI";
    
    ### 11/04/2014
    $this->{dbu} = new DB_Utilities;
    $this->{dbu}->set_DBI_Conn($this->{db_conn});     
}

sub set_Table {
    my $this = shift @_;
    
    $this->{table} = shift @_;
}

sub set_Auto_Inc_PK {
    my $this = shift @_;
    
    $this->{auto_inc_PK} = shift @_;
}

sub set_Exceptional_Fields { ### 11/03/2005
    my $this = shift @_;
    
    my $exceptional_field = shift @_;
    
    #print "<p>\$exceptional_field = $exceptional_field</p>";
    
    my @exceptional_fields = split(/ /, $exceptional_field);
    
    $this->{exceptional_fields_dict} = {};
    
    foreach my $item (@exceptional_fields) {
        $this->{exceptional_fields_dict}->{$item} = 1;
    }
}

sub set_Update_Keys_Str { ### 17/08/2005
    my $this = shift @_;
    
    $this->{update_keys_str} = shift @_;
}

sub set_Error_Back_Link { ### 16/05/2006
    my $this = shift @_;
    
    $this->{error_back_link} = shift @_;
}

sub exceptional_Field { ### 11/03/2005
    my $this = shift @_;
    
    my $field = shift @_;
    
    return $this->{exceptional_fields_dict}->{$field};
}

sub set_DB_Item_Auth_Info { ### 11/03/2006
    my $this = shift @_;
    
    $this->{login_name} = shift @_; 
    $this->{groups} = shift @_; ### array ref.
    $this->{db_item_auth_table_name} = shift @_;
    
    $this->{auth_mode} = 1;
    
    ### 11/04/2014
    $this->{dbu}->set_Table("webman_" . $this->{cgi}->param("app_name") . "_user");
    $this->{user_fullname} = $this->{dbu}->get_Item("full_name", "login_name", $this->{login_name});    
}

sub get_Auth_Error_Message {
    my $this = shift @_;
    
    return $this->{db_item_access_error_message};
}

sub get_DB_Error_Message {
    my $this = shift @_;
    
    return $this->{db_error};
}

sub get_SQL {
    my $this = shift @_;
    
    return $this->{sql};
}

sub insert_Table {
    my $this = shift @_;
    
    my $execute = shift @_;
    
    if ($execute eq "") {
        $execute = 1;
    }    
    
    my $sth = undef;
    
    my $cgi = $this->{cgi};
    my $db_conn = $this->{db_conn};
    my $table = $this->{table};
    my $auto_inc_PK = $this->{auto_inc_PK};
    
    ### 08/02/2011 ##############################################
    $this->generate_ISO_Date_Time;
        
    my $dbu = $this->{dbu};
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($table);
    
    if ($dbu->field_Exist("wmf_date_created") && $cgi->param("\$db_wmf_date_created") eq "") {
        $cgi->push_Param("\$db_wmf_date_created", $this->{iso_date});
    }
    
    if ($dbu->field_Exist("wmf_time_created") && $cgi->param("\$db_wmf_time_created") eq "") {
        $cgi->push_Param("\$db_wmf_time_created", $this->{iso_time});
    }
    
    ### 11/04/2014
    if ($dbu->field_Exist("wmf_created_by") && $cgi->param("\$db_wmf_created_by") eq "") {
        $cgi->push_Param("\$db_wmf_created_by", "$this->{login_name}-$this->{user_fullname}");
    }
    
    if ($dbu->field_Exist("wmf_created")) {
        $cgi->push_Param("\$db_wmf_created", "$this->{login_name}-$this->{user_fullname}, $this->{iso_date}, $this->{iso_time}");
    }
    
    ############################################################# 
        
    my @CGI_varName = $cgi->var_Name;
    my $fields = "";
    my $values = "";
    
    my %field_value = undef;
    
    ### 22/02/2011
    ### For insert operation, putting all table fields inside %field_value
    ### can facilitate the implemention of database item access control using 
    ### wildcard '*' value for table auto increment primary key
    
    my @ahr = $dbu->get_Table_Structure;
    
    foreach my $item (@ahr) {
        $field_value{$item->{field_name}} = undef;
    }
    
    #print "\@CGI_varName = @CGI_varName<br>";
    
    if ($this->{db_interface} eq "Pg") {
        $db_conn->exec("set datestyle to 'European'");
    }
    
    if ($auto_inc_PK ne "") {
        if ($this->{db_interface} eq "Pg") {
            $result = $db_conn->exec("select $auto_inc_PK from $table 
                                      order by $auto_inc_PK desc");
                                      
            @data =  $result->fetchrow;
            
        } elsif ($this->{db_interface} eq "DBI") {
            $sth = $db_conn->prepare("select $auto_inc_PK from $table 
                                      order by $auto_inc_PK desc");
                                      
            $sth->execute;
            @data = $sth->fetchrow_array;
            $sth->finish;
        }
        
        $auto_id = $data[0] + 1;
                
        $fields .= "$auto_inc_PK, ";
        $values .= "'$auto_id', ";
    }
    
    for ($j = 0; $j < @CGI_varName; $j++) {
        $field = $CGI_varName[$j];
        
        if ($this->exceptional_Field($field)) { ### 11/03/2005
            # do nothing
            
        } elsif ($field =~ /\$db_/ && !($field =~ /_\d+$/)) {
            $value = $cgi->param($field);
            $value =~ s/\\/\\\\/g;### 03/07/2004
            $value =~ s/\'/\\\'/g; 
            $value =~ s/\"/\\\"/g; ## "
            $value =~ s/\0/\\\0/g;
            
            $field =~ s/\$db_//;
            
            ### 13/04/2014
            if ($dbu->field_Exist($field)) {
                $fields .= "$field, ";
                $values .= "'$value', ";
                
                $field_value{$field} = $value;
            }
        }
    }
    
    $this->{field_value_hash_ref} = \%field_value;
    
    $values = substr($values, 0, length($values) - 2);
    $fields = substr($fields, 0, length($fields) - 2);
    
    #print "\$fields = $fields<br>";
    #print "\$values = $values<br>";
    
    ### 02/07/2011 ############################################################
    ### auto insert support for 36base & 62base primary key id based on 
    ### Webman's convention over configuration (CoC) for table's primary key 
    my $rnd362base = undef;
    my @ahr = $dbu->get_Table_Structure;
    
    my $first_field_name = $ahr[0]->{field_name};
    my $first_field_length = $ahr[0]->{field_length};
    
    ### Need to make sure it's not already added 
    ### possibly via CGI parameter push operation.
    if (!($fields =~ /$first_field_name/)) { 
        if ($first_field_name =~ /^id_.+_36base$/) { 
            $rnd362base = $dbu->get_Unique_Random_36Base($first_field_name, $first_field_length);
        }

        if ($first_field_name =~ /^id_.+_62base$/) {
            $rnd362base = $dbu->get_Unique_Random_62Base($first_field_name, $first_field_length);
        }

        if (defined($rnd362base)) {
            $fields = "$first_field_name, " . $fields;
            $values = "'$rnd362base', " . $values;        
        }
    }
    
    ###########################################################################
    
    $this->{sql} = "insert into $table ($fields) values ($values)";
    $this->{db_error} = "";
    
    my $pass_auth = 1;
    
    if ($this->{auth_mode}) { ### 11/03/2006
        $pass_auth = $this->authenticate_DB_Item_Access("INSERT");
    }
    
    
    if ($pass_auth) { 
        if ($this->{db_interface} eq "Pg") {
            $db_conn->exec("insert into $table ($fields) values ($values)");
        
        } elsif ($this->{db_interface} eq "DBI")  {     
            $sth = $db_conn->prepare("insert into $table ($fields) values ($values)");
            if ($DBI::errstr) { $this->{db_error} .= $DBI::errstr; }
            
            if ($execute && $this->{db_error} eq "") {
                $sth->execute;
                if ($DBI::errstr) { $this->{db_error} .= $DBI::errstr; }
            }
            
            $sth->finish;
        }
    }
    
    if ($this->{db_error} ne "") {
        return 0;
        
    } else {
        return 1;
    }
}

sub update_Table {
    my $this = shift @_;
    
    my $keys = shift @_;
    my $values = shift @_;
    
    my $execute = shift @_;
    
    if ($execute eq "") {
        $execute = 1;
    }     
    
    my $sth = undef;
    
    $cgi = $this->{cgi};
    $db_conn = $this->{db_conn};
    $table = $this->{table};
        
    $values =~ s/\b\\ \b/_space_/g;
        
    my @k = split(/ /, $keys);
    my @v = split(/ /, $values);
    
    my $i = 0;
    my $update_keys = "";
    
    if ($this->{update_keys_str} eq "") {
        for ($i = 0; $i < @k; $i++) {
            $v[$i] =~ s/_space_/ /g;

            $update_keys = $update_keys . "$k[$i] = '$v[$i]' and ";
        }

        $update_keys = substr($update_keys, 0, length($update_keys) - 5);
    } else {
        $update_keys = $this->{update_keys_str};
    }
    
    ### 08/02/2011 ##############################################
    $this->generate_ISO_Date_Time;
    
    my $dbu = $this->{dbu};
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($table);
    
    if ($dbu->field_Exist("wmf_date_modified") && $cgi->param("\$db_wmf_date_modified") eq "") {
        $cgi->push_Param("\$db_wmf_date_modified", $this->{iso_date});
    }
    
    if ($dbu->field_Exist("wmf_time_modified") && $cgi->param("\$db_wmf_time_modified") eq "") {
        $cgi->push_Param("\$db_wmf_time_modified", $this->{iso_time});
    } 
    
    ### 11/04/2014
    if ($dbu->field_Exist("wmf_modified_by") && $cgi->param("\$db_wmf_modified_by") eq "") {
        $cgi->push_Param("\$db_wmf_modified_by", "$this->{login_name}-$this->{user_fullname}");
    }
    
    if ($dbu->field_Exist("wmf_modified")) {
        $cgi->push_Param("\$db_wmf_modified", "$this->{login_name}-$this->{user_fullname}, $this->{iso_date}, $this->{iso_time}");
    } 
    
    #############################################################     
    
    my @CGI_varName = $cgi->var_Name;
    my $update_set = "";
    
    if ($this->{db_interface} eq "Pg") {
        $db_conn->exec("set datestyle to 'European'");
    }
    
    for ($j = 0; $j < @CGI_varName; $j++) {
        $field = $CGI_varName[$j];
        
        #$cgi->add_Debug_Text("$j : \$field : $field", __FILE__, __LINE__, "TRACING");
        
        if ($this->exceptional_Field($field)) { ### 23/03/2005
            # do nothing
            
        } else {
            if ($field =~ /\$db_/ && !($field =~ /_\d+$/)) {
                #$cgi->add_Debug_Text("is selected : ", __FILE__, __LINE__, "TRACING");
                
                $value = $cgi->param($field);
                
                $value =~ s/\\/\\\\/g;### 29/08/2005
                $value =~ s/\'/\\\'/g; 
                $value =~ s/\"/\\\"/g; ### "
                $value =~ s/\0/\\\0/g;

                $field =~ s/\$db_//;

                ### 13/04/2014
                if ($dbu->field_Exist($field)) {
                    if ($value eq "NULL" || $value eq "") {
                        $update_set .= "$field=NULL, ";

                    } else {
                        $update_set .= "$field='$value', ";
                    }                
                }
            }
        }
    }
    
    #$cgi->add_Debug_Text("\$update_set = $update_set", __FILE__, __LINE__, "TRACING");
    
    $update_set = substr($update_set, 0, length($update_set) - 2);
    
    $this->{sql} = "update $table set $update_set where $update_keys";
    $this->{db_error} = "";
    
    my $pass_auth = 1;
    
    if ($this->{auth_mode}) { ### 12/03/2006
        $sth = $db_conn->prepare("select * from $table where $update_keys");
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
    
    
    if ($pass_auth) {
        if ($this->{db_interface} eq "Pg") {
            $db_conn->exec("update $table set $update_set where $update_keys");

        } elsif ($this->{db_interface} eq "DBI")  {
            $sth = $db_conn->prepare("update $table set $update_set where $update_keys");
            if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
            
            if ($execute && $this->{db_error} eq "") {
                $sth->execute;
                if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
            }
            
            $sth->finish;
        }
    }
    
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

sub authenticate_DB_Item_Access { ### 11/03/2006
    my $this = shift @_;
    
    my $access_mode = shift @_;
    
    my $login_name = $this->{login_name};
    my $groups_array_ref = $this->{groups};
    my $db_item_auth_table = $this->{db_item_auth_table_name};
    
    my $cgi = $this->{cgi};
    my $db_conn = $this->{db_conn};
    my $table = $this->{table};

    my $user_group_auth_table_name = "webman_" . $cgi->param("app_name") . "_user_group";

    my %field_value = %{$this->{field_value_hash_ref}};
    my $key = undef;
    
    my $dbu = $this->{dbu};

    if ($this->{db_interface} eq "DBI") {
        $dbu->set_DBI_Conn($db_conn);
        
    } else {
        $dbu->set_Pg_Conn($db_conn);
    }
    
    #print "Try to check DB item access authentication for user $login_name (@{$groups_array_ref}) <br>\n";
    
    #######################################################################
    
    ### check if current table is authenticated, return 1 if not
    
    $dbu->set_Table($db_item_auth_table);
    
    if (!$dbu->find_Item("table_name", "$table")) {
        return 1;
    }
    
    #######################################################################
    
    my @array_hash_ref = undef;
    my $item = undef;
        
    my @user_auth_keys = undef;
    my @group_auth_keys = undef;
    
    my $auth_key = undef;
        
    ### check if current user match for current table
    
    if ($dbu->find_Item("table_name login_name", "$table $login_name")) {
        @user_auth_keys = $dbu->get_Items("key_field_name key_field_value mode_insert mode_update mode_delete", "table_name login_name", "$table $login_name");
        
        ### find a match key field name & value

        foreach $key (keys %field_value) {
            #$cgi->add_Debug_Text("$key = $field_value{$key}", __FILE__, __LINE__, "TRACING");
            
            foreach $auth_key (@user_auth_keys) {
                #$cgi->add_Debug_Text("$key = $auth_key->{key_field_name}", __FILE__, __LINE__, "TRACING");
                
                if ($auth_key->{key_field_name} eq $key) {
                    if ($auth_key->{key_field_value} eq $field_value{$key}) {
                        
                        if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                            #print "current user ($login_name) can modified current table ($table) item through login name<br>\n";
                            
                            return 1;   
                        } 
                    }
                    
                    if ($auth_key->{key_field_value} eq "*") {
                        
                        if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                            #print "current user ($login_name) can modified current table ($table) item through login name<br>\n";
                            
                            return 1;
                        } 
                    }
                }
            }
        }
    }
    
    ### check if current user groups match for current table ##############
        
    $dbu->set_Table($user_group_auth_table_name);
        
    @array_hash_ref = $dbu->get_Items("group_name", "login_name", "$login_name");
    
    $dbu->set_Table($db_item_auth_table);
    
    foreach $item (@array_hash_ref) {
        #print "$item->{group_name} <br>\n";
        
        if ($dbu->find_Item("table_name group_name", "$table $item->{group_name}")) {
            @group_auth_keys = $dbu->get_Items("key_field_name key_field_value mode_insert mode_update mode_delete", "table_name group_name", "$table $item->{group_name}");
            foreach $key (keys %field_value) {
                foreach $auth_key (@group_auth_keys) {
                    if ($auth_key->{key_field_name} eq $key) {
                        #print $auth_key->{key_field_value} . "<br>\n";
                        
                        if ($auth_key->{key_field_value} eq $field_value{$key}) {                       
                            if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                                #print "current user ($login_name) can modified current table ($table) item through group ($item->{group_name}) <br>\n";
                                
                                return 1;
                            } 
                        }
                        
                        if ($auth_key->{key_field_value} eq "*") {                     
                            if ($this->valid_DB_Item_Access_Mode($access_mode, $auth_key->{mode_insert}, $auth_key->{mode_update}, $auth_key->{mode_delete})) {
                                #print "current user ($login_name) can modified current table ($table) item through group ($item->{group_name}) <br>\n";
                                
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
        
        $dbu->set_Table("webman_" . $app_name . "_cgi_var_cache");
        $dbu->set_Keys_Str("session_id='$session_id' and link_id='$link_id' and name like '\$db_%'");
        $dbu->delete_Item(undef, undef);
        $dbu->set_Keys_Str(undef);
    }    
    
    my $error_message  = "<center>";
       $error_message .= "<h3>Webman Framework Access Control</h3>\n";
       $error_message .= "<b>Error:</b> Don't have privilege to access selected database table [<b>$table</b>] item.<p>\n";
       $error_message .= "$this->{error_back_link}\n";
       $error_message .= "</center>\n";    
    
    $this->{db_item_access_error_message} = $error_message;
    
    return 0;
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