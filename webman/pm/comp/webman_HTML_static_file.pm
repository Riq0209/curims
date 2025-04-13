package webman_HTML_static_file;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use Static_Content;

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{static_file} = undef;
    
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

sub set_Static_File {
    my $this = shift @_;
    
    $this->{static_file} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    #$this->set_Error("???");
    
    $this->SUPER::run_Task();
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>";
    
    $this->SUPER::process_Content;  
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    #my $te_type_name = $te->get_Name;
    
    my $sc = new Static_Content;
                
    my $content = $sc->get_Content($this->{static_file});     
    
    $this->add_Content($content);
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    #my $te_type_name = $te->get_Name;
    
    $this->add_Content($te_content);
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

1;