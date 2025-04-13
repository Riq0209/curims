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

package GMM_CGI;

use CGI::Cookie;
use DB_Utilities;

my $content = "";
my $rawContent = "";
my @fileContent = "";
my @fileName = "";

my @varName = undef;
my @value = undef;

my %varName_idx = ();

### 13/04/2014
my %varShifted_idx = ();

my @get_fmt_code    = ("\%25", "\%7E", "\%60", "\%21", "\%40", "\%23", "\%24", "\%5E", "\%26", 
                       "\%28", "\%29", "\%2B", "\%3D", "\%0D", "\%7B", "\%5B", "\%7D", 
                       "\%5D", "\%3A", "\%3B", "\%22", "\%27", "\%7C", "\%5C", "\%3C", "\%2C", "\%3E",
                       "\%3F", "\%2F",
                       "\%91", "\%92", "%93", "%94");
                    
my @get_fmt_char    = ("\%", "~", "\`", "!", "\@", "\#", "\$", "^", "&",
                        "(", ")", "+", "=", "\n", "{", "[", "}",
                        "]", ":", ";", "\"", "'", "|", "\\", "<", ",", ">", 
                        "?", "/",
                        "‘", "’", "“", "”");
                        
my @get_fmt_char_esc = ("\\\%", "\~", "\`", "\!", "\@", "\#", "\\\$", "\\^", "&",
                        "\\(", "\\)", "\\+", "=", "\n", "\\{", "\\[", "\\}",
                        "\\]", ":", ";", "\"", "'", "\\|", "\\\\", "<", ",", ">", 
                        "\\?", "\\/",
                        "‘", "’", "“", "”");

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{debug_text} = undef;
    
    bless $this, $class;
    
    $this->process_Method;
    
    return $this;
}

sub set_DBI_Conn { ### 12/12/2008
    my $this = shift @_;
    
    $this->{dbi_conn} = shift @_;
}

sub get_Raw_Content {
    my $this = shift @_;
    
    return $this->content_Type;
    
    if ($this->content_Type =~ /application\/x-www-form-urlencoded/) {
        return $content;
        
    } else {
        return $raw_content;
    }
}

sub redirect_Page {
    my $this = shift @_;
    
    $this->{url_redirect} = shift @_;
}

