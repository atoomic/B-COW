/*
*
* Copyright (c) 2018, Nicolas R.
*
* This is free software; you can redistribute it and/or modify it under the
* same terms as Perl itself.
*
*/

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>
#include <embed.h>


#define MIN_PERL_VERSION_FOR_COW  20

#if PERL_REVISION >= 5 && PERL_VERSION >= MIN_PERL_VERSION_FOR_COW  
#   define B_CAN_COW 1
#else
#   define B_CAN_COW 0
#endif

MODULE = B__COW       PACKAGE = B::COW

SV*
can_cow()
CODE:
{
#if B_CAN_COW
    XSRETURN_YES;
#else
    XSRETURN_NO;
#endif
}
OUTPUT:
     RETVAL

SV*
is_cow(sv)
  SV *sv;
CODE:
{
/* not exactly accurate but let's start there  */
#if !B_CAN_COW
    XSRETURN_UNDEF;
#else
    if ( SvIsCOW(sv) ) XSRETURN_YES;
#endif
    XSRETURN_NO;
}
OUTPUT:
     RETVAL

SV*
cowrefcnt(sv)
  SV *sv;
CODE:
{
#if !B_CAN_COW
    XSRETURN_UNDEF;
#else
    if ( SvIsCOW(sv) ) XSRETURN_IV( CowREFCNT(sv) );
#endif
    XSRETURN_UNDEF;
}
OUTPUT:
     RETVAL

SV*
cowrefcnt_max()
CODE:
{
#if !B_CAN_COW
    XSRETURN_UNDEF;
#else  
  XSRETURN_IV(SV_COW_REFCNT_MAX);
#endif
}
OUTPUT:
     RETVAL
