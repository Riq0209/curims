package web_man_admin_link_tree;

unshift (@INC, "../");

require CGI_Component;

@ISA=("CGI_Component");


sub new {
    my $class = shift;
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{activate_last_path} = undef;
    
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

sub run_Task {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if ($cgi->param("trace_module")) {
        print "<b>" . $this->get_Name_Full . "</b><br />\n";
    }
    
    $this->{app_name} = $cgi->param("app_name");
    
    $this->SUPER::run_Task;
    
    my $dbu = new DB_Utilities;
    $dbu->set_DBI_Conn($db_conn);
    
    $this->{dbu} = $dbu;
    
    $this->{node_root} = new Link_Node;
    
    $this->{node_root}->set_Text("Root");
    $this->{node_root}->{type} = "root";
    
    $this->contruct_link_tree($this->{node_root});
    
    $this->traverse_node($this->{node_root}, undef);
}

sub process_Content {
    $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File("./template_admin_link_tree.html");
    
    $this->SUPER::process_Content;
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($this->{tree_html});    
}

###############################################################################

sub contruct_link_tree {
    my $this = shift @_;
    
    my $node = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;  
    
    my $app_name = $this->{app_name};
    
    my $dbu = $this->{dbu};
    
    $dbu->set_DBI_Conn($db_conn);
    
    #$cgi->add_Debug_Text($node->{text}, __FILE__, __LINE__);

    if ($node->{type} eq "root") {
        $dbu->set_Table("webman_" . $app_name . "_link_structure");
        my @ahr = $dbu->get_Items("link_id parent_id name", "parent_id", "0", "sequence");
        
        foreach my $item (@ahr) {
            my $node_new = new Link_Node({text => $item->{name}, target => "-", type => "link",
                                          info_hash => {link_id => $item->{link_id}, parent_id => $item->{parent_id}}});
                                          
            $node->add_Child($node_new);
            $this->contruct_link_tree($node_new);
        }       
        
    } elsif ($node->{type} eq "link") {
        ### get dynamic ref. type child nodes under current $node
        $dbu->set_Table("webman_" . $app_name . "_link_reference");
        my @ahr = $dbu->get_Items("link_ref_id link_id ref_type ref_name dynamic_content_name dynamic_content_num", "link_id", $node->{info_hash}->{link_id});

        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);

        foreach my $item (@ahr) {
            my $node_new = new Link_Node({text => $item->{ref_name}, target => "-", type => "reference", 
                                          info_hash => {link_ref_id => $item->{link_ref_id}, link_id => $item->{link_id}, dynamic_content_num => $item->{dynamic_content_num}}});

            $node->add_Child($node_new);
            
            if ($node_new->{text} eq "webman_component_selector") {
                $this->contruct_link_tree($node_new);
            }
        } 
        
        ### get other link type child nodes under current $node
        $dbu->set_Table("webman_" . $app_name . "_link_structure");
        my @ahr =  $dbu->get_Items("link_id parent_id name", "parent_id", $node->{info_hash}->{link_id}, "sequence");
        
        foreach my $item (@ahr) {
            my $node_new = new Link_Node({text => $item->{name}, target => "-", type => "link",
                                          info_hash => {link_id => $item->{link_id}, parent_id => $item->{parent_id}}});
            
            
            $node->add_Child($node_new);
            
            #$cgi->add_Debug_Text($node_new->{text}, __FILE__, __LINE__);
            
            $this->contruct_link_tree($node_new);            
        }
        
    } elsif ($node->{type} eq "reference") {
        #$cgi->add_Debug_Text($node->{text}, __FILE__, __LINE__);
        
        $dbu->set_Table("webman_" . $app_name . "_link_reference");

        my $dynamic_content_num = $dbu->get_Item("dynamic_content_num", "link_ref_id", $node->{info_hash}->{link_ref_id});

        #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__);
        #$cgi->add_Debug_Text("\$dynamic_content_num = $dynamic_content_num", __FILE__, __LINE__);
            
        if (!$node->{recursive_wmcs}) {
            ### get dynamic ref. type child nodes under 
            ### webman_component_selector
            
            $dbu->set_Table("webman_" . $app_name . "_dyna_mod_selector");
            my @ahr = $dbu->get_Items("dyna_mod_selector_id link_ref_id dyna_mod_name cgi_param cgi_value parent_id", 
                                      "link_ref_id", $node->{info_hash}->{link_ref_id});

            foreach my $item (@ahr) {
                if (!$item->{parent_id}) {
                    my $node_new = new Link_Node({text => $item->{dyna_mod_name}, target => "-", type => "reference",
                                                  info_hash => {dyna_mod_selector_id => $item->{dyna_mod_selector_id}, link_ref_id => $item->{link_ref_id}, dynamic_content_num => $dynamic_content_num}});

                    if ($node_new->{text} eq "webman_component_selector") {
                        ### recursive webman_component_selector
                        $node_new->{recursive_wmcs} = 1;
                        $node->add_Child($node_new);
                        $this->contruct_link_tree($node_new);

                    } else {
                        $node->add_Child($node_new);
                        #$cgi->add_Debug_Text($node_new->{text}, __FILE__, __LINE__);
                    }
                }
            }
            
        } else {
            ### get dynamic ref. type child nodes under 
            ### recursive webman_component_selector
            
            $dbu->set_Table("webman_" . $app_name . "_dyna_mod_selector");
            my @ahr = $dbu->get_Items("dyna_mod_selector_id link_ref_id dyna_mod_name cgi_param cgi_value parent_id", 
                                      "link_ref_id parent_id", 
                                      "$node->{info_hash}->{link_ref_id} $node->{info_hash}->{dyna_mod_selector_id}");
                                      
            foreach my $item (@ahr) {
                my $node_new = new Link_Node({text => $item->{dyna_mod_name}, target => "-", type => "reference",
                                              info_hash => {dyna_mod_selector_id => $item->{dyna_mod_selector_id}, link_ref_id => $item->{link_ref_id}, dynamic_content_num => $dynamic_content_num}});

                if ($node_new->{text} eq "webman_component_selector") {
                    ### recursive webman_component_selector
                    $node_new->{recursive_wmcs} = 1;
                    $node->add_Child($node_new);
                    $this->contruct_link_tree($node_new);

                } else {
                    $node->add_Child($node_new);
                    #$cgi->add_Debug_Text($node_new->{text}, __FILE__, __LINE__);
                }            
            }
        }
    }
}

