package webman_TLD_item_view_dynamic;

use webman_TLD_item_view;

@ISA=("webman_TLD_item_view");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{order_field_cgi_var} = undef;
    $this->{order_field_caption} = undef;
    $this->{order_field_name} = undef;
    $this->{order_field_opt} = undef;
    $this->{order_field_mode} = undef;
    $this->{map_caption_field} = undef;
    
    $this->{default_order_field_selected} = 0;
    
    $this->{order_icon_asc} = undef;
    $this->{order_icon_desc} = undef;
    
    $this->{customize_TLD_after_sort} = 0; ### 01/02/2011    
    
    $this->{items_view_num} = undef;
    $this->{items_set_num} = undef;
    
    $this->{list_selection_num} = undef;
    
    $this->{inl_var_name} = undef;
    $this->{lsn_var_name} = undef;
    
    $this->{items_set_number_var} = undef;
    $this->{dynamic_menu_items_set_number_var} = undef;
    
    $this->{link_color_selected_order} = undef;
    $this->{link_color_selected_set_num} = undef;
    
    $this->{link_color_unselected_order} = undef;
    $this->{link_color_unselected_set_num} = undef;    
    
    $this->{carried_get_data} = undef;
    $this->{carried_hidden_post_data} = undef;    
    
    $this->{additional_get_data} = undef;
    $this->{additional_hidden_post_data} = undef;
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 17/12/2008
    
    bless $this, $class;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return $this->SUPER::get_Name_Full . "::" . __PACKAGE__;
}

sub set_Order_Field_CGI_Var {
    my $this = shift @_;
    
    $this->{order_field_cgi_var} = shift @_;
}

sub set_Order_Field_Caption {
    my $this = shift @_;
    
    $this->{order_field_caption} = shift @_;
}

sub set_Order_Field_Name_Opt_Mode {
    my $this = shift @_;
    
    $this->{order_field_name} = shift @_;
    $this->{order_field_opt} = shift @_;
    $this->{order_field_mode} = shift @_;
}

sub set_Map_Caption_Field { ### 20/12/2010
    my $this = shift @_;
    $this->{map_caption_field} = shift @_;
}

sub set_Items_View_Num {
    my $this = shift @_;
    
    $this->{items_view_num} = shift @_;
}

sub set_Items_Set_Num {
    my $this = shift @_;
    
    $this->{items_set_num} = shift @_;
}

sub set_Items_Set_Num_Var {
    my $this = shift @_;
    
    $this->{items_set_number_var} = shift @_;
}

sub set_Dynamic_Menu_Items_Set_Number_Var {
    my $this = shift @_;
    
    $this->{dynamic_menu_items_set_number_var} = shift @_;
}

sub set_List_Selection_Num {
    my $this = shift @_;
    
    $this->{list_selection_num} = shift @_;
}

sub set_Link_Color_Selected_Set_Num {
    my $this = shift @_;
        
    $this->{link_color_selected_set_num} = shift @_;
}

sub set_Link_Color_Selected_Order {
    my $this = shift @_;
        
    $this->{link_color_selected_order} = shift @_;
}

sub set_Link_Color_Unselected_Order {
    my $this = shift @_;
        
    $this->{link_color_unselected_order} = shift @_;
}

sub set_Link_Color_Unselected_Set_Num {
    my $this = shift @_;
        
    $this->{link_color_unselected_set_num} = shift @_;
}

sub set_Carried_GET_Data {
    my $this = shift @_;
    
    $this->{carried_get_data} = shift @_;
}

sub set_Carried_Hidden_POST_Data {
    my $this = shift @_;
    
    $this->{carried_hidden_post_data} = shift @_;
}

sub set_Additional_GET_Data {
    my $this = shift @_;
    
    $this->{additional_get_data} = shift @_;
}

sub set_Additional_Hidden_POST_Data {
    my $this = shift @_;
    
    $this->{additional_hidden_post_data} = shift @_;
}

