package webman_component_init;

use webman_CGI_component;

@ISA=("webman_CGI_component");

### customized application modules

sub new {
    my $class = shift @_;
    
    my $this = {};
    
    my $this = $class->SUPER::new();
    
    #$this->set_Debug_Mode(1, 1);
    
    bless $this, $class;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return $this->SUPER::get_Name_Full . "::" . __PACKAGE__;
}


1;