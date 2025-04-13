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

package DBI_HTML_Map;

use Table_List_Data;

sub new {
    my $class = shift;
    my $this = {};
    
    $this->{dbi_conn} = shift @_;
    $this->{sql} = shift @_;
    
    $this->{items_view_num} = undef;
    $this->{items_set_num} = undef;
    $this->{items_num} = undef;
    
    $this->{special_tag_view} = 0; ### 30/08/2005
    #$this->{escape_HTML_tag} = 0;  ### 01/04/2009
    $this->{escape_HTML_tag} = 1; ### 15/08/2024
    
    bless $this, $class;
    return $this;
}

sub set_DBI_Conn {
    my $this = shift @_;
    
    $this->{dbi_conn} = shift @_;
}

sub set_SQL {
    my $this = shift @_;
    
    $this->{sql} = shift @_;
}

sub set_HTML_Code {
    my $this = shift @_;
    
    $this->{HTML_Code} = shift @_;
}

sub set_Items_View_Num {
    my $this = shift @_;
    
    $this->{items_view_num} = shift @_;
}

sub set_Items_Set_Num {
    my $this = shift @_;
    
    $this->{items_set_num} = shift @_;
}

sub set_Special_Tag_View { ### 30/08/2005
    my $this = shift @_;
    
    $this->{special_tag_view} = shift @_;
}

sub set_Escape_HTML_Tag { ### 01/04/2009
    my $this = shift @_;
    
    $this->{escape_HTML_tag} = shift @_;
}

sub get_SQL { ### 29/01/2007
    my $this = shift @_;
    
    return $this->{sql};
}

sub get_DB_Error_Message {
    my $this = shift @_;
    
    return $this->{db_error};
}


sub get_HTML_Code {
    my $this = shift @_;
    
    my $this_content = undef;
    my $count = undef;
    my $start_print = undef;
    my $start_num = undef;
    my $stop_num = undef;
        
    my $this_DBI_Conn = $this->{dbi_conn};
    my $this_SQL = $this->{sql};
    my $this_HTML_Code = $this->{HTML_Code};
    
    my $sth = $this_DBI_Conn->prepare("$this_SQL");
    
    if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
    
    $sth->execute;
    
    if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
    
    if ($sth->rows == 0) {
        $sth->finish;
        return $this_HTML_Code;
    }
    
    my @fname = ("");
    
    my $count = 0;
    
    if ($sth->{NAME}) { ### 06/09/2018
        while (($f_name = $sth->{NAME}->[$count]) ne "") {
                $fname[$count] = $f_name;
                $count++;
        }
        
        $count = 1;
        
        while (@data = $sth->fetchrow_array) {
            
            if ($this->{items_view_num} > 0 && $this->{items_set_num} > 0) {
                $start_print = 0;
                
                $start_num = $this->{items_view_num} * $this->{items_set_num} - $this->{items_view_num} + 1;
                $stop_num = $start_num + $this->{items_view_num};
                
                if ($count >= $start_num && $count < $stop_num) {
                    $start_print = 1;
                }
                
            } else {
                $start_print = 1;
            }
            
            if ($start_print == 1) {
        
                $temp = $this_HTML_Code;
            
                for (my $i = 0; $i < @data; $i++) {
                    if ($this->{special_tag_view} || $this->{escape_HTML_tag}) {
                        $data[$i] =~ s/&/&amp;/g; ### 24/08/2005
                        $data[$i] =~ s/</&lt;/g;
                        $data[$i] =~ s/>/&gt;/g;
                        $data[$i] =~ s/"/&quot;/g; ### "
                    }
                    
                    $pattern = "db_$fname[$i]_";
                    $temp =~ s/\$\b$pattern\b/$data[$i]/g; 
                }
                
                $temp =~ s/\$num_/$count/;
                $this_content .= $temp;
            }
            
            $count++;
        }
        
        $sth->finish;
        
        $this->{items_num} =  $count - 1;
    
    }
    
    return $this_content;
}

sub get_Table_List_Data { ### 18/05/2005
    my $this = shift @_;
    
    my $this_content = undef;
    my $count = undef;
    my $start_print = undef;
    my $start_num = undef;
    my $stop_num = undef;
        
        
    my $this_DBI_Conn = $this->{dbi_conn};
    my $this_SQL = $this->{sql};
    my $this_HTML_Code = $this->{HTML_Code};
    
    my $sth = $this_DBI_Conn->prepare("$this_SQL");
    
    if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
    
    $sth->execute;
    
    if ($DBI::errstr) { $this->{db_error} = $DBI::errstr; }
    
    
    if ($sth->rows == 0) {
        $sth->finish;
        return 0;
    }
    
    
    $count = 1;
    
    my @ahr = ();
    my $data = undef;
    while ($data = $sth->fetchrow_hashref) { ### 14/06/2011
        if ($this->{items_view_num} > 0 && $this->{items_set_num} > 0) {
            $start_print = 0;
            
            $start_num = $this->{items_view_num} * $this->{items_set_num} - $this->{items_view_num} + 1;
            $stop_num = $start_num + $this->{items_view_num};
            
            if ($count >= $start_num && $count < $stop_num) {
                $start_print = 1;
            }
            
        } else {
            $start_print = 1;
        }
        
        if ($start_print == 1) {
            if ($this->{special_tag_view} || $this->{escape_HTML_tag}) { ### 01/04/2009
                foreach my $key (keys(%{$data})) { ### 14/06/2011
                    $data->{$key} =~ s/&/&amp;/g;
                    $data->{$key} =~ s/</&lt;/g;
                    $data->{$key} =~ s/>/&gt;/g;
                    $data->{$key} =~ s/"/&quot;/g; ### "
                }
            }
            
            push(@ahr, $data) 
        }
        
        $count++;
    }
    
    my $tld = new Table_List_Data;
    
    $tld->add_Array_Hash_Reference(@ahr); ### 14/06/2011
    
    $sth->finish;
    
    $this->{items_num} =  $count - 1;

    return $tld;
}


sub get_Items_Num {
    my $this = shift @_;
    
    return $this->{items_num};
}


sub get_Total_Items_Set_Num {
    my $this = shift @_;
    
    my $num = $this->{items_num} / $this->{items_view_num};
            
    if ($this->{items_num} % $this->{items_view_num} != 0) {
        $num++;
        $num = substr ($num, 0, index($num, "."));
    }
    
    return $num;

}

1;
