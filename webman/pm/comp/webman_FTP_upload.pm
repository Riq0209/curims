package webman_FTP_upload;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $type = shift;
    
    my $this = webman_CGI_component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{template_default_confirm} = undef;
    
    $this->{ftp_host} = undef;
    $this->{ftp_login} = undef;
    $this->{ftp_password} = undef;
    
    $this->{transfer_mode} = undef;
    
    $this->{dir_temp} = undef;
    $this->{dir_upload} = undef;
    $this->{dir_upload_absolute} = undef;
    
    $this->{submit_button_name} = undef;
    $this->{proceed_on_submit} = undef;
    $this->{confirm_on_submit} = undef;
    $this->{cancel_on_submit} = undef;
    
    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef; ### 14/12/2010
    $this->{link_path_separator_tag} = undef; ### 14/12/2010
    $this->{link_path_unselected_color} = undef; ### 14/12/2010
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009    
    
    $this->{last_phase_cgi_data_reset} = undef;
    $this->{last_phase_url_redirect} = undef; 
    
    bless $this, $type;
    
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

sub set_FTP_Host { 
    my $this = shift @_;
    
    $this->{ftp_host} = shift @_;
}

sub set_FTP_Login { 
    my $this = shift @_;
    
    $this->{ftp_login} = shift @_;
}

sub set_FTP_Password { 
    my $this = shift @_;
    
    $this->{ftp_password} = shift @_;
}

sub set_Transfer_Mode { 
    my $this = shift @_;
    
    $this->{transfer_mode} = shift @_;
}

sub set_Dir_Temp { 
    my $this = shift @_;
    
    $this->{dir_temp} = shift @_;
}

sub set_Dir_Upload { 
    my $this = shift @_;
    
    $this->{dir_upload} = shift @_;
}

sub set_Dir_Upload_Absolute { 
    my $this = shift @_;
    
    $this->{dir_upload_absolute} = shift @_;
}

sub set_Submit_Button_Name { 
    my $this = shift @_;
    
    $this->{submit_button_name} = shift @_; 
}

sub set_Proceed_On_Submit {
    my $this = shift @_;
    
    $this->{proceed_on_submit} = shift @_;
}

sub set_Confirm_On_Submit {
    my $this = shift @_;
    
    $this->{confirm_on_submit} = shift @_;
}

sub set_Cancel_On_Submit {
    my $this = shift @_;
    
    $this->{cancel_on_submit} = shift @_;
}

sub set_Link_Path_Level_Start {
    my $this = shift @_;
    
    $this->{link_path_level_start} = undef;
}

sub set_Link_Path_Level_Deep {
    my $this = shift @_;
    
    $this->{link_path_level_deep} = undef;
}

sub set_Link_Path_Separator_Tag {
    my $this = shift @_;
    
    $this->{link_path_separator_tag} = undef;
}


sub set_Link_Path_Unselected_Color {
    my $this = shift @_;

    $this->{link_path_unselected_color} = undef;
}

sub set_Link_Path_Additional_Get_Data { ### 11/02/2006
    my $this = shift @_;
    
    $this->{link_path_additional_get_data} = shift @_;
}

sub set_Last_Phase_CGI_Data_Reset { 
    my $this = shift @_;
    
    $this->{last_phase_cgi_data_reset} = shift @_;
}

