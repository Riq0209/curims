############################################################################################

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

package Table_List_Data;

sub new {
    my $type = shift;
    
    my $this = {};
    
    $this->{column_num} = 0;
    $this->{row_num} = 0;
    $this->{column_name_array_ref} = undef;
    $this->{row_data_array_hash_ref} = undef;
    $this->{row_link_array_hash_ref} = undef;
    $this->{row_link_properties_array_hash_ref} = undef;
    
    bless $this, $type;
    
    return $this;
}

sub add_Array_Hash_Reference { ### 31/01/2010
    my $this = shift @_;
    
    my @ahr = @_;
    
    ### sort columns by its name
    my @keys = sort(keys(%{$ahr[0]}));
    
    ### add column name
    foreach my $key (@keys) {
        $this->add_Column($key);
    }
    
    ### add row data for each column name 
    foreach my $item (@ahr) {
        my @data_array =  ();
        
        foreach my $key (@keys) {
            push(@data_array, $item->{$key});
        }
        
        $this->add_Row_Data(@data_array);
    }
}

sub insert_Array_Hash_Reference { ### 29/05/2011
    my $this = shift @_;
    
    my $row_index = shift @_;
    my @ahr = @_;
    
    ### sort columns by its name
    my @keys = sort(keys(%{$ahr[0]}));
    
    ### add column name
    foreach my $key (@keys) {
        $this->add_Column($key);
    }
    
    ### add row data for each column name 
    my $step = 0;
    
    foreach my $item (@ahr) {
        my @data_array =  ();
        
        foreach my $key (@keys) {
            push(@data_array, $item->{$key});
        }
        
        $this->insert_Row_Data($row_index + $step, \@data_array);
        
        $step++;
    }
}

sub add_Column {
    my $this = shift @_;
    
    my $column_name = shift @_;
    
    my @column_name_array = ();
    
    if ($column_name ne "") {
        if (defined($this->{dict_column_name})) {
            if ($this->{dict_column_name}->{$column_name}) { ### column name already exist
                return 0;
                
            } else {
                ### take from existing array ref.
                @column_name_array  = @{$this->{column_name_array_ref}};
            }

        } else {
            ### create column name dictionary table
            $this->{dict_column_name} = {};
        }
        
        $column_name_array[$this->{column_num}] = $column_name;
        
        ### update column name dictionary table
        $this->{dict_column_name}->{$column_name} = 1;
        
        $this->{column_name_array_ref} = \@column_name_array;
        
        $this->{column_num}++;
        
        return 1;
    }
    
    return 0;
}

sub add_Row_Data { 
    my $this = shift @_;
    
    my @data_array = @_;
    
    if (@data_array == $this->{column_num}) {
    
        my $i = 0;

        my @row_data_array = undef;
        my @row_link_array = undef;
        my @row_link_properties_array = undef;
        
        my %hash_row_data = undef;
        my %hash_row_link = undef;
        my %hash_row_link_properties = undef;
        
        my @column_name_array = @{$this->{column_name_array_ref}};

        for ($i = 0; $i < $this->{column_num}; $i++) {
            $hash_row_data{$column_name_array[$i]} = $data_array[$i];
            $hash_row_link{$column_name_array[$i]} = undef;
            $hash_row_link_properties{$column_name_array[$i]} = undef;
        }

        if ($this->{row_data_array_hash_ref} ne undef) {
            @row_data_array = @{$this->{row_data_array_hash_ref}};
            $row_data_array[$this->{row_num}] = \%hash_row_data;
            
            @row_link_array = @{$this->{row_link_array_hash_ref}};
            $row_link_array[$this->{row_num}] = \%hash_row_link;
            
            @row_link_properties_array = @{$this->{row_link_properties_array_hash_ref}};
            $row_link_properties_array[$this->{row_num}] = \%hash_row_link_properties;

        } else {
            $row_data_array[$this->{row_num}] = \%hash_row_data;
            $row_link_array[$this->{row_num}] = \%hash_row_link;
            $row_link_properties_array[$this->{row_num}] = \%hash_row_link_properties;
        }
        
        $this->{row_data_array_hash_ref} = \@row_data_array;
        $this->{row_link_array_hash_ref} = \@row_link_array;
        $this->{row_link_properties_array_hash_ref} = \@row_link_properties_array;
        
        $this->{row_num}++;
        
        return 1;
    }
    
    return 0;
}

