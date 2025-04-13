#! /usr/bin/perl

my @scripts = ("deploy_cgi.pl web.fsksm.utm.my webapps webApps2008 fsksmELearning y",
               "deploy_mod_app.pl web.fsksm.utm.my webapps webApps2008 fsksmELearning y", 
               "deploy_template.pl web.fsksm.utm.my webapps webApps2008 fsksmELearning y",
               "deploy_mod_core.pl web.fsksm.utm.my webapps webApps2008 fsksmELearning y");

foreach my $script (@scripts) {
    my $result = `$script`;

    print $result;
    &enter_to_continue;
}

sub enter_to_continue {
    print "Press enter to continue. ";
    my $stuck = <STDIN>;
}




