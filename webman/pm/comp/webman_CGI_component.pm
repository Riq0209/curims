package webman_CGI_component;

use CGI_Component;

@ISA=("CGI_Component");

use Link_Structure_Content_Info;

sub new {
    my $class = shift @_;
    
    my $this = $class->SUPER::new();

    #$this->set_Debug_Mode(1, 1);
    
    $this->{my_link_level} = 0;
    
    $this->{my_link_id} = undef;
    $this->{my_link_name} = undef;
    
    $this->{current_link_id} = undef;
    $this->{current_link_name} = undef;
    
    $this->{parent_link_id} = undef;
    
    $this->{link_path} = undef;
    $this->{link_content_info} = undef;
    
    $this->{current_dynamic_content_num} = undef;
    $this->{current_dynamic_content_name} = undef;
    
    $this->{app_name} = undef;
    
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
    
    $this->SUPER::run_Task();
    
    #print "<font color=\"#00FF00\">run_Task from webman_CGI_component</font><br>\n";

    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    #$cgi->add_Debug_Text($this->get_Name_Full, __FILE__, __LINE__);
}

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    ###########################################################################
    
    my $manual_assigned = 0;
    my $template_warning = undef;
    my $template_warning_cust = undef;
    
    #$cgi->add_Debug_Text("\$this->{template_default} = $this->{template_default}", __FILE__, __LINE__);

    if ($this->{template_default} ne "") {
        $manual_assigned = 1;
        $this->{template_file} = $this->{template_default};
    }
    
    if ($this->{template_file} eq "") { ### this is one of the CoC elements inside the framework ;-)   
        $this->{template_file} = "template_" . $this->get_Name . ".html";
    }
    
    if (not -e $this->{template_file}) {
        $template_warning = "<b>./$this->{template_file}</b>";
        
        if ($manual_assigned) {
            $template_warning_cust = "<b>./$this->{template_file}</b>";
        }
        
        $this->{template_file} = "./" . $this->get_Name . ".html"; ### 2nd option of CoC of template naming
        
        if (not -e $this->{template_file}) { ### still not exist for 2nd option of CoC
            $template_warning .= " or <b>$this->{template_file}</b>";
            
        } else {
            $template_warning = undef;
        }
    } 
    
    if (defined($template_warning)) {
        my $warning_text  = "Warning for module [<b>" . $this->get_Name . ".pm</b>]. ";
           $warning_text .= "Template file: " . $template_warning . " was not found. ";
           $warning_text .= "Use <b>./template_default.html</b> as a default template file.";
        
        $cgi->add_Debug_Text($warning_text, __FILE__, __LINE__, "TEMPLATE");
        
        $this->{template_file} = "./template_default.html";
        
    } elsif (defined($template_warning_cust)) {
        my $warning_text  = "Warning for module [<b>" . $this->get_Name . ".pm</b>]. ";
           $warning_text .= "Template file: " . $template_warning_cust . " was not found. ";
           $warning_text .= "Use <b>$this->{template_file}</b> as a default template file.";
        
        $cgi->add_Debug_Text($warning_text, __FILE__, __LINE__, "TEMPLATE");    
    }    
    
    ###########################################################################
    
    $this->SUPER::process_Content;
}

