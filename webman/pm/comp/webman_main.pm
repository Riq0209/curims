package webman_main;

use webman_CGI_component;

@ISA=("webman_CGI_component");

### standard webman modules
use webman_dynamic_links;
use webman_static_links;
use webman_image_map_links;

use webman_db_item_insert;
use webman_db_item_insert_multirows;

use webman_db_item_update;
use webman_db_item_update_multirows;

use webman_db_item_delete;
use webman_db_item_delete_multirows;

use webman_db_item_view;
use webman_db_item_view_dynamic;

use webman_db_item_search;

use webman_calendar;
use webman_calendar_interactive;
use webman_calendar_week_list;
use webman_calendar_weekly;
use webman_calendar_weekly_timerow;

use webman_link_path_generator;

use webman_component_selector;

use webman_HTML_printer; ### 09/07/2009

use webman_user_agent; ### 13/04/2011

use webman_JSON; ### 03/05/2011
use webman_JSON_authentication; ### 03/05/2011

use webman_sitemap; ### 18/02/2013

use webman_FTP_upload; ### 01/11/2013
use webman_FTP_list; ### 01/11/2013

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    $this->{sub_component} = undef;
    $this->{debug_component} = undef;
    
    $this->{trim_html_start} = undef;
    $this->{trim_html_end} = undef;
    
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

### Override the original one in webman_CGI_component to fulfill the roles as 
### a main controller 
sub set_Module_DB_Param {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    my $app_name = $this->get_Application_Name;
    
    my $clicked_link_id = $cgi->param("link_id");
    my $current_dyna_cont_num = -1;
    
    #$cgi->add_Debug_Text("Try to set local & global DB param for web_main_main", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$clicked_link_id = $clicked_link_id - \$current_dyna_cont_num = $current_dyna_cont_num", __FILE__, __LINE__, "LOGIC");
    
    my $pre_table_name = "webman_" . $app_name . "_"; #print "\$pre_table_name = $pre_table_name <br>";
    
    my $link_ref_id = undef;
    
    
    my $dbu = new DB_Utilities;
    my $dbu2 = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu2->set_DBI_Conn($db_conn); ### option 1
    
    my $i = 0;
    my $j = 0;
    my @array_hash_ref = undef;
    
    ############################################################################
        
    #print "Try to get global parameter from DB <br>\n";

    $dbu->set_Table($pre_table_name . "dyna_mod_param_global");
    
    @array_hash_ref = $dbu->get_Items("param_name param_value", 
                                      "dyna_mod_name dynamic_content_num", 
                                      "webman_main $current_dyna_cont_num");
                                      
    #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
                                  
    for ($i = 0; $i < @array_hash_ref; $i++) {
        #$cgi->add_Debug_Text($array_hash_ref[$i]->{param_name} . " = " . $array_hash_ref[$i]->{param_value}, __FILE__, __LINE__);
        $this->{$array_hash_ref[$i]->{param_name}} = $array_hash_ref[$i]->{param_value};
    }
                  
    ############################################################################
    
    #print "Try to get local parameter from DB for $pre_table_name <br>\n";
    
    my @link_path = $this->get_Link_Path;
    
    for ($i = 0; $i < @link_path; $i++) {
        my ($link_id, $link_name) = %{$link_path[$i]};
        
        #print "*** link_id = $link_id, link_name = $link_name <br>\n";
    
        
        $dbu->set_Table($pre_table_name . "link_reference");
        
        $link_ref_id = $dbu->get_Item("link_ref_id", 
                                      "link_id dynamic_content_num", 
                                      "$link_id $current_dyna_cont_num", "1");
                                      
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);

        #print "\$current_dyna_cont_num = $current_dyna_cont_num <br>";
        #print "\$link_id = $link_id <br>";
        #print "\$link_ref_id = $link_ref_id - \$i = $i<br>";

        if ($link_ref_id ne "") {
            $dbu->set_Table($pre_table_name . "dyna_mod_param");

            @array_hash_ref = $dbu->get_Items("param_name param_value", "link_ref_id", "$link_ref_id");

            for ($j = 0; $j < @array_hash_ref; $j++) {
                #$cgi->add_Debug_Text($array_hash_ref[$j]->{param_name} . " = " . $array_hash_ref[$j]->{param_value}, __FILE__, __LINE__);
                $this->{$array_hash_ref[$j]->{param_name}} = $array_hash_ref[$j]->{param_value};
            }
        }
    }
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    
    $this->SUPER::run_Task();
    
    #$cgi->add_Debug_Text("run_Task: ". $this->get_Name_Full, __FILE__, __LINE__);
}

