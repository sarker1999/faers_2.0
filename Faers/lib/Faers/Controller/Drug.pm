package Faers::Controller::Drug;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use JSON;
use Text::CSV;

=head1 NAME

Faers::Controller::Drug - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {

    my ( $self, $c ) = @_;
    $c->stash->{template} = 'drug/drug_data.html';
}

=head2 graph

=cut

sub graph : Local {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;

    my $drugname  = $params->{dname} || '';
    my $date_from = $params->{df}    || 20140101;
    my $date_to   = $params->{dt}    || 20171231;
    my $compare_drugname = $params->{compare_dname};
    my $compare_dname_2  = $params->{compare_dname_2};

    my ( $pts,         $count_pts )         = generate_graph( $drugname,         $date_from, $date_to );
    my ( $pts_compare, $count_pts_compare ) = generate_graph( $compare_drugname, $date_from, $date_to );
    my ( $pts2,        $count_pts2 )        = generate_graph( $compare_dname_2,  $date_from, $date_to );

    my @pts               = @$pts;
    my @count_pts         = @$count_pts;
    my @pts_compare       = @$pts_compare;
    my @count_pts_compare = @$count_pts_compare;
    my @pts2              = @$pts2;
    my @count_pts2        = @$count_pts2;

    $c->stash->{pts}                = objToJson( \@pts );
    $c->stash->{count_pts}          = objToJson( \@count_pts );
    $c->stash->{drugname}           = $drugname;
    $c->stash->{compare_drugname}   = $compare_drugname;
    $c->stash->{pts_compare}        = objToJson( \@pts_compare );
    $c->stash->{count_pts_compare}  = objToJson( \@count_pts_compare );
    $c->stash->{compare_drugname_2} = $compare_dname_2;
    $c->stash->{pts2}               = objToJson( \@pts2 );
    $c->stash->{count_pts2}         = objToJson( \@count_pts2 );
    $c->stash->{template}           = 'drug/compare_graph.html';

}

=head3 generate_graph

=cut

sub generate_graph {

    my ( $drugname, $date_from, $date_to ) = @_;

    my $pts_rs = Faers->model('FaersDB::GraphData')->search_rs(
        {
            drugname_pt => { like => "$drugname-%" },
            fda_dt => { -between => [ $date_from, $date_to ] },
        },
        {
            columns  => [ 'pt',          { count_pt => \'count(*)' } ],
            group_by => [ 'drugname_pt', 'pt' ],
            order_by => { -desc          => 'count(*)' },
            rows     => 15,
        }
    );

    my ( @pts, @count_pts );
    while ( my $pt_rs = $pts_rs->next ) {
        push @pts,       $pt_rs->pt;
        push @count_pts, $pt_rs->count_pt;
    }
    return ( \@pts, \@count_pts );
}

=head2 show_screen
Args: nothing
Return: nothing
Displays the generated query result on screen
=cut

sub show_screen : Local {
    my ( $self, $c ) = @_;

    my @display_results = generate_query_result( $c->request->params );

    $c->stash->{display_results} = \@display_results;
    $c->stash->{template}        = 'drug/drug_data.html';
}

sub download : Local : Args {
    my ( $self, $c, $type ) = @_;

    my @display_results = generate_query_result( $c->request->params );

    my $sep_char  = ',';
    my $extension = 'csv';
    if ( defined $type && $type eq 'tsv' ) {
        $sep_char  = "\t";
        $extension = 'tsv';
    }
    my $csv = Text::CSV->new( { sep_char => $sep_char } );
    my $csv_string = '';
    for my $display_result (@display_results) {
        $csv->combine(
            $display_result->drugname, $display_result->val_vbm,  $display_result->pt,
            $display_result->outc_cod, $display_result->rpsr_cod, $display_result->indi_pt,
            $display_result->fda_dt,   $display_result->age,      $display_result->age_cod,
            $display_result->wt,       $display_result->wt_cod
        );
        $csv_string .= $csv->string . "\n";
    }

    $c->response->content_type("text/$extension");
    $c->response->header( 'Content-Disposition' => "attachment; filename=drug_data.$extension" );
    $c->response->body($csv_string);
}

=head3 generate_query_result
Args: $result
Return: $result
Returns the passed has after populating it with query result
=cut

