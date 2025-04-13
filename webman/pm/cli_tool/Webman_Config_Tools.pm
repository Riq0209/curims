package Webman_Config_Tools;

use Cwd;

sub new {
    my $class = shift @_;
    
    my $this = {};
    
    bless $this, $class;
    
    $this->process_Conf;
    
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

sub get_Today_ISO {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

    $year += 1900;
    $mon += 1;

    if ($mon < 10) {
        $mon = "0" . $mon;
    }

    if ($mday < 10) {
        $mday = "0" . $mday;
    }
    
    return "$year-$mon-$mday";
}

sub get_YN_Options {
    my $this = shift @_;
    
    my $instruct_str = shift @_;
    my $opt = undef;
    
    while ($opt ne "y" and $opt ne "n") {
        print "$instruct_str [y/n]: ";
        
        $opt = <STDIN>;
        $opt =~ s/\n//;
        $opt =~ s/\r//;
    }
    
    if ($opt eq "y") {
        return 1;
        
    } else {
        return 0;
    }
}

sub process_Conf {
    my $this = shift @_;
    
    my $base_dir = getcwd;
       $base_dir =~ s/\/webman.*//; 
       
    #print "Base directory:  $base_dir\n";
    
    my %cnf_info = undef;

    ###########################################################

    if (open(CNF_FILE, "<./conf/dir_org.conf")) {
        my @file_content = <CNF_FILE>;

        close(CNF_FILE);

        foreach my $line (@file_content) {
            if ($line =~ /^#/) {
                ### do nothing, it's a comments
            } else {
                $line =~ s/\n//;
                $line =~ s/\r//;
                $line =~ s/ //g;
                $line =~ s/__base__/$base_dir/;

                my @data = split(/=/, $line);
                $data[1] =~ s/\/$//;
                $cnf_info{$data[0]} = $data[1];
            }
        }

        $this->{perl_bin} = $cnf_info{"perl_bin"};

        $this->{dir_base} = $cnf_info{"base"};
        $this->{dir_local} = $cnf_info{"local"};
        $this->{dir_web_public} = $cnf_info{"web_public"};
        $this->{dir_web_cgi} = $cnf_info{"web_cgi"};
    }

    ###########################################################

    if (open(CNF_FILE, "<./conf/dbi_connection.conf")) {
        my @file_content = <CNF_FILE>;

        close(CNF_FILE);

        foreach my $line (@file_content) {
            if ($line =~ /^#/) {
                ### do nothing, it's a comments
            } else {
                $line =~ s/\n//;
                $line =~ s/\r//;
                $line =~ s/ //g;

                my @data = split(/=/, $line);

                $cnf_info{$data[0]} = $data[1];
            }
        }

        $this->{db_host} = $cnf_info{"db_host"};
        $this->{db_driver} = $cnf_info{"db_driver"};
        $this->{db_name} = $cnf_info{"db_name"};
        $this->{db_user_name} = $cnf_info{"db_user_name"};
        $this->{db_password} = $cnf_info{"db_password"};
    }    
    
    $this->{cnf_info} = \%cnf_info;
}

sub get_Configuration_Info {
    my $this = shift @_;
    
    return $this->{cnf_info};
}

sub get_DBT_Schema {
    my $this = shift @_;
    
    my $app_name = shift @_;
    
    #print __FILE__, __LINE__, "<./conf/dbt_schema_" . $app_name . ".conf\n";
    
    if (open(MYFILE, "<./conf/dbt_schema_" . $app_name . ".conf")) {
        my @file_content = <MYFILE>;
        close(MYFILE);
        
        my $schema_struct = {};
        
        foreach my $line (@file_content) {
            $line =~ s/\n//;
            $line =~ s/\r//;
            
            while ($line =~ / /) {
                $line =~ s/ //g;
            }
            
            my @data = split(/>/, $line);
            
            my $bound_key = $data[1];
            
            my @data_left = split(/-/, $data[0]);
            my @data_right = split(/-/, $data[2]);
                
            my $pk = $data_left[2];
            my $name = $data_left[1];
            my $type = $data_left[0];

            my $bound_pk = $data_right[2];
            my $bound_name = $data_right[1];
            my $bound_type = $data_right[0];
            
            my $proceed = 1;
            
            if ($type eq "mediator" ) {
                if ($bound_type eq "mediator" ) { ### mediator -> mediator will not be processed
                    $proceed = 0;
                
                } else { ### swap data
                    my $temp_pk = $pk;
                    my $temp_name = $name;
                    my $temp_type = $type;
                    
                    $pk = $bound_pk;
                    $name = $bound_name;
                    $type = $bound_type;
                    
                    $bound_pk = $temp_pk;
                    $bound_name = $temp_name;
                    $bound_type = $temp_type;
                }
            }
                
            if ($proceed) {           
                #print "$name - $type - $bound_key - $bound_name - $bound_type\n";

                if ($schema_struct->{$name} eq "") {
                    $schema_struct->{$name} = [];
                }

                my $hash_ref = {type => $type, pk => $pk, bound_key => $bound_key, bound_name => $bound_name, 
                                bound_type => $bound_type, bound_pk => $bound_pk};

                push(@{$schema_struct->{$name}}, $hash_ref);
            }
        }
        
        return $schema_struct;
    }
    
    return undef;
}

sub get_DBT_Mediator_Schema {
    my $this = shift @_;
    
    my $app_name = shift @_;
    
    if (open(MYFILE, "<./conf/dbt_schema_" . $app_name . ".conf")) {
        my @file_content = <MYFILE>;
        close(MYFILE);
        
        my $schema_struct = {};
        
        foreach my $line (@file_content) {
            #print $line;
            
            $line =~ s/\n//;
            $line =~ s/\r//;
            
            while ($line =~ / /) {
                $line =~ s/ //g;
            }
            
            my @data = split(/>/, $line);
            
            my $bound_key = $data[1];
            
            my @data_left = split(/-/, $data[0]);
            my @data_right = split(/-/, $data[2]);
            
            my $pk = $data_left[2];
            my $name = $data_left[1];
            my $type = $data_left[0];
            
            my $bound_pk = $data_right[2];
            my $bound_name = $data_right[1];
            my $bound_type = $data_right[0];
            
            #print "$name - $type - $bound_key - $bound_name - $bound_type\n";
            
            if ($bound_type eq "mediator" || $type eq "mediator") {
            
                if ($type eq "mediator") { ### swap data
                    my $temp_pk = $pk;
                    my $temp_name = $name;
                    my $temp_type = $type;
                    
                    $pk = $bound_pk;
                    $name = $bound_name;
                    $type = $bound_type;
                    
                    $bound_pk = $temp_pk;
                    $bound_name = $temp_name;
                    $bound_type = $temp_type;                
                }
                
                if ($schema_struct->{$bound_name} eq "") {
                    $schema_struct->{$bound_name} = [];
                }

                my $hash_ref = {type => $bound_type, pk => $bound_pk, bound_key => $bound_key, bound_name => $name, 
                                bound_type => $type, bound_pk => $pk};

                push(@{$schema_struct->{$bound_name}}, $hash_ref);
            }
        }
        
        return $schema_struct;
    }
    
    return undef;
}

sub get_DBT_Mediator_Schema_Act {
    my $this = shift @_;
    
    my $app_name = shift @_;
    
    ### mtc stand for mediator table candidate
    ### ltc stand for linked table candidate
    my $mtc = shift @_; 
    my $ltc = shift @_;
    
    if (open(MYFILE, "<./conf/dbt_schema_" . $app_name . ".conf")) {
        my @file_content = <MYFILE>;
        close(MYFILE);
        
        foreach my $line (@file_content) {
            #print $line;
            
            $line =~ s/\n//;
            $line =~ s/\r//;
            
            while ($line =~ / /) {
                $line =~ s/ //g;
            }
            
            my @data = split(/>/, $line);
            
            my $bound_key = $data[1];
            
            if ($data[0] =~ /$ltc/ && $data[2] =~ /$mtc/) {
                my @data_left = split(/-/, $data[0]);
                my @data_right = split(/-/, $data[2]);

                my $pk = $data_left[2];
                my $name = $data_left[1];
                my $type = $data_left[0];

                my $bound_pk = $data_right[2];
                my $bound_name = $data_right[1];
                my $bound_type = $data_right[0];

                #print "$name - $type - $bound_key - $bound_name - $bound_type\n";

                my $hash_ref = {type => "mediator_act", pk => $bound_pk, bound_key => $bound_key, bound_name => $name, 
                                bound_type => $type, bound_pk => $pk};

                return $hash_ref;
            }
        }
    }
    
    return undef;
}

sub read_Directory {
    my $this = shift @_;
    
    my $current_dir = shift @_;
    
    #print "\$current_dir = $current_dir\n";
    
    my @dir_list = ();
    
    opendir(DIRHANDLE, $current_dir);

    my @ref_points = readdir(DIRHANDLE);

    my $count = 1;

    foreach my $pointer (@ref_points) {
        if (-d  "$current_dir/$pointer") {
            if (!($pointer =~ /^\./)) {
                push(@dir_list, $pointer);
            }
        }
    }
    
    @dir_list = sort(@dir_list);
    
    return @dir_list;
}

sub get_AppSrc_Backup_Date_Str {
    my $this = shift @_;
    
    my $current_dir = shift @_;

    my @dir_list = $this->read_Directory($current_dir);
    
    my $backup_date_str = undef;

    ### Check available backup date of application sources
    foreach my $item (@dir_list) {
        $backup_date_str .= "$item, ";
    }
    
    $backup_date_str =~ s/, $//;
    
    return $backup_date_str;
}

sub get_AppDBT_Backup_Date_Str {
    my $this = shift @_;
    
    my $current_dir = shift @_;

    my @dir_list = $this->read_Directory($current_dir);
    
    my %dbt_backup_date = ();

    ### Check available backup date of database tables
    foreach my $item (@dir_list) {
        if ($item =~ /^dbtl_/) {
            $item =~ s/^dbtl_//;
            $item =~ s/_/\-/g;
            $dbt_backup_date{logical} .= "$item, ";
            
        } elsif ($item =~ /^dbtd_/) {
            $item =~ s/^dbtd_//;
            $item =~ s/_/\-/g;
            $dbt_backup_date{domain} .= "$item, ";
            
        }
    }
    
    $dbt_backup_date{logical} =~ s/, $//;
    $dbt_backup_date{domain} =~ s/, $//;
    
    return \%dbt_backup_date;
}

sub debug {
    my $this = shift @_;
    my $file_name = shift @_;
    my $line_num = shift @_;
    my $str_debug = shift @_;
    
    my $str_head = "Debug code in $file_name at line number $line_num:";
    my $length = length($str_head);
    
    $str_head .= "\n";
    
    foreach (my $i = 0; $i < $length; $i++) {
        $str_head .= "-";
    }
    
    print "\n\n$str_head\n$str_debug";
    print "Press enter continue... ";      
    my $stuck = <STDIN>;    
}

1;    
