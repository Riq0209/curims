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

package Web_Service_Auth;

use JSON;
use LWP::Simple;
use DB_Utilities;

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{local_session} = undef;
    $this->{ws_session} = undef;
    
    bless $this, $class;
    
    return $this;
}

sub set_CGI {
    my $this = shift @_;
    
    $this->{cgi} = shift @_;
}

sub set_Local_Session {
    my $this = shift @_;
    
    $this->{local_session} = shift @_;
}

sub set_Web_Service_URL { ### 22/01/2011
    my $this = shift @_;
    
    $this->{ws_url} = shift @_;
}

sub get_Session_ID {
    my $this = shift @_;
    
    my $login = shift @_;
    my $password = shift @_;
    
    my $local_session = $this->{local_session};
    
    if ($local_session ne "") {
        my $auth_info = $local_session->get_Auth_Info;

        $login = $auth_info->{login};
        $password = $auth_info->{password};
    }
    
    my $url = $this->{ws_url} . "?entity=authentication&login=$login&password=$password";
    my $json_text = get($url);
    
    #$this->{cgi}->add_Debug_Text("\$url = $url", __FILE__, __LINE__);
    #$this->{cgi}->add_Debug_Text($json_text, __FILE__, __LINE__);
    
    if ($json_text ne "") {
        my $json = new JSON;
        
        my $arhr = $json->decode($json_text);
        
        my $ws_session = $arhr->[0]->{list}->[0];
        
        #$this->{cgi}->add_Debug_Text($ws_session->{session_id}, __FILE__, __LINE__);
        
        ### 12/10/2013
        ### A special treatment if authentication is made via framework's 
        ### "Central User Directory Access Service". Check if user is assigned 
        ### with current active app.
        if ($this->{ws_url} =~ /wmcudas\/index_json\.cgi$/) {
            my $app_match = 0;
            
            my $current_active_app = $this->{cgi}->server_Name . $this->{cgi}->server_Path;
               $current_active_app =~ s/\/$//;            
            
            foreach my $app (@{$ws_session->{apps}}) {
                my $app_path = $app->{path};
                   $app_path =~ s/^\///;
                   $app_path =~ s/\/$//;
                   
                my $user_app = $app->{dns} . "/" . $app_path . "/" . $app->{app_name};
                   
                
                ### Handle the '*' characters set by users to generalize some 
                ### parts of the URL pattern. 
                if ($user_app =~ /\*/) {
                
                    my $str1 = $current_active_app;
                    my $str2 = $user_app;
                    
                    my @parts = split(/\*/, $str2);

                    my $result = 0;
                    my $total = @parts;

                    foreach (my $i = 0; $i < $total; $i++) {
                        #$this->{cgi}->add_Debug_Text("$parts[$i]", __FILE__, __LINE__);
                        
                        if ($i == 0) {
                            $result += ($str1 =~ /^$parts[$i]/);

                        } elsif ($i == $#parts) {
                            $result += ($str1 =~ /$parts[$i]$/);

                        } else {
                            $result += ($str1 =~ /$parts[$i]/);
                        }
                    }
                    
                    if ($result == $total) {
                        $app_match = 1;
                        last;
                    }
                   
                    #$this->{cgi}->add_Debug_Text("$result == $total", __FILE__, __LINE__);
                    #$this->{cgi}->add_Debug_Text("$str1 === $str2  - $app_match", __FILE__, __LINE__);
                    
                } else {
                    if ($user_app eq $current_active_app) {
                        $app_match = 1;
                        last;
                    }
                    
                    #$this->{cgi}->add_Debug_Text("$user_app === $current_active_app  - $app_match", __FILE__, __LINE__);
                }
            }
            
            if (!$app_match) {
                return -1;
            }
        }
        
        if ($local_session ne "") {
            my $session_id = undef;

            if ($ws_session->{session_id} ne "") {
                $this->{ws_session} = $ws_session;

                if (!$local_session->check_ID($ws_session->{session_id})) {
                    $session_id = $ws_session->{session_id};

                } else {
                    $session_id = $local_session->get_Candidate_ID;
                }

            }

            if ($session_id ne "") {
                $local_session->set_Session_ID($session_id);
                $local_session->register_Session("WEB_SERVICE");

                return $session_id;
            }
            
        } else {
            if ($ws_session->{session_id} ne "") {
                $this->{ws_session} = $ws_session;
                return $ws_session->{session_id};
            }
        }
    }
    
    return -1;
}

sub register_Web_Service_User {
    my $this = shift @_;
    
    my $cgi = $this->{cgi};
    
    if ($this->{local_session} ne undef && $this->{ws_session} ne undef) {
        my $user_auth_table = $this->{local_session}->get_User_Auth_Table;
        my $auth_info = $this->{local_session}->get_Auth_Info;
        my $ws_session = $this->{ws_session};

        if (!$this->{local_session}->check_User($auth_info->{login})) {
            my $id_user = $ws_session->{id_user}; 
            
            ### it should have the same value with $auth_info->{login}
            my $login_name = $ws_session->{login_name}; 
            
            my $full_name = $ws_session->{full_name};
            my $description = $ws_session->{description};
            
            $full_name =~ s/ /\\ /g;
            $description =~ s/ /\\ /g;
            
            #$cgi->add_Debug_Text("Register $ws_session->{full_name} as web service user", __FILE__, __LINE__);
            
            my $dbu = $this->{local_session}->get_DBU;
            
            ### Register user.
            $dbu->set_Table($user_auth_table);
            
            if (!$dbu->find_Item("login_name", "$login_name")) {
                $dbu->insert_Row("id_user login_name full_name description web_service_url", 
                                 "$id_user $login_name $full_name $description $this->{ws_url}");
            }
                             
            #$this->{cgi}->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);                             
            
            ### Register group and user-group.
            my $group_list_table = $user_auth_table;
               $group_list_table =~ s/_user$/_group/;
               
            my $user_group_table = $user_auth_table . "_group";
               
            foreach my $item (@{$this->{ws_session}->{groups}}) {
                my $id_group_36base = $item->{id_group_36base};
                my $group_name = $item->{group_name};
                my $description = $item->{description};
                
                #$this->{cgi}->add_Debug_Text("$group_list_table - $id_group_36base : $group_name : $description", __FILE__, __LINE__);
                
                $description =~ s/ /\\ /g;
                
                ### Register group.
                $dbu->set_Table($group_list_table);
                
                if (!$dbu->find_Item("group_name", "$group_name")) {
                    $dbu->insert_Row("id_group group_name description", "$id_group_36base $group_name $description");
                }
                
                ### Register user-group.
                $dbu->set_Table($user_group_table);

                if (!$dbu->find_Item("login_name group_name", "$login_name $group_name")) {
                    $dbu->insert_Row("login_name group_name", "$login_name $group_name");
                }                
            }
        }
    }
}

1;