sub generate_query_result {
    my $params = shift;

    my $drugname    = $params->{'dname'} || '';
    my $code_num    = $params->{'cname'} || 1;
    my $side_effect = $params->{'pt'}    || '';
    my $outcome     = $params->{'out'}   || '';
    my $source      = $params->{'rps'}   || '';
    my $indication  = $params->{'ind'}   || '';
    my $date_from   = $params->{df}      || 20140101;
    my $date_to     = $params->{dt}      || 20171231;
    my $limit       = $params->{'lim'}   || 1;

    my $valid = validate( $drugname, $side_effect, $indication );
    if ($valid) {

        my $view_search_results_rs = Faers->model('FaersDB::ViewSearchResult')->search_rs(
            {},
            {
                bind => [
                    "$drugname%", $code_num, "$side_effect%", $outcome, "$source%", "$indication%",
                    $date_from,   $date_to,  $limit
                ],
            }
        );

        my @search_results;
        while ( my $search_result = $view_search_results_rs->next ) {
            push @search_results, $search_result;
        }

        return @search_results;
    }
}

=head2 print_header
Args: $mime (optional)
: $filename (optional)
Return: nothing
prints the appropriate header according to the passed parameters
=cut

=cut
sub print_header {
    my ( $mime, $filename ) = @_;
    print $q->header()                                                if not defined $mime;
    print qq!Content-Type: $mime\n!                                   if $mime;
    print qq!Content-Disposition: attachment; filename="$filename"\n! if $filename;
    print qq!\n!;
}
=cut

=head3 suggest_drug_name
Args: nothing
Return: nothing
Creates suggestions for the specified field and prints them to a kson file
=cut

sub suggest_drug_name : Local {
    my ( $self, $c ) = @_;

    my $term     = $c->request->params->{term};
    my $drugs_rs = $c->model('FaersDB::Drug')->search_rs(
        {
            drugname => { -like => "$term%" }
        },
        {
            select   => ['drugname'],
            distinct => 1
        }
    );
    my @drugs;
    while ( my $drug = $drugs_rs->next ) {
        push @drugs, $drug->drugname;
    }

    $c->response->content_type('application/json');
    $c->response->body( objToJson( \@drugs ) );
}

=head3 suggest_side_effect
Args: nothing
Return: nothing
Creates suggestions for the specified field and prints them to a json file
=cut

sub suggest_side_effect : Local {
    my ( $self, $c ) = @_;

    my $term           = $c->request->params->{term};
    my $side_effect_rs = $c->model('FaersDB::Reac')->search_rs(
        {
            pt => { -like => "$term%" }
        },
        {
            select   => ['pt'],
            distinct => 1
        }
    );
    my @side_effects;
    while ( my $side_effect = $side_effect_rs->next ) {
        push @side_effects, $side_effect->pt;
    }

    $c->response->content_type('application/json');
    $c->response->body( objToJson( \@side_effects ) );
}

=head3 suggest_indication_use
Args: nothing
Return: nothing
Creates suggestions for the specified field and prints them to a kson file
=cut

sub suggest_indication_use : Local {
    my ( $self, $c ) = @_;

    my $term              = $c->request->params->{term};
    my $indication_use_rs = $c->model('FaersDB::Indi')->search_rs(
        {
            indi_pt => { -like => "$term%" }
        },
        {
            select   => ['indi_pt'],
            distinct => 1
        }
    );
    my @indication_uses;
    while ( my $indication_use = $indication_use_rs->next ) {
        push @indication_uses, $indication_use->indi_pt;
    }

    $c->response->content_type('application/json');
    $c->response->body( objToJson( \@indication_uses ) );
}

=head2 
Args: @fields
Return: $value
return true if at least one field has some value and 
all the fields with a value doesn't have any inappriate characters
=cut

sub validate {
    my @fields = @_;
    my $value  = 0;
    foreach my $fields (@fields) {
        if ( length($fields) > 2 ) { $value = 1; }
    }
    if ($value) {
        foreach my $fields (@fields) {
            if ( $fields =~ m/[^a-zA-Z0-9\\\ ()\-\_]/ ) { $value = 0; }
        }
    }
    return $value;
}

=encoding utf8

=head1 AUTHOR

Programmer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
