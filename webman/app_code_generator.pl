#! /usr/bin/perl

unshift (@INC, "./pm/cli_tool/");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;

require Webman_Config_Tools;
require Webman_Module_Generator;
require Webman_Module_Updater;
require Webman_Template_Generator;
require Webman_LSR_Generator;

my $app_name = $ARGV[0];
my $app_table_name = $ARGV[1];
my $test_mode = $ARGV[2];

my $db_host = $ARGV[3];
my $db_name = $ARGV[4];
my $db_user_name = $ARGV[5];
my $db_password = $ARGV[6];

my $db_socket = $ARGV[7];



### provide info. for the mechanism used to avoid back and circular reference 
### to the same table name 
my %table_code_generated = ();   

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year += 1900;
$mon += 1;

if ($mon < 10) {
    $mon = "0" . $mon;
}

if ($mday < 10) {
    $mday = "0" . $mday;
}

my $wmct = new Webman_Config_Tools;
   
my $dir_web_cgi = $wmct->{"dir_web_cgi"};

print "\$dir_web_cgi = " . $dir_web_cgi . "\n";

print "\n\n--- Generate Webman Application Domain Table Logic Operations ---\n\n";

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("./conf/dbi_connection.conf");

$dbu->set_DBI_Conn($db_conn);

print "Application Name: ";
if ($app_name eq "") {
    $app_name = <STDIN>;
    
    $app_name =~ s/\n//;
    $app_name =~ s/\r//;
    
} else {
    print "$app_name\n";
}

my $file_opres = -e $dir_web_cgi . "/$app_name";

if (!$file_opres) {
    print $app_dir;
    print "Can't proceed since the application '$app_name' is not exist!!!\n";
    exit 1;
}

print "\n";

print "Application Table Name: ";
if ($app_table_name eq "") {
    $app_table_name = <STDIN>;
    
    $app_table_name =~ s/\n//;
    $app_table_name =~ s/\r//;    
    
} else {
    print "$app_table_name\n";
}

if (!$dbu->table_Exist($app_table_name)) {
    print "Can't proceed since the application table '$app_table_name' is not exist!!!\n";
    exit 1;
}

print "\n";

print "Test Mode [0|1]: ";
if ($test_mode eq "") {
    $test_mode = <STDIN>;
    
    $test_mode =~ s/\n//;
    $test_mode =~ s/\r//;
    
} else {
    print "$test_mode\n";
}

print "\n";

###############################################################################

print "Database Information:\n\n";

if ($db_host eq "" && $wmct->{"db_host"} ne "") {
    $db_host = $wmct->{"db_host"};
}

if ($db_name eq "" && $wmct->{"db_name"} ne "") {
    $db_name = $wmct->{"db_name"};
}

if ($db_user_name eq "" && $wmct->{"db_user_name"} ne "") {
    $db_user_name = $wmct->{"db_user_name"};
}

if ($db_password eq "" && $wmct->{"db_password"} ne "") {
    $db_password = $wmct->{"db_password"};
}

if ($db_socket eq "" && $wmct->{"db_socket"} ne "") {
    $db_socket = $wmct->{"db_socket"};
}

print "        DB Host: ";
if ($db_host eq "") {
    $db_host = <STDIN>;
    $db_host =~ s/\n//;
    $db_host =~ s/\r//;
    
} else {
    print "$db_host\n";
}


print "        DB Name: ";
if ($db_name eq "") {
    $db_name = <STDIN>;
    $db_name =~ s/\n//;
    $db_name =~ s/\r//;
    
} else {
    print "$db_name\n";
}

print "   DB User Name: ";
if ($db_user_name eq "") {
    $db_user_name = <STDIN>;
    $db_user_name =~ s/\n//;
    $db_user_name =~ s/\r//;
    
} else {
    print "$db_user_name\n";
}

print "    DB Password: ";
if ($db_password eq "") {
    $db_password = <STDIN>;
    $db_password =~ s/\n//;
    $db_password =~ s/\r//;
    
} else {
    print "$db_password\n";
}

###############################################################################

print "Run 'app_dbt_schema.pl' on '$app_name' application.\n";
print "Press enter to continue...\n";
print "app_dbt_schema.pl $app_name $db_host $db_name $db_user_name $db_password n\n";
`perl app_dbt_schema.pl $app_name $db_host $db_name $db_user_name $db_password n`;


print "\n\n";

my $dbt_schema = $wmct->get_DBT_Schema($app_name);

my $schema_super = undef;
my $schema_sub = undef;
my %map_table_type = ();
my %map_table_relations = ();

### $dbt_schema is hash of array of hash... ;-)
foreach my $key (sort(keys(%{$dbt_schema}))) {
    foreach my $item (@{$dbt_schema->{$key}}) {
        if ($item->{type} eq "super") {
            $schema_super .= "$item->{type}:$key:$item->{pk} > $item->{bound_key} > $item->{bound_type}:$item->{bound_name}:$item->{bound_pk}\n";
        } else {
            $schema_sub .= "$item->{type}:$key:$item->{pk} > $item->{bound_key} > $item->{bound_type}:$item->{bound_name}:$item->{bound_pk}\n";
        }
        
        $map_table_type{$key} = $item->{type};
        $map_table_type{$item->{bound_name}} = $item->{bound_type};
        
        if (!defined($map_table_relations{$key})) {
            $map_table_relations{$key} = [];
        }
        
        push (@{$map_table_relations{$key}}, $item->{bound_name});
        
        if (!defined($map_table_relations{$item->{bound_name}})) {
            $map_table_relations{$item->{bound_name}} = [];
        }
        
        push (@{$map_table_relations{$item->{bound_name}}}, $key);
    }
}

