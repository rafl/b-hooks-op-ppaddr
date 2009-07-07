use 5.006; #due to use warnings
use strict;
use warnings;
use inc::Module::Install 0.75;
use ExtUtils::Depends 0.302;

name 'B-Hooks-OP-PPAddr';
all_from 'lib/B/Hooks/OP/PPAddr.pm';

repository 'git://github.com/rafl/b-hooks-op-ppaddr.git';

requires 'parent';
configure_requires 'ExtUtils::Depends' => 0.302; #minimum version that works on Win32+gcc

my $pkg = ExtUtils::Depends->new('B::Hooks::OP::PPAddr');
$pkg->install('hook_op_ppaddr.h');
$pkg->add_xs('PPAddr.xs');
$pkg->add_pm('lib/B/Hooks/OP/PPAddr.pm' => '$(INST_LIB)/B/Hooks/OP/PPAddr.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

makemaker_args(
    $pkg->get_makefile_vars,
    FUNCLIST => [qw/hook_op_ppaddr hook_op_ppaddr_around/],
    DL_FUNCS => { 'B::Hooks::OP::PPAddr' => [] },
    dist => { PREOP => 'pod2text lib/B/Hooks/OP/PPAddr.pm > $(DISTVNAME)/README' },
);

extra_tests;

WriteAll;
