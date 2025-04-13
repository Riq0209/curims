package webman_FTP_list;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $type = shift;
    
    my $this = webman_CGI_component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{ftp_host} = undef;
    $this->{ftp_login} = undef;
    $this->{ftp_password} = undef;
    
    $this->{dir_top} = undef;
    $this->{dir_list} = undef;
    
    $this->{html_tag_dir_top} = undef;
    $this->{html_tag_dir_separator} = undef;
    
    $this->{link_style_dir} = undef;
    $this->{link_style_file} = undef;
    
    $this->{param_dir_path} = undef;
    
    $this->{param_selected_dir} = undef;
    $this->{param_selected_file} = undef;
    
    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef; ### 14/12/2010
    $this->{link_path_separator_tag} = undef; ### 14/12/2010
    $this->{link_path_unselected_color} = undef; ### 14/12/2010
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009
    
    $this->{dir_select_cgi_data_reset} = undef;
    $this->{dir_select_url_redirect} = undef;
    
    $this->{file_select_cgi_data_reset} = undef;
    $this->{file_select_url_redirect} = undef;    
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

sub set_Dir_Top { 
    my $this = shift @_;
    
    $this->{dir_top} = shift @_;
}

sub set_Dir_List { 
    my $this = shift @_;
    
    $this->{dir_list} = shift @_;
}

sub set_HTML_Tag_Dir_Top { 
    my $this = shift @_;
    
    $this->{html_tag_dir_top} = shift @_;
}

sub set_HTML_Tag_Dir_Separator { 
    my $this = shift @_;
    
    $this->{html_tag_dir_separator} = shift @_;
}

sub set_Link_Style_Dir { 
    my $this = shift @_;
    
    $this->{link_style_dir} = shift @_;
}

sub set_Link_Style_File { 
    my $this = shift @_;
    
    $this->{link_style_file} = shift @_;
}
   
sub set_Param_Dir_Path { 
    my $this = shift @_;
    
    $this->{param_dir_path} = shift @_;
}

sub set_Param_Selected_Dir { 
    my $this = shift @_;
    
    $this->{param_selected_dir} = shift @_;
}

