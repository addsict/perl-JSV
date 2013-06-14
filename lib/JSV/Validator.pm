package JSV::Validator;

use strict;
use warnings;

use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/last_exception/]
);

use JSV::Keyword::Type;
use JSV::Keyword::MultipleOf;
use JSV::Util::Type qw(detect_instance_type);

sub new {
    my $class = shift;
    bless {
        last_exception => undef,
    } => $class;
}

sub validate {
    my ($self, $schema, $instance, $opts) = @_;
    my $rv;

    $opts = {
        type           => detect_instance_type($instance),
        pointer_tokens => [],
    };

    eval {
        JSV::Keyword::Type->validate($schema, $instance, $opts);

        if ($opts->{type} eq "integer" || $opts->{type} eq "number") {
            JSV::Keyword::MultipleOf->validate($schema, $instance, $opts);
        }

        $rv = 1;
    };
    if (my $e = $@) {
        $self->last_exception($e);
        $rv = 0;
    }

    return $rv;
}

1;
