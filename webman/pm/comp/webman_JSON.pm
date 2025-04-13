package webman_JSON;

use webman_CGI_component;

@ISA=("webman_CGI_component");

use JSON;

sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{sql} = undef;
    
    
    ### 08/09/2024
    ### Limit the specific client resource that can access the 
    ### service's entity. For example, if the entity intendend to only 
    ### be accessed from 
    ### 'http://web.fc.utm.my/viewuser.html?entity=user&id=123' or 
    ### 'http://web1.fc.utm.my/viewuser.html?entity=user&id=123', 
    ### possibly the 'http_referer_limit' can be set to 'fc.utm.my'
    $this->{http_referer_limit} = undef;
    
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

sub set_SQL {
    my $this = shift @_;
    
    my $sql = shift @_;
    
    $this->{sql} = $sql;
}

sub get_Session_ID {
    my $this = shift @_;
    
    return $this->{session_id};
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
    
    $this->{json} = new JSON;
    
    $this->{json}->indent([1]);
    $this->{json}->allow_blessed([1]);
    $this->{json}->convert_blessed([1]);
    
    $this->SUPER::run_Task();
    
    my $sql = $this->{sql};
    
    my @cgi_var = $cgi->var_Name;
    
    my $pattern = undef;
    my $replacement = undef;
    
    for (my $i = 0; $i < @cgi_var; $i++) {
        $pattern = "cgi_" . $cgi_var[$i] . "_";
        
        $replacement = $cgi->param($cgi_var[$i]); 
        
        #print "$pattern : $replacement <br>";
        
        $sql =~ s/\$\b$pattern\b/$replacement/g;
    }
    
    $this->{sql} = $sql;
    $this->{sql} = $this->customize_SQL;
    
    #$cgi->add_Debug_Text($this->{sql}, __FILE__, __LINE__);
    
    $this->run_DB_Operation($this->{sql});    
    
    $this->{content_json} = $this->encode_JSON_Text($this->{json_hash_ref});
    $this->{session_id} = $cgi->param("session_id");
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ### prevent warning on template file
    $this->set_Template_File("template_default.html"); 
    
    $this->SUPER::process_Content;  
}

sub customize_SQL {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    #$sql = ...;
    
    return $sql;
}

sub run_DB_Operation {
    my $this = shift @_;

    my $sql = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->{db_error} = undef;
    
    #print "\$sql = $sql\n";
    
    my $sth = $this->{db_conn}->prepare($sql);
    if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
    
    $sth->execute;
    if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
    
    if (!defined($this->{dbopr_idx})) {
        $this->{dbopr_idx} = 0;
        $this->{json_hash_ref} = [{sql => $sql, error => $this->{db_error}, list => []}];
    } else {
        $this->{dbopr_idx}++;
        push(@{$this->{json_hash_ref}}, {sql => $sql, error => $this->{db_error}, list => []});
    }
    
    if (!defined($this->{db_error})) {
        while ($row = $sth->fetchrow_hashref) {
            push(@{$this->{json_hash_ref}->[$this->{dbopr_idx}]->{list}}, $row); 
        }
    }
    
    $sth->finish;
}

sub decode_JSON_Text {
    my $this = shift @_;
    
    my $json_text = shift @_;

    my $list_ref = $this->{json}->decode($json_text);
    
    return $list_ref;
}

sub encode_JSON_Text {
    my $this = shift @_;
    
    my $list_ref = shift @_;
    
    my $json_text = $this->{json}->encode($list_ref);
    
    return $json_text;
}

sub get_Content_JSON {
    my $this = shift @_;
    
    return $this->{content_json};
}

1;
