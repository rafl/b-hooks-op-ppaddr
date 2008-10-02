use strict;
use warnings;

package B::Hooks::OP::PPAddr;

use parent qw/DynaLoader/;

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

__PACKAGE__->bootstrap($VERSION);

1;

__END__
=head1 NAME

B::Hooks::OP::PPAddr - Hook into PL_ppaddr

=head1 SYNOPSIS

    #include "hook_op_ppaddr.h"

    TODO

=head1 BIG FAT WARNING

This is B<ALPHA> software. Things may change. Use at your own risk.

=head1 DESCRIPTION

This module provides a c api for XS modules to hook into the callbacks of
C<PL_ppaddr>.

L<ExtUtils::Depends> is used to export all functions for other XS modules to
use. Include the following in your Makefile.PL:

    my $pkg = ExtUtils::Depends->new('Your::XSModule', 'B::Hooks::OP::PPAddr');
    WriteMakefile(
        ... # your normal makefile flags
        $pkg->get_makefile_vars,
    );

Your XS module can now include C<hook_op_check.h>.

=head1 FUNCTIONS

TODO

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2008 Florian Ragwitz

This module is free software.

You may distribute this code under the same terms as Perl itself.

=cut
