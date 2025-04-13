package webman_image_map_links;

require webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{default_template} = undef;
    
    $this->{link_path_level} = undef;
    
    $this->{link_separator_tag} = undef;
    
    $this->{cgi_get_data} = undef;
    $this->{cgi_get_data_carried} = undef;
    
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
    
    $this->set_Template_File($this->{default_template});
    
    #print "\$this->{default_template} = " . $this->{default_template} . "<br>\n";
    
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


    my @links = $this->get_My_Menu_Links;
    
    #print "\$links[0] = $links[0]<br>";
    
    my $iml = new Image_Map_Link;
    
    $iml->set_Link_Template($te_content);
    $iml->set_Links(@links);
    $iml->set_Auto_Links("index.cgi");
    
    my $cgi_get_data_carried = $this->generate_GET_Data($this->{cgi_get_data_carried});
    
    $iml->add_GET_Data_Links_Source($this->{cgi_get_data});
    $iml->add_GET_Data_Links_Source($cgi_get_data_carried);
    
    $te_content = $iml->get_Links;
    
    $this->add_Content($te_content);
}

1;