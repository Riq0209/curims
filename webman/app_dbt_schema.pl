#! /usr/bin/perl

unshift (@INC, "./pm/cli_tool/");
unshift (@INC, "./pm/core");

use DBI;
#use File::Path qw(make_path);

require DB_Utilities;

require Webman_Config_Tools;

my $app_name = $ARGV[0];
my $db_host = $ARGV[1];
my $db_name = $ARGV[2];
my $db_user_name = $ARGV[3];
my $db_password = $ARGV[4];
my $dbt_prefix_opt = $ARGV[5];

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

print "\n\n--- Generate Webman Application Domain DB Table Schema Configuration ---\n\n";

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
    print "Can't proceed since the application '$app_name' is not exist!!!\n";
    exit 1;
}

print "\n";

print "\n\n Database Information:\n\n";

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

print "     DB HOST: ";
if ($db_host eq "") {
    $db_host = <STDIN>;
    $db_host =~ s/\n//;
    $db_host =~ s/\r//;
    
} else {
    print "$db_host\n";
}


print "     DB Name: ";
if ($db_name eq "") {
    $db_name = <STDIN>;
    $db_name =~ s/\n//;
    $db_name =~ s/\r//;
    
} else {
    print "$db_name\n";
}

print "DB User Name: ";
if ($db_user_name eq "") {
    $db_user_name = <STDIN>;
    $db_user_name =~ s/\n//;
    $db_user_name =~ s/\r//;
    
} else {
    print "$db_user_name\n";
}

print " DB Password: ";
if ($db_password eq "") {
    $db_password = <STDIN>;
    $db_password =~ s/\n//;
    $db_password =~ s/\r//;
    
} else {
    print "$db_password\n";
}

print "\n";

my $dbt_prefix_name = $app_name . "_";

print "Default prefix table name is '$dbt_prefix_name' \n\n";

if ($dbt_prefix_opt eq "n") {
    ### Do nothing. 
    
} else {
    print "Change default prefix table name [y/n]: ";
    my $option = <STDIN>;
       $option =~ s/\n//;
   
    if ($option eq "y") {
        print "\nEnter new prefix table name: ";
        $dbt_prefix_name = <STDIN>;
        $dbt_prefix_name =~ s/\n//;
    }
}

my $dbu = new DB_Utilities;
my $db_conn = $dbu->make_DBI_Conn("./conf/dbi_connection.conf");

$dbu->set_DBI_Conn($db_conn);

my @tbl = $dbu->get_Table_List;
my @tbl_idkey = ();

print "\n\n--- Start process database tables structure... ---\n\n";

my @entity_super = ();
my @entity_mediator = ();
my @entity_sub = ();

if ($dbt_prefix_name ne "") {
    foreach $item (@tbl) {
        if ($item =~ /^$dbt_prefix_name/) {
            my $table_name = $item;
               $table_name =~ s/\n//;
               
            $dbu->set_Table($table_name);

            my $all_field_count = 0;
            my $primary_key = undef;
            my $key_fields = [];
            my @ahr_field = $dbu->get_Table_Structure;  
            
            foreach my $field (@ahr_field) {
                if ($field->{key} eq "PRI" && $primary_key eq "" ) {
                    $primary_key = $field->{field_name};
                }
                
                if ($field->{field_name} =~ /^id_/) {
                    push(@{$key_fields}, "$field->{field_name}");
                }
                
                $all_field_count++;
            }
            
            print "$item [@{$key_fields}]";
            
            my $key_field_count = @{$key_fields};
            
            if ($key_field_count == 1) {
                print " - entity_super\n";
                push(@entity_super, {table_name => $table_name, primary_key => $primary_key, key_fields => $key_fields});
                
            } elsif ($key_field_count == $all_field_count) {
                print " - entity_mediator\n";
                push(@entity_mediator, {table_name => $table_name, primary_key => $primary_key, key_fields => $key_fields});
                
            } else {
                print " - entity_sub\n";
                push(@entity_sub, {table_name => $table_name, primary_key => $primary_key, key_fields => $key_fields});
            }
        }
    }
}

my @entities = ({type => "super", array_ref => \@entity_super},  
                {type => "sub", array_ref => \@entity_sub}, 
                {type => "mediator", array_ref => \@entity_mediator},);

print "\n\n--- Extract database tables types and relationships... ---\n\n";

my $file_content = "";

foreach my $entity (@entities) {
    foreach $hash_ref (@{$entity->{array_ref}}) {
        #print "$entity->{type}-$hash_ref->{table_name}:\n";
                
        foreach my $super (@entity_super) {
            foreach my $kf (@{$super->{key_fields}}) {
                if ($hash_ref->{primary_key} eq $kf && $hash_ref->{table_name} ne $super->{table_name}) {
                    $file_content .= "$entity->{type}-$hash_ref->{table_name}-$hash_ref->{primary_key} > $hash_ref->{primary_key} > super-$super->{table_name}-$super->{primary_key}\n";
                }
            }
        }

        foreach my $sub (@entity_sub) {
            #print "Sub table name: $sub->{table_name} -> $hash_ref->{table_name}\n";
            
            foreach my $kf (@{$sub->{key_fields}}) {
                #print "$hash_ref->{primary_key}\n";
                #print "$kf\n";
                
                
                if ($hash_ref->{primary_key} eq $kf && $hash_ref->{table_name} ne $sub->{table_name}) {
                    #print "Match...\n";
                    $file_content .= "$entity->{type}-$hash_ref->{table_name}-$hash_ref->{primary_key} > $hash_ref->{primary_key} > sub-$sub->{table_name}-$sub->{primary_key}\n";
                }
                
                #my $stuck = <STDIN>;
            }
        }
        
        foreach my $mediator (@entity_mediator) {
            foreach my $kf (@{$mediator->{key_fields}}) {
                if ($hash_ref->{primary_key} eq $kf && $hash_ref->{table_name} ne $mediator->{table_name}) {
                    $file_content .= "$entity->{type}-$hash_ref->{table_name}-$hash_ref->{primary_key} > $hash_ref->{primary_key} > mediator-$mediator->{table_name}-$mediator->{primary_key}\n";
                }
            }
        }        
        
        #print "\n";
    }
}

print $file_content;

if (open(MYFILE, ">./conf/dbt_schema_" . $app_name . ".conf")) {
    print MYFILE ($file_content);
    close(MYFILE);
}