### print all table relationships
print "All application table relationships:\n\n";
foreach my $key (sort(keys(%map_table_relations))) {
    foreach my $item (@{$map_table_relations{$key}}) {
        print "$key -> $item\n";
    }
}

print "\n\n";
print "Application table schema:\n\n";

print $schema_super;
print $schema_sub;
print "\n\n";

print "Application table mediator schema:\n\n";
my $dbt_med_schema = $wmct->get_DBT_Mediator_Schema($app_name);

foreach my $key (sort(keys(%{$dbt_med_schema}))) {
    foreach my $item (@{$dbt_med_schema->{$key}}) {
        print "$item->{type}:$key:$item->{pk} > $item->{bound_key} > $item->{bound_type}:$item->{bound_name}:$item->{bound_pk}\n";
    }
}

### for sub table that used to act as a mediator table
my $dbt_med_schema_act = undef;

print "\n";

print "Press enter to start generate code... ";
my $stuck = <STDIN>;
print "\n";

my @codegen_input = ({current_idx => 0});
my @codegen_input_rec = ();

### enable and take input from @codegen_input array option
&use_ACGen_Input($app_table_name);

print "\n";
print "################################################################################\n\n";
print "Generate code for handling table items [$app_table_name]...\n\n";

my $dbi_handling_opt = 0;
my $dbi_multi_row_opt = 0;
my $dbi_txt2db_opt = 0;

$dbi_handling_opt = &set_DB_Item_Handling_Options;

if ($dbi_handling_opt == 2 || $dbi_handling_opt == 4) {
    $dbi_multi_row_opt = &set_DB_Item_Multi_Row_Options;
    
} else {
    $dbi_multi_row_opt = 4;
}

###############################################################################
my $key_field_list = undef;
my $key_field_search = undef;

if ($dbi_handling_opt > 4 && $dbi_handling_opt < 9) {
    #if (defined($key_field_entry)) {
    #    $key_field_search = $key_field_entry;
        
    #} else {
        my $situation = "Current selected database handling option requires search key-field(s) entry by users!\n";
        my %opr_num_map = (5 => "search->update operation", 
                           6 => "search->delete operation", 
                           7 => "search operation", 
                           8 => "search->update/delete operations"); 
        
        $key_field_search = &get_Key_Field($app_table_name, $situation, $opr_num_map{$dbi_handling_opt});
    #}
}

###############################################################################

if ($dbi_handling_opt == 2 || $dbi_handling_opt == 4 || 
    $dbi_handling_opt == 5 || $dbi_handling_opt == 6) {
    $dbi_txt2db_opt = &set_DB_Item_Txt2DB_Options;
}

my $key_field_entry = undef;
my $key_field_insert = undef;

if ($map_table_type{$app_table_name} eq "sub" && ($dbi_handling_opt == 2 || $dbi_handling_opt == 4)) {
    my $situation = "Current selected database structure requires unique key-field entry.\n";
    my $opr_type  = "insert operation";
    
    $key_field_insert = &get_Key_Field($app_table_name, $situation, $opr_type);
}

#print "\$map_table_type{$app_table_name} = $map_table_type{$app_table_name}\n";
#my $stuck = <STDIN>;

if ($dbi_txt2db_opt && ($dbi_handling_opt == 2 || $dbi_handling_opt == 5 || $dbi_handling_opt == 6)) {
    print "Text-based database input support might requires unique key-field entry to be defined.\n\n";
    
    my $choice = &get_Yes_No_Options("Define unique key-field entry? [y/n]: ");

    print "\n";

    if ($choice eq "y") {
        my $situation = "Text-based database input unique key-field entry.\n";
        my $opr_type  = "text->db insert/update/delete operations";
    
        $key_field_entry = &get_Key_Field($app_table_name, $situation, $opr_type);
    }
}

###############################################################################

my @sub_table_queue = ();
my $map_table_list_template = {};
my $map_table_link_id = {};

my $foreign_unique_keys = &get_Foreign_Unique_Key($app_table_name);
    
&start_Generate({test_mode => $test_mode, dbi_handling_opt => $dbi_handling_opt, 
                 dbi_multi_row_opt => $dbi_multi_row_opt, dbi_txt2db_opt => $dbi_txt2db_opt, 
                 table_name => $app_table_name, key_field_search => $key_field_search, 
                 map_table_link_id => $map_table_link_id, map_table_relations => \%map_table_relations,
                 codegen_input => \@codegen_input, codegen_input_rec => \@codegen_input_rec, 
                 foreign_unique_keys => $foreign_unique_keys, map_table_type => \%map_table_type});

$table_code_generated{$app_table_name} = $dbi_handling_opt;

my $codegen_key_name = $app_table_name . $dbi_handling_opt . "-";

my $sub_table = shift(@sub_table_queue);
my $map_table_parent = {};

