use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.007005
use Test::Spelling 0.12;
use Pod::Wordlist;


add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib ) );
__DATA__
Class
Dagfinn
David
Etheridge
Gelu
Golden
Ilmari
Inkster
Karen
Lupas
Mannsåker
Matt
Mengué
Olivier
Tiny
Toby
Trout
dagolden
destructor
dolmen
ether
fatpacking
gelu
ilmari
interoperability
lib
linearized
mstrout
tobyink
xdg
