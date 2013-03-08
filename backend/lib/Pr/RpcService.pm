package Pr::RpcService;
use strict;
use warnings;

use Pr::Exception qw(mkerror);

use Mojo::Base -base;

=head1 NAME

Pr::RpcService - RPC services for BWTool Reporter

=head1 SYNOPSIS

This reporter gets instantiated by L<Pr> and provides backend functionality for the BWTool Reporter.

=head1 DESCRIPTION

the reporter provides the following methods

=cut

=head2 allow_rpc_access(method)

is this method accessible?

=cut

our %allow = (
    getConfig => 1,
    getReport => 1,
);

has 'controller';

sub allow_rpc_access {
    my $self = shift;
    my $method = shift;
#    my $user = $self->controller->session('bwtrUser');
#    die mkerror(3993,q{Your session has expired. Please re-connect.}) unless defined $user;
    return $allow{$method}; 
}
   

=head2 getConfig()

get some gloabal configuration information into the interface

=cut

sub getConfig {
    my $self = shift;
    my $cfgHash = $self->controller->app->config->cfgHash;    
    # this should be processed prior to returning it
    my @reports;
    for my $id (@{$cfgHash->{REPORT}{list}}){
        my $obj = $cfgHash->{REPORT}{object}{$id};
        $obj->controller($self->controller);
        next unless $obj->checkAccess();
        push @reports, {
            name => $obj->name,
            id => $obj->id,
            formCfg => $obj->getFormCfg,
            submitCfg => $obj->getSubmitCfg     
        }
    }
    return {
        reports => \@reports,
        config => $cfgHash->{FRONTEND},
    };
}

=head2 getReport(id,properties)

Create the desired report.

=cut  

sub getReport { ## no critic (RequireArgUnpacking)
    my $self = shift;    
    my $id = shift;
    my $args = shift;
    my $cfgHash = $self->controller->app->config->cfgHash;    
    my $obj = $cfgHash->{REPORT}{object}{$id};
    die mkerror(3848,qq{Report '$id' does not exist}) unless ref $obj;
    $obj->controller($self->controller);
    die mkerror(4628,qq{Access to Report '$id' denied}) unless $obj->checkAccess();
    return $obj->getReport($args);
}

1;
__END__

=head1 COPYRIGHT

Copyright (c) 2011 by OETIKER+PARTNER AG. All rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=head1 AUTHOR

S<Tobias Oetiker E<lt>tobi@oetiker.chE<gt>>

=head1 HISTORY 

 2011-01-25 to Initial

=cut
  
1;

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