sub set_Module_DB_Param {
    my $this = shift @_;
    
    my $current_comp_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $my_link_id = $this->get_My_Link_ID;
    my $current_dyna_cont_num = $this->get_Current_Dynamic_Content_Num;
    my $current_dyna_cont_name = $this->get_Current_Dynamic_Content_Name;
    
    #$cgi->add_Debug_Text("\$my_link_id = $my_link_id - \$current_dyna_cont_name = $current_dyna_cont_name", __FILE__, __LINE__);
    
    my $pre_table_name = "webman_" . $this->get_Application_Name . "_";
    
    my $link_ref_id = undef;
    my $dyna_mod_selector_id = undef;
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    
    my $i = 0;
    my @array_hash_ref = undef;
        
    ############################################################################
        
    #print "Try to get global parameter from DB <br>";
    
    if ($current_comp_name eq "") { ### 26/05/2011
        $current_comp_name = $this->get_Name; ### return the last child component name
        
        #$cgi->add_Debug_Text("\$current_comp_name = $current_comp_name", __FILE__, __LINE__, "TRACING");
        #$cgi->add_Debug_Text("\$current_dyna_cont_name = $current_dyna_cont_name", __FILE__, __LINE__, "TRACING");
    }

    $dbu->set_Table($pre_table_name . "dyna_mod_param_global");
    
    #print "\$current_dyna_cont_num = $current_dyna_cont_num - \$current_dyna_cont_name = $current_dyna_cont_name <br>\n";
    
    if ($current_dyna_cont_name ne "" && $dbu->find_Item("dyna_mod_name dynamic_content_name", "$current_comp_name $current_dyna_cont_name")) { ### 15/01/2009
        @array_hash_ref = $dbu->get_Items("param_name param_value", 
                                          "dyna_mod_name dynamic_content_name", 
                                          "$current_comp_name $current_dyna_cont_name");
                                          
    } else {
        @array_hash_ref = $dbu->get_Items("param_name param_value", 
                                          "dyna_mod_name dynamic_content_num", 
                                          "$current_comp_name $current_dyna_cont_num");
    
    }
                                  
    for ($i = 0; $i < @array_hash_ref; $i++) {
        #$cgi->add_Debug_Text($array_hash_ref[$i]->{param_name} . " = " . $array_hash_ref[$i]->{param_value}, __FILE__, __LINE__);
        $this->{$array_hash_ref[$i]->{param_name}} = $array_hash_ref[$i]->{param_value};
    }
                  
    ############################################################################
    
    #$cgi->add_Debug_Text("Try to get local parameter from DB for $pre_table_name (link_ref_id)", __FILE__, __LINE__);
    
    $dbu->set_Table($pre_table_name . "link_reference");
    
    if ($current_dyna_cont_name ne "" && $dbu->find_Item("link_id dynamic_content_name", "$my_link_id $current_dyna_cont_name")) { ### 10/01/2009
        $link_ref_id = $dbu->get_Item("link_ref_id", 
                                      "link_id dynamic_content_name", 
                                      "$my_link_id $current_dyna_cont_name");
    } else {
        $link_ref_id = $dbu->get_Item("link_ref_id", 
                                      "link_id dynamic_content_num", 
                                      "$my_link_id $current_dyna_cont_num");    
    }

                      
    #$cgi->add_Debug_Text("\$link_ref_id = $link_ref_id ", __FILE__, __LINE__);

    if ($link_ref_id ne "") { 
        $dbu->set_Table($pre_table_name . "dyna_mod_param");

        @array_hash_ref = $dbu->get_Items("param_name param_value", "link_ref_id", "$link_ref_id");

        my $param_var_name = undef;

        for ($i = 0; $i < @array_hash_ref; $i++) {
            #$cgi->add_Debug_Text($array_hash_ref[$i]->{param_name} . " = " . $array_hash_ref[$i]->{param_value}, __FILE__, __LINE__);
            $this->{$array_hash_ref[$i]->{param_name}} = $array_hash_ref[$i]->{param_value};
        }
    }
    
    ############################################################################
    
    #print "Try to get local parameter from DB for $pre_table_name (dyna_mod_selector_id)<br>";  
    
    $dbu->set_Table($pre_table_name . "dyna_mod_selector");
    
    my $item = undef;
    my $cgi_param_name_db = undef;
    my $cgi_param_value_db = undef;
    
    my @ahr = $dbu->get_Items("cgi_param cgi_value dyna_mod_name", "link_ref_id",  "$link_ref_id");
    
    #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__);
    
    ### determine webman dynamic module name to be choosed by comparing
    ### CGI parameter name & value from DB and current state  
    CGI_PARAM_VALUE:foreach $item (@ahr) {        
        $cgi_param_name_db = $item->{cgi_param};
        $cgi_param_value_db = $item->{cgi_value};
        
        #$cgi->add_Debug_Text("$cgi_param_name_db = $cgi_param_value_db : " . $cgi->param($cgi_param_name_db), __FILE__, __LINE__);
        
        if ($cgi_param_value_db eq $cgi->param($cgi_param_name_db)) {
            #$cgi->add_Debug_Text("\$cgi_param_name_db = $cgi_param_name_db and \$cgi_param_value_db = $cgi_param_value_db", __FILE__, __LINE__);


            $dyna_mod_selector_id = $dbu->get_Item("dyna_mod_selector_id", 
                                                   "link_ref_id cgi_param cgi_value dyna_mod_name", 
                                                   "$link_ref_id $cgi_param_name_db $cgi_param_value_db $current_comp_name");

            #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__);

            #$cgi->add_Debug_Text("\$dyna_mod_selector_id = $dyna_mod_selector_id", __FILE__, __LINE__);

            if ($dyna_mod_selector_id ne "") { 
                $dbu->set_Table($pre_table_name . "dyna_mod_param");

                @array_hash_ref = $dbu->get_Items("param_name param_value", "dyna_mod_selector_id", "$dyna_mod_selector_id");

                my $param_var_name = undef;

                for ($i = 0; $i < @array_hash_ref; $i++) {
                    #$cgi->add_Debug_Text($array_hash_ref[$i]->{param_name} . " = " . $array_hash_ref[$i]->{param_value}, __FILE__, __LINE__);
                    $this->{$array_hash_ref[$i]->{param_name}} = $array_hash_ref[$i]->{param_value};
                }
            }     
            
            #last CGI_PARAM_VALUE;
        }
    }
    
    ############################################################################
    
    #$current_comp_name = $this->get_Component_Name;
        
    #print "\$current_comp_name = $current_comp_name <br>";
}

