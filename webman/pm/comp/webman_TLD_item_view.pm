package webman_TLD_item_view;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use webman_link_path_generator;

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef;
    $this->{link_path_separator_tag} = undef;
    $this->{link_path_unselected_color} = undef;
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009
    
    $this->{web_service_url} = undef;    ### 10/10/2012
    $this->{web_service_entity} = undef; ### 10/10/2012
    
    $this->{carried_caller_get_data} = undef; ### 27/05/2008
    $this->{remove_db_cache_cgi_var} = undef; ### 01/01/2009
    
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
    
    $this->{link_path_separator_tag} = shift @_;
}


sub set_Link_Path_Unselected_Color {
    my $this = shift @_;

    $this->{link_path_unselected_color} = undef;
}

sub set_Link_Path_Additional_Get_Data { ### 11/02/2006
    my $this = shift @_;
    
    $this->{link_path_additional_get_data} = shift @_;
}

sub set_TLD {
    my $this = shift @_;
    
    $this->{tld} = shift @_;
}

sub set_Items_View_Num {
    my $this = shift @_;
    
    $this->{items_view_num} = shift @_;
}

sub set_Items_Set_Num {
    my $this = shift @_;
    
    $this->{items_set_num} = shift @_;
}

sub set_Carried_Caller_Get_Data { ### 27/05/2008
    my $this = shift @_;
    
    $this->{carried_caller_get_data} = shift @_;
}

sub get_TLD {
    my $this = shift @_;
    
    return $this->{tld};
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->SUPER::run_Task();
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    if (defined($this->{web_service_url}) && defined($this->{web_service_entity})) { ### 10/10/2012
        $this->{wse} = new Web_Service_Entity;

        $this->{wse}->set_Web_Service_URL($this->{web_service_url});

        $this->{entity} = $this->{wse}->get_Entity($this->str2HashRef($this->{web_service_entity}));
        
        $this->{tld} = $this->{wse}->get_TLD($this->{entity});

        #$cgi->add_Debug_Text($this->{tld}->get_Table_List, __FILE__, __LINE__);        
    }
    
    if ($this->{tld} ne undef) {
        $this->customize_TLD($this->{tld});
    }
    
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    $this->SUPER::process_Content;
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->{login_name};
    my @groups = @{$this->{groups}};
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    #print "\$te_type_name = $te_type_name";
    
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
        
        #$cgi->add_Debug_Text("\$this->{link_path_separator_tag} = $this->{link_path_separator_tag}", __FILE__, __LINE__, "TRACING");
        
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
    
    $this->add_Content($te_content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    if ($this->{tld} eq undef) {
        return $te_content;
    }
    
    if ($te_type_name eq "main" && $this->{tld} ne undef) {
        my $tldhtml = new TLD_HTML_Map;

        $tldhtml->set_Table_List_Data($this->{tld});
        $tldhtml->set_HTML_Code($te_content);
        
        #$cgi->add_Debug_Text("\$this->{items_set_num} = $this->{items_set_num}", __FILE__, __LINE__, "TRACING");

        if ($this->{items_view_num} > 0 && $this->{items_set_num} > 0) {
            $tldhtml->set_Items_View_Num($this->{items_view_num});
            $tldhtml->set_Items_Set_Num($this->{items_set_num});
        }

        $te_content = $tldhtml->get_HTML_Code;
    }
    
    $this->add_Content($te_content);
}

sub get_Content { ### 27/05/2008
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
    my $cgd = $cgi->generate_GET_Data("link_name link_id dmisn app_name session_id " . $this->{carried_caller_get_data});
    
    $this->{content} =~ s/\$caller_get_data_/$cgd/g;
    
    $this->SUPER::get_Content();
}
    
sub customize_TLD {
    my $this = shift @_;
    
    my $tld = $this->{tld};
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->{tld} = $tld;
}

sub str2HashRef {
    my $this = shift @_;
    
    my $str = shift @_;
    
    my $cgi = $this->get_CGI;
    
    my $hash_ref = {};
    
    ### CGI var. pattern replacements
    my $pattern = undef;
    my $replacement = undef;

    my @cgi_var = $cgi->var_Name;

    for (my $i = 0; $i < @cgi_var; $i++) {
        $pattern = "cgi_" . $cgi_var[$i] . "_";

        $replacement = $cgi->param($cgi_var[$i]);

        #$replacement =~ s/'/\\'/g;

        #print "$pattern : $replacement <br>";

        $str =~ s/\$\b$pattern\b/$replacement/;
    }    
    
    
    ### Start construct hash ref.
    my @parts = split(/,/, $str);
    
    foreach $part (@parts) {
        my @keyval = split(/\=\>/, $part);
        
        while ($keyval[0] =~ /^ /) { $keyval[0] =~ s/^ //; }
        while ($keyval[0] =~ / $/) { $keyval[0] =~ s/ $//; }
        
        while ($keyval[1] =~ /^ /) { $keyval[1] =~ s/^ //; }
        while ($keyval[1] =~ / $/) { $keyval[1] =~ s/ $//; }        
        
        $keyval[0] =~ s/^\"//;
        $keyval[0] =~ s/\"$//;
        
        $keyval[1] =~ s/^\"//;
        $keyval[1] =~ s/\"$//;
        
        $hash_ref->{$keyval[0]} = $keyval[1];
        
        #$cgi->add_Debug_Text($keyval[0] . " - " . $keyval[1], __FILE__, __LINE__);
    }
    
    return $hash_ref;
}


1;