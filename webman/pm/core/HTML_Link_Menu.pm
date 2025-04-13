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

package HTML_Link_Menu;

use Template_Element_Extractor;

my $selected_link_color = undef; ### 07/02/2013
my $non_selected_link_color = undef; ### 20/02/2005

my $active_menu_item = undef;
my $menu_template_f = undef;
my $menu_template_c = undef;
my $script_name = undef;

my @menu_items = undef;
my @menu_links = undef;

sub new {
    my $type = shift;
    
    my $this = {};
    
    $this->{additional_GET_data} = undef;
    
    bless $this, $type;
    
    return $this;
}

sub reset_Menu { ### 30/05/2003 
    @menu_items = undef;
    @menu_links = undef;
}

sub set_CGI { ### this is mainly purpose for debugging
    $this = shift @_;
    
    $this->{cgi} = shift @_;
}

sub set_Menu_Item {
    $this = shift @_;
    
    my $menu_item = shift @_;
    my $item_index = shift @_; ### 21/02/2005
    
    my $num = @menu_items;
    
    if ($item_index eq "") { ### 21/02/2005
        if ($num == 1 and $menu_items[0] eq "") {
            $menu_items[0] = $menu_item;
        } else {
            $menu_items[$num] = $menu_item;
        }
        
    } else {
        $menu_items[$item_index] = $menu_item;
    }
}

sub set_Menu_Link {
    $this = shift @_;
    
    $menu_link = shift @_;
    $link_index = shift @_; ### 21/02/2005
    
    $num = @menu_links;
    
    if ($link_index eq "") { ### 21/02/2005
        if ($num == 1 and $menu_links[0] eq "") {
            $menu_links[0] = $menu_link;
        } else {
            $menu_links[$num] = $menu_link;
        }
        
    } else {
        $menu_links[$link_index] = $menu_link;
    }
}

sub set_Menu_Items {
    $this = shift @_;
    @menu_items = @_;
}

sub set_Menu_Links {
    $this = shift @_;
    @menu_links = @_;
}

sub set_Auto_Menu_Links {
    my $this = shift @_;
    
    $auto_script_name = shift @_;
    $auto_menu_item_param_name = shift @_;
    
    my $old_link_value = undef; ### 05/08/2005
    
    for ($i = 0; $i < @menu_items; $i++) {
        $menu_items[$i] =~ s/ /\+/g;
        $menu_items[$i] =~ s/\&/\%26/g; ### 05/08/2005
        
        $old_link_value = $menu_links[$i];### 05/08/2005
        
        $menu_links[$i] = "$auto_script_name?$auto_menu_item_param_name=$menu_items[$i]";
        
        if ($old_link_value ne "") { ### 05/08/2005
            $menu_links[$i] .= "\&$old_link_value"; ### 05/08/2005
        }
        
        $menu_items[$i] =~ s/\+/ /g;
        $menu_items[$i] =~ s/\%26/\&/g;### 05/08/2005
    }
}

sub add_GET_Data_Links_Source {
    my $this = shift @_;
    
    my $new_GET_data = shift @_;
    my $link_index = shift @_; ### 21/02/2005
    
    #print "\$new_GET_data before = $new_GET_data <br>\n";
    
    $new_GET_data =~ s/ /\+/g;
    
    #print "\$new_GET_data = -$new_GET_data- <br>";
    
    if ($this->{additional_GET_data} eq undef) { ### 20/12/2005
        $this->{additional_GET_data} = $new_GET_data;

    } else {
        $this->{additional_GET_data} .= "\&" . $new_GET_data;
    }
    
    #print "\$this->{additional_GET_data} = " . $this->{additional_GET_data} . "<br>";
    
    ### 21/3/2005 ###################################################################
    
    my @splitted_get_data = split(/\&/, $new_GET_data);
    
    my $i = 0;
    $new_GET_data = "";
    
    for ($i =0; $i < @splitted_get_data; $i++) {
        if ($splitted_get_data[$i] =~ /=/) {
            $new_GET_data .= $splitted_get_data[$i] . "\&";
            
        } elsif($splitted_get_data[$i] ne "") { ### 16/11/2007
            $new_GET_data = substr($new_GET_data, 0, length($new_GET_data) - 1);
            
            $new_GET_data .= "\%26" . $splitted_get_data[$i] . "\&";
        }
    }
    
    $new_GET_data = substr($new_GET_data, 0, length($new_GET_data) - 1);
    
    #$new_GET_data =~ s/
    
    #print "\$new_GET_data after = $new_GET_data <br>\n";
    
    #################################################################################
    
    if ($link_index eq "") { ### 21/02/2005
        for ($i = 0; $i < @menu_links; $i++) {
            $menu_links[$i] = $menu_links[$i] . "\&" . $new_GET_data;
            $menu_links[$i] =~ s/\&\&/\&/g; ### 10/10/2007
        }
        
    } else {
        $menu_links[$link_index] = $menu_links[$link_index] . "\&" . $new_GET_data;
        $menu_links[$i] =~ s/\&\&/\&/g; ### 10/10/2007
    }
}

