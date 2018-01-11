package Faers::Controller::Drug;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use JSON;

=head1 NAME

Faers::Controller::Drug - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {

    my ( $self, $c ) = @_;
=cut
    my $params = $c->request->params;
    $c->log->debug('This is a debug statement');

my $dname         = $params->{'dname'}         || '';
my $cname         = $params->{'cname'}         || 1;
my $pt            = $params->{'pt'}            || '';
my $out           = $params->{'out'}           || '';
my $rps           = $params->{'rps'}           || '';
my $ind           = $params->{'ind'}           || '';
my $df            = $params->{'df'}            || 20140101;
my $dt            = $params->{'dt'}            || 20171231;
my $lim           = $params->{'lim'}           || 1;
my $compare_dname = $params->{'compare_dname'} || '';
my $action        = $params->{'action'}        || '';

if    ( $action eq 'drug' )    { suggest_field('drug'); }
elsif ( $action eq 'se' )      { suggest_field('se'); }
elsif ( $action eq 'iu' )      { suggest_field('iu'); }
elsif ( $action eq 'screen' )  { show_screen(); }
elsif ( $action eq 'csv' )     { csv(); }
elsif ( $action eq 'tab' )     { tab(); }
elsif ( $action eq 'graph' )   { graph(); }
elsif ( $action eq 'compare' ) { compare(); }
else                           { default_screen(); }
=cut
    $c->stash->{template} = 'drug/drug_data.html';
}

=head2 

=head2 graph

=cut

sub graph : Local {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;

    $params->{df} ||= 20140101;
    $params->{dt} ||= 20171231;

    my $pts_rs = $c->model('FaersDB::GraphData')->search_rs(
        {
            drugname_pt => { like => "$params->{dname}%" },
            fda_dt      => { -between => [ $params->{df}, $params->{dt} ] },
        },
        {
            columns  => [ 'pt', { count_pt => \'count(*)' } ],
            group_by => ['drugname_pt', 'pt'],
            order_by => { -desc => 'count(*)' },
            rows     => 15,
        }
    );

    my ( @pts, @count_pts );
    while ( my $pt_rs = $pts_rs->next ) {
        push @pts, $pt_rs->pt;
        push @count_pts, $pt_rs->count_pt;
    }

    $c->stash->{pts}       = objToJson( \@pts );
    $c->stash->{count_pts} = objToJson( \@count_pts );
    $c->stash->{template}  = 'drug/drug_graph.html';
}

=head2 compare

=cut

sub compare : Local {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;
    $c->stash->{drugs_rs} = $c->model('FaersDB::Drug')->search_rs(
        {
            drugname => { -like => 'harv%' }
        },
        {
            rows => 2000
        }
    );

    $c->stash->{template} = 'drug/compare.html';
}
=head3 generate_query_result
Args: $result
Return: $result
Returns the passed has after populating it with query result
=cut

=cut
sub generate_query_result {
    my $result = shift;
    my $valid = validate( $dname, $pt, $ind );
    if ($valid) {
        my $sql = 'SELECT drugname, val_vbm, pt, outc_cod, rpsr_cod, indi_pt, fda_dt, age, age_cod, wt, wt_cod 
			FROM demo JOIN drug ON demo.primaryid = drug.primaryid JOIN indi ON drug.primaryid=indi.primaryid 
			JOIN rpsr ON indi.primaryid = rpsr.primaryid JOIN outc ON rpsr.primaryid=outc.primaryid 
			JOIN reac on outc.primaryid=reac.primaryid WHERE drugname like ? AND val_vbm like ? AND pt LIKE ? AND 
			outc_cod LIKE ? AND rpsr_cod LIKE ? AND indi_pt LIKE ? AND fda_dt BETWEEN ? AND ? LIMIT ?';
        my $sth = $dbh->prepare($sql);

        my $res = $sth->execute( $dname . '%', $cname, $pt . '%', $out, $rps . '%', $ind . '%', $df, $dt, $lim );

        if ($res) {
            my $data_result = $sth->fetchall_arrayref( {} );
            $result->{data} = $data_result;
        }
        $sth->finish();
        return $result;
    }
}
=cut

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

