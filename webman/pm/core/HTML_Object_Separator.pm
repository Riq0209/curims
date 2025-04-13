###########################################################################################

# GMM_CGI_Lib Pre-Release 5

# This library intended to be released under GNU General Public License. 
# Please visit http://www.gnu.org/ or contact the author for more info 
# about copied and disribution of this library.

# Copyright 2002-2005, Mohd Razak bin Samingan

# Faculty of Computer Science & Information System,
# 81310 UTM Skudai,
# Johor, MALAYSIA.

# e-mail: mrazak@fsksm.utm.my

###########################################################################################

package HTML_Object_Separator;

require ("HTML_Object.pm");

sub new {
	my $type = shift;
	
	my $this = {};
	
	$this->{caller_cgi_get_data} = undef;
	
	$this->{doc_file_name} = undef;
	
	$this->{doc_content} = undef;
	$this->{doc_content_blob_prefered} = undef;
	
	$this->{html_object} = undef;
	$this->{html_object_blob_prefered} = undef;
	
	$this->{owner_entity_id} = undef;
	$this->{owner_entity_name} = undef;
	
	$this->{embedded_main_template} = 1;
	
	$this->{blob_printer_script} = undef;
	
	$this->{cgi_get_data} = undef;
	
	bless $this, $type;
	
	return $this;
}

sub reset {
	my $this = shift @_;
	
	$this->{caller_cgi_get_data} = undef;
	
	$this->{doc_file_name} = undef;
	
	$this->{doc_content} = undef;
	$this->{doc_content_blob_prefered} = undef;
	
	$this->{html_object} = undef;
	$this->{html_object_blob_prefered} = undef;
	
	$this->{owner_entity_id} = undef;
	$this->{owner_entity_name} = undef;
	
	$this->{embedded_main_template} = 1;
	
	$this->{blob_printer_script} = undef;
	
	$this->{cgi_get_data} = undef;
}

sub set_Caller_CGI_GET_Data {
	my $this = shift @_;
	
	$this->{caller_cgi_get_data} = shift @_;
}

sub set_Owner_Entity {
	my $this = shift @_;
	
	$this->{owner_entity_id} = shift @_;
	$this->{owner_entity_name} = shift @_;
}

sub set_Doc_File_Name { 
	my $this = shift @_;
	
	$this->{doc_file_name} = shift @_;
}

sub set_Doc_Content { 
	my $this = shift @_;
	
	$this->{doc_content} = shift @_;
	
	$this->{doc_content} =~ s/<img /<IMG /ig;
	$this->{doc_content} =~ s/<a /<A /ig;
	$this->{doc_content} =~ s/<area /<AREA /ig;

	$this->{doc_content} =~ s/href=/HREF=/ig;
	$this->{doc_content} =~ s/src=/SRC=/ig;
	
	$this->{doc_content_blob_prefered} = $this->{doc_content};
}

sub set_Embedded_To_Main_Template {
	my $this = shift @_;
	
	$this->{embedded_main_template} = shift @_;
}

sub set_BLOB_Printer_Script {
	my $this = shift @_;
	
	$this->{blob_printer_script} = shift @_;
}

sub set_CGI_Get_Data {
	my $this = shift @_;
	
	$this->{cgi_get_data} = shift @_;
}

sub add_CGI_Get_Data {
	my $this = shift @_;
	
	my $cgi_get_data = shift @_;
	
	if ($this->{cgi_get_data} eq undef) {
		$this->{cgi_get_data} = $cgi_get_data;
	} else {
		$this->{cgi_get_data} .= "&" . $cgi_get_data;
	}
}

