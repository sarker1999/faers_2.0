package Faers::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.html',
    render_die => 1,
);

=head1 NAME

Faers::View::TT - TT View for Faers

=head1 DESCRIPTION

TT View for Faers.

=head1 SEE ALSO

L<Faers>

=head1 AUTHOR

Programmer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
