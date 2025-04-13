package Deploy_File_Input;

sub new {
    my $class = shift;
    
    my $this = {};
    
    bless $this, $class;
    
    $this->process_File_Input;
    
    return $this;
}

sub process_File_Input {
    my $this = shift;
    
    if (open(MYFILE, "<./deploy_default_input.txt")) {
        my @file = <MYFILE>;
        
        foreach my $line (@file) {
            if (!($line =~ /^#/)) {
                #print $line;
                
                $line =~ s/\n//;
                
                my @data = split(/ /, $line);
                
                if (@data > 3) {
                    $this->{dns} = $data[0];
                    $this->{username} = $data[1];
                    $this->{password} = $data[2];
                    $this->{app_name} = $data[3];
                    
                    if (defined($data[4])) {
                        $this->{proceed_task} = $data[4];
                    }
                }

            }
        }
        
        close(MYFILE);
    }
}

sub get_DNS {
    my $this = shift;
    
    return $this->{dns};
}

sub get_Username {
    my $this = shift;
    
    return $this->{username};
}

sub get_Password {
    my $this = shift;
    
    return $this->{password};
}

sub get_App_Name {
    my $this = shift;
    
    return $this->{app_name};
}

sub get_Proceed_Task {
    my $this = shift;
    
    return $this->{proceed_task};
}

1;