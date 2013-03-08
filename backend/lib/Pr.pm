package Pr;

=head1 NAME

Pr - PearlReporter

=head1 SYNOPSIS

 use Pr;
 use Mojolicious::Commands;

 Mojolicious::Commands->start_app('Pr');

=head1 DESCRIPTION

Configure the mojo engine to run our application logic as webrequests arrive.

=head1 ATTRIBUTES

=cut

use strict;
use warnings;

# load the two modules to have perl check them
use Mojolicious::Plugin::QooxdooJsonrpc;
use Mojo::URL;
use Mojo::Util qw(hmac_sha1_sum slurp);

use Pr::RpcService;
use Pr::Config;
use Pr::Reporter;
use Pr::DocPlugin;

use Mojo::Base 'Mojolicious';

=head2 config

A hash pointer to the configuration object. See L<Pr::Config> for details.
The default configuration file is located in etc/bwtr.cfg. You can override the
path by setting the C<{PR_CONF> environment variable.

The config property is set automatically on startup.

=cut

has 'config' => sub {
    my $self = shift;
    my $conf = Pr::Config->new( 
        app => $self,
        file => $ENV{PR_CONF} || $self->home->rel_file('etc/pr.cfg' )
    );
};

=head1 METHODS

All  the methods of L<Mojolicious> as well as:

=cut

=head2 startup

Mojolicious calls the startup method at initialization time.

=cut

sub startup {
    my $self = shift;
    my $me = $self;

    # fix woff type
    $self->types->types->{woff} = 'application/x-font-woff';

    my $gcfg = $self->config->cfgHash->{GENERAL};
    $self->secret($gcfg->{mojo_secret});
    if ($self->mode ne 'development'){
        $self->log->path($gcfg->{log_file});
        if ($gcfg->{log_level}){    
            $self->log->level($gcfg->{log_level});
        }
    }

    # properly figure your own path when running under fastcgi    
    $self->hook( before_dispatch => sub {
        my $self = shift;
        my $reqEnv = $self->req->env;
        my $uri = $reqEnv->{SCRIPT_URI} || $reqEnv->{REQUEST_URI};
        my $path_info = $reqEnv->{PATH_INFO};
        $uri =~ s|/?${path_info}$|/| if $path_info and $uri;
        $self->req->url->base(Mojo::URL->new($uri)) if $uri;
    });

    # session is valid for 1 day
    $self->sessions->default_expiration(1*24*3600);

    # prevent our cookie from colliding. Pick a separate cookie
    # for each config file
    $self->sessions->cookie_name('BWTR_'.hmac_sha1_sum($self->config->file));

    my $routes = $self->routes;

   $self->plugin('Pr::DocPlugin', {
        root => '/doc',
        index => 'Pr::Index',
        localguide => $gcfg->{localguide},
        template => Mojo::Asset::File->new(
            path=>$self->home->rel_file('templates/doc.html.ep')
        )->slurp,
    }); 

    
    my $service = Pr::RpcService->new();
    $self->plugin('qooxdoo_jsonrpc',{
        services => {
            pr => $service
        }
    }); 

    return 0;
}

1;

__END__

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=head1 COPYRIGHT

Copyright (c) 2013 by OETIKER+PARTNER AG. All rights reserved.

=head1 AUTHOR

S<Tobias Oetiker E<lt>tobi@oetiker.chE<gt>>

=head1 HISTORY

 2013-03-06 to 1.0 first version

=cut

# Emacs Configuration
#
# Local Variables:
# mode: cperl
# eval: (cperl-set-style "PerlStyle")
# mode: flyspell
# mode: flyspell-prog
# End:
#
# vi: sw=4 et
