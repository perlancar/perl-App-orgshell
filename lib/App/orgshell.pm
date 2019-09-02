package App::orgshell;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use App::CSelUtils;

our %SPEC;

$SPEC{orgshell} = {
    v => 1.1,
    summary => 'Navigate Org document tree in a command-line shell',
    args => {
        %AppLib::TreeShell::args_common,
    },
};
sub orgshell {
    require Tree::Shell;

    my %args = @_;

    my $shell = Tree::Shell->new(
        program_name => "orgshell",
    );

        @_,

        code_read_tree => sub {
            require Org::Parser;
            my $args = shift;

            my $parser = Org::Parser->new;
            my $doc;
            if ($args->{file} eq '-') {
                binmode STDIN, ":encoding(utf8)";
                $doc = $parser->parse(join "", <>);
            } else {
                local $ENV{PERL_ORG_PARSER_CACHE} = $ENV{PERL_ORG_PARSER_CACHE} // 1;
                $doc = $parser->parse_file($args->{file});
            }
        },

        csel_opts => {class_prefixes=>["Org::Element"]},

        code_transform_node_actions => sub {
            my $args = shift;

            for my $action (@{$args->{node_actions}}) {
                if ($action eq 'dump') {
                    $action = 'dump:as_string';
                }
            }
        },
    );
}

1;
#ABSTRACT:

=head1 SYNOPSIS