sub run_Sub_Component { ### 29/04/2011
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    
    ### top-down structure of active link path that has/hasn't have a reference
    my @link_path = $this->get_Link_Path;
    
    ### bottom-up structure of active link path that has have a reference
    my @link_content_info = $this->get_Link_Content_Info;
    
    my $link_ref_name = $link_content_info[0]->get_Link_Ref_Name;
    my $link_level = $link_content_info[$i]->get_Link_Level;
    
    if ($this->{sub_component} ne "") {
        my $component = new $this->{sub_component};

        $component->set_CGI($cgi);
        $component->set_DBI_Conn($db_conn);
        
        $component->set_Link_Path(@link_path); ### 04/02/2009
        $component->set_My_Link_Level($link_level);        
        $component->set_Module_DB_Param($this->{sub_component});

        $component->run_Task;
        $component->process_Content;
        
        my $link_path_info = undef;
        
        foreach my $item (@link_path) {
            my ($key, $val) = %{$item};
            
            $link_path_info .= "[$key] $val - ";
        }
        
        #$cgi->add_Debug_Text("\$link_path_info = $link_path_info : $link_ref_name - $link_level", __FILE__, __LINE__);
        
        return $component;
    }
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #$cgi->add_Debug_Text("\$this->{template_default} = " . $this->{template_default}, __FILE__, __LINE__);
    
    $this->SUPER::process_Content;  
}

sub process_VIEW { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
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
    
    my $language = $cgi->param("language");
    
    if ($language eq "") {
        $language = "ENGLISH";
    }
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name link_id dmisn app_name");
    
    my @menu_items = ("MALAY", "ENGLISH");

    my @menu_links = ("index.cgi?language=MALAY", "index.cgi?language=ENGLISH");
    
    my $html_menu = new HTML_Link_Menu;

    $html_menu->set_Menu_Template_Content($te_content);
    $html_menu->set_Menu_Items(@menu_items);
    $html_menu->set_Menu_Links(@menu_links);
    $html_menu->add_GET_Data_Links_Source($caller_get_data);
    $html_menu->set_Active_Menu_Item($language);

    $te_content = $html_menu->get_Menu;
    
    $this->add_Content($te_content);
}

