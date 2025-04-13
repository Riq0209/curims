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

package Radio_Option;

sub new {
    my $class = shift;
    my $this = {};
    
    $this->{name} = undef;
    $this->{value} = undef;
    $this->{option} = undef;
    $this->{checked} = undef;
    $this->{css_class} = undef;
    $this->{separator_tag} = undef;
    
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

sub set_Name {
    $this = shift @_;
    $this->{name} = shift @_;
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

sub set_AttrStrings {
    $this = shift @_;
    my(@attrstring) = @_;
    $this->{attrstring} = \@attrstring;
}

sub set_Checked {
    $this = shift @_;
    $this->{checked} = shift @_;
}

sub set_CSS_Class {
    $this = shift @_;
    $this->{css_class} = shift @_;
}

sub set_Separator_Tag {
    $this = shift @_;
    $this->{separator_tag} = shift @_;
}

sub get_Radio {
    $this = shift @_;
    
    my $array_ref = undef;
    
    $array_ref = $this->{value};
    @value = @$array_ref;
    
    $array_ref = $this->{option};
    @option = @$array_ref;
    
    $array_ref = $this->{attrstring};
    @attrstring = @$array_ref;
    
    if ($#value != $#option) {
        return "Error: number of values not equal with number of options\n";
        
    } else {
        my $radio = "";
        
        for ($i = 0; $i < @value; $i++) {
            if ($value[$i] eq $this->{checked}) {
                $radio .= "<input class=\"$this->{css_class}\" type=\"radio\" name=\"$this->{name}\" value=\"$value[$i]\" $attrstring[$i] checked><label>$option[$i]</label>$this->{separator_tag}\n";
                    
            } else {
                $radio .= "<input class=\"$this->{css_class}\" type=\"radio\" name=\"$this->{name}\" value=\"$value[$i]\" $attrstring[$i]><label>$option[$i]</label>$this->{separator_tag}\n\n";
            }
        }
        
        return $radio;
    }
}

1;