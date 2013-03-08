package Pr::Reporter;
use strict;
use warnings;
use Carp qw(carp croak);

=head1 NAME

Pr::Reporter - Reporter base class

=head1 SYNOPSIS

 use Pr::Reporter;

=head1 DESCRIPTION

The base class for reporter reporters.

=cut

use Mojo::Base -base;

=head1 ATTRIBUTES

=head2 app

The application object. This is provided separately from the
controller link so that it is available even when no request is being processed.

=cut

has 'app';

=head2 controller

The current controller object. Make sure to set this appropriately before
using methods other than getGrammar;

=cut

has 'controller';

=head2 config

The REPORT instance specific config section from the master config file.

=cut

has 'config';

=head2 name

The REPORT instance 'name' as specified in the C<*** REPORT .... ***> section.

=cut

has 'name';

=head2 id

The report instance id, used to access any download function of the report via the /report/$self->id
route.

=cut

has 'id';

=head1 METHODS

All the methods of L<Mojo::Base> plus:

=cut

=head2 getFormCfg

Returns a Configuration Structure for the Report Form. The output from this method is fed
to the bwtr.ui.AutoForm object to build a form for configuring the report.

=cut

sub getFormCfg {
    my $self = shift;
    croak "the getFormCfg method must be implemented by the child class";
}

=head2 getSubmitCfg

At the bottom of the report configuration form, a set of buttons appears letting you view, download, email the repport
according to the reports specifications. By default a view button will be displayed.

The submit config is an array pointer to submit button configurations.

 { label => 'View Report',
   action => 'view|download',
   extraParams => {
         ex1 => 'Hellow',
         ex2 => 'World',
   }
 }

The extraParams get merged with the cfgHash prior to the callback. If the
action is 'view' the report will be pulled via jsonrpc call to getReport. If
the action is 'download' the cfgHash gets posted via REST to the
downloadReport method.
   
=cut

sub getSubmitCfg {
    my $self = shift;
    return [
        { label => 'View Report',
          action => 'view|download',
          extraParams => {
             ex1 => 'Hellow',
             ex2 => 'World',
          }
        }
     ];
}


=head2 downloadReport;

Prepare a fully formatted downloadeable report. As you would in a standard
L<Mojolicious> controller. Note that the controller is a property of the
object and not the object itself.

=cut

sub downloadReport {
    my $self = shift;
    my $controller = $self->controller;
}

=head2 getReport($cfgHash)

Creates the Report Contents and returns it as a jsonrpc response. The method takes a parameter
hash as configured by getConfig

=cut

sub getReport {
    my $self = shift;
    my $cfgHash = shift;
    croak "the getReport method must be implemented by the child class";
}

=head2 checkAccess()

Check if the current user may access the Report. Override in the Child class
to limit accessibility.

=cut

sub checkAccess {
    my $self = shift;
    return 1;
}

=head2 getGrammar

Returns the L<Config::Grammar> parser for the configuration of this reporter.

=cut

sub getGrammar {
    my $self = shift;
    my $grammar = {
        _doc => 'Base Class Documentation String. Should be overwritten by the child class',
        _vars => [qw(title)],
        _mandatory => [qw(title)],
        title => {
            _doc => 'Title of the Report for the Tree'
        },
    };
    return $grammar;
}

=head2 getVarCompiler ($variabeName || 'D')

returns a compiler sub reference for use in configuration variables or _text
sections with perl syntax. The resulting sub will  provide access to the
a hash called $variableName.

=cut

sub getVarCompiler {
    my $self = shift;
    my $variableName = shift || 'D';
    return sub { 
        my $code = $_[0] || '';
        # check and modify content in place
        my $perl = 'sub { my %{'.$variableName.'} = (%{$_[0]}); '.$code.'}';
        my $sub = eval $perl; ## no critic (ProhibitStringyEval)
        if ($@){
            return "Failed to compile $code: $@ ";
        }        
        eval { $sub->({}) };
        if ($@){
            return "Failed to run $code: $@ ";
        }        
        $_[0] = $sub;
        return;
    };
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