sub process_DYNAMIC { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    ### top-down structure of active link path that has/hasn't have a reference
    my @link_path = $this->get_Link_Path;
    
    ### bottom-up structure of active link path that has have a reference
    my @link_content_info = $this->get_Link_Content_Info;
    
    my $lci_num = @link_content_info;
    
    my $link_id = $this->get_Current_Link_ID;
    my $link_name = $this->get_Current_Link_Name;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name; ### 08/01/2009
    
    #$cgi->add_Debug_Text("\$te_type_name = $te_type_name", __FILE__, __LINE__);
    
    
    my $app_name = $cgi->param("app_name");
    my $pre_table_name = "webman_" . $app_name . "_";
        
    my $link_path_num = @link_path;
    
    my $content = $te_content;
    
    my $comp_name = undef;
    my $dynamic_content_num = undef;
    my $dynamic_content_name = undef; ### 08/01/2009
    my $link_ref_type = undef;
    my $link_ref_name = undef;
    my $blob_content_id = undef;
    my $link_level = undef;
    my $link_id = undef;
    my $link_ref_id = undef;
    
    my $component = undef;


    #$this->print_Link_Path_Info;
    
    #$cgi->add_Debug_Text("\$lci_num = $lci_num", __FILE__, __LINE__);
    
    if ($this->{sub_component} ne "") {
        my $component = $this->run_Sub_Component($this->{sub_component});

        $content = $component->get_Content;
        
        #$cgi->add_Debug_Text("comp. name = " . $component->get_Name_Full, __FILE__, __LINE__);
            
    } elsif ($lci_num > 0) {
        my $i = 0;
        
        my $dbu = new DB_Utilities;
        
        $dbu->set_DBI_Conn($db_conn);
        
        $dbu->set_Table($pre_table_name . "blob_content");
        
        for ($i = 0; $i < @link_content_info; $i++) {
            $dynamic_content_num = $link_content_info[$i]->get_Dynamic_Content_Num;
            $dynamic_content_name = $link_content_info[$i]->get_Dynamic_Content_Name; ### 08/01/2009
            
            $link_ref_type = $link_content_info[$i]->get_Link_Ref_Type;
            $link_ref_name = $link_content_info[$i]->get_Link_Ref_Name;
            $blob_content_id = $link_content_info[$i]->get_Blob_Content_ID;
            $link_level = $link_content_info[$i]->get_Link_Level;
            $link_id = $link_content_info[$i]->get_Link_ID;
           
            #$cgi->add_Debug_Text($i . ". LINK_REF_NAME = $link_ref_name", __FILE__, __LINE__);
            
            my $match_by_name = 0;
            my $match_by_num = 0;
            
            $dbu->set_Table($pre_table_name . "link_reference");
            
            ### dynamic content template match by name will have a  
            ### privilege over dynamic content template match by number
            if ($te_type_name ne "" && $te_type_name eq $dynamic_content_name) { ### 22/01/2009
                $match_by_name = 1;
                
                $link_ref_id = $dbu->get_Item("link_ref_id", 
                                              "link_id dynamic_content_name", "$link_id $dynamic_content_name", "1");                
                
            } elsif ($te_type_num == $dynamic_content_num) {
                $match_by_num = 1;
                
                $link_ref_id = $dbu->get_Item("link_ref_id", 
                                              "link_id dynamic_content_num", "$link_id $dynamic_content_num", "1");
            }
            
            #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
            
            if ($match_by_name || $match_by_num) {
                
                if ($link_ref_type eq "DYNAMIC_MODULE" && $link_ref_name ne "webman_main") {
                    #$link_content_info[$i]->print_My_Info;
                    #print " match dynamic_content_num = $dynamic_content_num for DYNAMIC_MODULE:$link_ref_name with link level = $link_level<br>";

                    $link_ref_name =~ s/.pm//;
                    
                    #$cgi->add_Debug_Text("\$link_ref_name = $link_ref_name, \$link_id = $link_id, \$login_name = $login_name", __FILE__, __LINE__, "TRACING");
                    
                    if ($this->{debug_component}) {
                        $cgi->add_Debug_Text("Component name: $link_ref_name, Dynamic template name: $te_type_name", __FILE__, __LINE__,"DEBUG_COMP");
                    }
                    
                    #$cgi->add_Debug_Text("Component name: $link_ref_name - [$link_id - $link_ref_id], Dynamic template name: $te_type_name", __FILE__, __LINE__,"DEBUG_COMP");

                    ### Default is to run each link-node's 
                    ### attached modules  
                    my $run = 1;
                    
                    ### Special handling case for "webman_component_selector" module.
                    if ($link_ref_name eq "webman_component_selector") {
                        ### Assume there is no match CGI param and value for current 
                        ### attached "webman_component_selector" module.
                        $run = 0;
                        
                        $dbu->set_Table($pre_table_name . "dyna_mod_selector");
                        
                        my @ahr = $dbu->get_Items("cgi_param cgi_value", "link_ref_id", "$link_ref_id");
                        
                        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
                        
                        foreach my $item (@ahr) {
                            $paramvalue_keys{$item->{cgi_param}-$item->{cgi_value}} = 1;
                            
                            #$cgi->add_Debug_Text("$item->{cgi_param}-$item->{cgi_value}", __FILE__, __LINE__);
                            
                            if ($cgi->param($item->{cgi_param}) eq $item->{cgi_value}) {
                                ### There is match CGI param and value for current
                                ### attached "webman_component_selector" module.
                                $run = 1;
                                last;
                            }
                        }
                    }
                    
                    if ($run) {
                        $component = new $link_ref_name;

                        $component->set_Caller_Module_Name($this->get_Name);

                        $component->set_CGI($cgi);
                        $component->set_DBI_Conn($db_conn);
                        $component->set_Current_Dynamic_Content_Num($te_type_num);
                        $component->set_Current_Dynamic_Content_Name($te_type_name);

                        $component->set_Link_Path(@link_path); ### 04/02/2009
                        $component->set_My_Link_Level($link_level);

                        $component->set_Module_DB_Param;
                        #$component->set_Module_DB_Param($link_ref_name);

                        ######################################################################################################

                        if ($component->auth_Link_Path && $component->authenticate) { ### 30/05/2011 ### 06/01/2012

                            $component->run_Task;
                            $component->process_Content;
                            $component->end_Task; ### 17/01/2011

                        } else { ### 01/06/2011
                            ### stop the loop from running the next component  
                            ### beneath the current processed link
                            $i = @link_content_info;
                        }

                        $content = $component->get_Content;

                        #$cgi->add_Debug_Text("\$content = $content", __FILE__, __LINE__);
                        #$cgi->add_Debug_Text("Comp. Full Name: " . $component->get_Name_Full, __FILE__, __LINE__);
                    }

                } elsif ($link_ref_type eq "STATIC_FILE") {
                    #$cgi->add_Debug_Text($link_content_info[$i]->print_My_Info, __FILE__, __LINE__);
                    #$cgi->add_Debug_Text("match dynamic_content_num = $dynamic_content_num for STATIC_FILE ", __FILE__, __LINE__);
                    #$cgi->add_Debug_Text("$link_ref_type - LINK_REF_NAME = $link_ref_name", __FILE__, __LINE__);
                    #$cgi->add_Debug_Text("\$blob_content_id = $blob_content_id", __FILE__, __LINE__);

                    if ($this->get_BLOB_Content_Prefered_ID ne undef) {
                        $blob_content_id = $this->get_BLOB_Content_Prefered_ID;
                    }

                    if ($blob_content_id ne "") {
                        #my $sc = new Static_Content;

                        $content = $dbu->get_Item("content", "blob_id", $blob_content_id);

                        #$sc->set_Doc_Content($content);
                        #$content = $sc->get_Content;
                        
                        $content = $this->process_BLOB_Dyna_Ref($blob_content_id, $link_level);
                        
                        my $cgi_HTML = new CGI_HTML_Map;

                        $cgi_HTML->set_CGI($cgi);
                        $cgi_HTML->set_HTML_Code($content);
                        $cgi_HTML->set_Escape_HTML_Tag(num_); ### num_ can be 0 or 1

                        $content = $this->customize_STATIC_FILE_Content($blob_content_id, $cgi_HTML->get_HTML_Code);
                    }
                }
            }           
        }   
    } 
    
    $this->add_Content($content);
}