while ($sub_table ne "") {
    print "\n\n";
    print "################################################################################\n\n";
    print "Generate code for related table items [$sub_table->{parent} > $sub_table->{name}]...\n\n";
    
    $map_table_parent->{$sub_table->{name}} = $sub_table->{parent};   

    $dbi_handling_opt = &set_DB_Item_Handling_Options;
    
    if ($dbi_handling_opt == 2) {
        $dbi_multi_row_opt = &set_DB_Item_Multi_Row_Options;
        
    } else {
        $dbi_multi_row_opt = 4;
    }
    
    if ($dbi_handling_opt == 2 || $dbi_handling_opt == 4 || 
        $dbi_handling_opt == 5 || $dbi_handling_opt == 6) {
        $dbi_txt2db_opt = &set_DB_Item_Txt2DB_Options;
    }
    
    $key_field_entry = undef;
    $key_field_insert = undef;
    
    if ($map_table_type{$sub_table->{name}} eq "sub" && ($dbi_handling_opt == 2 || $dbi_handling_opt == 4)) {
        my $situation = "Current selected database structure requires unique key-field entry.\n";
        my $opr_type  = "insert operation";

        $key_field_insert = &get_Key_Field($sub_table->{name}, $situation, $opr_type);
    }
    
    #print "\$map_table_type{$sub_table->{name}} = $map_table_type{$sub_table->{name}}\n";
    #my $stuck = <STDIN>;

    if ($dbi_txt2db_opt && ($dbi_handling_opt == 2 || $dbi_handling_opt == 5 || $dbi_handling_opt == 6)) {
        print "Text-based database input support might requires unique key-field entry to be defined.\n\n";
    
        my $choice = &get_Yes_No_Options("Define unique key-field entry? [y/n]: ");

        print "\n";

        if ($choice eq "y") {
            my $situation = "Text-based database input unique key-field entry.\n";
            my $opr_type  = "text->db insert/update/delete operations";
            $key_field_entry = &get_Key_Field($sub_table->{name}, $situation, $opr_type);
        }
        
        print "\n";
    }    

    $key_field_list = undef;
    $key_field_search = undef;
    
    if ($dbi_handling_opt > 4) {
        if (defined($key_field_entry)) {
            $key_field_search = $key_field_entry;

        } else {
            my $situation = "Current selected database handling option requires search's key-field(s) entry by users!\n";
            my $opr_type  = "search/update/delete operations";       
            
            $key_field_search = &get_Key_Field($sub_table->{name}, $situation, $opr_type);
        }
    }
    
    $foreign_unique_keys = &get_Foreign_Unique_Key($sub_table->{name});

    &start_Generate({test_mode => $test_mode, dbi_handling_opt => $dbi_handling_opt, 
                     dbi_multi_row_opt => $dbi_multi_row_opt, dbi_txt2db_opt => $dbi_txt2db_opt, 
                     table_name => $sub_table->{name}, key_field_search => $key_field_search, 
                     table_info => $sub_table, map_table_parent => $map_table_parent, 
                     map_table_link_id => $map_table_link_id, map_table_relations => \%map_table_relations,
                     codegen_input => \@codegen_input, codegen_input_rec => \@codegen_input_rec, 
                     foreign_unique_keys => $foreign_unique_keys, map_table_type => \%map_table_type});
                     
    $table_code_generated{$sub_table->{name}} = $dbi_handling_opt;
    
    $codegen_key_name .= $sub_table->{name} . $dbi_handling_opt . "-";
    
    $sub_table = shift(@sub_table_queue);
}

$codegen_key_name =~ s/\-$//;

###############################################################################

if ($codegen_input[0]->{current_idx} == 0) {
    print "\n";
    print "################################################################################\n";
    print "\n";
    &save_ACGen_Input;
}

###############################################################################

