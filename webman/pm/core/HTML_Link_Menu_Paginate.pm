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

package HTML_Link_Menu_Paginate;

use HTML_Link_Menu;

require HTML_Link_Menu;

@ISA=("HTML_Link_Menu");


my $items_set_num = 1;
my $num_tag = "num_.";
my $script_name = "";
my $menu_item_param_name = "dynamic_menu_item";
my $items_set_param_name = "items_set_num";

sub new {
    my $type = shift;
    
    my $this = $type->SUPER::new();
    
    $this->{items_view_num} = 1;
    $this->{next_get_data} = "";
    $this->{previous_get_data} = "";
    
    $this->{separator_tag} = "|";
    $this->{next_tag} = "&gt;&gt;";
    $this->{previous_tag} = "&lt;&lt;";
    
    bless $this, $type;
    
    return $this;
}

sub set_Items_View_Num {
    my $this = shift @_;
    
    $this->{items_view_num} = shift @_;
    
    #print "set_Items_View_Num: \$this->{items_view_num} = $this->{items_view_num} <br>\n";
}

sub set_Items_Set_Num {
    my $this = shift @_;
    
    $items_set_num = shift @_;
}

sub set_Numbering_Tag {
    my $this = shift @_;
    
    $num_tag = shift @_;
}

sub set_Separator_Tag {
    my $this = shift @_;
    
    $this->{separator_tag} = shift @_;
}

sub set_Next_Tag {
    my $this = shift @_;
    
    $this->{next_tag} = shift @_;
}

sub set_Next_GET_Data_Links_Source {
    my $this = shift @_;
    
    $this->{next_get_data} = shift @_;
}

sub set_Previous_Tag {
    my $this = shift @_;
    
    $this->{previous_tag} = shift @_;
}

sub set_Previous_GET_Data_Links_Source {
    my $this = shift @_;
    
    $this->{previous_get_data} = shift @_;
}

sub set_Auto_Menu_Links {
    my $this = shift @_;
    
    my $auto_script_name = shift @_;
    my $auto_menu_item_param_name = shift @_;
    my $auto_items_set_param_name = shift @_;
    
    if ($auto_items_set_param_name ne "") { ### 22/11/2003
        $items_set_param_name = $auto_items_set_param_name;
    }
    
    if ($auto_menu_item_param_name ne "") {
        $menu_item_param_name = $auto_menu_item_param_name;
    }
    
    @menu_items = $this->get_menu_items;
    @menu_links = $this->get_menu_links;
    
    my $old_link_value = undef;
    
    for ($i = 0; $i < @menu_items; $i++) {
        $menu_items[$i] =~ s/ /\+/g;
        $menu_items[$i] =~ s/\&/\%26/g; ### 20/02/2005
        
        $old_link_value = $menu_links[$i];
        
        $menu_links[$i] = "$auto_script_name?$auto_menu_item_param_name=$menu_items[$i]\&$auto_items_set_param_name=$items_set_num";
        
        if ($old_link_value ne "") {
            $menu_links[$i] .= "\&$old_link_value"; ### 21/02/2005
        }
        
        $menu_items[$i] =~ s/\+/ /g;
        $menu_items[$i] =~ s/\%26/\&/g; ### 20/02/2005
    }
    
    $this->set_Menu_Links(@menu_links);
}

### 30/12/2003 ##########################################################
sub get_First_Current_Item {
    my $this = shift @_;
    
    my $items_num = @menu_items;
    
    $j_start = ($items_set_num - 1) * $this->{items_view_num};

    if (($j_stop = $this->{items_view_num} * $items_set_num) > $items_num) {
        $j_stop = $items_num;   
    }
    
    return $menu_items[$j_start];
}

sub get_Last_Current_Item {
    my $this = shift @_;
    
    my $items_num = @menu_items;
    
    $j_start = ($items_set_num - 1) * $this->{items_view_num};

    if (($j_stop = $this->{items_view_num} * $items_set_num) > $items_num) {
        $j_stop = $items_num;   
    }
    
    return $menu_items[$j_stop - 1];
}
#########################################################################


sub get_Menu {
    my $this = shift @_;
    
    $menu_content = ""; 
    
    $menu_template_f = $this->get_menu_template_f;
    $menu_template_c = $this->get_menu_template_c;
    
    $active_menu_item = $this->get_active_menu_item;
    @menu_items = $this->get_menu_items;
    @menu_links = $this->get_menu_links;
    
    my $items_num = @menu_items;
    my $str = "dynamic_menu_items_";
    
    #print "get_Menu: \$items_num = $items_num <br>\n";
                    
    if ($this->{items_view_num} > $items_num) {
        $this->{items_view_num} = $items_num;
    }
        
    if ($menu_template_f ne "" && $menu_template_c eq "") {
        $tex = new Template_Element_Extractor;

        @te = $tex->get_Template_Element($menu_template_f);
        
        for ($i = 0; $i < @te; $i++) {

            $type = $te[$i]->get_Type;
            $content = $te[$i]->get_Content;
            
            #print "Content = $content ----\n";
            
            if ($type eq "VIEW") {
                $menu_content = $menu_content . $content;
            }

            if ($type eq "MENU") {
                $menu_content = $menu_content . $this->generate_Menu($items_num, $str, $content);
            }
        }
        
        return $menu_content;
    }
    
    
    if ($menu_template_f eq "" && $menu_template_c ne "") {
        #print "From menu_template_c <> \"\"<br>\n";
        
        $content = $menu_template_c;
        $menu_content = $menu_content . $this->generate_Menu($items_num, $str, $content);
        return $menu_content;
    }
}

