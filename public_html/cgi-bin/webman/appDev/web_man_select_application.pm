package web_man_select_application;

unshift (@INC, "../../../../webman/pm/core");

require CGI_Component;

@ISA=("CGI_Component");

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
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

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_select_application.html");
    
    $this->SUPER::process_Content;  
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    
    my @array = split(/\//, $script_filename);
    
    my $i = 0;
    my $counter = 0;
    my $app_dir = undef;
    my $app_list = undef;
    
    for ($i = 0; $i < @array - 2; $i++) {
        $app_dir .= "$array[$i]/";
    }
    
    opendir(DIRHANDLE, $app_dir);
    
    my @files = readdir(DIRHANDLE);

    @files = sort(@files);
    
    my $tld = new Table_List_Data;
    
    $tld->add_Column("app_name");
    $tld->add_Column("link_develop");
    $tld->add_Column("link_run");
    
    @list_array_data = undef;

    for ($i = 0; $i < @files; $i++) {
        if ($files[$i] =~ /\./ || $files[$i] eq "appDev") {
            ### do nothing
        } else {
            $list_array_data[0] = $files[$i];
            $list_array_data[1] = "index.cgi?app_name=$files[$i]&app_dir=$app_dir";
            $list_array_data[2] = "../$files[$i]/index.cgi?";
            
            $tld->add_Row_Data(@list_array_data);
        }
    }
    
    my $tldhtml = new TLD_HTML_Map;
                
    $tldhtml->set_Table_List_Data($tld);
    $tldhtml->set_HTML_Code($te_content);
    
    my $html_result = $tldhtml->get_HTML_Code;
                
    $this->add_Content($html_result);
}