sub start_Generate { 
    my $arg = shift @_;
    
    my $link_sub_tables = undef;
    
    $arg->{overwrite_all_module} = 0;
    $arg->{overwrite_all_template} = 0;
    
    if ($dbt_schema->{$arg->{table_name}} ne "" && $dbi_handling_opt < 4) {
        print "Generate link(s) to list '$arg->{table_name}' other related table(s)...\n\n";
        
        foreach my $item (@{$dbt_schema->{$arg->{table_name}}}) {
            if ($item->{bound_type} ne "mediator" && $table_code_generated{$item->{bound_name}} eq "") {
                my $str_info = "$arg->{table_name} > $item->{bound_name} [y/n]: ";

                my $choice = &get_Yes_No_Options($str_info);

                if ($choice eq "y") {
                    $item->{generate_code} = 1;
                    push(@sub_table_queue, {name => $item->{bound_name}, parent => $arg->{table_name}});
                    $link_sub_tables .= "_$item->{bound_name}";
                    
                }
                
                foreach my $item2 (@{$map_table_relations{$item->{bound_name}}}) {
                    ### at this level the related table ($item2) has the       
                    ### features of being linked via table type mediator
                    ### thus necessary to make $item->{bound_name} acting
                    ### as a mediator table type
                    if ($item2 ne $arg->{table_name}) {
                        my $str_info = "$arg->{table_name} > $item->{bound_name} > $item2 [y/n]: ";

                        my $choice = &get_Yes_No_Options($str_info);

                        if ($choice eq "y") {
                            if (!defined($dbt_med_schema_act)) {
                                $dbt_med_schema_act = {};
                            }
                            
                            if (!defined($dbt_med_schema_act->{$item->{bound_name}})) {
                                $dbt_med_schema_act->{$item->{bound_name}} = [];
                            }
                            
                            my $hash_ref = $wmct->get_DBT_Mediator_Schema_Act($app_name, $item->{bound_name}, $item2);
                               $hash_ref->{dbt_schema_key} = $arg->{table_name};
                               
                            push(@{$dbt_med_schema_act->{$item->{bound_name}}}, $hash_ref);
                            
                            #$wmct->debug(__FILE__, __LINE__, 
                            #             "Acting mediator: $hash_ref->{type}:$item->{bound_name}:$hash_ref->{pk} > $hash_ref->{bound_key} > $hash_ref->{bound_type}:$hash_ref->{bound_name}:$hash_ref->{bound_pk}\n" . 
                            #             "\$dbt_med_schema_act = $dbt_med_schema_act\n" .
                            #             "\$dbt_med_schema_act->{$item->{bound_name}} = $dbt_med_schema_act->{$item->{bound_name}}\n");
                            
                            push(@sub_table_queue, {name => $item2, parent => $arg->{table_name}});
                            $link_sub_tables .= "_$item2";

                        }
                    }
                }                
                
            } elsif ($item->{bound_type} eq "mediator") {
                foreach my $item_med (@{$dbt_med_schema->{$item->{bound_name}}}) {
                    if ($item_med->{bound_name} ne $arg->{table_name} && $table_code_generated{$item_med->{bound_name}} eq "") {
                        #print "Check dbt_med_schema: $item->{bound_name} > $item_med->{bound_key} > $item_med->{bound_name}\n"; 
                        #my $stuck = <STDIN>;
                        
                        my $str_info = "$arg->{table_name} > $item->{bound_name} > $item_med->{bound_name} [y/n]: ";

                        my $choice = &get_Yes_No_Options($str_info);

                        if ($choice eq "y") {
                            $item->{generate_code} = 1;
                            $item_med->{generate_code} = 1;
                            
                            push(@sub_table_queue, {name => $item_med->{bound_name}, parent => $arg->{table_name}, via_mediator => $item->{bound_name}});
                            $link_sub_tables .= "_$item_med->{bound_name}";
                        }                        
                    }
                }
            }
        }
    }
    
    $dbu->set_Table($arg->{table_name});
    my @ahr = $dbu->get_Table_Structure;

    my $init_ref = {wmct => $wmct, app_name => $app_name, table_name => $arg->{table_name}, 
                    dbts => \@ahr, dbt_schema => $dbt_schema, dbt_med_schema => $dbt_med_schema,
                    dbt_med_schema_act => $dbt_med_schema_act};
                    
    ###########################################################################
    
    if ($arg->{dbi_handling_opt} < 4) {
        print "\n\n";
        print "Current database handling option for table '$arg->{table_name}' requires item list operation.\n\n";
        
        my $choice = &get_Yes_No_Options("Apply filter for item listing? [y/n]: ");
        
        print "\n";
        
        if ($choice eq "y") {
            my $situation = undef;
            my $opr_type = "database item list operation";
            $key_field_list = &get_Key_Field($arg->{table_name}, $situation, $opr_type);
        }
        
        print "\n";
    }
    
    my $wmmg = new Webman_Module_Generator($init_ref, $dbu, $arg);

    if ($arg->{dbi_handling_opt} != 9) {
        if ($arg->{dbi_handling_opt} < 4) {
            $wmmg->generate_DBI_List_Dynamic($link_sub_tables, $key_field_list);

            if ($arg->{dbi_handling_opt} == 2) {       
                $wmmg->generate_DBI_IUD("insert");
                $wmmg->generate_DBI_IUD("update");
                $wmmg->generate_DBI_IUD("delete");
                
                if ($arg->{dbi_txt2db_opt}) {
                    $wmmg->generate_DBI_IUD_Txt2DB("insert");
                    $wmmg->generate_DBI_IUD_Txt2DB("update");
                    $wmmg->generate_DBI_IUD_Txt2DB("delete");
                }

            } elsif ($arg->{dbi_handling_opt} == 3) {
                $wmmg->generate_DBI_Add($key_field_list);
                $wmmg->generate_DBI_Remove;        
            }
            
        } elsif ($arg->{dbi_handling_opt} == 4) {
            $wmmg->generate_DBI_IUD("insert");
            
            if ($arg->{dbi_txt2db_opt}) {
                $wmmg->generate_DBI_IUD_Txt2DB("insert");
            }
            
        } elsif ($arg->{dbi_handling_opt} == 5) {
            $wmmg->generate_DBI_Search;
            $wmmg->generate_DBI_IUD("update");
            
            if ($arg->{dbi_txt2db_opt}) {
                $wmmg->generate_DBI_IUD_Txt2DB("update");
            }            
            
        } elsif ($arg->{dbi_handling_opt} == 6) {
            $wmmg->generate_DBI_Search;
            $wmmg->generate_DBI_IUD("delete");
            
            if ($arg->{dbi_txt2db_opt}) {
                $wmmg->generate_DBI_IUD_Txt2DB("delete");
            }            
            
        } elsif ($arg->{dbi_handling_opt} == 7) {
            $wmmg->generate_DBI_Search;
            
        } elsif ($arg->{dbi_handling_opt} == 8) {
            $wmmg->generate_DBI_Search;
            $wmmg->generate_DBI_IUD("update");
            $wmmg->generate_DBI_IUD("delete");
        }
    }
    
    ### update modules to be included in or removed from the main controller 
    my $wmmu = new Webman_Module_Updater($init_ref, $dbu, $arg);
    
    $wmmu->rewrite_Main_Controller;
    
    ###########################################################################
    
    my $wmtg = new Webman_Template_Generator($init_ref, $dbu, $arg);
    
    if ($arg->{dbi_handling_opt} != 9) {
        $wmtg->process_DBTS_Info;
        
        if ($arg->{dbi_handling_opt} < 4) {
            $map_table_list_template->{$arg->{table_name}} = $wmtg->generate_DBI_List_Dynamic($key_field_list);
            
            if ($arg->{dbi_handling_opt} == 2) {
                $wmtg->generate_DBI_IU_Form("insert");
                $wmtg->generate_DBI_IUD_Confirm("insert");

                $wmtg->generate_DBI_IU_Form("update");
                $wmtg->generate_DBI_IUD_Confirm("update");

                $wmtg->generate_DBI_IUD_Confirm("delete");
                
                if ($arg->{dbi_txt2db_opt}) {
                    $wmtg->generate_DBI_IUD_Txt2DB("insert");
                    $wmtg->generate_DBI_IUD_Txt2DB("update");
                    $wmtg->generate_DBI_IUD_Txt2DB("delete");
                }

            } elsif ($arg->{dbi_handling_opt} == 3) {
                $wmtg->generate_DBI_Add_Form($key_field_list);
            }
            
        } elsif ($arg->{dbi_handling_opt} == 4) {
            $wmtg->generate_DBI_IU_Form("insert");
            $wmtg->generate_DBI_IUD_Confirm("insert");
            
            if ($arg->{dbi_txt2db_opt}) {
                $wmtg->generate_DBI_IUD_Txt2DB("insert");
            }
            
        } elsif ($arg->{dbi_handling_opt} == 5) {
            $wmtg->generate_DBI_Search_Form;
            
            ### template for single row search result
            ### commented since directly go to update page
            #$wmtg->generate_DBI_View;
            
            ### template for multi row search result
            ### provide selection of exact single item to update
            $wmtg->generate_DBI_View(undef, 1);            
            
            $wmtg->generate_DBI_IU_Form("update");
            $wmtg->generate_DBI_IUD_Confirm("update");
            
            if ($arg->{dbi_txt2db_opt}) {
                $wmtg->generate_DBI_IUD_Txt2DB("update");
            }
                
        } elsif ($arg->{dbi_handling_opt} == 6) {
            $wmtg->generate_DBI_Search_Form;
            
            ### template for single row search result
            ### commented since directly go to delete page
            #$wmtg->generate_DBI_View;
            
            ### template for multi row search result
            ### provide selection of exact single item to delete
            $wmtg->generate_DBI_View(undef, 1);            
            
            $wmtg->generate_DBI_IUD_Confirm("delete");
            
            if ($arg->{dbi_txt2db_opt}) {
                $wmtg->generate_DBI_IUD_Txt2DB("delete");
            }
            
        } elsif ($arg->{dbi_handling_opt} == 7) {
            $wmtg->generate_DBI_Search_Form;
            
            ### template for single row search result
            $wmtg->generate_DBI_View;
            
            ### template for multi row search result
            $wmtg->generate_DBI_View(undef, 1);
            
        } elsif ($arg->{dbi_handling_opt} == 8) {
            $wmtg->generate_DBI_Search_Form;
            
            ### template for single row search result
            $wmtg->generate_DBI_View;
            
            ### template for multi row search result
            $wmtg->generate_DBI_View(undef, 1);
            
            $wmtg->generate_DBI_IU_Form("update");
            $wmtg->generate_DBI_IUD_Confirm("update");
            
            $wmtg->generate_DBI_IUD_Confirm("delete");
        }
    }

    ###########################################################################

    my $wmlsrg = new Webman_LSR_Generator($init_ref, $dbu, $arg, $wmtg->{field_name_exclude});

    if ($arg->{dbi_handling_opt} != 9) {
        $wmlsrg->process_DBTS_Info;

        if ($wmlsrg->choose_Link_ID) {
            $wmlsrg->add_Link_Reference("content_main", "webman_component_selector");
            $wmlsrg->add_Dyna_Mod_Selector($arg->{dbi_handling_opt}, $arg->{dbi_txt2db_opt});

            $wmlsrg->set_Key_Ref_ID(-1, -1, undef); ### based on dyna_mod_selector_id since link reference 
                                                    ### is assigned with webman_component_selector 
            
            if ($arg->{dbi_handling_opt} < 4) {
                $wmlsrg->regenerate_Parent_DBIVD_Template($map_table_list_template);
                $wmlsrg->generate_DB_Item_List_Dynamic;
            }

            if ($arg->{dbi_handling_opt} == 2) {
                $wmlsrg->generate_DB_Item_Insert($key_field_insert);
                $wmlsrg->generate_DB_Item_Update($key_field_insert);
                $wmlsrg->generate_DB_Item_Delete;
                
                if ($arg->{dbi_txt2db_opt}) {
                    $wmlsrg->generate_DB_Item_Insert_Text2DB($key_field_entry);
                    $wmlsrg->generate_DB_Item_Update_Text2DB($key_field_entry);
                    $wmlsrg->generate_DB_Item_Delete_Text2DB($key_field_entry);
                }                
            }

            if ($arg->{dbi_handling_opt} == 3) {
                $wmlsrg->generate_DB_Item_Add;
                $wmlsrg->generate_DB_Item_Remove;
            }
            
            if ($arg->{dbi_handling_opt} == 4) {
                $wmlsrg->generate_DB_Item_Insert($key_field_insert);
                
                if ($arg->{dbi_txt2db_opt}) {
                    $wmlsrg->generate_DB_Item_Insert_Text2DB($key_field_insert);
                }
            }
            
            if ($arg->{dbi_handling_opt} > 4) {
                $wmlsrg->generate_DB_Item_Search($key_field_search);
            }
            
            if ($arg->{dbi_handling_opt} == 5) {
                $wmlsrg->generate_DB_Item_Update($key_field_search);
                
                if ($arg->{dbi_txt2db_opt}) {
                    $wmlsrg->generate_DB_Item_Update_Text2DB($key_field_entry);
                }
            }
            
            if ($arg->{dbi_handling_opt} == 6) {
                $wmlsrg->generate_DB_Item_Delete($key_field_search);
                
                if ($arg->{dbi_txt2db_opt}) {
                    $wmlsrg->generate_DB_Item_Delete_Text2DB($key_field_entry);
                }
            }
            
            if ($arg->{dbi_handling_opt} == 7) {
                ### $wmlsrg->generate_DB_Item_Search already cover 
                ### by if ($arg->{dbi_handling_opt} > 4) {...}
            }
            
            if ($arg->{dbi_handling_opt} == 8) {
                ### $wmlsrg->generate_DB_Item_Search already cover 
                ### by if ($arg->{dbi_handling_opt} > 4) {...}
                
                $wmlsrg->generate_DB_Item_Update($key_field_search);
                $wmlsrg->generate_DB_Item_Delete($key_field_search);
            }            
        } 
    }
}

