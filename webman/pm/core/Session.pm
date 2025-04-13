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

package Session;

use DB_Utilities;

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{cgi} = undef;
    $this->{db_conn} = undef;
    
    $this->{app_name} = undef;
    
    $this->{session_table} = undef;
    $this->{user_auth_table} = undef;
    $this->{cgi_var_db_cache_table} = undef;
    $this->{login_field} = undef;
    $this->{password_field} = undef;
    
    $this->{login} = undef;
    $this->{password} = undef;
    
    $this->{idle_Time} = undef;
    
    $this->{date} = undef;
    $this->{time} = undef;
    $this->{session_id} = undef;
    
    $this->{zto_temp_table} = undef; ### 09/02/2006 - ref. to array
    
    $this->{error} = undef;
    
    bless $this, $class;
    
    return $this;
}

sub set_CGI {
    my $this = shift @_;
    
    $this->{cgi} = shift @_;
    
    ### 28/04/2012
    $this->{app_name} = $this->{cgi}->param("app_name");
    
    $this->{session_table} = "webman_" . $this->{app_name} . "_session";
    $this->{user_auth_table} = "webman_" . $this->{app_name} . "_user";
    $this->{cgi_var_db_cache_table} = "webman_" . $this->{app_name} . "_cgi_var_cache";
    
    $this->{login_field} = "login_name";
    $this->{password_field} = "password";
}

sub set_DBI_Conn { ### 27/02/2004
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
    
    if ($this->{dbu} eq undef) {
        my $dbu = new DB_Utilities;
                    
        $dbu->set_DBI_Conn($this->{db_conn}); 
        
        $this->{dbu} = $dbu;
    }
}

sub set_Session_Table {
    my $this = shift @_;
    
    $this->{session_table} = shift @_;
}

sub set_User_Auth_Table {
    my $this = shift @_;
    
    $this->{user_auth_table} = shift @_;
    $this->{login_field} = shift @_;
    $this->{password_field} = shift @_;
}

sub set_CGI_Var_DB_Cache_Table {
    my $this = shift @_;
    
    $this->{cgi_var_db_cache_table} = shift @_;
}

sub set_Auth_Info {
    my $this = shift @_;
    
    $this->{login} = shift @_;
    $this->{password} = shift @_;
}

sub set_Idle_Time {
    my $this = shift @_;
    
    $this->{idle_Time} = shift @_;
}

sub set_Session_ID {
    my $this = shift @_;
    
    $this->{session_id} = shift @_;
}

sub get_CGI {
    my $this = shift @_;
    
    return $this->{cgi};
}

sub get_DBU {
    my $this = shift @_;
    
    return $this->{dbu};
}

sub get_Candidate_ID { ### 22/01/2011
    my $this = shift @_;
    
    return $this->{candidate_id};
} 

sub get_Session_ID {
    my $this = shift @_;
    
    return $this->{session_id};
}

sub get_Auth_Info { ### 22/01/2011
    my $this = shift @_;
    
    return {login => $this->{login}, password => $this->{password}};
}

sub get_User_Auth_Table { ### 22/01/2011
    my $this = shift @_;
    
    return $this->{user_auth_table};
}

sub get_Login_Name { ### 26/02/2013
    my $this = shift @_;
    
    my $session_id = shift @_;
    
    if (!defined($session_id)) {
        $session_id = $this->{session_id};
    }
    
    my $dbu = $this->get_DBU;

    $dbu->set_Table($this->{session_table});
    
    return $dbu->get_Item("login_name", "session_id", $session_id);
}

sub get_User_Info { ### 22/01/2011
    my $this = shift @_;
    
    my $login_name = shift @_;
    
    my $dbu = $this->get_DBU;

    $dbu->set_Table($this->{user_auth_table});
    
    my @ahr = $dbu->get_Items("login_name full_name description web_service_url", "login_name", "$login_name", undef, undef);
    
    if ($ahr[0] ne "") {
        return $ahr[0];
    }
    
    return 0;
}

sub get_ZTO_Session_ID { ### 09/02/2006
    my $this = shift @_;
   
    my $zto_session_id = undef;
    my $epoch_time = time;
    my $idle_epoch_time = $epoch_time - $this->{idle_Time};
    
    my $dbu = new DB_Utilities;
            
    $dbu->set_DBI_Conn($this->{db_conn});
    
    $dbu->set_Keys_Str(" \(status='zombie' or status='time out'\) and temp_table='1'");
    $dbu->set_Table($this->{session_table});
    
    my @array_hash_ref = $dbu->get_Items("session_id");
    
    return @array_hash_ref;
}

