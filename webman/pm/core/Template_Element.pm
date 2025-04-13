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

package Template_Element;

sub new {
    my $this = {};
    
    $this->{type} = undef;
    $this->{content} = undef;
    $this->{type_num} = undef;
    $this->{name} = undef;
    $this->{has_nested} = undef;
    $this->{nested} = undef;
    
    bless $this;
    
    return $this;
}

sub set_Type {
    my $this = shift;
    
    $this->{type} = shift;
}

sub set_Content {
    my $this = shift;
    
    $this->{content} = shift;
}

sub set_Type_Num {
    my $this = shift;
    
    $this->{type_num} = shift;
}

sub set_Name {
    my $this = shift;
    
    $this->{name} = shift;
}

sub get_Type {
    my $this = shift;
    
    return $this->{type};
}

sub get_Content {
    my $this = shift;
    
    return $this->{content};
}

sub get_Type_Num {
    my $this = shift;
    
    return $this->{type_num};
}

sub get_Name {
    my $this = shift;
    
    return $this->{name};
}

1;