###############################################################################

### detect foreign unique key from other table inside current one
sub get_Foreign_Unique_Key {
    my $current_table = shift @_;
    
    my $current_table_entity = $current_table;
       $current_table_entity =~ s/^$app_name//;
       $current_table_entity =~ s/^_//;
       
    #print "\$current_table_entity: $current_table_entity \n\n";
    
    my @linked_tables = @{$map_table_relations{$current_table}};
    
    ### pkfk stand for primary key & foreign key field type
    my %map_pkfk_table = (); 
    
    foreach my $table (@linked_tables) {
        $dbu->set_Table($table);
        my @ahr_field = $dbu->get_Table_Structure;
        
        print "Linked table - $table: \n";
        
        foreach my $field (@ahr_field) {
           print "$field->{field_name} ($field->{key})\n";
            
            if ($field->{key} eq "PRI" || $field->{key} eq "UNI") {
                $map_pkfk_table{$field->{field_name}} = {type => $field->{key}, table => $table};
                
            } elsif ($field->{field_name} =~ /^id_$current_table_entity/) {
                $map_pkfk_table{$field->{field_name}} = {type => "FK", table => $table};            
            }
            
             print "$map_pkfk_table{$field->{field_name}}->{type}\n";
        }
        
        my $stuck = <STDIN>;
        
        #print "\n\n";
    }
    
    ###########################################################################
    
    my @foreign_unique_keys = ();
    
    if ($dbi_handling_opt == 3) {
        my $parent_table = $map_table_parent->{$current_table};
        #print "Parent table - $parent_table: \n";
        
        $dbu->set_Table($parent_table);
        my @ahr_field = $dbu->get_Table_Structure;
        
        foreach my $field (@ahr_field) {
           #print "$field->{field_name} ($field->{key})\n";
            
            if ($field->{key} eq "PRI" || $field->{key} eq "UNI") {
                $map_pkfk_table{$field->{field_name}} = {type => $field->{key}, table => $parent_table};
                
            } elsif ($field->{field_name} =~ /^id_$current_table_entity/) {
                $map_pkfk_table{$field->{field_name}} = {type => "FK", table => $parent_table};            
            }
            
            if ($map_pkfk_table{$field->{field_name}} ne "") {
                push(@foreign_unique_keys, {field_name => $field->{field_name}, 
                                            field_type => $map_pkfk_table{$field->{field_name}}->{type},
                                            table_name => $map_pkfk_table{$field->{field_name}}->{table}, 
                                           });            
            }
        }
        
       #print "\n\n";        
    }
    
   #print "\%map_pkfk_table:\n";
    foreach my $key (keys(%map_pkfk_table)) {
       #print "$key - $map_pkfk_table{$key}->{type} -> $map_pkfk_table{$key}->{table}\n";
    }
    
   #print "\n\n";
    
    ###########################################################################
    
    $dbu->set_Table($current_table);
    my @ahr_field = $dbu->get_Table_Structure;
    
   #print "Current table - $current_table: \n";
    
    foreach my $field (@ahr_field) {
       #print "$field->{field_name} ($field->{key}) - ";
        
        ### detect any primary/unique keys from other tables 
        ### that have relationship with current table
        if ($map_pkfk_table{$field->{field_name}} ne "") {
           #print "$map_pkfk_table{$field->{field_name}}->{type} => $map_pkfk_table{$field->{field_name}}->{table}";
            
            push(@foreign_unique_keys, {field_name => $field->{field_name}, 
                                        field_type => $map_pkfk_table{$field->{field_name}}->{type},
                                        table_name => $map_pkfk_table{$field->{field_name}}->{table}, 
                                       });
        }
        
       #print "\n"
    }
    
    #my $stuck = <STDIN>;
    
    if (@foreign_unique_keys > 0) {
        return \@foreign_unique_keys;
        
    } else {
        return undef;
    }
}