sub set_ZTO_Temp_Table_Postname_Checked { ### 09/02/2006
    my $this = shift @_;
    
    my $temp_table_postname = shift @_;
    
    my @zto_session_id = @_; ### array hash ref.
    
    my @array_postname = split(/ /, $temp_table_postname);
    
    my $item_zto = undef;
    my $item_postname = undef;
    my $temp_table_name = undef;
    
    my $counter = 0;
    my @array_temp_table_name = undef;
    
    foreach $item_zto (@zto_session_id) {
    
        foreach $item_postname (@array_postname) {
            if ($item_zto->{session_id} ne "") {
        
                $temp_table_name = "temp_" . $item_zto->{session_id} . "_$item_postname";
                #print "\$temp_table_name = $temp_table_name <br>";
                $array_temp_table_name[$counter] = $temp_table_name;
            
                $counter++;
            }
        }
    }
    
    if ($counter > 0) {
        $this->{zto_temp_table} = \@array_temp_table_name;
    } else {
        $this->{zto_temp_table} = undef;
    }
}

sub remove_ZTO_Temp_Table { ### 09/02/2006
    my $this = shift @_;
    
    my $temp_table_name = undef;
    my @array_temp_table_name = @{$this->{zto_temp_table}};
    
    my $dbu = new DB_Utilities;
                    
    $dbu->set_DBI_Conn($this->{db_conn});
            
    foreach $temp_table_name (@array_temp_table_name) {
        $dbu->set_Table($temp_table_name);
        #print "drop table $temp_table_name <br>";
        $dbu->drop_Table;
    }
    
    ################################################
    
    my @zto_session_id = $this->get_ZTO_Session_ID;
    my $item_zto = undef;
    
    $dbu->set_Table($this->{session_table});
    
    foreach $item_zto (@zto_session_id) {
        if ($item_zto->{session_id} ne "") {
            $dbu->update_Item("temp_table", "0", "session_id", $item_zto->{session_id});
            #print "zto_session_id = " . $item_zto->{session_id} . " <br>";
        }
    }
    
}

