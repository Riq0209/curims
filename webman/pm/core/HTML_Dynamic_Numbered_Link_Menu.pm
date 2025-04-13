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

package HTML_Dynamic_Numbered_Link_Menu;

require HTML_Link_Menu;

@ISA=("HTML_Link_Menu");

use HTML_Link_Menu;
use HTML_Link_Menu_Paginate;

$items_view_num = 1;
$items_set_num = 1;
$num_tag = "num_.";
$separator_tag = " \| ";
$script_name = "";
$menu_item_param_name = "dynamic_menu_item";
$items_set_param_name = "items_set_num";

sub new {
    my $type = shift;
    
    my $this = HTML_Link_Menu->new();
    
    bless $this, $type;
    
    return $this;
}

sub set_Items_View_Num {
    $this = shift @_;
    $items_view_num = shift @_;
}

sub set_Items_Set_Num {
    $this = shift @_;
    $items_set_num = shift @_;
}

sub set_Numbering_Tag {
    $this = shift @_;
    $num_tag = shift @_;
}

sub set_Separator_Tag {
    $this = shift @_;
    $separator_tag = shift @_;
}

sub set_Ref_Script {
    $this = shift @_;
    $script_name = shift @_;
}

sub set_Auto_Menu_Links {
    $this = shift @_;
    
    $script_name = shift @_;
    $menu_item_param_name = shift @_;
    $items_set_param_name = shift @_;
    
    @menu_items = $this->get_menu_items;
    @menu_links = $this->get_menu_links;
    
    for ($i = 0; $i < @menu_items; $i++) {
        $menu_items[$i] =~ s/ /\+/g;
        $menu_links[$i] = "$script_name?$menu_item_param_name=$menu_items[$i]\&$items_set_param_name=$items_set_num";
        $menu_items[$i] =~ s/\+/ /g;
    }
    
    $this->set_Menu_Links(@menu_links);
}

sub get_Menu {
    $this = shift @_;
    
    my $menu_content = "";
    my $dynamic_numbered_menu = "";
    
    my $script_name = $this->get_Script_Name;
    my $additional_GET_data = $this->get_Additional_GET_Data;
    
    my $menu_template_f = $this->get_menu_template_f;
    my $menu_template_c = $this->get_menu_template_c;
    
    my $active_menu_item = $this->get_active_menu_item;
    my @menu_items = $this->get_menu_items;
    my @menu_links = $this->get_menu_links;
    
    $items_num = @menu_items;
    
    
    if ($items_view_num > $items_num) {
        $items_view_num = $items_num;
    }
    
    $html_menu = new HTML_Link_Menu_Paginate;
    
    $html_menu->set_Next_Tag("");
    $html_menu->set_Previous_Tag("");
    $html_menu->set_Items_Set_Num($items_set_num);
    $html_menu->set_Items_View_Num($items_view_num);
    $html_menu->set_Separator_Tag(" "); 
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    
    $html_menu->set_Active_Menu_Item($active_menu_item);
    
    if ($menu_template_f eq "" && $menu_template_c ne "") {
        #print $menu_template_c;
        $html_menu->set_Menu_Template_Content($menu_template_c);
        
    } elsif ($menu_template_f ne "" && $menu_template_c eq "") {
        $html_menu->set_Menu_Template_File($menu_template_f);
    }
    
    $menu_content = $html_menu->get_Menu;
    
    $num = $items_num / $items_view_num;
    
    if ($items_num % $items_view_num != 0) {
        $num++;
        $num = substr ($num, 0, index($num, ".")); ### 04/06/2003
    }

    #print $num;
    
    for ($i = 1; $i <= $num; $i++) {
        if ($items_set_num != $i) {
                $start_href = "<a href=\"$script_name?$items_set_param_name=$i\&$additional_GET_data\">";
                $end_href = "</a>";
            } else {
                $start_href = "<b>";
                $end_href = "</b>"
            }
        if ($i < $num) {
            $dynamic_numbered_menu .= "$start_href" . $i . "$end_href" . $separator_tag;
        } else {
            $dynamic_numbered_menu .= "$start_href" . $i . "$end_href";
        }
    }
    
    $menu_content =~ s/dynamic_number_items_/$dynamic_numbered_menu/;
    
    return $menu_content;
}

sub generate_Menu {
    $this = shift @_;
    
}



1;