sub set_Module_DB_Param_BLOB_Ref {
    my $this = shift @_;
    
    my $scdmr_id = shift @_;
    my $component_name = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $pre_table_name = "webman_" . $this->get_Application_Name . "_";
    
    #print "Try to get local parameter from DB for $pre_table_name<br>";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    
    $dbu->set_Table($pre_table_name . "dyna_mod_param");
        
    my @array_hash_ref = $dbu->get_Items("param_name param_value", "scdmr_id", "$scdmr_id");

    my $param_var_name = undef;

    for ($i = 0; $i < @array_hash_ref; $i++) {
        #print $array_hash_ref[$i]->{param_name} . " = " . $array_hash_ref[$i]->{param_value} . "<br>";
        $this->{$array_hash_ref[$i]->{param_name}} = $array_hash_ref[$i]->{param_value};
    }
    
}

sub construct_Link_Path {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $link_id = $cgi->param("link_id");
    my $link_name = $cgi->param("link_name");
    my $session_id = $cgi->param("session_id");
    
    my $pre_table_name = "webman_" . $this->get_Application_Name . "_";
    
    #print "\$pre_table_name = $pre_table_name <br>";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 
    
    my @link_path = ();

    my ($i, $counter) = 0;
    
    #$cgi->add_Debug_Text("link_id = $link_id", __FILE__, __LINE__, "TRACING");
    
    if ($link_id eq "") { 
    
        $dbu->set_Table($pre_table_name . "link_structure");
            
        $link_id = $dbu->get_Item("link_id", "parent_id auto_selected", "0 YES"); ### 13/07/2007
        
        #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "TRACING");
        
        if ($link_id eq "") { ### auto selected is not set
            $link_id = $dbu->get_Item("link_id", "sequence parent_id", "0 0");
            $link_name = $dbu->get_Item("name", "sequence parent_id", "0 0");
            
        } else { 
            $link_name = $dbu->get_Item("name", "parent_id auto_selected", "0 YES");
        }
        
        $cgi->add_Param("link_id", $link_id);
        $cgi->add_Param("link_name", $link_name);
        
        #$link_path[$counter] = {$link_id => $link_name};
        #$counter++;
        
        #$cgi->add_Debug_Text("$link_id => $link_name : \$counter = $counter", __FILE__, __LINE__, "TRACING");
            
    }
    
    ### 05/02/2009 ##################################################
    
    $dbu->set_Table($pre_table_name . "cgi_var_cache");
    
    if ($link_id ne "" && $dbu->find_Item("session_id link_id name active_mode", "$session_id $link_id link_id_child 0")) {
        
        #while ($dbu->get_Item("value", "session_id link_id name active_mode", "$session_id $link_id link_id_child 0") ne "") {
        #    $link_id = $dbu->get_Item("value", "session_id link_id name active_mode", "$session_id $link_id link_id_child 0");
            
        #    $cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "DATABASE");
        #}
        
        #$dbu->set_Table($pre_table_name . "link_structure");
                    
        #$link_name = $dbu->get_Item("name", "link_id", "$link_id");
        
        #$cgi->add_Debug_Text("\$end_link_id = $end_link_id", __FILE__, __LINE__, "LOGIC");
        
        #if (!$cgi->set_Param_Val("link_id", $end_link_id)) {
        #    $cgi->add_Param("link_id", $end_link_id);
        #}

        #if (!$cgi->set_Param_Val("link_name", $end_link_name)) {
        #    $cgi->add_Param("link_name", $end_link_name);
        #}

        #$cgi->activate_DB_Cache_Var;        
        
    }
    
    #################################################################
    
    if ($link_id ne "") {
        my $auto_Selected_Link_ID = "";
        my $auto_Selected_Link_ID_Prev = "";
        
        $auto_Selected_Link_ID = $this->get_Link_Child_Auto_Selected($link_id);
        $auto_Selected_Link_ID_Prev = $auto_Selected_Link_ID;
        
        while ($auto_Selected_Link_ID ne "") {
            $auto_Selected_Link_ID = $this->get_Link_Child_Auto_Selected($auto_Selected_Link_ID_Prev);
            
            if ($auto_Selected_Link_ID ne "") {
                $auto_Selected_Link_ID_Prev = $auto_Selected_Link_ID;
            }
        }
        
        $auto_Selected_Link_ID = $auto_Selected_Link_ID_Prev;
        
        #$cgi->add_Debug_Text("link_id = $link_id", __FILE__, __LINE__, "TRACING");
        #$cgi->add_Debug_Text("\$auto_Selected_Link_ID = $auto_Selected_Link_ID", __FILE__, __LINE__, "TRACING");
        
        if ($auto_Selected_Link_ID ne "") {
            $link_id = $auto_Selected_Link_ID;
            
            #$cgi->set_Param_Val("link_id", $link_id);
            
            $dbu->set_Table($pre_table_name . "link_structure");
            
            $link_name = $dbu->get_Item("name", "link_id", "$link_id");
            
            #print " link_id=$link_id<->link_name=$link_name ";
            
        }       
        
        ### 30/01/2009 ##############################################
        my $end_link_id = $link_id; 
        my $end_link_name = $link_name; 

        #print "\$end_link_id = $end_link_id <br>\n";
        #print "\$end_link_name = $end_link_name <br>\n";
        #############################################################


        ### 02/02/2009 ##############################################

        if ($cgi->param("link_id") != $end_link_id) {
            if (!$cgi->set_Param_Val("link_id", $end_link_id)) {
                $cgi->add_Param("link_id", $end_link_id);
            }

            if (!$cgi->set_Param_Val("link_name", $end_link_name)) {
                $cgi->add_Param("link_name", $end_link_name);
            }

            $cgi->activate_DB_Cache_Var;
        }

        #############################################################
        
        
        ### 03/02/2009 ##############################################
        
        my $child_link_id = $link_id;
        
        #$cgi->add_Debug_Text("link_id = $link_id", __FILE__, __LINE__, "TRACING");
        
        $dbu->set_Table($pre_table_name . "link_structure");
        
        my $parent_link_id = $dbu->get_Item("parent_id", "link_id", "$child_link_id");
        
        while ($session_id ne "" && $parent_link_id != 0) {
            #print "Need to record previous active link for parent link id - $parent_link_id with child link id - $child_link_id <br>\n";
            
            $dbu->set_Table($pre_table_name . "cgi_var_cache");
            
            $dbu->delete_Item("session_id link_id name active_mode", "$session_id $parent_link_id link_id_child 0");
            $dbu->insert_Row("session_id link_id name value active_mode", "$session_id $parent_link_id link_id_child $child_link_id 0");
            
            #print $dbu->get_SQL . "<br>\n";
            
            $dbu->set_Table($pre_table_name . "link_structure");
            
            $child_link_id = $parent_link_id;
            $parent_link_id = $dbu->get_Item("parent_id", "link_id", "$child_link_id");
        }
        #############################################################        
        
        #$cgi->add_Debug_Text("link_id = $link_id", __FILE__, __LINE__, "TRACING");
        
        $dbu->set_Table($pre_table_name . "link_structure");
        
        while ($link_id != 0) {
            $link_name = $dbu->get_Item("name", "link_id", "$link_id");
            
            $link_path[$counter] = {$link_id => $link_name};

            $link_id = $dbu->get_Item("parent_id", "link_id", "$link_id");
            
            #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__, "TRACING");
            #$cgi->add_Debug_Text("\$link_id = $link_id : \$link_name = $link_name", __FILE__, __LINE__, "TRACING");
            
            $counter++;
        }
    }
    
    if ($counter > 0) {
        my @temp_link_path = ();
        
        for (my $i = @link_path - 1; $i >= 0; $i--) {
            push(@temp_link_path, $link_path[$i]);
            
            my ($key, $val) = %{$link_path[$i]};
            #$cgi->add_Debug_Text("link_id = $key : link_name = $val", __FILE__, __LINE__, "TRACING");
        }
        
        $this->{link_path} = \@temp_link_path;
    }
}

