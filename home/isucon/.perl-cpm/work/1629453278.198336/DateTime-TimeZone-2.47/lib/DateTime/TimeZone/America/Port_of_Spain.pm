# This file is auto-generated by the Perl DateTime Suite time zone
# code generator (0.08) This code generator comes with the
# DateTime::TimeZone module distribution in the tools/ directory

#
# Generated from /tmp/M7TZl06VNc/southamerica.  Olson data version 2021a
#
# Do not edit this file directly.
#
package DateTime::TimeZone::America::Port_of_Spain;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '2.47';

use Class::Singleton 1.03;
use DateTime::TimeZone;
use DateTime::TimeZone::OlsonDB;

@DateTime::TimeZone::America::Port_of_Spain::ISA = ( 'Class::Singleton', 'DateTime::TimeZone' );

my $spans =
[
    [
DateTime::TimeZone::NEG_INFINITY, #    utc_start
60310584364, #      utc_end 1912-03-02 04:06:04 (Sat)
DateTime::TimeZone::NEG_INFINITY, #  local_start
60310569600, #    local_end 1912-03-02 00:00:00 (Sat)
-14764,
0,
'LMT',
    ],
    [
60310584364, #    utc_start 1912-03-02 04:06:04 (Sat)
DateTime::TimeZone::INFINITY, #      utc_end
60310569964, #  local_start 1912-03-02 00:06:04 (Sat)
DateTime::TimeZone::INFINITY, #    local_end
-14400,
0,
'AST',
    ],
];

sub olson_version {'2021a'}

sub has_dst_changes {0}

sub _max_year {2031}

sub _new_instance {
    return shift->_init( @_, spans => $spans );
}



1;