sub set_Last_Phase_URL_Redirect { 
    my $this = shift @_;
    
    $this->{last_phase_url_redirect} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    ### Set default value of form element to be used 
    ### inside the view template for the edit page
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; }
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Upload"; }
    if ($this->{confirm_on_submit} eq undef) { $this->{confirm_on_submit} = "Confirm"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }
    
    if (!defined($this->{ftp_host})) { $this->{ftp_host} = "localhost"; }
    if (!defined($this->{dir_temp})) { $this->{dir_temp} = "./temp"; }
    
    ### The temporary directory used to save the uploaded files is always 
    ### distinct by current user's session ID.
    my $dir_temp = $this->{dir_temp};
       $dir_temp =~ s/\/$//;
       $dir_temp = "$dir_temp/" . $cgi->param("session_id");
    
    if (!(-e $dir_temp)) {
        mkdir($dir_temp);
    }
    
    ### To be used by process_LIST function.
    $this->{dir_temp_session} = $dir_temp;
    
    if ($this->check_Button_On_Submit("proceed_")) {
        $cgi->add_Debug_Text("Save files to temporary directory...", __FILE__, __LINE__);

        ### Functions to access array variables that used store  
        ### the uploaded file names and their content.    
        my @file_name = $cgi->upl_File_Name;
        my @file_content = $cgi->upl_File_Content;

        for (my $i = 0; $i < @file_name; $i++) {
            my $fname = $file_name[$i];
            my $fcontent = $file_content[$i];

            if ($fname ne "") {
                ### Need to store the file name as CGI variables so they can 
                ### be retrieved later to support the situation where the 
                ### confirmation phase is applied. 
                $cgi->push_Param("\$file_upload_$i", $fname);
                
                if (open(MYFILE, ">$dir_temp/$fname")) {
                    ### Do whatever necessary such as saving $fcontent 
                    ### as a file with name $fname. 
                    #$cgi->add_Debug_Text("Copy to $dir_temp/$fname", __FILE__, __LINE__, "TRACING");                    

                    binmode MYFILE;
                    print MYFILE $fcontent;
                    close(MYFILE);

                } else {
                    $cgi->add_Debug_Text("Can't write file: $dir_temp/$fname", __FILE__, __LINE__, "TRACING");
                }
            }
        }
    }
    
    ### Always have file name list from the previous pushed CGI variables   
    ### to support the situation when the confirmation phase is applied.
    $this->{file_name_list} = [];
    
    my @cgi_var_list = $cgi->var_Name;
            
    foreach my $param_name (@cgi_var_list) {
        if ($param_name =~ /^\$file_upload_/) {
            push(@{$this->{file_name_list}}, $cgi->param($param_name));
        }
    }

    if ($this->last_Phase) {
        $cgi->add_Debug_Text("Last phase...", __FILE__, __LINE__);
        
        if (!$this->check_Button_On_Submit("cancel_")) {
            ### Create FTP_Service instance for ftp connection.
            my $ftp_srvc = new FTP_Service;
            
            $ftp_srvc->set_CGI($cgi);
            
            my $ftp_conn = undef;
            
            ### 04/01/2015
            if (defined($this->{ftp_login}) && defined($this->{ftp_password})) {
                $ftp_conn = $ftp_srvc->set_FTP_Conn($this->{ftp_host}, $this->{ftp_login}, $this->{ftp_password});
                
            } else {
                $ftp_conn = $ftp_srvc->make_FTP_Conn("../../../../webman/conf/ftp_connection.conf");
            }
            
            ### 06/03/2014
            $this->override_FTP_Conn_Init($ftp_conn);
  
            $ftp_srvc->set_Dir_Temp($dir_temp);
            $ftp_srvc->set_Dir_Upload($this->{dir_upload});
            $ftp_srvc->set_Transfer_Mode($this->{transfer_mode});
            
            ###################################################################
            
            ### Generate the uploaded files info. list.
            $this->{file_info} = $ftp_srvc->generate_File_Info($this->{file_name_list});
            $this->query_File_Size;           
            
            my $file_num_exist = $this->check_File_Exist;
            
            if ($file_num_exist) {
                $cgi->add_Debug_Text("Num. of files exist: $file_num_exist", __FILE__, __LINE__);
            }
            
            ### Customize the file info. to be saved.
            $this->process_File_Info;
            
            ### Saved uploaded files into upload directory using FTP service.
            $this->{file_info_saved} = $ftp_srvc->save_Files;
            
            ### 13/03/2017
            ### Move here so some info and task can be passed to and processed 
            ### by override_FTP_Conn_Complete function 
            $this->process_File_Info_Saved($ftp_conn);
            
            ### 06/03/2014
            $this->override_FTP_Conn_Complete($ftp_conn);
            
            ### Close ftp connection.
            $ftp_srvc->close_FTP_Conn;
            
        }
        
        ### Delete uploaded files from temporary directory. 
        ### Just need to get the uploaded file names.
        foreach my $fname (@{$this->{file_name_list}}) {
            if ($fname ne "") {
                unlink("$dir_temp/$fname");
                $cgi->add_Debug_Text("Delete $dir_temp/$fname", __FILE__, __LINE__, "TRACING");
            }
        }

        rmdir($dir_temp);
        
        ### Remove pushed CGI variables which used 
        ### to store the file name list. 
        foreach my $param_name (@cgi_var_list) {
            if ($param_name =~ /^\$file_upload_/) {
                $cgi->param_Shift($param_name);
            }
        }        
        
        
        ### Handle CGI data reset and URL redirect
        if (!defined($this->{last_phase_cgi_data_reset})) {
            $this->{last_phase_cgi_data_reset} = "task $this->{submit_button_name} ";
            
        } elsif (!($this->{last_phase_cgi_data_reset} =~ / $/)) {
            $this->{last_phase_cgi_data_reset} .= " ";
        }
        
        #$cgi->add_Debug_Text("Last phase CGI data reset: $this->{last_phase_cgi_data_reset}", __FILE__, __LINE__);
        $this->set_CGI_Data_Reset($this->{last_phase_cgi_data_reset});
        
        if ($this->{last_phase_url_redirect} ne "") {
            my $cgi_HTML = new CGI_HTML_Map; ### 10/02/2013

            $cgi_HTML->set_CGI($cgi);
            $cgi_HTML->set_HTML_Code($this->{last_phase_url_redirect});
      
            $cgi->redirect_Page($cgi_HTML->get_HTML_Code);        
        }
        
    } else {
        $cgi->add_Debug_Text("Form load phase...", __FILE__, __LINE__);
    }
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    #$cgi->add_Debug_Text("\!\$this->field_Entry_Error = " . !$this->field_Entry_Error, __FILE__, __LINE__);
    
    if ($this->check_Button_On_Submit("proceed_") && 
        $this->{template_default_confirm} ne "") {
        
        $this->{template_default} = $this->{template_default_confirm};
    }
    
    $this->SUPER::process_Content;
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;    
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    if ($te_type_name eq "link_path") {
        my $wmlpg = new webman_link_path_generator;
        
        $wmlpg->set_Template_Default("template_link_path.html");
        $wmlpg->set_Carried_GET_Data("session_id");
        $wmlpg->set_Additional_GET_Data($this->{link_path_additional_get_data}); ### 01/01/2009
        $wmlpg->set_Level_Start($this->{link_path_level_start});
        
        if ($this->{link_path_level_deep} < 1) { ### 14/12/2010
            $this->{link_path_level_deep} = $this->get_My_Link_Level;
        }
        
        $wmlpg->set_Level_Deep($this->{link_path_level_deep});
        
        if ($this->{link_path_separator_tag} ne "") { ### 14/12/2010
            $wmlpg->set_Separator_Tag($this->{link_path_separator_tag});
        }
        
        if ($this->{link_path_unselected_color} ne "") { ### 14/12/2010
            $wmlpg->set_Non_Selected_Link_Color($this->{link_path_unselected_color});
        }
        
        $wmlpg->set_CGI($cgi);
        $wmlpg->set_DBI_Conn($db_conn);
        
        $wmlpg->set_Link_Path($this->get_Link_Path); ### 04/02/2009
        
        $wmlpg->set_Current_Dynamic_Content_Name($te_type_name); ### 26/05/2011
        $wmlpg->set_Module_DB_Param; ### 26/05/2011        
        
        $wmlpg->run_Task;
        $wmlpg->process_Content;
        
        $te_content = $wmlpg->get_Content;
    }
    
    if ($te_type_name eq "form_hidden_field") {
        my $hpd = $this->generate_Hidden_POST_Data("session_id link_id");

        $te_content = $hpd;
    }
    
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
    my $te_type_name = $te->get_Name;
    
    if ($te_type_name eq "file_upload_list") {       
        ### Create FTP_Service instance for ftp connection. Just for the 
        ### purpose of displaying the file info. list for confirmation.
        my $ftp_srvc = new FTP_Service;

        $ftp_srvc->set_CGI($cgi);
        
        ### 04/01/2015
        if (defined($this->{ftp_login}) && defined($this->{ftp_password})) {
            $ftp_srvc->set_FTP_Conn($this->{ftp_host}, $this->{ftp_login}, $this->{ftp_password});

        } else {
            $ftp_srvc->make_FTP_Conn("../../../../webman/conf/ftp_connection.conf");
        }
        
        $ftp_srvc->set_Dir_Temp($this->{dir_temp_session});
        $ftp_srvc->set_Dir_Upload($this->{dir_upload});

        ### Generate the uploaded files info. list.
        $this->{file_info} = $ftp_srvc->generate_File_Info($this->{file_name_list});
        $this->query_File_Size; 
        
        ### Customize the file info. to be saved.
        $this->process_File_Info;
        
        ### Display the file info. list using Table_List_Data and 
        ### TLD_HTML_Map instances.
        my $tld = new Table_List_Data;
        my $tldhtml = new TLD_HTML_Map;
        
        $tld->add_Array_Hash_Reference(@{$this->{file_info}});    
        
        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content); 
        
        $this->add_Content($tldhtml->get_HTML_Code);
        
        #$cgi->add_Debug_Text($tld->get_Table_List, __FILE__, __LINE__);
    }
}