sub set_Param_Selected_File { 
    my $this = shift @_;
    
    $this->{param_selected_file} = shift @_;
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

sub set_Dir_Select_CGI_Data_Reset { 
    my $this = shift @_;
    
    $this->{dir_select_cgi_data_reset} = shift @_;
}

sub set_Dir_Select_URL_Redirect { 
    my $this = shift @_;
    
    $this->{dir_select_url_redirect} = shift @_;
}

sub set_File_Select_CGI_Data_Reset { 
    my $this = shift @_;
    
    $this->{file_select_cgi_data_reset} = shift @_;
}

sub set_File_Select_URL_Redirect { 
    my $this = shift @_;
    
    $this->{file_select_url_redirect} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    $this->SUPER::run_Task();
    
    ### Set default value of CGI parameter name used to hold the current
    ### directory path and its current selected directory/file.
    if (!defined($this->{param_dir_path})) { $this->{param_dir_path} = "dir_path"; } 
    if (!defined($this->{param_selected_file})) { $this->{param_selected_file} = "selected_file"; }
    if (!defined($this->{param_selected_dir})) { $this->{param_selected_dir} = "selected_dir"; }
    
    ### Set other default value.
    if (!defined($this->{html_tag_dir_top})) { $this->{html_tag_dir_top} = "home"; }
    if (!defined($this->{html_tag_dir_separator})) { $this->{html_tag_dir_separator} = "/"; }
    
    $this->{dir_path} = $cgi->param_Shift($this->{param_dir_path});
    $this->{selected_file} = $cgi->param_Shift($this->{param_selected_file});
    $this->{selected_dir} = $cgi->param_Shift($this->{param_selected_dir});
    
    $cgi->add_Debug_Text("\$this->{dir_path} = $this->{dir_path}", __FILE__, __LINE__);
    
    ### Control the list directory so it will always consistent not 
    ### exceeding the current set top directory, etc.
    if (!defined($this->{dir_top})) {
        $this->{dir_top} = "./";        
    }
    
    if (!($this->{dir_top} =~ /\/$/)) {
        $this->{dir_top} .= "/";
    }
    
    if ($this->{dir_path} ne "") {
         $this->{dir_list} = $this->{dir_path};         
    }  
    
    if (!defined($this->{dir_list})) {
        $this->{dir_list} = $this->{dir_top};        
    }
    
    ### Not a sub directory of top directory.
    if (!($this->{dir_list} =~ /^$this->{dir_top}/)) {
        $this->{dir_list} = $this->{dir_top};
        
    } else {
        ### Over the allowed most top directory. 
        if (scalar(split("/", $this->{dir_list})) < scalar(split("/", $this->{dir_top}))) {
            $this->{dir_list} = $this->{dir_top};
        }
    }
    
    $this->{dir_list} =~ s/\/\//\//g;
    $this->{dir_path} = $this->{dir_list};
    
    ### Store current directory path ad CGI parameter.
    $cgi->push_Param("$this->{param_dir_path}", $this->{dir_list});
    
    ### Create FTP_Service instance for ftp connection.
    my $ftp_srvc = new FTP_Service;
    
    ### Quickly make the FTP_Service instance as a member scalar so it can 
    ### be used inside the "run_Task_File_Select" and "run_Task_Dir_Select" 
    ### functions inside the child module.
    $this->{ftp_service} = $ftp_srvc;

    $ftp_srvc->set_CGI($cgi);
    $ftp_srvc->set_FTP_Conn($this->{ftp_host}, $this->{ftp_login}, $this->{ftp_password});
    
    my $status = 1;
    
    if ($ftp_srvc->set_Dir_Top($this->{dir_top})) {        
        if ($ftp_srvc->set_Dir_List($this->{dir_list})) {            
            if ($this->{selected_file} ne "") {
                $this->run_Task_File_Select;
            }
            
            if ($this->{selected_dir} ne "") {
                $this->run_Task_Dir_Select;
            }
            
        } else {
            ### Only reach here if not existed or not allowed.
            $this->{dir_list} = $this->{dir_top};
            $this->{dir_path} = $this->{dir_list};

            ### Store current directory path ad CGI parameter.
            $cgi->push_Param("$this->{param_dir_path}", $this->{dir_list});         
        }
        
    } else {
        $status = 0;
    }
    
    $cgi->add_Debug_Text("\$this->{ftp_service} = $this->{ftp_service}", __FILE__, __LINE__);
    
    return $status;
}

sub run_Task_File_Select {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    #my $match_group = $this->match_Group($group_name_, @groups);
    
    $this->set_CGI_Data_Reset($this->{file_select_cgi_data_reset});
    
    if ($this->{file_select_url_redirect} ne "") {
        my $cgi_HTML = new CGI_HTML_Map; ### 10/02/2013

        $cgi_HTML->set_CGI($cgi);
        $cgi_HTML->set_HTML_Code($this->{file_select_url_redirect});

        $cgi->redirect_Page($cgi_HTML->get_HTML_Code);        
    }    
}

sub run_Task_Dir_Select {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    #my $match_group = $this->match_Group($group_name_, @groups);
    
    $this->set_CGI_Data_Reset($this->{dir_select_cgi_data_reset});
    
    if ($this->{dir_select_url_redirect} ne "") {
        my $cgi_HTML = new CGI_HTML_Map; ### 10/02/2013

        $cgi_HTML->set_CGI($cgi);
        $cgi_HTML->set_HTML_Code($this->{dir_select_url_redirect});

        $cgi->redirect_Page($cgi_HTML->get_HTML_Code);        
    }    
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
    
    if ($te_type_name eq "dir_path") {
        my $dir_path = undef;
        my $dir_path_str = undef;
        
        my $link_id = $cgi->param("link_id");
        
        my @parts = split(/\//, $this->{dir_list});
        
        my $start_path = 0;
        
        foreach my $item (@parts) {
            $dir_path .= "$item/";
            
            if ($dir_path eq $this->{dir_top}) {
                $start_path = 1;
                $item =$this->{html_tag_dir_top};
            }
            
            if ($start_path) {
                my $get_data = "link_id=$link_id&$this->{param_dir_path}=$dir_path";
                $dir_path_str .= "<a href=\"index.cgi?$get_data\" $this->{link_style_dir}>$item</a>$this->{html_tag_dir_separator}";
            }
        }
        
        $te_content = $dir_path_str;
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
    
    $cgi->add_Debug_Text("\$this->{dir_list} = $this->{dir_list}", __FILE__, __LINE__);
    
    if ($te_type_name eq "dir_content_list" && $this->{ftp_service}) {               

        ### Display the directory content list using Table_List_Data and 
        ### TLD_HTML_Map instances.
        my $tld = new Table_List_Data;
        my $tldhtml = new TLD_HTML_Map;

        my $content_list = $this->{ftp_service}->get_Content_List;

        if ($content_list->[0]) {
            $tld->add_Array_Hash_Reference(@{$content_list});

            my $num_row = $tld->get_Row_Num;
            my $link_id = $cgi->param("link_id");

            $cgi->add_Debug_Text("\$this->{dir_path} = $this->{dir_path}", __FILE__, __LINE__);

            for (my $index_row = 0; $index_row < $num_row; $index_row++) {
                my $name_get_fmt = $cgi->convert_GET_Format_CharToCode($tld->get_Data($index_row, "name"));
                my $type = $tld->get_Data($index_row, "type");

                if ($type eq "Dir") {
                    my $next_dir_path = "$this->{dir_path}/$name_get_fmt";
                       $next_dir_path =~ s/\/\//\//g;

                    $tld->set_Data_Get_Link($index_row, "name", "index.cgi?link_id=$link_id&$this->{param_dir_path}=$next_dir_path&$this->{param_selected_dir}=$name_get_fmt&$this->{param_selected_file}=", $this->{link_style_dir});

                } else {
                    $tld->set_Data_Get_Link($index_row, "name", "index.cgi?link_id=$link_id&$this->{param_selected_file}=$name_get_fmt&$this->{param_selected_dir}=", $this->{link_style_file});
                }
            }

            $tld = $this->customize_TLD($tld);

            $tldhtml->set_Table_List_Data($tld);
            $tldhtml->set_HTML_Code($te_content); 

            $this->add_Content($tldhtml->get_HTML_Code);

            #$cgi->add_Debug_Text($tld->get_Table_List, __FILE__, __LINE__);
        }
    }
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    return $tld;
}

sub end_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
    $this->SUPER::end_Task;
    
    if ($this->{ftp_service}) {
        $this->{ftp_service}->close_FTP_Conn;
        $cgi->add_Debug_Text("Close FTP connection...", __FILE__, __LINE__);
    }
}

1;