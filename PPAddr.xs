#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "ptable.h"

#include "hook_op_ppaddr.h"

typedef struct userdata_St {
	hook_op_ppaddr_cb_t cb;
	void *ud;
} userdata_t;

typedef struct around_userdata_St {
	hook_op_ppaddr_cb_t before;
	hook_op_ppaddr_cb_t after;
	Perl_ppaddr_t orig;
	void *ud;
} around_userdata_t;

STATIC PTABLE_t *op_map = NULL;

STATIC OP *
ppaddr_cb (pTHX) {
	userdata_t *ud = (userdata_t *)PTABLE_fetch(op_map, PL_op);
	return CALL_FPTR (ud->cb) (aTHX_ PL_op, ud->ud);
}

void
hook_op_ppaddr (OP *op, hook_op_ppaddr_cb_t cb, void *user_data) {
	userdata_t *ud;

	Newx (ud, 1, userdata_t);
	ud->cb = cb;
	ud->ud = user_data;

	PTABLE_store (op_map, op, ud);
	op->op_ppaddr = ppaddr_cb;
}

STATIC OP *
ppaddr_around_cb (pTHX_ OP *op, void *user_data) {
	OP *ret = op;
	around_userdata_t *ud = (around_userdata_t *)user_data;

	if (ud->before) {
		ret = CALL_FPTR (ud->before) (aTHX_ ret, ud->ud);
	}

	PL_op = ret;
	ret = CALL_FPTR (ud->orig) (aTHX);

	if (ud->after) {
		ret = CALL_FPTR (ud->after) (aTHX_ ret, ud->ud);
	}

	return ret;
}

void
hook_op_ppaddr_around (OP *op, hook_op_ppaddr_cb_t before,
                       hook_op_ppaddr_cb_t after, void *user_data) {
	around_userdata_t *ud;

	Newx (ud, 1, around_userdata_t);
	ud->before = before;
	ud->after = after;
	ud->orig = op->op_ppaddr;
	ud->ud = user_data;

	hook_op_ppaddr (op, ppaddr_around_cb, ud);
}

MODULE = B::Hooks::OP::PPAddr  PACKAGE = B::Hooks::OP::PPAddr

PROTOTYPES: DISABLE

void
END ()
	CODE:
		PTABLE_free (op_map);

BOOT:
	op_map = PTABLE_new ();

	if (!op_map) {
		croak ("can't initialize op map");
	}