sub construct_Link_Content_Info {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $link_id = $cgi->param("link_id");
    my $link_name = undef;
    
    my $app_name = $this->get_Application_Name;
    
    my $pre_table_name = "webman_" . $app_name . "_";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my @link_content_info = undef;

    my ($i, $counter, $level_counter, $old_level) = (0, 0, 0, undef);
    my $sth = undef;
    my $db_row = undef;
    
    if ($link_id eq "") { 
        $link_id = $dbu->get_Item("link_id", "sequence parent_id", "0 0");
        $link_name = $dbu->get_Item("name", "sequence parent_id", "0 0");
        
        if (!$cgi->set_Param_Val("link_id", "$link_id")) { $cgi->add_Param("link_id", "$link_id"); }
        if (!$cgi->set_Param_Val("link_name", "$link_name")) { $cgi->add_Param("link_name", "$link_name"); }
        if (!$cgi->set_Param_Val("dmisn", "1")) { $cgi->add_Param("dmisn", "1"); }
        if (!$cgi->set_Param_Val("app_name", "$app_name")) { $cgi->add_Param("app_name", "$app_name"); }
        
        $cgi->add_Debug_Text("\$cgi->param(\"link_id\") = " . $cgi->param("link_id"), __FILE__, __LINE__);
        #print "\$cgi->param(\"link_name\") = " . $cgi->param("link_name") . "<br>";
        #print "\$cgi->param(\"dmisn\") = " . $cgi->param("dmisn") . "<br>";
        #print "\$cgi->param(\"app_name\") = " . $cgi->param("app_name") . "<br>";    
    } 
    
    my $auto_Selected_Link_ID = "";
    my $auto_Selected_Link_ID_Prev = "";

    $auto_Selected_Link_ID = $this->get_Link_Child_Auto_Selected($link_id);
    $auto_Selected_Link_ID_Prev = $auto_Selected_Link_ID;

    while ($auto_Selected_Link_ID ne "") {
        $auto_Selected_Link_ID = $this->get_Link_Child_Auto_Selected($auto_Selected_Link_ID_Prev);

        if ($auto_Selected_Link_ID ne "") {
            $auto_Selected_Link_ID_Prev = $auto_Selected_Link_ID;
        }
    }

    $auto_Selected_Link_ID = $auto_Selected_Link_ID_Prev;

    if ($auto_Selected_Link_ID ne "") {
        $link_id = $auto_Selected_Link_ID;
    }

    while ($link_id ne "") {
        $link_name = $dbu->get_Item("name", "link_id", "$link_id");

        $sth = $db_conn->prepare("select dynamic_content_num, dynamic_content_name, ref_type, ref_name, blob_id from $pre_table_name" . 
                                 "link_reference where link_id='$link_id' order by dynamic_content_num");

        $sth->execute;

        while ($db_row = $sth->fetchrow_hashref) {
            $link_content_info[$counter] = new Link_Structure_Content_Info($link_id, $link_name, $level_counter, $db_row->{"dynamic_content_num"}, $db_row->{"dynamic_content_name"}, $db_row->{"ref_type"}, $db_row->{"ref_name"}, $db_row->{"blob_id"});
            $counter++;
        }

        $sth->finish;

        $link_id = $dbu->get_Item("parent_id", "link_id", "$link_id");

        $level_counter++;        
    }
    

    $max_level = $level_counter - 2; ### ??? may cause by $dbu->get_Item(" ... 
                                     ### that always return something even there is no 
                                     ### items inside DB - 17/05/2005
    
    if ($counter > 0) {
        my $link_content_info_num = @link_content_info;
        my @temp_link_content_info = undef;
        
        $counter = 0;
        
        for ($i = $link_content_info_num - 1; $i >= 0; $i--) {
            $old_level = $link_content_info[$i]->get_Link_Level;
            
            #print "\$old_level = $old_level -- \$max_level = $max_level<br>";
            
            $temp_link_content_info[$counter] = $link_content_info[$i];
            
            $temp_link_content_info[$counter]->set_Link_Level($max_level - $old_level);
            
            $counter++;
        }
        
        $this->{link_content_info} = \@temp_link_content_info;
    }
}

