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
	my $type = shift;
	
	my $this = {};
	
	$this->{session_table} = undef;
	
	$this->{db_conn} = undef;
	$this->{db_interface} = undef;
	$this->{user_auth_table} = undef;
	$this->{login_field} = undef;
	$this->{password_field} = undef;
	
	$this->{login} = undef;
	$this->{password} = undef;
	
	$this->{idle_Time} = undef;
	
	$this->{date} = undef;
	$this->{time} = undef;
	$this->{session_id} = undef;
	
	$this->{session_table} = "session";
	
	$this->{zto_temp_table} = undef; ### 09/02/2006 - ref. to array
	
	$this->{error} = undef;
	
	bless $this, $type;
	
	return $this;
}

sub set_Conn {
	$this = shift @_;
	$this->{db_conn} = shift @_;
}

sub set_Pg_Conn { ### 27/02/2004
	$this = shift @_;
	$this->{db_conn} = shift @_;
	$this->{db_interface} = "Pg"; 
}

sub set_DBI_Conn { ### 27/02/2004
	$this = shift @_;
	$this->{db_conn} = shift @_;
	$this->{db_interface} = "DBI"; 
}

sub set_Session_Table {
	$this = shift @_;
	
	$this->{session_table} = shift @_;
}

sub set_User_Auth_Table {
	$this = shift @_;
	
	$this->{user_auth_table} = shift @_;
	$this->{login_field} = shift @_;
	$this->{password_field} = shift @_;
}

sub set_User {
	$this = shift @_;
	
	$this->{login} = shift @_;
	$this->{password} = shift @_;
}

sub set_Idle_Time {
	$this = shift @_;
	
	$this->{idle_Time} = shift @_;
}

sub set_Session_ID {
	$this = shift @_;
	
	$this->{session_id} = shift @_;
}

sub get_Session_ID {
	$this = shift @_;
	
	return $this->{session_id};
}

sub get_ZTO_Session_ID { ### 09/02/2006
	$this = shift @_;
	
	my $db_conn = $this->{db_conn};
	
	my $zto_session_id = undef;
	my $epoch_time = time;
	my $idle_epoch_time = $epoch_time - $this->{idle_Time};
	
	my $dbu = new DB_Utilities;
			
	$dbu->set_DBI_Conn($db_conn);
	
	$dbu->set_Keys_Str(" \(status='zombie' or status='time out'\) and temp_table='1'");
	$dbu->set_Table($this->{session_table});
	
	my @array_hash_ref = $dbu->get_Items("session_id");
	
	return @array_hash_ref;
}

