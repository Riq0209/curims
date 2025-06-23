package webman_db_item_view_dynamic;

use webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
    my $class = shift @_;
        
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{template_default} = undef;
    
    $this->{sql_debug} = undef;
    
    $this->{sql} = undef;
    $this->{table_name} = undef; ### 21/12/2010
    
    ### 21/12/2010
    $this->{filter_field_name} = undef; 
    $this->{filter_field_cgi_var} = undef;
    $this->{filter_field_additional_keystr} = undef;    
    
    $this->{order_field_cgi_var} = undef;
    $this->{order_field_caption} = undef;
    $this->{order_field_name} = undef;
    $this->{map_caption_field} = undef;
    
    $this->{row_num_text_pattern} = undef;
    
    $this->{default_order_field_selected} = 0;
    
    $this->{order_icon_asc} = undef;
    $this->{order_icon_desc} = undef;

    $this->{list_selection_num} = undef;
    $this->{db_items_set_num} = undef;
    $this->{db_items_view_num} = undef;
    
    ### 30/10/2007
    $this->{inl_var_name} = "inl";
    $this->{lsn_var_name} = "lsn";
    
    $this->{dynamic_menu_items_set_number_var} = undef;
    $this->{db_items_set_number_var} = undef;    
    
    $this->{link_color_selected_order} = undef;
    $this->{link_color_selected_set_num} = undef;
    
    $this->{link_color_unselected_order} = undef;
    $this->{link_color_unselected_set_num} = undef;
    
    $this->{link_path_level_start} = undef; ### 06/02/2008
    $this->{link_path_level_deep} = undef;
    $this->{link_path_separator_tag} = undef;
    $this->{link_path_unselected_color} = undef;
    $this->{link_path_additional_get_data} = undef; ### 01/01/2009
    
    $this->{carried_previous_get_data} = undef; ### 16/12/2010
    
    $this->{additional_get_data} = undef;
    $this->{additional_hidden_post_data} = undef;
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 05/01/2009
    $this->{remove_db_cache_cgi_var} = undef; ### 31/12/2008
    
    ### 19/112017
    $this->{paginate_previous_tag} = undef;
    $this->{paginate_separator_tag} = undef;
    $this->{paginate_next_tag} = undef;
    
    $this->{escape_HTML_tag} = undef; ### 15/08/2024
    
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

sub set_Template_Default {
    my $this = shift @_;
    
    $this->{template_default} = shift @_;
}

sub set_DBI_App_Conn {
    my $this = shift @_;
    
    $this->{dbi_app_conn} = shift @_;
}

sub set_SQL_Debug {
    my $this = shift @_;
    
    $this->{sql_debug} = shift @_;
}

sub set_SQL {
    my $this = shift @_;
    
    $this->{sql} = shift @_;
}