sub check_Button_On_Submit { ### 08/12/2010
    my $this = shift @_;
    my $submit_option = shift @_;
    
    my $cgi = $this->get_CGI;
    
    my $submit_current = $cgi->param($this->{submit_button_name});
    
    if ($submit_option eq "proceed_" &&
        $submit_current eq $this->{proceed_on_submit}) { 
        return 1;
    }
    
    if ($submit_option eq "confirm_" &&
        $submit_current eq $this->{confirm_on_submit}) { 
        return 1;
    }
    
    if ($submit_option eq "cancel_" &&
        $submit_current eq $this->{cancel_on_submit}) { 
        return 1;
    }     
    
    return 0;    
    
}

### The next function is hooked inside the run_Task function at the last 
### phase just after the FTP connection instance is made available but 
### before the uploaded file is saved into the target folder. 
sub override_FTP_Conn_Init {
    my $this = shift @_;
    my $ftp_conn = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;   

    ### Next is to do the task that requires 
    ### service from $ftp_conn instance.
    ### ???
}

### The next function is hooked inside the run_Task function at the last 
### phase just after the uploaded file is saved into the target folder and  
### before the FTP connection is closed. 
sub override_FTP_Conn_Complete {
    my $this = shift @_;
    my $ftp_conn = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    ### Next is to do the task that requires 
    ### service from $ftp_conn instance.
    ### ???
}