sub set_Link_Path {
    my $this = shift @_;
    
    $this->{link_path} = \@_;
}

sub auth_Link_Path { ### 30/09/2011
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
    my $link_path_ref = $this->{link_path};
    
    my @link_path = @{$link_path_ref};
    
    foreach $lp (@link_path) {
        my ($link_id, $link_name) = %{$lp};
        
        my $auth = $this->auth_Link_ID($link_id, undef, 0);
        
        if (!$auth) {
            return 0;
        }   
        
        #$cgi->add_Debug_Text("$link_id : $link_name = $auth", __FILE__, __LINE__);
    }
    
    return 1;
}

sub set_Link_Content_Info {
    my $this = shift @_;
    
    $this->{link_content_info} = \@_;
}

sub set_Parent_Link_ID {
    my $this = shift @_;
    
    $this->{parent_link_id} = shift @_;
}

sub set_My_Link_Level {
    my $this = shift @_;
    
    $this->{my_link_level} = shift @_;
    
    #print "\$this->{my_link_level} = $this->{my_link_level} <br>";
    
    my @link_path = $this->get_Link_Path;
    my @link_content_info = $this->get_Link_Content_Info;
    
    my $link_path_num = @link_path;
        
    my ($key, $value) = %{$link_path[$this->{my_link_level}]};
    $this->set_My_Link_ID($key);
    $this->set_My_Link_Name($value);
    
    #print "My_Link_ID = $key <br>";
    
    ($key, $value) = %{$link_path[$link_path_num - 1]};
    $this->set_Current_Link_ID($key);
    $this->set_Current_Link_Name($value);
    
    #print "Current_Link_ID = $key <br>";
}