sub set_Default_Order_Field_Selected {
    my $this = shift @_;
    
    $this->{default_order_field_selected} = shift @_;
}

sub set_INL_Var_Name {
    my $this = shift @_;
    
    $this->{inl_var_name} = shift @_;
}

sub set_LSN_Var_Name {
    my $this = shift @_;
    
    $this->{lsn_var_name} = shift @_;
}

sub set_Customize_TLD_After_Sort { ### 01/02/2011
    my $this = shift @_;

    $this->{customize_TLD_after_sort} = shift @_;
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ### 16/11/2007 ##############################################################
    
    my $def_ofs = $this->{default_order_field_selected};

    if ($cgi->param($this->{order_field_cgi_var}) eq "") {

        my @order_fields = split(/:/, $this->{order_field_name});

        if (!$cgi->set_Param_Val($this->{order_field_cgi_var}, $order_fields[$def_ofs])) {
            $cgi->add_Param($this->{order_field_cgi_var}, $order_fields[$def_ofs]);
            #print "\$this->{order_field_cgi_var} = $this->{order_field_cgi_var} <br>";
            #print "\$order_fields[$def_ofs] = $order_fields[$def_ofs] <br>";
        }
    }
    
    #############################################################################
    
    if ($this->{order_icon_asc} eq "") {
        $this->{order_icon_asc} = "&uarr;";
    }
    
    if ($this->{order_icon_desc} eq "") {
        $this->{order_icon_desc} = "&darr;";
    }    
    
    if ($this->{list_selection_num} eq "") {  ### should do this even default has been set
        $this->{list_selection_num} = 15;     ### to 15 or the $this->{list_selection_num} 
    }                                         ### variable will not get any value if try to call
                                              ### module name by using variable. eg: $comp = new $comp_name
                                             
    if ($this->{items_set_num} eq "") {
        $this->{items_set_num} = 1;
    }                                             

    if ($this->{items_set_number_var} eq "") {
        $this->{items_set_number_var} = "tldisn_" . $cgi->param("task");
    }
    
    if ($this->{dynamic_menu_items_set_number_var} eq "") {
        $this->{dynamic_menu_items_set_number_var} = "dmisn_" . $cgi->param("task");
    }
    
    if ($this->{inl_var_name} eq "") {
        $this->{inl_var_name} = "inl";
    }
    
    if ($this->{lsn_var_name} eq "") {
        $this->{lsn_var_name} = "lsn";
    }
    
    my $inl = $cgi->param($this->{inl_var_name});
    my $lsn = $cgi->param($this->{lsn_var_name});
    
    if ($inl > 0 and $inl ne $this->{items_view_num}) {
        $this->{items_view_num} = $inl;
        
    } else {
        if ($this->{items_view_num} eq "") {
            $this->{items_view_num} = 10;
        }
    }
    
    if ($lsn ne "" && !$cgi->is_DB_Cache_Var($this->{lsn_var_name})) { ### 01/01/2009
        $cgi->push_Param($this->{dynamic_menu_items_set_number_var}, $lsn);
    }
    
    my $items_set_number = $cgi->param($this->{items_set_number_var});
    
    if ($items_set_number eq "") {
        $items_set_number = $this->{items_set_num};
        $cgi->push_Param($this->{items_set_number_var}, $items_set_number);
        
    } else {
        $this->{items_set_num} = $items_set_number;
    }
    
    #print "\$items_set_number = $items_set_number";
    
    $this->SUPER::run_Task();    
    
    if ($this->{tld} ne undef) {            
        $this->{tld_items_num_total} = $this->{tld}->get_Row_Num;
    
        $this->{tld_items_num_begin} = 1;
        
        if ($items_set_number > 1) {
            $this->{tld_items_num_begin} = $items_set_number * $this->{items_view_num} - $this->{items_view_num} + 1;
        }
    
        $this->{tld_items_num_end} = $items_set_number * $this->{items_view_num};
    
        if ($this->{tld_items_num_end} > $this->{tld_items_num_total}) {
            $this->{tld_items_num_end} = $this->{tld_items_num_end} - ($this->{tld_items_num_end} - $this->{tld_items_num_total}); 
        }
        
        if ($this->{customize_TLD_after_sort}) {
            $this->sort_TLD;
            $this->customize_TLD($this->{tld});

        } else {
            $this->customize_TLD($this->{tld});
            $this->sort_TLD;
        }        
    }
    
    
    ### 16/11/2007 #############################################################
    
    $this->{combined_get_data} = undef;
    $this->{combined_hidden_post_data} = undef;
    
    my $carried_get_data = $cgi->generate_GET_Data($this->{inl_var_name});
    
    if ($this->{carried_get_data} ne "") {
        $carried_get_data .= "&" . $cgi->generate_GET_Data($this->{carried_get_data});
    }
    
    my $combined_get_data = $carried_get_data . "&" . $this->{additional_get_data};
    
    while ($combined_get_data =~ /\&\&/) {
        $combined_get_data =~ s/\&\&/\&/g;
    }
    
    $this->{combined_get_data} = $combined_get_data;
    
    #print "\$carried_get_data = -$carried_get_data- <br>\n";
    #print "\$combined_get_data = -$combined_get_data- <br>\n";
    
    my $carried_hidden_post_data = undef;
    
    if ($this->{carried_hidden_post_data} ne "") {
        $carried_hidden_post_data = $cgi->generate_Hidden_POST_Data($this->{carried_hidden_post_data});
    }
    
    my $combined_hidden_post_data = $carried_hidden_post_data;
    
    my @hidden_post_data = split(/\&/, $this->{additional_hidden_post_data});
    
    foreach my $item (@hidden_post_data) {
        my @hidden_param_val = split(/=/, $item);
        
        $hidden_param_val[1] = $cgi->convert_GET_Format_CodeToChar($hidden_param_val[1]);
        $combined_hidden_post_data .= "<input type=\"hidden\" name=\"$hidden_param_val[0]\" value=\"$hidden_param_val[1]\">\n";
    }
        
    $this->{combined_hidden_post_data} = $carried_hidden_post_data;
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    my $items_view_num = $this->{items_view_num};
    
    my $inl_var_name = $this->{inl_var_name} . "_";
    
    $te_content =~ s/\$$inl_var_name/$items_view_num/;
    
    $this->add_Content($te_content);
}

