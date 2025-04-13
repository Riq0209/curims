package wmcudas_user_apps_group_link;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $class = shift;
    
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
    
    my $match_group = $this->match_Group($group_name_, @groups);
    
    ### DB item dynamic list with multi row insert/update/delete  
    ### operations support need this to behave correctly 
    if (!$cgi->param_Exist("task")) {
        $cgi->push_Param("task", "");
    }
    
    
    $this->SUPER::run_Task();
}

### The skeleton of "hook" function to be redefined to process template 
### elements content. TE_TYPE_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, 
### SELECT, DATAHTML, CGIHTML, etc.
sub process_DYNAMIC { 
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $te_content = $te->get_Content;
    my $te_type_num = $te->get_Type_Num;
    my $te_type_name = $te->get_Name;
    
    ### Start process template element content.
    #???
    
    if ($te_type_name eq "select_description") {
        my $s_opt = new Select_Option;
        
        $s_opt->set_DBI_Conn($db_conn);
        $s_opt->set_Values_From_DBI_SQL("SELECT DISTINCT description FROM wmcudas_user ORDER BY description");
        
        $s_opt->set_Selected($cgi->param("filter_description"));
        $this->add_Content($s_opt->get_Selection);
        
    } else {
        $this->SUPER::process_DYNAMIC($te);
    }
}

sub customize_SQL {
    my $this = shift @_;
    my $te = shift @_;

    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $sql = $this->{sql};
    
    ### Next to customize the $sql string
    ### ???
    my $sql_filter = undef;
    my @cgivars = ("filter_login_name", "filter_full_name", "filter_description");
    
    foreach my $var (@cgivars) {
        my $val = $cgi->param($var);
        my $db_field = $var;
           $db_field =~ s/^filter_//;
        
        if (!$cgi->param_Exist($var) || $cgi->param($var) eq "") {
            $val = "\%";
            
        } else {
            $val = "\%" . $val . "\%";
        }
        
        $sql_filter .= "$db_field like '$val' and ";
        $val =~ s/\%//g;
        $cgi->push_Param($var, $val);
    } 
    
    $sql_filter =~ s/ and $//;
    
    my @sql_part = split(/ order by /, $sql);
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    if ($sql_part[0] =~ / where /) {
        $sql = "$sql_part[0] and $sql_filter order by $sql_part[1]";
         
    } else {
        $sql = "$sql_part[0] where $sql_filter order by $sql_part[1]";
    }
    
    #$cgi->add_Debug_Text($sql, __FILE__, __LINE__, "DATABASE");
    
    return $sql;
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $dbu = $this->get_DBU;
    my $db_conn = $this->get_DB_Conn;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $caller_get_data = $cgi->generate_GET_Data("link_name link_id dmisn app_name");
    my $get_data = undef;
    
    $tld->add_Column("row_class");
    $tld->add_Column("wmcudas_apps");
    $tld->add_Column("wmcudas_group");
    
    my $row_class = "row_odd"; ### HTML CSS class
    
    for ($i = 0; $i < $tld->get_Row_Num; $i++) { 
        #$tld_data = $tld->get_Data($i, "col_name_");
        
        #$tld_data = "<font color=\"#0099FF\">$tld_data</font>";
            
        #$tld->set_Data($i, "col_name_", $tld_data);
        #$tld->set_Data_Get_Link($i, "col_name_", "index.cgi?$get_data", "link_properties_");
        
        $tld->set_Data($i, "row_class", "$row_class");
        
        if ($row_class eq "row_odd") {
            $row_class = "row_even";
            
        } else {
            $row_class = "row_odd";
        }        
        
        $dbu->set_Table("wmcudas_userapps");
        my $count_item = $dbu->count_Item("id_user_36base", $tld->get_Data($i, "id_user_36base"));
        $tld->set_Data($i, "wmcudas_apps", $count_item);

        $dbu->set_Table("wmcudas_usergroup");
        my $count_item = $dbu->count_Item("id_user_36base", $tld->get_Data($i, "id_user_36base"));
        $tld->set_Data($i, "wmcudas_group", $count_item);

    }
    
    return $tld;
}

1;