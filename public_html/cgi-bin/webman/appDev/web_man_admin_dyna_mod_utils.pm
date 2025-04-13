package web_man_admin_dyna_mod_utils;

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{db_conn} = undef;
    $this->{db_interface} = undef;
    
    $this->{dyna_mod_folder} = undef;
    $this->{dyna_mod_parent_modules} = undef;
    
    bless $this, $class;
    
    return $this;
}

sub set_Dynamic_Module_Folder {
    $this = shift @_;
    
    $this->{dyna_mod_folder} = shift @_;
}

sub set_CGI {
    $this = shift @_;
    
    $this->{cgi} = shift @_;
}

sub set_DBI_Conn { ### 27/02/2004
    $this = shift @_;
    $this->{db_conn} = shift @_;
    $this->{db_interface} = "DBI"; 
}

sub get_New_Valid_Webman_CGI_Component {
    my $this = shift @_;
    
    my $dyna_mod_folder = shift @_;
    my $app_name = shift @_;
    
    my $pre_table_name = "webman_" . $app_name . "_";
    
    if ($dyna_mod_folder eq "") {
        $dyna_mod_folder = $this->{dyna_mod_folder};
    }
    
    $dyna_mod_folder .= "/";
    $dyna_mod_folder =~ s/\/\//\//;
    
    #print "\$dyna_mod_folder = $dyna_mod_folder<br>\n";
    
    my @new_webman_dyna_mod = undef;
    my @webman_dyna_mod_app = $this->get_Valid_Webman_CGI_Component($dyna_mod_folder);
    my @webman_dyna_mod_std = $this->get_Valid_Webman_CGI_Component("../../../../webman/pm/comp");
    
    my $dbu = new DB_Utilities;
        
    if ($this->{db_interface} eq "DBI") {
        $dbu->set_DBI_Conn($this->{db_conn}); ### option 1
        $dbu->set_Table($pre_table_name . "dyna_mod");
    }
    
    my $counter = 0;
    
    for (my $i = 0; $i < @webman_dyna_mod_app; $i++) {
        if (!$dbu->find_Item("dyna_mod_name", $webman_dyna_mod_app[$i])) {
            $new_webman_dyna_mod[$counter] = $webman_dyna_mod_app[$i];
            $counter++;
        }   
    }
    
    for (my $i = 0; $i < @webman_dyna_mod_std; $i++) {
        if (!$dbu->find_Item("dyna_mod_name", $webman_dyna_mod_std[$i])) {
            $new_webman_dyna_mod[$counter] = $webman_dyna_mod_std[$i];
            $counter++;
        }   
    }    
    
    return @new_webman_dyna_mod;
}

sub get_Valid_Webman_CGI_Component {
    my $this = shift @_;
    
    my $dyna_mod_folder = shift @_;
    
    if ($dyna_mod_folder eq "") {
        $dyna_mod_folder = $this->{dyna_mod_folder};
    }
    
    $dyna_mod_folder .= "/";
    $dyna_mod_folder =~ s/\/\//\//;
    
    #print "\$dyna_mod_folder = $dyna_mod_folder <br>";
    
    opendir(DIRHANDLE, $dyna_mod_folder);
    
    my @files = readdir(DIRHANDLE);

    my ($i, $counter, @webman_dyna_mod) = (0, 0, undef);

    for ($i = 0; $i < @files; $i++) {
        if ($files[$i] =~ /\.pm/) {
            if ($this->valid_Webman_CGI_Component($dyna_mod_folder . $files[$i])) {
                $files[$i] =~ s/\.pm$//;

                $webman_dyna_mod[$counter] = $files[$i];
                $counter++;
            }
        }
    }
    
    @webman_dyna_mod = sort(@webman_dyna_mod);
    
    return @webman_dyna_mod;
}

