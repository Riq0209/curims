package webman_dynamic_links;

require webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{link_id_key} = undef;
    $this->{link_path_level} = undef;
    
    $this->{cgi_get_data} = undef;
    $this->{cgi_get_data_carried} = undef;
    
    $this->{link_separator_tag} = undef;
    $this->{non_selected_link_color} = undef;
    
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

sub set_Link_ID_Key {
    my $this = shift @_;
    
    $this->{link_id_key} = shift @_;
}

sub set_Link_Path_Level {
    my $this = shift @_;
    
    $this->{link_path_level} = shift @_;
}

sub set_CGI_GET_Data {
    my $this = shift @_;
    
    $this->{cgi_get_data} = shift @_;
}

sub set_CGI_GET_Data_Carried {
    my $this = shift @_;
    
    $this->{cgi_get_data_carried} = shift @_;
}

sub set_Link_Separator_Tag {
    my $this = shift @_;
    
    $this->{link_separator_tag} = shift @_;
}

sub set_Non_Selected_Link_Color {
    my $this = shift @_;
    
    $this->{non_selected_link_color} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    $this->SUPER::run_Task();
    
    #my $dbu = new DB_Utilities;
                
    #$dbu->set_DBI_Conn($db_conn); ### option 1   
    
    $dbu->set_Table("webman_" . $cgi->param("app_name") . "_link_structure");
    
    if ($cgi->param("link_id") ne "" && 
        $cgi->param("link_id") ne $this->{my_link_id}) {
        $this->{my_link_id} = $cgi->param("link_id");
    }
    
    $this->{link_id_key_exist} = $dbu->find_Item("link_id", $this->{link_id_key});
    #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");    
    
    if ($this->{link_path_level} ne undef) {
        my @link_path = ();
        
        if ($this->{link_id_key} eq undef) { ### base on user click
            @link_path = $this->get_Link_Path;
            
        } else { ### set by application developer but user might also click it           
            $parent_link_id_key = $dbu->get_Item("parent_id", "link_id", $this->{link_id_key});
            $parent_link_id_cgi = $dbu->get_Item("parent_id", "link_id", $cgi->param("link_id"));
            
            if ($parent_link_id_key eq $parent_link_id_cgi) {
                @link_path = $this->get_Link_Path;
                
            } else {
                ### not set @link_path since only want to list the link item
            }
        }
        
        $dbu->get_Item("parent_id", "link_id", $this->{my_link_id});
        
        my $current_link_path_level = @link_path - 1;
        
        my ($suit_link_id, $suite_link_name) = undef;

        my $level_count = $current_link_path_level;
        
        #$cgi->add_Debug_Text($this->get_Link_Path_Info, __FILE__, __LINE__);
        
        if ($current_link_path_level < $this->{link_path_level}) {  
            #$cgi->add_Debug_Text("\$this->{my_link_id} = $this->{my_link_id}", __FILE__, __LINE__);
            
            while ($level_count < $this->{link_path_level}) {
                $suit_link_id = $this->get_My_First_Child_Link_ID;
                $this->set_My_Link_ID($suit_link_id);
                $level_count++;
            }
            
            #$cgi->add_Debug_Text("level_count = $level_count", __FILE__, __LINE__);
            #$cgi->add_Debug_Text("\$this->{my_link_id} = $this->{my_link_id}", __FILE__, __LINE__);
            #$cgi->add_Debug_Text("\$suit_link_id = $suit_link_id", __FILE__, __LINE__);
            
            if ($dbu->get_Item("auto_selected", "link_id", "$suit_link_id") eq "YES") {
                $this->set_My_Link_Name($dbu->get_Item("name", "link_id", "$suit_link_id"));
            }
            
        } else {
            #print "condition 2 <br>";
            
            ($suit_link_id, $suit_link_name) = %{$link_path[$this->{link_path_level}]};
                    
            $this->set_My_Link_ID($suit_link_id);
            $this->set_My_Link_Name($suit_link_name);
            
        }
        
        #$cgi->add_Debug_Text("\$suit_link_id = $suit_link_id", __FILE__, __LINE__);
        #$cgi->add_Debug_Text("\$current_link_path_level = $current_link_path_level", __FILE__, __LINE__);
        #$cgi->add_Debug_Text("\$this->{link_path_level} = $this->{link_path_level}", __FILE__, __LINE__);  
        #$cgi->add_Debug_Text("\$this->{link_id_key_exist} = $this->{link_id_key_exist}", __FILE__, __LINE__);  
        
        $this->{suit_link_id} = $suit_link_id;
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #$cgi->add_Debug_Text("\$this->{template_default} = " . $this->{template_default}, __FILE__, __LINE__);
    
    $this->SUPER::process_Content;  
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

sub process_MENU { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $link_id = $this->get_Current_Link_ID;
    my $link_name = $this->get_Current_Link_Name;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    #$cgi->add_Debug_Text("\$link_id = $link_id - \$link_name = $link_name", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{link_id_key} = $this->{link_id_key}", __FILE__, __LINE__);
    
    if (defined($this->{link_id_key}) && !$this->{link_id_key_exist}) {
        return 0;
    }
    
    if (!defined($this->{link_id_key}) && $this->{suit_link_id} eq "") {
        return 0;
    }
    
    my @menu_items = $this->get_My_Menu_Items($this->{link_id_key});
    my @menu_links = $this->get_My_Menu_Links($this->{link_id_key});
    
    my $current_link_level_name = $this->get_My_Link_Name;
    
    #print "<br>\$current_link_level_name = " . $current_link_level_name . "<br>";
    
    my @menu_items_filtered = ();
    my @menu_links_filtered = ();
    
    for (my $i = 0; $i < @menu_links; $i++) {
        my $menu_link_id = $menu_links[$i];
           $menu_link_id =~ s/^link_id=//;
        
        ### for auth_Link_ID function call set $skip_error_message = 1 
        ### so webman_dynamic_links.pm can still render the result content
        
        if ($this->auth_Link_ID($menu_link_id, undef, 1)) {
            push(@menu_items_filtered, $menu_items[$i]);
            push(@menu_links_filtered, $menu_links[$i]);
        }
        
        #$cgi->add_Debug_Text("\Link ID : Link Name = $menu_link_id : $menu_items[$i]", __FILE__, __LINE__, "TRACING");
    }
    
    ### part for multi language support ##########################################
    
    my $language = $cgi->param("language");
    
    if ($language ne "MALAY") {
        my %link_dictionary = $this->get_Link_Dictionary_Hash;
        
        for ($i = 0; $i < @menu_items_filtered; $i++) {
            if ($link_dictionary{$menu_items[$i]} ne "") {
                $menu_items[$i] = $link_dictionary{$menu_items[$i]};
            }

            if ($link_dictionary{$current_link_level_name} ne "") {
                $current_link_level_name = $link_dictionary{$current_link_level_name};  
            } 
        }
    }
    
    ### end part for multi language support ##########################################
    
    my $html_menu = new HTML_Link_Menu_Paginate;
    
    $html_menu->set_Menu_Items(@menu_items_filtered);
    $html_menu->set_Menu_Links(@menu_links_filtered);
    
    $html_menu->set_Items_View_Num(10);
    $html_menu->set_Items_Set_Num(1);    
    
    $html_menu->set_Auto_Menu_Links("index.cgi", "link_name", "dmisn");
    $html_menu->set_Active_Menu_Item($current_link_level_name);
    
    #$cgi->add_Debug_Text($current_link_level_name, __FILE__, __LINE__);
    
    #print "<br>\$this->get_My_Link_Name = " . $this->get_My_Link_Name . "<br>";
    
    #print "\$this->{link_separator_tag} = $this->{link_separator_tag} <br>";
    
    $html_menu->set_Separator_Tag($this->{link_separator_tag});
    $html_menu->set_Next_Tag("");
    $html_menu->set_Previous_Tag("");
    
    if (defined($this->{non_selected_link_color})) {
        $html_menu->set_Non_Selected_Link_Color($this->{non_selected_link_color});
        #$cgi->add_Debug_Text($this->{non_selected_link_color}, __FILE__, __LINE__);
    }
    
    #print "\$this->{cgi_get_data_carried} = " . $this->{cgi_get_data_carried} . "<br>";
    
    my $cgi_get_data_carried = $this->generate_GET_Data($this->{cgi_get_data_carried});
    
    $html_menu->add_GET_Data_Links_Source($this->{cgi_get_data});
    $html_menu->add_GET_Data_Links_Source($cgi_get_data_carried);
    
    #print "\$cgi_get_data_carried = " . $cgi_get_data_carried . "<br>";
    $html_menu->set_Menu_Template_Content($te_content);
    $te_content = $html_menu->get_Menu;
    
    $this->add_Content($te_content);
}

sub get_Link_Dictionary_Hash {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $app_name = $cgi->param("app_name");
    my $language = $cgi->param("language");
    
    my $link_structure_table_name = "webman_" . $app_name . "_link_structure";
    my $dictionary_table_name = "webman_" . $app_name . "_dictionary_link";
    
    #my $dbu = new DB_Utilities;
    
    #$dbu->set_DBI_Conn($db_conn);
    
    $dbu->set_Table("webman_" . $app_name . "_dictionary_language");
    
    my $lang_id = $dbu->get_Item("lang_id", "language", "$language");
    
    my $sth = $db_conn->prepare("select ls.name, dl.link_name_translate 
                                from $link_structure_table_name ls, $dictionary_table_name dl 
                                where dl.lang_id='$lang_id' and ls.link_id=dl.link_id");
    
    $sth->execute;
    
    my %dictionary_hash = undef;
    my $hash_ref = undef;
    
    while ($hash_ref = $sth->fetchrow_hashref) {
        $dictionary_hash{$hash_ref->{name}} = $hash_ref->{link_name_translate};
    }
    
    $sth->finish;
    
    return %dictionary_hash;
}

1;