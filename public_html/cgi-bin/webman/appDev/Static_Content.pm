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

package Static_Content;

use Template_Element_Extractor;

sub new {
	my $class = shift;
	
	my $this = {};
	
	$this->{doc_content} = undef;
	
	bless $this, $class;
	
	return $this;
}

sub set_Doc_Content { ### 12/03/2005
	my $this = shift @_;
	
	my $doc_content = shift @_;
	
	$this->{doc_content} = $doc_content;
}

sub get_Content {
	$this = shift @_;
	
	$file_name = shift @_;
	
	my $temp_content = "";
	
	$tex = new Template_Element_Extractor;
	
	if ($file_name ne "") {
		@te = $tex->get_Template_Element($file_name);
	} else {
		$tex->set_Doc_Content($this->{doc_content});
		@te = $tex->get_Template_Element;
	}
	
	for ($i = 0; $i < @te; $i++) {
		$type = $te[$i]->get_Type;
		$content = $te[$i]->get_Content;
		
		if ($type eq "VIEW") {
			$temp_content = $temp_content . $content;
		}
		
		if ($type eq "DYNAMIC") {
			$temp_content = $temp_content . "\$DYNAMIC_CONTENT_";
		}
	}
	
	return $temp_content;
}


1;

