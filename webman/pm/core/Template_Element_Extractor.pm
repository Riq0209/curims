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

package Template_Element_Extractor;

require ("Template_Element.pm");

sub new {
    my $class = shift;
    
    my $this = {};
    
    $this->{restruct_content} = undef;
    
    bless $this, $class;
    
    return $this;
}

sub restruct_Doc {
    my $this = shift @_;
    
    my $file_name = shift @_;
    
    my $RESTRUCT_CONTENT = "";

    if (open(MYFILE, "<$file_name")) {
    
        @file = <MYFILE>;
    
        foreach $line (@file) {
            
            #$line =~ s/>/>\n/g;
            #$line =~ s/\n\n/\n/g;
            
            $line =~ s/<\!--/\n<\!--/g; ### 03/07/2003
            $line =~ s/\/\/-->/\/\/-->\n/g; ### 03/07/2003
        
            $RESTRUCT_CONTENT .= $line;
        }
    
        #$RESTRUCT_CONTENT =~ s/\n</</g;
        #$RESTRUCT_CONTENT =~ s/</\n</g;
        
        
        close (MYFILE);
    }
    
    $this->{restruct_content} = $RESTRUCT_CONTENT;
    
    return $RESTRUCT_CONTENT;
}

sub set_Doc_Content { ### 12/03/2005
    my $this = shift @_;
    
    my $doc_content = shift @_;
    
    my $RESTRUCT_CONTENT = "";
    
    my @doc_line = split(/\n/, $doc_content);
    
    foreach $line (@doc_line) {
        $line =~ s/<\!--/\n<\!--/g;
        $line =~ s/\/\/-->/\/\/-->\n/g;
        
        $RESTRUCT_CONTENT .= $line . "\n";
    }
    
    $this->{restruct_content} = $RESTRUCT_CONTENT;
    
    return $RESTRUCT_CONTENT;
}

