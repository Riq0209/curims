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

package DB_HTML_Map;

sub new {
	my $class = shift;
	my $this = {};
	
	this->{result} = shift @_;
	this->{HTML_Code} = shift @_;
	
	bless $this, $class;
	return $this;
}

sub set_Result {
	$this = shift @_;
	this->{result} = shift @_;
}

sub set_HTML_Code {
	$this = shift @_;
	this->{HTML_Code} = shift @_;
}

sub get_HTML_Code {
        $this_content = "";
	$this_result = this->{result};
	$this_HTML_Code = this->{HTML_Code};
	
	
	$ntuples = $this_result->ntuples;
	
	if ($ntuples < 1) {
		return $this_HTML_Code;
	}
	
	@fname = ("");
	$nfields = $this_result->nfields;
	
	for ($i = 0; $i < $nfields; $i++) {
		$fname[$i] = $this_result->fname($i);
	}
	
	while (@data = $this_result->fetchrow) {
	
		$temp = $this_HTML_Code;
		
		for ($i = 0; $i < @data; $i++) {
			$pattern = "db_$fname[$i]_";
			$data[$i] =~ s/\n/<br>/g;
			$temp =~ s/\$\b$pattern\b/$data[$i]/g; 
		}
		
		$this_content .= $temp;
	}
	
	
	return $this_content;
}

1;