sub get_Yes_No_Options {
    my $str_info = shift;
    
    my $choice = undef;
    
    ### text-based input ######################################################
    if ($codegen_input[0]->{current_idx} > 0) {
        print $str_info;
        print $codegen_input[$codegen_input[0]->{current_idx}] . "\n";
        
        $choice = $codegen_input[$codegen_input[0]->{current_idx}];
        $codegen_input[0]->{current_idx}++;
    }
    
    ### manual key-enter input ################################################
    while ($choice ne "y" && $choice ne "n") {
        print $str_info;

        $choice = <STDIN>;
        $choice =~ s/\n//;
        $choice =~ s/\r//;
    }
    
    push(@codegen_input_rec, "### $str_info");
    push(@codegen_input_rec, $choice);

    return $choice;
}

sub set_DB_Item_Handling_Options {
    my $choice = 0;
    
    ### text-based input ######################################################
    if ($codegen_input[0]->{current_idx} > 0) {
        print "Database item handling options: \n\n", 
              " 1. List only\n",
              " 2. List with full insert/update/delete support\n",
              " 3. List/add/remove from other existing list\n",
              " 4. Insert only\n",
              " 5. Update only\n",
              " 6. Delete only\n",
              " 7. Search only\n",
              " 8. Search with update/delete support\n",
              " 9. Skip task\n\n";

        print "Choose option [1 - 9]: ";
        
        print $codegen_input[$codegen_input[0]->{current_idx}] . "\n";
        
        $choice = $codegen_input[$codegen_input[0]->{current_idx}];
        $codegen_input[0]->{current_idx}++;
    }    
    
    ### manual key-enter input ################################################
    while ($choice < 1 || $choice > 9) {
        print "Database item handling options: \n\n", 
              " 1. List only\n",
              " 2. List with full insert/update/delete support\n",
              " 3. List/add/remove from other existing list\n",
              " 4. Insert only\n",
              " 5. Update only\n",
              " 6. Delete only\n",
              " 7. Search only\n",
              " 8. Search with update/delete support\n",
              " 9. Skip task\n\n";

        print "Choose option [1 - 9]: ";

        $choice = <STDIN>;
        $choice =~ s/\n//;
        $choice =~ s/\r//;
    }
            
    print "\n";
    push(@codegen_input_rec, "### Database item handling options:");
    push(@codegen_input_rec, $choice);
    
    return $choice;    
}

