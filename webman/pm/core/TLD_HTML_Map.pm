###########################################################################################

# GMM_CGI_Lib Pre-Release 5

# This library intended to be released under GNU General Public License. 
# Please visit http://www.gnu.org/ or contact the author for more info 
# about copied and disribution of this library.

# Copyright 2002-2005, Mohd Razak bin Samingan

# Faculty of Computer Science & Information System,
# 81310 UTM Skudai,
# Johor, MALAYSIA.

# e-mail: mrazak@fsksm.utm.my

###########################################################################################

package TLD_HTML_Map;

sub new {
    my $type = shift;
    
    my $this = {};
    
    $this->{items_view_num} = undef;
    $this->{items_set_num} = undef;
    $this->{items_num} = undef;
    
    $this->{special_tag_view} = 0; ### 30/08/2005
    
    $this->{start_counter} = 1;
    
    $this->{row_num_text_pattern} = undef; ### 23/12/2006
    $this->{row_idx_text_pattern} = undef; ### 06/07/2011
    
    bless $this, $type;
    
    return $this;
}

sub set_Table_List_Data {
    $this = shift @_;
    
    $this->{table_list_data} = shift @_;
    
    my $tld = $this->{table_list_data};

    if ($tld ne undef) { ### 07/07/2009
        my ($i, $j) = 0;

        for ($i = 0; $i < $tld->get_Row_Num; $i++) {
            for ($j = 0; $j < $tld->get_Column_Num; $j++) {
                #print "<pre>" . $tld->get_Column_Name($j) . " = " . $tld->get_Row_Data($i, $tld->get_Column_Name($j)) . "\n</pre>";
            }
        }
    }
}

sub set_HTML_Code {
    $this = shift @_;
    
    $this->{HTML_Code} = shift @_;
}

sub set_HTML_File {
    $this = shift @_;
    
    #$this->{HTML_Code} = ???;### 30/08/2006
}


sub set_Items_View_Num {
    $this = shift @_;
    
    $this->{items_view_num} = shift @_;
}

sub set_Items_Set_Num {
    $this = shift @_;
    
    $this->{items_set_num} = shift @_;
}

sub set_Special_Tag_View { ### 30/08/2005
    $this = shift @_;
    
    $this->{special_tag_view} = shift @_;   
    
    $this->{stv_columns} = shift @_; ### 14/12/2010
                                     ### anonymous array ref. [col_1_, ..., col_n_] 
}

sub set_Start_Counter {
    $this = shift @_;
    
    $this->{start_counter} = shift @_;
}

sub set_Row_Num_Text_Pattern { ### 23/12/2010
    my $this = shift @_;
   
    $this->{row_num_text_pattern} = shift @_;
    
    $this->{row_num_text_pattern} =~ s/^\$/\\\$/;
}

sub set_Row_Idx_Text_Pattern { ### 06/07/2011
    my $this = shift @_;
   
    $this->{row_idx_text_pattern} = shift @_;
    
    $this->{row_idx_text_pattern} =~ s/^\$/\\\$/;
}

sub get_HTML_Code {
    my $this = shift @_;
    
    my $tld = $this->{table_list_data};
    
    if ($tld eq undef) { ### 07/07/2009
        return $this_HTML_Code;        
    }    
    
    if ($tld->get_Row_Num == 0) {
        return $this_HTML_Code;
    }
    
    my ($pattern, $data, $get_link, $get_link_properties, $temp_code, $result_code) = undef;
    
    my $i = 0;
    my $j = 0;
    my $tld_num = 0;
    
    my $start_row_num = undef;
    my $stop_row_num = undef;
    
    if ($this->{items_view_num} > 0 && $this->{items_set_num} > 0) {
        $start_row_num = ($this->{items_set_num} - 1) * $this->{items_view_num};
        $stop_row_num = $this->{items_set_num} * $this->{items_view_num};
        
        if ($stop_row_num > $tld->get_Row_Num) {
            $stop_row_num = $tld->get_Row_Num;
        }
        
    } else {
        $start_row_num = 0;
        $stop_row_num = $tld->get_Row_Num;
    }
    
    #print "\$this->{items_set_num} = " . $this->{items_set_num} . "<br>";
    #print "\$this->{items_view_num} = " . $this->{items_view_num} . "<br>";
    #print "\$start_row_num = " . $start_row_num . "<br>";
    #print "\$stop_row_num = " . $stop_row_num . "<br>";
    
    my %stv_cols_hash = undef; ### stv stand for special tag view
    
    #print "\$this->{stv_columns} = $this->{stv_columns}";
    
    if ($this->{stv_columns} ne undef) { ### 14/12/2010
        my @stv_cols_array = @{$this->{stv_columns}};
        
        foreach my $item (@stv_cols_array) {
            $stv_cols_hash{$item} = 1;
        }
    }
    
    if ($this->{row_num_text_pattern} eq "") {
        $this->{row_num_text_pattern} = "\\\$tld_num_";
    }
    
    if ($this->{row_idx_text_pattern} eq "") {
        $this->{row_idx_text_pattern} = "\\\$tld_idx_";
    }    
    
    for ($i = $start_row_num; $i < $stop_row_num; $i++) {
        $temp_code = $this->{HTML_Code};
        
        #print "\$i = $i <br>";
        
        $tld_num = $this->{start_counter} + $i;
        $tld_idx = $this->{start_counter} + $i - 1;
        
        $temp_code =~ s/$this->{row_num_text_pattern}/$tld_num/g;
        $temp_code =~ s/$this->{row_idx_text_pattern}/$tld_idx/g;
        
        for ($j = 0; $j < $tld->get_Column_Num; $j++) {
            my $col_name = $tld->get_Column_Name($j);
            
            $pattern = "tld_" . $col_name . "_";
            
            $data = $tld->get_Data($i, $col_name);
            
            if ($this->{special_tag_view} && $stv_cols_hash{$col_name}) {
                $data =~ s/&/&amp;/g; ### 24/08/2005
                $data =~ s/</&lt;/g;
                $data =~ s/>/&gt;/g;
                $data =~ s/"/&quot;/g; ### "
            }
            
            $get_link = $tld->get_Data_Get_Link($i, $col_name);
            $get_link_properties = $tld->get_Data_Get_Link_Properties($i, $col_name);
            
            if ($get_link_properties ne undef) {
                $get_link_properties = "$get_link_properties";
                
            } else {
                $get_link_properties = "";
            }
            
            if ($get_link eq undef) {
                $temp_code =~ s/\$\b$pattern\b/$data/g;
            } else {
                $temp_code =~ s/\$\b$pattern\b/<a href="$get_link" $get_link_properties>$data<\/a>/g;
            }
            
            if ($this->{items_view_num} > 0) {
            
            }
        }
        
        $result_code .= $temp_code;
    }
    
    return $result_code;
    
}

1;