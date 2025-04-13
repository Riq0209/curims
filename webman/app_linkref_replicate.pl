#! #!

unshift (@INC, "./pm/cli_tool");
unshift (@INC, "./pm/core");

use DBI;

require DB_Utilities;
require Node_Reference_Structure;

my $app_name = $ARGV[0];

### Link ID that provide source of references to be replicated.
my $link_id_src = $ARGV[1]; 

### Target link ID where replicated references will be dumped.
my $link_id_tgt = $ARGV[2];

my $os = $^O;

print "+----------------------------------------+\n";
print "|Replicate Link Structure References.    |\n";
print "+----------------------------------------+\n\n";

print "Running in $os OS\n\n";

print "Application Name: ";
if ($app_name eq "") {
    $app_name = <STDIN>;
    $app_name =~ s/\n//;
    $app_name =~ s/\r//;
    
} else {
    print "$app_name\n";
}

print "\n";

print "Source Link ID: ";
if ($link_id_src eq "") {
    $link_id_src = <STDIN>;
    $link_id_src =~ s/\n//;
    $link_id_src =~ s/\r//;
    
} else {
    print "$link_id_src\n";
}

print "Target Link ID: ";
if ($link_id_tgt eq "") {
    $link_id_tgt = <STDIN>;
    $link_id_tgt =~ s/\n//;
    $link_id_tgt =~ s/\r//;
    
} else {
    print "$link_id_tgt\n";
}

print "\n";

###############################################################################

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("./conf/dbi_connection.conf");
$dbu->set_DBI_Conn($db_conn);



my $nrs_src = new Node_Reference_Structure($app_name, $link_id_src, $dbu);
my $nrs_tgt = new Node_Reference_Structure($app_name, $link_id_tgt, $dbu);

$nrs_src->get_Structure;
$nrs_tgt->get_Structure;

my $link_error = undef;

if ($link_id_src eq $link_id_tgt) {
    $link_error = "Identical node replication.\n"; 
}

if (defined($nrs_src->{error})) { 
    $link_error .= "$nrs_src->{error}\n";
}

if (defined($nrs_tgt->{error})) { 
    $link_error .= "$nrs_tgt->{error}\n";
}

if (!defined($nrs_src->{ref_root})) {
    $link_error .= "Source link node is reference empty.\n"; 
}

if ($nrs_tgt->{ref_exist}) {
    $link_error .= "Target link node already have reference.\n"; 
}

if (defined($link_error)) { 
    print "Found Error(s): \n";
    print "$link_error \n";
    
} else {
    print "Source root node: " . $nrs_src->{link_path_info} . "\n";
    print "Target root node: " . $nrs_tgt->{link_path_info} . "\n\n";
    
    print $nrs_src->get_Structure_FmtTxt;
    print "\n";
    print "Start replicate...\n\n";
    
    ### Traverse and replicate reference structure.
    &trvrep_Struct($nrs_src->{ref_root});
    
    
}

###############################################################################

### Traverse and replicate reference structure function.
sub trvrep_Struct {
    my $node_parent = shift @_;
    my $link_ref_id = shift @_;
    my $dyna_mod_selector_id = shift @_;
    
    my @childs = $node_parent->get_Childs;

    ### First loop
    foreach $node (@childs) {
        print "Replicate $node->{type}: $node->{text} - ";
        
        my $info = $node->{info_hash};
        
        if ($node->{type} eq "reference_selector") {
            print "webman_" . $app_name . "_link_reference\n";
            
            $dbu->set_Table("webman_" . $app_name . "_link_reference");
            
            $link_ref_id = $dbu->get_Unique_Random_Num("link_ref_id", "20000", "29999");
            
            print "$link_ref_id, $link_id_tgt, $info->{dynamic_content_num}, $info->{dynamic_content_name}, $info->{ref_type}, $info->{ref_name}, $info->{blob_id}\n\n";
            
            $dbu->insert_Row("link_ref_id link_id dynamic_content_num dynamic_content_name ref_type ref_name blob_id", 
                             "$link_ref_id $link_id_tgt $info->{dynamic_content_num} $info->{dynamic_content_name} $info->{ref_type} $info->{ref_name} $info->{blob_id}");            
            
            &trvrep_Struct($node, $link_ref_id);
            
        } elsif ($node->{type} eq "reference") {
            ### The $link_ref_id parameter available here might be the one  
            ### passed via previous recursive functio call made inside
            ### the "reference_selector" condition. If it's not available 
            ### create the new one;
            if (!defined($link_ref_id)) {
                $dbu->set_Table("webman_" . $app_name . "_link_reference");
                $link_ref_id = $dbu->get_Unique_Random_Num("link_ref_id", "100000", "999999");           
            }
            
            if ($node->{info_hash}->{dyna_mod_selector_id}) {
                print "webman_" . $app_name . "_dyna_mod_selector\n";
                
                ### The $link_ref_id parameter available here is normally the 
                ### one brought via recursive function call made inside the
                ### the "reference_selector" condition.
                
                $dbu->set_Table("webman_" . $app_name . "_dyna_mod_selector");
                
                ### Get the next 'dyna_mod_selector_id' value based on its 
                ### current max value.
                my $dyna_mod_selector_id = $dbu->get_MAX_Item("dyna_mod_selector_id") + 1;
                
                print "$dyna_mod_selector_id, $link_ref_id, 'null', $info->{cgi_param}, $info->{cgi_value}, $info->{dyna_mod_name}\n\n";
                
                $dbu->insert_Row("dyna_mod_selector_id link_ref_id cgi_param cgi_value dyna_mod_name", 
                                 "$dyna_mod_selector_id $link_ref_id $info->{cgi_param} $info->{cgi_value} $info->{dyna_mod_name}");
                                 
                &trvrep_Struct($node, -1, $dyna_mod_selector_id);
                
            } else {
                print "webman_" . $app_name . "_link_reference\n";
                
                ### The $link_ref_id parameter available here is normally 
                ### the one that newly created inside the "reference" 
                ### condition itself.
                
                $dbu->set_Table("webman_" . $app_name . "_link_reference");
                
                print "$link_ref_id, $link_id_tgt, $info->{dynamic_content_num}, $info->{dynamic_content_name}, $info->{ref_type}, $info->{ref_name}, $info->{blob_id}\n";
                
                $dbu->insert_Row("link_ref_id link_id dynamic_content_num dynamic_content_name ref_type ref_name blob_id", 
                                 "$link_ref_id $link_id_tgt $info->{dynamic_content_num} $info->{dynamic_content_name} $info->{ref_type} $info->{ref_name} $info->{blob_id}");                            
                
                &trvrep_Struct($node, $link_ref_id, -1);
            }
            
        } elsif ($node->{type} eq "parameter") {
            print "webman_" . $app_name . "_dyna_mod_param\n";
            
            ### The $link_ref_id parameter available here is either generated 
            ### inside 
            
            $dbu->set_Table("webman_" . $app_name . "_dyna_mod_param");
            
            ### Get the next 'dmp_id' value based on its 
            ### current max value.
            my $dmp_id = $dbu->get_MAX_Item("dmp_id") + 1;
                
            print "$dmp_id, $link_ref_id, -1, $dyna_mod_selector_id, $info->{param_name}, $info->{param_value}\n\n";
            
            my $param_value = $info->{param_value};
               $param_value =~ s/ /\\ /g;
            
            $dbu->insert_Row("dmp_id link_ref_id scdmr_id dyna_mod_selector_id param_name param_value",
                             "$dmp_id $link_ref_id -1 $dyna_mod_selector_id $info->{param_name} $param_value");
        
        }
    }
}
