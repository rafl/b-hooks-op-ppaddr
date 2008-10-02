#ifndef __HOOK_OP_PPADDR_H__
#define __HOOK_OP_PPADDR_H__

#include "perl.h"

typedef OP *(CPERLscope(*hook_op_callback_t)) (pTHX_ OP *);
PERL_XS_EXPORT_C void hook_op_ppaddr (opcode type, hook_op_callback_t cb);

#endif