sub insert_Row_Data { ### 08/01/2006
    my $this = shift @_;
    
    my $row_index = shift @_;
    my $data_array_ref = shift @_;
    my $shift_mode = shift @_; 
    
    my @data_array = @{$data_array_ref};
    
    ### $shift_mode seems will not be implemented ### 28/05/2011
    if ($shift_mode ne "DOWN") {
        if ($shift_mode ne "UP") {
            $shift_mode = "DOWN";
        }
    }
    
    if (@data_array == $this->{column_num} && 
        $this->{row_data_array_hash_ref} ne undef) {
        
        ### greater than current last index number
        if ($row_index > $this->{row_num} - 1) { 
            return $this->add_Row_Data(@data_array);
        }
    
        my $i = 0;

        my @row_data_array = undef;
        my @row_link_array = undef;
        my @row_link_properties_array = undef;
        
        my %hash_row_data = undef;
        my %hash_row_link = undef;
        my %hash_row_link_properties = undef;
        
        my @column_name_array = @{$this->{column_name_array_ref}};

        for ($i = 0; $i < $this->{column_num}; $i++) {
            $hash_row_data{$column_name_array[$i]} = $data_array[$i];
            $hash_row_link{$column_name_array[$i]} = undef;
            $hash_row_link_properties{$column_name_array[$i]} = undef;
        }
        
        my @row_data_array = @{$this->{row_data_array_hash_ref}};
        my @row_link_array = @{$this->{row_link_array_hash_ref}};
        my @row_link_properties_array = @{$this->{row_link_properties_array_hash_ref}};
        
        for ($i = $this->{row_num}; $i > $row_index; $i--) {
            $row_data_array[$i] = $row_data_array[$i - 1];
            $row_link_array[$i] = $row_link_array[$i - 1];
            $row_link_properties_array[$i] = $row_link_properties_array[$i - 1];
        }
        
        $row_data_array[$row_index] = \%hash_row_data;
        $row_link_array[$row_index] = \%hash_row_link;
        $row_link_properties_array[$row_index] = \%hash_row_link_properties;
        
        $this->{row_data_array_hash_ref} = \@row_data_array;
        $this->{row_link_array_hash_ref} = \@row_link_array;
        $this->{row_link_properties_array_hash_ref} = \@row_link_properties_array;
        
        $this->{row_num}++;
        
        #print "Sucessful insert_Row_Data at row num $row_index and shift_mode = $shift_mode <br>";
        
        return 1;
    }
    
    return 0;
}

sub set_Data {
    my $this = shift @_;
    
    my $row_index = shift @_;
    my $column_name = shift @_;
    my $column_data = shift @_;
    
    my @array_hash_ref = undef;
    my $hash_ref = undef;
    
    if ($this->found_Column_Name($column_name) && 
        $this->{row_data_array_hash_ref} ne undef &&
        $row_index >= 0 && $row_index < $this->{row_num}) {
        
        @array_hash_ref = @{$this->{row_data_array_hash_ref}};

        if ($array_hash_ref[$row_index] ne undef) {
            $hash_ref = $array_hash_ref[$row_index];
            $hash_ref->{$column_name} = $column_data;
        }  
    }
}

sub set_Data_Get_Link {
    my $this = shift @_;
    
    my $row_index = shift @_;
    my $column_name = shift @_;
    my $get_link_data = shift @_;
    my $get_link_properties = shift @_;
    
    my @array_hash_ref = undef;
    my $hash_ref = undef;
    
    if ($this->found_Column_Name($column_name) &&
        $this->{row_link_array_hash_ref} ne undef &&
        $row_index >= 0 && $row_index < $this->{row_num}) {
        
        @array_hash_ref = @{$this->{row_link_array_hash_ref}};
            
        if ($array_hash_ref[$row_index] ne undef) {
            $hash_ref = $array_hash_ref[$row_index];
            $hash_ref->{$column_name} = $get_link_data;
        }
        
        @array_hash_ref = @{$this->{row_link_properties_array_hash_ref}};
            
        if ($array_hash_ref[$row_index] ne undef && $get_link_properties ne "") {
            $hash_ref = $array_hash_ref[$row_index];
            $hash_ref->{$column_name} = $get_link_properties;
        }
    }
}

