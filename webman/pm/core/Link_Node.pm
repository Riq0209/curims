###########################################################################################

# TukangWeb Pre-Release 1

# This library intended to be released under GNU General Public License. 
# Please visit http://www.gnu.org/ or contact the author for more info 
# about copies and disribution of this library.

# Copyright 2002-2010, Mohd Razak bin Samingan

# Faculty of Computer Science & Information System,
# 81310 UTM Skudai,
# Johor, MALAYSIA.

# e-mail: mrazak@utm.my

###########################################################################################

package Link_Node;

use strict;

sub new {
    my $class = shift;
    my $this = {};

    $this->{args} = shift; ### hash reference
    
    $this->{text} = undef;
    $this->{target} = undef;
    $this->{info_hash} = undef; ### hash reference
    
    $this->{parent} = undef; ### reference to other single Tree_Node instance
    $this->{next_sibling} = undef; ### reference to other single Tree_Node instance
    $this->{childs} = undef; ### reference to array of reference to other Tree_Node instances
    $this->{level} = 0;
    
    $this->{warning_text} = undef;
    
    bless $this, $class;
    
    $this->init_Vars;    
    
    return $this;    
}

sub init_Vars {
    my $this = shift;
    
    if (defined($this->{args})) {
        my %args = %{$this->{args}};
        
        foreach my $key (keys(%args)) {
            $this->{$key} = $args{$key};
        }
    }
}

sub set_Text {
    my $this = shift;
    
    $this->{text} = shift;   
}

sub get_Text {
    my $this = shift;
    
    return $this->{text};
}

sub set_Target {
    my $this = shift;
    
    $this->{target} = shift;
}

sub get_Target {
    my $this = shift;
    
    return $this->{target};
}

sub set_Info_Hash {
    my $this = shift;
    
    $this->{info_hash} = shift;   
}

sub get_Info_Hash {
    my $this = shift;
    
    return $this->{info_hash};
}

sub set_Parent {
    my $this = shift;
    
    my $parent = shift;
    
    my $child = shift; ### this only used internally within this module for the  
                       ### purpose handling internal recursive calling between 
                       ### set_Parent and add_Child
    
    #print "set_Parent after $child\n";
    
    if ($parent) {
        if ($parent ne $this) { ### $parent must be other Link_Node instance
            $this->{parent} = $parent;
            
            if (!$child) { ### only call add_Child if $child not already set
                $parent->add_Child($this, $parent); ### set $this as child to $parent and inform $parent
            }                                       ### that itself has been set as parent to $this
            
            return 1;
            
        } else {
            $this->{warning_text} .= "$this: Can't set parent node. Parent is the same node.\n";        
        }
    } else {
        $this->{warning_text} .= "$this: Can't set parent node. Parent is undef.\n";
    }
    
    return 0;
}

sub get_Parent {
    my $this = shift;
    
    return $this->{parent};
}

sub set_Next_Sibling {
    my $this = shift;
    
    $this->{next_sibling} = shift;
}

sub get_Next_Sibling {
    my $this = shift;
    
    return $this->{next_sibling};
}

sub detach_Parent {
    my $this = shift;
    
    $this->{parent} = undef;
}

sub add_Child {
    my $this = shift;
    
    my $child = shift;
    
    my $parent = shift; ### this only used internally within this module for the  
                        ### purpose handling internal recursive calling between 
                        ### set_Parent and add_Child
    
    #print "add_Child after $parent\n";    
    
    if ($child) { 
        if ($child eq $this) { ### $child must be other Link_Node instance
            $this->{warning_text} .= "$this: Can't add child node. Child is the same node.\n";
                return 0;
        }
        
        my @current_childs = ();
        
        if (!$this->{childs}) {
            $this->{childs} = []; ### create anonymous array ref.
            
        } else {
            @current_childs = @{$this->{childs}};
        }
        
        foreach my $item (@{$this->{childs}}) {
            if ($child eq $item) {
                $this->{warning_text} .= "$this: Can't add child node. Parent already has the same child.\n";
                return 0;
            }
        }
        
        $child->set_Level($this->{level} + 1);
        
        if (@current_childs) {
            $current_childs[@current_childs - 1]->set_Next_Sibling($child);
        }
        
        push(@{$this->{childs}}, $child);
        
        if (!$parent) { ### only call set_Parent if $parent not already set 
            $child->set_Parent($this, $child); ### set $this as a parent to $child and inform $child
        }                                      ### that itslef has been set as one of child of $this 
        
        return 1;
        
    } else {
        $this->{warning_text} .= "$this: Can't add child node. Child is undef.\n";
    }
    
    return 0;
}

sub detach_Child {
    my $this = shift;
    
    my $child_index = shift;
}

sub get_Childs {
    my $this = shift;

    if ($this->{childs}) {
        return @{$this->{childs}};
        
    } else {
        return ();
    }
}

sub set_Level {
    my $this = shift;
    
    $this->{level} = shift;
}

sub get_Level {
    my $this = shift;
    
    return $this->{level};
}

sub get_Warning_Text {
    my $this = shift;
    
    return $this->{warning_text};
}

1;