sub set_DB_Item_Multi_Row_Options {
    my $choice = 0;
    
    ### text-based input ######################################################
    if ($codegen_input[0]->{current_idx} > 0) {
        if ($dbi_handling_opt == 2) {
            print "Multi row database operation(s) support: \n\n", 
                  " 1. Insert only \n",
                  " 2. Update/delete \n",
                  " 3. All (insert/update/delete) \n",
                  " 4. Skip options\n\n";

            print "Choose option [1 - 4]: ";
            
        } elsif ($dbi_handling_opt == 4) {
            print "Multi row database item insert support [y/n]: ";
        }
        
        print $codegen_input[$codegen_input[0]->{current_idx}] . "\n";
        
        $choice = $codegen_input[$codegen_input[0]->{current_idx}];
        $codegen_input[0]->{current_idx}++;
    }    
    
    ### manual key-enter input ################################################
    if ($dbi_handling_opt == 2) {
        while ($choice < 1 || $choice > 4) {
            print "Multi row database operation(s) support: \n\n", 
                  " 1. Insert only \n",
                  " 2. Update/delete \n",
                  " 3. All (insert/update/delete) \n",
                  " 4. Skip options\n\n";

            print "Choose option [1 - 4]: ";

            $choice = <STDIN>;
            $choice =~ s/\n//;
            $choice =~ s/\r//;
        }
        
        push(@codegen_input_rec, "### Multi row database operation(s) support:");
        
    } elsif ($dbi_handling_opt == 4) {
        while ($choice ne "y" && $choice ne "n") {
            print "Multi row database item insert support [y/n]: ";
        
            $choice = <STDIN>;
            $choice =~ s/\n//;
            $choice =~ s/\r//;   
        }
        
        if ($choice eq "y") {
            $choice = 3;
            
        } else {
            $choice = 4;
        }
        
        push(@codegen_input_rec, "### Multi row database item insert support [y/n]:");
    }
            
    print "\n";
    
    push(@codegen_input_rec, $choice);
    
    return $choice;    
}

sub set_DB_Item_Txt2DB_Options {
    my $choice = 0;
    
    ### text-based input ######################################################
    if ($codegen_input[0]->{current_idx} > 0) {
        print "Provide text-based database input support? [y/n]: ";
        print $codegen_input[$codegen_input[0]->{current_idx}] . "\n";
        
        $choice = $codegen_input[$codegen_input[0]->{current_idx}];
        $codegen_input[0]->{current_idx}++;
    }    
    
    ### manual key-enter input ################################################
    while ($choice ne "y" && $choice ne "n") {
        print "Provide text-based database input support? [y/n]: ";

        $choice = <STDIN>;
        $choice =~ s/\n//;
        $choice =~ s/\r//;   
    }
    
    push(@codegen_input_rec, "### Provide text-based database input support? [y/n]:");
    push(@codegen_input_rec, $choice);

    if ($choice eq "y") {
        $choice = 1;

    } else {
        $choice = 0;
    }    
    
    print "\n";
    
    return $choice;    
}