sub set_My_Link_ID {
    my $this = shift @_;
    
    $this->{my_link_id} = shift @_;
}

sub set_My_Link_Name {
    my $this = shift @_;
    
    $this->{my_link_name} = shift @_;
}

sub set_Current_Link_ID {
    my $this = shift @_;
    
    $this->{current_link_id} = shift @_;
}

sub set_Current_Link_Name {
    my $this = shift @_;
    
    $this->{current_link_name} = shift @_;
}

sub set_Current_Dynamic_Content_Num {
    my $this = shift @_;
    
    my $dyna_cont_num = shift @_;
    
    $this->{current_dynamic_content_num} = $dyna_cont_num;
}

sub set_Current_Dynamic_Content_Name { ### 10/01/2009
    my $this = shift @_;
    
    my $dyna_cont_name = shift @_;
    
    $this->{current_dynamic_content_name} = $dyna_cont_name;
}

sub get_Link_Path { ### this function/method will return an array of hash reference 
    my $this = shift @_;
    
    if ($this->{link_path} eq undef) { ### 03/02/2009
        $this->construct_Link_Path;
    } 
    
    my $link_path_ref = $this->{link_path};
    
    my @link_path = @{$link_path_ref};
    
    return @link_path;
}

sub get_Link_Content_Info {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    
    if ($this->{link_content_info} eq undef) { ### 03/02/2009
        $this->construct_Link_Content_Info;
    }
    
    my $link_content_info_ref = $this->{link_content_info};
        
    my @link_content_info = @{$link_content_info_ref};
        
    return @link_content_info;
}


sub get_My_Link_Level {
    my $this = shift @_;
    
    return $this->{my_link_level};
}

sub get_My_Link_ID {
    my $this = shift @_;
    
    return $this->{my_link_id};
}

sub get_My_Link_Name {
    my $this = shift @_;
    
    return $this->{my_link_name};
}

sub get_Current_Link_ID {
    my $this = shift @_;
    
    return $this->{current_link_id};
}

sub get_Current_Link_Name {
    my $this = shift @_;
    
    return $this->{current_link_name};
}

sub get_Current_Dynamic_Content_Num {
    my $this = shift @_;
    
    return $this->{current_dynamic_content_num};
}

sub get_Current_Dynamic_Content_Name { ### 10/01/2009
    my $this = shift @_;
    
    return $this->{current_dynamic_content_name};
}

