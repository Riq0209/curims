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

package Text_DB_Map;

use DB_Utilities;
use Table_List_Data;

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{txt_file_name} = undef;
    $this->{txt_file_content} = undef;
    $this->{spliter_col} = undef;
    $this->{spliter_row} = undef;
    
    $this->{db_conn} = undef;
    $this->{table_name} = undef;
    
    ### arraf reference of fields order/sequence
    $this->{field_list} = undef;
    
    $this->{key_field_name} = undef;
    
    ### can be 36Base or 62Base,  
    ### default is auto_increment
    $this->{key_field_type} = undef; 
    
    ### default for 36Base and 62Base is 6 and 
    ### will be ignored if key_field_type is
    ### auto_icrement
    $this->{key_field_length} = undef;
    
    ### 01/01/2014
    ### to accept blank field, it must be 
    ### first converted
    $this->{blank_field_conversion} = undef;
    
    bless $this, $class;
    
    return $this;
}

sub set_Text_File_Name {
    my $this = shift @_;
    
    $this->{txt_file_name} = shift @_;
}

sub set_Text_File_Content {
    my $this = shift @_;
    
    $this->{txt_file_content} = shift @_;
}

sub set_Spliter_Column {
    my $this = shift @_;
    
    $this->{spliter_col} = shift @_;
}

sub set_Spliter_Row {
    my $this = shift @_;
    
    $this->{spliter_row} = shift @_;
}

sub set_Conn {
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
    
    my $dbu = new DB_Utilities;
    
    $dbu->set_DBI_Conn($this->{db_conn});
  
    $this->{dbu} = $dbu;
}

sub set_Table_Name {
    my $this = shift @_;
    
    $this->{table_name} = shift @_;
}

sub set_Field_List {
    my $this = shift @_;
    
    $this->{field_list} = shift @_;
}

sub set_Key_Field_Name {
    my $this = shift @_;
    
    $this->{key_field_name} = shift @_;
}

sub set_Key_Field_Type {
    my $this = shift @_;
    
    $this->{key_field_type} = shift @_;
    
    if ($this->{key_field_type} ne "36Base" && 
        $this->{key_field_type} ne "62Base") {
        
        $this->{key_field_type} = "auto_increment";
    }
}

sub set_Key_Field_Length {
    my $this = shift @_;
    
    $this->{key_field_length} = shift @_;
}

### 01/01/2014
sub set_Blank_Field_Conversion {
    my $this = shift @_;
    
    $this->{blank_field_conversion} = shift @_;
}

sub get_TLD {
    my $this = shift @_;
    
    return $this->{tld};
}

sub insert_Row {
    my $this = shift @_;
    
    $this->generate_TLD;
    
    my $tld = $this->{tld};
    my $dbu = $this->{dbu};
    
    my $row_num = $tld->get_Row_Num;
    my $col_num = $tld->get_Column_Num;    
    
    for (my $i = 0; $i < $row_num; $i++) {
        my $col_name = undef;
        my $col_data = undef;
        
        for (my $j = 0; $j < $col_num; $j++) {
            $col_name .= $tld->get_Column_Name($j) . " ";
            
            my $data = $tld->get_Data($i, $tld->get_Column_Name($j));
            
            $data =~ s/ /\\ /g;
            
            $col_data .= "$data ";
        }
        
        $col_name =~ s/ $//;
        $col_data =~ s/ $//;
        
        #print "$col_name $col_data\n";
        
        $dbu->insert_Row($col_name, $col_data);
    }
}

sub update_Row {
    my $this = shift @_;
    
    $this->generate_TLD;
    
    my $tld = $this->{tld};
    my $dbu = $this->{dbu};
    
    my $row_num = $tld->get_Row_Num;
    my $col_num = $tld->get_Column_Num;
    
    for (my $i = 0; $i < $row_num; $i++) {
        my $col_name = undef;
        my $col_data = undef;
        
        my $key_field = undef;
        my $key_value = undef;
        
        for (my $j = 0; $j < $col_num; $j++) {
            if ($tld->get_Column_Name($j) eq $this->{key_field_name}) {
                $key_field = $tld->get_Column_Name($j);
                $key_value = $tld->get_Data($i, $tld->get_Column_Name($j));
                
            } else {
                $col_name .= $tld->get_Column_Name($j) . " ";
            
                my $data = $tld->get_Data($i, $tld->get_Column_Name($j));
            
                $data =~ s/ /\\ /g;
            
                $col_data .= "$data ";
            }
        }
        
        $col_name =~ s/ $//;
        $col_data =~ s/ $//;
        
        #print "$key_field = $key_value\n";
        #print "$col_name $col_data\n";
        
        $dbu->update_Item($col_name, $col_data, $key_field, $key_value);
        
        #print $dbu->get_SQL . "\n";
    }    
}

