package webman_JSON_authentication;

use webman_JSON;

@ISA=("webman_JSON");

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
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

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    #$this->set_Error("???");
    
    $this->{json} = new JSON;
    
    $this->{json}->indent([1]);
    $this->{json}->allow_blessed([1]);
    $this->{json}->convert_blessed([1]);
    
    my $app_name = $cgi->param("app_name");
    my $login = $cgi->param("login");
    my $password = $cgi->param("password");
    
    my $session_id = $cgi->param("session_id");
    my $session_id_user = $cgi->param("session_id_user");
    
    ### not the first phase login & current user want to get other user info.
    if ($session_id_user ne "") { 
        $login = $this->get_User_Login($session_id_user);
        @groups = $this->get_User_Groups($login);
    }
    
    ### not the first phase login & current user want to get self info.
    if ($login eq "") { 
        $login = $login_name;
    }
    
    ###########################################################################
    
    my $table_auth = "webman_" . $app_name . "_user";
    my $table_session = "webman_" . $app_name . "_session";
    my $table_group = "webman_" . $app_name . "_user_group";
    
    my $session = new Session;

    $session->set_CGI($cgi);
    $session->set_DBI_Conn($db_conn);

    $session->set_Session_Table($table_session);
    $session->set_User_Auth_Table($table_auth, "login_name", "password");
    $session->set_CGI_Var_DB_Cache_Table("webman_" . $app_name . "_cgi_var_cache");
    $session->set_Idle_Time(3600);
    
    if ($session_id eq "") {
        $session->set_Auth_Info($login, $password);
        
        ### the create_Session function below will also check if current user
        ### requires JSON service authentication from different webman
        ### applications/servers
        $session->create_Session;

        $session_id = $session->get_Session_ID;
        
        $session->refresh_Session; # mark any possible zombie session
    }
    
    #$cgi->add_Debug_Text("session_id = $session_id", __FILE__, __LINE__);    
    
    if ($session_id != -1) {
        $session->set_Session_ID($session_id);       
        
        if ($session->is_Valid) {
            if ($login_name eq "") { ### the first phase login, session_id is not already exist as CGI variable
                $cgi->push_Param("session_id", $session_id);
                @groups = $this->get_User_Groups($login);
            }
            
            $dbu->set_Table($table_auth);
            my @ahr = $dbu->get_Items("id_user login_name full_name description web_service_url", "login_name", "$login", undef, undef);
            
            #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
            
            $ahr[0]->{session_id} = $session_id;
            
            $ahr[0]->{groups} = \@groups;
            
            ### 12/10/2013
            ### A special treatment if authentication is made via framework's 
            ### "Central User Directory Access Service". Get groups and apps. 
            ### have been assigned to the current user.
            if ($app_name eq "wmcudas") {
                my @apps = ();
                my @id_apps = ();
                
                ### Apps. assigned via groups.
                my @id_groups = ();
                
                foreach my $group (@groups) {
                    if (defined($group)) {
                        $dbu->set_Table("wmcudas_group");
                        push(@id_groups, $dbu->get_Item("id_group_36base", "group_name", "$group"));
                    }
                }
                
                foreach my $id_group_36base (@id_groups) {
                    $dbu->set_Table("wmcudas_groupapps");
                    my @ahr2 = $dbu->get_Items("id_apps_36base", "id_group_36base", "$id_group_36base");
                    
                    foreach my $item (@ahr2) {
                        push(@id_apps, $item->{id_apps_36base});
                    }
                }
                
                ### Apps. assigned via user's "login_name".
                $dbu->set_Table("wmcudas_user");
                my $id_user_36base = $dbu->get_Item("id_user_36base", "login_name", "$login");
                
                $dbu->set_Table("wmcudas_userapps");
                my @ahr3 = $dbu->get_Items("id_apps_36base", "id_user_36base", "$id_user_36base");

                foreach my $item (@ahr3) {
                    push(@id_apps, $item->{id_apps_36base});
                }                
                
                ### Get the apps info.
                foreach my $id_apps_36base (@id_apps) {
                    $dbu->set_Table("wmcudas_apps");
                    my @ahr4 = $dbu->get_Items("dns path app_name description", "id_apps_36base", "$id_apps_36base");
                    
                    push(@apps, $ahr4[0]);
                }
                
                $ahr[0]->{apps} = \@apps;
                
                ### Provide more details on group info.
                my @groups_detail = ();
                
                foreach my $group (@groups) {
                    if (defined($group)) {
                        $dbu->set_Table("wmcudas_group");
                        my @ahr5 = $dbu->get_Items("id_group_36base group_name description", "group_name", "$group");
                    
                        push(@groups_detail, $ahr5[0]);
                    
                        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
                    }
                }
                
                $ahr[0]->{groups} = \@groups_detail;
                
                ### 15/01/2024
                $dbu->set_Table("wmcudas_user");
                $ahr[0]->{email} = $dbu->get_Item("email", "login_name", "$login");
            }
            
            my $json_data_ref = [{error => $dbu->{db_error}, list => [$ahr[0]]}];
            
            $this->{content_json} = $this->encode_JSON_Text($json_data_ref);
            
            $this->{session_id} = $session_id;
            
        } else {
            my $json_data_ref = [{error => "Invalid session ID", list => undef}];
            
            $this->{content_json} = $this->encode_JSON_Text($json_data_ref);            
        }
    }
}

1;