#include "poly.h"
#include "randombytes.h"
#include "error_correction.h"
#include "fips202.h"

static void encode_a(unsigned char *r, const poly *pk, const unsigned char *seed)
{
  int i,j;
  poly_tobytes(r, pk);
  unsigned char t;

  for(i=0;i<NEWHOPE_SEEDBYTES;i++)
  {
    t = seed[i];
    for(j=0;j<4;j++)
    {
      r[2*(4*i+j)+1] |= t << 6;
      t >>= 2;
    }
  }
}

static void decode_a(poly *pk, unsigned char *seed, const unsigned char *r)
{
  int i,j;
  poly_frombytes(pk, r);
  for(i=0;i<32;i++)
  {
    seed[i] = 0;
    for(j=0;j<4;j++)
      seed[i] |= (r[2*(4*i+j)+1] >> 6) << 2*j;
  }
}

static void encode_b(unsigned char *r, const poly *b, const poly *c)
{
  int i;
  poly_tobytes(r,b);
  for(i=0;i<1024;i++)
    r[2*i+1] |= c->v[i] << 6;
}

static void decode_b(poly *b, poly *c, const unsigned char *r)
{
  int i;
  poly_frombytes(b, r);
  for(i=0;i<1024;i++)
    c->v[i] = r[2*i+1] >> 6;
}

static void gen_a(poly *a, const unsigned char *seed)
{
    poly_uniform(a,seed);
}


// API FUNCTIONS 

void newhope_keygen(unsigned char *send, poly *sk)
{
  poly a, e, r, pk;
  unsigned char seed[NEWHOPE_SEEDBYTES];
  unsigned char noiseseed[32];

  randombytes(seed, NEWHOPE_SEEDBYTES);
  randombytes(noiseseed, 32);

  gen_a(&a, seed); //unsigned

  poly_getnoise(sk,noiseseed,0);
  poly_ntt(sk); //unsigned
  
  poly_getnoise(&e,noiseseed,1);
  poly_ntt(&e); //unsigned

  poly_pointwise(&r,sk,&a); //unsigned
  poly_add(&pk,&e,&r); //unsigned
  encode_a(send, &pk, seed);
}


void newhope_sharedb(unsigned char *sharedkey, unsigned char *send, const unsigned char *received)
{
  poly sp, ep, v, a, pka, c, epp, bp;
  unsigned char seed[NEWHOPE_SEEDBYTES];
  unsigned char noiseseed[32];
  
  randombytes(noiseseed, 32);

  decode_a(&pka, seed, received);
  gen_a(&a, seed);

  poly_getnoise(&sp,noiseseed,0);
  poly_ntt(&sp);
  poly_getnoise(&ep,noiseseed,1);
  poly_ntt(&ep);

  poly_pointwise(&bp, &a, &sp);
  poly_add(&bp, &bp, &ep);
  
  poly_pointwise(&v, &pka, &sp);
  poly_bitrev(&v);
  poly_invntt(&v);

  poly_getnoise(&epp,noiseseed,2);
  poly_add(&v, &v, &epp);

  helprec(&c, &v, noiseseed, 3);

  encode_b(send, &bp, &c);
  
  rec(sharedkey, &v, &c);

#ifndef STATISTICAL_TEST 
  sha3256(sharedkey, sharedkey, 32);
#endif
}


void newhope_shareda(unsigned char *sharedkey, const poly *sk, const unsigned char *received)
{
  poly v,bp, c;

  decode_b(&bp, &c, received);

  poly_pointwise(&v,sk,&bp);
  poly_bitrev(&v);
  poly_invntt(&v);
 
  rec(sharedkey, &v, &c);
#ifndef STATISTICAL_TEST 
  sha3256(sharedkey, sharedkey, 32); 
#endif
}