=head2 show_screen
Args: nothing
Return: nothing
Displays the generated query result on screen
=cut

=cut
sub show_screen {
    my $display = { data => undef };
    $display = generate_query_result($display);
    print_header();
    $tt->process( 'drug_data.html', $display );
}
=cut

=head2 default_screen
Args: nothing
Return: nothing
Shows the default screen with the form and input options
=cut

=cut
sub default_screen {
    print_header();
    $tt->process('drug_data.html');
}
=cut

=head3 csv
Args: nothing
Return: nothing
Converts the generated query result into downloadable csv file
=cut

=cut
sub csv {
    my $csv_data = { data => undef };
    $csv_data = generate_query_result($csv_data);
    print_header( "text/csv", "drug_data.csv" );
    my $data    = $csv_data->{data};
    my @headers = sort keys %{ $data->[0] };
    print join ",", @headers;
    print "\n";

    for my $row (@$data) {
        print map { qq!"$row->{$_}",! } @headers;
        print '""';
        print "\n";
    }
}
=cut

=head3 tab
Args: nothing
Return: nothing
converts the generated query results into downloadable text file
=cut

=cut
sub tab {
    my $tab_data = { data => undef };
    $tab_data = generate_query_result($tab_data);
    print_header( "text/txt", "drug_data.txt" );
    my $data    = $tab_data->{data};
    my @headers = sort keys %{ $data->[0] };
    print join "    ", @headers;
    print "\n";
    for my $row (@$data) {
        print map { qq!"$row->{$_}"    ! } @headers;
        print "\n";
    }
}
=cut

=head3 suggest_drug_name
Args: nothing
Return: nothing
Creates suggestions for the specified field and prints them to a kson file
=cut

sub suggest_drug_name : Local {
    my ( $self, $c ) = @_;

    my $term = $c->request->params->{term};
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

    my $term = $c->request->params->{term};
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

    my $term = $c->request->params->{term};
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

=head3 graph
Args: nothing
Return: nothing
Processes the query for making graphs and passes the result to an html file to draw the graph
=cut


=cut
sub graph : Local {
    my $graph_data = { data => undef };
    $graph_data->{data} = generate_graph_data( $df, $dt, $dname );

    print_header();
    $tt->process( 'drug_graph.html', $graph_data );

    my ( $self, $c ) = @_;
    $c->stash->{template} = 'drug/test.html';
}
=cut


=head3 compare
Args = nothing
Return = nothing
Compares the results received from the generate_graph_data function 
by sending them to the relevant html file
=cut

=cut
sub compare {
    my $store_data = { drug1 => undef, drug1name => undef, drug2 => undef, drug2name => undef };
    $store_data->{drug1}     = generate_graph_data( $df, $dt, $dname );
    $store_data->{drug1name} = $dname;
    $store_data->{drug2}     = generate_graph_data( $df, $dt, $compare_dname );
    $store_data->{drug2name} = $compare_dname;

    print_header();
    $tt->process( 'compare_graph.html', $store_data );
}
=cut

=head2 generate_graph_data
Args: $from_date, $to_date, $drug_name
Return: $data
Runs a sql query to get all the results necessary for a graph and
then returns that resultas an arrayref
=cut


sub generate_graph_data {
=cut
    my ( $from_date, $to_date, $drug_name ) = @_;
    my $data;
    
    my $indication_use_rs = $c->model('FaersDB::Drug')->search_rs(
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

    my $query = 'SELECT pt, count(*) as count FROM drug 
                JOIN reac ON drug.primaryid=reac.primaryid 
                JOIN demo ON reac.primaryid=demo.primaryid 
                WHERE fda_dt BETWEEN ? AND ? AND drugname like ? 
                GROUP BY pt order by count(*) desc limit 15';
    my $content = $dbh->prepare($query);
    my $store = $content->execute( $from_date, $to_date, $drug_name ) or die;
    if ($store) {
        $data = $content->fetchall_arrayref( {} );
    }
    return $data;
=cut


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
            if ( $fields =~ m/[^a-zA-Z0-9\\\ \-\_]/ ) { $value = 0; }
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
