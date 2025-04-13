package Webman_Module_Updater;

use Cwd;

sub new {
    my $class = shift @_;
    
    my $init_ref = shift @_;
    my $dbu = shift @_;
    my $arg = shift @_;
    
    my $this = {};
    
    $this->{wmct} = $init_ref->{wmct};
    $this->{app_name} = $init_ref->{app_name};
    $this->{table_name} = $init_ref->{table_name};
    $this->{dbts} = $init_ref->{dbts}; ### dbts stand for database table structure (array ref. of hash ref.)
    $this->{dbt_schema} = $init_ref->{dbt_schema};
    $this->{dbt_med_schema} = $init_ref->{dbt_med_schema};
    
    $this->{dbu} = $dbu;
    $this->{arg} = $arg;
    
    $this->{app_path_module} = $this->{wmct}->{dir_base} . "/webman/pm/apps/" . $this->{app_name} . "/";
    
    
    
    bless $this, $class;
    
    return $this;
}

sub get_Name {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub get_Name_Full {
    my $this = shift @_;
    
    return __PACKAGE__;
}

sub rewrite_Main_Controller {
    my $this = shift @_;
    
    my $wmct = $this->{wmct};
    my $app_name = $this->{app_name};
    
    $this->{app_path_module} = $this->{wmct}->{dir_base} . "/webman/pm/apps/" . $this->{app_name};
    
    print "\n\n";
    print "### Update modules inside the main controller ($this->{app_path_module}/$this->{app_name}.pm): \n";
    
    my @modules = sort($this->get_Module_List($this->{app_path_module}));
    
    my $count = 1;
    my $content_module = "\n";
    
    foreach my $module(@modules) {        
        if ($module ne $this->{app_name}) {
            print "$count. $module\n";
            $count++;
            
            $content_module .= "use $module;\n";
        }
    }
    
    $content_module .= "\n";
    
    my $content_part1 = undef;
    my $content_part2 = undef;
    
    if (open(MYFILE, "<$this->{app_path_module}/$this->{app_name}.pm")) {
        my @file_content = <MYFILE>;

        my $capture = 1;
        
        foreach my $line (@file_content) {
            if ($line =~ /\#__cust_mod__/) {
                if ($capture == 1) {
                    $capture = 0;
                    $content_part1 .= $line;
                    
                } elsif ($capture == 0) {
                    $capture = 2;
                }
            }
         
            if ($capture == 1) {
                $content_part1 .= $line;
                
            } elsif ($capture == 2) {
                $content_part2 .= $line;
            }           
        }
        
        close(MYFILE);
        
        if (open(MYFILE, ">$this->{app_path_module}/$this->{app_name}.pm")) {
            print MYFILE ($content_part1 . $content_module . $content_part2);
            close(MYFILE);
        }
    }
    
    print "\n\n";
}

sub get_Module_List {
    my $this = shift @_;
    
    my $current_dir = shift @_;
    
    opendir(DIRHANDLE, $current_dir);

    my @ref_points = readdir(DIRHANDLE);
    my @modules = ();

    my $count = 1;
    
    #print "\$current_dir = $current_dir\n";

    foreach my $pointer (@ref_points) {
        if (-f "$current_dir/$pointer" && $pointer =~ /\.pm$/) {
            #print "$count. $pointer\n";
            
            $pointer =~ s/\.pm$//;
            
            push(@modules, $pointer);
            
            $count++;  
        } 
    }
    
    return @modules;
}

1;