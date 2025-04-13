###########################################################################################

# GMM_CGI_Lib Pre-Release 5

# This library intended to be released under GNU General Public License. 
# Please visit http://www.gnu.org/ or contact the author for more info 
# about copied and disribution of this library.

# Copyright 2002-2011, Mohd Razak bin Samingan

# Faculty of Computer Science & Information System,
# 81310 UTM Skudai,
# Johor, MALAYSIA.

# e-mail: mrazak@fsksm.utm.my

###########################################################################################

package Checkbox_Selection;

sub new {
    my $class = shift;
    
    my $name = shift @_;
    my $caption = shift @_; ### array ref.    
    my $value = shift @_;  ### array ref.
    my $checked_value = shift @_; ### array ref.
    my $separator_tag = shift @_;
    
    my $this = {};
    
    $this->{name} = $name;
    $this->{caption} = $caption;
    $this->{value} = $value;
    $this->{checked_value} = $checked_value;
    $this->{separator_tag} = $separator_tag;
    
    bless $this, $class;
    return $this;
}

sub set_Name {
    $this = shift @_;
    $this->{name} = shift @_;
}

sub set_Captions {
    $this = shift @_;
    $this->{caption} = shift @_; ### array ref.
}

sub set_Values {
    $this = shift @_;
    $this->{value} = shift @_; ### array ref.
}

sub set_Checked_Values {
    $this = shift @_;
    $this->{checked_value} = shift @_; ### array ref.
}

sub set_CGI {
    $this = shift @_;
    $this->{cgi} = shift @_;
}

sub set_DBU {
    $this = shift @_;
    $this->{dbu} = shift @_;
}

sub set_DB_Table_Info {
    $this = shift @_;
    
    my $table_name = shift @_;
    my $field_caption = shift @_;
    my $field_value = shift @_;
    my $field_order = shift @_;
    
    if ($this->{dbu} ne undef) {
        my $dbu = $this->{dbu};
        
        $dbu->set_Table($table_name);
        
        my @ahr = $dbu->get_Items("$field_caption $field_value", undef, undef, "$field_order", undef);
        
        my @caps = ();
        my @vals = ();
        
        foreach my $item (@ahr) {
            push(@caps, $item->{$field_caption});
            push(@vals, $item->{$field_value});
        }
        
        $this->{caption} = \@caps;
        $this->{value} = \@vals;
    }
}

sub get_Checkbox_List {
    $this = shift @_;
    
    my $cgi = $this->{cgi};
    
    my %checked_val_map = ();
    
    ### try to automatically set it via $this->{name} CGI var. pattern
    if ($this->{checked_value} eq "") { 
        my @cgi_var_list = $cgi->var_Name;
        
        foreach my $var (@cgi_var_list) {
            if ($var =~ /^$this->{name}/) {
                $checked_val_map{$cgi->param($var)} = "checked";
            }
        }
    } else {
        my @checked_vals = @{$this->{checked_value}};

        foreach my $checked_value (@checked_vals) {
            $checked_val_map{$checked_value} = "checked";
        }    
    }
    
    my @caps = @{$this->{caption}};
    my @vals = @{$this->{value}};
    
    my $content = undef;
    my $rmv_cgivar_dbcache = undef;
    
    for (my $i = 0; $i < @caps; $i++) {
        my $chkbox_name = $this->{name} . "_" . $i;
        
        if ($vals[$i] eq undef) {
            $vals[$i] = $caps[$i];
        }
        
        $content .= "<input type=\"checkbox\" name=\"$chkbox_name\" value=\"$vals[$i]\" $checked_val_map{$vals[$i]}>$caps[$i]\n$this->{separator_tag}\n";
        $rmv_cgivar_dbcache .= "$chkbox_name ";
    }
    
    $cgi->remove_DB_Cache_Var($rmv_cgivar_dbcache);
    
    ### prevent from being loaded back via $cgi->update_DB_Cache_Var inside index.cgi
    $cgi->exclude_DB_Cache_Var($rmv_cgivar_dbcache); 
    
    return $content
}

1;