sub get_Template_Element {
    my $this = shift @_;
    
    my $file_name = shift @_;
    my $nested_content = shift @_;
    
    my $stop_assign = 0;
    my $start_view = 1;
    
    ### vce stand for view child elements. $record_some_vce is used to 
    ### prevent more than one view child elements are recorded in case of
    ### nested vce is found in the template
    my $record_some_vce = 0;
    
    ### used as an indicator to be set to 1 when 
    ### nested template scenario has been found
    my $nested_template = 0;
    
    my $start_menu = 0;
    my $start_dbhtml = 0;
    my $start_dynamic = 0;
    my $start_list = 0;
    my $start_list2 = 0;
    my $start_select = 0;
    my $start_datahtml = 0;
    my $start_cgihtml = 0;

    my $view_content = "";
    my $menu_content = "";
    my $dbhtml_content = "";
    my $dynamic_content = "";
    my $list_content = "";
    my $select_content = "";
    my $datahtml_content = "";
    my $cgihtml_content = "";
    
    my $VIEW_num = 0;
    my $MENU_num = 0;
    my $DBHTML_num = 0;
    my $DYNAMIC_num = 0;
    my $LIST_num = 0;
    my $SELECT_num = 0;
    my $DATAHTML_num = 0;
    my $CGIHTML_num = 0;
    
    my $start_menu_header = undef;
    my $start_dbhtml_header = undef;
    my $start_list_header = undef;
    my $start_datahtml_header = undef;
    my $start_cgihtml_header = undef;
    
    my $te_num = 0;
    my @te_inst_list = new Template_Element;
    
    if (defined($file_name)) {
        $this->restruct_Doc("$file_name");
        
    } elsif(defined($nested_content)) {
        $this->{restruct_content} = $nested_content;
    }
    
    my @line = split(/\n/, $this->{restruct_content});
    
    my $nested_template_tag_start = undef;
    my $nested_template_tag_end = undef;
    
    if (defined($nested_content)) {
        $nested_template_tag_start = $line[0];
        $nested_template_tag_end = $line[@line - 1];
        
        $line[0] = "<!-- start_view_ //-->";
        $line[@line - 1] = "<!-- end_view_ //-->";
    }
    
    foreach $data (@line) { ##### current algorithm not support nested template tag
        #print "$data\n";
        
        ### Prevent any possible repeated parent template tags be processed.
        ### This mechanism is required and has been functionally tested to 
        ### complete the todo list mentioned on 20/10/2011.
        if (defined($nested_content)) {
            if ($data eq $nested_template_tag_start) {
                $data = "___ntt_start___";
            }
            
            if ($data eq $nested_template_tag_end) {
                $data = "___ntt_end___";
            }            
        }
        
        if ($data =~ /<\!-- start_view_ \/\/-->/) {
            $view_content = "";
            $stop_assign = 0;
            $data = "";
            $te_num = 0;
        }
        
        if ($data =~ /<\!-- end_view_ \/\/-->/) {
            $stop_assign = 1;
            
            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            
            $view_content = "";
            $te_num++;
            $VIEW_num++;
            
            $view_content = "";
            $data = "";
        }
        
        ############################################################################

        if ($data =~ /<\!-- start_menu_ .*\/\/-->/ && !$stop_assign && !$record_some_vce) {
            $record_some_vce = 1;
            
            $start_menu = 1;
            $start_view = 0;
                        
            $menu_content .= "$data\n";
            $start_menu_header = $data;
            
            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            
            $te_num++;
            $VIEW_num++;
            
            $view_content = "";
            $data = "";
            
        }
        
        if ($data =~ /<\!-- end_menu_ .*\/\/-->/ && $start_menu && !$stop_assign && $start_menu) {
            $record_some_vce = 0;
            
            $start_menu = 0;
            $start_view = 1;
            
            $menu_content .= "$data\n";
            
            my $te_type_name = $this->get_Template_Name($start_menu_header);
            $te_inst_list[$te_num] = $this->create_Template_Element("MENU", $menu_content, $MENU_num, $te_type_name);
            
            if ($nested_template) {
                $nested_template = 0;
                $te_inst_list[$te_num]->{has_nested} = 1;
            }
            
            $te_num++;
            $MENU_num++;
                        
            $menu_content = "";
            $data = "";
        }
        
        ############################################################################
        
        if ($data =~ /<\!-- start_dbhtml_ .*\/\/-->/ && !$stop_assign && !$record_some_vce) {
            $record_some_vce = 1;
            
            $start_dbhtml = 1;
            $start_view = 0;
                        
            $dbhtml_content .= "$data\n";
            $start_dbhtml_header = $data;
            
            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            $te_num++;
            $VIEW_num++;
            
            $view_content = "";
            $data = "";
            
        }
        
        if ($data =~ /<\!-- end_dbhtml_ .*\/\/-->/ && $start_dbhtml && !$stop_assign && $start_dbhtml) {
            $record_some_vce = 0;
            
            $start_dbhtml = 0;
            $start_view = 1;
            
            $dbhtml_content .= "$data\n";
            
            my $te_type_name = $this->get_Template_Name($start_dbhtml_header);
            $te_inst_list[$te_num] = $this->create_Template_Element("DBHTML", $dbhtml_content, $DBHTML_num, $te_type_name);            
            
            if ($nested_template) {
                $nested_template = 0;
                $te_inst_list[$te_num]->{has_nested} = 1;
            }            
            
            $te_num++;
            $DBHTML_num++;
                        
            $dbhtml_content = "";
            $data = "";
            

        }
        
        ############################################################################
        
        if (($data =~ /<\!-- dynamic_content_ .*\/\/-->/) && !$stop_assign && !$record_some_vce) {
            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            $te_num++;
            $VIEW_num++;
                        
            my $te_type_name = $this->get_Template_Name($data);
            $te_inst_list[$te_num] = $this->create_Template_Element("DYNAMIC", "", $DYNAMIC_num, $te_type_name);            
            $te_num++;
            $DYNAMIC_num++;
            
            $view_content = "";
            $data = "";
        }
        
        ############################################################################
        
        if (($data =~ /start_list_>/) && !$stop_assign && !$record_some_vce) {
            $record_some_vce = 1;
            
            $start_list = 1;
            $start_view = 0;
            
            $list_content .= "$data\n";
            
            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            $te_num++;
            $VIEW_num++;
            
            $view_content = "";
            $data = "";
        }
        
        if (($data =~ /<\/tr>/) && $start_list && !$stop_assign && $start_list) {
            $record_some_vce = 0;
            
            $start_list = 0;
            $start_view = 1;
            
            $list_content .= "$data\n";
            
            $te_inst_list[$te_num] = $this->create_Template_Element("LIST", $list_content, $LIST_num);            
            $te_num++;
            $LIST_num++;
            
            $list_content = "";
            $data = "";
        }
        
        ############################################################################
        
        if (($data =~ /<\!-- start_list_ .*\/\/-->/) && !$stop_assign && !$record_some_vce) { ### 19/08/2003
            $record_some_vce = 1;
            
            $start_list2 = 1;
            $start_view = 0;
            
            $list_content .= "$data\n";
            $start_list_header = $data;
            
            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            $te_num++;
            $VIEW_num++;
            
            $view_content = "";
            $data = "";
        }
        
        if (($data =~ /<\!-- end_list_ .*\/\/-->/) && $start_list2 && !$stop_assign && $start_list2) { ### 19/08/2003
            $record_some_vce = 0;
            
            $start_list2 = 0;
            $start_view = 1;
            
            $list_content .= "$data\n";
            
            my $te_type_name = $this->get_Template_Name($start_list_header);
            $te_inst_list[$te_num] = $this->create_Template_Element("LIST", $list_content, $LIST_num, $te_type_name);
            
            if ($nested_template) {
                $nested_template = 0;
                $te_inst_list[$te_num]->{has_nested} = 1;
            }            
            
            $te_num++;
            $LIST_num++;
            
            $list_content = "";
            $data = "";
        }
        
        ############################################################################
        
        if (($data =~ /<\!-- select_ .*\/\/-->/) && !$stop_assign && !$record_some_vce) {
            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            $te_num++;
            $VIEW_num++;
            
            my $te_type_name = $this->get_Template_Name($data);
            $te_inst_list[$te_num] = $this->create_Template_Element("SELECT", "", $SELECT_num, $te_type_name);
            $te_num++;
            $SELECT_num++;
            
            $view_content = "";
            $data = "";
        }
        
        ############################################################################
        
        if ($data =~ /<\!-- start_datahtml_ .*\/\/-->/ && !$stop_assign && !$record_some_vce) {
            $record_some_vce = 1;
            
            $start_datahtml = 1;
            $start_view = 0;

            $datahtml_content .= "$data\n";
            $start_datahtml_header = $data;

            $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
            $te_num++;
            $VIEW_num++;

            $view_content = "";
            $data = "";

        }

        if ($data =~ /<\!-- end_datahtml_ .*\/\/-->/ && $start_datahtml && !$stop_assign && $start_datahtml) {
            $record_some_vce = 0;

            $start_datahtml = 0;
            $start_view = 1;

            $datahtml_content .= "$data\n";
            
            my $te_type_name = $this->get_Template_Name($start_datahtml_header);
            $te_inst_list[$te_num] = $this->create_Template_Element("DATAHTML", $datahtml_content, $DATAHTML_num, $te_type_name);            
            
            if ($nested_template) {
                $nested_template = 0;
                $te_inst_list[$te_num]->{has_nested} = 1;
            }            
            
            $te_num++;
            $DATAHTML_num++;

            $datahtml_content = "";
            $data = "";
        }
        
        ############################################################################
        
        if ($data =~ /<\!-- start_cgihtml_ .*\/\/-->/ && !$stop_assign) { ### 02/06/2009
            if (!$record_some_vce) {
                $record_some_vce = 1;

                $start_cgihtml = 1;
                $start_view = 0;

                $cgihtml_content .= "$data\n";
                $start_cgihtml_header = $data;

                $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
                $te_num++;
                $VIEW_num++;

                $view_content = "";
                $data = "";
                
            } else {
                $nested_template = 1;
            }

        }

        if ($data =~ /<\!-- end_cgihtml_ .*\/\/-->/ && $start_cgihtml && !$stop_assign && $start_cgihtml) { ### 02/06/2009
            $record_some_vce = 0;
            
            $start_cgihtml = 0;
            $start_view = 1;

            $cgihtml_content .= "$data\n";
            
            my $te_type_name = $this->get_Template_Name($start_cgihtml_header);
            $te_inst_list[$te_num] = $this->create_Template_Element("CGIHTML", $cgihtml_content, $CGIHTML_num, $te_type_name);
            
            if (defined($nested_content)) {
                $te_inst_list[$te_num]->{nested} = 1;
            }
            
            $te_num++;
            $CGIHTML_num++;

            $cgihtml_content = "";
            $data = "";
        }
        
        #######################################################################
        
        ### Recover repeated parent template tags. This mechanism is required
        ### and has been functionally tested to complete the todo list 
        ### mentioned on 20/11/2011.
        if (defined($nested_content)) {
            if ($data eq "___ntt_start___") {
                $data = $nested_template_tag_start;
            }
            
            if ($data eq "___ntt_end___") {
                $data = $nested_template_tag_end;
            }            
        }
        
        #######################################################################
        
        if ($start_view && !$stop_assign) {
            $view_content .= "$data\n";
        }
        
        if ($start_menu && !$stop_assign) {
            $menu_content .= "$data\n";
        }
        
        if ($start_dbhtml && !$stop_assign) {
            $dbhtml_content .= "$data\n";
        }
        
        if ($start_list && !$stop_assign) {
            $list_content .= "$data\n";
        }
        
        if ($start_list2 && !$stop_assign) { ### 19/08/2003
            $list_content .= "$data\n";
        }
        
        if ($start_datahtml && !$stop_assign) {
            $datahtml_content .= "$data\n";
        }
        
        if ($start_cgihtml && !$stop_assign) {### 02/06/2009
            $cgihtml_content .= "$data\n";
        }         
        
    }
    
    if (!$stop_assign) {
        $te_inst_list[$te_num] = $this->create_Template_Element("VIEW", $view_content, $VIEW_num);
        $te_num++;
        $VIEW_num++;        
    }
    
    my $num = @te_inst_list;
    
    ### handling template that has other nested templet element
    if (defined($nested_content)) {
        $te_inst_list[0]->set_Content($nested_template_tag_start . $te_inst_list[0]->get_Content);
        $te_inst_list[$num - 1]->set_Content($te_inst_list[$num - 1]->get_Content . $nested_template_tag_end . "\n");
    }    
    
    if ($num > $te_num) {
        @te_inst_list2 = new Template_Element;
        
        for ($i = 0; $i < $te_num; $i++) {
            $te_inst_list2[$i] = $te_inst_list[$i];
        }
        
        return (@te_inst_list2);
        
    } else {
        return (@te_inst_list);
    }
}

sub create_Template_Element {
    my $this = shift @_;
    
    my $te_type = shift @_;
    my $te_type_content = shift @_;
    my $te_type_num = shift @_;
    my $te_type_name = shift @_;
    
    my $te = new Template_Element;
    
    $te->set_Type($te_type);
    $te->set_Content($te_type_content);
    $te->set_Type_Num($te_type_num);
    
    if (defined($te_type_name)) {
        $te->set_Name($te_type_name);
    }
    
    return $te;
}

sub get_Template_Name {
    my $this = shift @_;
    
    my $template_header = shift @_;
    
    my $template_name = $template_header;

    $template_name =~ s/<\!--//;
    $template_name =~ s/\/\/-->//;

    my @spliter = split(/ /, $template_name);
    my $count = 0;

    for ($count = 0; $count < @spliter; $count++) {
        if ($spliter[$count] =~ /name=.*/) {
            $template_name = $spliter[$count];
        }
    }

    if ($template_name =~ /^name=.*/) {
        $template_name =~ s/^name=//;

    } else {
        $template_name = undef;
    }
    
    return $template_name;
}

1;