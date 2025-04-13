package app_admin_select_application;

unshift (@INC, "../");

require webman_CGI_component;

@ISA=("webman_CGI_component");

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

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_select_application.html");
    
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
    
    my $session_id = $cgi->param("session_id");
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    
    my @array = split(/\//, $script_filename);
    
    my $i = 0;
    my $counter = 0;
    my $app_dir = undef;
    my $app_list = undef;
    
    for ($i = 0; $i < @array - 2; $i++) {
        $app_dir .= "$array[$i]/";
    }
    
    #$cgi->add_Debug_Text("\$app_dir = $app_dir", __FILE__, __LINE__);
    
    opendir(DIRHANDLE, $app_dir);
    
    my @files = readdir(DIRHANDLE);

    @files = sort(@files);

    for ($i = 0; $i < @files; $i++) {
        if ($files[$i] =~ /\./ || $files[$i] eq "appDev") {
            ### do nothing
            
        } else {
            $app_list .= "<a href=\"index.cgi?session_id=$session_id&app_name=appAdmin&app_name_in_control=$files[$i]&app_dir=$app_dir\">". 
                         "<font color=\"#0099FF\">" .
                         "$files[$i]" .
                         "<\/font>" . 
                         "<\/a>" .
                         "<br>\n";
        }
    }
    
    $this->add_Content($app_list);
}