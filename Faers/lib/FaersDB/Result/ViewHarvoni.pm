use utf8;
package FaersDB::Result::ViewHarvoni;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FaersDB::Result::ViewHarvoni - VIEW

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
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<view_harvoni>

=cut

__PACKAGE__->table("view_harvoni");
__PACKAGE__->result_source_instance->view_definition("select `fears`.`drug`.`id` AS `id`,`fears`.`drug`.`primaryid` AS `primaryid`,`fears`.`drug`.`caseid` AS `caseid`,`fears`.`drug`.`drug_seq` AS `drug_seq`,`fears`.`drug`.`role_cod` AS `role_cod`,`fears`.`drug`.`drugname` AS `drugname`,`fears`.`drug`.`prod_ai` AS `prod_ai`,`fears`.`drug`.`val_vbm` AS `val_vbm`,`fears`.`drug`.`route` AS `route`,`fears`.`drug`.`dose_vbm` AS `dose_vbm`,`fears`.`drug`.`cum_dose_chr` AS `cum_dose_chr`,`fears`.`drug`.`cum_dose_unit` AS `cum_dose_unit`,`fears`.`drug`.`dechal` AS `dechal`,`fears`.`drug`.`rechal` AS `rechal`,`fears`.`drug`.`lot_num` AS `lot_num`,`fears`.`drug`.`exp_dt` AS `exp_dt`,`fears`.`drug`.`nda_num` AS `nda_num`,`fears`.`drug`.`dose_amt` AS `dose_amt`,`fears`.`drug`.`dose_unit` AS `dose_unit`,`fears`.`drug`.`dose_form` AS `dose_form`,`fears`.`drug`.`dose_freq` AS `dose_freq` from `fears`.`drug` where (`fears`.`drug`.`drugname` like 'harv%') limit 10");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 primaryid

  data_type: 'integer'
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
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "primaryid",
  { data_type => "integer", is_nullable => 0 },
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


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-01-11 15:23:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JeoxoQzeA9wj3biULIyV1w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
