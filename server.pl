# server.pl
use strict;
use warnings;
use Plack::Builder;
use Plack::App::File;
use Plack::App::CGIBin;

my $app = builder {
    # Serve static files (HTML, CSS, JS) from public_html
    mount "/" => Plack::App::File->new(root => "./public_html")->to_app;

    # Serve CGI scripts from cgi-bin
   mount "/cgi-bin" => Plack::App::CGIBin->new(root => "./public_html/cgi-bin");
};

$app;
