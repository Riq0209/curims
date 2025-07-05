#! #!/usr/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/psm2");

use DBI;
use JSON;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;
require Web_Service_Auth;

require psm2;

my $json = new JSON;
my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf"); ### 15/05/2009

$dbu->set_DBI_Conn($dbi_conn); ### 12/12/2008
$cgi->set_DBI_Conn($dbi_conn); ### 12/12/2008

if ($app_name eq "") {
    $app_name = "psm2";
    $cgi->push_Param("app_name", $app_name); ### 13/07/2007
}

###############################################################################

my $session = new Session;

$session->set_CGI($cgi);
$session->set_DBI_Conn($dbi_conn);
$session->set_Idle_Time(3600);

### Options to manually set the database table names involved in session data management.
#$session->set_Session_Table("webman_" . $app_name . "_session");
#$session->set_User_Auth_Table("webman_" . $app_name . "_user", "login_name", "password");
#$session->set_CGI_Var_DB_Cache_Table("webman_" . $app_name . "_cgi_var_cache");

my $session_id = $cgi->param("session_id");
my $app_name = $cgi->param("app_name");

$dbu->set_Table("webman_" . $app_name . "_link_structure");
my $link_id__json_entity = $dbu->get_Item("link_id ", "parent_id name", "0 json_entities_");

my @ahr_linkinfo = $dbu->get_Items("name link_id", "parent_id", "$link_id__json_entity", "sequence");

my $link_id = undef;
my %entity_name__link_id = ();

foreach my $item (@ahr_linkinfo) {
    $entity_name__link_id{$item->{name}} = $item->{link_id};
}

my $entity_name = $cgi->param("entity");
my $link_id = $entity_name__link_id{$entity_name};

$cgi->push_Param("link_id", $link_id);


###############################################################################

my $json_text = undef;
my $debug_text = undef;

### may changed via webman_JSON.pm 'http_referer_limit' parameter setting
my $http_referer_error = 0; 

my $ctrl_main = new psm2;

my $today_ISO = $ctrl_main->get_Today_ISO;
my $time_ISO = $ctrl_main->get_Time_ISO;

$ctrl_main->{template_default} = "template_default.html";

$ctrl_main->set_CGI($cgi);
$ctrl_main->set_DBI_Conn($dbi_conn);

### top-down structure of active link path that has/hasn't have a reference
my @link_path = $ctrl_main->get_Link_Path;

### bottom-up structure of active link path that has have a reference
my @link_content_info = $ctrl_main->get_Link_Content_Info;

my ($link_id, $link_name) = %{$link_path[0]};  
my $link_ref_name = undef;

if (defined($link_content_info[0])) {
    $link_ref_name = $link_content_info[0]->get_Link_Ref_Name;
}

if ($link_name eq "json_entities_" && $link_ref_name ne "") {
    my $login_name = $ctrl_main->get_User_Login;
    my @groups = $ctrl_main->get_User_Groups;
    
    $ctrl_main->{sub_component} = $link_ref_name;
    $ctrl_main->run_Task;
    my $sub_comp = $ctrl_main->run_Sub_Component;
    
    $session->set_Session_ID($session_id);
    
    if ($session_id ne "" && !$session->is_Valid) {
        $json_text = "{ \"error\":\"$session->{error}\", \"list\":null }";
        
    } else {
        
        #$debug_text .= $ENV{'HTTP_REFERER'};
        #$debug_text .= "\$sub_comp->get_Name = " . $sub_comp->get_Name . "\n";
        
        ### developer may change webman_JSON.pm 'http_referer_limit' 
        ### parameter to some DNS pattern
        if ($sub_comp->{'http_referer_limit'} ne undef) {
            if ($ENV{'HTTP_REFERER'} =~ /$sub_comp->{'http_referer_limit'}/) {
               ### do nothing
                
            } else {
                $http_referer_error = 1;
            }
        }
        
        if ($sub_comp->auth_Link_Path && $sub_comp->authenticate) {
            $json_text = $sub_comp->get_Content_JSON;
            
            $session_id = $sub_comp->get_Session_ID;
            #$debug_text .= "\$session_id = $session_id\n";

        } else {
            my $comp_name = $sub_comp->get_Name . ".pm";

            if ($session_id eq "" && $comp_name eq "webman_JSON_authentication.pm") { ### first phase login
                $json_text = $sub_comp->get_Content_JSON;
                
                $session_id = $sub_comp->get_Session_ID;
                #print "\$session_id = $session_id\n";

            } else {
                if (!$sub_comp->auth_Link_Path) {
                    $json_text = "{ \"error\":\"Don't have privilege on selected link reference of Webman JSON component [$comp_name]\", \"list\":null }";
                } else {
                    $json_text = "{ \"error\":\"Don't have privilege on selected Webman JSON component [$comp_name]\", \"list\":null }";
                }
            }
        }
    }
    
    &log_Hit_Info($json_text);
    
} else { ### print out the documentation
    if (open(MYFILE, "../../../../webman/pm/core/webman_json_service_doc-v2.txt")) {
        my @fc = <MYFILE>;

        foreach $line (@fc) {
            if ($line =~ /^__entities_attributes__\n$/) {
                foreach my $item (@ahr_linkinfo) {
                    if ($item->{name} ne "authentication") {
                        $json_text .=  "$item->{name} - " . 
                                       &extract_Entity_Attributes($item->{link_id}) . 
                                       "\n";
                    }
                }
            } else {
                $json_text .= $line;
            }
        }

        close(MYFILE);        
    }
}

