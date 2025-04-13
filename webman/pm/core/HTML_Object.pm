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

package HTML_Object;

my %obj_ref_type_hash = ("jpg"=>"Image", "gif"=>"Image", "png"=>"Image",
                         "doc"=>"Word Document", "ppt"=>"Power Point", "xls"=>"Excel",
                         "htm"=>"HTML Document", "html"=>"HTML Document", "txt"=>"Text File",
                         "pdf"=>"Adobe Acrobat");

sub new {
	my $type = shift @_;
	
	my $this = {};
	
	$this->{object_type} = undef;
	$this->{object_ref_type} = undef;
	$this->{object_ref_name} = undef;
	$this->{object_ref_location} = undef;
	$this->{object_type_num} = undef;
	$this->{object_type_code} = undef;
	
	bless $this, $type;
	
	return $this;
}

sub set_Object_Type {
	$this = shift @_;
	
	$this->{object_type} = shift @_;
}

sub set_Object_Reference_Name {
	$this = shift @_;
	
	$this->{object_ref_name} = shift @_;
}

sub set_Object_Type_Num {
	$this = shift @_;
	
	$this->{object_type_num} = shift @_;
}

sub set_Object_Type_Code {
	$this = shift @_;
	
	$this->{object_type_code} = shift @_;
	
	my $i = 0;
	my ($obj_ref_string, $obj_ref_location, $obj_ref_name) = undef;
	my @splited_code = undef;
	
	my $obj_code = $this->{object_type_code};
	
	my @splited_code = split(/ /, $obj_code);
	
	for ($i = 0; $i < @splited_code; $i++) {
		if ($this->{object_type} eq "IMAGE") {
		
			if ($splited_code[$i] =~ /SRC=/) {
				$obj_ref_string = $splited_code[$i];
				$obj_ref_string =~ s/SRC=//;
			}
			
			if ($splited_code[$i] =~ /BACKGROUND=/) { ### 01/06/2005
				$obj_ref_string = $splited_code[$i];
				$obj_ref_string =~ s/BACKGROUND=//;
			}
			
		} elsif ($this->{object_type} eq "LINK") {
			if ($splited_code[$i] =~ /HREF=/) {
				$obj_ref_string = $splited_code[$i];
				$obj_ref_string =~ s/HREF=//;
			}
		}
	}
	
	$obj_ref_string =~ s/"//g;
	$obj_ref_string =~ s/>//g;
	$obj_ref_string =~ s/\\/\//g;
	$obj_ref_string =~ s/\/\//,,/;
	
	if ($obj_ref_string =~ /\// || $obj_ref_string =~ /,,/) {
		# do nothing
	} else {
		$obj_ref_string = "./" . $obj_ref_string;
	}
	
	@splited_code = split(/\//, $obj_ref_string);
	
	$obj_ref_name = $splited_code[@splited_code - 1];
	
	$obj_ref_location = $splited_code[0] . "/";
	
	for ($i = 1; $i < @splited_code - 1; $i++) {
		$obj_ref_location .= $splited_code[$i] . "/";
	}
	
	if ($obj_ref_name =~ /\./ && !($obj_ref_name =~ /,,/)) {
		# do nothing
	} else {
		if (!($obj_ref_name =~ /,,/)) {
			$obj_ref_location .= $obj_ref_name;
		}
		
		$obj_ref_name = "";
	}
	
	$obj_ref_location =~ s/,/\//g;
	
	if ($obj_ref_name ne "") {
		$this->{object_ref_name} = $obj_ref_name;
		
		my @file_info = split(/\./, $obj_ref_name);
		
		$this->{object_ref_type} = $obj_ref_type_hash{$file_info[1]}; 
	}
	
	$this->{object_ref_location} = $obj_ref_location;
}

sub get_Object_Type {
	$this = shift @_;
	
	return $this->{object_type};
}

sub get_Object_Reference_Type {
	$this = shift @_;
	
	return $this->{object_ref_type};
}

sub get_Object_Reference_Name {
	$this = shift @_;
	
	return $this->{object_ref_name};
}

sub get_Object_Reference_Location {
	$this = shift @_;
	
	return $this->{object_ref_location};
}

sub get_Object_Type_Num {
	$this = shift @_;
	
	return $this->{object_type_num};
}

sub get_Object_Type_Code {
	$this = shift @_;
	
	return $this->{object_type_code};
}

sub not_CGI_Application { ### 01/06/2005
	my $this = shift @_;
	
	my $obj_code = $this->{object_type_code};
	
	if ($obj_code =~ /\.cgi/ || $obj_code =~ /\.pl/ || $obj_code =~ /\.php/ ||
	    $obj_code =~ /\.jsp/ || $obj_code =~ /\.asp/ || $obj_code =~ /\.cfm/) {
		
		return 0;
		
	} else {
		return 1;
	}
}

sub is_CGI_Application { ### 01/06/2005
	my $this = shift @_;
	
	my $obj_code = $this->{object_type_code};
	
	if ($obj_code =~ /\.cgi/ || $obj_code =~ /\.pl/ || $obj_code =~ /\.php/ ||
	    $obj_code =~ /\.jsp/ || $obj_code =~ /\.asp/ || $obj_code =~ /\.cfm/) {
		
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
	}
	
	return 0;
}

sub get_Embedded_BLOB_Filename {
	my $this = shift @_;
	
	my $obj_ref_name = $this->{object_ref_name};
	
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

1;