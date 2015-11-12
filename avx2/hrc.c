#include "error_correction.h"

static int32_t abs(int32_t v)
{
  int32_t mask = v >> 31;
  return (v ^ mask) - mask;
}


static int32_t f(int32_t *v0, int32_t *v1, int32_t x)
{
  int32_t xit, t, r, b;
  
  // Next 6 lines compute t = x/PARAM_Q;
  b = x*2730;

  t = b >> 25;
  b = x - t*12289;
  b = 12288 - b;
  b >>= 31;
  t -= b;
  

  r = t & 1;
  xit = (t>>1);
  *v0 = xit+r; // v0 = round(x/(2*PARAM_Q))

  t -= 1;
  r = t & 1;
  *v1 = (t>>1)+r;

  return abs(x-((*v0)*2*PARAM_Q));
}


void hrc(poly *c, const poly *v, unsigned char rand[32])
{  
  int32_t v00[4];
  int32_t v01[4]; 
  int32_t v02[4]; 
  int32_t v03[4]; 
  int32_t v04[4]; 
  int32_t v05[4]; 
  int32_t v06[4]; 
  int32_t v07[4]; 

  int32_t v10[4]; 
  int32_t v11[4]; 
  int32_t v12[4]; 
  int32_t v13[4]; 
  int32_t v14[4]; 
  int32_t v15[4]; 
  int32_t v16[4]; 
  int32_t v17[4]; 

  int32_t v_tmp0[4];
  int32_t v_tmp1[4];
  int32_t v_tmp2[4];
  int32_t v_tmp3[4];
  int32_t v_tmp4[4];
  int32_t v_tmp5[4];
  int32_t v_tmp6[4];
  int32_t v_tmp7[4];

  int32_t k0;
  int32_t k1;
  int32_t k2;
  int32_t k3;
  int32_t k4;
  int32_t k5;
  int32_t k6;
  int32_t k7;

  unsigned char rbit0;
  unsigned char rbit1;
  unsigned char rbit2;
  unsigned char rbit3;
  unsigned char rbit4;
  unsigned char rbit5;
  unsigned char rbit6;
  unsigned char rbit7;
  
  int i = 0;

  /*
  for(i=0; i<256; i+=8)
  {
  */
    rbit0 =  (rand[(i+0)>>3] >> ((i+0)&7)) & 1;
    rbit1 =  (rand[(i+1)>>3] >> ((i+1)&7)) & 1;
    rbit2 =  (rand[(i+2)>>3] >> ((i+2)&7)) & 1;
    rbit3 =  (rand[(i+3)>>3] >> ((i+3)&7)) & 1;
    rbit4 =  (rand[(i+4)>>3] >> ((i+4)&7)) & 1;
    rbit5 =  (rand[(i+5)>>3] >> ((i+5)&7)) & 1;
    rbit6 =  (rand[(i+6)>>3] >> ((i+6)&7)) & 1;
    rbit7 =  (rand[(i+7)>>3] >> ((i+7)&7)) & 1;


    k0  = f(v00+0, v10+0, 8*v->v[  0+i] + 4*PARAM_Q*rbit0);
    k1  = f(v01+0, v11+0, 8*v->v[  1+i] + 4*PARAM_Q*rbit1);
    k2  = f(v02+0, v12+0, 8*v->v[  2+i] + 4*PARAM_Q*rbit2);
    k3  = f(v03+0, v13+0, 8*v->v[  3+i] + 4*PARAM_Q*rbit3);
    k4  = f(v04+0, v14+0, 8*v->v[  4+i] + 4*PARAM_Q*rbit4);
    k5  = f(v05+0, v15+0, 8*v->v[  5+i] + 4*PARAM_Q*rbit5);
    k6  = f(v06+0, v16+0, 8*v->v[  6+i] + 4*PARAM_Q*rbit6);
    k7  = f(v07+0, v17+0, 8*v->v[  7+i] + 4*PARAM_Q*rbit7);

    /*
    c->v[  0+i] =  v10[0];
    c->v[  1+i] =  v11[0];
    c->v[  2+i] =  v12[0];
    c->v[  3+i] =  v13[0];
    c->v[  4+i] =  v14[0];
    c->v[  5+i] =  v15[0];
    c->v[  6+i] =  v16[0];
    c->v[  7+i] =  v17[0];
    */


    k0 += f(v00+1, v10+1, 8*v->v[256+i] + 4*PARAM_Q*rbit0);
    k1 += f(v01+1, v11+1, 8*v->v[257+i] + 4*PARAM_Q*rbit1);
    k2 += f(v02+1, v12+1, 8*v->v[258+i] + 4*PARAM_Q*rbit2);
    k3 += f(v03+1, v13+1, 8*v->v[259+i] + 4*PARAM_Q*rbit3);
    k4 += f(v04+1, v14+1, 8*v->v[260+i] + 4*PARAM_Q*rbit4);
    k5 += f(v05+1, v15+1, 8*v->v[261+i] + 4*PARAM_Q*rbit5);
    k6 += f(v06+1, v16+1, 8*v->v[262+i] + 4*PARAM_Q*rbit6);
    k7 += f(v07+1, v17+1, 8*v->v[263+i] + 4*PARAM_Q*rbit7);

    k0 += f(v00+2, v10+2, 8*v->v[512+i] + 4*PARAM_Q*rbit0);
    k1 += f(v01+2, v11+2, 8*v->v[513+i] + 4*PARAM_Q*rbit1);
    k2 += f(v02+2, v12+2, 8*v->v[514+i] + 4*PARAM_Q*rbit2);
    k3 += f(v03+2, v13+2, 8*v->v[515+i] + 4*PARAM_Q*rbit3);
    k4 += f(v04+2, v14+2, 8*v->v[516+i] + 4*PARAM_Q*rbit4);
    k5 += f(v05+2, v15+2, 8*v->v[517+i] + 4*PARAM_Q*rbit5);
    k6 += f(v06+2, v16+2, 8*v->v[518+i] + 4*PARAM_Q*rbit6);
    k7 += f(v07+2, v17+2, 8*v->v[519+i] + 4*PARAM_Q*rbit7);

    k0 += f(v00+3, v10+3, 8*v->v[768+i] + 4*PARAM_Q*rbit0);
    k1 += f(v01+3, v11+3, 8*v->v[769+i] + 4*PARAM_Q*rbit1);
    k2 += f(v02+3, v12+3, 8*v->v[770+i] + 4*PARAM_Q*rbit2);
    k3 += f(v03+3, v13+3, 8*v->v[771+i] + 4*PARAM_Q*rbit3);
    k4 += f(v04+3, v14+3, 8*v->v[772+i] + 4*PARAM_Q*rbit4);
    k5 += f(v05+3, v15+3, 8*v->v[773+i] + 4*PARAM_Q*rbit5);
    k6 += f(v06+3, v16+3, 8*v->v[774+i] + 4*PARAM_Q*rbit6);
    k7 += f(v07+3, v17+3, 8*v->v[775+i] + 4*PARAM_Q*rbit7);

    k0 = (2*PARAM_Q-1-k0) >> 31;
    k1 = (2*PARAM_Q-1-k1) >> 31;
    k2 = (2*PARAM_Q-1-k2) >> 31;
    k3 = (2*PARAM_Q-1-k3) >> 31;
    k4 = (2*PARAM_Q-1-k4) >> 31;
    k5 = (2*PARAM_Q-1-k5) >> 31;
    k6 = (2*PARAM_Q-1-k6) >> 31;
    k7 = (2*PARAM_Q-1-k7) >> 31;

    /*
    c->v[  0+i] =  k0;
    c->v[  1+i] =  k1;
    c->v[  2+i] =  k2;
    c->v[  3+i] =  k3;
    c->v[  4+i] =  k4;
    c->v[  5+i] =  k5;
    c->v[  6+i] =  k6;
    c->v[  7+i] =  k7;
    */

    v_tmp0[0] = ((~k0) & v00[0]) ^ (k0 & v10[0]);
    v_tmp1[0] = ((~k1) & v01[0]) ^ (k1 & v11[0]);
    v_tmp2[0] = ((~k2) & v02[0]) ^ (k2 & v12[0]);
    v_tmp3[0] = ((~k3) & v03[0]) ^ (k3 & v13[0]);
    v_tmp4[0] = ((~k4) & v04[0]) ^ (k4 & v14[0]);
    v_tmp5[0] = ((~k5) & v05[0]) ^ (k5 & v15[0]);
    v_tmp6[0] = ((~k6) & v06[0]) ^ (k6 & v16[0]);
    v_tmp7[0] = ((~k7) & v07[0]) ^ (k7 & v17[0]);

    v_tmp0[1] = ((~k0) & v00[1]) ^ (k0 & v10[1]);
    v_tmp1[1] = ((~k1) & v01[1]) ^ (k1 & v11[1]);
    v_tmp2[1] = ((~k2) & v02[1]) ^ (k2 & v12[1]);
    v_tmp3[1] = ((~k3) & v03[1]) ^ (k3 & v13[1]);
    v_tmp4[1] = ((~k4) & v04[1]) ^ (k4 & v14[1]);
    v_tmp5[1] = ((~k5) & v05[1]) ^ (k5 & v15[1]);
    v_tmp6[1] = ((~k6) & v06[1]) ^ (k6 & v16[1]);
    v_tmp7[1] = ((~k7) & v07[1]) ^ (k7 & v17[1]);

    v_tmp0[2] = ((~k0) & v00[2]) ^ (k0 & v10[2]);
    v_tmp1[2] = ((~k1) & v01[2]) ^ (k1 & v11[2]);
    v_tmp2[2] = ((~k2) & v02[2]) ^ (k2 & v12[2]);
    v_tmp3[2] = ((~k3) & v03[2]) ^ (k3 & v13[2]);
    v_tmp4[2] = ((~k4) & v04[2]) ^ (k4 & v14[2]);
    v_tmp5[2] = ((~k5) & v05[2]) ^ (k5 & v15[2]);
    v_tmp6[2] = ((~k6) & v06[2]) ^ (k6 & v16[2]);
    v_tmp7[2] = ((~k7) & v07[2]) ^ (k7 & v17[2]);

    v_tmp0[3] = ((~k0) & v00[3]) ^ (k0 & v10[3]);
    v_tmp1[3] = ((~k1) & v01[3]) ^ (k1 & v11[3]);
    v_tmp2[3] = ((~k2) & v02[3]) ^ (k2 & v12[3]);
    v_tmp3[3] = ((~k3) & v03[3]) ^ (k3 & v13[3]);
    v_tmp4[3] = ((~k4) & v04[3]) ^ (k4 & v14[3]);
    v_tmp5[3] = ((~k5) & v05[3]) ^ (k5 & v15[3]);
    v_tmp6[3] = ((~k6) & v06[3]) ^ (k6 & v16[3]);
    v_tmp7[3] = ((~k7) & v07[3]) ^ (k7 & v17[3]);

    /*
    c->v[  0+i] =  v_tmp0[3];
    c->v[  1+i] =  v_tmp1[3];
    c->v[  2+i] =  v_tmp2[3];
    c->v[  3+i] =  v_tmp3[3];
    c->v[  4+i] =  v_tmp4[3];
    c->v[  5+i] =  v_tmp5[3];
    c->v[  6+i] =  v_tmp6[3];
    c->v[  7+i] =  v_tmp7[3];
    */

    c->v[  0+i] = (v_tmp0[0] -   v_tmp0[3]) & 3;  
    c->v[  1+i] = (v_tmp1[0] -   v_tmp1[3]) & 3;  
    c->v[  2+i] = (v_tmp2[0] -   v_tmp2[3]) & 3;  
    c->v[  3+i] = (v_tmp3[0] -   v_tmp3[3]) & 3;  
    c->v[  4+i] = (v_tmp4[0] -   v_tmp4[3]) & 3;  
    c->v[  5+i] = (v_tmp5[0] -   v_tmp5[3]) & 3;  
    c->v[  6+i] = (v_tmp6[0] -   v_tmp6[3]) & 3;  
    c->v[  7+i] = (v_tmp7[0] -   v_tmp7[3]) & 3;  

    c->v[256+i] = (v_tmp0[1] -   v_tmp0[3]) & 3;
    c->v[257+i] = (v_tmp1[1] -   v_tmp1[3]) & 3;
    c->v[258+i] = (v_tmp2[1] -   v_tmp2[3]) & 3;
    c->v[259+i] = (v_tmp3[1] -   v_tmp3[3]) & 3;
    c->v[260+i] = (v_tmp4[1] -   v_tmp4[3]) & 3;
    c->v[261+i] = (v_tmp5[1] -   v_tmp5[3]) & 3;
    c->v[262+i] = (v_tmp6[1] -   v_tmp6[3]) & 3;
    c->v[263+i] = (v_tmp7[1] -   v_tmp7[3]) & 3;

    c->v[512+i] = (v_tmp0[2] -   v_tmp0[3]) & 3;
    c->v[513+i] = (v_tmp1[2] -   v_tmp1[3]) & 3;
    c->v[514+i] = (v_tmp2[2] -   v_tmp2[3]) & 3;
    c->v[515+i] = (v_tmp3[2] -   v_tmp3[3]) & 3;
    c->v[516+i] = (v_tmp4[2] -   v_tmp4[3]) & 3;
    c->v[517+i] = (v_tmp5[2] -   v_tmp5[3]) & 3;
    c->v[518+i] = (v_tmp6[2] -   v_tmp6[3]) & 3;
    c->v[519+i] = (v_tmp7[2] -   v_tmp7[3]) & 3;

    c->v[768+i] = (   -k0    + 2*v_tmp0[3]) & 3;
    c->v[769+i] = (   -k1    + 2*v_tmp1[3]) & 3;
    c->v[770+i] = (   -k2    + 2*v_tmp2[3]) & 3;
    c->v[771+i] = (   -k3    + 2*v_tmp3[3]) & 3;
    c->v[772+i] = (   -k4    + 2*v_tmp4[3]) & 3;
    c->v[773+i] = (   -k5    + 2*v_tmp5[3]) & 3;
    c->v[774+i] = (   -k6    + 2*v_tmp6[3]) & 3;
    c->v[775+i] = (   -k7    + 2*v_tmp7[3]) & 3;

    /*
  }
    */
}