sub get_Key_Field {
    my $table_name = shift @_;
    
    my $situation = shift @_;
    my $opr_type = shift @_;
    
    print $situation;
    print "Separate using single spaces if more than single key-fields are involved.\n\n";
    
    $dbu->set_Table($table_name);
    my @ahr = $dbu->get_Table_Structure;
    
    foreach my $item (@ahr) {
        if (!($item->{field_name} =~ /^id_/)) {
            print "-> $item->{field_name}\n";
        }     
    }

    print "\n";
    
    my $key_field = undef;
    
    ### text-based input ######################################################
    if ($codegen_input[0]->{current_idx} > 0) {        
        print "Unique key-field(s) for $opr_type: ";
        print $codegen_input[$codegen_input[0]->{current_idx}] . "\n";
        
        $key_field = $codegen_input[$codegen_input[0]->{current_idx}];
        $codegen_input[0]->{current_idx}++;
    }

    ### manual key-enter input ################################################ 
    while (!defined($key_field)) {
        print "Unique key-field(s) for $opr_type: ";
        
        $key_field = <STDIN>;
        $key_field =~ s/\n//;
        $key_field =~ s/\r//;

        while ($key_field =~ /  /) {
            $key_field =~ s/  / /;
        }

        $key_field =~ s/^ //;
        $key_field =~ s/ $//;

        my @key_fields = split(/ /, $key_field);

        foreach my $field (@key_fields) {
            if (!$dbu->field_Exist($field)) {
                print "Can't proceed since entry key-field '$field' is not exist!!!\n";
                $key_field = undef;
            }
        }

        print "\n";
    }

    print "\n";
    
    if ($situation ne "") {
        push(@codegen_input_rec, "### $situation");
    }
    
    push(@codegen_input_rec, "### Unique key-field(s) for $opr_type:");
    push(@codegen_input_rec, $key_field);
    
    return $key_field;
}

sub save_ACGen_Input {
    my $choice = undef;
    
    while ($choice ne "y" && $choice ne "n") {
        print "Save code generation input for later reuse? [y/n]: ";

        $choice = <STDIN>;
        $choice =~ s/\n//;
        $choice =~ s/\r//;
    }
    
    if ($choice eq "y") {
        if (open(MYFILE, ">app_rsc/$app_name/codegen_input/$codegen_key_name.txt")) {
            
            foreach my $item (@codegen_input_rec) {
                $item =~ s/\n//;
                
                if ($item =~ /^\#/) {
                    print MYFILE ($item . "\n");
                    
                } else {
                    print MYFILE ($item . "\n\n");
                }
            }
            
            close(MYFILE);
        }
    }    
}

sub use_ACGen_Input {
    my $app_table_name = shift @_;
    
    my $choice = undef;
    
    opendir(DIRHANDLE, "app_rsc/$app_name/codegen_input");

    my @files = readdir(DIRHANDLE);
    my @files_input = ();
    
    foreach my $file (@files) {
        if ($file =~ /\.txt$/) {
            push(@files_input, $file);
        }
    }
    
    my $file_input_total = @files_input;
    
    if ($file_input_total > 0 && grep(/^$app_table_name/, @files_input)) {
        while ($choice ne "y" && $choice ne "n") {
            print "Use previous code generation input? [y/n]: ";

            $choice = <STDIN>;
            $choice =~ s/\n//;
            $choice =~ s/\r//;
        }

        if ($choice eq "y") {
            print "\n";
            my $choice_no = 1;
            my $index = 0;
            my %map_choice_index = ();
            
            @files_input = sort(@files_input);
            
            foreach my $file (@files_input) {
                if ($file =~ /^$app_table_name/) {
                    print " $choice_no. $file\n";
                    
                    $map_choice_index{$choice_no} = $index;
                    $choice_no++;
                }
                
                $index++;
            }
            
            $choice_no--;
            
            print "\n";
            
            my $file_no = -1;
            
            while ($file_no < 1 || $file_no > $choice_no) {
                print "Choose file no. [1 - $choice_no]: ";

                $file_no = <STDIN>;
                $file_no =~ s/\n//;
                $file_no =~ s/\r//;
            }
               
            #print "<app_rsc/$app_name/codegen_input/$files_input[$map_choice_index{$file_no}]\n";
            #my $stuck = <STDIN>;
            
            if (open(MYFILE, "<app_rsc/$app_name/codegen_input/$files_input[$map_choice_index{$file_no}]")) {
                $codegen_input[0]->{current_idx} = 1;
                
                my @file_content = <MYFILE>;
                
                foreach my $line (@file_content) {
                    $line =~ s/\n//;
                    
                    while ($line =~ /^ /) {
                        $line =~ s/^ //;
                    }
                    
                    if ($line ne "" && !($line =~ /^\#/)) {
                        push(@codegen_input, $line);
                    }
                }
                
                close(MYFILE);
            }
        }
    }
}

###############################################################################