###############################################################################

print "Content-type: text/plain\n";
print "Access-Control-Allow-Origin:*\n\n";


if (!$dbi_conn) {
    print "{ \"error\":\"Database connection error\", \"list\":null, \"debug_text\":\"$debug_text\" }";
    
} elsif ($json_text eq undef) {
    print "{ \"error\":\"No valid Webman JSON component was selected\", \"list\":null, \"debug_text\":\"$debug_text\" }";
    
} elsif ($http_referer_error) {
   print "{ \"error\":\"HTTP_REFERER parameter error\", \"list\":null, \"debug_text\":\"$debug_text\" }";
   
} else {
    ### version 2 main changes
    $json_text =~ s/^\[\n//;
    $json_text =~ s/\n\]$//;
    
    ### 08/09/2024
    if ($debug_text ne undef) {
        my $json_ref = $json->decode($json_text);
        
        $json_ref->{'debug_text'} = $debug_text;
        
        $json->indent([1]);
        $json->allow_blessed([1]);
        $json->convert_blessed([1]);
        
        $json_text = $json->encode($json_ref);
    }
    
    print $json_text;
    
    #my $json_ref = $json->decode($json_text);
    
    #if (defined($json_ref->{error})) {
    #    print "error = $json_ref->{error} \n";
        
    #} else {
    #    print "list = $json_ref->{list}\n";
    #}
}

$cgi->print_Debug_Text;

###############################################################################

sub extract_Entity_Attributes {
    my $link_id = shift @_;
    
    $dbu->set_Table("webman_" . $app_name . "_link_reference");
    my $link_ref_id = $dbu->get_Item("link_ref_id", "link_id", "$link_id");
    
    $dbu->set_Table("webman_" . $app_name . "_dyna_mod_param");
    my $sql = $dbu->get_Item("param_value", "link_ref_id param_name", "$link_ref_id sql");
    
    #my @data = split(/ where /, $sql);
    my @data = split(/ /, $sql);
    
    #$data[1] =~ s/ and / /g;
    #$data[1] =~ s/ or / /g;
    #$data[1] =~ s/\(//g;
    #$data[1] =~ s/\)//g;
    
    #while ($data[1] =~ /  /) {
    #    $data[1] =~ /  / /g;
    #}
    
    #my @data2 = split(/ /, $data[1]);
    
    my $attributes = undef;
    
    foreach my $item (@data) {
        $item =~ s/\(//g;
        $item =~ s/\)//g;
        $item =~ s/'//g;
        $item =~ s/`//g;
        
        if ($item =~ /^.*cgi_/) {
            $item =~ s/^.*cgi_//;
            $item =~ s/_$//;
        
            $attributes .= "$item, ";
        }
    }
    
    
    $attributes =~ s/, $//;
    
    return $attributes;
}

sub log_Hit_Info {
    my $content_display = shift @_;
    
    if ($session_id ne "" && $session_id ne "-1" && !$logout) {
        #print "Try to log Hit info - $session_id<br>\n";
        #print "$today_ISO / $time_ISO <br>\n";
        #print $cgi->request_Method . "<br>\n";
        #print $cgi->generate_GET_Data(ALL) . "<br>\n";
        
        my $method = $cgi->request_Method;
        my $query_string = $cgi->generate_GET_Data(ALL);
        
        $content_display =~ s/ /\\ /g;
        $content_display =~ s/\'/\\\'/g;
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info");
        
        $dbu->insert_Row("session_id date time method",
                         "$session_id $today_ISO $time_ISO $method");
                         
        my $hit_id = $dbu->get_Item("hit_id", "session_id date time", "$session_id $today_ISO $time_ISO");
        
        #print "\$hit_id = $hit_id ";
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info_query_string");
        $dbu->insert_Row("hit_id query_string", "$hit_id $query_string");
        
        
        $dbu->set_Table("webman_" . $app_name . "_hit_info_content");
        $dbu->insert_Row("hit_id content", "$hit_id $content_display");
    }
}
