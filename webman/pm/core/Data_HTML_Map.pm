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

package Data_HTML_Map;


sub new {
    my $class = shift;
    my $this = {};
    
    $this->{cgi} = undef;
    $this->{cgi_var_name} = undef;
    $this->{HTML_Code} = undef;
    $this->{special_tag_view} = 0;
    
    bless $this, $class;
    return $this;
}

sub set_CGI {
    $this = shift @_;
    
    $this->{cgi} = shift @_;
}

sub set_CGI_Var_Name { ### 17/01/2006
    $this = shift @_;
    
    $this->{cgi_var_name} = shift @_;
}

sub set_Hash_Var_Map { ### 17/01/2006
    $this = shift @_;
    
    $this->{hash_var_map} = shift @_; ### accept anonymous hash
}

sub set_HTML_Code {
    $this = shift @_;
    
    $this->{HTML_Code} = shift @_;
}

sub set_Special_Tag_View { ### 30/08/2005
    $this = shift @_;
    $this->{special_tag_view} = shift @_;
}

sub get_HTML_Code {
    $this = shift @_;
    
    my $cgi = $this->{cgi};
    my $this_HTML_Code = $this->{HTML_Code};
    
    my @var_Name = undef;
    
    ### 17/01/2006
    if ($this->{cgi_var_name} eq "") {
        @var_Name = $cgi->var_Name;
    } else {
        @var_Name = split(/ /, $this->{cgi_var_name});
    }
    
    ### sort variable name from the longest to the shortest
    ### to prevent the similar shortest variable name get to
    ### substituted first
    
    my $stop = 0;
    
    while (!$stop) { ### 10/12/2010
        $stop = 1;
        
        for (my $i = 0; $i < @var_Name - 1; $i++) {
            if (length($var_Name[$i]) < length($var_Name[$i + 1])) {
                my $temp = $var_Name[$i];
                
                $var_Name[$i] = $var_Name[$i + 1];
                $var_Name[$i + 1] = $temp;
                
                $stop = 0;
            }
        }
    }
    
    ###########################################################################
    
    #$cgi->add_Debug_Text("\$this->{special_tag_view} = $this->{special_tag_view}", __FILE__, __LINE__, "TRACING");
    
    for ($i = 0; $i < @var_Name; $i++) {
        #print "\$var_Name[$i] = $var_Name[$i]<br>";
        
        $value = $cgi->param($var_Name[$i]);
        
        #$cgi->add_Debug_Text("\$value = $value", __FILE__, __LINE__, "TRACING");
        
        if ($this->{special_tag_view}) {
            $value =~ s/&/&amp;/g;
            $value =~ s/</&lt;/g;
            $value =~ s/>/&gt;/g;
            $value =~ s/"/&quot;/g; ### "
            $value =~ s/‘/&lsquo;/g;
            $value =~ s/’/&rsquo;/g;
            $value =~ s/“/&ldquo;/g;
            $value =~ s/”/&rdquo;/g;
        }
        
        if ($var_Name[$i] =~ /\$/) {
            $var_Name[$i] =~ s/\$//;
            $this_HTML_Code =~ s/\$\b$var_Name[$i]_\b/$value/g;
            
        } else {
            $this_HTML_Code =~ s/\b$var_Name[$i]_\b/$value/g;
        }
        
        #$str .= "$var_Name[$i] = $value \| ";
    }
    
    #$this_HTML_Code .= $str;
    
    return $this_HTML_Code;
}


1;