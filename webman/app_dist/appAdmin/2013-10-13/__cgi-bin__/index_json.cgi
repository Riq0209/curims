#! C:/Perl516/bin/perl

unshift (@INC, "../../../../webman/pm/core");
unshift (@INC, "../../../../webman/pm/comp");
unshift (@INC, "../../../../webman/pm/apps/appAdmin");

use DBI;
use JSON;
use CGI::Carp qw(fatalsToBrowser);

require GMM_CGI;
require DB_Utilities;
require Web_Service_Auth;

require webman_main;

my $json = new JSON;
my $cgi = new GMM_CGI;
my $dbu = new DB_Utilities;

my $dbi_conn = $dbu->make_DBI_Conn("../../../../webman/conf/dbi_connection.conf"); ### 15/05/2009

$dbu->set_DBI_Conn($dbi_conn); ### 12/12/2008
$cgi->set_DBI_Conn($dbi_conn); ### 12/12/2008

if ($app_name eq "") {
    $app_name = "aims";
    $cgi->push_Param("app_name", $app_name); ### 13/07/2007
}

###############################################################################

my $session = new Session;

$session->set_CGI($cgi);
$session->set_DBI_Conn($dbi_conn);

$session->set_Session_Table("webman_" . $app_name . "_session");
$session->set_User_Auth_Table("webman_" . $app_name . "_user", "login_name", "password");
$session->set_CGI_Var_DB_Cache_Table("webman_" . $app_name . "_cgi_var_cache");
$session->set_Idle_Time(3600);

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

print "Content-type: text/plain\n\n";

my $json_text = undef;

my $ctrl_main = new webman_main;

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
        $json_text = "[ { \"error\" => \"$session->{error}\", \"list\" => null } ]";
        
    } else {
        #print "\$sub_comp->get_Name = " . $sub_comp->get_Name . "\n";
        
        if ($sub_comp->authenticate($login_name, \@groups, "webman_". $cgi->param("app_name") . "_comp_auth")) {
            $json_text = $sub_comp->get_Content_JSON;
            
            $session_id = $sub_comp->get_Session_ID;
            #print "\$session_id = $session_id\n";

        } else {
            my $comp_name = $sub_comp->get_Name . ".pm";

            if ($session_id eq "" && $comp_name eq "webman_JSON_authentication.pm") { ### first phase login
                $json_text = $sub_comp->get_Content_JSON;
                
                $session_id = $sub_comp->get_Session_ID;
                #print "\$session_id = $session_id\n";

            } else {
                $json_text = "[ { \"error\":\"Don't have privilege on selected Webman JSON component [$comp_name]\", \"list\":null } ]";
            }
        }
    }
    
    &log_Hit_Info($json_text);
    
} else { ### print out the documentation
    if (open(MYFILE, "../../../../webman/pm/core/webman_json_service_doc.txt")) {
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



if (!$dbi_conn) {
    print "[ { \"error\":\"Database connection error\", \"list\":null } ]";
    
} elsif($json_text eq undef) {
    print "[ { \"error\":\"No valid Webman JSON component was selected\", \"list\":null } ]";
    
} else {
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
    
    my @data = split(/ where /, $sql);
    
    $data[1] =~ s/ and / /g;
    $data[1] =~ s/ or / /g;
    $data[1] =~ s/\(//g;
    $data[1] =~ s/\)//g;
    
    while ($data[1] =~ /  /) {
        $data[1] =~ /  / /g;
    }
    
    my @data2 = split(/ /, $data[1]);
    
    my $attributes = undef;
    
    foreach my $item (@data2) {
        if ($item =~ /^.*cgi_/) {
            $item =~ s/^.*cgi_//;
            $item =~ s/_'$//;
        
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