sub generate_TLD {
    my $this = shift @_;
    
    my $cgi = shift @_;
    
    $this->{dbu}->set_Table($this->{table_name});
    
    my $tld = new Table_List_Data;
    
    foreach my $col_name (@{$this->{field_list}}) {        
        $tld->add_Column($col_name);
    }
    
    ###########################################################################
    
    if (!defined($this->{spliter_row})) {
        $this->{spliter_row} = "\n";
    }
    
    my @file_content = ();
    
    if (defined($this->{txt_file_name})) {
        if (open(MYFILE, $this->{txt_file_name})) {
            
            if ($this->{spliter_row} eq "\n") {
                @file_content = <MYFILE>;
                
            } else {
                my $line = undef;
                my $txt_content = undef;
                
                while ($line = <MYFILE>) {
                    $txt_content .= $line;
                }
                
                @file_content = split(/$this->{spliter_row}/, $txt_content);
            }
            
            close(MYFILE);
        }
    }
    
    if ($this->{txt_file_content} ne "" && !defined($this->{txt_file_name})) {
        @file_content = split(/$this->{spliter_row}/, $this->{txt_file_content});
    }
    
    ###########################################################################
    
    foreach my $line (@file_content) {
        $line =~ s/\n//;
        $line =~ s/\r//;
        
        #print "$line\n";
        
        if (!defined($this->{spliter_col})) {
            $this->{spliter_col} = "\t";
        }
        
        my $spliter_col = $this->{spliter_col};
        
        $spliter_col =~ s/\|/\\\|/; 
        
        ### 01/01/2014 start
        my $spliter_count =()= $line =~ /$spliter_col/gi;
        my $field_count = $spliter_count + 1;
        
        my @cols = split(/$spliter_col/, $line);
        my @data = ();
        
        foreach (my $i = 0; $i < $field_count; $i++) {
            while ($cols[$i] =~ /^ / || $cols[$i] =~ / $/) {
                $cols[$i] =~ s/^ //;
                $cols[$i] =~ s/ $//;
            }
            
            if ($cols[$i] ne "") {
                push(@data, $cols[$i]);
                
            } elsif (defined($this->{blank_field_conversion})) {
                push(@data, $this->{blank_field_conversion});
            }
            
            #$cgi->add_Debug_Text("\$cols[$i] = $cols[$i]", __FILE__, __LINE__);
        }
        ### 01/01/2014 end
        
        ### check if @data and field_list has the same number of columns        
        if (@data == @{$this->{field_list}}) {
            $tld->add_Row_Data(@data);            
        }
    }
    
    ###########################################################################
    
    if ($this->{key_field_type} eq "36Base" ||
        $this->{key_field_type} eq "62Base") {
        
        if (grep(/^$this->{key_field_name}$/,@{$this->{field_list}})) {
            ### the key field name already exist 
            ### in the field list so do nothing
            
        } else {
            $tld->add_Column($this->{key_field_name});

            for (my $i = 0; $i < $tld->get_Row_Num; $i++) {
                my $rnd362base = undef;

                if ($this->{key_field_type} eq "36Base") {
                    $rnd362base = $this->{dbu}->get_Unique_Random_36Base($this->{key_field_name}, $this->{key_field_length});

                } else {
                    $rnd362base = $this->{dbu}->get_Unique_Random_62Base($this->{key_field_name}, $this->{key_field_length});
                }

                $tld->set_Data($i, $this->{key_field_name}, $rnd362base);
            }
        }
    }
    
    $this->{tld} = $tld;
    
    return $tld;
}


1;