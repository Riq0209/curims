package app_admin_component_list;

use webman_db_item_view_dynamic;

@ISA=("webman_db_item_view_dynamic");

sub new {
    my $type = shift;
    
    my $this = webman_db_item_view_dynamic->new();
    
    #$this->set_Debug_Mode(1, 1);
    
    $this->{staff_id};
    
    bless $this, $type;
    
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
    
    $this->SUPER::run_Task();
}

sub customize_TLD {
    my $this = shift @_;
    
    my $tld = shift @_;
    
    my $cgi = $this->get_CGI;
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    my $i = 0;
    my $tld_data = undef;
    
    my $caller_get_data = $this->generate_GET_Data("link_name link_id dmisn app_name ...");
    my $get_data = undef;
    
    $tld->add_Column("row_color");
    $tld->add_Column("dyna_mod_name_font_color");
    $tld->add_Column("user_num");
    $tld->add_Column("group_num");
    
    my $row_color = "#FFFFFF";
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_comp_auth");
    
    my $comp_name = undef;
    
    for ($i < 0; $i < $tld->get_Row_Num; $i++) { 
        #$tld_data = $tld->get_Data($i, "nama");
        
        #$get_data = $caller_get_data . "&" . "nama=" . $tld_data;
        #$get_data =~ s/ /+/g;
        
        #$tld_data = "<font color=\"#0099FF\">$tld_data</font>";
            
        #$tld->set_Data($i, "nama", $tld_data);
        #$tld->set_Data_Get_Link($i, "nama", "index.cgi?$get_data");
        
        $tld->set_Data($i, "row_color", "$row_color");
        
        if ($row_color eq "#FFFFFF") {
            $row_color = "#E3E6FB";
        } else {
            $row_color = "#FFFFFF";
        }
        
        $comp_name = $tld->get_Data($i, "dyna_mod_name");
        
        $dbu->set_Keys_Str("comp_name='$comp_name' and login_name is not null");
        $tld->set_Data($i, "user_num", $dbu->count_Item(undef, undef));
        
        $dbu->set_Keys_Str("comp_name='$comp_name' and group_name is not null");
        $tld->set_Data($i, "group_num", $dbu->count_Item(undef, undef));
        
        if ($tld->get_Data($i, "user_num") > 0 || 
            $tld->get_Data($i, "group_num") > 0) {
            
            $tld->set_Data($i, "dyna_mod_name_font_color", "#FF0000");
        }
    }
    
    return $tld;
}

1;