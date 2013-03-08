package Pr::Reporter::Demo;
use Mojo::Base 'Pr::Reporter';

=head1 NAME

Pr::Reporter::Demo - Demo Reporter

=head1 SYNOPSIS

 use Pr::Reporter::Demo;

=head1 DESCRIPTION

The Demo Reporter.

=cut


=head1 METHODS

All the methods of L<Mojo::Base> plus:

=cut

=head2 getFormCfg

Returns a Configuration Structure for the Report Frontend Module.

=cut

sub getFormCfg {
    my $self = shift;
    return [
        {
            key => 'name',
            label => 'Name',
            widget => 'text'            
        },
        {
            key => 'flavor',
            label => 'Pick your Flavour',
            widget => 'selectBox',
            cfg => {
                structure => [
                    { key => 'blau', title=> 'Blaue Dragoner' },
                    { key => 'red',  title=> 'Roter Drache' },
                ]
            }
        },
        {
            key => 'date',
            label => 'Datum',
            widget => 'date',
        },
    ];
}


=head2 getSubmitCfg

see L<Pr::Reporter> for details.
   
=cut

sub getSubmitCfg {
    my $self = shift;
    return [
        { label => 'View Report',
          action => 'view',
          extraParams => {
             ex1 => 'Hello',
             ex2 => 'World',
          }
        },
        { label => 'Download Report',
          action => 'download',
          extraParams => {
             p2 => 'Hollow',
             d33 => 'Man',
          }
        }
     ];
}


=head2 downloadReport

Downloadable version of the report.

=cut

sub downloadReport {
    my $self = shift;
    my $ctrl = $self->controller;
    $ctrl->render(text=>'Hello World');
}


=head2 getReport($cfgHash)

Creates the Report Contents and returns it. The method takes a parameter
hash as configured by getConfig

=cut

sub getReport {
    my $self = shift;
    my $cfgHash = shift;
    return { test => 'Hello' };
}

=head2 getGrammar

Returns the config parser for the configuration of this reporter.

=cut

sub getGrammar {
    my $self = shift;
    my $grammar = $self->SUPER::getGrammar(@_);
    push @{$grammar->{_vars}}, 'header_pl';
    push @{$grammar->{_mandatory}}, 'header_pl';
    $grammar->{header_pl} = {
        _doc => 'demo header line in perl syntax',
        _sub => $self->getVarCompiler,
    };
    return $grammar;
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

Copyright (c) 2011 by OETIKER+PARTNER AG. All rights reserved.

=head1 AUTHOR

S<Tobias Oetiker E<lt>tobi@oetiker.chE<gt>>

=head1 HISTORY

 2011-04-20 to 1.0 first version

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

