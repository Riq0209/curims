package web_man_admin_content_uploader;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

my %ext_mime = ("doc"=>"application/msword", "class"=>"application/octet-stream",
                "pdf"=>"application/pdf", "xls"=>"application/vnd.ms-excel", 
                "ppt"=>"application/vnd.ms-powerpoint", "swf"=>"application/x-shockwave-flash",
                "zip"=>"application/zip", "gif"=>"image/gif", "jpg"=>"image/jpeg", "png"=>"image/png",
                "htm"=>"text/html", "html"=>"text/html", "txt"=>"text/plain", "mpg"=>"video/mpeg");

sub new {
    my $type = shift;
        
    my $this = CGI_Component->new();
    
    $this->{owner_entity_id} = undef;
    $this->{owner_entity_name} = undef;
    $this->{exceptional_db_fields} = undef;
    $this->{root_blob_id} = undef;
    $this->{embedded_main_template} = 1;
    
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

sub run_Task {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }    
    
    my $time_ISO = $this->get_Time_ISO;
    my $today_ISO = $this->get_Today_ISO;
    
    my @file_name = $cgi->upl_File_Name;
    my @file_content = $cgi->upl_File_Content;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    my $root_filename_blob_id = $cgi->param("root_filename_blob_id");
    
    my $link_id = $cgi->param("child_link_id");
    
    my $num_of_files = @file_name;
    
    #print "<p>file_name = $file_name[0]</p>";
    
    my $dbu = new DB_Utilities;
    $dbu->set_DBI_Conn($db_conn);
    
    my $htmldb = new HTML_DB_Map;
    $htmldb->set_CGI($cgi);
    $htmldb->set_DBI_Conn($db_conn);
    
    my $i = 0;
    my $blob_id = undef;
    my $exist = undef;
    my @file_name_ext = undef;
    my $link_name = undef;
    
    my $htmlos = new HTML_Object_Separator;

    for ($i = 0; $i < $num_of_files; $i++) {
        $exist = 1;

        while ($exist) {
            $rn1 = int rand 9; $rn2 = int rand 10;
            $rn3 = int rand 10; $rn4 = int rand 10;

            $rn1 = $rn1 + 1;

            $blob_id = $rn1 . $rn2 . $rn3 . $rn4;
            
            $dbu->set_Table($pre_table_name . "blob_info");
            
            $exist = $dbu->find_Item("blob_id", "$blob_id");
        }

        if ($this->{owner_entity_id} ne "" && $this->{owner_entity_name} ne "" &&
            $file_name[$i] ne "" && $file_content[$i] ne "") {
                
            @file_name_ext = split(/\./,$file_name[$i]);
            
            if ($file_name_ext[1] eq "html" || $file_name_ext[1] eq "htm") {
                
                $dbu->set_Table($pre_table_name . "link_structure");
                $link_name = $dbu->get_Item("name", "link_id", $link_id);
                $link_name =~ s/ /+/g;
                $link_name =~ s/&/\%26/g;
                
                $htmlos->set_Caller_CGI_GET_Data("session_id=\$cgi_session_id_&link_name=$link_name&link_id=$link_id&dmisn=1");
                $htmlos->set_Owner_Entity($this->{owner_entity_id}, $this->{owner_entity_name});
                $htmlos->set_Doc_Content($file_content[$i]);
                $htmlos->set_Embedded_To_Main_Template($this->{embedded_main_template});
                $htmlos->add_CGI_Get_Data("app_name=" . $cgi->param("app_name"));
                
                $file_content[$i] = $htmlos->get_Doc_Content_BLOB_Prefered;
                
                $this->{root_blob_id} .= "$file_name[$i]=$blob_id ";
                
                $htmlos->reset;
            }
            

            if (!$cgi->set_Param_Val("\$db_blob_id", $blob_id)) { $cgi->add_Param("\$db_blob_id", $blob_id); }

            if (!$cgi->set_Param_Val("\$db_filename", $file_name_ext[0])) { $cgi->add_Param("\$db_filename", $file_name_ext[0]); }
            if (!$cgi->set_Param_Val("\$db_extension", $file_name_ext[1])) { $cgi->add_Param("\$db_extension", $file_name_ext[1]); }

            if (!$cgi->set_Param_Val("\$db_upload_time", $time_ISO)) { $cgi->add_Param("\$db_upload_time", $time_ISO); }
            if (!$cgi->set_Param_Val("\$db_upload_date", $today_ISO)) { $cgi->add_Param("\$db_upload_date", $today_ISO); }

            if (!$cgi->set_Param_Val("\$db_mime_type", $ext_mime{$file_name_ext[1]})) { $cgi->add_Param("\$db_mime_type", $ext_mime{$file_name_ext[1]}); }

            if (!$cgi->set_Param_Val("\$db_owner_entity_id", $this->{owner_entity_id})) { $cgi->add_Param("\$db_owner_entity_id", $this->{owner_entity_id}); }
            if (!$cgi->set_Param_Val("\$db_owner_entity_name", $this->{owner_entity_name})) { $cgi->add_Param("\$db_owner_entity_name", $this->{owner_entity_name}); }

            if (!$cgi->set_Param_Val("\$db_content", $file_content[$i])) { $cgi->add_Param("\$db_content", $file_content[$i]); }
            
            #print "<p>Try run task </p><pre>$blob_id - $file_name_ext[0] - $file_name_ext[1] - $ext_mime{$file_name_ext[1]}</pre>";
            
            #print "\$this->{owner_entity_id} = $this->{owner_entity_id} <br>";

            $htmldb->set_Table($pre_table_name . "blob_info");
            $htmldb->set_Exceptional_Fields("\$db_content " . $this->{exceptional_db_fields});
            
            #print "Ready to insert blob_info <br>";
            
            $htmldb->insert_Table;
            
            #$cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
            
            if ($htmldb->get_DB_Error_Message ne "") {
                $cgi->add_Debug_Text($htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
            }
            
            $dbu->set_Table($pre_table_name . "blob_parent_info");
            
            if ($root_filename_blob_id eq "") {
                $dbu->insert_Row("blob_id parent_blob_id", "$blob_id 0");
            } else {
                my @spliters = split(/ /, $root_filename_blob_id);
                
                my @filename_blob_id = split(/=/, $spliters[0]);
                
                $dbu->insert_Row("blob_id parent_blob_id", "$blob_id $filename_blob_id[1]");
            }

            $htmldb->set_Table($pre_table_name . "blob_content");
            $htmldb->set_Exceptional_Fields("\$db_filename \$db_extension \$db_upload_time \$db_upload_date \$db_mime_type \$db_owner_entity_id \$db_owner_entity_name " . $this->{exceptional_db_fields});
            
            #print "Ready to insert blob_icontent <br>";
            
            $htmldb->insert_Table;
            
            #$cgi->add_Debug_Text($htmldb->get_SQL, __FILE__, __LINE__, "DATABASE");
            
            if ($htmldb->get_DB_Error_Message ne "") {
                $cgi->add_Debug_Text($htmldb->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
            }                        
        }
    }
}

sub set_Owner_Entity {
    my $this = shift @_;
    
    $this->{owner_entity_id} = shift @_;
    $this->{owner_entity_name} = shift @_;
}

sub set_Exceptional_DB_Fields {
    my $this = shift @_;
    
    $this->{exceptional_db_fields} = shift @_;
}

sub set_Embedded_To_Main_Template {
    my $this = shift @_;
    
    $this->{embedded_main_template} = shift @_;
}

sub get_Root_BLOB_ID {
    my $this = shift @_;
    
    return $this->{root_blob_id};
}

1;