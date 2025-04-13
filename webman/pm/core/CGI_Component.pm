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

package CGI_Component;

use Template_Element_Extractor;
use DB_HTML_Map;
use HTML_DB_Map;
use Text_DB_Map;
use DBI_HTML_Map;
use Data_HTML_Map;
use CGI_HTML_Map; ### 02/06/2009
use Select_Option;
use Radio_Option;
use Checkbox_Selection;
use HTML_Table_Menu;
use Session;
use HTML_Link_Menu;
use HTML_Link_Menu_Paginate;
use HTML_Dynamic_Numbered_Link_Menu;
use Static_Content;
use DB_Utilities;

use Link_Structure_Content_Info;
use HTML_Object_Separator;
use Table_List_Data;
use TLD_HTML_Map;

use HTML_Link_Path;

use Link_Node;

use Calendar;

use Web_Service_Auth;
use Web_Service_Entity;

use FTP_Service; ### 01/11/2013

my $HOME_DIR = "./";

my %month = ("Jan"=>"01", "Feb"=>"02", "Mar"=>"03", "Apr"=>"04", "May"=>"05", "Jun"=>"06", 
             "Jul"=>"07", "Aug"=>"08", "Sep"=>"09", "Oct"=>"10", "Nov"=>"11", "Dec"=>"12"); ### 13/03/2004

my $time = localtime;
   $time =~ s/\b  \b/ /g;
   
my @tarikh = split(/ /, $time);

if ($tarikh[2] < 10) { $tarikh[2] = "0" . $tarikh[2]; }

my $today = "$tarikh[2]-$tarikh[1]-$tarikh[4]";
my $today_ISO = "$tarikh[4]-$month{$tarikh[1]}-$tarikh[2]";
my $time_ISO = "$tarikh[3]"; ### 03/07/2004

my $global_debug_mode = 0;

