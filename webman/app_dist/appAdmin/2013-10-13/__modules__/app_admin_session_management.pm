package app_admin_session_management;

require webman_CGI_component;

@ISA=("webman_CGI_component");

sub new {
	my $type = shift;
	
	my $this = webman_CGI_component->new();
	
	$this->set_Component_Name("app_admin_session_management");
	
	#$this->set_Debug_Mode(1, 1);
	
	$this->{template_default} = undef;
	
	bless $this, $type;
	
	return $this;
}

sub run_Task {
	my $this = shift @_;
	
	my $cgi = $this->get_CGI;
	my $db_conn = $this->get_DB_Conn;
	my $db_interface = $this->get_DB_Interface;
	
	$this->SUPER::run_Task();
}

sub process_Content {
	$this = shift @_;
	
	my $cgi = $this->get_CGI;
	my $db_conn = $this->get_DB_Conn;
	my $db_interface = $this->get_DB_Interface;
	
	$this->set_Template_File($this->{template_default});
	
	#print "\$this->{template_default} = " . $this->{template_default} . "<br>";
	
	$this->SUPER::process_Content;	
}

sub process_so_type_ { ### so_type_ can be: VIEW, DYNAMIC, LIST, MENU, DBHTML, SELECT, DATAHTML
	my $this = shift @_;
	my $te = shift @_;

	my $cgi = $this->get_CGI;
	my $db_conn = $this->get_DB_Conn;
	my $db_interface = $this->get_DB_Interface;
	
	my $te_content = $te->get_Content;
	my $te_type_num = $te->get_Type_Num;
	
	$this->add_Content($te_content);
}

1;
