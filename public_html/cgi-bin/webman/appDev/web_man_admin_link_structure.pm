package web_man_admin_link_structure;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");


sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{activate_last_path} = undef;
    
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
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }     
    
    $this->SUPER::run_Task;    
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_link_structure.html");
    
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
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name");
    my $caller_get_data2 = $this->generate_GET_Data("app_name");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    if ($link_struct_id eq "") { $link_struct_id = 0; }
    
    my @link_path = undef;
    my $link_path_info = undef;
    
    if ($link_struct_id == 0) {
        $te_content =~ s/LINK_PATH_//;
        
    } else {
        $te_content =~ s/Root/<a href="index.cgi?$caller_get_data"><font color="#0099FF">Root<\/font><\/a>/;
        
        @link_path = $this->get_Link_Path;
        
        $link_path_info = $this->generate_Link_Path_Info("index.cgi", "$caller_get_data2", @link_path);
        
        $te_content =~ s/LINK_PATH_/$link_path_info/;
    }
    
    my $table_name = "webman_" . $cgi->param("app_name") . "_link_structure";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($table_name);

    my $current_sequence = $dbu->get_MAX_Item("sequence", "parent_id", $link_struct_id);
    
    if ($current_sequence eq "") {
        $current_sequence = 0;
    } else {
        $current_sequence += 1;
    }
    
    $te_content =~ s/add_/<a href="index.cgi?$caller_get_data&link_struct_id=$link_struct_id&task=add_phase1&\$db_parent_id=$link_struct_id&\$db_sequence=$current_sequence"><font color="#0099FF">Add<\/font><\/a>/g;
    
    $this->add_Content($te_content);
}

sub process_DBHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn app_name app_dir");
    
    my $link_struct_id = $cgi->param("link_struct_id");
    if ($link_struct_id eq "") { $link_struct_id = 0; }
    
    my $script_ref = "index.cgi?$caller_get_data";
    my $script_ref2 = "index.cgi?$caller_get_data&link_struct_id=$link_struct_id";
    
    my $table_link_structure = "webman_" . $cgi->param("app_name") . "_link_structure";
    my $table_link_reference = "webman_" . $cgi->param("app_name") . "_link_reference";
    
    my $dbihtml = new DBI_HTML_Map;
    
    $dbihtml->set_DBI_Conn($db_conn);
    $dbihtml->set_SQL("select * from $table_link_structure where parent_id='$link_struct_id' order by sequence");
    $dbihtml->set_HTML_Code($te_content);
    
    $te_content = $dbihtml->get_HTML_Code;
    
    my $db_items_num = $dbihtml->get_Items_Num;
    
    my $sth = $db_conn->prepare("select name, link_id from $table_link_structure where parent_id='$link_struct_id' order by sequence");
    
    $sth->execute;
    
    my $dbu = new DB_Utilities;
    $dbu->set_DBI_Conn($db_conn);
    
    my $link_struct_name = undef;
    my $data_hashref = undef;
    my $name_id_tag = undef;
    
    while ($data_hashref = $sth->fetchrow_hashref) {
    
        $link_struct_name = $data_hashref->{name};
        $link_struct_name =~ s/\(/\\\(/;
        $link_struct_name =~ s/\)/\\\)/;
        $link_struct_name =~ s/\?/\\\?/;
        
        $name_id_tag = "name_" . $data_hashref->{link_id};
        
        #$cgi->add_Debug_Text("\$name_id_tag = $name_id_tag", __FILE__, __LINE__);
        
        $dbu->set_Table($table_link_reference);
        
        my $ref_num = $dbu->count_Item("link_id", $data_hashref->{link_id});
        
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
            
        if ($ref_num < 10) {
            $ref_num = "0" . $ref_num;
        }
        
        $dbu->set_Table($table_link_structure);
        
        if ($dbu->find_Item("parent_id", $data_hashref->{link_id})) {
            $te_content =~ s/\$\b$name_id_tag\b/<a href="$script_ref&link_struct_id=$data_hashref->{link_id}"><font color="#0000FF">$data_hashref->{name}<\/font><\/a>/;
            $te_content =~ s/del_/del2_/;
            
        } else {
            $te_content =~ s/\$\b$name_id_tag\b/<a href="$script_ref&link_struct_id=$data_hashref->{link_id}"><font color="#0099FF">$data_hashref->{name}<\/font><\/a>/;
            $te_content =~ s/del_/<a href="$script_ref2&child_link_id=$data_hashref->{link_id}&task=delete_phase1"><font color="#0099FF">del2_<\/font><\/a>/;
        }
        
        $te_content =~ s/upd_i_/<a href="$script_ref2&child_link_id=$data_hashref->{link_id}&task=update_phase1"><font color="#0099FF">upd_i2_<\/font><\/a>/;
        $te_content =~ s/upd_r_/<a href="$script_ref2&child_link_id=$data_hashref->{link_id}&task=update_ref_phase1"><font color="#0099FF">upd_r2_<\/font><\/a> <font color="#0099FF">[$ref_num]<\/font>/;
    }
    
    $sth->finish;
    
    $te_content =~ s/upd_i2_/Update Info./g;
    $te_content =~ s/upd_r2_/Update Ref./g;
    $te_content =~ s/del2_/Delete/g;
    
    $te_content =~ s/lt_/\&lt;/g;
    $te_content =~ s/gt_/\&gt;/g;
    
    $te_content =~ s/\$caller_get_data_/$caller_get_data\&link_struct_id=$link_struct_id/g;
    
    if ($db_items_num ne "") {
        $this->add_Content($te_content);
    } else {
        $this->add_Content("");
    }
}

