#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_op_ppaddr.h"

STATIC Perl_ppaddr_t orig_PL_ppaddr[OP_max];
STATIC AV *ppaddr_cbs[OP_max];

#define run_orig_ppaddr(type) (CALL_FPTR (orig_PL_ppaddr[(type)])(aTHX))

STATIC UV initialized = 0;

STATIC void
setup () {
	if (initialized) {
		return;
	}

	initialized = 1;

	Copy (PL_ppaddr, orig_PL_ppaddr, OP_max, Perl_ppaddr_t);
	Zero (ppaddr_cbs, OP_max, AV *);
}

STATIC OP *
ppaddr_cb (pTHX) {
	I32 i;
	AV *hooks = ppaddr_cbs[PL_op->op_type];
	OP *ret = run_orig_ppaddr (PL_op->op_type);

	if (!hooks) {
		return ret;
	}

	for (i = 0; i <= av_len (hooks); i++) {
		SV **hook = av_fetch (hooks, i, 0);

		if (!hook || !*hook) {
			continue;
		}

		Perl_ppaddr_t cb = (Perl_ppaddr_t)SvUV (*hook);
		CALL_FPTR (cb)(aTHX);
	}

	return ret;
}

void
hook_op_ppaddr (opcode type, Perl_ppaddr_t cb) {
	AV *hooks;

	if (!initialized) {
		setup ();
	}

	hooks = ppaddr_cbs[type];

	if (!hooks) {
		hooks = newAV ();
		ppaddr_cbs[type] = hooks;
		PL_ppaddr[type] = ppaddr_cb;
	}

	av_push (hooks, newSVuv ((UV)cb));
}

MODULE = B::Hooks::OP::PPAddr  PACKAGE = B::Hooks::OP::PPAddr

PROTOTYPES: DISABLE
