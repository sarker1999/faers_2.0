use strict;
use warnings;

use Faers;

my $app = Faers->apply_default_middlewares(Faers->psgi_app);
$app;

