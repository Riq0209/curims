package webman_HTML_printer;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $type = shift;
    
    my $this = webman_CGI_component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{template_default_edit} = undef;
    
    $this->{html_content} = undef;
    
    $this->{table_name} = undef;
    $this->{content_field_name} = undef;
    $this->{key_field_str} = undef;
    
    $this->{edit_mode} = undef;
    
    $this->{param_edit_mode} = undef;
    $this->{param_save_mode} = undef;
    
    $this->{submit_button_name} = undef;
    $this->{proceed_on_submit} = undef;
    $this->{cancel_on_submit} = undef;
    
     $this->{sql_debug} = shift @_;
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    $this->{template_default} = shift @_;
}

sub set_Template_Default_Edit {
    my $this = shift @_;
    
    $this->{template_default_edit} = shift @_;
}

sub set_HTML_Content {
    my $this = shift @_;
    
    $this->{html_content} = shift @_;
}

sub set_Table_Name {
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Content_Field_Name {
    my $this = shift @_;
    
    $this->{content_field_name} = shift @_;
}

sub set_Key_Field_Str {
    my $this = shift @_;
    
    $this->{key_field_str} = shift @_;
}

sub set_Edit_Mode {
    my $this = shift @_;
    
    $this->{edit_mode} = shift @_;
}

sub set_Param_Edit_Mode {
    $this->{param_edit_mode} = shift @_;
}

sub set_Param_Save_Mode {
    $this->{param_save_mode} = shift @_;
}

sub set_Submit_Button_Name { 
    my $this = shift @_;
    
    $this->{submit_button_name} = shift @_; 
}

sub set_Proceed_On_Submit {
    my $this = shift @_;
    
    $this->{proceed_on_submit} = shift @_;
}

sub set_Cancel_On_Submit {
    my $this = shift @_;
    
    $this->{cancel_on_submit} = shift @_;
}

sub set_SQL_Debug {
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    #$this->set_Error("???");
    
    $this->SUPER::run_Task();
    
    ### Set default value of form element to be used 
    ### inside the view template for the edit page
    if ($this->{submit_button_name} eq undef) { $this->{submit_button_name} = "button_submit"; }
    if ($this->{proceed_on_submit} eq undef) { $this->{proceed_on_submit} = "Save"; }
    if ($this->{cancel_on_submit} eq undef) { $this->{cancel_on_submit} = "Cancel"; }
    
    if (!defined($this->{param_edit_mode})) { $this->{param_edit_mode} = "edit_mode"; }
    if (!defined($this->{param_save_mode})) { $this->{param_save_mode} = "save_mode"; }
    
    ### Check if content if from other database table
    if (defined($this->{table_name}) &&  
        defined($this->{content_field_name} && 
        defined($this->{key_field_str}))) {
        
        my $cgi_HTML = new CGI_HTML_Map;
        
        $cgi_HTML->set_CGI($this->{cgi});
        $cgi->push_Param("content_field_name", $this->{content_field_name});
        $cgi_HTML->set_HTML_Code($this->{key_field_str});
        $cgi_HTML->set_Escape_HTML_Tag(0);
        
        my $key_field_str = $cgi_HTML->get_HTML_Code;
        
        $dbu->set_Table($this->{table_name});
        $dbu->set_Keys_Str($key_field_str);
        
        ### Check if need to save (after submission from edit page). Need 
        ### shift "save_mode" CGI parameter or it will be keep cached into 
        ### database and causes the save mode always true.
        if ($cgi->param_Shift($this->{param_save_mode}) &&
            $cgi->param($this->{submit_button_name}) eq $this->{proceed_on_submit}) {
            
            #$cgi->add_Debug_Text("Try to save...", __FILE__, __LINE__);
            
            my $content = $cgi->param_Shift("html_content");
            
            $content = $this->refine_Saved_Content($content);
            $content =~ s/ /\\ /g;
               
            $dbu->update_Item($this->{content_field_name}, $content);
            
            if ($this->{sql_debug}) {
                $cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
            }            
        }
        
        $this->{html_content} = $dbu->get_Item($this->{content_field_name});
        
        if ($this->{sql_debug}) {
            $cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        }
        
        $dbu->set_Keys_Str(undef); 
    }
    
    ### Set page either for view or edit
    if ($cgi->param_Shift($this->{param_edit_mode})) {
        $this->{edit_mode} = 1;
        
    } else {
        $this->{edit_mode} = 0;
        
        ### 04/03/2014
        $this->{html_content} = $this->process_HTML_Content;        
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    if ($this->{edit_mode}) {
        $this->{template_default} = $this->{template_default_edit};
    }
    
    #$cgi->add_Debug_Text("\$this->{template_default} = " . $this->{template_default}, __FILE__, __LINE__);
    
    $this->SUPER::process_Content;  
}

### 04/03/2014
sub process_HTML_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $tex = new Template_Element_Extractor;
    $tex->set_Doc_Content($this->{html_content});

    my @te = $tex->get_Template_Element;
    
    my $content = undef;
    
    foreach my $item (@te) {   
        if ($item->get_Type eq "DYNAMIC") {
            $content .= $this->process_Dynamic_View_Element($item->get_Name);
            
        } else {
            $content .= $item->get_Content;
        }
    }
    
    return $content;    
}

### 04/03/2014
sub process_Dynamic_View_Element {
    my $this = shift @_;
    
    my $te_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    #$cgi->add_Debug_Text($te_name, __FILE__, __LINE__);
    
    return "<p><b>Dynamic view element:</b> $te_name</p>";
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    if ($te_type_name eq "html_content") {
        my $cgi_HTML = new CGI_HTML_Map;
        
        $cgi_HTML->set_CGI($this->{cgi});   
        $cgi_HTML->set_HTML_Code($this->{html_content});
        $cgi_HTML->set_Escape_HTML_Tag(1); ### can be 0 or 1

        my $content = $cgi_HTML->get_HTML_Code;
        
        $this->add_Content($content);
    }
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
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

sub refine_Saved_Content {
    my $this = shift @_;
    
    my $content = shift @_;
    
    return $content;
}

1;