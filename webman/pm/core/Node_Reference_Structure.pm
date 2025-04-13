package Node_Reference_Structure;

use Link_Node;

sub new {
    my $class = shift @_;
    
    my $app_name = shift @_;
    my $link_id = shift @_;
    my $dbu = shift @_;
    
    
    my $this = {};
    
    $this->{app_name} = $app_name;
    $this->{link_id} = $link_id;
    $this->{dbu} = $dbu;
    
    $this->{ref_root} = undef;
    $this->{link_path_info} = undef;
    $this->{ref_exist} = undef;
    $this->{error} = undef;
    
    bless $this, $class;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub set_Table_Name {
    my $this = shift;
    
    $this->{table_name} = shift @_;
}

sub set_Link_ID {
    my $this = shift;
    
    $this->{link_id} = shift @_;
}

sub set_DBU {
    my $this = shift;
    
    $this->{dbu} = shift @_;
}

sub get_Structure {
    my $this = shift;
    
    my $dbu = $this->{dbu};
    
    $dbu->set_Table("webman_" . $this->{app_name} . "_link_structure");
    
    if ($dbu->find_Item("link_id", $this->{link_id})) {
        my $link_name = $dbu->get_Item("name", "link_id", $this->{link_id});
        
        $this->{ref_root} = new Link_Node({text => $link_name, type => "root"});
        
        $this->{link_path_info} = $link_name;
        
        my $link_id_parent = $dbu->get_Item("parent_id", "link_id", $this->{link_id});
        
        while ($link_id_parent != 0) {
            my $link_name = $dbu->get_Item("name", "link_id", $link_id_parent);
            
            $this->{link_path_info} = "$link_name > $this->{link_path_info}";
            
            $link_id_parent = $dbu->get_Item("parent_id", "link_id", $link_id_parent);
        }
        
        $dbu->set_Table("webman_" . $this->{app_name} . "_link_reference");        
        
        if ($dbu->find_Item("link_id", $this->{link_id})) {
            $this->{ref_exist} = 1;
            
            $this->construct_Struct($this->{ref_root});
            
        } else {
            $this->{ref_exist} = 0;
        }
        
    } else {
        $this->{error} = "Can't found node with link ID $this->{link_id}.";
    }
    
}

sub construct_Struct {
    my $this = shift;
    my $node_parent = shift @_;
    
    my $dbu = $this->{dbu};
    
    #print "Traverse $node_parent->{type}...\n";
    
    if ($node_parent->{type} eq "root") {
        $dbu->set_Table("webman_" . $this->{app_name} . "_link_reference");
    
        my @ahr = $dbu->get_Items("link_ref_id dynamic_content_num dynamic_content_name ref_type ref_name blob_id", 
                                  "link_id", "$this->{link_id}");
                                  
        my $idx_level = 0;
         
        foreach my $item (@ahr) {
            #print "$item->{link_ref_id}, $item->{dynamic_content_num}, $item->{dynamic_content_name}, $item->{ref_type}, $item->{ref_name}\n";
            
            my $type = "reference";
            
            if ($item->{ref_name} eq "webman_component_selector") {
                $type = "reference_selector";
            }
            
            my $node_new = new Link_Node({ text => "$item->{ref_name}", type => "$type", idx_level => $idx_level,
                                           info_hash => { link_ref_id => "$item->{link_ref_id}", 
                                                          dynamic_content_num => "$item->{dynamic_content_num}",
                                                          dynamic_content_name => "$item->{dynamic_content_name}", 
                                                          ref_type => "$item->{ref_type}", ref_name => "$item->{ref_name}", 
                                                          blob_id => "$item->{blob_id}" } });
                                                          
           $this->construct_Struct($node_new);
           
           $node_parent->add_Child($node_new);
        }
        
    } elsif ($node_parent->{type} eq "reference_selector") {
        $dbu->set_Table("webman_" . $this->{app_name} . "_dyna_mod_selector");
        
        my @ahr = $dbu->get_Items("dyna_mod_selector_id link_ref_id cgi_param cgi_value dyna_mod_name", 
                                  "link_ref_id", "$node_parent->{info_hash}->{link_ref_id}");
        
        my $idx_level = $node_parent->{idx_level} + 1;
        
        foreach my $item (@ahr) {
            for (my $i = 0; $i < $idx_level * 3; $i++) {
                #print " ";
            }
            
            #print "$item->{dyna_mod_selector_id}, $item->{link_ref_id}, $item->{cgi_param}, $item->{cgi_value}, $item->{dyna_mod_name}\n";
            
            my $node_new = new Link_Node({ text => "$item->{dyna_mod_name}", type => "reference", idx_level => $idx_level,
                                           info_hash => { dyna_mod_selector_id => "$item->{dyna_mod_selector_id}",
                                                          link_ref_id => "$item->{link_ref_id}", 
                                                          cgi_param => "$item->{cgi_param}", cgi_value => "$item->{cgi_value}", 
                                                          dyna_mod_name => "$item->{dyna_mod_name}" } });
                                                          
           $this->construct_Struct($node_new);
           
           $node_parent->add_Child($node_new);            
        } 
        
    } elsif ($node_parent->{type} eq "reference") {
        $dbu->set_Table("webman_" . $this->{app_name} . "_dyna_mod_param");
        
        my @ahr = undef;
        
        if ($node_parent->{info_hash}->{dyna_mod_selector_id}) {
            @ahr = $dbu->get_Items("dmp_id link_ref_id scdmr_id dyna_mod_selector_id param_name param_value", 
                                   "dyna_mod_selector_id", $node_parent->{info_hash}->{dyna_mod_selector_id});
            
        } else {
            @ahr = $dbu->get_Items("dmp_id link_ref_id scdmr_id dyna_mod_selector_id param_name param_value",
                                   "link_ref_id", $node_parent->{info_hash}->{link_ref_id});
        }
        
        #print $dbu->get_SQL;
        
        my $idx_level = $node_parent->{idx_level} + 1;
        
        foreach my $item (@ahr) {
            for (my $i = 0; $i < $idx_level * 3; $i++) {
                #print " ";
            }
            
            #print "$item->{dmp_id}, $item->{link_ref_id}, $item->{scdmr_id}, $item->{dyna_mod_selector_id}, $item->{param_name}, $item->{param_value}\n";
            #my $stuck = <STDIN>;
            
            my $node_new = new Link_Node({ text => "$item->{param_name}", type => "parameter", idx_level => $idx_level,
                                           info_hash => { dmp_id => "$item->{dmp_id}",
                                                          link_ref_id => "$item->{link_ref_id}", scdmr_id => "$item->{scdmr_id}", dyna_mod_selector_id => "$item->{dyna_mod_selector_id}", 
                                                          param_name => "$item->{param_name}", param_value => "$item->{param_value}" } });
                                                          
            $node_parent->add_Child($node_new);
        }
        
    }
    
}

sub get_Structure_FmtTxt {
    my $this = shift;
    my $node_parent = shift @_;
    
    my $fmttxt = undef;
    
    if (!defined($node_parent) && defined($this->{ref_root})) {
        $node_parent = $this->{ref_root};        
    } 
    
    if (defined($node_parent)) {
        my $idx_spc = $node_parent->{idx_level} * 4;
        
        for (my $i = 0; $i < $idx_spc; $i++) {
            if ($i == 0) {
                $fmttxt .= "|";
                
            } elsif ($node_parent->{idx_level} > 1 && $i == (($node_parent->{idx_level} - 1) * 4)) {
                $fmttxt .= "|";
                
            } elsif (($idx_spc - $i) < 4) {
                $fmttxt .= "-";
                
            } else {
                $fmttxt .= " ";
            }
        }
        
        if ($node_parent->{type} eq "parameter") {
            $fmttxt .= "$node_parent->{text} = $node_parent->{info_hash}->{param_value}\n";
        } else {
            $fmttxt .= "$node_parent->{text}\n";
        }
        
        #for (my $i = 0; $i < $idx_spc; $i++) {
        #    if ($i == 0
        #}
        
        $fmttxt .= "\n";
        
        my @childs = $node_parent->get_Childs;
        
        foreach $node (@childs) {
            $fmttxt .= $this->get_Structure_FmtTxt($node);
        }
    }
    
    return $fmttxt;   
}

1;