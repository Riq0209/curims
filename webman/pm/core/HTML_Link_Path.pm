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

package HTML_Link_Path;

sub new {
	my $class = shift;
	my $this = {};
	
    $this->{separator_tag} = undef;
	$this->{additional_get_data} = undef;
    $this->{active_link_color} = undef;
	
	bless $this, $class;
	
	return $this;
}

sub set_CGI {
	$this = shift @_;
	
	$this->{cgi} = shift @_;
}


sub set_Captions {
	$this = shift @_;
	
	my @captions = @_;
	
	$this->{captions} = \@captions;
}

sub set_Links {
	$this = shift @_;
	
	my @links = @_;
	
	$this->{links} = \@links;
}

sub set_Links_Title {
    $this = shift @_;
    
    my @links_title = @_;
    
    $this->{links_title} = \@links_title;
}

sub set_Separator_Tag {
    $this = shift @_;
    
    $this->{separator_tag} = shift @_;
}

sub set_Additional_GET_Data {
	$this = shift @_;
	
	$this->{additional_get_data} = shift @_;
}

sub set_Active_Link_Color {
    $this = shift @_;
        
    $this->{active_link_color} = shift @_;
}

sub get_Link_Path {
    my @captions = @{$this->{captions}};
    my @links = @{$this->{links}};
    
    my $separator_tag = $this->{separator_tag};
    my $additional_get_data = $this->{additional_get_data};
    my $active_link_color = $this->{active_link_color};
    
    
    my $item = undef;
    my $count = 0;
    my $link_path = undef;
    
    foreach $item (@captions) {
        if ($links[$count] ne undef) {
            if ($active_link_color ne undef) {
                $item = "<font color=\"$active_link_color\">" . $item . "</font>";
            }
            
            $item = "<a href=\"$links[$count]$additional_get_data\">" . $item . "</a>";
        }
        
        $link_path .= $item . $separator_tag;
        
        $count++;
    }
    
    $link_path =~ s/$separator_tag$//;
    
    return $link_path;
}



1;