sub valid_Webman_CGI_Component {
    my $this = shift @_;
    
    my $dyna_mod_file_name = shift @_;
    
    my ($i, $valid_indicator) = (0, 0);
    
    my $base_directory = "";
    
    my @spliters = split(/\//, $dyna_mod_file_name);
    
    if (@spliters > 1) {
        for ($i = 0; $i < @spliters - 1; $i++) {
            $base_directory .= $spliters[$i] . "/";
        }
    }

    my $file_name = $spliters[@spliters - 1];
    my $file_name_super = undef; ### 06/03/2009
    
    #print "\$dyna_mod_file_name = $dyna_mod_file_name <br>";
    #print "\$file_name = $file_name <br>";
    
    my $count = 1;
    my $file_exist = -e $dyna_mod_file_name;
    
    while ($file_exist && $file_name ne "CGI_Component" && $file_name ne $file_name_super && $count) {
        #print "$count . $dyna_mod_file_name<br><br>\n";
        $count++;
              
        if (open(MYFILE, "<$dyna_mod_file_name")) {
            $file_name_super = $file_name;
            
            my $file_str = undef;
            my @file_content = <MYFILE>;

            close (MYFILE);

            for ($i = 0; $i < @file_content; $i++) {
                $file_str .= $file_content[$i];

                if ($file_content[$i] =~ /\@ISA/) {

                    @spliters = split(/"/, $file_content[$i]); ### "

                    if ($spliters[1] eq "webman_CGI_component" && ($file_str =~ /require webman_CGI_component;/ || $file_str =~ /use webman_CGI_component;/)) {
                        return 1;
                        
                    } else {
                        #print "<pre>$file_str</pre>"; 
                        
                        #print "\$dyna_mod_file_name = $dyna_mod_file_name (before)<br>";
                        
                        $file_name = $spliters[1];
                        $dyna_mod_file_name = $base_directory . $file_name . ".pm";
                        
                        #print "\$dyna_mod_file_name = $dyna_mod_file_name <br>\n";
                    }
                    
                    $i = @file_content; ### to stop for loop operation
                }
            }
        }
        
        $file_exist = -e $dyna_mod_file_name;
        
        if (!$file_exist) {
            ### try change the base directory to where standard Webman
            ### components are stored
            
            $base_directory = "../../../../webman/pm/comp/";
            $dyna_mod_file_name = $base_directory . $file_name . ".pm";
            
            ### is still !$file_exist, will exit while loop
            $file_exist = -e $dyna_mod_file_name;
            
            #print "\$dyna_mod_file_name = $dyna_mod_file_name <br>\n";
        
        }        
    }
    
    return 0;
}

sub get_Dyna_Mod_Param {
    my $this = shift @_;
    
    my $dyna_mod_name = shift @_;
    
    my $module_file_name = $this->{dyna_mod_folder} . "$dyna_mod_name.pm";
    
    #print __FILE__ . "-" . __LINE__ . ": \$module_file_name = $module_file_name<br>\n";
    
    if (!(-e $module_file_name)) {
        ### highly possible a standard Webman component module
        $module_file_name = "../../../../webman/pm/comp/$dyna_mod_name.pm";
    }
    
    #print "\$this->{dyna_mod_folder} = $this->{dyna_mod_folder}<br>\n";
    #print __FILE__ . "-" . __LINE__ .  ": \$module_file_name = $module_file_name<br>\n";
    
    $module_file_name =~ s/\/\//\//g;
    
    my $counter = 0;
    my @result_array = undef;
    my @spliters = undef;
    
    my $base_directory = "";
    
    @spliters = split(/\//, $module_file_name);
    
    if (@spliters > 1) {
        for ($i = 0; $i < @spliters - 1; $i++) {
            $base_directory .= $spliters[$i] . "/";
        }
    }
    
    my $file_name = $spliters[@spliters - 1];
    
    #print "\$module_file_name = $module_file_name <br>";
    #print "\$file_name = $file_name <br>";
    
    my $max_depth = 10;
    my $count_depth = 0;
    
    while ($file_name ne "webman_CGI_component.pm" && $count_depth < $max_depth) {
        $count_depth++;
        
        #print "DEPTH = $count_depth : \$file_name = $file_name <br>";
        
        if (open(MYFILE, "<$module_file_name")) {
            my $file_content = <MYFILE>;
            my $sub_new = undef;
            my ($stop, $start_store, $close_brace) = (0, 0, 0);

            while (!$stop && $file_content ne "") {
                $file_content = <MYFILE>;
                
                ### get parent module name
                
                if ($file_content =~ /\@ISA/) {
                    my @spliters = split(/;/, $file_content);

                    my $super_class_name = $spliters[0];

                    while ($super_class_name =~ / /) {
                        $super_class_name =~ s/ //;
                    }

                    $super_class_name =~ s/^\@ISA=\("//; ### "
                    $super_class_name =~ s/"\)$//; ### "
                    
                    $file_name = $super_class_name . ".pm";
                    
                    $module_file_name = $base_directory . $file_name;
                    
                    if (!(-e $module_file_name)) {
                        ### highly possible a standard Webman component module
                        $module_file_name = "../../../../webman/pm/comp/$file_name";
                    }                    
                    
                    #print "\$module_file_name = $module_file_name  <br>";
                }
                
                
                ### get sub new { ... } part
                
                if ($file_content =~ /sub /) { 
                    if ($file_content =~ / new /) {
                        $start_store = 1;
                    } else {
                        $start_store = 0;
                        $stop = 1;
                    }
                }

                if ($start_store) {
                    $sub_new .= $file_content;
                }

            }

            close(MYFILE);

            #print "\$module_file_name = $sub_new <br>";

            my $line = undef;
            my @temp_array = undef;

            my @instruct_lines = split(/;/, $sub_new);

            foreach $line (@instruct_lines) {
                if ($line =~ /{/ && $line =~ /}/) {
                    @temp_array = split(/{/, $line);
                    @temp_array = split(/}/, $temp_array[1]);

                    $line = $temp_array[0];

                    if ($line ne "") {
                        $result_array[$counter] = $line;
                        $counter++;
                    }
                }
            }
        }
        
        #print "\$file_name = $file_name <br>";
    }
    
    return @result_array;
    
}

1;