sub get_Application_Name {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $script_filename = $ENV{SCRIPT_FILENAME};
    
    my @array = split(/\//, $script_filename);
    
    #print "\Application Name = " . $array[@array - 2] . "<br>";
    
    return $array[@array - 2];
}

sub get_My_First_Child_Link_ID {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $pre_table_name = "webman_" . $this->get_Application_Name . "_";

    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my $child_link_id = $dbu->get_Item("link_id", "parent_id sequence", $this->{my_link_id} . " 0");
    
    return $child_link_id;
}

sub match_My_First_Child_Link_Reference {
    my $this = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
        my $dynamic_content_num = shift @_;
        my $ref_type = shift @_;
        my $ref_name = shift @_;
        
        my $pre_table_name = "webman_" . $this->get_Application_Name . "_";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my $child_link_id = $dbu->get_Item("link_id", "parent_id sequence", $this->{my_link_id} . " 0");
    
    $dbu->set_Table($pre_table_name . "link_reference");
    
    my $link_ref_id = $dbu->get_Item("link_ref_id", 
                                     "link_id dynamic_content_num ref_type ref_name", 
                                     "$child_link_id $dynamic_content_num $ref_type $ref_name");
    
    if ($link_ref_id ne "") {
        return 1;
        
    } else {
        return 0;
    }
}

sub get_My_Menu_Items {
    my $this = shift @_;
    
    my $key_link_id = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $pre_table_name = "webman_" . $this->get_Application_Name . "_";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my $parent_link_id = undef;
    
    if ($key_link_id eq "") {
        $parent_link_id = $dbu->get_Item("parent_id", "link_id", $this->{my_link_id});
        
    } else {
        $parent_link_id = $dbu->get_Item("parent_id", "link_id", $key_link_id);
    }
    
    my @menu_items = undef;
    
    my $sth = $db_conn->prepare("select name from $pre_table_name" . "link_structure where parent_id='$parent_link_id' order by sequence");
    
    $sth->execute;
    
    my $count = 0;
    while ($data = $sth->fetchrow_hashref) {
        $menu_items[$count] = $data->{"name"};
        $count++;
    }
    
    $sth->finish;
    
    return @menu_items;
}

sub get_My_Menu_Links {
    my $this = shift @_;
    
    my $key_link_id = shift @_; ### 2006/12/05
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $pre_table_name = "webman_" . $this->get_Application_Name . "_";
    
    my $dbu = new DB_Utilities;

    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my $parent_link_id = undef;
    
    #$cgi->add_Debug_Text("\$this->{my_link_id} = $this->{my_link_id}", __FILE__, __LINE__);
    
    if ($key_link_id eq "") { ### 2006/12/05
        $parent_link_id = $dbu->get_Item("parent_id", "link_id", $this->{my_link_id});
        
    } else {
        $parent_link_id = $dbu->get_Item("parent_id", "link_id", $key_link_id);
    }
    
    my @menu_links = undef;
    
    my $sth = $db_conn->prepare("select link_id from $pre_table_name" . "link_structure where parent_id='$parent_link_id' order by sequence");
    
    $sth->execute;
    
    my $count = 0;
    while ($data = $sth->fetchrow_hashref) {
        $menu_links[$count] = "link_id=" . $data->{"link_id"};
        $count++;
    }
    
    $sth->finish;
    
    return @menu_links;
}

sub same_Level_Menu_Item {
    my $this = shift @_;
    
    my $current_menu_item = shift @_;
    my @menu_items = @_;
    
    my $i = 0;
    
    for ($i = 0; $i < @menu_items; $i++) {
        if ($menu_items[$i] eq $current_menu_item) {
            return 1;
        }
    }
    
    return 0;
}

sub get_Link_Child_Auto_Selected {
    my $this = shift @_;
    
    my $parent_link_id = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $pre_table_name = "webman_" . $this->get_Application_Name . "_";
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn); ### option 1
    $dbu->set_Table($pre_table_name . "link_structure");
    
    my $auto_Selected_Link_ID = $dbu->get_Item("link_id", "parent_id auto_selected", "$parent_link_id YES");
    
    return $auto_Selected_Link_ID;
}

sub generate_Link_Path_Info {
    my $this = shift @_;
    
    my $script_name = shift @_;
    my $additional_get_data = shift @_;
    my $carried_get_data = shift @_;
    my $last_not_active = shift @_;
    my $level_start = shift @_;
    my $level_deep = shift @_;
    
    my $nslc = shift @_; ### none selected link color
    my $st = shift @_;   ### separator tag
    
    if ($st eq "")   { $st = "&gt;"; }
    
    my $cgi = $this->get_CGI;
    
    if ($script_name eq "") { $script_name = "index.pl"; }
    if ($last_not_active eq "") { $last_not_active = 0; }
    
    $carried_get_data = $this->generate_GET_Data("$carried_get_data");
    
    my $get_data = undef;
    
    if ($additional_get_data ne undef) { $get_data = "$additional_get_data" . "&"; }
    
    if ($carried_get_data ne "") { $get_data .= "$carried_get_data"; }
        
    my ($counter, $lp, $link_id, $link_name, $link_name_get_fmt, $link) = undef;

    my $link_path_ref = $this->{link_path};

    my @link_path = @{$link_path_ref};

    $counter = 0;
    
    if ($level_start eq "" || $level_start < 0) {
        $level_start = 0;
    }

    if ($level_deep eq "" || $level_deep > @link_path || $level_deep < $level_start) {
        $level_deep = @link_path;
        $level_deep--;  
    }
    
    #print "\$level_start = $level_start : \$level_deep = $level_deep <br>";
    
    foreach $lp (@link_path) {
        ($link_id, $link_name) = %{$lp};
        
        $link_name_get_fmt = $link_name;
        $link_name_get_fmt =~ s/ /+/g;
        $link_name_get_fmt =~ s/\&/\%26/g;
        
        if ($counter >= $level_start && $counter <= $level_deep) {
            if ($counter < $level_deep) {
                if ($nslc ne "") {
                    $link_name = "<font color=\"$nslc\">$link_name</font>";
                }
                
                $link .= "<a href=\"$script_name?link_name=$link_name_get_fmt&link_id=$link_id&$get_data\">$link_name</a> $st ";

            } else {
                if ($last_not_active) {
                    $link .= "$link_name";
                    
                } else {
                    if ($nslc ne "") {
                        $link_name = "<font color=\"$nslc\">$link_name</font>";
                    }                
                    $link .= "<a href=\"$script_name?link_name=$link_name_get_fmt&link_id=$link_id&$get_data\">$link_name</a>";
                }

            }
            
            #print "\$level_deep = $level_deep : \$counter = $counter : \$link = $link <br>\n";
        }

        $counter++;
    }
    
    return $link;
}