sub process_File_Info {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    #my $match_group = $this->match_Group($group_name_, @groups);
    
    ### This function is to be overriden by the child module to further 
    ### manipulate the uploaded files info. before they are saved into 
    ### the target upload directory.
    #???

}

sub process_File_Info_Saved {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    #my $match_group = $this->match_Group($group_name_, @groups);
    
    ### This function is to be overriden by the child module to further 
    ### manipulate the uploaded files info. after they are saved into 
    ### the target upload directory.
    #???

}

sub check_File_Exist {
    my $this = shift @_;
    
    my $total_exist = 0;
    
    foreach my $file (@{$this->{file_info}}) {
        if ($file->{status} eq "Exist") {
            $total_exist++;
        }
    }
    
    return $total_exist;
}

sub last_Phase {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
    if ($this->check_Button_On_Submit("proceed_") && !defined($this->{template_default_confirm})) {
        #$cgi->add_Debug_Text("Condition 1", __FILE__, __LINE__);
        return 1;
    }    
    
    if ($this->check_Button_On_Submit("cancel_") || $this->check_Button_On_Submit("confirm_")) {
        #$cgi->add_Debug_Text("Condition 2", __FILE__, __LINE__);
        return 1;
    }    
    
    return 0;
}

### 16/03/2017
sub query_File_Size {
    my $this = shift @_;
    
    foreach my $item (@{$this->{file_info}}) {
        $item->{size} = -s $this->{dir_temp_session} . "/" . $item->{name};
    
        $item->{size} = $item->{size} / 1024;

        if ($item->{size} < 1024) {
	    $item->{size} = sprintf("%.1f", $item->{size});
	    $item->{size} .= " KB";

        } else {
	    $item->{size} = $item->{size} / 1024;
	    $item->{size} = sprintf("%.1f", $item->{size});
	    $item->{size} .= " MB";
        }
    }
}

1;