sub traverse_node {
    my $this = shift @_;
    
    my $node_start = shift @_;
    my $prev_newline = shift @_;
    
    my $cgi = $this->get_CGI;
    
    my $dbu = $this->{dbu};
    my $app_name = $this->{app_name};
    
    $this->{tree_txt}  .= $this->get_indent($node_start, $prev_newline);
    $this->{tree_html} .= $this->get_indent($node_start, $prev_newline);
 
    #$cgi->add_Debug_Text("$node_start->{text} - $node_start->{recursive_wmcs}", __FILE__, __LINE__);
    
    if ($node_start->{type} eq "reference") {
        $this->{tree_txt}  .= "[" . $node_start->get_Text . "]\n";
        
        my $param_set_total = 0;
        
        $dbu->set_Table("webman_" . $app_name . "_dyna_mod_param");
        
        my $link_id = $node_start->{info_hash}->{link_id};
        my $parent_id = $node_start->{info_hash}->{parent_id};
        
        my $dyna_mod_selector_id = $node_start->{info_hash}->{dyna_mod_selector_id};
        my $link_ref_id = $node_start->{info_hash}->{link_ref_id};
        my $dynamic_content_num = $node_start->{info_hash}->{dynamic_content_num};
        
        my $ref_name = $node_start->{text};
        
        my $ref_type = "DYNAMIC_MODULE";
        
        if ($ref_name eq "webman_main") {
            $ref_type = "MAIN_CONTROLLER";
        }
        
        ### dyna_mod_selector_id must be checked first or it will never be counted
        ### since dynamic ref. type nodes under webman_component_selector will have
        ### both link_ref_id & dyna_mod_selector_id
        if ($dyna_mod_selector_id) {
            $param_set_total = $dbu->count_Item("dyna_mod_selector_id", $node_start->{info_hash}->{dyna_mod_selector_id});
            
        } elsif ($link_ref_id) {
            $param_set_total = $dbu->count_Item("link_ref_id", $node_start->{info_hash}->{link_ref_id});
        }
        
        my $href_target = "index.cgi?link_name=Link+Structure/Reference&dmisn=1&app_name=$app_name&link_struct_id=$parent_id&child_link_id=$link_id&task=update_dyna_mod_phase1&link_ref_id=$link_ref_id&\$ref_name=$ref_name&\$ref_type=$ref_type&\$dynamic_content_num=$dynamic_content_num";
        
        if ($link_id eq "") {
            ### dynamic ref. type child nodes under webman_component_selector
            
            $dbu->set_Table("webman_" . $app_name . "_link_reference");
            $link_id = $dbu->get_Item("link_id", "link_ref_id", "$link_ref_id");
            
            $dbu->set_Table("webman_" . $app_name . "_link_structure");
            $parent_id = $dbu->get_Item("parent_id", "link_id", "$link_id");
            
            $href_target = "index.cgi?link_name=Link+Structure/Reference&dmisn=1&app_name=$app_name&link_struct_id=$parent_id&child_link_id=$link_id&task=update_ref_phase2_csl&link_ref_id=$link_ref_id&\$ref_name=webman_component_selector&\$ref_type=$ref_type&\$dynamic_content_num=$dynamic_content_num&task_type=set_param&dyna_mod_selector_id=$dyna_mod_selector_id";
            
            ### handle link for recursive webman_component_selector
            $dbu->set_Table("webman_" . $app_name . "_dyna_mod_selector");

            my $dyna_mod_selector_id_parent = $dbu->get_Item("parent_id", "dyna_mod_selector_id", $dyna_mod_selector_id);

            if ($dyna_mod_selector_id_parent ne "") {
                $href_target .= "&task_mode=recursive_csl&parent_id=$dyna_mod_selector_id_parent";
            }             
        }       
        
        
        if ($node_start->get_Text =~ /\.html$/) {
            $this->{tree_html} .= "<font color=\"#00AA00\">" . $node_start->get_Text . "</font>\n";
            
        } elsif ($node_start->get_Text =~ /^webman_main$/) {
            $this->{tree_html} .= "<font color=\"#AAAAAA\">" . $node_start->get_Text . " [<a href=\"$href_target\" title=\"Num. of param. set (click to update)\">$param_set_total</a>]</font>\n";
            
        } elsif ($node_start->get_Text =~ /^webman_/) {
            $this->{tree_html} .= "<font color=\"#FF0000\">" . $node_start->get_Text . " [<a href=\"$href_target\" title=\"Num. of param. set (click to update)\">$param_set_total</a>]</font>\n";
            
        } else {
            $this->{tree_html} .= "<font color=\"#AA0000\">" . $node_start->get_Text . " [<a href=\"$href_target\" title=\"Num. of param. set (click to update)\">$param_set_total</a>]</font>\n";
        }
        
    } else {
        $this->{tree_txt}  .= $node_start->get_Text . "\n";
        
        if ($node_start->{info_hash}->{link_id} > 0) { ### not Root
            $dbu->set_Table("webman_" . $app_name . "_link_reference");
            
            my $link_id = $node_start->{info_hash}->{link_id};
            my $parent_id = $node_start->{info_hash}->{parent_id};
            
            my $ref_total = $dbu->count_Item("link_id", $link_id);
            
            my $href_target = "index.cgi?link_name=Link+Structure/Reference&dmisn=1&app_name=$app_name&link_struct_id=$parent_id&&child_link_id=$link_id&task=update_ref_phase1";
            
            $this->{tree_html} .= "<font color=\"#0000FF\">" . $node_start->get_Text . "[<a href=\"$href_target\" title=\"Num. of ref. added (click to update)\">$ref_total</a>]</font>\n";
            
        } else { ### the Root         
            $this->{tree_html} .= "<font color=\"#0000FF\">" . $node_start->get_Text . "</font>\n";
        }
    }
    
    my $newline = $this->get_indent_newline($node_start);
    $this->{tree_txt}  .= $newline;
    $this->{tree_html} .= $newline;

    
    my @node_childs = $node_start->get_Childs;
    
    foreach my $item (@node_childs) {
        $this->traverse_node($item, $newline);
    }
}