sub new {
    my $class = shift @_;
    
    my $this = {};
    
    $this->{db_conn} = undef;
    $this->{db_interface} = undef; ### 27/02/2004
    
    $this->{cgi} = undef;
    
    $this->{content} = undef;
    $this->{template_file} = undef;
    
    $this->{component_name} = __PACKAGE__; ### 01/07/2010;
    #$this->{component_name} = undef; ### 21/11/2007
    #$this->{component_name} = "CGI_Component"; ### 26/03/2004
    
    $this->{debug_mode} = 0;
    
    $this->{used_session} = 0;
    $this->{session_id} = -1;
    $this->{session_table} = "session";
    $this->{login_field} = "login_name";
    
    $this->{used_authentication} = 0; ### 13/04/2004
    $this->{link_auth_table} = undef; ### 30/05/2011
    $this->{comp_auth_table} = undef; ### 13/04/2004
    $this->{user_auth_table} = "user"; ### 14/04/2004
    
    $this->{error} = undef; ### 13/04/2004
    $this->{redirect_session_error} = ""; ### 13/04/2004
    
    $this->{error_back_link} = undef; ### 17/05/2006
    
    $this->{cgi_data_reset} = undef; ### 14/04/2008
    
    $this->{exclude_db_cache_cgi_var} = undef; ### 17/12/2008
    $this->{remove_db_cache_cgi_var} = undef; ### 31/12/2008
    
    $this->{caller_module_name} = undef; ### 25/12/2008
    
    $this->{escape_html_tag} = undef; ### 17/12/2010
    
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

sub set_Pg_Conn {
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
    $this->{db_interface} = "Pg"; ### 27/02/2004
}

sub set_DBI_Conn { ### 27/02/2004
    my $this = shift @_;
    
    $this->{db_conn} = shift @_;
    $this->{db_interface} = "DBI"; 
}

sub set_CGI {
    my $this = shift @_;
    
    $this->{cgi} = shift @_;
}

sub add_Content {
    my $this = shift @_;
    
    my $new_content = shift @_;
    
    $this->{content} = $this->{content} . $new_content;
    
    #print "process add content: $new_content\n";
}

sub set_Content {
    my $this = shift @_;
    
    $this->{content} = shift @_;
}

sub set_Template_File {
    my $this = shift @_;
    
    $this->{template_file} = shift @_;
    
    #print "Set Template File: $this->{template_file}\n";
}

sub set_Debug_Mode { ### 26/03/2004
    my $this = shift @_;
    
    $this->{debug_mode} = shift @_;
    $global_debug_mode = shift @_;
}

sub set_HOME_DIR {
    my $this = shift @_;
    
    $HOME_DIR = shift @_;
}

sub set_HOME_URL { ### 23/07/2003
    my $this = shift @_;
    
    $HOME_URL = shift @_;
}

sub set_Session_ID { ### 23/11/2003
    my $this = shift @_;
    
    $this->{session_id} = shift @_;
}

sub set_Session_Table { ### 23/11/2003
    my $this = shift @_;
    
    $this->{session_table} = shift @_;
}

sub set_Authentication_Table { ### 13/04/2004
    my $this = shift @_;
    
    $this->{comp_auth_table} = shift @_;
}

sub set_Redirect_Session_Error { ### 13/04/2004
    my $this = shift @_;
    
    $this->{redirect_session_error} = shift @_;
}

sub set_Error { ### 18/05/2006
    my $this = shift @_;
    
    $this->{error} = shift @_;
}

sub set_Error_Back_Link { ### 17/05/2006
    my $this = shift @_;
    
    $this->{error_back_link} = shift @_;
}

sub set_CGI_Data_Reset { ### 14/04/2008
    my $this = shift @_;
    
    $this->{cgi_data_reset} = shift @_;
}


sub set_Exclude_DB_Cache_CGI_Var { ### 24/12/2008
    my $this = shift @_;
    
    $this->{exclude_db_cache_cgi_var} = shift @_;
}

sub set_Caller_Module_Name { ### 25/12/2008
    my $this = shift @_;
    
    $this->{caller_module_name} = shift @_;
}

sub set_Escape_HTML_Tag { ### 17/12/2010
    my $this = shift @_;
    
    $this->{escape_html_tag} = shift @_;
}

sub get_Pg_Conn {
    my $this = shift @_;
    
    return $this->{db_conn};
}

sub get_DB_Conn { ### 27/02/2004
    my $this = shift @_;
    
    return $this->{db_conn};
}

sub get_DB_Interface { ### 27/02/2004
    my $this = shift @_;
    
    return $this->{db_interface};
}

sub get_DBU { ### 26/12/2010
    my $this = shift @_;
    
    if ($this->{dbu} ne "") {
        return $this->{dbu};
        
    } elsif ($this->{db_conn} ne "") {
        my $dbu = new DB_Utilities;
        
        $dbu->set_DBI_Conn($this->{db_conn});
        
        $this->{dbu} = $dbu;
        
        return $this->{dbu};
    } 
    
    return undef;
}

sub get_CGI {
    my $this = shift @_;
    
    return $this->{cgi} ;
}

sub get_Template_File {
    my $this = shift @_;
    
    return $this->{template_file} ;
}

sub get_HOME_DIR {
    my $this = shift @_;
    
    return $HOME_DIR
}

sub get_HOME_URL { ### 23/07/2003
    my $this = shift @_;
    
    return $HOME_URL
}

sub get_Today {
    my $this = shift @_;
    
    return $today;
}

sub get_Today_ISO {
    my $this = shift @_;
    
    return $today_ISO;
}

sub get_Time_ISO { ### 03/07/2004
    my $this = shift @_;
    
    return $time_ISO;
}

sub get_Session_ID { ### 28/02/2004
    my $this = shift @_;
    
    return $this->{session_id};
}

sub get_Error { ### 18/05/2006
    my $this = shift @_;
    
    return $this->{error};
}

sub get_CGI_Data_Reset { ### 14/04/2008
    my $this = shift @_;
    
    return $this->{cgi_data_reset};
}

sub get_Caller_Module_Name { ### 25/12/2008
    my $this = shift @_;
    
    return $this->{caller_module_name};
}

###############################################################################

sub generate_GET_Data { ### 18/12/2010
    my $this = shift @_;
    
    my $var_name = shift @_;
    my $var_name_excepted = shift @_;
    
    return $this->{cgi}->generate_GET_Data($var_name, $var_name_excepted);
}

sub generate_Hidden_POST_Data { ### 18/12/2010
    my $this = shift @_;
    
    my $var_name = shift @_;
    my $var_name_excepted = shift @_;
    
    return $this->{cgi}->generate_Hidden_POST_Data($var_name, $var_name_excepted);
}

sub reset_CGI_Data { ### 14/04/2008
    my $this = shift @_;
    
    my $cgi = $this->{cgi};
    
    if ($this->{cgi_data_reset} ne "") {
        my $cgi_var_val = $this->{cgi_data_reset};
        
        $cgi_var_val =~ s/\\ /_space_/g;
        $cgi_var_val =~ s/\\'/_single_quote_/g;
        
        my @var_val_pairs = split(/ /, $cgi_var_val);
        
        #$cgi->add_Debug_Text("cgi_data_reset = $cgi_var_val", __FILE__, __LINE__, "TRACING");
        
        my $item = undef;
        
        foreach $item (@var_val_pairs) {
            my @data = split (/='/, $item);
            
            my $cgi_var = $data[0];
            my $cgi_val = $data[1];
            
            $cgi_val =~ s/'//g;
            $cgi_val =~ s/_space_/ /g;
            $cgi_val =~ s/_single_quote_/'/g;

            #$cgi->add_Debug_Text("Reset CGI Var/Val: $cgi_var = $cgi_val", __FILE__, __LINE__, "TRACING");
            
            $cgi->set_Param_Val($cgi_var, $cgi_val);
        }
    }
}

sub exclude_DB_Cache_CGI_Var { ### 17/12/2008
    my $this = shift @_;
    
    my $exclude_var_name = shift @_;
    
    my $cgi = $this->{cgi};
    
    if ($exclude_var_name ne "") {
        $this->{exclude_db_cache_cgi_var} = $exclude_var_name;
    }
    
    #print "\$this->{exclude_db_cache_cgi_var} = $this->{exclude_db_cache_cgi_var} <br>\n";
    
    $cgi->add_Exclude_DB_Cache_Var($this->{exclude_db_cache_cgi_var});
    $cgi->exclude_DB_Cache_Var;
}

sub remove_DB_Cache_CGI_Var { ### 31/12/2008
    my $this = shift @_;
    
    my $remove_var_name = shift @_;
    
    my $cgi = $this->{cgi};
    
    if ($remove_var_name ne "") {
        $this->{remove_db_cache_cgi_var} = $remove_var_name;
    } 
    
    #print "\$this->{remove_db_cache_cgi_var} = $this->{remove_db_cache_cgi_var} <br>\n";
    
    #$cgi->set_Remove_DB_Cache_Var($this->{remove_db_cache_cgi_var});
    
    $cgi->remove_DB_Cache_Var($this->{remove_db_cache_cgi_var}); ### 01/01/2009
    
    ### below is required or removed db cache variables cached again 
    ### while $cgi->update_DB_Cache_Var; inside index.cgi
    $cgi->add_Exclude_DB_Cache_Var($this->{remove_db_cache_cgi_var}); ### 02/01/2009
}

###################################################################################

sub run_Task {
    my $this = shift @_;
    
    #print "<font color=\"#FF0000\">run_Task from CGI_Component: </font>" . $this->get_Component_Name . "<br>\n";
    #print "Called by: " . $this->get_Caller_Module_Name . "<br>\n";
    
    $this->remove_DB_Cache_CGI_Var; ### 22/01/2009 
                                    ### must be called before exclude_DB_Cache_CGI_Var as we 
                                    ### consider call to add_Exclude_DB_Cache_Var inside 
                                    ### remove_DB_Cache_CGI_Var
                                    
    $this->exclude_DB_Cache_CGI_Var;
    
    #$this->{cgi}->add_Debug_Text($this->get_Name_Full, __FILE__, __LINE__);
    
}


###############################################################################

sub process_Content {
    my $this = shift @_;
    
    my $cgi = $this->{cgi};
    my $request_method = $cgi->request_Method;
    my @cgi_var_name = $cgi->var_Name;
    my $debug_content = "";
    
    if ($this->{debug_mode} || $global_debug_mode) {
        $debug_content = "<table width=400 border=1 cellpadding=1 cellspacing=1>";
        $debug_content .= "  <tr> ";
        $debug_content .= "    <td width=41% align=right><font face=\"Courier New, Courier, mono\" size=2><b>Component Name:</b></font></td>";
        $debug_content .= "    <td width=59%><font face=\"Courier New, Courier, mono\" size=2>$this->{component_name}</font></td>";
        $debug_content .= "  </tr>";
        $debug_content .= "  <tr> ";
        $debug_content .= "    <td width=41% align=right><font face=\"Courier New, Courier, mono\" size=2><b>Template File:</b></font></td>";
        $debug_content .= "    <td width=59%><font face=\"Courier New, Courier, mono\" size=2>$this->{template_file}</font></td>";
        $debug_content .= "  </tr>";
        $debug_content .= "  <tr> ";
        $debug_content .= "    <td width=41% align=right><font face=\"Courier New, Courier, mono\" size=2><b>CGI Request Method:</b></font></td>";
        $debug_content .= "    <td width=59%><font face=\"Courier New, Courier, mono\" size=2>$request_method</font></td>";
        $debug_content .= "  </tr>";
        $debug_content .= "  <tr> ";
        $debug_content .= "    <td width=41% align=center><font face=\"Courier New, Courier, mono\" size=2><b>CGI Variable</b></font></td>";
        $debug_content .= "    <td width=59% align=center><font face=\"Courier New, Courier, mono\" size=2><b>Value</b></font></td>";
        $debug_content .= "  </tr>";
        $debug_content .= "  <tr> ";
        $debug_content .= "    <td width=41%><font face=\"Courier New, Courier, mono\" size=2></font></td>";
        $debug_content .= "    <td width=59%><font face=\"Courier New, Courier, mono\" size=2></font></td>";
        $debug_content .= "  </tr>";
        
        my $i = 0;
        my $cgi_value = "";
        
        for ($i = 0; $i < @cgi_var_name; $i++) {
            $cgi_value = $cgi->param($cgi_var_name[$i]);
            $debug_content .= "  <tr> ";
            $debug_content .= "    <td width=41%><font face=\"Courier New, Courier, mono\" size=2>$cgi_var_name[$i]</font></td>";
            $debug_content .= "    <td width=59%><font face=\"Courier New, Courier, mono\" size=2>$cgi_value</font></td>";
            $debug_content .= "  </tr>";
        }
        
        $debug_content .= "</table>";
        
        $this->add_Content($debug_content);
    }
    
    if ($this->{template_file} ne undef) {
        my $i = 0;
        my $tex = new Template_Element_Extractor;
        my @te = $tex->get_Template_Element($this->{template_file});

        for ($i = 0; $i < @te; $i++) {
            my $type = $te[$i]->get_Type;
            my $temp_content = $te[$i]->get_Content;
            my $type_num = $te[$i]->get_Type_Num;
            
            my $result_content = undef;

            if ($type eq "VIEW") {
                $this->process_VIEW($te[$i]);
            }

            if ($type eq "DYNAMIC") {
                $this->process_DYNAMIC($te[$i]);
            }

            if ($type eq "LIST") {
                if ($te[$i]->{has_nested}) { ### 20/10/2011
                    $te[$i]->set_Content($this->process_Content_Nested($te[$i]->get_Content));
                }
                
                $this->process_LIST($te[$i]);
            }

            if ($type eq "MENU") {
                if ($te[$i]->{has_nested}) { ### 20/10/2011
                    $te[$i]->set_Content($this->process_Content_Nested($te[$i]->get_Content));
                }
                
                $this->process_MENU($te[$i]);
            }

            if ($type eq "DBHTML") {
                if ($te[$i]->{has_nested}) { ### 20/10/2011
                    $te[$i]->set_Content($this->process_Content_Nested($te[$i]->get_Content));
                }   
                
                $this->process_DBHTML($te[$i]);
                
                ### Below is an example of tested implementation for completion 
                ### of todo list on 20/11/2011. It requires all template element 
                ### processing functions to return the result and not directly
                ### add the result via $this->add_Content(...) function.
                
                #$result_content = $this->process_DBHTML($te[$i]);
                
                #if ($te[$i]->{has_nested}) { ### 20/10/2011
                #    $result_content = $this->process_Content_Nested($result_content);
                #}                
            }

            if ($type eq "SELECT") {
                $this->process_SELECT($te[$i]);
            }

            if ($type eq "DATAHTML") {
                if ($te[$i]->{has_nested}) { ### 20/10/2011
                    $te[$i]->set_Content($this->process_Content_Nested($te[$i]->get_Content));
                }
                
                $this->process_DATAHTML($te[$i]);
            }
            
            if ($type eq "CGIHTML") { ### 02/06/2009
                $this->process_CGIHTML($te[$i]);
            }
            
            if ($result_content ne "") {
                $this->add_Content($result_content);
            }
        }
    }
}

### 20/10/2011
### currently only <!-- start_cgihtml_ //--> ... <!-- end_cgihtml_ //--> 
### template tag pairs are valid to exist as nested template element object
sub process_Content_Nested {
    my $this = shift @_;
    
    my $te_content = shift @_;
    
    my $cgi = $this->{cgi};
    
    my $tex = new Template_Element_Extractor;
    my @te = $tex->get_Template_Element(undef, $te_content);
    
    my $new_content = undef;
    
    for (my $i = 0; $i < @te; $i++) {
        my $type = $te[$i]->get_Type;
        my $temp_content = $te[$i]->get_Content;
        my $type_num = $te[$i]->get_Type_Num;
        
        if ($type eq "CGIHTML") {
            $te[$i]->set_Content($this->process_CGIHTML($te[$i]));
        }
        
        $new_content .= $te[$i]->get_Content;        
    }
    
    return $new_content;
}

sub process_VIEW {
    my $this = shift @_;
    
    my $temp_so = shift @_;
    
    my $temp_content = $temp_so->get_Content;
            
    $this->add_Content($temp_content);
        
    # print "$temp_content\n";
}

sub process_DYNAMIC {
    my $this = shift @_;
    
    my $temp_so = shift @_;
}

sub process_LIST {
    my $this = shift @_;
    
    my $temp_so = shift @_;
}

sub process_MENU {
    my $this = shift @_;
    
    my $temp_so = shift @_;
}

sub process_DBHTML {
    my $this = shift @_;
    
    my $temp_so = shift @_;
}

sub process_SELECT {
    my $this = shift @_;
    
    my $temp_so = shift @_;
}

sub process_DATAHTML {
    my $this = shift @_;
    
    my $temp_so = shift @_;
}

sub process_CGIHTML { ### 02/06/2009
    my $this = shift @_;
    my $temp_so = shift @_;
    
    my $cgi_HTML = new CGI_HTML_Map;
    
    $cgi_HTML->set_CGI($this->{cgi});
    $cgi_HTML->set_HTML_Code($temp_so->get_Content);
    $cgi_HTML->set_Escape_HTML_Tag($this->{escape_html_tag}); ### can be 0 or 1
    
    my $te_content = $cgi_HTML->get_HTML_Code;
    
    if ($temp_so->{nested}) {
        return $te_content;
        
    } else {
        $this->add_Content($te_content);
    }
}

###############################################################################

sub get_Content {
    my $this = shift @_;
    
   ### need to clear $this->{content} and $this->{error} or possibly we will get the 
   ### content is copied to  other module if there are more than one modules called by
   ### the main controller
    
    if ($this->{error} ne "") {
        my $new_content = $this->{error};
        
        $this->{error} = "";
        $this->{content} = "";
        return $new_content;
        
    } else {
        my $new_content = $this->{content};
        
        $this->{content} = "";
        return $new_content;
    }
}

###############################################################################

sub end_Task {
    my $this = shift @_;
    
    $this->reset_CGI_Data;
}

###############################################################################

### 23/11/2003

sub used_Session {
    my $this = shift @_;
    
    $this->{used_session} = shift @_;
    
    my $table = shift @_;
    
    if ($table ne "") {
        $this->{session_table} = $table;
    }
}

sub is_Used_Session {
    my $this = shift @_;
    
    return $this->{used_session};
}

sub used_Authentication { 
    my $this = shift @_;
    
    $this->{used_authentication} = shift @_;
    
    my $table = shift @_;
    
    if ($table ne "") {
        $this->{comp_auth_table} = $table;
    }
}

sub is_Used_Authentication { 
    my $this = shift @_;
    
    return $this->{used_authentication};
}

sub auth_Link_ID { ### 30/05/2011
    my $this = shift @_;
    
    my $link_id = shift @_;
    my $link_auth_table = shift @_;
    my $skip_error_message = shift @_;
    
    my $dbu = $this->get_DBU;
    my $login_name = $this->get_User_Login;
    my @groups = $this->get_User_Groups;
    
    my $cgi = $this->{cgi};
    
    if (defined($link_auth_table)) {
        $this->{link_auth_table} = $link_auth_table;
    }
    
    if (!defined($this->{link_auth_table})) {
        $this->{link_auth_table} = "webman_". $cgi->param("app_name") . "_link_auth";
    }
    
    if (defined($this->{link_auth_table})) {
        $dbu->set_Table($this->{link_auth_table});
        
        ############## first check if passed link_id is authenticate ##########

        ### check if link_id is authenticate in link_auth table
        if (!$dbu->find_Item("link_id", $link_id)) { 
            #$cgi->add_Debug_Text("link_id=$link_id is not authenticate", __FILE__, __LINE__, "TRACING");

            return 1;
        }
        
        
        ############## second is check login name authentication ################

        if ($login_name ne "") {
            ### check if link_id is authenticate to current user
            if ($dbu->find_Item("link_id login_name", "$link_id $login_name")) {
                #$cgi->add_Debug_Text("link_id=$link_id is authenticate for user $login_name", __FILE__, __LINE__, "TRACING");

                return 1;               
            } 
        }
        
        
        ############## third is check for group authentication ####################

        if (@groups) {
            foreach my $group_name (@groups) {  

                ### check if link_id is authenticate to current user's groups
                if ($dbu->find_Item("link_id group_name", "$link_id $group_name")) {
                    #$cgi->add_Debug_Text("link_id=$link_id is authenticate for user $login_name via group $group_name", __FILE__, __LINE__, "TRACING");

                    return 1;
                }
            }
        }                
        
    } else { ### no authentication applied at all 
        return 1;
    }
    
    ###########################################################################
    
    if (!defined($skip_error_message)) {
        $skip_error_message = 0;
    }
    
    if (!$skip_error_message) {
        if ($this->{error_back_link} eq "") {
            my $session_id = $this->{cgi}->param("session_id");
            my $link_id = $this->{cgi}->param("link_id");
            my $app_name = $this->{cgi}->param("app_name");

            $this->{error_back_link} = "<a href=\"index.cgi?session_id=$session_id&task=\">Back to default/previous possible working page.</a>";
        }

        my $own_name = $this->get_Name;

        $this->{error} = "<center>\n";
        $this->{error} .= "<h3>Webman Framework Access Control</h3>\n";
        $this->{error} .= "<b>Error:</b> Don't have privilege on current selected link [<b>link_id: $link_id </b> &gt; <b>$own_name.pm</b>]<p>\n";
        $this->{error} .= "$this->{error_back_link}\n";
        $this->{error} .= "</center>\n";
    
        $this->add_Content($this->{error});
    
        $this->{cgi}->preserve_Previous_DB_Cache_Var; ### 10/04/2009 
                                                      ### have to call this or the user will trapped 
                                                      ### with component access privilege error
    }
    
    return 0;    
    
}

sub authenticate { ### 23/05/2003
    my $this = shift @_;
    
    my $login_name = shift @_;
    my $groups_array_ref = shift @_;
    my $comp_auth_table = shift @_;
    
    my $debug_mode = shift @_;
    
    my $cgi = $this->{cgi};
    
    my $db_conn = $this->get_DB_Conn;
    my $db_interface = $this->get_DB_Interface;
    
    if (!defined($login_name)) {
        $login_name = $this->get_User_Login;
    }
    
    if (!defined($groups_array_ref)) {
        my @array = $this->get_User_Groups;
        $groups_array_ref = \@array;
    }
    
    if (defined($comp_auth_table)) {
        $this->{comp_auth_table} = $comp_auth_table;
        
    } else {
        $this->{comp_auth_table} = "webman_". $cgi->param("app_name") . "_comp_auth";
    }
    
    my $dbu = new DB_Utilities;

    if ($db_interface eq "DBI") {
        $dbu->set_DBI_Conn($db_conn);
    } else {
        $dbu->set_Pg_Conn($db_conn);
    }
    
    $this->{child_component_name} = $this->get_Name;
    
    if ($debug_mode) {
        $cgi->add_Debug_Text("Try to authenticate component: " . $this->get_Name, __FILE__, __LINE__);
    }
    
    #$cgi->add_Debug_Text("\$this->{child_component_name} = $this->{child_component_name}", __FILE__, __LINE__);
    #$cgi->add_Debug_Text("\$this->{comp_auth_table} = $this->{comp_auth_table}", __FILE__, __LINE__);
    
    $dbu->set_Table($this->{comp_auth_table});
    
    ############## first check if current component is authenticate ###########
    
    ### check if component is authenticate in comp_auth table
    if (!$dbu->find_Item("comp_name", $this->{child_component_name})) {
        #$cgi->add_Debug_Text("pass: comp. is not authenticated", __FILE__, __LINE__);
        
        return 1;
    }
    
    
    ############## second is check login name authentication ################
    
    if ($login_name ne "") {
        $this->{used_authentication} = 1;
        
        ### check if component is authenticate to current user
        if ($dbu->find_Item("comp_name login_name", $this->{child_component_name} . " " . $login_name)) {
            #$cgi->add_Debug_Text("pass: comp. authentication for current user's login name", __FILE__, __LINE__);
            
            return 1;               
        } 
    }
    
    
    ############## third is check for group authentication ####################
    
    if ($groups_array_ref ne "") {
    
        $this->{used_authentication} = 1;
        
        my @groups = @{$groups_array_ref};
        my $group_name = undef;
        
        foreach $group_name (@groups) {  
        
            ### check if component is authenticate to current user's groups
            if ($dbu->find_Item("comp_name group_name", $this->{child_component_name} . " " . $group_name)) {
                #$cgi->add_Debug_Text("pass: comp. authentication for one of current user's groups", __FILE__, __LINE__);
                
                return 1;
            }
        }
    }
    
    ###########################################################################
       
    if ($this->{error_back_link} eq "") {
        my $session_id = $this->{cgi}->param("session_id");
        my $link_id = $this->{cgi}->param("link_id");
        my $app_name = $this->{cgi}->param("app_name");
        
        $this->{error_back_link} = "<a href=\"index.cgi?session_id=$session_id&link_id=$link_id&task=\">Back to previous possible working page.</a>";
        
        #$dbu->set_Table("webman_" . $app_name . "_cgi_var_cache");
        #$dbu->set_Keys_Str("session_id='$session_id' and link_id='$link_id' and name not in ('app_name', 'link_id', 'link_name')");
        #$dbu->delete_Item(undef, undef);
        #$dbu->set_Keys_Str(undef);
    }
    
    $this->{error} = "<center>\n";
    $this->{error} .= "<h3>Webman Framework Access Control</h3>\n";
    $this->{error} .= "<b>Error:</b> Don't have privilege to run/use the component [<b>$this->{child_component_name}.pm</b>]<p>\n";
    $this->{error} .= "$this->{error_back_link}\n";
    $this->{error} .= "</center>\n";

    $this->add_Content($this->{error});
    
    $this->{cgi}->preserve_Previous_DB_Cache_Var; ### 10/04/2009 
                                                  ### have to call this or the user will trapped 
                                                  ### with component access privilege error
    
    return 0;
}

###################################################################################

### 13/04/2004

sub check_Session {
    my $this = shift @_;
    
    my $session_id = shift @_;
    my $session_table = shift @_;
    
    if ($session_id ne "") {
            $this->{session_id} = $session_id;
    }
    
    if ($session_table ne "") {
        $this->{session_table} = $session_table;
    }
    
    $this->{used_session} = 1;
    
    my $session = new Session;
    
    if ($this->{db_interface} eq "Pg" || $this->{db_interface} eq "DBI") {
                
        if ($this->{db_interface} eq "DBI") {
            $session->set_DBI_Conn($this->{db_conn});
        } else {
            $session->set_Pg_Conn($this->{db_conn});
        }

        $session->set_Session_Table($this->{session_table});
        $session->set_Session_ID($this->{session_id});
    
        if (($this->{cgi} != undef) && ($this->{session_id} != -1) && $session->is_Valid) {
            return 1;   
        } else {
            #$session->is_Valid;
        }
        
    }
    
    $this->{error} = "<center><pre><font face=\"Verdana, Arial, Helvetica, sans-serif\" size=2>\n";
    $this->{error} .= "<h3>Webman Framework Session Handler</h3>\n";
    $this->{error} .= "Error: " . $session->get_Error . "<p>\n";
    $this->{error} .= "Please back to <a href=\"" . $this->{redirect_session_error} . "\">Login Page.</a>";
    $this->{error} .= "</font></pre></center>\n";

    $this->{content} = "";

    $this->{cgi}->print_Header;
    $this->{cgi}->start_HTML("GMM_CGI_lib");
    print $this->{error};
    $this->{cgi}->end_HTML;

    exit(1);
}

###############################################################################

sub generate_App_Constraint_Error_Message { ### 17/05/2006
    my $this = shift @_;
    
    my $type = shift @_;
    
    my $error_message  = undef;
    
    $error_message  = "<center>\n";
    $error_message .= "<h3>Webman Framework Application Constraints</h3>\n";
    $error_message .= "<b>Error:</b> Application Constraints on $type.<p>\n";
    $error_message .= "$this->{error_back_link}\n";
    $error_message .= "</center>\n";
    
    $this->{error} = $error_message;
    
    return $error_message;
}

###############################################################################
### All of the functions below is put here so other component that based
### on CGI_Component.pm module can be called without error within the 
### run_Sub_Component function inside the webman_main.pm module. The real 
### implementation of these functions is done inside webman_CGI_component.pm 
### module. The  set_Module_DB_Param function further overridden inside the 
### webman_main.pm module

sub set_Module_DB_Param { ### 29/04/2011
    my $this = shift @_;
}

###############################################################################

1;