sub set_ZTO_Temp_Table_Postname_Checked { ### 09/02/2006
	$this = shift @_;
	
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
	$this = shift @_;
	
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
	$this = shift @_;
	
	my $db_conn = $this->{db_conn};
	my $session_table = $this->{session_table};
	
	my $epoch_time = time;
	my $idle_epoch_time = $epoch_time - $this->{idle_Time};
	
	if ($this->{db_interface} eq "Pg") {
		$db_conn->exec("update $session_table set status='zombie' where status='login'
		                and epoch_time < '$idle_epoch_time'");
		                
	} elsif ($this->{db_interface} eq "DBI") {
		$sth = $this->{db_conn}->prepare("update $session_table set status='zombie' where status='login'
						  and epoch_time < '$idle_epoch_time'");
		$sth->execute;
		$sth->finish;
	}
}

sub create_Session {
	$this = shift @_;
	
	$db_conn = $this->{db_conn};
	
	$session_table = $this->{session_table};
	
	$user_auth_table = $this->{user_auth_table};
	$login_field = $this->{login_field};
	$password_field = $this->{password_field};
	
	$login = $this->{login};
	$password = $this->{password};
	
	my $cgi = new GMM_CGI;
	
	my $client_IP = $cgi->client_IP;
	
	my @data = undef;
	
	if ($this->{db_interface} eq "Pg") {
		#print "select * from $user_auth_table where $login_field = '$login' and $password_field = '$password' <br>";
		
		$result = $db_conn->exec("select * from $user_auth_table where 
	                                  $login_field = '$login' and $password_field = '$password'");
	                                  
	        @data = $result->fetchrow;
	                                  
	} elsif ($this->{db_interface} eq "DBI") {
		$sth = $db_conn->prepare("select * from $user_auth_table where 
	                                          $login_field = '$login' and $password_field = '$password'");
	                                  
	        $sth->execute;
		@data = $sth->fetchrow_array;
	        $sth->finish;
	}
	
	
	if ($#data > -1) {
	        $exist = 1;
		
		while ($exist) {
			$id = "";
	
			($sec,$min,$hour,$mday,$mon,$year) = (localtime(time))[0,1,2,3,4,5];
	
			$mon++;
			$year += 1900;
			
			$this->{date} = "$year-$mon-$mday";
			$this->{time} = "$hour:$min:$sec";
			
			#print "seconds since 1 jan 1970 = ", $epoch_time, "<br>\n";
			#print "\$idle_epoch_time = ", $idle_epoch_time, "<br>\n";
	
			$id = rand(8);
			$id++;
			$id =~ s/\.//;
			
			if ($this->{db_interface} eq "Pg") {
				$result = $db_conn->exec("select * from $session_table where
			                       		  session_id = '$id'");
			        @data = $result->fetchrow;
			                       		  
			} elsif ($this->{db_interface} eq "DBI") {
				$sth = $this->{db_conn}->prepare("select * from $session_table where
			                       		          session_id = '$id'");
			                       		          
			        $sth->execute;
				@data = $sth->fetchrow_array;
	        		$sth->finish;
			}
			                       
			if ($#data > -1) {
				$exist = 1;
			} else {
				$exist = 0;
			}
		}
	
		$this->{session_id} = $id;
		
		my $epoch_time = time;
		
		if ($this->{db_interface} eq "Pg") {
			$db_conn->exec("insert into $session_table (session_id, login_name, login_date, login_time, last_active_date, last_active_time, epoch_time, idle_time, status, temp_table, client_ip) 
			                values ('$id', '$login', '$this->{date}', '$this->{time}', '$this->{date}',
		                	        '$this->{time}', '$epoch_time', '$this->{idle_Time}', 'login', '1', '$client_IP')");
		                	
		} elsif ($this->{db_interface} eq "DBI") {
			$sth = $this->{db_conn}->prepare("insert into $session_table (session_id, login_name, login_date, login_time, last_active_date, last_active_time, epoch_time, idle_time, status, temp_table, client_ip) 
			                                  values ('$id', '$login', '$this->{date}', '$this->{time}', '$this->{date}',
		                			          '$this->{time}', '$epoch_time', '$this->{idle_Time}', 'login', '1', '$client_IP')");
		        $sth->execute;
		        $sth->finish;		
		}
		
	} else {
		$this->{session_id} = -1;
	}
}

sub is_Valid {
	my $this = shift @_;
	
	my $db_conn = $this->{db_conn};
	my $session_table = $this->{session_table};
	my $session_id = $this->{session_id};
	my $login_name = $this->{login};
	
	if ($session_id == -1) {
		$this->{error} = "Incorrect login/password.";
		return 0;
	}
	
	$valid = 0;
	
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
	
	if ($this->{db_interface} eq "Pg") {
		$result = $db_conn->exec($sql);
		@data = $result->fetchrow;
		
	} elsif ($this->{db_interface} eq "DBI") {
		$sth = $this->{db_conn}->prepare($sql);
		
		$sth->execute;
		@data = $sth->fetchrow_array;
	        $sth->finish;
	}
	
	#print "select * from $session_table where session_id='$session_id'\n";
	
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
			if ($this->{db_interface} eq "Pg") {
				$db_conn->exec("update $session_table set last_active_date = '$this->{date}', 
			             		last_active_time = '$this->{time}', epoch_time = '$epoch_time' 
			             		where session_id='$session_id'");
			             		
			} elsif ($this->{db_interface} eq "DBI") {
				$sth = $this->{db_conn}->prepare("update $session_table set last_active_date = '$this->{date}', 
			             				  last_active_time = '$this->{time}', epoch_time = '$epoch_time' 
			             				  where session_id='$session_id'");  
			        $sth->execute;
		        	$sth->finish;
			}
			
			$valid = 1;
			
		} elsif ($data[8] eq "login" && $second_intervals > $data[7]) {
			#print "Set time out for session_id=$session_id <br>"; 
			
			if ($this->{db_interface} eq "Pg") {
				$db_conn->exec("update $session_table set status = 'time out'
			                	where session_id='$session_id'");
			                	
			} elsif ($this->{db_interface} eq "DBI") {
				$sth = $this->{db_conn}->prepare("update $session_table set status = 'time out'
			                			  where session_id='$session_id'");
			        $sth->execute;
		        	$sth->finish;
			}
			             
			$this->{error} = "Session Time Out";
			
		} else {
			$this->{error} = "Invalid Session";
		}
		
	} else {
		$this->{error} = "Invalid Session";
	}
	
	if ($valid) { ### 20/12/2006 - count hits
		my $dbu = new DB_Utilities;
		
		$dbu->set_DBI_Conn($db_conn);
		$dbu->set_Table($session_table);
		
		my $current_hits = $dbu->get_Item("hits", "session_id", $session_id);
		
		$current_hits++;
		
		$dbu->update_Item("hits", $current_hits, "session_id", $session_id);
	}
	
	return $valid;
}

sub logout {
	$this = shift @_;
	
	my $session_id = shift @_;
	
	if ($session_id eq "") {
		$session_id = $this->{session_id};
	} else {
		$this->{session_id} = $session_id;
	}
	
	#print "logout: session id = $session_id";
	
	my $db_conn = $this->{db_conn};
	my $session_table = $this->{session_table};
	
	my $sql = "update $session_table set status='logout', temp_table='0' where session_id='$session_id'";
	
	#print "<pre>$sql</pre>";
	
	if ($this->{db_interface} eq "Pg") {
		$db_conn->exec($sql);
		        	
	} elsif ($this->{db_interface} eq "DBI") {
		$sth = $db_conn->prepare($sql);
		$sth->execute;
		$sth->finish;
	}
}

sub remove_Logout_Temp_Table { ### 09/02/2006
	$this = shift @_;
	
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
	$this = shift @_;
	
	return $this->{error};
}

1;