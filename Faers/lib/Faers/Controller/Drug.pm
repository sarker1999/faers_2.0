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
=cut
sub graph : Local {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;

    my $drugname = $params->{dname} || '';
    my $date_from = $params->{df} || 20140101;
    my $date_to = $params->{dt} || 20171231;
    
    my ( $pts, $count_pts ) = generate_graph($drugname,$date_from,$date_to);
    my @pts       = @$pts;
    my @count_pts = @$count_pts;

    $c->stash->{pts}       = objToJson( \@pts );
    $c->stash->{count_pts} = objToJson( \@count_pts );
    $c->stash->{template}  = 'drug/drug_graph.html';
}
=cut
=head2 compare

=cut

sub graph : Local {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;

    my $drugname = $params->{dname} || '';
    my $date_from = $params->{df} || 20140101;
    my $date_to = $params->{dt} || 20171231;
    my $compare_drugname = $params->{compare_dname};
    my $compare_dname_2 = $params->{compare_dname_2};    

    my ( $pts, $count_pts ) = generate_graph($drugname,$date_from,$date_to);
    my ( $pts_compare, $count_pts_compare ) = generate_graph($compare_drugname,$date_from,$date_to);
    my ( $pts2, $count_pts2 ) = generate_graph($compare_dname_2, $date_from, $date_to);

    my @pts = @$pts;
    my @count_pts = @$count_pts;
    my @pts_compare = @$pts_compare;
    my @count_pts_compare = @$count_pts_compare;
    my @pts2 = @$pts2;
    my @count_pts2 = @$count_pts2;

    $c->stash->{pts}       = objToJson( \@pts );
    $c->stash->{count_pts} = objToJson( \@count_pts );
    $c->stash->{drugname} = $drugname;
    $c->stash->{compare_drugname} = $compare_drugname;
    $c->stash->{pts_compare}       = objToJson( \@pts_compare );
    $c->stash->{count_pts_compare} = objToJson( \@count_pts_compare );
    $c->stash->{compare_drugname_2} = $compare_dname_2;
    $c->stash->{pts2} = objToJson( \@pts2 );
    $c->stash->{count_pts2} = objToJson( \@count_pts2 );
    $c->stash->{template}  = 'drug/compare_graph.html';
    
    
}

=head3 generate_graph

=cut
sub generate_graph {

    my ($drugname, $date_from, $date_to) = @_;

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


sub show_screen: Local {
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
            $display_result->drugname,
            $display_result->val_vbm,
            $display_result->pt,
            $display_result->outc_cod,
            $display_result->rpsr_cod,
            $display_result->indi_pt,
            $display_result->fda_dt,
            $display_result->age,
            $display_result->age_cod,
            $display_result->wt,
            $display_result->wt_cod
        );
        $csv_string .= $csv->string . "\n";
    }

    $c->response->content_type("text/$extension");
    $c->response->header(
        'Content-Disposition' => "attachment; filename=drug_data.$extension"
    );
    $c->response->body($csv_string);
}

=head3 generate_query_result
Args: $result
Return: $result
Returns the passed has after populating it with query result
=cut


sub generate_query_result {
	my $params = shift;

#    my $result = shift;

    my $drugname         = $params->{'dname'}         || '';
my $code_num         = $params->{'cname'}         || 1;
my $side_effect      = $params->{'pt'}            || '';
my $outcome           = $params->{'out'}           || '';
my $source           = $params->{'rps'}           || '';
my $indication        = $params->{'ind'}           || '';
 my $date_from =  $params->{df} || 20140101;
my $date_to =    $params->{dt} || 20171231;
my $limit           = $params->{'lim'}           || 1;

my $valid = validate( $drugname, $side_effect, $indication );
    if ($valid) {
        my $sql = 'SELECT drugname, val_vbm, pt, outc_cod, rpsr_cod, indi_pt, fda_dt, age, age_cod, wt, wt_cod 
			FROM demo JOIN drug ON demo.primaryid = drug.primaryid JOIN indi ON drug.primaryid=indi.primaryid 
			JOIN rpsr ON indi.primaryid = rpsr.primaryid JOIN outc ON rpsr.primaryid=outc.primaryid 
			JOIN reac on outc.primaryid=reac.primaryid WHERE drugname like ? AND val_vbm like ? AND pt LIKE ? AND 
			outc_cod LIKE ? AND rpsr_cod LIKE ? AND indi_pt LIKE ? AND fda_dt BETWEEN ? AND ? LIMIT ?';

        my $view_search_results_rs = Faers->model('FaersDB::ViewSearchResult')->search_rs(
            {},
            {
                bind => [
                    "$drugname%",    $code_num,
                    "$side_effect%", $outcome,
                    "$source%",      "$indication%",
                    $date_from,      $date_to,
                    $limit
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

=pod
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