sub set_Activate_Last_Path {
    $this = shift @_;
    
    $this->{activate_last_path} = shift @_;
}

sub get_Link_Path {
    $this = shift @_;
    
    my $link_struct_id = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($link_struct_id eq "") {
        $link_struct_id = $cgi->param("link_struct_id");
    }
    
    my $table_name = "webman_" . $cgi->param("app_name") . "_link_structure";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($table_name);
    
    my @link_path = undef;

    my ($i, $counter, $link_name) = 0; 
    
    while ($link_struct_id > 0) {
        $link_name = $dbu->get_Item("name", "link_id", "$link_struct_id");

        $link_path[$counter] = {$link_struct_id => $link_name};

        #print "$link_struct_id => $link_name ";

        $link_struct_id = $dbu->get_Item("parent_id", "link_id", "$link_struct_id");

        $counter++;
    }

    
    if ($counter > 0) {
        my $link_path_num = @link_path;
        my @temp_link_path = undef;
        
        #print "\$link_path_num = $link_path_num ";
        
        if ($link_path_num == 1) { 
            $link_path_num = 0; 
            
        } elsif($link_path_num > 1) {
            $link_path_num -= 1;
        }
        
        $counter = 0;
        for ($i = $link_path_num; $i >= 0; $i--) {
            $temp_link_path[$counter] = $link_path[$i];
            $counter++;
        }
        
        return @temp_link_path;
        
    } else {
        return undef;
    }
    
}

sub generate_Link_Path_Info {
    $this = shift @_;
    
    my $script_name = shift @_;
    my $additional_get_data = shift @_;
    my @link_path = @_;
    
    my $caller_get_data = $this->generate_GET_Data("link_name dmisn");
    
    if ($additional_get_data ne "") {
        $caller_get_data .= "\&" . $additional_get_data;
    }
    
    my $link_path_num = @link_path;
    
    #print "\$link_path_num = $link_path_num ";
    
    if ($script_name eq "") { $script_name = "index.pl"; }
        
    my ($i, $counter, $lp, $link_path_id, $link_path_name, $link_path_name_get_fmt, $link) = undef;

    $counter = 0;
    $link = " > ";

    for ($i = 0; $i < $link_path_num; $i++) {
        ($link_struct_id, $link_path_name) = %{$link_path[$i]};
        
        #print "$link_path_name = $caller_get_data <br>";
        
        $link_path_name_get_fmt = $link_path_name;
        $link_path_name_get_fmt =~ s/ /+/g;

        if ($counter < @link_path - 1) {
            $link .= "<a href=\"$script_name?link_path_name=$link_path_name_get_fmt&link_struct_id=$link_struct_id&$caller_get_data\"><font color=\"#0099FF\">$link_path_name</font></a> > ";
            
        } else {
            if ($this->{activate_last_path} == 1) {
                $link .= "<a href=\"$script_name?link_path_name=$link_path_name_get_fmt&link_struct_id=$link_struct_id&$caller_get_data\"><font color=\"#0099FF\">$link_path_name</font></a>";
                
            } else {
                $link .= "$link_path_name";
            }
            
        }

        $counter++;
    }
    
    return $link;
}

1;