sub process_MENU { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    #print "\$te_type_name = $te_type_name";   
    
    if ($this->{tld} eq undef) {
        return $te_content;
    }
    
    my $i = 0;
    
    my $tld = $this->{tld};
    
    my $tld_items_num = $tld->get_Row_Num;
    
    $this->{total_items_set_num} = $tld_items_num / $this->{items_view_num};
    
    if ($tld_items_num % $this->{items_view_num} != 0) {
        $this->{total_items_set_num}++;
        $this->{total_items_set_num} = substr($this->{total_items_set_num}, 0, index($this->{total_items_set_num}, "."));
    }
    
    #print "\$this->{total_items_set_num} = " . $this->{total_items_set_num};
    
    if ($te_type_name eq "caption") {
        my @menu_items = split(/:/, $this->{order_field_caption});
        my @menu_links = split(/:/, $this->{order_field_name});
        
        my @order_opt = split(/:/, $this->{order_field_opt});

        #######################################################################
        
        my %map_caption_field = undef;
        
   
        if ($this->{map_caption_field} ne "") { ### developers want to include order sequence info.
        
            my @caption_field = split(/,/, $this->{map_caption_field});
            
            foreach my $item (@caption_field) {
                my @spliter = split(/=>/, $item);
                
                my $caption = $this->refine_Caption_Field_Text($spliter[0]);
                my $field = $this->refine_Caption_Field_Text($spliter[1]);
                
                #$cgi->add_Debug_Text("caption : field = $caption : $field", __FILE__, __LINE__);
                
                $map_caption_field{$caption} = $field;
            }
        }
        
        if (%map_caption_field ne undef) { ### start construct order sequence visual information
        
            my $selected_order_field_name = $this->refine_Caption_Field_Text($cgi->param($this->{order_field_cgi_var}));

            $selected_order_field_name =~ s/ ,/,/g;
            $selected_order_field_name =~ s/, /,/g;
            
            #$cgi->add_Debug_Text("\$selected_order_field_name = $selected_order_field_name", __FILE__, __LINE__);

            my @spliter = split(/ /, $selected_order_field_name);

            
            for (my $i = 0; $i < @menu_items; $i++) {
                my $counter = 1;
                
                foreach my $field_name (@spliter) {
                    #$cgi->add_Debug_Text("\$menu_items[$i] = $menu_items[$i]", __FILE__, __LINE__);
                    #$cgi->add_Debug_Text("$field_name =~ $map_caption_field{$menu_items[$i]}", __FILE__, __LINE__);
                
                    if ($field_name =~ /$map_caption_field{$menu_items[$i]}/ && $map_caption_field{$menu_items[$i]} ne "") {
                        my $icon = $this->{order_icon_asc};
                        
                        if ($order_opt[$i] =~ /^desc/) {
                            $icon = $this->{order_icon_desc}
                        }
                        
                        $menu_items[$i] = $menu_items[$i] . " " . $icon . "<sup>$counter</sup>";
                    }
                    
                    #$cgi->add_Debug_Text("\$menu_items[$i] = $menu_items[$i]", __FILE__, __LINE__);
                    
                    $counter++;
                }
            }
        }
                
        #######################################################################        
        
        my %field_name_caption = undef;
        
        for ($i = 0; $i < @menu_links; $i++) {
            $field_name_caption{"$menu_links[$i]"} = $menu_items[$i];
            $menu_links[$i] =~ s/ /+/g;
            $menu_links[$i] = "index.cgi?" . $this->{order_field_cgi_var} . "=$menu_links[$i]";
        }
        
        my $html_menu = new HTML_Link_Menu;

        $html_menu->set_Menu_Template_Content($te_content);
        $html_menu->set_Menu_Items(@menu_items);
        $html_menu->set_Menu_Links(@menu_links);
        
        if ($this->{link_color_unselected_order} ne undef) {
            $html_menu->set_Non_Selected_Link_Color($this->{link_color_unselected_order});
        }
        
        if ($cgi->param($this->{order_field_cgi_var}) eq "") {
            $html_menu->set_Active_Menu_Item($menu_items[$this->{default_order_field_selected}]);
            
        } else {
            $html_menu->set_Active_Menu_Item($field_name_caption{$cgi->param($this->{order_field_cgi_var})});
        }
        
        my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
        
        $html_menu->add_GET_Data_Links_Source($caller_get_data);
        $html_menu->add_GET_Data_Links_Source($this->{combined_get_data});
        

        $te_content = $html_menu->get_Menu;
        
    } elsif ($te_type_name eq "list") {
    
        my $dmisn = $cgi->param($this->{dynamic_menu_items_set_number_var});
        my $items_set_number = $cgi->param($this->{items_set_number_var});

        if ($dmisn eq "") { $dmisn = 1; }
        if ($items_set_number eq "") { $items_set_number = $this->{items_set_num}; }

        my $html_menu = new HTML_Link_Menu_Paginate;

        $html_menu->reset_Menu;

        $html_menu->set_Menu_Template_Content($te_content);
        $html_menu->set_Items_View_Num($this->{list_selection_num});
        $html_menu->set_Items_Set_Num($dmisn);

        for ($i = 1; $i <= $this->{total_items_set_num}; $i++) {
            $html_menu->set_Menu_Item("$i");
        }
        
        #print "\$this->{items_set_number_var} = " . $this->{items_set_number_var} . "<br>";

        $html_menu->set_Auto_Menu_Links("index.cgi", $this->{items_set_number_var}, $this->{dynamic_menu_items_set_number_var});
        $html_menu->set_Active_Menu_Item($items_set_number);

        $html_menu->set_Separator_Tag("|");
        $html_menu->set_Next_Tag(">>");
        $html_menu->set_Previous_Tag("<<");
        #$html_menu->set_Non_Selected_Link_Color("#0099FF");

        my $caller_get_data = $cgi->generate_GET_Data("session_id link_id");
        
        #print "\$caller_get_data = $caller_get_data <br>\n";
        #print "\$this->{combined_get_data} = $this->{combined_get_data} <br>\n";
        
        $html_menu->add_GET_Data_Links_Source($caller_get_data);
        $html_menu->add_GET_Data_Links_Source($this->{combined_get_data});

        $te_content = $html_menu->get_Menu;
    }
    
    $this->add_Content($te_content);
}

