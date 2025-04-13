package webman_static_links;

require webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{key_link_id} = undef; ### 2006/12/05
    
    $this->{link_path_level} = undef;
    
    $this->{link_separator_tag} = undef;
    
    $this->{cgi_get_data} = undef;
    $this->{cgi_get_data_carried} = undef;
    
    $this->{non_selected_link_color} = "#0099CC";
    
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
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->SUPER::run_Task();
    
    #$this->print_Link_Path_Info;
    
    if ($this->{link_path_level} ne undef) {
        my @link_path = $this->get_Link_Path;
        my $current_link_path_level = @link_path - 1;
        
        my ($suite_link_id, $suite_link_name) = undef;
        
        my $dbu = new DB_Utilities;
                
        $dbu->set_DBI_Conn($db_conn); ### option 1
        
        
        my $level_count = $current_link_path_level;
        
        if ($current_link_path_level < $this->{link_path_level}) {  
            #print "condition 1 <br>";
            
            while ($level_count < $this->{link_path_level}) {
                $suit_link_id = $this->get_My_First_Child_Link_ID;
                $this->set_My_Link_ID($suit_link_id);
                $level_count++;
            }
            
            $dbu->set_Table("link_structure");
            
            if ($dbu->get_Item("auto_selected", "link_id", "$suit_link_id") eq "YES") {
                $this->set_My_Link_Name($dbu->get_Item("name", "link_id", "$suit_link_id"));
            }
            
        } else {
            #print "condition 2 <br>";
            
            ($suit_link_id, $suit_link_name) = %{$link_path[$this->{link_path_level}]};
            
            $dbu->set_Table("link_structure");
                    
            $this->set_My_Link_ID($suit_link_id);
            $this->set_My_Link_Name($suit_link_name);
            
        } 
        #print "\$suit_link_id = $suit_link_id <br>";
        #print "\$current_link_path_level = $current_link_path_level <br>";
        #print "\$this->{link_path_level} = $this->{link_path_level} <br>";
        
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
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
    
    #print "\$link_id = $link_id - \$link_name = $link_name <br>";
    
    my @menu_items = $this->get_My_Menu_Items($this->{key_link_id}); ### 2006/12/05
    my @menu_links = $this->get_My_Menu_Links($this->{key_link_id});
    
    #print "\$menu_links[0] = $menu_links[0] <br>";

    my $html_menu = new HTML_Link_Menu;
    
    $html_menu->set_Menu_Template_Content($te_content);
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    
    $html_menu->set_Auto_Menu_Links("index.cgi", "link_name");
    
    
    $html_menu->set_Non_Selected_Link_Color($this->{non_selected_link_color});
    $html_menu->set_Active_Menu_Item($this->get_My_Link_Name);
    
    #print "<br>\$this->get_My_Link_Name = " . $this->get_My_Link_Name . "<br>";
        
    #print "\$this->{link_separator_tag} = $this->{link_separator_tag} <br>";
    
    my $cgi_get_data_carried = $this->generate_GET_Data($this->{cgi_get_data_carried});
    
    $html_menu->add_GET_Data_Links_Source($this->{cgi_get_data});
    $html_menu->add_GET_Data_Links_Source($cgi_get_data_carried);
    
    $te_content = $html_menu->get_Menu;
    
    $this->add_Content($te_content);
}

1;