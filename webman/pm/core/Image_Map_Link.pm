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

package Image_Map_Link;

use Template_Element_Extractor;

my $link_template = undef;
my $script_name = undef;

my @links = undef;

sub new {
    my $type = shift;
    
    my $this = {};
    
    $this->{additional_GET_data} = undef;
    
    bless $this, $type;
    
    return $this;
}

sub reset_Links { 
    @links = undef;
}

sub set_Link {
    my $this = shift @_;
    
    my $link = shift @_;
    my $link_index = shift @_; 
    
    $num = @links;
    
    if ($link_index eq "") { 
        if ($num == 1 and $links[0] eq "") {
            $links[0] = $menu_link;
        } else {
            $links[$num] = $link;
        }
        
    } else {
        $links[$link_index] = $link;
    }
}

sub set_Links {
    $this = shift @_;
    @links = @_;
}

sub set_Auto_Links {
    $this = shift @_;
    
    my $auto_script_name = shift @_;
    
    my $old_link_value = undef; ### 05/08/2005
    
    for ($i = 0; $i < @links; $i++) {
        $old_link_value = $links[$i];
        
        $links[$i] = "$auto_script_name?";
        
        if ($old_link_value ne "") {
            $links[$i] .= "\&$old_link_value"; ### 05/08/2005
        }
    }
}

sub add_GET_Data_Links_Source {
    $this = shift @_;
    my $new_GET_data = shift @_;
    my $link_index = shift @_; 
    
    $new_GET_data =~ s/ /\+/g;
    
    #print "\$new_GET_data = $new_GET_data <br>";
    
    $this->{additional_GET_data} .= $new_GET_data;
    
    ### 21/3/2005 ###################################################################
    
    my @splitted_get_data = split(/\&/, $new_GET_data);
    
    my $i = 0;
    $new_GET_data = "";
    
    for ($i =0; $i < @splitted_get_data; $i++) {
        if ($splitted_get_data[$i] =~ /=/) {
            $new_GET_data .= $splitted_get_data[$i] . "\&";
        } else {
            $new_GET_data = substr($new_GET_data, 0, length($new_GET_data) - 1);
            
            $new_GET_data .= "\%26" . $splitted_get_data[$i] . "\&";
        }
    }
    
    $new_GET_data = substr($new_GET_data, 0, length($new_GET_data) - 1);
    
    #################################################################################
    
    if ($link_index eq "") { ### 21/02/2005
        for ($i = 0; $i < @links; $i++) {
            $links[$i] = $links[$i] . "\&" . $new_GET_data;
        }
        
    } else {
        $links[$link_index] = $links[$link_index] . "\&" . $new_GET_data;
    }
}


sub set_Link_Template {
    $this = shift @_;
    $link_template = shift @_;
}

sub set_Script_Name {
    $this = shift @_;
    $script_name = shift @_;
}

sub get_Links_Array {
    $this = shift @_;
    return @links;
}

sub get_Script_Name {
    $this = shift @_;
    return $script_name;
}

sub get_Additional_GET_Data {
    $this = shift @_;
    return $this->{additional_GET_data};
}

sub get_Links {
    
    if ($link_template ne "") {
        for ($i = 0; $i < @links; $i++) {
            $str = "link_ref_";
            $str .= $i;
            $str .= "_";
    
            $link_template =~ s/\b$str\b/$links[$i]/;
        }

        return $link_template;
    
    }
}


1;