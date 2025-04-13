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

package Web_Service_Entity;

use JSON;
use LWP::Simple;
use Table_List_Data;

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{local_session} = undef;
    $this->{ws_session_var} = undef;
    $this->{ws_session} = undef;
    
    bless $this, $class;
    
    return $this;
}

sub set_Local_Session {
    my $this = shift @_;
    
    $this->{local_session} = shift @_;
}

sub set_Web_Service_Session_Var { ### 09/10/2012
    my $this = shift @_;
    
    $this->{ws_session_var} = shift @_;
}

sub set_Web_Service_URL { ### 22/01/2011
    my $this = shift @_;
    
    $this->{ws_url} = shift @_;
}

sub get_Entity {
    my $this = shift @_;
    
    my $arg_hr = shift @_;
    
    my $get_data = undef;
    
    foreach my $key (keys(%{$arg_hr})) {
        $get_data .= "$key=" . $arg_hr->{$key} . "&"; 
    }
    
    $get_data =~ s/\&$//;
    
    my $url = $this->{ws_url} . "?$get_data";
    my $json_text = get($url);
    
    #print $json_text;
    
    if ($json_text ne "") {
        my $json = new JSON;
        my $entity = $json->decode($json_text);
        
        return $entity;
    }
    
    return undef;
}

sub get_TLD {
    my $this = shift @_;
    
    my $entity = shift @_;
    
    my $tld = new Table_List_Data;
    
    $tld->add_Array_Hash_Reference(@{$entity->[0]->{list}});
    
    return $tld;
}

1;