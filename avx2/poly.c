#include "poly.h"
#include "ntt.h"
#include "randombytes.h"
#include "fips202.h"
#include "crypto_stream.h"

static const unsigned char nonce[8] = {0};

static uint16_t barrett_reduce(uint16_t a)
{
  uint32_t u;

  u = ((uint32_t) a * 5) >> 16;
  u *= PARAM_Q;
  a -= u;
  return a;
}

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


extern void cbd(poly *r, unsigned char *b);

void poly_getnoise(poly *r, unsigned char *seed, unsigned char nonce)
{
#if PARAM_K != 8
#error "poly_getnoise in poly.c only supports k=8"
#endif
  unsigned char buf[3*PARAM_N];
  unsigned char n[CRYPTO_STREAM_NONCEBYTES];
  int i;

  for(i=1;i<CRYPTO_STREAM_NONCEBYTES;i++)
    n[i] = 0;
  n[0] = nonce;

  crypto_stream(buf,3*PARAM_N,n,seed);
  cbd(r,buf);
}

void poly_pointwise(poly *r, const poly *a, const poly *b)
{
  int i;
  for(i=0;i<PARAM_N;i++)
    r->v[i] = a->v[i] * b->v[i] % PARAM_Q; /* XXX: Get rid of the % here! */
}

void poly_add(poly *r, const poly *a, const poly *b)
{
  int i;
  for(i=0;i<PARAM_N;i++)
    r->v[i] = a->v[i] + b->v[i] % PARAM_Q; /* XXX: Get rid of the % here! */
}

void poly_bitrev(poly *r)
{
  bitrev_vector(r->v);
}

void poly_ntt(poly *r)
{
  double temp[PARAM_N];

  pwmul_double(r->v, psis_bitrev);
  ntt_double(r->v,omegas_double,temp);
}

void poly_invntt(poly *r)
{
  double temp[PARAM_N];

  ntt_double(r->v, omegas_inv_double,temp);
  pwmul_double(r->v, psis_inv);
}
