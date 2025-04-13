package web_man_admin_blob_prefered_list;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{root_doc_content} = shift @_;
    $this->{html_object_blob_prefered} = undef;
    $this->{generated_hidden_POST_data} = undef;
    $this->{hidden_POST_data} = undef;
    
    $this->{root_blob_id} = undef;
    
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
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_blob_prefered_list.html");
    
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
    
    my $link_struct_id = $cgi->param("link_struct_id");
    my $child_link_id = $cgi->param("child_link_id");
    
    $te_content =~ s/child_link_id_/$child_link_id/;
    
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
    
    my $ghpd = $this->{generated_hidden_POST_data};
    
    my $hpd = $this->generate_Hidden_POST_Data($ghpd);
    
    $hpd = $this->{hidden_POST_data} . $hpd;
    
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
    
    ###########################################################################
    
    my $app_name = $cgi->param("app_name");
    my $owner_entity_id = $cgi->param("link_ref_id");    
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table("webman_" . $app_name . "_blob_info");
    
    my @ahr = $dbu->get_Items("filename extension", "owner_entity_id owner_entity_name", 
                              "$owner_entity_id link_reference", undef, undef);
                              
    my %dict_file_from_db = undef;
    
    foreach my $item (@ahr) {
        my $filename_ext = $item->{filename} . "." . $item->{extension};
        
        $dict_file_from_db{$filename_ext} = 1;
        
        #$cgi->add_Debug_Text("\$filename_ext = $filename_ext", __FILE__, __LINE__, "TRACING"); 
    }
    
    ###########################################################################
    
    my @file_name = $cgi->upl_File_Name;
    my @file_content = $cgi->upl_File_Content;
    
    my $htmlos = new HTML_Object_Separator;
    
    my ($i, $j, $counter) = 0;
    my @file_name_info = undef;
    my (@html_obp, @all_html_obp) = undef;
    
    for ($i = 0; $i < @file_name; $i++) {
        if ($file_name[$i] ne "") {
            @file_name_info = split(/\./, $file_name[$i]);
        
            $file_name_info[@file_name_info - 1] =~ s/htm/HTM/i;
            $file_name_info[@file_name_info - 1] =~ s/l/L/i;
        
            if ($file_name_info[@file_name_info - 1] eq "HTM" ||
                $file_name_info[@file_name_info - 1] eq "HTML") {
                
                $htmlos->set_Doc_Content($file_content[$i]);
                    
                @html_obp = $htmlos->get_HTML_Object_BLOB_Prefered;
                
                for ($j = 0; $j < @html_obp; $j++) {
                    #$cgi->add_Debug_Text("\$html_obp[$j] = " . $html_obp[$j]->get_Object_Reference_Name, __FILE__, __LINE__, "TRACING");
                    
                    if (!$dict_file_from_db{$html_obp[$j]->get_Object_Reference_Name} && 
                        !$this->already_Exist_HTML_Object(\@all_html_obp, $html_obp[$j])) {
                        $all_html_obp[$counter] = $html_obp[$j];
                        $counter++;
                        
                        #$cgi->add_Debug_Text($html_obp[$j]->get_Object_Reference_Name . " is added", __FILE__, __LINE__, "TRACING");
                    }
                }
                
                @html_obp = undef;
                $htmlos->reset;
            }
        }
    }
    
    my $tld = new Table_List_Data;
        
    $tld->add_Column("num");
    $tld->add_Column("file_name");
    $tld->add_Column("file_type");
    
    for ($i = 0; $i < @all_html_obp; $i++) {
        $tld->add_Row_Data($i + 1, $all_html_obp[$i]->get_Object_Reference_Name, $all_html_obp[$i]->get_Object_Reference_Type);
    }
    
    my $tldhtml = new TLD_HTML_Map;

    $tldhtml->set_Table_List_Data($tld);
    $tldhtml->set_HTML_Code($te_content);

    my $html_result = $tldhtml->get_HTML_Code;
    
    $this->add_Content($html_result);
}

sub set_Hidden_POST_Data {
    my $this = shift @_;
    
    my $hpd_var_name = shift @_;
    my @hpd_value = @_;
    
    @hpdvn = split(/ /, $hpd_var_name);
    
    my $i = 0; 
    
    for ($i = 0; $i < @hpdvn; $i++) {
        $this->{hidden_POST_data} .= "<input type=\"hidden\" name=\"$hpdvn[$i]\" value=\"$hpd_value[$i]\">\n";
    }
}

sub set_Generated_Hidden_POST_Data {
    my $this = shift @_;
    
    my $ghpd = shift @_;
    
    $this->{generated_hidden_POST_data} = $ghpd;
}

sub already_Exist_HTML_Object {
    my $this = shift @_;
    
    my $html_obj_array_ref = shift @_;
    my $new_html_obj = shift @_;
    
    my @html_obj_array = @{$html_obj_array_ref};
    
    for (my $i = 0; $i < @html_obj_array; $i++) {
        if ($new_html_obj->get_Object_Reference_Name eq $html_obj_array[$i]->get_Object_Reference_Name) {
            return 1;
        }
    }
    
    return 0;
}

1;