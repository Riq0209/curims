package web_man_admin_dynamic_module_scan;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

use web_man_admin_link_structure;
use web_man_admin_dyna_mod_utils;

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{webman_dyna_mod_files} = undef;
    
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

sub run_Task {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }    
    
    my $task = $cgi->param("task");
    my $submit = $cgi->param("submit");
    my $link_name_dyna_mod = $cgi->param("link_name_dyna_mod");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    my @array = split(/\//, $script_filename);
    
    my $dbu = new DB_Utilities;

    my $app_dir = undef;

    for ($i = 0; $i < @array - 5; $i++) {
        $app_dir .= "$array[$i]/";
    }

    $app_dir .=  "webman/pm/apps/" . $cgi->param("app_name");
    
    #print "\$app_dir = $app_dir<br />\n";
    
    my $web_man_admu = new web_man_admin_dyna_mod_utils;
    
    #$web_man_admu->set_Dynamic_Module_Folder($app_dir);
    
    $web_man_admu->set_DBI_Conn($db_conn);
    
    my @webman_dyna_mod = $web_man_admu->get_New_Valid_Webman_CGI_Component($app_dir, $cgi->param("app_name"));
    
    #print "\@webman_dyna_mod = @webman_dyna_mod <br>";
    
    if ($webman_dyna_mod[0] ne "") {
        $this->{webman_dyna_mod_files} = \@webman_dyna_mod;
    }

    if ($submit eq "Add Module" && $webman_dyna_mod[0] ne "") {
        #print "Try to add module <br>";
        
        $dbu->set_DBI_Conn($this->{db_conn}); ### option 1
        $dbu->set_Table($pre_table_name . "dyna_mod");

        for ($i = 0; $i < @webman_dyna_mod; $i++) {
            $dbu->insert_Row("dyna_mod_name", $webman_dyna_mod[$i]);
            #print $dbu->get_SQL . "<br>\n";
        }

        $this->{webman_dyna_mod_files} = undef;
    }
    
    
    ##### remove module name inside DB table that not exist in app. directory 
    
    my $module_name = undef;
    my $module_name_exist = undef;
    
    my @webman_dyna_mod_exist_app = $web_man_admu->get_Valid_Webman_CGI_Component($app_dir);
        
    foreach $module_name (@webman_dyna_mod_exist_app) {
        $module_name_exist .= "'" . $module_name . "', ";
    }
    
    my @webman_dyna_mod_exist_std = $web_man_admu->get_Valid_Webman_CGI_Component("../../../../webman/pm/comp");
        
    foreach $module_name (@webman_dyna_mod_exist_std) {
        $module_name_exist .= "'" . $module_name . "', ";
    }    
    
    $module_name_exist .= "''";
    
    #print "\$module_name_exist = $module_name_exist <br>\n";
    
    $dbu->set_DBI_Conn($this->{db_conn}); ### option 1
    $dbu->set_Table($pre_table_name . "dyna_mod");
    
    $dbu->set_Keys_Str("dyna_mod_name not in ($module_name_exist)");
    
    my @module_name_not_exist = $dbu->get_Items("dyna_mod_name");
    
    #print $dbu->get_SQL;
    
    $dbu->set_Keys_Str(undef);
    
    my $har_item = undef;
    
    foreach $har_item (@module_name_not_exist) {
        #print $har_item->{dyna_mod_name} . "<br>\n";
        $dbu->delete_Item("dyna_mod_name", $har_item->{dyna_mod_name});
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_dynamic_module_scan.html");
    
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
    
    if ($this->{webman_dyna_mod_files} ne undef) {
        $te_content =~ s/\$message_/Found new Webman modules/;
    } else {
        $te_content =~ s/\$message_/No new Webman modules found/;
    }
    
    $this->add_Content($te_content);
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $hpd = $this->generate_Hidden_POST_Data("link_name dmisn app_name link_name_dyna_mod dmisn_dyna_mod");
    
    $this->add_Content($hpd);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    if ($this->{webman_dyna_mod_files} ne undef) {
        my @new_dyna_mod_name = @{$this->{webman_dyna_mod_files}};
        
        my $tld = new Table_List_Data;
    
        $tld->add_Column("dyna_mod_name");
        
        my $i = 0;
        
        for ($i = 0; $i < @new_dyna_mod_name; $i++) {
            $tld->add_Row_Data($new_dyna_mod_name[$i]);
        }
        
        my $tldhtml = new TLD_HTML_Map;

        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);

        my $html_result = $tldhtml->get_HTML_Code;

        $this->add_Content($html_result);
    }
}

sub valid_Webman_CGI_Component {
    my $this = shift @_;
    
    my $dyna_mod_file_name = shift @_;
    
    my ($i, $valid_indicator) = (0, 0);
    
    if (open(MYFILE, "<$dyna_mod_file_name")) {
        
        my @file_content = <MYFILE>;
        
        close (MYFILE);
        
        for ($i = 0; $i < @file_content; $i++) {
            
            if ($file_content[$i] =~ /require webman_CGI_component;/) { $valid_indicator++; }
            if ($file_content[$i] =~ /use webman_CGI_component;/) { $valid_indicator++; }
            if ($file_content[$i] =~ /\@ISA=\("webman_CGI_component"\);/) { $valid_indicator++; }
            
            if ($valid_indicator > 1) { return 1; }
        }
    }
    
    return 0;
}

1;