sub refresh_Session { ### 09/02/2006
    my $this = shift @_;

    my $session_table = $this->{session_table};
    my $cgi_var_db_cache_table = $this->{cgi_var_db_cache_table};
    
    my $epoch_time = time;
    my $idle_epoch_time = $epoch_time - $this->{idle_Time};    
    
    ### 06/01/2009 #############################################################
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($this->{db_conn});
    $dbu->set_Table("$session_table");
    $dbu->set_Keys_Str("status='login' and epoch_time < '$idle_epoch_time'");

    my @ahr = $dbu->get_Items("session_id", undef, undef, undef, undef);

    $dbu->set_Keys_Str(undef);

    foreach my $item (@ahr) {
        $dbu->set_Table($cgi_var_db_cache_table);
        $dbu->delete_Item("session_id", $item->{session_id});
    }

    ############################################################################

    $sth = $this->{db_conn}->prepare("update $session_table set status='zombie' where status='login'
                                      and epoch_time < '$idle_epoch_time'");
    $sth->execute;
    $sth->finish;
}

sub create_Session {
    my $this = shift @_;
    
    my $cgi = $this->{cgi};
    
    my $session_table = $this->{session_table};
    
    my $user_auth_table = $this->{user_auth_table};
    my $login_field = $this->{login_field};
    my $password_field = $this->{password_field};
    
    my $login = $this->{login};
    my $password = $this->{password};
    
    if ($cgi eq undef) {
        $cgi = new GMM_CGI;
    }
    
    #$cgi->add_Debug_Text("Logn: $login", __FILE__, __LINE__, "TRACING");
    
    ### generate new id for session ###########################################
    
    my $candidate_id = "";
    my $exist = 1;
    
    while ($exist) {
        $candidate_id = rand(8);
        $candidate_id++;
        $candidate_id =~ s/\.//;
        
        if (!$this->check_ID($candidate_id)) {
            $exist = 0;
        } 
    }
    
    $this->{candidate_id} = $candidate_id;
    
    ###########################################################################    
    
    if ($this->check_User($login)) {
        
        my $user_info = $this->get_User_Info($login);
        
        if ($user_info->{web_service_url} ne "") {
            #$cgi->add_Debug_Text("User exist locally but authenticated from other webman application via web service", __FILE__, __LINE__);
            
            my $wsauth = new Web_Service_Auth;

            ### 13/10/2013
            $wsauth->set_CGI($this->{cgi});
            
            $wsauth->set_Local_Session($this);
            $wsauth->set_Web_Service_URL($user_info->{web_service_url});

            $ws_session_id = $wsauth->get_Session_ID;
            
            $this->{session_id} = $ws_session_id;
            
            if ($ws_session_id != -1) {
                $this->register_Session;            
            }
            
        } else {
     
            #$cgi->add_Debug_Text("select * from $user_auth_table where $login_field = '$login' and $password_field = '$password'", __FILE__, __LINE__);

            $sth = $this->{db_conn}->prepare("select * from $user_auth_table where 
                                              $login_field = '$login' and $password_field = '$password'");

            $sth->execute;

            my $ref = $sth->fetchrow_hashref; ### 17/01/2019

            $sth->finish;
            
            ### Programatically do a case sensitive comparison
            if ($ref->{$login_field} eq $login && $ref->{$password_field} eq $password) { ### 17/01/2019 
                $this->{session_id} = $candidate_id;
                $this->register_Session;

            } else {
                $this->{session_id} = -1;
            }
        }
        
    } else {
        $this->{session_id} = -1;
    }
    
    return $this->{session_id};
}

sub check_User { ### 22/01/2011
    my $this = shift @_;
    
    my $login_name = shift @_;
    
    $sth = $this->{db_conn}->prepare("select login_name from $this->{user_auth_table} where login_name = '$login_name'");

    $sth->execute;
    
    my @data = $sth->fetchrow_array;
    
    $sth->finish;

    if ($#data > -1) {
        return 1;
        
    } else {
        return 0;
    }    
    
}

sub check_ID { ### 22/01/2011
    my $this = shift @_;
    my $session_id = shift @_;
    
    my $session_table = $this->{session_table};
    
    $sth = $this->{db_conn}->prepare("select session_id from $session_table where session_id = '$session_id'");

    $sth->execute;
    
    my @data = $sth->fetchrow_array;
    
    $sth->finish;

    if ($#data > -1) {
        return 1;
        
    } else {
        return 0;
    }    
}

sub register_Session { ### 22/01/2011
    my $this = shift @_;
    
    my $auth_status = shift @_;
    
    my $cgi = $this->{cgi};
    
    if ($auth_status eq "") {
        $auth_status = "LOCAL";
    }
    
    if ($cgi eq undef) {
        $cgi = new GMM_CGI;
    }
    
    my $client_IP = $cgi->client_IP;
    
    my $session_table = $this->{session_table};
    
    my $epoch_time = time;
    
    my ($sec,$min,$hour,$mday,$mon,$year) = (localtime(time))[0,1,2,3,4,5];

    $mon++;
    $year += 1900;

    $this->{date} = "$year-$mon-$mday";
    $this->{time} = "$hour:$min:$sec";

    #print "seconds since 1 jan 1970 = ", $epoch_time, "<br>\n";
    #print "\$idle_epoch_time = ", $idle_epoch_time, "<br>\n";    

    $sth = $this->{db_conn}->prepare("insert into $session_table (session_id, login_name, login_date, login_time, last_active_date, last_active_time, epoch_time, idle_time, status, temp_table, client_ip, auth_status) 
                                      values ('$this->{session_id}', '$this->{login}', '$this->{date}', '$this->{time}', '$this->{date}',
                                      '$this->{time}', '$epoch_time', '$this->{idle_Time}', 'login', '1', '$client_IP', '$auth_status')");
    $sth->execute;
    $sth->finish;        
}

sub is_Valid {
    my $this = shift @_;
    
    my $session_table = $this->{session_table};
    my $session_id = $this->{session_id};
    my $login_name = $this->{login};
    
    if ($session_id == -1) {
        $this->{error} = "Incorrect Login/Password";
        return 0;
    }
    
    my $valid = 0;
    
    ($sec,$min,$hour,$mday,$mon,$year) = (localtime(time))[0,1,2,3,4,5];

    $mon++;
    $year += 1900;

    $this->{date} = "$year-$mon-$mday";
    $this->{time} = "$hour:$min:$sec";
    
    $epoch_time = time;
    
    if ($login_name ne "") {   ### 18/02/2005
        $sql = "select * from $session_table where session_id='$session_id' and login_name='$login_name'";
    } else {
        $sql = "select * from $session_table where session_id='$session_id'";
    }
    
    $sth = $this->{db_conn}->prepare($sql);

    $sth->execute;
    
    my @data = $sth->fetchrow_array;
    
    $sth->finish;
    
    #$this->{cgi}->add_Debug_Text("select * from $session_table where session_id='$session_id'", __FILE__, __LINE__);
    
    if ($#data > -1) {
        #print"<pre>";            
            #print "session_id = $data[0]\n";
            #print "login = $data[1]\n";
            #print "login_date = $data[2]\n";
            #print "login_time = $data[3]\n";
            #print "last_active_date = $data[4]\n";
            #print "last_active_time = $data[5]\n";
            #print "epoch_time = $data[6]\n";
            #print "idle_time = $data[7]\n";
            #print "status = $data[8]\n";
            
            $second_intervals = $epoch_time - $data[6];
            
            #print "second_intervals = $second_intervals\n";
            #print "</pre>";
        
        if ($data[8] eq "login" && $second_intervals <= $data[7]) {

            $sth = $this->{db_conn}->prepare("update $session_table set last_active_date = '$this->{date}', 
                                              last_active_time = '$this->{time}', epoch_time = '$epoch_time' 
                                              where session_id='$session_id'");  
            $sth->execute;
            $sth->finish;
            
            $valid = 1;
            
        } elsif ($data[8] eq "login" && $second_intervals > $data[7]) {
            #print "Set time out for session_id=$session_id <br>"; 
            
            ### 06/01/2009 #####################################################

            my $dbu = new DB_Utilities;

            $dbu->set_DBI_Conn($this->{db_conn});
            $dbu->set_Table($this->{cgi_var_db_cache_table});

            $dbu->delete_Item("session_id", "$session_id");

            #print "SQL: " . $dbu->get_SQL . "<br>";

            ####################################################################

            $sth = $this->{db_conn}->prepare("update $session_table set status='time out'
                                              where session_id='$session_id'");
            $sth->execute;
            $sth->finish;
                         
            $this->{error} = "Session Time Out";
            
        } else {
            $this->{error} = "Invalid Session";
        }
        
    } else {
        $this->{error} = "Invalid Session";
    }
    
    $this->{valid} = $valid;
    
    return $valid;
}

sub update_Hits { ### 21/02/2013
    my $this = shift @_;
    
    my $session_table = $this->{session_table};
    my $session_id = $this->{session_id};
    
    #$this->{cgi}->add_Debug_Text("\$session_id = $session_id", __FILE__, __LINE__);
    
    if ($this->{valid}) {
        my $dbu = new DB_Utilities;

        $dbu->set_DBI_Conn($this->{db_conn});
        $dbu->set_Table($session_table);

        my $current_hits = $dbu->get_Item("hits", "session_id", $session_id);

        #$this->{cgi}->add_Debug_Text("\$current_hits = $current_hits", __FILE__, __LINE__);

        $current_hits++;

        #$this->{cgi}->add_Debug_Text("\$current_hits = $current_hits", __FILE__, __LINE__);

        $dbu->update_Item("hits", $current_hits, "session_id", $session_id);
        
        #$this->{cgi}->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
    }
}

sub logout {
    my $this = shift @_;
    
    my $session_id = shift @_;
    
    if ($session_id eq "") {
        $session_id = $this->{session_id};
        
    } else {
        $this->{session_id} = $session_id;
    }
    
    #$this->{cgi}->add_Debug_Text("logout: session id = $session_id");
    
    my $session_table = $this->{session_table};
    
    my $sql = "update $session_table set status='logout', temp_table='0' where session_id='$session_id'";
    
    #$this->{cgi}->add_Debug_Text($sql);
        
    ### 06/01/2009 #############################################################

    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($this->{db_conn});
    $dbu->set_Table($this->{cgi_var_db_cache_table});

    $dbu->delete_Item("session_id", "$session_id");        

    ############################################################################

    $sth = $this->{db_conn}->prepare($sql);
    $sth->execute;
    $sth->finish;
}

sub remove_Logout_Temp_Table { ### 09/02/2006
    my $this = shift @_;
    
    my $session_id = shift @_;
    
    my $temp_table_postname = shift @_;
    
    my $item = undef;
    my @array = split(/ /, $temp_table_postname);
    my $temp_table_name = undef;
    
    my $dbu = new DB_Utilities;
                
    $dbu->set_DBI_Conn($this->{db_conn});
    
    foreach $item (@array) {
        $temp_table_name = "temp_" . $session_id . "_$item";
        
        #print "\$temp_table_name = $temp_table_name <br>";
        
        $dbu->set_Table($temp_table_name);
        $dbu->drop_Table;
    }
}

sub get_Error {
    my $this = shift @_;
    
    return $this->{error};
}

1;
