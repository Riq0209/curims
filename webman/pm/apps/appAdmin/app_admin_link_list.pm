package app_admin_link_list;

use webman_TLD_item_view_dynamic;

@ISA=("webman_TLD_item_view_dynamic");

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
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($db_conn);
    
    ###########################################################################
    
    my @ahr = undef;
    
    $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_structure");
    
    my %map_linkid_name = ();
    
    @ahr = $dbu->get_Items("link_id name", undef, undef, undef, undef);
    
    foreach my $item (@ahr) {
        $map_linkid_name{$item->{link_id}} = $item->{name};
    }    
    
    #############################################
    
    $dbu->set_Table("webman_" . $cgi->param("app_name_in_control") . "_link_auth");
    
    my %dict_linkid_auth = ();
    
    @ahr = $dbu->get_Items("link_id", undef, undef, undef, );
    
    foreach my $item (@ahr) {
        $dict_linkid_auth{$item->{link_id}} = 1;
    }    
    
    ###########################################################################
    
    my $tld_data = undef;
    
    my $caller_get_data = $this->generate_GET_Data("link_name link_id dmisn app_name ...");
    my $get_data = undef;
    
    $tld->add_Column("row_color");
    $tld->add_Column("link_name_path");
    $tld->add_Column("link_name_path_getfmt");
    $tld->add_Column("user_num");
    $tld->add_Column("group_num");
    
    my $row_color = "#FFFFFF";
    
    my $link_id = undef;
    
    for (my $i < 0; $i < $tld->get_Row_Num; $i++) { 
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
        
        $link_id = $tld->get_Data($i, "link_id");
        
        $dbu->set_Keys_Str("link_id='$link_id' and login_name is not null");
        $tld->set_Data($i, "user_num", $dbu->count_Item(undef, undef));
        
        $dbu->set_Keys_Str("link_id='$link_id' and group_name is not null");
        $tld->set_Data($i, "group_num", $dbu->count_Item(undef, undef));
        
        #$cgi->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__, "TRACING");
        
        if ($tld->get_Data($i, "user_num") > 0 || 
            $tld->get_Data($i, "group_num") > 0) {
            
            $tld->set_Data($i, "link_font_color", "#FF0000");
        }
        
        my @link_id_path_list = split(/ : /, $tld->get_Data($i, "link_id_path"));
        
        my $link_name_path = "";
        my $link_name_path_getfmt = "";
        
        my $count = 1;
        
        foreach my $link_id_path (@link_id_path_list) {
            if ($dict_linkid_auth{$link_id_path}) {
                if ($count == @link_id_path_list) {
                    $link_name_path .= "<font color=#ff0000>" . $map_linkid_name{$link_id_path} . "</font>" . " : ";
                    
                } else {
                    $link_name_path .= "<font color=#990000>" . $map_linkid_name{$link_id_path} . "</font>" . " : ";
                }
                
            } else {
                $link_name_path .= $map_linkid_name{$link_id_path} . " : ";
            }
            
            $link_name_path_getfmt .= $map_linkid_name{$link_id_path} . " : ";
            
            $count++;
        }
        
        $link_name_path =~ s/ : $//;
        $tld->set_Data($i, "link_name_path", $link_name_path);
        
        $link_name_path_getfmt =~ s/ : $//;
        $link_name_path_getfmt =~ s/ /+/g;
        $tld->set_Data($i, "link_name_path_getfmt", $link_name_path_getfmt);
    }
    
    return $tld;
}

1;