sub set_Table_Name { ### 21/12/2010
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Filter_Field_Name { ### 21/12/2010
    my $this = shift @_;
    $this->{filter_field_name} = shift @_;
}

sub set_Filter_Field_CGI_Var { ### 21/12/2010
    my $this = shift @_;
    $this->{filter_field_cgi_var} = shift @_;
}

sub set_Filter_Field_Additional_Keystr { ### 21/12/2010
    my $this = shift @_;
    $this->{filter_field_additional_keystr} = shift @_;
}

sub set_Order_Field_CGI_Var {
    my $this = shift @_;
    
    $this->{order_field_cgi_var} = shift @_;
}

sub set_Order_Field_Caption {
    my $this = shift @_;
    
    $this->{order_field_caption} = shift @_;
}

sub set_Order_Field_Name {
    my $this = shift @_;
    
    $this->{order_field_name} = shift @_;
}

sub set_Map_Caption_Field { ### 20/12/2010
    my $this = shift @_;
    $this->{map_caption_field} = shift @_;
}

sub set_Row_Num_Text_Pattern { ### 23/12/2010
    my $this = shift @_;
   
    $this->{row_num_text_pattern} = shift @_;
}

sub set_Default_Order_Field_Selected {
    my $this = shift @_;
    
    $this->{default_order_field_selected} = shift @_;
}

sub set_List_Selection_Num {
    my $this = shift @_;
    
    $this->{list_selection_num} = shift @_;
}

sub set_DB_Items_Set_Num {
    my $this = shift @_;
    
    $this->{db_items_set_num} = shift @_;
}

sub set_DB_Items_View_Num {
    my $this = shift @_;
    
    $this->{db_items_view_num} = shift @_;
}

sub set_INL_Var_Name {
    my $this = shift @_;
    
    $this->{inl_var_name} = shift @_;
}

sub set_LSN_Var_Name {
    my $this = shift @_;
    
    $this->{lsn_var_name} = shift @_;
}

sub set_Dynamic_Menu_Items_Set_Number_Var {
    my $this = shift @_;
    
    $this->{dynamic_menu_items_set_number_var} = shift @_;
}

sub set_DB_Items_Set_Num_Var {
    my $this = shift @_;
    $this->{db_items_set_number_var} = shift @_;
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

sub set_Carried_Previous_GET_Data {
    my $this = shift @_;
    
    $this->{carried_previous_get_data} = shift @_;
}

sub set_Additional_GET_Data {
    my $this = shift @_;
    
    $this->{additional_get_data} = shift @_;
}

sub set_Additional_Hidden_POST_Data {
    my $this = shift @_;
    
    $this->{additional_hidden_post_data} = shift @_;
}

sub set_Link_Path_Level_Start {
    my $this = shift @_;
    
    $this->{link_path_level_start} = undef;
}

sub set_Link_Path_Level_Deep {
    my $this = shift @_;
    
    $this->{link_path_level_deep} = undef;
}

sub set_Link_Path_Separator_Tag {
    my $this = shift @_;
    
    $this->{link_path_separator_tag} = undef;
}


sub set_Link_Path_Unselected_Color {
    my $this = shift @_;

    $this->{link_path_unselected_color} = undef;
}

sub set_Link_Path_Additional_Get_Data { ### 11/02/2006
    my $this = shift @_;
    
    $this->{link_path_additional_get_data} = shift @_;
}

sub set_Carried_Caller_Get_Data { ### 27/05/2008
    my $this = shift @_;
    
    $this->{carried_caller_get_data} = shift @_;
}

sub get_SQL {
    my $this = shift @_;
        
    return $this->{sql};
}

sub run_Task {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ### 30/11/2007 ##########################################################
    
    $this->{combined_get_data} = undef;
    
    if ($this->{carried_previous_get_data} ne "") {
        my $cpgd = $this->{carried_previous_get_data};
        
        $cpgd =~ s/link_id//;
        $cpgd =~ s/session_id//;
        
        $this->{combined_get_data} = $cgi->generate_GET_Data($cpgd);
    }
    
    if ($this->{additional_get_data} ne "") {
        $this->{combined_get_data} .= "&" . $this->{additional_get_data};
    }
    
    while ($this->{combined_get_data} =~ /\&\&/) {
        $this->{combined_get_data} =~ s/\&\&/\&/g;
    }
    
    $this->{combined_hidden_post_data} = undef;
    
    my @hidden_post_data = split(/\&/, $this->{additional_hidden_post_data});
    
    foreach my $item (@hidden_post_data) {
        my @hidden_param_val = split(/=/, $item);
        
        $hidden_param_val[1] = $cgi->convert_GET_Format_CodeToChar($hidden_param_val[1]);
        $this->{combined_hidden_post_data} .= "<input type=\"hidden\" name=\"$hidden_param_val[0]\" value=\"$hidden_param_val[1]\">\n";
    }    
    
    ### 16/11/2007 ##########################################################
    
    my $def_ofs = $this->{default_order_field_selected};
    #$cgi->add_Debug_Text("\$def_ofs = $def_ofs", __FILE__,__LINE__, "TRACING");;

    if ($cgi->param($this->{order_field_cgi_var}) eq "") {

        my @order_fields = split(/:/, $this->{order_field_name});

        if (!$cgi->set_Param_Val($this->{order_field_cgi_var}, $order_fields[$def_ofs])) {
            $cgi->add_Param($this->{order_field_cgi_var}, $order_fields[$def_ofs]);
            #$cgi->add_Debug_Text("\$order_fields[$def_ofs] = $order_fields[$def_ofs]", __FILE__, __LINE__, "TRACING");;
        }
    }
    
    #########################################################################
    
    if ($this->{order_icon_asc} eq "") {
        $this->{order_icon_asc} = "&uarr;";
    }
    
    if ($this->{order_icon_desc} eq "") {
        $this->{order_icon_desc} = "&darr;";
    }
    
    if ($this->{list_selection_num} eq "") {  ### Should do this even default has been set
        $this->{list_selection_num} = 15;     ### to 15 or the $this->{list_selection_num} 
    }                                         ### variable will not get any value if try to call
                                              ### module name by using variable. eg: $comp = new $comp_name.
                                              ### Also the same for the rest below.
    
    if ($this->{db_items_set_num} eq "") {
        $this->{db_items_set_num} = 1;
    }
    
    if ($this->{db_items_set_number_var} eq "") {
        $this->{db_items_set_number_var} = "dbisn_" . $cgi->param("task");
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
    
    if ($this->{filter_field_name} ne "" && $this->{filter_field_cgi_var} eq "") {
        $this->{filter_field_cgi_var} = "filter_by_" . $this->{filter_field_name};
    }
    
    ### 12/08/2011
    if ($cgi->param($this->{filter_field_cgi_var}) eq "") {
        $cgi->push_Param("$this->{filter_field_cgi_var}", "");
    }
    
    #$cgi->add_Debug_Text("\$this->{list_selection_num} = $this->{list_selection_num}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{db_items_set_num} = $this->{db_items_set_num}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{db_items_set_number_var} = $this->{db_items_set_number_var}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{dynamic_menu_items_set_number_var} = $this->{dynamic_menu_items_set_number_var}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{inl_var_name} = $this->{inl_var_name}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{lsn_var_name} = $this->{lsn_var_name}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{filter_field_cgi_var} = $this->{filter_field_cgi_var}", __FILE__, __LINE__);

    
    my $inl = $cgi->param($this->{inl_var_name});
    my $lsn = $cgi->param($this->{lsn_var_name});
    
    if ($inl < 1) { ### 28/01/2013
        if ($this->{db_items_view_num} > 0) {
            $inl = $this->{db_items_view_num};
            
        } else {
            $inl = 10;
        }
        
        $cgi->push_Param($this->{inl_var_name}, $inl);
        
    } else {
        $this->{db_items_view_num} = $inl;
    }
    
    #if ($inl ne "" and $inl ne $this->{db_items_view_num}) {
    #    $this->{db_items_view_num} = $inl;
    #}
    
    if ($lsn ne "" && !$cgi->is_DB_Cache_Var($this->{lsn_var_name})) { ### 01/01/2009
        $cgi->push_Param($this->{dynamic_menu_items_set_number_var}, $lsn);
    }
    
    my $db_items_set_number = $cgi->param($this->{db_items_set_number_var});
    
    if ($db_items_set_number eq "") {
        $db_items_set_number = $this->{db_items_set_num};
        $cgi->push_Param($this->{db_items_set_number_var}, $db_items_set_number);
    }
    
    ### 13/12/2010 ############################################################
    
    ### The logic below move here from process_LIST. There are requirements to 
    ### get all database item information prior processing the the list template
    
    my $sql = $this->{sql};
    
    if ($this->{table_name} ne "") { ### 21/12/2010
        $sql = "select * from $this->{table_name} ";
        
        if ($this->{filter_field_name} ne "" && 
            $cgi->param($this->{filter_field_cgi_var}) ne "") {
            $sql .= "where $this->{filter_field_name}='\$cgi_" . $this->{filter_field_cgi_var} . "_' "
        }
        
        if ($this->{filter_field_additional_keystr} ne "") {
        
            while ($this->{filter_field_additional_keystr} =~ /^ /) {
                $this->{filter_field_additional_keystr} =~ s/^ //g;
            }
            
            if (!($this->{filter_field_additional_keystr} =~ /^and/i) &&
                !($this->{filter_field_additional_keystr} =~ /^or/i)) {
                
                $this->{filter_field_additional_keystr} = "and " . $this->{filter_field_additional_keystr} . " ";
            }
            
            if (!($sql =~ / where /i)) {
                $sql .= "where ";
                
                $this->{filter_field_additional_keystr} =~ s/^and//i;
                $this->{filter_field_additional_keystr} =~ s/^or//i;
            }
            
            $sql .= $this->{filter_field_additional_keystr};
        }
        
        if ($this->{order_field_cgi_var} ne "") {
            $sql .= "order by \$cgi_" . $this->{order_field_cgi_var} . "_"
        }
    }
    
    #$cgi->add_Debug_Text("\$sql = $sql", __FILE__, __LINE__, "TRACING");

    my $pattern = undef;
    my $replacement = undef;

    my @cgi_var = $cgi->var_Name;

    for (my $i = 0; $i < @cgi_var; $i++) {
        $pattern = "cgi_" . $cgi_var[$i] . "_";

        $replacement = $cgi->param($cgi_var[$i]);

        #$replacement =~ s/'/\\'/g;

        #print "$pattern : $replacement <br>";

        $sql =~ s/\$\b$pattern\b/$replacement/g;
    }
    
    #$cgi->add_Debug_Text("\$sql = $sql", __FILE__, __LINE__, "TRACING");
    
    $this->{sql} = $sql;

    my $db_conn_app = $this->get_DB_Conn_App;

    my $dbihtml = new DBI_HTML_Map;

    if ($db_conn_app ne undef) {
        $dbihtml->set_DBI_Conn($db_conn_app);
    } else {
        $dbihtml->set_DBI_Conn($db_conn);
    }

    if ($this->{db_items_view_num} < 1) { ### 12/12/2010
        $this->{db_items_view_num} = 10   ### 10/06/2025
    }
    
    $this->{sql} = $this->customize_SQL;

    $dbihtml->set_SQL($this->{sql});
    $dbihtml->set_HTML_Code($te_content);
    $dbihtml->set_Items_View_Num($this->{db_items_view_num});
    $dbihtml->set_Items_Set_Num($db_items_set_number);
    
    if ($this->{escape_HTML_tag} ne undef) { ### 15/08/2024
        $dbihtml->set_Escape_HTML_Tag($this->{escape_HTML_tag});
    }

    $this->{tld} = $dbihtml->get_Table_List_Data;
    
    if ($dbihtml->get_DB_Error_Message ne "") {
        $cgi->add_Debug_Text("Database Error: " . $dbihtml->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
    }    

    $this->{sql} = $dbihtml->get_SQL;
    
    if ($this->{sql_debug}) {
        $cgi->add_Debug_Text("SQL = " . $this->{sql}, __FILE__, __LINE__, "DATABASE");
    }

    $this->{db_items_num_total} = $dbihtml->get_Items_Num;
    $this->{total_db_items_set_num} = $dbihtml->get_Total_Items_Set_Num;
    
    $this->{db_items_num_begin} = 1;
        
    if ($db_items_set_number > 1) {
        $this->{db_items_num_begin} = $db_items_set_number * $this->{db_items_view_num} - $this->{db_items_view_num} + 1;
    }
    
    $this->{db_items_num_end} = $db_items_set_number * $this->{db_items_view_num};
    
    if ($this->{db_items_num_end} > $this->{db_items_num_total}) {
        $this->{db_items_num_end} = $this->{db_items_num_end} - ($this->{db_items_num_end} - $this->{db_items_num_total}); 
    }
    
    ### in case of begin list number > total item number  due to CGI variable 
    ### cache from other bigger list set item
    
    if ($this->{db_items_num_begin} > $this->{db_items_num_total}) {
        $this->{db_items_num_begin} = 1;
        $this->{db_items_set_num} = 1;
        
        $cgi->set_Param_Val($this->{db_items_set_number_var}, 1);
              
        $dbihtml->set_Items_Set_Num(1);
        
        $this->{tld} = $dbihtml->get_Table_List_Data;
        
        #if ($dbihtml->get_DB_Error_Message ne "") {
        #    $cgi->add_Debug_Text("Database Error: " . $dbihtml->get_DB_Error_Message, __FILE__, __LINE__, "DATABASE");
        #}        
    }
    
    ### the last one is if there is no item 
    
    if ($this->{db_items_num_total} == 0) {
        $this->{db_items_num_begin} = 0;
    }
    
    ###########################################################################
    
    $this->SUPER::run_Task();
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $this->set_Template_File($this->{template_default});
    
    #print "\$this->{template_default} = " . $this->{template_default} . "<br>";
    #print "\$this->{dbi_app_conn} = " . $this->{dbi_app_conn} . "<br>";
    #print "\$this->{sql} = " . $this->{sql} . "<br>";
    
    
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
    
    ###########################################################################
    
    ### 30/11/2011
    ### The LOC below is no more relevant since the template engine already 
    ### support nested <!-- start_cgihtml_ //-->...<!-- end_cgihtml_ //--> 
    ### coupled tag.
        
    #if ($this->{carried_previous_get_data} ne "") {
    #    my $cgd = $cgi->generate_GET_Data($this->{carried_previous_get_data});
        
    #    $te_content =~ s/\$carried_previous_get_data_/$cgd/g;
    #}
    
    ###########################################################################
    
    ### 27/03/2012
    ### The LOC below should no more relevant since the template engine already
    ### support <!-- start_cgihtml_ //-->...<!-- end_cgihtml_ //--> coupled tag.
    my $db_items_view_num = $this->{db_items_view_num};
    
    my $inl_var_name = $this->{inl_var_name} . "_";
    
    $te_content =~ s/\$$inl_var_name/$db_items_view_num/;
    
    $this->add_Content($te_content);
}

sub process_DATAHTML { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    ### 15/01/2012
    ### This function might be no more required since we already have 
    ### "form_hidden_field" template element name inside process_DYNAMIC    
    if ($te_type_name eq "cgi_data_map") {
        my $data_HTML = new Data_HTML_Map;
        
        $data_HTML->set_CGI($cgi);
        $data_HTML->set_HTML_Code($te_content);
        $data_HTML->set_Special_Tag_View(1); ### can be 0 or 1
        
        $te_content = $data_HTML->get_HTML_Code;
    }
    
    $this->add_Content($te_content);
}

sub process_LIST { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    ### by default the main list can has no name or named as "main"
    if ($te_type_name eq "" || $te_type_name eq "main") { 
    
        ###########################################################################
        
        ### 30/11/2011
        ### The LOC below is no more relevant since the template engine already 
        ### support nested <!-- start_cgihtml_ //-->...<!-- end_cgihtml_ //--> 
        ### coupled tag
        
        #if ($this->{carried_previous_get_data} ne "") {
        #    my $cgd = $cgi->generate_GET_Data($this->{carried_previous_get_data});

        #    $te_content =~ s/\$carried_previous_get_data_/$cgd/g;
        #}

        ###########################################################################    

        my $db_items_set_number = $cgi->param($this->{db_items_set_number_var});

        if ($db_items_set_number eq "") { $db_items_set_number = $this->{db_items_set_num}; }

        #print "\$db_items_set_number = $db_items_set_number <br>";


        if ($this->{db_items_num_total} > 0) {
            my $tld = $this->customize_TLD($this->{tld});
            
            #$cgi->add_Debug_Text($tld->get_Table_List,  __FILE__, __LINE__, "TRACING");

            my $tldhtml = new TLD_HTML_Map;
            
            if ($this->{row_num_text_pattern} ne "") {
                $tldhtml->set_Row_Num_Text_Pattern($this->{row_num_text_pattern});
            }

            $tldhtml->set_Table_List_Data($tld);
            $tldhtml->set_HTML_Code($te_content);

            #$cgi->add_Debug_Text("\$this->{db_items_num_begin} = $this->{db_items_num_begin}", __FILE__, __LINE__);


            $tldhtml->set_Start_Counter($this->{db_items_num_begin});

            my $html_result = $tldhtml->get_HTML_Code;

            my $caller_get_data = $cgi->generate_GET_Data("link_id " . 
                                                          $this->{order_field_cgi_var} . " " . 
                                                          $this->{db_items_set_number_var} . " " .
                                                          $this->{dynamic_menu_items_set_number_var} . " " . 
                                                          $this->{inl_var_name});

            #print "\$caller_get_data = $caller_get_data<br>";

            #$html_result =~ s/\$caller_get_data_/$caller_get_data/g;

            $this->add_Content($html_result);
        }
    }    
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
    
    my $i = 0;
    
    if ($te_type_name eq "caption") {
        my @menu_items = split(/:/, $this->{order_field_caption});
        my @menu_links = split(/:/, $this->{order_field_name});
        
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

            my @spliter = split(/,/, $selected_order_field_name);

            
            for (my $i = 0; $i < @menu_items; $i++) {
                my $counter = 1;
                
                foreach my $field_name (@spliter) {
                    #$cgi->add_Debug_Text("\$field_name = $field_name", __FILE__, __LINE__);
                    #$cgi->add_Debug_Text("\$menu_items[$i] = $menu_items[$i]", __FILE__, __LINE__);
                    #$cgi->add_Debug_Text("$field_name =~ $map_caption_field{$menu_items[$i]}", __FILE__, __LINE__);
                
                    #$cgi->add_Debug_Text("$i - $field_name", __FILE__, __LINE__);
                    
                    if ($field_name =~ /\b$map_caption_field{$menu_items[$i]}\b/ && $map_caption_field{$menu_items[$i]} ne "") {
                        #$cgi->add_Debug_Text("$i - $field_name - $menu_items[$i] - $map_caption_field{$menu_items[$i]} - $selected_order_field_name", __FILE__, __LINE__);
                        
                        my $link_invert = "index.cgi?link_id=" . $cgi->param("link_id") . "&$this->{order_field_cgi_var}=";
                        
                        my $icon = undef;
                        my $sofn = $this->invert_Order_Field($selected_order_field_name);
                        
                        if ($field_name =~ / desc$/) {
                            $icon = "<a href=\"$link_invert$sofn\">$this->{order_icon_desc}</a>";
                            
                        } else {
                            $icon = "<a href=\"$link_invert$sofn\">$this->{order_icon_asc}</a>";
                        }
                        
                        $menu_items[$i] = $menu_items[$i] . " " . $icon . "<sup>$counter</sup>";
                        
                        #$cgi->add_Debug_Text("\$menu_items[$i] = $menu_items[$i]", __FILE__, __LINE__);
                    }
                    
                    #$cgi->add_Debug_Text("\$menu_items[$i] = $menu_items[$i]", __FILE__, __LINE__);
                    
                    $counter++;
                }
            }
        }
                
        #######################################################################        
        
        my %map_fldname_caption = undef;
        
        for (my $i = 0; $i < @menu_links; $i++) {            
            $map_fldname_caption{"$menu_links[$i]"} = $menu_items[$i];
            $menu_links[$i] =~ s/ /+/g;
            $menu_links[$i] = "index.cgi?" . $this->{order_field_cgi_var} . "=$menu_links[$i]";
            
            #$cgi->add_Debug_Text("$menu_items[$i] : $menu_links[$i]", __FILE__, __LINE__);
        }
        
        my $html_menu = new HTML_Link_Menu;
        
        $html_menu->set_CGI($cgi);

        $html_menu->set_Menu_Template_Content($te_content);
        $html_menu->set_Menu_Items(@menu_items);
        $html_menu->set_Menu_Links(@menu_links);
        
        if ($this->{link_color_unselected_order} ne undef) {
            $html_menu->set_Non_Selected_Link_Color($this->{link_color_unselected_order});
        }
        
        if ($cgi->param($this->{order_field_cgi_var}) eq "") {
            $html_menu->set_Active_Menu_Item($menu_items[$this->{default_order_field_selected}]);
            
        } else {
            $html_menu->set_Active_Menu_Item($map_fldname_caption{$cgi->param($this->{order_field_cgi_var})});
        }
        
        my $caller_get_data = $cgi->generate_GET_Data("link_id ");
        #my $caller_get_data = $cgi->generate_GET_Data("link_id session_id ");
        
        $html_menu->add_GET_Data_Links_Source($caller_get_data);
        
        ### 30/11/2011
        if (defined($this->{combined_get_data})) {
            $html_menu->add_GET_Data_Links_Source($this->{combined_get_data});
        }

        $te_content = $html_menu->get_Menu;
        
    } elsif ($te_type_name eq "list") {
    
        my $dmisn = $cgi->param($this->{dynamic_menu_items_set_number_var});
        my $db_items_set_number = $cgi->param($this->{db_items_set_number_var});

        if ($dmisn eq "") { $dmisn = 1; }
        if ($db_items_set_number eq "") { $db_items_set_number = $this->{db_items_set_num}; }

        my $html_menu = new HTML_Link_Menu_Paginate;

        $html_menu->reset_Menu;

        $html_menu->set_Menu_Template_Content($te_content);
        $html_menu->set_Items_View_Num($this->{list_selection_num});
        $html_menu->set_Items_Set_Num($dmisn);
        
        #$cgi->add_Debug_Text("\$this->{total_db_items_set_num} = " . $this->{total_db_items_set_num}, __FILE__, __LINE__);

        for ($i = 1; $i <= $this->{total_db_items_set_num}; $i++) {
            #print "$i ";
            $html_menu->set_Menu_Item("$i");
        }
        
        #print "\$this->{db_items_set_number_var} = " . $this->{db_items_set_number_var} . "<br>\n";

        $html_menu->set_Auto_Menu_Links("index.cgi", $this->{db_items_set_number_var}, $this->{dynamic_menu_items_set_number_var});
        $html_menu->set_Active_Menu_Item($db_items_set_number);
        
        ### 19/112017
        if ($this->{paginate_previous_tag} eq "") { $this->{paginate_previous_tag} = "<<"; }
        if ($this->{paginate_separator_tag} eq "") { $this->{paginate_separator_tag} = "|"; }
        if ($this->{paginate_next_tag} eq "") { $this->{paginate_next_tag} = ">>"; }

        ### 19/112017
        $html_menu->set_Previous_Tag($this->{paginate_previous_tag});
        $html_menu->set_Separator_Tag($this->{paginate_separator_tag});
        $html_menu->set_Next_Tag($this->{paginate_next_tag});
        
        #$cgi->add_Debug_Text($this->{paginate_separator_tag}, __FILE__, __LINE__);
 
        if ($this->{link_color_selected_set_num} ne "") { ### 07/02/2013
            $html_menu->set_Selected_Link_Color($this->{link_color_selected_set_num});
        }

        if ($this->{link_color_unselected_set_num} ne "") { ### 07/02/2013
            $html_menu->set_Non_Selected_Link_Color($this->{link_color_unselected_set_num});
        }

        my $caller_get_data = $cgi->generate_GET_Data("link_id ");
        #my $caller_get_data = $cgi->generate_GET_Data("link_id session_id ");
        
        #print "\$caller_get_data = $caller_get_data <br>\n";
        
        $html_menu->add_GET_Data_Links_Source($caller_get_data);
        
        ### 30/11/2011
        if (defined($this->{combined_get_data})) {
            $html_menu->add_GET_Data_Links_Source($this->{combined_get_data});
        }
        

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

        my $dmisn_total = 0;
        
        if ($this->{list_selection_num} > 0) {
            $dmisn_total = $this->{total_db_items_set_num} / $this->{list_selection_num};

            if ($this->{total_db_items_set_num} % $this->{list_selection_num} != 0) {
                    $dmisn_total++;
                    $dmisn_total = substr($dmisn_total, 0, index($dmisn_total, "."));
            }
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

        my $content = $s_opt->get_Selection;

        $this->add_Content($content);
        
    } elsif ($te_type_name eq $this->{filter_field_cgi_var}) {
        my $sql = "select distinct " . $this->{filter_field_name} . " from " . $this->{table_name} . " order by " . $this->{filter_field_name};
        my $s_opt = new Select_Option;
        
        $s_opt->set_DBI_Conn($db_conn);
        $s_opt->set_Values_From_DBI_SQL($sql);
        $s_opt->set_Options_From_DBI_SQL($sql);
        
        $s_opt->set_Selected($cgi->param($this->{filter_field_cgi_var}));
        
        $this->add_Content($s_opt->get_Selection);
    }
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
    
    if ($te_type_name eq "link_path") {
        my $wmlpg = new webman_link_path_generator;
        
        $wmlpg->set_Template_Default("template_link_path.html");
        #$wmlpg->set_Carried_GET_Data("session_id"); ### all possible get data except link_name & link_id
        $wmlpg->set_Additional_GET_Data($this->{link_path_additional_get_data}); ### 01/01/2009
        $wmlpg->set_Level_Start($this->{link_path_level_start});
        
        if ($this->{link_path_level_deep} < 0) { ### 14/12/2010
            $this->{link_path_level_deep} = $this->get_My_Link_Level;
        }
        
        $wmlpg->set_Level_Deep($this->{link_path_level_deep});
        
        if ($this->{link_path_separator_tag} ne "") { ### 14/12/2010
            $wmlpg->set_Separator_Tag($this->{link_path_separator_tag});
        }
        
        if ($this->{link_path_unselected_color} ne "") { ### 14/12/2010
            $wmlpg->set_Non_Selected_Link_Color($this->{link_path_unselected_color});
        }
        
        $wmlpg->set_CGI($cgi);
        $wmlpg->set_DBI_Conn($db_conn);
        
        $wmlpg->set_Link_Path($this->get_Link_Path); ### 04/02/2009
        
        $wmlpg->set_Current_Dynamic_Content_Name($te_type_name); ### 26/05/2011
        $wmlpg->set_Module_DB_Param; ### 26/05/2011
        
        
        $wmlpg->run_Task;
        $wmlpg->process_Content;
        
        my $content = $wmlpg->get_Content;
        
        $this->add_Content($content);
    }
    
    if ($te_type_name eq "db_items_num_total") {
        $this->add_Content($this->{db_items_num_total});
    }
    
    if ($te_type_name eq "db_items_num_begin") {
        $this->add_Content($this->{db_items_num_begin});
    }
    
    if ($te_type_name eq "db_items_num_end") {
        $this->add_Content($this->{db_items_num_end});
    }    
    
    if ($te_type_name eq "form_hidden_field") {
    
        my $hpd = $cgi->generate_Hidden_POST_Data("link_id");
        #my $hpd = $cgi->generate_Hidden_POST_Data("link_id session_id ");
                                   
        if (defined($this->{combined_hidden_post_data})) {
            $hpd .= $this->{combined_hidden_post_data};
        }
        
        $this->add_Content($hpd);
    }
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    
    $this->add_Content($te_content);
}

sub get_Content { ### 27/05/2008
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
    my $cgd = $cgi->generate_GET_Data("link_id " . $this->{carried_caller_get_data});
    #my $cgd = $cgi->generate_GET_Data("link_id session_id " . $this->{carried_caller_get_data});
    
    $this->{content} =~ s/\$caller_get_data_/$cgd/g;
    
    $this->SUPER::get_Content();
}

sub get_DB_Conn_App {
    my $this = shift @_;
    
    if ($this->{dbi_app_conn} ne "") {
        
        my @spliters = split(/ /, $this->{dbi_app_conn});
        
        my $db_conn = DBI->connect("DBI:$spliters[0]:dbname=$spliters[1]", "$spliters[2]", "$spliters[3]");
        
        return $db_conn;
    }
    
    return undef;
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    $tld->add_Column("row_color");
        
    my $row_color = "#FFFFFF";
        
    for ($i = 0; $i < $tld->get_Row_Num; $i++) { 
        $tld->set_Data($i, "row_color", "$row_color");
    }
    
    return $tld;
}

sub customize_SQL {
    my $this = shift @_;

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    ### ???
    
    return $sql;
}

sub refine_Caption_Field_Text {
    my $this = shift @_;
    
    my $text = shift @_;
    
    $text =~ s/^ //;
    $text =~ s/ $//;
    
    while ($text =~ /  /) { $text =~ s/  / /g; }
    
    return $text;
}

sub invert_Order_Field { ### 22/05/2013
    my $this = shift @_;
    
    my $sofn = shift @_;
    my $sofn_new = undef;
    
    my @field_orders = split(/,/, $sofn);
    
    foreach my $field_order (@field_orders) {
        $field_order =~ s/^ //;
        $field_order =~ s/ $//;
        
        if ($field_order =~ / desc$/) {
            $field_order =~ s/ desc$//;
            
        } else {
            $field_order = "$field_order desc";
        }
        
        $sofn_new .= $field_order . ", ";
    }
    
    $sofn_new =~ s/, $//;
    $sofn_new =~ s/ /\+/g;
    
    return $sofn_new
}

1;
