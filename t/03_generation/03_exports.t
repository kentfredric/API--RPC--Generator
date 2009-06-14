use strict;
use warnings;

use Test::More tests => 8;
use Test::Exception;
use Find::Lib './03_exports';

{

  package dog;
  use eieio;
  use namespace::autoclean;

  ::lives_ok{ dynamic_call 'example';
    } 'generated-package eieio exports dynamic_call';
  ::lives_ok{ root;
    } 'generated-package eieio exports root';

  ::lives_ok{ leaf;
    } 'generated-package eieio exports leaf';

  ::lives_ok{ subspace 'bar';
    } 'generated-package eieio exports subspace';
  __PACKAGE__->meta->make_immutable;
}

for (qw( dynamic_call root leaf subspace )) {
  ok( !dog->can($_), "generated-interface doesn't export badness with $_ " );
}

