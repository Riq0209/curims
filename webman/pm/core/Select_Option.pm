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

package Select_Option;

sub new {
    my $class = shift;
    my $this = {};
    
    $this->{value} = undef;
    $this->{option} = undef;
    $this->{selected} = undef;
    
    bless $this, $class;
    return $this;
}

sub set_DBI_Conn { ### 18/10/2006
    $this = shift @_;
    $this->{dbi_conn} = shift @_;
}

sub set_Values_From_DBI_SQL { ### 18/10/2006
    $this = shift @_;
    my $sql = shift @_;
    
    my $item = undef;
    my @data = undef;
    my @values = undef;
    my $counter = 0;
    
    my $dbi_conn = $this->{dbi_conn};
    my $sth = $dbi_conn->prepare($sql);
    
    $sth->execute;
    
    while (@data = $sth->fetchrow_array) {
        $values[$counter] = $data[0];
        $counter++;
    }
        
    $this->{value} = \@values;
    
    if ($this->{option} eq undef) {
        $this->{option} = \@values;
    }
    
    $sth->finish;
}

sub set_Options_From_DBI_SQL { ### 18/10/2006
    $this = shift @_;
    my $sql = shift @_;
    
    my $item = undef;
    my @data = undef;
    my @options = undef;
    my $counter = 0;
    
    my $dbi_conn = $this->{dbi_conn};
    my $sth = $dbi_conn->prepare($sql);
    
    $sth->execute;
    
    while (@data = $sth->fetchrow_array) {
        $options[$counter] = $data[0];
        $counter++;
    }
    
    $this->{option} = \@options;
    
    if ($this->{value} eq undef) {
        $this->{value} = \@options;
    }
    
    $sth->finish;
}

sub set_Values_From_DB {
    $this = shift @_;
    $result = shift @_;
    
    $item = "";
    while (@data = $result->fetchrow) {
        $item .= "$data[0],";
    }
    
    #print "item = $item\n";
    @value = split(/\,/, $item);
    $this->{value} = \@value;
    $this->{option} = \@value;
}

sub set_Options_From_DB {
    $this = shift @_;
    $result = shift @_;
    
    $item = "";
    while (@data = $result->fetchrow) {
        $item .= "$data[0],";
    }
    
    #print "item = $item\n";
    @option = split(/\,/, $item);
    $this->{option} = \@option;
}

sub set_Values_From_DBI { ### 15/07/2004
    my $this = shift @_;
    my $sth = shift @_;
    
    my @values = undef;
    my $counter = 0;
    
    $sth->execute;
    
    while (@data = $sth->fetchrow_array) {
        $values[$counter] = $data[0];
        $counter++;
    }
    
    $this->{value} = \@values;
    $this->{option} = \@values;
    
    $sth->finish;
}

sub set_Options_From_DBI { ### 15/07/2004
    my $this = shift @_;
    my $sth = shift @_;
    
    my @options = undef;
    my $counter = 0;
    
    $sth->execute;
    
    while (@data = $sth->fetchrow_array) {
        $options[$counter] = $data[0];
        $counter++;
    }
    
    $this->{option} = \@options;
    
    $sth->finish;
}

sub set_Values {
    $this = shift @_;
    my(@value) = @_;
    $this->{value} = \@value;
    $this->{option} = \@value;
}

sub set_Options {
    $this = shift @_;
    my(@option) = @_;
    $this->{option} = \@option;
}

sub set_Selected {
    $this = shift @_;
    my(@selected) = @_;
    $this->{selected} = \@selected;
}

sub get_Selection {
    $this = shift @_;
    
    $array_ref = $this->{value};
    @value = @$array_ref;
    
    $array_ref = $this->{option};
    @option = @$array_ref;
    
    $array_ref = $this->{selected};
    @selected = @$array_ref;
    
    if ($#value != $#option) {
        return "Error: number of values not equal with number of options\n"; 
    } else {
        my $selection = "";
        
        for ($i = 0; $i < @value; $i++) {
            $found = 0;
                
            for ($j = 0; $j < @selected; $j++) {
                if ($value[$i] eq $selected[$j]) {
                    $selection .= "<option value=\"$value[$i]\" selected>$option[$i]</option>\n";
                    $found = 1;
                }
            }
            
            if (!$found) {
                $selection .= "<option value=\"$value[$i]\">$option[$i]</option>\n";
            }
        }
        
        return $selection;
    }
}


1;