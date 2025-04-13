package webman_link_path_generator;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{additional_get_data} = undef;
    $this->{carried_get_data} = undef;
    $this->{last_not_active} = 0;
    $this->{level_start} = undef;
    $this->{level_deep} = undef;
    
    $this->{non_selected_link_color} = undef;
    $this->{separator_tag} = undef;
    
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

sub set_Additional_GET_Data {
    my $this = shift @_;
    
    $this->{additional_get_data} = shift @_;
}

sub set_Carried_GET_Data {
    my $this = shift @_;
    
    $this->{carried_get_data} = shift @_;
}

sub set_Last_Not_Active {
    my $this = shift @_;
    
    $this->{last_not_active} = shift @_;
}

sub set_Level_Start {
    my $this = shift @_;
    
    $this->{level_start} = shift @_;
}

sub set_Level_Deep {
    my $this = shift @_;
    
    $this->{level_deep} = shift @_;
}

sub set_Separator_Tag { ### 14/12/2010
    my $this = shift @_;
    
    $this->{separator_tag} = shift @_;
}

sub set_Non_Selected_Link_Color { ### 14/12/2010
    my $this = shift @_;
    $this->{non_selected_link_color} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->SUPER::run_Task();
    
    #print "run_Task from webman_link_path_generator: </font>" . $this->get_Name . "<br>\n";
    #print "Called by: " . $this->get_Caller_Module_Name . "<br>\n";
    
    #$this->print_Link_Path_Info;
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>\n";
    
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
    
    my $app_name = $cgi->param("app_name");
    
    my $link_path_info = $this->generate_Link_Path_Info("index.cgi", $this->{additional_get_data}, $this->{carried_get_data}, 
                                                        $this->{last_not_active}, $this->{level_start}, $this->{level_deep},
                                                        $this->{non_selected_link_color}, $this->{separator_tag});
    
    $te_content =~ s/\$LINK_PATH_DYNAMIC_/$link_path_info/;
    
    $this->add_Content($te_content);
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

1;