sub generate_Menu {
    my $this = shift @_;
    
    my $items_num = shift @_;
    my $str = shift @_;
    my $content = shift @_;
    
    #print "generate_Menu: \$items_num = $items_num | \$this->{items_view_num} = $this->{items_view_num}<br>\n";
    
    my $temp_content = ""; ### 21/02/2005
    
    if ($content =~ /dynamic_number_items_/) {
        #$content =~ s/\n\n/\n/g;
        return $content;
    }
    
    #@menu_items = $this->get_menu_items;
    #@menu_links = $this->get_menu_links;
    
    my $slc = $this->get_Selected_Link_Color; ### 07/02/2013
    my $slc_ftb = undef; ### fts stnd for font tag begin
    my $slc_fte = undef; ### fts stnd for font tag end    
    
    if ($slc ne "") {
        $slc_ftb = "<font color=\"$slc\">";
        $slc_fte = "</font>";
    }
    
    my $nslc = $this->get_Non_Selected_Link_Color; ### 20/02/2005
    my $nslc_ftb = undef; ### fts stnd for font tag begin
    my $nslc_fte = undef; ### fts stnd for font tag end
    
    if ($nslc ne "") {
        $nslc_ftb = "<font color=\"$nslc\">";
        $nslc_fte = "</font>";
    }
    
    $script_name = $this->get_Script_Name;

    $additional_GET_data = $this->get_Additional_GET_Data;
    
    #print "\$additional_GET_data = " . $additional_GET_data . "<br>";

    if ($this->{previous_tag} ne "") { ### 22/05/2003
        if ($items_set_num > 1) {
            $num = $items_set_num - 1;
            
            if ($this->{previous_get_data} eq "") {
                $tag = "<a href=\"$script_name?$items_set_param_name=$num\&$menu_item_param_name=$active_menu_item\&$additional_GET_data\">$nslc_ftb$this->{previous_tag}$nslc_fte</a> $this->{separator_tag}";
            } else {
                $tag = "<a href=\"$script_name?$items_set_param_name=$num\&$this->{previous_get_data}\">$nslc_ftb$this->{previous_tag}$nslc_fte</a> $this->{separator_tag}";
            }
            
            $temp_content = $content;
            $temp_content =~ s/\b$str\b/$tag /;
            $temp_content =~ s/\bnum_\b/ /;
        } else {
            $temp_content = $content;
            $temp_content =~ s/\b$str\b/$this->{previous_tag} $this->{separator_tag} /;
            $temp_content =~ s/\bnum_\b/ /;
        }
    }

    $j_start = ($items_set_num - 1) * $this->{items_view_num};

    if (($j_stop = $this->{items_view_num} * $items_set_num) > $items_num) {
        $j_stop = $items_num;   
    }
    
    
    #print "generate_Menu: \$j_start = $j_start | \$j_stop = $j_stop <br>\n";

    for ($j = $j_start; $j < $j_stop; $j++) {
        #print "$menu_links[$j] <br>\n";
    
        $temp_content = $temp_content . $content;

        if ($menu_items[$j] eq $active_menu_item) {
            if (($j + 1) < $j_stop) {
                $temp_content =~ s/\b$str\b/$slc_ftb$menu_items[$j]$slc_fte $this->{separator_tag} /;
            } else {
                $temp_content =~ s/\b$str\b/$slc_ftb$menu_items[$j]$slc_fte /;
            }
            
        } else {
            if (($j + 1) < $j_stop) {
                $temp_content =~ s/\b$str\b/<a href="$menu_links[$j]">$nslc_ftb$menu_items[$j]$nslc_fte<\/a> $this->{separator_tag} /;
            } else {
                $temp_content =~ s/\b$str\b/<a href="$menu_links[$j]">$nslc_ftb$menu_items[$j]$nslc_fte<\/a> /;
            }
        }

        $num = $j + 1;
        $temp_content =~ s/\bnum_\b/$num/;
    }



    if ($this->{next_tag} ne "") { ### 22/05/2003
        $temp_content = $temp_content . $content;

        if (($items_set_num * $this->{items_view_num}) < $items_num) {
            $num = $items_set_num + 1;
            
            if ($this->{next_get_data} eq "") {
                $tag = "$this->{separator_tag} <a href=\"$script_name?$items_set_param_name=$num\&$menu_item_param_name=$active_menu_item\&$additional_GET_data\">$nslc_ftb$this->{next_tag}$nslc_fte</a>";
            } else {
                $tag = "$this->{separator_tag} <a href=\"$script_name?$items_set_param_name=$num\&$this->{next_get_data}\">$nslc_ftb$this->{next_tag}$nslc_fte</a>";
            }
            $temp_content =~ s/\b$str\b/ $tag/;
            $temp_content =~ s/\bnum_\b/ /;
        } else {
            $temp_content =~ s/\b$str\b/$this->{separator_tag} $this->{next_tag}/;
            $temp_content =~ s/\bnum_\b/ /;
        }
    } 

    #$temp_content =~ s/\n\n/\n/g;
    return $temp_content;
    
}

1;