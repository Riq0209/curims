package webman_init;

use webman_CGI_component;

@ISA=("webman_CGI_component");

### customized application modules

sub new {
    my $class = shift @_;
        
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

sub run_Task {
    my $this = shift @_;
    
    $this->SUPER::run_Task();
    
    #print "<font color=\"#FF00FF\">run_Task from webman_init</font><br>\n";
    
    #$this->print_Link_Path_Info;
}

1;