sub process_SELECT { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
                                          
    if ($te_type_name eq $this->{lsn_var_name}) {
        my $dmisn = $cgi->param($this->{dynamic_menu_items_set_number_var});

        my $dmisn_total = $this->{total_items_set_num} / $this->{list_selection_num};

        if ($this->{total_items_set_num} % $this->{list_selection_num} != 0) {
                $dmisn_total++;
                $dmisn_total = substr($dmisn_total, 0, index($dmisn_total, "."));
        }
        
        

        if ($dmisn eq "") { $dmisn = 1; }

        my $s_opt = new Select_Option;

        my @values = undef;
        my @options = undef;

        my $i = 0;

        for ($i = 0; $i < $dmisn_total; $i++) {
            $values[$i] = $i + 1;
            $options[$i] = $i + 1 . "/" . $dmisn_total;
        }

        $s_opt->set_Values(@values);
        $s_opt->set_Options(@options);

        $s_opt->set_Selected($dmisn);

        $te_content = $s_opt->get_Selection;
    } 
    
    $this->add_Content($te_content);
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    #print "\$te_type_name = $te_type_name";
    
    if ($te_type_name eq "tld_items_num_total") {
        $this->add_Content($this->{tld_items_num_total});
    }
    
    if ($te_type_name eq "tld_items_num_begin") {
        $this->add_Content($this->{tld_items_num_begin});
    }
    
    if ($te_type_name eq "tld_items_num_end") {
        $this->add_Content($this->{tld_items_num_end});
    }    
    
    if ($te_type_name eq "form_hidden_field") {
    
        my $hpd = $cgi->generate_Hidden_POST_Data("link_name dmisn link_id app_name session_id " . 
                                                  $this->{order_field_cgi_var} . " " . $this->{items_set_number_var});
                                                  
        $hpd .= $this->{combined_hidden_post_data};
        
        $te->set_Content($hpd);
    }
    
    $this->SUPER::process_DYNAMIC($te);
}

sub sort_TLD {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my @field_name = split(/:/, $this->{order_field_name});
    my @sort_opt = split(/:/, $this->{order_field_opt});
    my @sort_mode = split(/:/, $this->{order_field_mode});
    
    my $tld = $this->{tld};
    
    if ($tld ne undef) { ### 07/07/2009
        if ($cgi->param($this->{order_field_cgi_var}) eq "") {

            $tld->sort_Data($field_name[$this->{default_order_field_selected}], 
                            $sort_opt[$this->{default_order_field_selected}], 
                            $sort_mode[$this->{default_order_field_selected}]);

        } else {
            my $i = 0;

            for ($i = 0; $i < @field_name; $i++) {
                if ($field_name[$i] eq $cgi->param($this->{order_field_cgi_var})) {
                    $tld->sort_Data($field_name[$i], $sort_opt[$i], $sort_mode[$i]);
                }
            }
        }
    }
}

sub refine_Caption_Field_Text {
    my $this = shift @_;
    
    my $text = shift @_;
    
    $text =~ s/^ //;
    $text =~ s/ $//;
    
    while ($text =~ /  /) { $text =~ s/  / /g; }
    
    return $text;
}

1;