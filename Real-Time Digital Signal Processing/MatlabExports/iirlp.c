/* iirlp.c                             */
/* IIR filter coefficients             */
/* exported by MATLAB using IIR_dump2C */
/* Michael G. Morrow - 2000, 2013      */


#include "iirlp.h"

float B[N] = {
 3.50355e-12,	/* B[0] */
 1.05107e-11,	/* B[1] */
 1.05107e-11,	/* B[2] */
 3.50355e-12,	/* B[3] */
};

float A[N] = {
           1,	/* A[0] */
    -2.99939,	/* A[1] */
     2.99879,	/* A[2] */
   -0.999393,	/* A[3] */
};