sub sort_Data { ### 13/06/2006
    my $this = shift @_;
    
    my $column_name = shift @_;
    my $order_list = shift @_;
    my $cmp_mode = shift @_;
    
    my @columns = split(/ /, $column_name);
    my @orders = split(/ /, $order_list);
    my @modes = split(/ /, $cmp_mode);
    
    my $c_num = @columns;
    my $o_num = @orders;
    
    my $i = 0;
    my $j = 0;
    
    my $finish = undef;
    my $row_index = $this->get_Row_Num;
    
    my $temp_hash_ref = undef;
    
    my @array_hash_ref_data = @{$this->{row_data_array_hash_ref}};
    my @array_hash_ref_link = @{$this->{row_link_array_hash_ref}};
    my @array_hash_ref_link_properties = @{$this->{row_link_properties_array_hash_ref}};
    
    my $swap = undef;
    
    for ($i = 0; $i < $c_num; $i++) {
        if ($this->found_Column_Name($columns[$i])) {
            #print "Try to sort base on $columns[$i] : $modes[$i] ";
            
            $finish = 0;
            
            my $row_index_decrease = $row_index;
            
            while (!$finish) {
                $finish = 1;
                
                for ($j = 0; $j < $row_index_decrease - 1; $j++) {
                    if ($i > 0) { ### control order by data sorted base on previous column
                        my $k = $i - 1;

                        while ($k >= 0) {
                            if ($array_hash_ref_data[$j]->{$columns[$k]} eq $array_hash_ref_data[$j + 1]->{$columns[$k]}) {
                                $swap = 1;
                            } else {
                                $swap = 0;
                                $k = -1;
                            }

                            $k--;
                        }

                    } else {
                        $swap = 1;
                    }
                    
                    if ($modes[$i] eq "num") { ### numeric comparison
                        if ($orders[$i] eq "desc") {
                            ### descending order
                            if ($array_hash_ref_data[$j]->{$columns[$i]} < $array_hash_ref_data[$j + 1]->{$columns[$i]}) {
                                if ($swap) {
                                    $this->swap_Array_Item(\@array_hash_ref_data, $j, $j + 1);
                                    $this->swap_Array_Item(\@array_hash_ref_link, $j, $j + 1);
                                    $this->swap_Array_Item(\@array_hash_ref_link_properties, $j, $j + 1);
                                    
                                    $finish = 0;
                                }
                            }
                        } else {
                            ### ascending order
                            if ($array_hash_ref_data[$j]->{$columns[$i]} > $array_hash_ref_data[$j + 1]->{$columns[$i]}) {
                                #print "\$array_hash_ref_data[$j] = " . $array_hash_ref_data[$j] . "<br>";
                                #print "\$array_hash_ref_data[$j+1] = " . $array_hash_ref_data[$j+1] . "<br>";

                                if ($swap) {
                                    $this->swap_Array_Item(\@array_hash_ref_data, $j, $j + 1);
                                    $this->swap_Array_Item(\@array_hash_ref_link, $j, $j + 1);                                  
                                    $this->swap_Array_Item(\@array_hash_ref_link_properties, $j, $j + 1);

                                    $finish = 0;
                                }
                            }
                        }
                        
                    } else { ### string comparison
                        if ($orders[$i] eq "desc") {
                            ### descending order
                            if ($array_hash_ref_data[$j]->{$columns[$i]} lt $array_hash_ref_data[$j + 1]->{$columns[$i]}) {
                                if ($swap) {
                                    $this->swap_Array_Item(\@array_hash_ref_data, $j, $j + 1);
                                    $this->swap_Array_Item(\@array_hash_ref_link, $j, $j + 1);
                                    $this->swap_Array_Item(\@array_hash_ref_link_properties, $j, $j + 1);

                                    $finish = 0;
                                }
                            }
                        } else {
                            ### ascending order
                            if ($array_hash_ref_data[$j]->{$columns[$i]} gt $array_hash_ref_data[$j + 1]->{$columns[$i]}) {
                                #print "\$array_hash_ref_data[$j] = " . $array_hash_ref_data[$j] . "<br>";
                                #print "\$array_hash_ref_data[$j+1] = " . $array_hash_ref_data[$j+1] . "<br>";

                                if ($swap) {
                                    $this->swap_Array_Item(\@array_hash_ref_data, $j, $j + 1);
                                    $this->swap_Array_Item(\@array_hash_ref_link, $j, $j + 1);
                                    $this->swap_Array_Item(\@array_hash_ref_link_properties, $j, $j + 1);
                                    
                                    $finish = 0;
                                }
                            }
                        }
                    }
                }
                
                $row_index_decrease--;
            }
        }
    }
    
    $this->{row_data_array_hash_ref} = \@array_hash_ref_data;
    $this->{row_link_array_hash_ref} = \@array_hash_ref_link;
    $this->{row_link_properties_array_hash_ref} = \@array_hash_ref_link_properties;
}

