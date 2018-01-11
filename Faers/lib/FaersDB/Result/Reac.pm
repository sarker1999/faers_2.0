use utf8;
package FaersDB::Result::Reac;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FaersDB::Result::Reac

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

=head1 TABLE: C<reac>

=cut

__PACKAGE__->table("reac");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 primaryid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 caseid

  data_type: 'integer'
  is_nullable: 1

=head2 pt

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 drug_rec_act

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "primaryid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "caseid",
  { data_type => "integer", is_nullable => 1 },
  "pt",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "drug_rec_act",
  { data_type => "varchar", is_nullable => 1, size => 64 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 primaryid

Type: belongs_to

Related object: L<FaersDB::Result::Demo>

=cut

__PACKAGE__->belongs_to(
  "primaryid",
  "FaersDB::Result::Demo",
  { primaryid => "primaryid" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-01-10 16:00:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:50O093GppYTlaWqxymyNZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
