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

package Link_Structure_Content_Info;


sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{link_id} = shift @_;
    $this->{link_name} = shift @_;
    $this->{link_level} = shift @_;
    $this->{dynamic_content_num} = shift @_;
    $this->{dynamic_content_name} = shift @_; ### 08/01/2009
    $this->{link_ref_type} = shift @_;
    $this->{link_ref_name} = shift @_;
    $this->{blob_content_id} = shift @_;
    
    bless $this, $class;
    
    return $this;
}

sub set_Link_ID {
    my $this = shift @_;
    
    $this->{link_id} = shift @_;
}

sub set_Dynamic_Content_Num {
    my $this = shift @_;
    
    $this->{dynamic_content_num} = shift @_;
}

sub set_Dynamic_Content_Name { ### 08/01/2009
    my $this = shift @_;
    
    $this->{dynamic_content_name} = shift @_;
}

sub set_Link_Name {
    my $this = shift @_;
    
    $this->{link_name} = shift @_;
}

sub set_Link_Level {
    my $this = shift @_;
    
    $this->{link_level} = shift @_;
}

sub set_Link_Ref_Type {
    my $this = shift @_;
    
    $this->{link_ref_type} = shift @_;
}

sub set_Link_Ref_Name {
    my $this = shift @_;
    
    $this->{link_ref_name} = shift @_;
}

sub set_Blob_Content_ID {
    my $this = shift @_;
    
    $this->{blob_content_id} = shift @_;
}


sub get_Link_ID {
    my $this = shift @_;
    
    return $this->{link_id};
}

sub get_Dynamic_Content_Num {
    my $this = shift @_;
    
    return $this->{dynamic_content_num};
}

sub get_Dynamic_Content_Name { ### 08/01/2009
    my $this = shift @_;
    
    return $this->{dynamic_content_name};
}

sub get_Link_Name {
    my $this = shift @_;
    
    return $this->{link_name};
}

sub get_Link_Level {
    my $this = shift @_;
    
    return $this->{link_level};
}

sub get_Link_Ref_Type {
    my $this = shift @_;
    
    return $this->{link_ref_type};
}

sub get_Link_Ref_Name {
    my $this = shift @_;
    
    return $this->{link_ref_name};
}

sub get_Blob_Content_ID {
    my $this = shift @_;
    
    return $this->{blob_content_id};
}

sub print_My_Info {
    my $this = shift @_;
    
    print "<pre>",
          "Link id = " . $this->{link_id} . "; ",
          "Link Name = " . $this->{link_name} . "; ",
          "Link Level = " . $this->{link_level} . "; ",
          "Dynamic Content Num. = " . $this->{dynamic_content_num} . "; ",
          "</pre>";
}

1;