sub swap_Array_Item {
    my $this = shift @_;
    
    my $array_ref =  shift @_;
    my $index_1 = shift @_;
    my $index_2 = shift @_;
    
    my $temp_item = $array_ref->[$index_1];
    
    $array_ref->[$index_1] = $array_ref->[$index_2];
    $array_ref->[$index_2] = $temp_item;
}

sub get_Column_Num {
    my $this = shift @_;
    
    return $this->{column_num};
}

sub get_Row_Num {
    my $this = shift @_;
    
    return $this->{row_num};
}

sub get_Column_Name {
    my $this = shift @_;
    
    my $column_num = shift @_;
    
    my @column_name_array  = @{$this->{column_name_array_ref}};
    
    return $column_name_array[$column_num];
}

sub get_Data {
    my $this = shift @_;
    
    my $row_index = shift @_;
    my $column_name = shift @_;
    
    my @array_hash_ref = @{$this->{row_data_array_hash_ref}};
    
    my $hash_ref = $array_hash_ref[$row_index];
    
    return $hash_ref->{$column_name};
}

sub get_Data_Get_Link { ### 18/05/2005
    my $this = shift @_;
    
    my $row_index = shift @_;
    my $column_name = shift @_;
    
    my @array_hash_ref = @{$this->{row_link_array_hash_ref}};
    
    my $hash_ref = $array_hash_ref[$row_index];
    
    return $hash_ref->{$column_name};
}

sub get_Data_Get_Link_Properties { ### 19/05/2005
    my $this = shift @_;
    
    my $row_index = shift @_;
    my $column_name = shift @_;
    
    my @array_hash_ref = @{$this->{row_link_properties_array_hash_ref}};
    
    my $hash_ref = $array_hash_ref[$row_index];
    
    return $hash_ref->{$column_name};
}

sub get_Table_List { ### 18/05/2005
    my $this = shift @_;
    
    my @column_name_array = @{$this->{column_name_array_ref}};
    my @array_hash_ref = @{$this->{row_data_array_hash_ref}};
    
    my ($row, $column, $list_table, $hash_ref) = (0, 0, undef, undef);
    
    $list_table = "<table border=1>\n";
    
    $list_table .= "<tr>\n";
    
    for ($column = 0; $column < $this->{column_num}; $column++) {
        $list_table .= "  <td><pre><b>" . $column_name_array[$column] . "</b></pre></td>\n";
    }
    
    $list_table .= "</tr>\n";
    
    for ($row = 0; $row < $this->{row_num}; $row++) {
        $column = 0;
        
        $hash_ref = $array_hash_ref[$row];
        
        $list_table .= "<tr>\n";
        
        for ($column = 0; $column < $this->{column_num}; $column++) {
            $list_table .= "  <td><pre>" . $hash_ref->{$column_name_array[$column]} . "</pre></td>\n";
        }
        
        $list_table .= "</tr>\n";   
    }
    
    $list_table .= "</table>\n";
    
    return $list_table;
}

sub get_Start_Row_Num {
    $this = shift @_;
    
    my $items_view_num = shift @_;
    my $items_set_num = shift @_;
    
    my $start_row_num = undef;
    
    if ($items_view_num > 0 && $items_set_num > 0) {
        $start_row_num = ($items_set_num - 1) * $items_view_num;
        
    } else {
        $start_row_num = 0;
    }
    
    return $start_row_num;
}

sub get_Stop_Row_Num {
    $this = shift @_;
    
    my $items_view_num = shift @_;
    my $items_set_num = shift @_;  
    
    my $stop_row_num = undef;
    
    if ($items_view_num > 0 && $items_set_num > 0) {
        $stop_row_num = $items_set_num * $items_view_num;
            
        if ($stop_row_num > $this->get_Row_Num) {
            $stop_row_num = $this->get_Row_Num;
        }
        
    } else {
        $stop_row_num = $this->get_Row_Num;
    }
    
    return $stop_row_num;
}

sub found_Column_Name { ### 18/05/2005
    my $this = shift @_;
    
    my $column_name = shift @_;
    
    my @column_name_array  = @{$this->{column_name_array_ref}};
    
    my $i = 0;
    
    for ($i = 0; $i < $this->{column_num}; $i++) {
        if ($column_name_array[$i] eq $column_name) {
            return 1;
        }
    }
    
    return 0;
}

1;