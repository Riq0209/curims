package webman_user_agent;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use LWP::UserAgent;
use HTML::LinkExtor;

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{base_url} = undef;
    $this->{file_name} = undef;
    
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
    
    my $template_file = shift @_;
    
    $this->{template_default} = $template_file;
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
    
    ###########################################################################
    
    $cgi->add_Debug_Text($cgi->get_Cookie_Val("\$ua_initial_cgi_vars"), __FILE__, __LINE__, "TRACING");
    
    if ($cgi->param("\$ua_file_name") ne "") { ### indicate that the User Agent (UA) is called from
                                               ### external resource content modified by the UA itself
        $this->{file_name} = $cgi->param("\$ua_file_name");
        
        my %initial_cgi_vars_dict = ();
        my @initial_cgi_vars = split(/ /, $cgi->get_Cookie_Val("\$ua_initial_cgi_vars"));

        foreach my $var (@initial_cgi_vars) {
            $initial_cgi_vars_dict{$var} = 1;
        }
        
        my $excluded_cgi_vars = "\$ua_file_name";
        my @cgi_var_list = $cgi->var_Name;

        foreach my $var (@cgi_var_list) {
            if (!$initial_cgi_vars_dict{$var}) {
                $excluded_cgi_vars .= " $var";
            }
        }        
        
        $cgi->exclude_DB_Cache_Var($excluded_cgi_vars);
        
    } else { ### UA is called via the content that come internally from the webman framework
        my $cgi_vars_str = undef;
        my @cgi_var_list = $cgi->var_Name;

        foreach my $var (@cgi_var_list) {
            $cgi_vars_str .= "$var ";
        }
        
        $cgi->set_Cookie("\$ua_initial_cgi_vars", $cgi_vars_str);
    }
    
    ###########################################################################
    
    $this->{full_url} = $this->{base_url};
    $this->{full_url} =~ s/\/$//;
    
    $this->{full_url} .= "/" . $this->{file_name};
    
    my $ua = new LWP::UserAgent;
    
    #$ua->cookie_jar({});
    
    my $response = undef;
    
    if ($cgi->request_Method eq "GET") {
        $response = $ua->get($this->{full_url});
        
    } elsif ($cgi->request_Method eq "POST") {
        my %form_data = ();
        my @cgi_var_list = $cgi->var_Name;

        foreach my $var (@cgi_var_list) {
            $form_data{$var} = $cgi->param($var);
        }    
        
        $response = $ua->post($this->{full_url}, \%form_data);
    }
    
    $this->{response_content} = $response->content;
    
    ###########################################################################
    
    my @links_form_action = ();
    my @links_form_action2 = ();
    my @links_a_href = ();
    
    my $link_parser = new HTML::LinkExtor;
    
    $link_parser->parse($this->{response_content});
    my @links = $link_parser->links;
    $this->{content_links} = \@links;
    
    $this->{link_info} = "";
    
    foreach my $link (@links) {
        $this->{link_info} .= "$link->[0] - $link->[1] - $link->[2]<br>\n";
        
        if ($link->[0] eq "form" && $link->[1] eq "action") {
            push(@links_form_action, $link->[2]);
            push(@links_form_action2, $link->[2]);
            
        } elsif ($link->[0] eq "a" && $link->[1] eq "href") {
            push(@links_a_href, $link->[2]);
        }
    }      
    
    ###########################################################################
    
    $this->{response_content_filtered} = undef;
    
    my $tex = new Template_Element_Extractor;
    $tex->set_Doc_Content($this->{response_content});
    my @te_list = $tex->get_Template_Element;
    
    foreach my $te (@te_list) {
        if ($te->get_Type eq "VIEW") {
            my $te_content = $te->get_Content;
            
            $this->{response_content_filtered} .= $te_content;
            
        } elsif ($te->get_Type eq "DYNAMIC" and $te->get_Name eq "form_hidden_field") {
            $this->{response_content_filtered} .= $cgi->generate_Hidden_POST_Data("link_id") . "\n";
            $this->{response_content_filtered} .= "<input type=\"hidden\" name=\"\$ua_file_name\" value=\"__ua_file_name__\">\n";
        }
    }  
    
    ###########################################################################
    
    $this->{response_content_modified} = undef;
    
    my $get_data = $cgi->generate_GET_Data("link_id");
    
    my @content_lines = split(/\n/, $this->{response_content_filtered});
    
    foreach my $line (@content_lines) {
        
        if ($line =~ / action=/i) {
            my $link_rsc = shift(@links_form_action);
            $line =~ s/$link_rsc/index.cgi/g;
        }
        
        if ($line =~ /__ua_file_name__/) {
            my $link_rsc = shift(@links_form_action2);
            $line =~ s/__ua_file_name__/$link_rsc/;
        }        
        
        if ($line =~ / href=/i) {
            my $link_rsc = shift(@links_a_href);
            $link_rsc =~ s/\?.*$//;
            
            $cgi->add_Debug_Text("\$link_rsc = $link_rsc", __FILE__, __LINE__, "TRACING");
            
            $line =~ s/\?/&/;
            $line =~ s/$link_rsc/index.cgi?$get_data&\$ua_file_name=$link_rsc/g;
        }
        
        $this->{response_content_modified} .= $line;
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

sub process_DYNAMIC { ### TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_name = $te->get_Name;
    
    #$te_content = ...;
    #$te->set_Content($te_content);
    
    $this->SUPER::process_DYNAMIC($te);
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
    
    if ($te_type_name eq "default") {
        #$this->add_Content("Hello I'm from webman_user_agent.pm");
        $this->add_Content($this->{response_content_modified});
        $this->add_Content("<br>links detected:<br>\n" . $this->{link_info});
    }
}

sub process__TE_TYPE_ { ### TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_name = $te->get_Name;
    
    #$te_content = ...;
    #$te->set_Content($te_content);
    
    $this->SUPER::process__TE_TYPE_($te);
    
    #if ($this->get_Error eq "") {
    #   $this->add_Content($te_content);
        
    #} else {
    #   $this->add_Content($this->get_Error);
    #}
}

1;