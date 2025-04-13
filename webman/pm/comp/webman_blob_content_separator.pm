package webman_blob_content_separator;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");

sub new {
    my $class = shift @_;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{html_blob_content} = undef;
    $this->{html_content} = undef;
    
    $this->{html_object} = undef;
    $this->{html_object_blob_prefered} = undef;
    
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
}

sub get_HTML_Code {
    my $this = shift @_;
    
    my @html_objects_blob_prefered = undef;
    my $blob_obj_count = 0;
    
    if ($this->{html_blob_content} ne undef) {
        my $htmlos = new HTML_Object_Separator;
        
        $htmlos->set_Doc_Content($this->{html_blob_content});
        
        my @html_objects = $htmlos->get_HTML_Object;
        
        my $temp_content = $this->{html_blob_content};
        
        #$temp_content =~ s/jsic_blob_content_printer.cgi\?//g;
        #$temp_content =~ s/web_man_blob_content_printer.cgi\?//g;
        
        my $i = 0; my $j = 0;
        
        my @temp_ref_name = undef;
        my $file_name = undef;
        my $ext = undef;
        my $obj_ref_name = undef;
        my $obj_ref_name_old = undef;
        
        if ($html_objects[0] ne undef) { ### always return 1 item even there is no html object exist ???
            
            $this->{html_object} = \@html_objects;
            
            for ($i = 0; $i < @html_objects; $i++) {
                $obj_ref_name_old = $html_objects[$i]->get_Object_Reference_Name;
                $obj_ref_name_old = $html_objects[$i]->get_Object_Reference_Location . $obj_ref_name_old;

                if ($obj_ref_name_old =~ /jsic_blob_content_printer.cgi/ || 
                    $obj_ref_name_old =~ /web_man_blob_content_printer.cgi/) {
                        
                        $html_objects_blob_prefered[$blob_obj_count] = $html_objects[$i];
                        $blob_obj_count++;

                    @temp_ref_name = split(/\?/, $obj_ref_name_old);

                    @temp_ref_name = split(/\&/, $temp_ref_name[1]);

                    for ($j = 0; $j < @temp_ref_name; $j++) {
                        if ($temp_ref_name[$j] =~ /filename/) {
                            $file_name = substr($temp_ref_name[$j], index($temp_ref_name[$j], "=") + 1, length($temp_content));
                        }

                        if ($temp_ref_name[$j] =~ /extension/) {
                            $ext = substr($temp_ref_name[$j], index($temp_ref_name[$j], "=") + 1, length($temp_content));
                        }
                    }

                    $obj_ref_name = $file_name . "." . $ext;

                    $obj_ref_name_old =~ s/\?/\\\?/;
                    
                    $temp_content =~ s/$obj_ref_name_old/$obj_ref_name/;

                }
                
                if ($this->is_Embedded_BLOB($obj_ref_name_old)) {
                    $html_objects_blob_prefered[$blob_obj_count] = $html_objects[$i];
                        $blob_obj_count++;
                        
                    $obj_ref_name = $this->get_Embedded_BLOB_Filename($html_objects[$i]->get_Object_Reference_Name);
                    
                    $obj_ref_name_old =~ s/\?/\\\?/;
                    $obj_ref_name_old =~ s/\+/\\\+/;
                    $obj_ref_name_old =~ s/\%/\\\%/;
                    
                    #$this->{html_content} .= "<pre>- is embedded blob " . $obj_ref_name . "-</pre>";
                    
                    $temp_content =~ s/$obj_ref_name_old/$obj_ref_name/;    
                } 
                
                
            } 
        }
        
        $this->{html_content} = $temp_content;
        
        $this->{html_object_blob_prefered} = \@html_objects_blob_prefered;
    }
    
    
    
    return $this->{html_content};
}

sub get_HTML_Object_BLOB_Prefered {
    my $this = shift @_;
    
    my $array_ref = $this->{html_object_blob_prefered};
    
    return @{$array_ref};
}

sub set_HTML_BLOB_Content {
    my $this = shift @_;
    
    $this->{html_blob_content} = shift @_;
}

sub is_Embedded_BLOB {
    my $this = shift @_;
    
    my $obj_ref_name = shift @_;
    
    if ($obj_ref_name =~ /index.cgi/ && 
        $obj_ref_name =~ /filename=/ && $obj_ref_name =~ /extension=/ &&
        $obj_ref_name =~ /owner_entity_id=/ && $obj_ref_name =~ /owner_entity_name=/) {
        
        return 1;
    }
    
    return 0;
}

sub get_Embedded_BLOB_Filename {
    my $this = shift @_;
    
    my $obj_ref_name = shift @_;
    
    my @info = split(/&/, $obj_ref_name);
    my @temp_info = undef;
    
    my $i = 0;
    my $filename = undef;
    my $ext = undef;
    
    for ($i = 0; $i < @info; $i++) {
        if ($info[$i] =~ /filename=/) {
            @temp_info = split(/=/, $info[$i]);
            $filename = $temp_info[1];
        }
        
        if ($info[$i] =~ /extension=/) {
            @temp_info = split(/=/, $info[$i]);
            $ext = $temp_info[1];
        }
    }
    
    return $filename . "." . $ext;
}