sub print_Link_Path_Info {
    my $this = shift @_;
    
    my ($counter, $lp, $link_id, $link_name) = undef;
    
    
    my $link_path_ref = $this->{link_path};
    
    my @link_path = @{$link_path_ref};
    
    print "<pre>";
    
    $counter = 0;
    
    foreach $lp (@link_path) {
        ($link_id, $link_name) = %{$lp};
        
        if ($counter < @link_path - 1) {
            print "$link_id:$link_name -&gt; ";
        } else {
            print "$link_id:$link_name";
        }
        
        $counter++;
    }
    
    print "</pre>";
}

sub get_Link_Path_Info { ### 29/09/2011
    my $this = shift @_;
    
    my ($counter, $lp, $link_id, $link_name) = undef;
    
    
    my $link_path_ref = $this->{link_path};
    
    my @link_path = @{$link_path_ref};
    
    my $info_text = undef;
    
    $counter = 0;
    
    foreach $lp (@link_path) {
        ($link_id, $link_name) = %{$lp};
        
        if ($counter < @link_path - 1) {
            $info_text .= "$link_id:$link_name -&gt; ";
        } else {
            $info_text .= "$link_id:$link_name";
        }
        
        $counter++;
    }
    
    return $info_text;
}

sub translate_CGI_HTML_Map_Key_Str { ### 13/08/2011
    my $this = shift @_;
    
    my $key_str = shift @_;

    my $cgi = $this->get_CGI;

    my $cgi_HTML = new CGI_HTML_Map;
        
    $cgi_HTML->set_CGI($cgi);
    
    $cgi_HTML->set_HTML_Code($key_str);
    #$cgi_HTML->set_Escape_HTML_Tag(???); ### can be 0 or 1
    
    $key_str = $cgi_HTML->get_HTML_Code;
    
    return $key_str;
}

sub get_User_Login {
    my $this = shift @_;
    
    my $session_id = shift @_; ### 05/05/2011
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $app_name = $cgi->param("app_name");
    
    if ($session_id eq "") { ### using current active session id (current user)
        $session_id = $cgi->param("session_id");
    }
    
    ### still doesn't have session id so just return undefined
    if ($session_id  eq "") { 
        return undef;
    }
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table("webman_" . $app_name . "_session");
    
    my $login_name = $dbu->get_Item("login_name", "session_id", $session_id);
    
    #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__);
    
    return $login_name;
}

sub get_User_Groups {
    my $this = shift @_;
    
    my $login_name = shift @_; ### 05/05/2011    
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $app_name = $cgi->param("app_name");
    my $session_id = $cgi->param("session_id");
    
    if ($login_name eq "") { 
        $login_name = $this->get_User_Login;
    }
    
    if ($login_name eq "") {
        return undef;
    }
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table("webman_" . $app_name . "_user_group");
    
    my @array_hash = $dbu->get_Items("group_name", "login_name", $login_name);
    
    #$cgi->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__);
    
    my $item = undef;
    my $count = 0;
    my @groups = undef;
    
    foreach $item (@array_hash) {
        $groups[$count] = $item->{group_name};
        $count++;
    }
    
    return @groups;
}

sub match_Group {
    my $this = shift @_;
    
    my $group_name = shift @_;
    my @my_groups = @_;
    
    my $item = undef;
    
    foreach $item (@my_groups) {
        if ($group_name eq $item) {
            return 1;
        }
    }
    
    return 0;
}

1;