sub set_Cookie { ### 30/06/2010
    my $this = shift @_;

    my $name = shift @_;
    my $value = shift @_;

    my $domain = $ENV{'SERVER_NAME'};

    my @path_info = split(/\//, $ENV{'REQUEST_URI'});
    
    my $i = 1;
    my $path = "/";
    
    while (defined($path_info[$i]) && !($path_info[$i] =~ /index\.cgi/)) {
        $path .= "$path_info[$i]/";
        $i++;
    }

    if (!defined $this->{cookies_set}) {
        $this->{cookies_set} = {};
    }

    $this->{cookies_set}->{$name} = $value; ### useful to make new cookies immediately
                                            ### available in get_Cookie_Val

    my $cookie = new CGI::Cookie(-name=>$name, -value=>$value, -domain=>$domain, -path=>$path);

    $this->{cookies_raw_str} .= "Set-Cookie: $cookie\n";

    return "Set-Cookie: $cookie\n";
}

sub delete_Cookie { ### 30/06/2010
    my $this = shift @_;

    my $name = shift @_;

    my $domain = $ENV{'SERVER_NAME'};

    my @path_info = split(/\//, $ENV{'REQUEST_URI'});
    
    my $i = 1;
    my $path = "/";
    
    while (defined($path_info[$i]) && !($path_info[$i] =~ /index\.cgi/)) {
        $path .= "$path_info[$i]/";
        $i++;
    }

    if (!defined $this->{cookies_delete}) {
        $this->{cookies_delete} = {};
    }

    $this->{cookies_delete}->{$name} = 1; ### useful to make previous deleted
                                          ### cookies immediately unavailable in get_Cookie_Val

    my $cookie = new CGI::Cookie(-name=>$name, -value=>'', -domain=>$domain, -path=>$path, -expires=>'-1M');

    $this->{cookies_raw_str} .= "Set-Cookie: $cookie\n";
    
    #$this->add_Debug_Text($path);
    #$this->add_Debug_Text($this->{cookies_raw_str});
}

sub delete_Cookie_All { ### 02/07/2010
    my $this = shift @_;

    my %cookies = fetch CGI::Cookie;

    my $str = undef;

    foreach $key (keys(%cookies)) {
        $str .= "$key -- " . $cookies{$key}->expires . "<br>";
        $this->delete_Cookie($key);
    }

    return $str;
}

sub delete_Cookie_All_Except { ### 24/11/2018
    my $this = shift @_;
    my $except_hash = shift @_;
    
    my %cookies = fetch CGI::Cookie;
    
    my $str = undef;
    
    foreach $key (keys(%cookies)) {
        if (!$except_hash->{$key}) {
            $str .= "$key -- " . $cookies{$key}->expires . "<br>";
            $this->delete_Cookie($key);
        }
    }
    
    return $str;
}

sub get_Cookie_Val { ### 30/06/2010
    my $this = shift @_;

    my $name = shift @_;
    
    #$this->add_Debug_Text("Cookie name: $name", __FILE__, __LINE__);

    ### always try to get the latest cookies from $this->{cookies_set}
    if (defined $this->{cookies_set}->{$name}) {
        return $this->{cookies_set}->{$name};
    }

    ### try to get the previous available cookies
    my %cookies = fetch CGI::Cookie;
    
    #$this->add_Debug_Text(%cookies, __FILE__, __LINE__);

    if (defined $cookies{$name}) {
        #$this->add_Debug_Text("\$cookies{$name} : " . $cookies{$name}, __FILE__, __LINE__);
        
        if (defined $this->{cookies_delete}) {
            if ($this->{cookies_delete}->{$name}) { ### make deleted previous cookies immediately unavailable
                return undef;
            }
        }

        return $cookies{$name}->value;
    }

    ### no match from both $this->{cookies_set} and $this->{cookies}
    return undef;
}

sub print_Header {
    my $this = shift @_;
    
    #$this->add_Debug_Text($this->{cookies_raw_str}, __FILE__, __LINE__);
    
    if (defined $this->{cookies_raw_str}) { ### 30/06/2010
        print $this->{cookies_raw_str};
    }    
    
    if ($this->{url_redirect} ne "") {
        print "Location: $this->{url_redirect}\n\n";
        
    } else {
    if ($this->{allow_origin}) {
            print "Content-type: text/html\n";
            print "Access-Control-Allow-Origin:*\n\n";
            
        } else {
            print "Content-type: text/html\n\n";
        }
    }
}

sub start_HTML {
    my $this = shift @_;
    
    my $title = shift @_;
    my $page_subheader = shift @_;
    my $page_properties = shift @_;
    
    print "<HTML>\n",
          "<HEAD>\n",
          "<TITLE>$title</TITLE>\n",
          "$page_subheader\n",
          "</HEAD>\n",
          "<BODY $page_properties>\n";
          
    #print "<pre>\n";
    #for ($i = 0; $i < @varName; $i++) {
    #     print "$varName[$i] = $value[$i]\n";
    #}
    
    #print this->requestMethod;
    #read(*STDIN, $buff, $ENV{'CONTENT_LENGTH'}, 0);
    #print $buff;
    
    #while( ($n, $v) = each(%ENV)) { print "$n = $v <br>"; } print "<br>"; 
    #while( ($n, $v) = each(%GLOBAL)) { print "$n = $v <br>"; } print "<br>";
    
    #print "$rawContent\n";
    #print "</pre>\n";
}

sub get_Start_HTML {
    $this = shift @_;
    my $title = shift @_;
    my $page_attribute = shift @_;

    return "<HTML>\n" .
           "<HEAD>\n",
           "<TITLE>$title</TITLE>\n",
           "$page_subheader\n",
           "</HEAD>\n",
           "<BODY $page_properties>\n";
}

sub end_HTML {
    $this = shift @_;
    
    print "</BODY>\n",
          "</HTML>\n";
}

sub get_End_HTML {
    $this = shift @_;
    
    return "</BODY>\n" .
           "</HTML>\n";
}

sub process_Method {
    $this = shift @_;
    
    if ($this->request_Method eq "POST") {
        $counter = 0;
        $f_size = 0;
        $separator = "";
        
        if ($this->content_Type =~ /application\/x-www-form-urlencoded/) {
            read(*STDIN, $content, $ENV{'CONTENT_LENGTH'}, 0);    
            #print "content = $content"; 
            
        } else { # file upload
            read(*STDIN, $rawContent, $ENV{'CONTENT_LENGTH'}, 0);
            
            #print "<pre>$rawContent</pre>";
            
            @r_c_array = split(/\n/, $rawContent);
            $delimeter = $r_c_array[0];
            
            $counter = 0;
            $num_of_file = 0;
            for ($i = 0; $i <= $#r_c_array; $i++) {
                
                if ($r_c_array[$i] eq "$delimeter") {
                    $i++;
       
                    if ($r_c_array[$i] =~ /filename="/) { ### 11/03/2005 ### "
                        $f_n = "";
                        
                        if ($r_c_array[$i] =~ /\\/) {
                            @f_Name = split(/\\/,$r_c_array[$i] );
                            $f_n = $f_Name[$#f_Name];
                            
                        } elsif ($r_c_array[$i] =~ /\//) {
                            @f_Name = split(/\//,$r_c_array[$i] );
                            $f_n = $f_Name[$#f_Name];
                            
                        } else {  ### 03/07/2004
                            @f_Name_Part = split(/\;/,$r_c_array[$i] );
                            @f_Name = split(/\=/, $f_Name_Part[2]);
                            $f_n = $f_Name[1];
                        }
                        
                        $f_n =~ s/"//g; ### "
                        $f_n =~ s/\r//g;
                        $fileName[$num_of_file] = $f_n;
                        
                        $stop = 0;
                        $i = $i + 3; 
                        while (!$stop) {     
                            if ($r_c_array[$i] ne $delimeter && $i < $#r_c_array) {
                                $fileContent[$num_of_file] .= "$r_c_array[$i]\n";
                                $i++;
                            } else {
                                $stop = 1;                                
                                $i = $i - 1;
                            }
                        }
                        
                        $num_of_file++;
                        
                    } else {
                        @array = split(/"/, $r_c_array[$i]); ### "
                        $varName[$counter] = $array[1];
                        $varName_idx{$varName[$counter]} = $counter;
                        
                        $stop = 0;
                        $i = $i + 2;
                        while (!$stop) {
                            if ($r_c_array[$i] ne $delimeter && $i < $#r_c_array) {
                                $value[$counter] .= $r_c_array[$i];
                                $i++;
                            } else {
                                $stop = 1;                                
                                    $i = $i - 1;
                                    $counter++;
                            }
                        }
                        
                        if ($value[$counter - 1] =~ /\r/) {
                            $value[$counter - 1] = substr($value[$counter - 1], 0, length($value[$counter - 1]) - 1); ### 19/03/2004
                        }
                        
                    }
                }
            }
        }
          
    } else {
        $content = $ENV{"QUERY_STRING"};
        # print "content: $content<br>";
    }
    
    @c_array = split(/\&/, $content);
    
    $counter = 0;
    foreach $line (@c_array) {
        my @vv_array = split(/=/, $line);
        
        $varName[$counter] = $this->translate_Char($vv_array[0]);
        $varName_idx{$varName[$counter]} = $counter;
        
        $value[$counter] = $this->translate_Char($vv_array[1]);
        
        $var_exist_map{$varName[$counter]} = 1;
        
        $counter++; 
    }
}

sub var_Name {
    my $this = shift @_;
    
    ### 16/01/2014
    my @varNameValid = ();
    
    for (my $i = 0; $i < @varName; $i++) {
        if (defined($varName_idx{$varName[$i]})) {
            push(@varNameValid, $varName[$i]);
        }
    }
    
    return @varNameValid;
}

sub param {
    my $this = shift @_;
    
    my $param_name = shift @_;
    
    my $counter = 0;
    my @param_value = ("");
    
    #for ($i = 0; $i < @varName; $i++) {
    #    # print "$varName[$i] : $param_name<br>";
        
    #    if ($varName[$i] eq $param_name) {
    #        $param_value[$counter] = $value[$i];
    #        $counter++; 
    #    }
    #}
    
    ### 16/01/2014
    if (defined($varName_idx{$param_name})) {
        my $idx = $varName_idx{$param_name};
        return $value[$idx];
    }
    
    return undef;
}

### 16/01/2014
sub param_List {
    my $this = shift @_;
    
    my $param_name = shift @_;
    
    my $counter = 0;
    my @param_value = ("");
    
    for ($i = 0; $i < @varName; $i++) {
        # print "$varName[$i] : $param_name<br>";
        
        if ($varName[$i] eq $param_name) {
            $param_value[$counter] = $value[$i];
            $counter++; 
        }
    }
    
    if ($counter > 1) {
        return (@param_value);
        
    } else {
        return ($param_value[0]);
    }    
}

sub param_Exist { ### 01/07/2011
    my $this = shift @_;
    
    my $param_name = shift @_;
    
    #$param_name =~ s/\$/\\\$/g; ### 18/02/2013    
    
    #return grep(/^$param_name$/, @varName);
    
    ### 16/01/2014
    if (defined($varName_idx{$param_name})) {
        return 1;
        
    } else {
        return 0;
    }
}

sub param_Shift { ### 18/12/2010
    my $this = shift @_;
    
    my $param_name = shift @_;
    
    my $param_val = $this->param($param_name);
    
    #for ($i = 0; $i < @varName; $i++) { ### 30/11/2013
    #    if ($varName[$i] eq $param_name) {
    #        splice(@varName, $i, 1);
    #        splice(@value, $i, 1);
    #        $this->remove_DB_Cache_Var($param_name);
    #        last;
    #    }
    #}
    
    ### 16/01/2014
    if (defined($varName_idx{$param_name})) {
        my $idx = $varName_idx{$param_name};
        
        #$this->add_Debug_Text("$param_name => $idx", __FILE__, __LINE__);
        
        $varName_idx{$param_name} = undef;
        $this->remove_DB_Cache_Var($param_name);
        
        ### 13/04/2014
        $varShifted_idx{$param_name} = $idx;        
    }
    
    return $param_val;
}

sub push_Param { ### 26/12/2010
    my $this = shift @_;
    
    my $param_name = shift @_;
    my $param_val = shift @_;
    
    if ($param_name ne "") { ### 10/04/2014
        if (!$this->set_Param_Val("$param_name", $param_val)) {
            $this->add_Param("$param_name", $param_val);
        }
    }
}

sub set_Param_Val {
    my $this = shift @_;
    
    my $param_name = shift @_;
    my $param_val = shift @_;
    
    #my $i = 0;
    #
    #for ($i = 0; $i < @varName; $i++) {
    #        #print "$varName[$i] : $param_name<br>\n";
    #        
    #        if ($varName[$i] eq $param_name) {
    #            #print "match set_Param_Val: $varName[$i] : $param_name with value = $param_val<br>\n";
    #            $value[$i] = $param_val;
    #            return 1;   
    #        }
    #}
    
    ### 16/01/2014
    if (defined($varName_idx{$param_name})) {
        $value[$varName_idx{$param_name}] = $param_val;
        return 1;
    }
    
    return 0;
}

sub add_Param { ### 23/09/2005
    my $this = shift @_;
    
    my $param_name = shift @_;
    my $param_val = shift @_;
    
    #my $i = 0;
    #
    #for ($i = 0; $i < @varName; $i++) {
    #    # print "$varName[$i] : $param_name<br>";
    #
    #    if ($varName[$i] eq $param_name) {
    #        return 0;
    #    }
    #}
    
    if ($param_name ne "") { ### 10/04/2014
        if (defined($varName_idx{$param_name})) {
            return 0;
        }

        my $i = @varName;
        
        ### 13/04/2014
        ### In the cases of $param_name already exist but shifted from 
        ### be available as CGI parameter.
        if (defined($varShifted_idx{$param_name})) {
            $i = $varShifted_idx{$param_name};
            $varShifted_idx{$param_name} = undef;
        }        

        $varName[$i] = $param_name;
        $varName_idx{$varName[$i]} = $i;

        $value[$i] = $param_val;

        return 1;
    }
    
    return 0;
}

sub get_Param_Val {
    my $this = shift @_;
    
    return @value;
}

sub get_Param_Val_Hash { ### 30/12/2006
    my $this = shift @_;
    
    my %param_val = undef;
   
    for ($i = 0; $i < @varName; $i++) {
        $param_val{$varName[$i]} = $value[$i];
    }
    
    return %param_val;
}

sub preserve_Previous_DB_Cache_Var { ### 10/04/2009
    my $this = shift @_;
    
    $this->{preserve_previous_db_cache_var} = 1;
}

sub add_Exclude_DB_Cache_Var { ### 24/12/2008
    my $this = shift @_;
    
    my $var_str = shift @_;
    
    #print "\$var_str = $var_str <br>\n";

    $this->{additional_exclude_db_cache_var} .= $var_str . " ";
}

sub exclude_DB_Cache_Var { ### 16/12/2008
    my $this = shift @_;
    
    my $var_str = shift @_;
    
    #print "\$this->{additional_exclude_db_cache_var} = $this->{additional_exclude_db_cache_var} <br>\n";
    
    my @excluded_var_name = split(' ', $var_str . " " . $this->{additional_exclude_db_cache_var});
    
    my %var_name_dict = undef;
    
    foreach my $var_name (@excluded_var_name) {
        #print "Exclude: $var_name <br>\n";
    
        $var_name_dict{$var_name} = 1;
    }
    
    $this->{exclude_db_cache_var} = \%var_name_dict;
}

sub update_DB_Cache_Var { ### 16/12/2008
    my $this = shift @_;
    
    my %exclude_db_cache_var = %{$this->{exclude_db_cache_var}};
    
    my $dbu = new DB_Utilities;
       $dbu->set_DBI_Conn($this->{dbi_conn});
    
    my $app_name = $this->param("app_name");
    my $session_id = $this->param("session_id");
    my $link_id = $this->param("link_id");
    
    if ($this->{preserve_previous_db_cache_var} != 1) {
    
        #$this->add_Debug_Text("Try cache_To_DB: $app_name - $session_id", __FILE__, __LINE__);

        my $i = 0;
        my $var_value = undef;

        $dbu->set_Table("webman_" . $app_name . "_cgi_var_cache");

        for ($i = 0; $i < @varName; $i++) {
            #$this->add_Debug_Text("\$exclude_db_cache_var{$varName[$i]} = " . $exclude_db_cache_var{$varName[$i]}, __FILE__, __LINE__);

            if ($session_id ne "" && $varName[$i] ne "login" && 
                $varName[$i] ne "password" && $varName[$i] ne "session_id" &&
                $exclude_db_cache_var{$varName[$i]} != 1 && 
                defined($varName_idx{$varName[$i]})) {

                $var_value= $value[$i];
                $var_value =~ s/ /\\ /g;

                $dbu->set_Table("webman_" . $app_name . "_cgi_var_cache");

                $dbu->delete_Item("session_id link_id name", "$session_id $link_id $varName[$i]");
                $dbu->insert_Row("session_id link_id name value", "$session_id $link_id $varName[$i] $var_value");

                #if ($varName[$i] =~ /^???/) {
                #    $this->add_Debug_Text($varName[$i], __FILE__, __LINE__);
                #    $this->add_Debug_Text($dbu->get_SQL, __FILE__, __LINE__);
                #}
            }
        }

        if ($this->{remove_db_cache_var} ne "") { ### 18/12/2008
            $this->remove_DB_Cache_Var($this->{remove_db_cache_var});
        }
    }
}

sub activate_DB_Cache_Var { ### 16/12/2008
    my $this = shift @_;
    
    my %exclude_db_cache_var = %{$this->{exclude_db_cache_var}};
    
    my $dbu = new DB_Utilities;
       $dbu->set_DBI_Conn($this->{dbi_conn});   
       
    my $app_name = $this->param("app_name");
    my $session_id = $this->param("session_id");
    my $link_id = $this->param("link_id");
    
    $dbu->set_Table("webman_" . $app_name . "_cgi_var_cache");
    
    my @param_val_db = $dbu->get_Items("name value", "session_id link_id active_mode", "$session_id $link_id 1", undef, undef);
    
    #$this->add_Debug_Text($dbu->get_SQL . $param_val_db, __FILE__, __LINE__);
    
    my $i = 0;
    my %var_exist_map = undef;
    
    for ($i = 0; $i < @varName; $i++) {
        #$this->add_Debug_Text($i + 1 . ". $varName[$i] = $value[$i]", __FILE__, __LINE__);
        $var_exist_map{$varName[$i]} = 1;
    }    
    
    my $counter = @varName;
    my %db_cache_var = undef;
    
    foreach my $item (@param_val_db) {
        if ($var_exist_map{$item->{name}} != 1 && 
            $exclude_db_cache_var{$varName[$i]} != 1) {
            
            #print "Add from DB: " . $item->{name} . " = " . $item->{value} . "<br>\n";
            
            $varName[$counter] = $item->{name};
            $varName_idx{$varName[$counter]} = $counter;
            
            $value[$counter] = $item->{value};
            
            $db_cache_var{$item->{name}} = 1;
            
            $counter++;
        }
    }
    
    $this->{db_cache_var} = \%db_cache_var;
    
    #for ($i = 0; $i < @varName; $i++) {
    #    print $i + 1 . ". $varName[$i] = $value[$i] <br>\n";
    #}
}

sub remove_DB_Cache_Var { ### 18/12/2008
    my $this = shift @_;
    
    my @remove_var_name = split(/ /, shift @_);
    
    my $dbu = new DB_Utilities;
       $dbu->set_DBI_Conn($this->{dbi_conn});
    
    my $app_name = $this->param("app_name");
    my $session_id = $this->param("session_id");
    my $link_id = $this->param("link_id");
    
    $dbu->set_Table("webman_" . $app_name . "_cgi_var_cache");
    
    foreach my $var_name (@remove_var_name) {
        $dbu->delete_Item("session_id link_id name", "$session_id $link_id $var_name");
        #$this->add_Debug_Text("SQL = " . $dbu->get_SQL, __FILE__, __LINE__);
    }
}

sub set_Remove_DB_Cache_Var { ### 18/12/2008
    my $this = shift @_;
    
    $this->{remove_db_cache_var} = shift @_;
}

sub is_DB_Cache_Var { ### 01/01/2009
    my $this = shift @_;
    
    my $var_name = shift @_;
    
    my %db_cache_var = %{$this->{db_cache_var}};
    
    if ($db_cache_var{$var_name}) {
        return 1;
        
    } else {
        return 0;
    }
}

sub request_Method {
    my $this = shift @_;
    
    return $ENV{"REQUEST_METHOD"};
}

sub content_Type {
    my $this = shift @_;
    
    $ctype = $ENV{"CONTENT_TYPE"};
    @ct_array = split(/\;/, $ctype);
    return $ct_array[0];
}

sub executed_Script { ### 05/06/2003
    my $this = shift @_;
    my $script_name = $ENV{"SCRIPT_NAME"};
    my @data = split(/\//, $script_name);
    return $data[$#data];
}

sub client_IP { ### 05/06/2003
    my $this = shift @_;
    return $ENV{"REMOTE_ADDR"};
} 

sub server_Name { ### 13/10/2013
    my $this = shift @_;
    
    return $ENV{"SERVER_NAME"};
}

sub server_Path { ### 13/10/2013
    my $this = shift @_;
    my $path = $ENV{"REQUEST_URI"};
    my $script = $this->executed_Script;
    
    $path =~ s/$script$//;
    
    return $path;
}

sub server_Script { ### 13/10/2013
    my $this = shift @_;
    return $this->executed_Script;
}

sub upl_File_Name {
    $this = shift @_;
    
    return @fileName;
}

sub upl_File_Content {
    my $this = shift @_;
    
    return @fileContent;   
}

sub CGI_Content {
    my $this = shift @_;
    
    if ($this->content_Type =~ /application\/x-www-form-urlencoded/) {
        return $content;
        
    } else { # file upload
        return $rawContent;
    }
}

sub add_Debug_Text {
    my $this = shift @_;

    my $debug_text = shift @_; 
    
    my $file_name = shift @_;
    my $line_number = shift @_;
    
    my $type_color = shift @_;
    
    my %type_color_map = ("DATABASE" => "#00E5E6", "TEMPLATE" => "#FC841B", "TRACING" => "#FFE6E6", "DEFAULT" => "#E6E6E6", "DEBUG_COMP" => "#99DD99"); 
    
    if ($type_color =~ /^\#/) { 
            ### Do nothing, directly assign color via $type_color
            
    } elsif ($type_color_map{$type_color} eq "") {
        $type_color = $type_color_map{"DEFAULT"};
        
    } else {
        $type_color = $type_color_map{$type_color};
    }
    
    

    $this->{debug_text} .= "<div style=\"background-color:$type_color; border:1px solid grey\">\n";
    
    if ($file_name ne "" || $line_number ne "") {
        $this->{debug_text} .= "<font size=\"1\" face=\"Verdana, Arial, Helvetica, sans-serif\"><b>$file_name - $line_number</b></font>\n<br />\n"
    }
    
    $this->{debug_text} .= "<font size=\"1\" face=\"Verdana, Arial, Helvetica, sans-serif\">$debug_text</font>\n";
    
    $this->{debug_text} .= "</div>\n<br />\n";
}

sub get_Debug_Text {
    my $this = shift @_;
    
    return $this->{debug_text};
}

sub print_Debug_Text {
    my $this = shift @_;
    
    if ($this->{debug_text} ne "") {
        print "<p><strong><font size=\"2\" face=\"Verdana, Arial, Helvetica, sans-serif\">CGI Debug Text:</font></strong></p>\n";
        print $this->{debug_text};
    }
}
sub generate_GET_Data { ### 21/3/2005
    my $this = shift @_;
    
    my $var_name = shift @_;
    my $var_name_excepted = shift @_;
    
    $var_name =~ s/\$/_ds_/g;
    $var_name_excepted =~ s/\$/_ds_/g;
    
    ### 26/01/2019
    my @var_name_list = split(/ /, $var_name);
    my $var_name_dict = {};
    
    ### 26/01/2019
    foreach my $item (@var_name_list) {
        $var_name_dict->{$item} = 1;
    }    
    
    my $i = 0;
    my $get_data = "";
    
    my @CGI_Var_Name = $this->var_Name;    
    
    if ($var_name ne "" && $var_name ne "ALL") {
    
        for ($i = 0; $i < @CGI_Var_Name; $i++) {
            if ($CGI_Var_Name[$i] ne "") {
                $CGI_Var_Name[$i] =~ s/\$/_ds_/;
                $CGI_Var_Name[$i] =~ s/\[/_lbrkt_/g;
                $CGI_Var_Name[$i] =~ s/\]/_rbrkt_/g;
                

                #if ($var_name =~ /\b$CGI_Var_Name[$i]\b/) {
                if ($var_name_dict->{$CGI_Var_Name[$i]}) { ### 26/01/2019
                    $CGI_Var_Name[$i] =~ s/_ds_/\$/;
                    $CGI_Var_Name[$i] =~ s/_lbrkt_/\[/g;
                    $CGI_Var_Name[$i] =~ s/_rbrkt_/\]/g;

                    
                    $CGI_Value = $this->param($CGI_Var_Name[$i]);
                    $CGI_Value =~ s/ /+/g;
                    $CGI_Value =~ s/\&/\%26/g;
                    
                    if ($CGI_Var_Name[$i] ne "") {
                        $get_data .= "$CGI_Var_Name[$i]=$CGI_Value\&";
                    }
                }
            }
        }
        
    } elsif ($var_name eq "ALL") {
        for ($i = 0; $i < @CGI_Var_Name; $i++) {
            if ($CGI_Var_Name[$i] ne "") {
                $CGI_Var_Name[$i] =~ s/\$/_ds_/;
                $CGI_Var_Name[$i] =~ s/\[/_lbrkt_/g;
                $CGI_Var_Name[$i] =~ s/\]/_rbrkt_/g;
                

                if ($var_name_excepted =~ /\b$CGI_Var_Name[$i]\b/) {
                    # do nothing

                } else {
                    $CGI_Var_Name[$i] =~ s/_ds_/\$/;
                    $CGI_Var_Name[$i] =~ s/_lbrkt_/\[/g;
                    $CGI_Var_Name[$i] =~ s/_rbrkt_/\]/g;
                    
                    $CGI_Value = $this->param($CGI_Var_Name[$i]);
                    $CGI_Value =~ s/ /+/g;
                    $CGI_Value =~ s/\&/\%26/g;

                    if ($CGI_Var_Name[$i] ne "") {
                        $get_data .= "$CGI_Var_Name[$i]=$CGI_Value\&";
                    }
                }
            }
        }
    }
    
    $get_data = substr($get_data, 0, length($get_data) - 1);
    
    #print "\$get_data=$get_data<br>\n";
    
    return $get_data;
}

sub generate_Hidden_POST_Data { ### 22/3/2005
    my $this = shift @_;
    
    my $var_name = shift @_;
    my $var_name_excepted = shift @_;
    
    $var_name =~ s/\$/_ds_/g;
    $var_name_excepted =~ s/\$/_ds_/g;
    
    ### 26/01/2019
    my @var_name_list = split(/ /, $var_name);
    my $var_name_dict = {};
    
    ### 26/01/2019
    foreach my $item (@var_name_list) {
        $var_name_dict->{$item} = 1;
    }    
    
    my $i = 0;
    my $hidden_object = "";
    
    my @CGI_Var_Name = $this->var_Name;
    
    if ($var_name ne "" && $var_name ne "ALL") {
        
        for ($i = 0; $i < @CGI_Var_Name; $i++) {
        
            $CGI_Var_Name[$i] =~ s/\$/_ds_/;
            $CGI_Var_Name[$i] =~ s/\[/_lbrkt_/g;
            $CGI_Var_Name[$i] =~ s/\]/_rbrkt_/g;
                
            
            #if ($var_name =~ /\b$CGI_Var_Name[$i]\b/) {
            if ($var_name_dict->{$CGI_Var_Name[$i]}) { ### 26/01/2019
                $CGI_Var_Name[$i] =~ s/_ds_/\$/;
                $CGI_Var_Name[$i] =~ s/_lbrkt_/\[/g;
                $CGI_Var_Name[$i] =~ s/_rbrkt_/\]/g;
                    
                $CGI_value = $this->param($CGI_Var_Name[$i]);
                
                $CGI_value =~ s/&/&amp;/g; ### 19/08/2005
                $CGI_value =~ s/</&lt;/g;
                $CGI_value =~ s/>/&gt;/g;
                $CGI_value =~ s/"/&quot;/g; ### "
                $CGI_value =~ s/’/&rsquo;/g;
                $CGI_value =~ s/‘/&lsquo;/g; ### 09/04/2009
                $CGI_value =~ s/“/&ldquo;/g;
                $CGI_value =~ s/”/&rdquo;/g;
                
                if ($CGI_Var_Name[$i] ne "") {
                    $hidden_object .= "\<input type=\"hidden\" name=\"$CGI_Var_Name[$i]\" value=\"$CGI_value\"\>\n";
                }
            }
        
        }
    } elsif ($var_name eq "ALL") {
        for ($i = 0; $i < @CGI_Var_Name; $i++) {
            $CGI_Var_Name[$i] =~ s/\$/_ds_/;
            $CGI_Var_Name[$i] =~ s/\[/_lbrkt_/g;
            $CGI_Var_Name[$i] =~ s/\]/_rbrkt_/g;
            
            
            if ($var_name_excepted =~ /\b$CGI_Var_Name[$i]\b/) {
                # do nothing
                
            } else {
                $CGI_Var_Name[$i] =~ s/_ds_/\$/;
                $CGI_Var_Name[$i] =~ s/_lbrkt_/\[/g;
                $CGI_Var_Name[$i] =~ s/_rbrkt_/\]/g;
                    
                $CGI_value = $this->param($CGI_Var_Name[$i]);

                $CGI_value =~ s/&/&amp;/g; ### 19/08/2005
                $CGI_value =~ s/</&lt;/g;
                $CGI_value =~ s/>/&gt;/g;
                $CGI_value =~ s/"/&quot;/g; ### "
                $CGI_value =~ s/’/&rsquo;/g;
                $CGI_value =~ s/‘/&lsquo;/g; ### 09/04/2009
                $CGI_value =~ s/“/&ldquo;/g;
                $CGI_value =~ s/”/&rdquo;/g;
                
                if ($CGI_Var_Name[$i] ne "") {
                    $hidden_object .= "\<input type=\"hidden\" name=\"$CGI_Var_Name[$i]\" value=\"$CGI_value\"\>\n";
                }
            }
        }
    }
    
    return $hidden_object;
}

sub convert_GET_Format_CharToCode {
    my $this = shift @_;
    
    my $str = shift @_;
    
    my @code = @get_fmt_code;
    my @char = @get_fmt_char_esc;    
    
    for ($j = 0; $j < @char; $j++) {
        if ($j != 13 && $j != 14) {
            $str =~ s/$char[$j]/$code[$j]/g;

            if ($char[$j] eq "\&") {
                $str =~ s/amp;//g;
            }

            #print "$char[$j]/$code[$j]<br>\n";
            #$this->add_Debug_Text("$char[$j] vs $code[$j] = " . $str, __FILE__, __LINE__);
        }
    }
    
    $str =~ s/ /+/g;
    
    return ($str);      
}

sub convert_GET_Format_CodeToChar {
    my $this = shift @_;
    
    my $str = shift @_;
    
    my @code = @get_fmt_code;
    my @char = @get_fmt_char;
    
    $str =~ s/\+/ /g;
    
    for ($j = 0; $j < @code; $j++) {
        $str =~ s/$code[$j]/$char[$j]/g;
    }
    
    return ($str);      
}

sub translate_Char {
    my $this = shift @_;
    
    my $str = shift @_;
    
    
    my @code = ("\%7E", "\%60", "\%21", "\%40", "\%23", "\%24", "\%25", "\%5E", "\%26", 
                "\%28", "\%29", "\%2B", "\%3D", "\%0D", "\%0A", "\%7B", "\%5B", "\%7D", 
                "\%5D", "\%3A", "\%3B", "\%22", "\%27", "\%7C", "\%5C", "\%3C", "\%2C", "\%3E",
                "\%3F", "\%2F",
                "\%91", "\%92", "%93", "%94");
            
    my @char = ("\~", "\`", "\!", "\@", "\#", "\$", "\%", "\^", "\&", 
                "(", ")", "+", "=", "\n", "", "{", "[", "}", 
                "]", ":", ";", "\"", "'", "|", "\\", "<", ",", ">", 
                "?", "/", 
                "‘", "’", "“", "”");   
                
    $str =~ s/\+/ /g;                
    
    for ($j = 0; $j < @code; $j++) {
        $str =~ s/$code[$j]/$char[$j]/g;
    }
    
    return ($str);   
}

sub uc {
    my $this = shift @_;
    
    $str = shift @_;
    
    @lower = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
              "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
              "u", "v", "w", "x", "y", "z");
              
    @upper = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
              "K", "l", "M", "N", "O", "P", "Q", "R", "S", "T",
              "U", "V", "W", "X", "Y", "Z");
              
    for ($j = 0; $j < @lower; $j++) {
        $str =~ s/$lower[$j]/$upper[$j]/g;
    } 
    
    return ($str);
}

sub lc {
    my $this = shift @_;
    
    $str = shift @_;
    
    @lower = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
              "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
              "u", "v", "w", "x", "y", "z");
              
    @upper = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
              "K", "l", "M", "N", "O", "P", "Q", "R", "S", "T",
              "U", "V", "W", "X", "Y", "Z");
              
    for ($j = 0; $j < @lower; $j++) {
        $str =~ s/$upper[$j]/$lower[$j]/g;
    } 
    
    return ($str);
}

1;
