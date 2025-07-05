#! #!/usr/bin/perl

print("Content-Type: text/plain\n\n");

foreach $var (sort(keys(%ENV))) {

    $val = $ENV{$var};
    $val =~ s|\n|\\n|g;
    $val =~ s|"|\\"|g;
    print "${var}=\"${val}\"\n";

}