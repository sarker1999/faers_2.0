use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Faers';
use Faers::Controller::Drug;

ok( request('/drug')->is_success, 'Request should succeed' );
done_testing();