sub get_indent {
    my $this = shift @_;
    
    my $node = shift @_;
    my $prev_newline = shift @_;
    
    if ($prev_newline) {
        $prev_newline = substr($prev_newline, 0, length($prev_newline) - 5);
        
        if ($node->{type} eq "reference") {
            return $prev_newline . "|---";
            
        } else {
            return $prev_newline . "|---";
        }
    } else {
        return "";
    }
}

sub get_indent_newline {
    my $this = shift @_;
    
    my $node = shift @_;
  
    my $indent_str = "";
    
    ### trace node's path
    my @node_path = ($node);
    my $node_parent = $node->get_Parent;
    
    while ($node_parent) {
        push(@node_path, $node_parent);
        $node_parent = $node_parent->get_Parent;
    }
        
    my $max_idx = @node_path - 1;
    
    for (my $i = $max_idx; $i > -1 ; $i--) { ### trace node's path from root
        #print "$i=" . $node_path[$i]->get_Text;
        
        my $char = " ";
        
        if ($i == 0) { ### the end of the path
            my $childs = $node_path[$i]->get_Childs;
            
            if ($childs) {
                $char = "|";
            }
           
        } else {
            my $node_next_sibling = $node_path[$i - 1]->get_Next_Sibling;
            
            if ($node_next_sibling) {
                $char = "|";            
            }
        }
        
        $indent_str .= "$char   ";
    }


    $indent_str .= "\n";
    
    return $indent_str;
}

1;