sub set_Selected_Link_Color { ### 07/02/2013
    $this = shift @_;
    $selected_link_color = shift @_;
}

sub set_Non_Selected_Link_Color { ### 20/02/2005
    $this = shift @_;
    $non_selected_link_color = shift @_;
}

sub set_Active_Menu_Item {
    $this = shift @_;
    $active_menu_item = shift @_;
}

sub set_Menu_Template_Content {
    $this = shift @_;
    $menu_template_c = shift @_;
    $menu_template_f = "";
}

sub set_Menu_Template_File {
    $this = shift @_;
    $menu_template_f = shift @_;
    $menu_template_c = "";
}

sub set_Script_Name {
    $this = shift @_;
    $script_name = shift @_;
}

sub get_menu_template_f {
    $this = shift @_;
    return $menu_template_f;
}

sub get_menu_template_c {
    $this = shift @_;
    return $menu_template_c;
}

sub get_Selected_Link_Color { ### 07/02/2013
    $this = shift @_;
    return $selected_link_color;
}

sub get_Non_Selected_Link_Color { ### 20/02/2005
    $this = shift @_;
    return $non_selected_link_color;
}

sub get_active_menu_item {
    $this = shift @_;
    return $active_menu_item;
}

sub get_menu_items {
    $this = shift @_;
    return @menu_items;
}

sub get_menu_links {
    $this = shift @_;
    return @menu_links;
}

sub get_Script_Name {
    $this = shift @_;
    return $script_name;
}

sub get_Additional_GET_Data {
    $this = shift @_;
    return $this->{additional_GET_data};
}

sub get_Menu {

    my $menu_content = "";
    # my $menu_template_c = ""; ### 25/03/2005
    
    my $nslc = $this->get_Non_Selected_Link_Color; ### 26/03/2005
        
    if ($menu_template_f ne "" && $menu_template_c eq "") {
        $tex = new Template_Element_Extractor;

        @te = $tex->get_Template_Element($menu_template_f);
        
        for ($i = 0; $i < @te; $i++) {

            $type = $te[$i]->get_Type;
            $content = $te[$i]->get_Content;
            
            if ($type eq "VIEW") {
                $menu_content = $menu_content . $content;
            }

            if ($type eq "MENU") {
                for ($j = 0; $j < @menu_items; $j++) {
                    $str = "menu_item";
                    $str .= $j;
                    $str .= "_";

                    if ($menu_items[$j] eq $active_menu_item) {
                        $content =~ s/\b$str\b/$menu_items[$j]/;
                        
                    } else {
                        if ($menu_items[$j] =~ /<a/) { ### 10/02/2014
                            ### Link has been set by external sources so need 
                            ### to avoid from constructing nested link.
                            $menu_items[$j] =~ s/<a/<\/font><\/a><a/;
                            $content =~ s/\b$str\b/<a href="$menu_links[$j]"><font color="$nslc">$menu_items[$j]/;
                            
                        } else {
                            $content =~ s/\b$str\b/<a href="$menu_links[$j]"><font color="$nslc">$menu_items[$j]<\/font><\/a>/;
                        }
                    }
                }

                $menu_content = $menu_content . $content;
            }
        }
        
        return $menu_content;
    }
    
    
    if ($menu_template_f eq "" && $menu_template_c ne "") {
        for ($i = 0; $i < @menu_items; $i++) {
            $str = "menu_item";
            $str .= $i;
            $str .= "_";

            if ($menu_items[$i] eq $active_menu_item) {
                $menu_template_c =~ s/\b$str\b/$menu_items[$i]/;
                
            } else {
                if ($menu_items[$i] =~ /<a/) { ### 10/02/2014
                    ### Link has been set by external sources so need 
                    ### to avoid from constructing nested link.
                    $menu_items[$i] =~ s/<a/<\/font><\/a><a/;
                    $menu_template_c =~ s/\b$str\b/<a href="$menu_links[$i]"><font color="$nslc">$menu_items[$i]/;
                    
                } else {
                    $menu_template_c =~ s/\b$str\b/<a href="$menu_links[$i]"><font color="$nslc">$menu_items[$i]<\/font><\/a>/;
                }
            }
        }

        return $menu_template_c;
    
    }
}


1;