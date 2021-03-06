use utf8;
package FaersDB::Result::Drug;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FaersDB::Result::Drug

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

=head1 TABLE: C<drug>

=cut

__PACKAGE__->table("drug");

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

=head2 drug_seq

  data_type: 'integer'
  is_nullable: 1

=head2 role_cod

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 drugname

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 prod_ai

  data_type: 'varchar'
  is_nullable: 1
  size: 512

=head2 val_vbm

  data_type: 'integer'
  is_nullable: 1

=head2 route

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 dose_vbm

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 cum_dose_chr

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 cum_dose_unit

  data_type: 'varchar'
  is_nullable: 1
  size: 8

=head2 dechal

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=head2 rechal

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=head2 lot_num

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 exp_dt

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 nda_num

  data_type: 'integer'
  is_nullable: 1

=head2 dose_amt

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 dose_unit

  data_type: 'varchar'
  is_nullable: 1
  size: 8

=head2 dose_form

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 dose_freq

  data_type: 'varchar'
  is_nullable: 1
  size: 16

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
  "drug_seq",
  { data_type => "integer", is_nullable => 1 },
  "role_cod",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "drugname",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "prod_ai",
  { data_type => "varchar", is_nullable => 1, size => 512 },
  "val_vbm",
  { data_type => "integer", is_nullable => 1 },
  "route",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "dose_vbm",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "cum_dose_chr",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "cum_dose_unit",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "dechal",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "rechal",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "lot_num",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "exp_dt",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "nda_num",
  { data_type => "integer", is_nullable => 1 },
  "dose_amt",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "dose_unit",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "dose_form",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "dose_freq",
  { data_type => "varchar", is_nullable => 1, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 indis

Type: has_many

Related object: L<FaersDB::Result::Indi>

=cut

__PACKAGE__->has_many(
  "indis",
  "FaersDB::Result::Indi",
  { "foreign.primaryid" => "self.primaryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 thers

Type: has_many

Related object: L<FaersDB::Result::Ther>

=cut

__PACKAGE__->has_many(
  "thers",
  "FaersDB::Result::Ther",
  { "foreign.primaryid" => "self.primaryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-01-10 16:00:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:r/j/yaLo3jD3HNYiz3dWDg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
