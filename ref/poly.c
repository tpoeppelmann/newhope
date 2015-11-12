#include "poly.h"
#include "ntt.h"
#include "randombytes.h"
#include "reduce.h"
#include "fips202.h"
#include "crypto_stream_chacha20.h"

void poly_frombytes(poly *r, const unsigned char *a)
{
  int i;
  for(i=0;i<PARAM_N;i++)
  {
    r->v[i] = a[2*i] | ((uint16_t) (a[2*i+1] & 0x3f) << 8);
  }
}

void poly_tobytes(unsigned char *r, const poly *p)
{
  int i;
  uint16_t t,m;
  int16_t c;
  for(i=0;i<PARAM_N;i++)
  {
    t = barrett_reduce(p->v[i]); //Make sure that coefficients have only 14 bits
    m = t - PARAM_Q;
    c = m;
    c >>= 15;
    t = m ^ ((t^m)&c); // <Make sure that coefficients are in [0,q]
    r[2*i]   = t & 0xff;
    r[2*i+1] = t >> 8;
  }
}

void poly_uniform(poly *a, const unsigned char *seed)
{
  unsigned int pos=0, ctr=0;
  uint16_t val;
  uint64_t state[25];
  unsigned int nblocks=16;
  uint8_t buf[SHAKE128_RATE*nblocks];

  shake128_absorb(state, seed, NEWHOPE_SEEDBYTES);
  
  shake128_squeezeblocks((unsigned char *) buf, nblocks, state);

  while(ctr < PARAM_N)
  {
    val = (buf[pos] | ((uint16_t) buf[pos+1] << 8)) & 0x3fff; // Specialized for q = 12889
    if(val < PARAM_Q)
      a->v[ctr++] = val;
    pos += 2;
    if(pos > SHAKE128_RATE*nblocks-2)
    {
      nblocks=1;
      shake128_squeezeblocks((unsigned char *) buf,nblocks,state);
      pos = 0;
    }
  }
}


void poly_getnoise(poly *r, unsigned char *seed, unsigned char nonce)
{
#if PARAM_K != 12
#error "poly_getnoise in poly.c only supports k=12"
#endif

  unsigned char buf[3*PARAM_N];
  unsigned char n[8];
  uint32_t v; /*use as a vector of 4 8-bit ints */
  uint8_t *b = (uint8_t *)&v;
  int i,j;

  for(i=1;i<8;i++)
    n[i] = 0;
  n[0] = nonce;

  crypto_stream_chacha20(buf,3*PARAM_N,n,seed);

  /* First half of the output */
  for(i=0;i<PARAM_N/2;i+=2)
  {
    v = 0;
    for(j=0;j<8;j++)
      v += ((*(uint32_t *)(buf+2*i)) >> j) & 0x01010101;
    for(j=0;j<4;j++)
      v += ((*(uint32_t *)(buf+2*i+2*PARAM_N)) >> j) & 0x01010101;
    r->v[i]   = PARAM_Q + b[0] - b[1];
    r->v[i+1] = PARAM_Q + b[2] - b[3];
  }

  /* Second half of the output */
  for(i=0;i<PARAM_N/2;i+=2)
  {
    v = 0;
    for(j=0;j<8;j++)
      v += ((*(uint32_t *)(buf+2*i+PARAM_N)) >> j) & 0x01010101;
    for(j=0;j<4;j++)
      v += ((*(uint32_t *)(buf+2*i+2*PARAM_N)) >> (4+j)) & 0x01010101;
    r->v[i+PARAM_N/2]   = PARAM_Q + b[0] - b[1];
    r->v[i+PARAM_N/2+1] = PARAM_Q + b[2] - b[3];
  }
}

void poly_pointwise(poly *r, const poly *a, const poly *b)
{
  int i;
  uint16_t t;
  for(i=0;i<PARAM_N;i++)
  {
    t       = montgomery_reduce(3186*b->v[i]); /* t is now in Montgomery domain */
    r->v[i] = montgomery_reduce(a->v[i] * t); /* r->v[i] is back in normal domain */
  }
}

void poly_add(poly *r, const poly *a, const poly *b)
{
  int i;
  for(i=0;i<PARAM_N;i++)
    r->v[i] = barrett_reduce(a->v[i] + b->v[i]);
}

void poly_bitrev(poly *r)
{
  bitrev_vector(r->v);
}

void poly_ntt(poly *r)
{
  mul_coefficients(r->v, psis_bitrev_montgomery); 
  ntt((uint16_t *)r->v, omegas_montgomery);
}

void poly_invntt(poly *r)
{
  ntt((uint16_t *)r->v, omegas_inv_montgomery);
  mul_coefficients(r->v, psis_inv_montgomery);
}
