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

package HTML_Table_Menu;

use Template_Element_Extractor;

$default_bgcolor = "#0066FF";
$active_bgcolor = "#0066FF";
$active_menu_item = "";
$menu_template_f = "";
$menu_template_c = "";

@menu_items = ("");
@menu_links = ("");

$active_menu_item = "";


sub new {
	my $type = shift;
	
	my $this = {};
	
	bless $this, $type;
	
	return $this;
}


sub set_Default_Bg_Color {
	$this = shift @_;
	$default_bgcolor = shift @_;
}

sub set_Actvie_Bg_Color {
	$this = shift @_;
	$active_bgcolor = shift @_;
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
	$this = shift @_;
	$script_name = shift @_;
	$cgi_param_name = shift @_;
	
	for ($i = 0; $i < @menu_items; $i++) {
		$menu_links[$i] = "$script_name?$cgi_param_name=$menu_items[$i]";
	}
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

sub get_Menu {

	$menu_content = "";
        
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
						$content =~ s/\bbgcolor_\b/bgcolor=$active_bgcolor/;
						$content =~ s/\b$str\b/$menu_items[$j]/;
					} else {
						$content =~ s/\bbgcolor_\b/bgcolor=$default_bgcolor/;
						$content =~ s/\b$str\b/<a href="$menu_links[$j]">$menu_items[$j]<\/a>/;
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
				$menu_template_c =~ s/\bbgcolor_\b/bgcolor=$active_bgcolor/;
				$menu_template_c =~ s/\b$str\b/$menu_items[$i]/;
			} else {
				$menu_template_c =~ s/\bbgcolor_\b/bgcolor=$default_bgcolor/;
				$menu_template_c =~ s/\b$str\b/<a href="$menu_links[$i]">$menu_items[$i]<\/a>/;
			}
		}

		return $menu_template_c;
	
	}
}


1;