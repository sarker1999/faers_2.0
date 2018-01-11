use utf8;
package FaersDB::Result::GraphData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FaersDB::Result::GraphData

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<graph_data>

=cut

__PACKAGE__->table("graph_data");

=head1 ACCESSORS

=head2 drugname

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 pt

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 drugname_pt

  data_type: 'varchar'
  is_nullable: 1
  size: 384

=head2 count_pt

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 fda_dt

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "drugname",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "pt",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "drugname_pt",
  { data_type => "varchar", is_nullable => 1, size => 384 },
  "count_pt",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "fda_dt",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-01-11 15:23:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1cwxYtrgUxQqUQDzY+M+oA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