sub get_BLOB_Content_Prefered_ID {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $filename = $cgi->param("filename");
    my $extension = $cgi->param("extension");
    my $owner_entity_id = $cgi->param("owner_entity_id");
    my $owner_entity_name = $cgi->param("owner_entity_name");
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    if ($filename ne "" && $extension ne "" && $owner_entity_id ne "" && 
        $owner_entity_name ne "") {
            
        my $dbu = new DB_Utilities;

        $dbu->set_DBI_Conn($db_conn); ### option 1


        $dbu->set_Table($pre_table_name . "blob_info");

        my $found = $dbu->find_Item("filename extension owner_entity_id owner_entity_name", 
                                    "$filename $extension $owner_entity_id $owner_entity_name");  ### method 1

        if ($found) {
            my $blob_id = $dbu->get_Item("blob_id", 
                                         "filename extension owner_entity_id owner_entity_name", 
                                         "$filename $extension $owner_entity_id $owner_entity_name");
            return $blob_id;

        } else {
            return undef;
        }
        
        } else {
            return undef;
        }
}

sub process_BLOB_Dyna_Ref {
    my $this = shift @_;
    
    my $blob_id = shift @_;
    my $link_level = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $pre_table_name = "webman_" . $cgi->param("app_name") . "_";
    
    $dbu->set_Table($pre_table_name . "blob_content");
    my $blob_content = $dbu->get_Item("content", "blob_id", "$blob_id");
    
    #$dbu->set_Table($pre_table_name . "static_content_dyna_mod_ref");
    #my @array_hash_ref = $dbu->get_Items("scdmr_id dynamic_content_name dyna_mod_name", "blob_id", "$blob_id"); ### method 4
    
    my $tex = new Template_Element_Extractor;
    $tex->set_Doc_Content($blob_content);

    my @te = $tex->get_Template_Element;

    my $content = undef;
    
    foreach my $item (@te) {   
        if ($item->get_Type eq "DYNAMIC") {
            my $type_name = $item->get_Name;
            
            $dbu->set_Table($pre_table_name . "static_content_dyna_mod_ref");
            
            my $component_name  = $dbu->get_Item("dyna_mod_name", "blob_id dynamic_content_name", "$blob_id $type_name");
            
            my $scdmr_id = $dbu->get_Item("scdmr_id", "blob_id dynamic_content_name", "$blob_id $type_name");

            #$cgi->add_Debug_Text("\$component_name = $component_name - $scdmr_id <br>", __FILE__, __LINE__);

            if ($component_name ne "") {
                $component = new $component_name;

                $component->set_CGI($cgi);
                $component->set_DBI_Conn($db_conn);

                $component->set_My_Link_Level($link_level);
                $component->set_Module_DB_Param_BLOB_Ref($scdmr_id, $component_name);

                $component->run_Task;
                $component->process_Content;

                $content .= $component->get_Content;        
            }
            
        } else {
            $content .= $item->get_Content;
        }
    }
    
    return $content;
}

sub customize_STATIC_FILE_Content { ### 10/02/2013
    my $this = shift @_;
    
    my $blob_id = shift @_;
    my $content = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    return $content;
}

1;
