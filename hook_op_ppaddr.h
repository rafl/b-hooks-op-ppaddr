#ifndef __HOOK_OP_PPADDR_H__
#define __HOOK_OP_PPADDR_H__

#include "perl.h"

PERL_XS_EXPORT_C void hook_op_ppaddr (opcode type, Perl_ppaddr_t cb);

#endif
