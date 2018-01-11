use utf8;
package FaersDB::Result::Demo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FaersDB::Result::Demo

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

=head1 TABLE: C<demo>

=cut

__PACKAGE__->table("demo");

=head1 ACCESSORS

=head2 primaryid

  data_type: 'integer'
  is_nullable: 0

=head2 caseid

  data_type: 'integer'
  is_nullable: 1

=head2 caseversion

  data_type: 'integer'
  is_nullable: 1

=head2 i_f_code

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=head2 event_dt

  data_type: 'integer'
  is_nullable: 1

=head2 mfr_dt

  data_type: 'integer'
  is_nullable: 1

=head2 init_fda_dt

  data_type: 'integer'
  is_nullable: 1

=head2 fda_dt

  data_type: 'integer'
  is_nullable: 1

=head2 rept_cod

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 auth_num

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 mfr_num

  data_type: 'varchar'
  is_nullable: 1
  size: 128

=head2 mfr_sndr

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 lit_ref

  data_type: 'varchar'
  is_nullable: 1
  size: 512

=head2 age

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 age_cod

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 age_grp

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=head2 sex

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 e_sub

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=head2 wt

  data_type: 'varchar'
  is_nullable: 1
  size: 8

=head2 wt_cod

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 rept_dt

  data_type: 'integer'
  is_nullable: 1

=head2 to_mfr

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=head2 occp_cod

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=head2 reporter_country

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 occr_country

  data_type: 'varchar'
  is_nullable: 1
  size: 4

=cut

__PACKAGE__->add_columns(
  "primaryid",
  { data_type => "integer", is_nullable => 0 },
  "caseid",
  { data_type => "integer", is_nullable => 1 },
  "caseversion",
  { data_type => "integer", is_nullable => 1 },
  "i_f_code",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "event_dt",
  { data_type => "integer", is_nullable => 1 },
  "mfr_dt",
  { data_type => "integer", is_nullable => 1 },
  "init_fda_dt",
  { data_type => "integer", is_nullable => 1 },
  "fda_dt",
  { data_type => "integer", is_nullable => 1 },
  "rept_cod",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "auth_num",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "mfr_num",
  { data_type => "varchar", is_nullable => 1, size => 128 },
  "mfr_sndr",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "lit_ref",
  { data_type => "varchar", is_nullable => 1, size => 512 },
  "age",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "age_cod",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "age_grp",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "sex",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "e_sub",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "wt",
  { data_type => "varchar", is_nullable => 1, size => 8 },
  "wt_cod",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "rept_dt",
  { data_type => "integer", is_nullable => 1 },
  "to_mfr",
  { data_type => "varchar", is_nullable => 1, size => 2 },
  "occp_cod",
  { data_type => "varchar", is_nullable => 1, size => 4 },
  "reporter_country",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "occr_country",
  { data_type => "varchar", is_nullable => 1, size => 4 },
);

=head1 PRIMARY KEY

=over 4

=item * L</primaryid>

=back

=cut

__PACKAGE__->set_primary_key("primaryid");

=head1 RELATIONS

=head2 drugs

Type: has_many

Related object: L<FaersDB::Result::Drug>

=cut

__PACKAGE__->has_many(
  "drugs",
  "FaersDB::Result::Drug",
  { "foreign.primaryid" => "self.primaryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 outcs

Type: has_many

Related object: L<FaersDB::Result::Outc>

=cut

__PACKAGE__->has_many(
  "outcs",
  "FaersDB::Result::Outc",
  { "foreign.primaryid" => "self.primaryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reacs

Type: has_many

Related object: L<FaersDB::Result::Reac>

=cut

__PACKAGE__->has_many(
  "reacs",
  "FaersDB::Result::Reac",
  { "foreign.primaryid" => "self.primaryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 rpsrs

Type: has_many

Related object: L<FaersDB::Result::Rpsr>

=cut

__PACKAGE__->has_many(
  "rpsrs",
  "FaersDB::Result::Rpsr",
  { "foreign.primaryid" => "self.primaryid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07047 @ 2018-01-10 16:00:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3OLLPLmm7/ZtEPFp38netQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
