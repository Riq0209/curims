package webman_sitemap;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
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
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    $this->SUPER::run_Task();
    
    $this->{dbu} = $dbu;
    $this->{app_name} = $cgi->param("app_name");
    
    $this->{node_root} = new Link_Node;
    $this->{node_root}->set_Text("Root");
    $this->{node_root}->{type} = "root";
    
    $this->contruct_link_tree($this->{node_root});
    
    $this->traverse_node($this->{node_root}, undef);
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

sub contruct_link_tree {
    my $this = shift @_;
    
    my $node = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;    
    
    my $app_name = $this->{app_name};
    
    my $dbu = $this->{dbu};
    
    $dbu->set_DBI_Conn($db_conn);
    
    #$cgi->add_Debug_Text($node->{text}, __FILE__, __LINE__);

    if ($node->{type} eq "root") {
        $dbu->set_Table("webman_" . $app_name . "_link_structure");
        my @ahr = $dbu->get_Items("link_id parent_id name", "parent_id name", "0 Home", "sequence");
        
        foreach my $item (@ahr) {
            my $add_child = 1;
            
            $dbu->set_Table("webman_" . $app_name . "_link_auth");
            
            if ($dbu->find_Item("link_id", $item->{link_id})) {
                $add_child = 0;
                
                if ($dbu->find_Item("link_id login_name", "$item->{link_id} $login_name")) {
                    $add_child = 1;
                    
                } else {
                    my @ahr2 = $dbu->get_Items("group_name", "link_id", $item->{link_id});
                    
                    LOOPGRP: foreach my $item2 (@ahr2) {
                        $cgi->add_Debug_Text($item2->{group_name}, __FILE__, __LINE__);
                        
                        if (grep(/^$item2->{group_name}$/, @groups)) {
                            $add_child = 1;
                            last LOOPGRP;
                        }
                    }
                }                
            }
            
            
            if ($add_child) {
                my $node_new = new Link_Node({text => $item->{name}, target => "-", type => "link",
                                             info_hash => {link_id => $item->{link_id}, parent_id => $item->{parent_id}}});
                                          
                $node->add_Child($node_new);
                $this->contruct_link_tree($node_new);
            }
        }       
        
    } elsif ($node->{type} eq "link") {
        ### get other link type child nodes under current $node
        $dbu->set_Table("webman_" . $app_name . "_link_structure");
        my @ahr =  $dbu->get_Items("link_id parent_id name", "parent_id", $node->{info_hash}->{link_id}, "sequence");
        
        foreach my $item (@ahr) {
            my $add_child = 1;
            
            $dbu->set_Table("webman_" . $app_name . "_link_auth");
            
            if ($dbu->find_Item("link_id", $item->{link_id})) {
                $add_child = 0;
                
                if ($dbu->find_Item("link_id login_name", "$item->{link_id} $login_name")) {
                    $add_child = 1;
                    
                } else {
                    my @ahr2 = $dbu->get_Items("group_name", "link_id", $item->{link_id});
                    
                    LOOPGRP: foreach my $item2 (@ahr2) {
                        $cgi->add_Debug_Text($item2->{group_name}, __FILE__, __LINE__);
                        
                        if (grep(/^$item2->{group_name}$/, @groups)) {
                            $add_child = 1;
                            last LOOPGRP;
                        }
                    }
                }
            }            
            
            if ($add_child) {
                my $node_new = new Link_Node({text => $item->{name}, target => "-", type => "link",
                                              info_hash => {link_id => $item->{link_id}, parent_id => $item->{parent_id}}});
\
                $node->add_Child($node_new);

                #$cgi->add_Debug_Text($node_new->{text}, __FILE__, __LINE__);

                $this->contruct_link_tree($node_new);
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
    
    
    $this->{tree_txt}  .= $node_start->get_Text . "\n";

    if ($node_start->{info_hash}->{link_id} > 0) { ### not Root
        $dbu->set_Table("webman_" . $app_name . "_link_reference");

        my $link_id = $node_start->{info_hash}->{link_id};

        my $href_target = "index.cgi?link_id=$link_id";

        $this->{tree_html} .= "<a href=\"$href_target\">" . $node_start->get_Text . "</a>\n";

    } else { ### the Root
        $this->{tree_html} .= "<b>" . $node_start->get_Text . "</b>\n";
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