sub get_HTML_Object {
	my $this = shift @_;
	
	if ($this->{blob_printer_script} eq undef) {
		$this->{blob_printer_script} = "web_man_blob_content_printer.cgi";
	}
	
	my $printer_script = $this->{blob_printer_script};
	
	if ($this->{doc_file_name} ne "") {
		
		$this->{doc_content} = "";
		
		my $file_name = $this->{doc_file_name};
		
		my $line = undef;
		
		if (open(MYFILE, "<$file_name")) {
			my @file_content = <MYFILE>;
			
			foreach $line (@file_content) {
				$this->{doc_content} .= $line;
			}
			
			$this->{doc_content} =~ s/<img /<IMG /ig;
			$this->{doc_content} =~ s/<a /<A /ig;
			$this->{doc_content} =~ s/<area /<AREA /ig;
			
			$this->{doc_content} =~ s/href=/HREF=/ig;
			$this->{doc_content} =~ s/src=/SRC=/ig;
			
			$this->{doc_content_blob_prefered} = $this->{doc_content};
		}
	}
	
	my @html_objects = new HTML_Object;
	
	my ($obj_start_location, $obj_end_location) = undef;
	
	my $obj_counter = 0;
	my $obj_type_counter = 0;
	my $obj_code = undef;
	my $temp_content = undef;
	
	
	### detect image object #######################################################
	
	$temp_content = $this->{doc_content};
	
	while ($temp_content =~ /<IMG /) {
		$obj_start_location = index($temp_content, "<IMG ");
		
		$temp_content = substr($temp_content, $obj_start_location, length($temp_content));
		
		$obj_end_location = index($temp_content, ">");
		
		$obj_code = substr($temp_content, 0, $obj_end_location + 1);
		
		if ($obj_end_location > 0) {
			#print "obj_code = $obj_code<br>\n";
			
			$html_objects[$obj_counter] = new HTML_Object;
			
			$html_objects[$obj_counter]->set_Object_Type_Num($obj_type_counter);
			$html_objects[$obj_counter]->set_Object_Type("IMAGE");
			$html_objects[$obj_counter]->set_Object_Type_Code($obj_code);
			
			$obj_counter++;
			$obj_type_counter++;
		}
		
		$temp_content = substr($temp_content, $obj_end_location, length($temp_content));
	}
	
	### detect background image object ####################################################### ### 01/06/2005
	
	$temp_content = $this->{doc_content};
		
	while ($temp_content =~ /</) {
		$obj_start_location = index($temp_content, "<");
		
		$temp_content = substr($temp_content, $obj_start_location, length($temp_content));
		
		$obj_end_location = index($temp_content, ">");
		
		$obj_code = substr($temp_content, 0, $obj_end_location + 1);
		
		$obj_code =~ s/background/BACKGROUND/ig;
		
		if ($obj_end_location > 0 && $obj_code =~ /BACKGROUND/) {
			
			#print "obj_code = $obj_code<br>\n";
			
			$html_objects[$obj_counter] = new HTML_Object;
			
			$html_objects[$obj_counter]->set_Object_Type_Num($obj_type_counter);
			$html_objects[$obj_counter]->set_Object_Type("IMAGE");
			$html_objects[$obj_counter]->set_Object_Type_Code($obj_code);
			
			$obj_counter++;
			$obj_type_counter++;
		}
		
		$temp_content = substr($temp_content, $obj_end_location, length($temp_content));
	}
	
	### detect link object ##########################################################
	
	$temp_content = $this->{doc_content};
	
	$obj_type_counter = 0;
	
	while ($temp_content =~ /<A /) {
		$obj_start_location = index($temp_content, "<A ");
		
		$temp_content = substr($temp_content, $obj_start_location, length($temp_content));
		
		$obj_end_location = index($temp_content, ">");
		
		$obj_code = substr($temp_content, 0, $obj_end_location + 1);
		
		if ($obj_end_location > 0) {
			#print "obj_code = $obj_code<br>\n";

			$html_objects[$obj_counter] = new HTML_Object;

			$html_objects[$obj_counter]->set_Object_Type_Num($obj_type_counter);
			$html_objects[$obj_counter]->set_Object_Type("LINK");
			$html_objects[$obj_counter]->set_Object_Type_Code($obj_code);

			$obj_counter++;
			$obj_type_counter++;
		}
				
		$temp_content = substr($temp_content, $obj_end_location, length($temp_content));
	}
	
	
	
	### detect link object (image map) ##############################################
	
	$temp_content = $this->{doc_content};
	
	### $obj_type_counter = 0; ### this is not required (just continue as a link object as above)
	
	while ($temp_content =~ /<AREA /) {
		$obj_start_location = index($temp_content, "<AREA ");
		
		$temp_content = substr($temp_content, $obj_start_location, length($temp_content));
		
		$obj_end_location = index($temp_content, ">");
		
		$obj_code = substr($temp_content, 0, $obj_end_location + 1);
		
		if ($obj_end_location > 0) {
			#print "obj_code = $obj_code<br>\n";

			$html_objects[$obj_counter] = new HTML_Object;

			$html_objects[$obj_counter]->set_Object_Type_Num($obj_type_counter);
			$html_objects[$obj_counter]->set_Object_Type("LINK");
			$html_objects[$obj_counter]->set_Object_Type_Code($obj_code);

			$obj_counter++;
			$obj_type_counter++;
		}
		
		$temp_content = substr($temp_content, $obj_end_location, length($temp_content));
	}
	
	
	
	### get blob prefered  HTML object ##############################################
	
	my @html_objects_blob_prefered = undef;
	
	#print "\$obj_counter = $obj_counter<br>\n";
	
	if ($obj_counter > 0) {
	
		my ($temp_obj_code, $temp_obj_ref) = undef;
		my ($filename, @fn_info) = undef;
	
		$obj_counter = 0;
		
		#print "\$#html_objects = $#html_objects<br>";

		for ($i = 0; $i < @html_objects; $i++) {
			#print "ref. name = " . $html_objects[$i]->get_Object_Reference_Name . "<br>";
			
			if (($html_objects[$i]->is_CGI_Application && !$html_objects[$i]->is_Embedded_BLOB) ||
			    $html_objects[$i]->get_Object_Reference_Location =~ /http:/ || 
			    $html_objects[$i]->get_Object_Reference_Name eq "" ||
			    $html_objects[$i]->get_Object_Reference_Name =~ /mailto:/ ||
			    length($html_objects[$i]->get_Object_Reference_Name) < 3) {

			    	#print "# do nothing -> " . $html_objects[$i]->get_Object_Reference_Name . "<br>";

			} else {
				#print "# add as blob prefered -> " . $html_objects[$i]->get_Object_Reference_Name . "<br>";
				
				$html_objects_blob_prefered[$obj_counter] = $html_objects[$i];
				
				################################################################
				
				$temp_obj_code = $html_objects[$i]->get_Object_Type_Code;
					
				$temp_obj_ref  = $html_objects[$i]->get_Object_Reference_Location;
				$temp_obj_ref .= $html_objects[$i]->get_Object_Reference_Name;

				$filename = $html_objects[$i]->get_Object_Reference_Name;
				@fn_info = split(/\./, $filename);

				if (!($temp_obj_code =~ /\.\//)) {
					$temp_obj_ref =~ s/\.\///;
				}
				
				$temp_obj_ref =~ s/\|/\\\|/g; ### 19/07/2005
				
				#print "\$temp_obj_ref = $temp_obj_ref <br>";
				
				my $cgi_get_data = $this->{cgi_get_data};
				
				$cgi_get_data .= "&" . "filename=$fn_info[0]&extension=$fn_info[1]";
				
				if ($this->{owner_entity_id} ne undef) {
					$cgi_get_data .= "&" . "owner_entity_id=" . $this->{owner_entity_id};
				}
				
				if ($this->{owner_entity_name} ne undef) {
					$cgi_get_data .= "&" . "owner_entity_name=" . $this->{owner_entity_name};
				}
				
				#print "HTML_Object_Separator \$cgi_get_data = $cgi_get_data <br>";
				
				if ($html_objects[$i]->get_Object_Type eq "IMAGE") {
					$this->{doc_content_blob_prefered} =~ s/$temp_obj_ref/\.\/$printer_script?$cgi_get_data/;
					
				} elsif ($html_objects[$i]->get_Object_Type eq "LINK") {
					$temp_obj_code =~ s/target="_blank">/target="_BLANK">/ig;
					
					$this->{doc_content_blob_prefered} =~ s/target="_blank">/target="_BLANK">/ig;
					
					if ($temp_obj_code =~ /_BLANK/) {
						$this->{doc_content_blob_prefered} =~ s/$temp_obj_ref/\.\/$printer_script?$cgi_get_data/;
						
					} else {
						if ($this->{embedded_main_template}) {
							$this->{doc_content_blob_prefered} =~ s/$temp_obj_ref/\.\/index.cgi?$this->{caller_cgi_get_data}&$cgi_get_data/;
							
						} else {
							$this->{doc_content_blob_prefered} =~ s/$temp_obj_ref/\.\/$printer_script?$cgi_get_data/;
						}
					}
				}
				
				$obj_counter++;
			}
		}
		
		if ($obj_counter > 0) {
			$this->{html_object_blob_prefered} = \@html_objects_blob_prefered;
		} else {
			$this->{html_object_blob_prefered} = undef;
		}
	
		$this->{html_object} = \@html_objects;
	
		return @html_objects;
	} else {
		return undef;
	}
}

sub get_HTML_Object_BLOB_Prefered {
	my $this = shift @_;
	
	if ($this->{html_object_blob_prefered} eq undef) {
		$this->get_HTML_Object;
	}
	
	my $array_ref = $this->{html_object_blob_prefered};
	
	return @{$array_ref};
}

sub get_Doc_Content_BLOB_Prefered {
	my $this = shift @_;
	
	if ($this->{html_object_blob_prefered} eq undef) {
		$this->get_HTML_Object;
	}
	
	return $this->{doc_content_blob_prefered};
}

sub not_CGI_Application {
	my $this = shift @_;
	
	my $obj_code = shift @_;
	
	if ($obj_code =~ /.cgi/ || $obj_code =~ /pl/ || $obj_code =~ /.php/ ||
	    $obj_code =~ /.jsp/ || $obj_code =~ /.asp/ || $obj_code =~ /.cfm/) {
		
		return 0;
		
	} else {
		return 1;
	}
}

sub is_CGI_Application { ### 20/06/2005
	my $this = shift @_;
	
	my $obj_code = shift @_;
	
	if ($obj_code =~ /.cgi/ || $obj_code =~ /pl/ || $obj_code =~ /.php/ ||
	    $obj_code =~ /.jsp/ || $obj_code =~ /.asp/ || $obj_code =~ /.cfm/) {
		
		return 1;
		
	} else {
		return 0;
	}
}

sub is_Embedded_BLOB { ### 20/06/2005
	my $this = shift @_;
		
	my $obj_code = $this->{object_type_code};
	
	if ($obj_code =~ /index\.cgi/ && 
	    $obj_code =~ /filename=/ && $obj_code =~ /extension=/ &&
	    $obj_code =~ /owner_entity_id=/ && $obj_code =~ /owner_entity_name=/) {
	    
	    return 1;
	    
	} else {
		return 0;
	}
}

1;