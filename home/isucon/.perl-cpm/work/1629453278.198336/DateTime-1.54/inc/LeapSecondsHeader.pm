package inc::LeapSecondsHeader;

use strict;
use warnings;
use autodie;

my $VERSION = 0.04;

use Dist::Zilla::File::InMemory;

use Moose;

has _leap_second_data => (
    traits  => ['Array'],
    is      => 'bare',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_leap_second_data',
    handles => { _leap_second_data => 'elements' },
);

with 'Dist::Zilla::Role::FileGatherer';

sub gather_files {
    my $self = shift;

    $self->add_file(
        Dist::Zilla::File::InMemory->new(
            name     => 'leap_seconds.h',
            encoding => 'bytes',
            content  => $self->_header,
        ),
    );
}

my $x = 1;
my %months = map { $_ => $x++ }
    qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );

sub _build_leap_second_data {
    my $self = shift;
    my @steps;

    open my $fh, '<', 'leaptab.txt' or die $!;
    while (<$fh>) {
        my ( $year, $mon, $day, $leap_seconds ) = split /\s+/;

        $mon =~ s/\W//;
        my $utc_epoch = _ymd2rd( $year, $months{$mon}, $day );

        push @steps, [ $utc_epoch => $leap_seconds ];
    }

    close $fh;

    return \@steps;
}

sub _macro_lines {
    join "\n", map sprintf( "    %-37s\\", $_ ), @_;
}

sub set_leap_seconds {
    my $self = shift;

    # The most recent leaps have a higher chance to match
    my $count  = 0;
    my @checks = "$count;";
    foreach my $step ( $self->_leap_second_data ) {
        $count += $step->[1];
        unshift @checks, "utc_rd >= $step->[0] ? $count :";
    }
    my $checks = _macro_lines(@checks);

    return <<__LEAP;

/* utc_rd must be a simple variable */
#define SET_LEAP_SECONDS(utc_rd, leaps)  \\
  (leaps) =                              \\
$checks\
__LEAP
}

sub set_extra_seconds {
    my $self = shift;

    my @checks;
    foreach my $step ( $self->_leap_second_data ) {
        push @checks, "case $step->[0]: es = $step->[1]; break;";
    }

    my $checks = _macro_lines(@checks);

    return <<__EXTRA_SECONDS;
#define SET_EXTRA_SECONDS(utc_rd, es)    \\
    switch (utc_rd +1) {                 \\
$checks\
    default: es = 0;                     \\
    }
__EXTRA_SECONDS
}

sub set_day_length {
    my $self = shift;

    my @checks;
    foreach my $step ( $self->_leap_second_data ) {
        push @checks, "case $step->[0]: dl = 86400 + $step->[1]; break;";
    }
    my $checks = _macro_lines(@checks);

    return <<__DAY_LENGTH;
#define SET_DAY_LENGTH(utc_rd, dl)       \\
    switch (utc_rd +1) {                 \\
$checks\
    default: dl = 86400;                 \\
    }
__DAY_LENGTH
}

sub _header {
    my $self = shift;

    my $generator = ref $self;
    my $header    = <<__HEADER;
/*

This file is auto-generated by the leap second code generator ($VERSION). This
code generator comes with the DateTime.pm module distribution in the tools/
directory

Generated $generator.

Do not edit this file directly.

*/
__HEADER

    return join "\n",
        $header,
        $self->set_leap_seconds,
        $self->set_extra_seconds,
        $self->set_day_length;
}

# from lib/DateTimePP.pm
sub _ymd2rd {
    use integer;
    my ( $y, $m, $d ) = @_;
    my $adj;

    # make month in range 3..14 (treat Jan & Feb as months 13..14 of
    # prev year)
    if ( $m <= 2 ) {
        $y -= ( $adj = ( 14 - $m ) / 12 );
        $m += 12 * $adj;
    }
    elsif ( $m > 14 ) {
        $y += ( $adj = ( $m - 3 ) / 12 );
        $m -= 12 * $adj;
    }

    # make year positive (oh, for a use integer 'sane_div'!)
    if ( $y < 0 ) {
        $d -= 146097 * ( $adj = ( 399 - $y ) / 400 );
        $y += 400 * $adj;
    }

    # add: day of month, days of previous 0-11 month period that began
    # w/March, days of previous 0-399 year period that began w/March
    # of a 400-multiple year), days of any 400-year periods before
    # that, and 306 days to adjust from Mar 1, year 0-relative to Jan
    # 1, year 1-relative (whew)

    $d
        += ( $m * 367 - 1094 ) / 12
        + $y % 100 * 1461 / 4
        + ( $y / 100 * 36524 + $y / 400 )
        - 306;
}

1;
