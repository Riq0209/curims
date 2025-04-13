package web_man_admin_blob_content_upload;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

sub new {
    my $type = shift;
    
    my $this = CGI_Component->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{old_blob_prefered_obj} = undef;
    $this->{new_blob_prefered_obj} = undef;
    
    $this->{upload_files} = undef;
    
    $this->{owner_entity_id} = undef;
    $this->{owner_entity_name} = undef;
    
    $this->{pre_table_name} = undef;
    
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
    
    my $array_ref1 = $this->{old_blob_prefered_obj};
    my $array_ref2 = $this->{new_blob_prefered_obj};
    
    my @old_html_obj = @{$array_ref1};
    my @new_html_obj = @{$array_ref2};
    
    $this->{pre_table_name} = "webman_" . $cgi->param("app_name") . "_";
    
    my $upload_file_count = 0;
    my @upload_files = undef;
    
    my $i = 0;
    my $j = 0;
    my $found = undef;
    
    if ($old_html_obj[0] ne undef && $new_html_obj[0] ne undef) {
        
        for ($i = 0; $i < @new_html_obj; $i++) {
            
            $found = 0;
            
            for ($j = 0; $j < @old_html_obj; $j++) {
                #print $old_html_obj[$j]->get_Object_Reference_Name . ":" . $new_html_obj[$i]->get_Object_Reference_Name . "<br>";
                
                if ($old_html_obj[$j]->get_Object_Reference_Name eq $new_html_obj[$i]->get_Object_Reference_Name) {
                    $found = 1;
                }
            }
            
            if (!$found) {
                if ($this->ref_Name_Not_Exist($new_html_obj[$i]->get_Object_Reference_Name, @upload_files)) {
                    #print "upload new[$i]. " . $new_html_obj[$i]->get_Object_Reference_Name . "<br>";
                
                    $upload_files[$upload_file_count] = $new_html_obj[$i]->get_Object_Reference_Name;
                    $upload_file_count++;
                }
            }
        }
        
    } elsif ($old_html_obj[0] eq undef && $new_html_obj[0] ne undef) {
        #print "Upload all new BLOB object refer to current HTML Doc.<br>";
        
        for ($i = 0; $i < @new_html_obj; $i++) {
            if ($this->ref_Name_Not_Exist($new_html_obj[$i]->get_Object_Reference_Name, @upload_files)) {
                $upload_files[$upload_file_count] = $new_html_obj[$i]->get_Object_Reference_Name;
                $upload_file_count++;
            }
        }
    }
    
    if ($upload_file_count > 0) {
        $this->{upload_files} = \@upload_files;
    }
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->{current_blob_id} = $cgi->param("current_blob_id");
    
    $this->set_Template_File("./template_admin_blob_content_upload.html");
    
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
    
    my $hpd = $cgi->generate_Hidden_POST_Data("\$filename blob_id current_blob_id sort_link_name_old sort_field_old
                           sort_link_name sort_field cdbr_set_num_dmisn cdbr_set_num 
                           blob_content_link_name blob_content_dmisn link_name dmisn app_name");
    
    $this->add_Content($hpd);
}

sub process_DATAHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;

    my $data_HTML = new Data_HTML_Map;
    
    $data_HTML->set_CGI($cgi);
    $data_HTML->set_HTML_Code($te_content);
    
    $te_content = $data_HTML->get_HTML_Code;
    
    $this->add_Content($te_content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    if ($this->{upload_files} ne undef) {
        my $array_ref = $this->{upload_files};
        
        my @upload_files = @{$array_ref};
        
        my $tld = new Table_List_Data;
        
        $tld->add_Column("filename");
        
        my $i = 0;
        
        for ($i = 0; $i < @upload_files; $i++) {
            $tld->add_Row_Data("$upload_files[$i]");
        }
        
        my $tldhtml = new TLD_HTML_Map;
                    
        $tldhtml->set_Table_List_Data($tld);
        $tldhtml->set_HTML_Code($te_content);
                    
        my $html_result = $tldhtml->get_HTML_Code;
                    
        $this->add_Content($html_result);
    }
}

sub set_Owner_Entity {
    my $this = shift @_;
    
    $this->{owner_entity_id} = shift @_;
    $this->{owner_entity_name} = shift @_;
}

sub set_Old_BLOB_Prefered_List {
    my $this = shift @_;
    
    my @html_obj_array = @_;
    
    $this->{old_blob_prefered_obj} = \@html_obj_array;
}

sub set_New_BLOB_Prefered_List {
    my $this = shift @_;
    
    my @html_obj_array = @_;
    
    $this->{new_blob_prefered_obj} = \@html_obj_array;
}

sub get_Upload_Files {
    my $this = shift @_;
    
    if ($this->{upload_files} ne undef) {
        my $array_ref = $this->{upload_files};
        
        my @upload_files = @{$array_ref};
        
        return @upload_files;
        
    } else {
        return undef;
    }
}

sub ref_Name_Not_Exist {
    my $this = shift @_;
    
    my $ref_name = shift @_;
    my @upload_files = @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $i = 0;
    
    for ($i = 0; $i < @upload_files; $i++) {
        if ($ref_name eq $upload_files[$i]) { ### check from current upload files reference name
            return 0;
        }
    }
    
    ### next is to check inside the DB
    my $db_ref_name = undef;
    my $dbu = new DB_Utilities;
        
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table($this->{pre_table_name} . "blob_info");
    
    my @file_info = $dbu->get_Items("filename extension", "owner_entity_id owner_entity_name",
                        $this->{owner_entity_id} . " " . $this->{owner_entity_name});
                        
    for ($i = 0; $i < @file_info; $i++) {
        $db_ref_name = $file_info[$i]->{filename} . "." . $file_info[$i]->{extension};
        
        #print "$db_ref_name - $ref_name <br>";
        
        if ($ref_name eq $db_ref_name) {
            return 0;
        }
    }
    
    
    return 1;
}

1;