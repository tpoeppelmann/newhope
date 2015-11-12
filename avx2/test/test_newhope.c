
#include "../newhope.h"
#include "../poly.h"
#include "../randombytes.h"
#include "../crypto_stream_chacha20.h"
#include "../error_correction.h"
#include <math.h>
#include <stdio.h>
#include <string.h>

#define NTESTS 1000

int compare_keys(poly *a, poly *b){

  int i;

  for(i=0; i<256; i++){
    if (a->v[i] != b->v[i]){
      return -1;
    }
  }
  return 0;
}


int test_keys(){
  poly sk_a;
  unsigned char key_a[32], key_b[32];
  unsigned char senda[POLY_BYTES];
  unsigned char sendb[POLY_BYTES];
  int i;



  for(i=0; i<NTESTS; i++)
  {
    //Alice generates a public key
    newhope_keygen(senda, &sk_a);

    //Bob derives a secret key and creates a response
    newhope_sharedb(key_b, sendb, senda);
  
    //Alice uses Bobs response to get her secre key
    newhope_shareda(key_a, &sk_a, sendb);

    printf("%d\n", memcmp(key_a, key_b, 32));
  }

  return 0;
}

int test_invalid_sk_a()
{
  poly sk_a;
  unsigned char key_a[32], key_b[32];
  unsigned char senda[POLY_BYTES];
  unsigned char sendb[POLY_BYTES];
  unsigned char noiseseed[32];
  int i;
  
  randombytes(noiseseed,32);

  for(i=0; i<NTESTS; i++)
  {
    //Alice generates a public key
    newhope_keygen(senda, &sk_a);

    //Bob derives a secret key and creates a response
    newhope_sharedb(key_b, sendb, senda);
  
    //Overwrite the secret key
    poly_getnoise(&sk_a,noiseseed,i);

    //Alice uses Bobs response to get her secre key
    newhope_shareda(key_a, &sk_a, sendb);

    printf("%d\n", !memcmp(key_a, key_b, 32));
  }
  return 0;
}


int test_invalid_ciphertext()
{
  poly sk_a;
  unsigned char key_a[32], key_b[32];
  unsigned char senda[POLY_BYTES];
  unsigned char sendb[POLY_BYTES];
  int i;

  for(i=0; i<10; i++)
  {
    //Alice generates a public key
    newhope_keygen(senda, &sk_a);

    //Bob derives a secret key and creates a response
    newhope_sharedb(key_b, sendb, senda);

    //Change some byte in the "ciphertext"
    randombytes(sendb+42,1);
  
    //Alice uses Bobs response to get her secre key
    newhope_shareda(key_a, &sk_a, sendb);

    printf("%d\n", !memcmp(key_a, key_b, 32));

  }

  return 0;
}


int main(){

  test_keys();
  test_invalid_sk_a();
  test_invalid_ciphertext();
  return 0;
}
