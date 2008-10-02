use strict;
use warnings;
use inc::Module::Install;
use ExtUtils::Depends;

name 'B-Hooks-OP-PPAddr';
all_from 'lib/B/Hooks/OP/PPAddr.pm';

requires 'parent';
configure_requires 'ExtUtils::Depends';

my $pkg = ExtUtils::Depends->new('B::Hooks::OP::PPAddr');
$pkg->install('hook_op_ppaddr.h');
$pkg->add_xs('PPAddr.xs');
$pkg->add_pm('lib/B/Hooks/OP/PPAddr.pm' => '$(INST_LIB)/B/Hooks/OP/PPAddr.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

makemaker_args(
    $pkg->get_makefile_vars,
    dist => { PREOP => 'pod2text lib/B/Hooks/OP/PPAddr.pm > $(DISTVNAME)/README' },
);

extra_tests;

WriteAll;
