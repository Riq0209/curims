#! /usr/bin/perl

use Cwd;
use Net::FTP;
use File::Listing qw(parse_dir);
use File::stat;
use Net::Domain qw (hostname hostfqdn hostdomain);

use Deploy_File_Input;
   
################################################################################
   
my %month_txt_num = ("Jan"=>"01", "Feb"=>"02", "Mar"=>"03", "Apr"=>"04", "May"=>"05", "Jun"=>"06",
                     "Jul"=>"07", "Aug"=>"08", "Sep"=>"09", "Oct"=>"10", "Nov"=>"11", "Dec"=>"12");

my $dfi = new Deploy_File_Input;

my $cur_dir = getcwd;

my @data = split(/\//, $cur_dir);

my $webman_dir = undef;
   
for (my $i = 0; $i < @data - 2; $i++) {
    $webman_dir .= "$data[$i]/";
}

$webman_dir =~ s/\\/\//g;

my $cgi_dir = $webman_dir . "public_html/cgi-bin/webman/" . $dfi->get_App_Name . "/";

#print "\$cur_dir    = $cur_dir\n";
#print "\$cgi_dir = $cgi_dir\n";

print "\nCheck current local CGI files...\n\n"; 

opendir(DOCDIR, $cgi_dir) || die("Cannot open directory");
    
my @files = readdir(DOCDIR);

my %file_info_all = ();

my %file_info_local = ();

my %map_file_exist_local = undef;
my %map_file_date_cur = undef;
my %map_file_time_cur = undef;

my $max_length_filename = 0;

my $file_info_local_list = undef;

my $count = 1;
    
foreach my $file (@files) {
    if ($file =~ /\.cgi$/) {
        $map_file_exist_local{$file} = 1;
    
        if ($max_length_filename < length($file)) {
            $max_length_filename = length($file);
        }
        
        my $file_size = -s "$cgi_dir" . "$file";
        my $file_date_time = localtime(stat("$cgi_dir" . "$file")->[9]);

        #print "$cgi_dir" . "$file" . "\n";
        #print "\$file_size = $file_size\n";
        #print "\$file_date_time = $file_date_time\n\n";
        
        #my $stuck = <STDIN>;

        $file_date_time =~ s/  / /g;

        my @data = split(/ /, $file_date_time);
        
        if ($data[2] < 10) {
            $data[2] = "0" . $data[2];
        }   

        my $file_date = "$data[4]-$month_txt_num{$data[1]}-$data[2]";
        my $file_time = $data[3];

        $map_file_date_cur{$file} = $file_date;
        $map_file_time_cur{$file} = $file_time;
        
        $file_info_local{$file} = {date=>$file_date, time=>$file_time, size=>$file_size};
        
        $file_info_all{$file} = {date=>$file_date, time=>$file_time, size=>$file_size};

        #print "$file | $file_size | $file_date | $file_time\n";
        
        $file_info_local_list .= "$file | $file_size | $file_date | $file_time\n";
    }
}

foreach my $key (sort(keys(%file_info_local))) {
    print &fmt_num($count) . ". $key ";
    
    for (my $i = 0; $i < $max_length_filename - length($key); $i++) {
        print " ";
    }
    
    print " | $file_info_local{$key}->{date} | $file_info_local{$key}->{time} | $file_info_local{$key}->{size}\n";
    
    $count++;
}

print "\n######################################################################\n";

################################################################################

print "\nCheck current CGI files on server...\n\n";

my $dns = $ARGV[0];
my $username = $ARGV[1]; 
my $password = $ARGV[2]; 
my $app_name = $ARGV[3];
my $proceed_task = $ARGV[4];

if ($dns eq undef) {
    $dns = $dfi->get_DNS;
    
    if ($dns eq undef) {
        print "      DNS: ";
        
        $dns = <STDIN>;
        $dns =~ s/\n//;
        
    } else {
        print "      DNS: $dns\n";
    }
}

my $fqdn = hostfqdn();

if ($dns eq $fqdn) {
    die "Can't proceed, source and target machine is the same host ($dns).\n"; 
}

if ($username eq undef) {
    $username = $dfi->get_Username;
    
    if ($username eq undef) {
        print " Username: ";
        
        $username = <STDIN>;
        $username =~ s/\n//;
        
    } else {
        print " Username: $username\n";
    }
}

   
if ($password eq undef) {
    $password = $dfi->get_Password;
    
    if ($password eq undef) {
        print " Password: ";
        
        $password = <STDIN>;
        $password =~ s/\n//;
        
    } else {
        print " Password: $password\n";
    }
}

if ($app_name eq undef) {
    $app_name = $dfi->get_App_Name;
    
    if ($app_name eq undef) {
        print "App. name: ";
        $app_name = <STDIN>;
        $app_name =~ s/\n//;
        
    } else {
        print "App. name: $app_name\n";
    }
}

my $ftp_conn = Net::FTP->new("$dns", Debug => 0) or die "Cannot connect to $host_name_src: $@";

$ftp_conn->login($username, $password) or die "Cannot login ", $ftp_conn->message;
$ftp_conn->cwd("public_html/cgi-bin/webman/$app_name") or die "Cannot change working directory ", $ftp_conn->message;

my $server_files = $ftp_conn->dir or die "Cannot listing current folder ", $ftp_conn->message;

print "\nFTP connection to $dns success...\n";

my %file_info_server = ();
my %map_file_exist_server = undef;

$count = 1;

foreach my $item (parse_dir($server_files)) {
    my ($fname, $ftype, $fsize, $fmtime, $fmode) = @$item;
    
    if ($fname =~ /\.cgi$/) {
        if ($max_length_filename < length($fname)) {
            $max_length_filename = length($fname);
        }
        
        my $file_date_time = localtime($fmtime);
        
        $file_date_time =~ s/  / /g;

        my @data = split(/ /, $file_date_time);
        
        if ($data[2] < 10) {
            $data[2] = "0" . $data[2];
        }   

        my $file_date = "$data[4]-$month_txt_num{$data[1]}-$data[2]";
        my $file_time = $data[3];        
        
        #print &fmt_num($count) . ". $fname | $file_date | $file_time\n";
        
        $file_info_server{$fname} = {date=>$file_date, time=>$file_time, size=>$fsize};
        
        $map_file_exist_server{$fname} = 1;
        
        if ($map_file_exist_local{$fname}) {
            $file_info_all{$fname}->{task} = "Reload";
            
        } else {
            $file_info_all{$fname} = {date=>$file_date, time=>$file_time, size=>$fsize, task=>"Delete"};
        }
        
        $count++;
    }
}

foreach my $local_file (keys(%map_file_exist_local)) {
    if ($local_file ne "" && !$map_file_exist_server{$local_file}) {
        $file_info_all{$local_file}->{task} = "Upload";
    }
}

$count = 1;

foreach my $key (sort(keys(%file_info_server))) {
    print &fmt_num($count) . ". $key ";
    
    for (my $i = 0; $i < $max_length_filename - length($key); $i++) {
        print " ";
    }
    
    print " | $file_info_server{$key}->{date} | $file_info_server{$key}->{time} | $file_info_server{$key}->{size}  \n";
    
    $count++;
}

################################################################################

if (open(MYFILE, "<./logs/cgi_" . $dns . "-" . $app_name .  "_last.txt")) {
    print "\n######################################################################\n";
    
    print "\nCheck last local CGI files log...\n\n";
    
    my @log_file_content = <MYFILE>;
    
    foreach my $line (@log_file_content) {
        print $line;
        
        my @data = split(/ \| /, $line);
        
        $data[1] =~ s/ +//;
        
        #print "$data[1]|$data[2]|$data[3]|$data[5]\n";
        
        if ($file_info_all{$data[1]} ne "") {
            if ($file_info_all{$data[1]}->{date} eq $data[2] && 
                $file_info_all{$data[1]}->{time} eq $data[3] &&
                $file_info_all{$data[1]}->{task} ne "Upload") {
                $file_info_all{$data[1]}->{task} = "      ";
            }
        }
    }
    
    close(MYFILE);
}


################################################################################

print "\n######################################################################\n";

print "\nDo the following tasks to $dns :\n\n";

$count = 1;

foreach my $key (sort(keys(%file_info_all))) {
   print &fmt_num($count) . " | $key ";

    for (my $i = 0; $i < $max_length_filename - length($key); $i++) {
        print " ";
    }

    print " | $file_info_all{$key}->{date} | $file_info_all{$key}->{time} | $file_info_all{$key}->{task} | $file_info_all{$key}->{size}\n";
    
    $count++;
 }

################################################################################

print "\n";

#if ($ftp_conn->feature('MDTM')) {
#    print "FTP server support MDTM\n";
#}

if ($proceed_task ne "y") {
    print "Continue above tasks for $dns [y/n]?: ";

    $proceed_task = <STDIN>;
    $proceed_task =~ s/\n//;
}
   
my $localtime = localtime;

while ($localtime =~ /  /) {
    $localtime =~ s/  / /;
}

#print "\$localtime = $localtime\n";

my $date_finish = &localtime_ISO_date($localtime);
my $time_finish = &localtime_ISO_time($localtime);   
   
$date_finish =~ s/-//g;
$time_finish =~ s/://g;

#print "\$date_finish = $date_finish\n";
print "\$time_finish = $time_finish\n";
#   
if ($proceed_task eq "y") {
    print "\n";
    
    $ftp_conn->ascii;
    
    my $mod_info_file_name_last = "cgi_" . $dns . "-" . $app_name .  "_last.txt";
    my $mod_info_file_name_log  = "cgi_" . $dns . "-" . $app_name .  "_$date_finish" . "_$time_finish.txt";
    
    #print "\$mod_info_file_name_last = $mod_info_file_name_last\n";
    #print "\$mod_info_file_name_log = $mod_info_file_name_log\n";
    
    if (open(MYFILE_LAST, ">./logs/$mod_info_file_name_last") && open(MYFILE_LOG, ">./logs/$mod_info_file_name_log")) {
        $count = 1;
        
        foreach my $key (sort(keys(%file_info_all))) {
            my $file_content = &fmt_num($count) . " | $key ";

            for (my $i = 0; $i < $max_length_filename - length($key); $i++) {
                $file_content .= " ";
            }

            $file_content .= " | $file_info_all{$key}->{date} | $file_info_all{$key}->{time} | $file_info_all{$key}->{task} | $file_info_all{$key}->{size}\n";
            
            if ($file_info_all{$key}->{task} ne "      ") {
                print $file_info_all{$key}->{task} . " -> " . $key . "\n";
            }
            
            if ($file_info_all{$key}->{task} eq "Reload" || $file_info_all{$key}->{task} eq "Upload") {
                
                $ftp_conn->put("$cgi_dir/$key", $key);
                #$ftp_conn->chmod(755, $key) or $ftp_conn->message; ### this command still not working!!!
                
            } elsif ($file_info_all{$key}->{task} eq "Delete") {
                $ftp_conn->delete($key);
            }
            
            print MYFILE_LAST ($file_content);
            print MYFILE_LOG ($file_content);
            
            $count++;
        }
        
        close(MYFILE_LAST);
        close(MYFILE_LOG);
    }
}

$ftp_conn->close;

################################################################################

sub localtime_ISO_time {
    my $localtime_str = shift @_;
    
    my @data = split (/ /, $localtime_str);
    
    return $data[3];
}

sub localtime_ISO_date {
    my $localtime_str = shift @_;
    
    my %month_str_num = ("Jan"=>"01", "Feb"=>"02", "Mar"=>"03", "Apr"=>"04", "May"=>"05", "Jun"=>"06", 
                         "Jul"=>"07", "Aug"=>"08", "Sep"=>"09", "Oct"=>"10", "Nov"=>"11", "Dec"=>"12");
    
    my @data = split (/ /, $localtime_str);
    
    if ($data[2] < 10) { $data[2] = "0" . $data[2]; }
    
    return "$data[4]-$month_str_num{$data[1]}-$data[2]";
    
}

sub fmt_num {
    my $num = shift @_;
    
    if ($num < 10) {
        return "00" . $num;
        
    } elsif ($num < 100) {
        return "0" . $num;
        
    } else {
        return $num;
    }
}


