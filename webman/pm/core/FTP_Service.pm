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

package FTP_Service;

use Net::FTP;
use Table_List_Data;

sub new {
    my $class = shift @_;
    my $this = {};
    
    $this->{ftp_host} = undef;
    $this->{ftp_login} = undef;
    $this->{ftp_password} = undef;
    
    $this->{transfer_mode} = undef;
    
    $this->{dir_temp} = undef;
    $this->{dir_upload} = undef;
    
    $this->{dir_top} = undef;
    $this->{dir_list} = undef;
    
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

sub set_CGI {
    my $this = shift @_;
    
    $this->{cgi} = shift @_;
}

### 04/01/2015
sub make_FTP_Conn {
    my $this = shift @_;
    
    my $conn_cnf = shift @_;
    
    if ($conn_cnf eq "") {
        $conn_cnf = "./webman/conf/ftp_connection.conf";
    }
    
    my %cnf_info = ();
    
    if (open(CNF_FILE, "<$conn_cnf")) {
        my @file_content = <CNF_FILE>;
        
        close(CNF_FILE);
        
        foreach my $line (@file_content) {
            while ($line =~ s/^ //) { }
            
            if (!($line =~ /^#/)) {
                $line =~ s/\n//;
                $line =~ s/\r//;
                $line =~ s/ //g;
                
                my @data = split(/=/, $line);
                
                $cnf_info{$data[0]} = $data[1];
            }
        }
        
        my $host = $cnf_info{"ftp_host"};
        my $username = $cnf_info{"ftp_user_name"};
        my $password = $cnf_info{"ftp_password"};
        
        return $this->set_FTP_Conn($host, $username, $password);
    }
    
    return undef;
}

sub set_FTP_Conn { 
    my $this = shift @_;
    
    my $cgi = $this->{cgi};
    
    $this->{ftp_host} = shift @_;
    $this->{ftp_login} = shift @_;
    $this->{ftp_password} = shift @_;
    
    if (!defined($this->{ftp_host})) { 
        $this->{ftp_host} = "localhost";
    }     
    
    my $ftp_conn = Net::FTP->new($this->{ftp_host}, Debug => 1) 
       or $cgi->add_Debug_Text("FTP: Cannot connect to host: $@", __FILE__, __LINE__, "TRACING");
       
    #$cgi->add_Debug_Text("$ftp_conn - $this->{ftp_host} : $this->{ftp_login} : $this->{ftp_password}", __FILE__, __LINE__);
       
    if ($ftp_conn && defined($this->{ftp_login}) && defined($this->{ftp_password})) {
        $ftp_conn->login($this->{ftp_login}, $this->{ftp_password}) 
        or $cgi->add_Debug_Text("FTP: Cannot login", __FILE__, __LINE__, "TRACING");
        
        $this->{ftp_conn} = $ftp_conn;
    }
    
    return $ftp_conn;
}

sub close_FTP_Conn {
    my $this = shift @_;
    
    if ($this->{ftp_conn}) {
        $this->{ftp_conn}->close;
    }
}

sub set_Transfer_Mode { 
    my $this = shift @_;
    
    $this->{transfer_mode} = shift @_;
}

sub set_Dir_Temp { 
    my $this = shift @_;
    
    $this->{dir_temp} = shift @_;
}

sub set_Dir_Upload { 
    my $this = shift @_;
    
    $this->{dir_upload} = shift @_;
}

sub set_Dir_Top { 
    my $this = shift @_;
    
    $this->{dir_top} = shift @_;
    
    if ($this->{ftp_conn}->cwd($this->{dir_top})) {
        return 1;
        
    } else {
        return 0;
    }    
}

sub set_Dir_List { 
    my $this = shift @_;
    
    $this->{dir_list} = shift @_;
    
    if ($this->{ftp_conn}->cwd($this->{dir_list})) {
        return 1;
        
    } else {
        return 0;
    }
}

sub generate_File_Info {
    my $this = shift @_;
    
    my $file_name_list = shift @_;
    
    my $cgi = $this->{cgi};      
    my $ftp_conn = $this->{ftp_conn};
    
    if (!defined($this->{dir_temp})) { 
        $this->{dir_temp} = "./temp";
    }
    
    if ($ftp_conn && defined($this->{dir_upload})) {           
        my $dir_upload = $this->{dir_upload};
           $dir_upload =~ s/\/\//\//g;
           $dir_upload =~ s/\/$//;
           
        if (!(-d $dir_upload)) {
            ### Recursively create all directories in the given path.
            $ftp_conn->mkdir($dir_upload, 1);
        }
        
        $ftp_conn->cwd($dir_upload) 
        or $cgi->add_Debug_Text("Cannot change working directory: $this->{dir_upload}", __FILE__, __LINE__, "TRACING");
        
        my @dir_list = $ftp_conn->ls;
        my %existed = ();
        
        foreach my $item (@dir_list) {
            #$cgi->add_Debug_Text($item, __FILE__, __LINE__);
            $existed{$item} = 1;
        }
        
        my @file_name = $cgi->upl_File_Name;
        
        if (defined($file_name_list)) {
            @file_name = @{$file_name_list};
        }
        
        my @file_info = ();
        
        foreach my $fname (@file_name) {
            if ($fname ne "") {
                my @fname_parts = split(/\./,  $fname);
                
                my $status = "New";
                
                if ($existed{$fname}) {
                    $status = "Exist";
                }
                
                push(@file_info, {dir_upload => $dir_upload, name => $fname, name_to_save => $fname,
                                  ext => @fname_parts[1], status => $status, save_mode => 1});            
            }
        }
        
        $this->{file_info} = \@file_info;
    }
    
    return $this->{file_info};
}

sub save_Files {
    my $this = shift @_;
    
    my $cgi = $this->{cgi};      
    my $ftp_conn = $this->{ftp_conn};
    
    if (!defined($this->{file_info})) {
        $this->generate_File_info;
    }
    
    #$cgi->add_Debug_Text("$ftp_conn : $this->{file_info}", __FILE__, __LINE__);
    
    if ($ftp_conn && defined($this->{file_info})) {
      
        ### Default is binary mode.
        if ($this->{transfer_mode} eq "ascii") {
            $ftp_conn->ascii;
        } else {
            $ftp_conn->binary;
        }
        
        my $dir_temp = $this->{dir_temp};
           $dir_temp =~ s/\/$//;
           
           
        my @file_info = @{$this->{file_info}};
        my @file_info_saved = ();
        
        foreach my $file (@file_info) { 
            if ($file->{save_mode}) {
                my $dir_upload = $file->{dir_upload};
                   $dir_upload =~ s/\/\//\//g;
                   $dir_upload =~ s/\/$//;

                if (!(-d $dir_upload)) {
                    ### Recursively create all directories in the given path.
                    $ftp_conn->mkdir($dir_upload, 1);
                }

                $ftp_conn->cwd($dir_upload) 
                or $cgi->add_Debug_Text("Cannot change working directory: $this->{dir_upload}", __FILE__, __LINE__, "TRACING");
                
                $ftp_conn->put("$dir_temp/$file->{name}", $file->{name_to_save}) 
                or $cgi->add_Debug_Text("Cannot copy $dir_temp/$file->{name} to $dir_upload/$file->{name_to_save}", __FILE__, __LINE__, "TRACING");

                $cgi->add_Debug_Text("Save $dir_temp/$file->{name} to $dir_upload/$file->{name_to_save}", __FILE__, __LINE__, "TRACING");
                
                push(@file_info_saved, $file);
            }
        }
        
        return \@file_info_saved;
    }
}

sub get_Content_List {
    my $this = shift @_;
    
    my $cgi = $this->{cgi};      
    my $ftp_conn = $this->{ftp_conn};
    
    ### Control the list directory so it will not 
    ### exceeding the current set top directory.
    if (!defined($this->{dir_top})) {
        $this->{dir_top} = "./";        
    }
    
    if (!defined($this->{dir_list})) {
        $this->{dir_list} = $this->{dir_top};        
    }
    
    ### Not a sub directory of top directory.
    if (!($this->{dir_list} =~ /^$this->{dir_top}/)) {
        $this->{dir_list} = $this->{dir_top};
        
    } else {
        ### Over the allowed most top directory. 
        if (scalar(split("/", $this->{dir_list})) < scalar(split("/", $this->{dir_top}))) {
            $this->{dir_list} = $this->{dir_top};
        }
    }
    
    $cgi->add_Debug_Text("\$this->{dir_list} = $this->{dir_list}", __FILE__, __LINE__);
    
    ### Get directory content list using 
    ### current active FTP connection.
    $cgi->add_Debug_Text("Try change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    
    $ftp_conn->cwd($this->{dir_list}) 
    or $cgi->add_Debug_Text("Cannot change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    
    my @list = $ftp_conn->ls;
    my @list_full = $ftp_conn->dir;
    my @content_list = ();
    
    my $idx = 0;
    
    foreach my $item (@list_full) {
        $cgi->add_Debug_Text("$item - $list[$idx]", __FILE__, __LINE__);
        
        my $info = {};
        
        if ($item =~ /^d/) {
            $info->{type} = "Dir";
        } else {
            $info->{type} = "File";
        }
        
        ### The "dof" stand for "directory or file".
        my $name_dof = $list[$idx];
        
        $info->{name} = $name_dof;
        
        ### Solve the problem for file name with regex special characters.
        $name_dof =~ s/\(/\\(/g;
        $name_dof =~ s/\)/\\\)/g;
        $name_dof =~ s/\[/\\[/g;
        $name_dof =~ s/\]/\\\]/g;
        $name_dof =~ s/\^/\\\^/g;
        $name_dof =~ s/\$/\\\$/g;
        
        $item =~ s/$name_dof$//;
        $cgi->add_Debug_Text("$item", __FILE__, __LINE__);
        
        while ($item =~ /  /) {
            $item =~ s/  / /;
        }
        
        my @parts = split(/ /, $item);
        
        $info->{size} = $parts[4];
        
        if ($info->{size} < (1024 * 1024)) {
            $info->{size} = sprintf("%.1f", $info->{size} / 1024);
            $info->{size} .= " KB";

        } else {
            $info->{size} = $info->{size} / (1024 * 1024);
            $info->{size} = sprintf("%.1f", $info->{size});
            $info->{size} .= " MB";
        }
        
        for (my $i = 5; $i < @parts; $i++) {
            $info->{date_time} .= "$parts[$i] ";
        }
        
        $info->{date_time} =~ s/ $//;
        
        push(@content_list, $info);
        
        $idx++;
    }
    
    return \@content_list;
}

sub rename_DirFile {
    my $this = shift @_;
    
    my $old_name = shift @_;
    my $new_name = shift @_;
    
    my $cgi = $this->{cgi};      
    my $ftp_conn = $this->{ftp_conn};
    
    $cgi->add_Debug_Text("Try change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    
    if ($ftp_conn->cwd($this->{dir_list}) && defined($old_name) && defined($new_name)) {
        $ftp_conn->rename($old_name, $new_name);
        
    } else {
        $cgi->add_Debug_Text("Cannot change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    }
}

sub delete_File {
    my $this = shift @_;
    
    my $file_name = shift @_;
    
    my $cgi = $this->{cgi};      
    my $ftp_conn = $this->{ftp_conn};
    
    $cgi->add_Debug_Text("Try change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    
    if ($ftp_conn->cwd($this->{dir_list}) && defined($file_name)) {
        $ftp_conn->delete($file_name);
        
    } else {
        $cgi->add_Debug_Text("Cannot change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    }
}

sub delete_Dir {
    my $this = shift @_;
    
    my $dir_name = shift @_;
    
    my $cgi = $this->{cgi};      
    my $ftp_conn = $this->{ftp_conn};
    
    $cgi->add_Debug_Text("Try change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    
    if ($ftp_conn->cwd($this->{dir_list}) && defined($dir_name)) {
        $ftp_conn->rmdir($dir_name);
        
    } else {
        $cgi->add_Debug_Text("Cannot change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    }
}

sub create_Dir {
    my $this = shift @_;
    
    my $dir_name = shift @_;
    
    my $cgi = $this->{cgi};      
    my $ftp_conn = $this->{ftp_conn};
    
    $cgi->add_Debug_Text("Try change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    
    if ($ftp_conn->cwd($this->{dir_list}) && defined($dir_name)) {
        $ftp_conn->rmdir($dir_name);
        
    } else {
        $cgi->add_Debug_Text("Cannot change working directory: $this->{dir_list}", __FILE__, __LINE__, "TRACING");
    }
}

1;