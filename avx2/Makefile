CC = /usr/bin/gcc

CFLAGS = -Wall -Wextra -O3 -fomit-frame-pointer -msse2avx -march=corei7-avx

HEADERS = crypto_stream_chacha20.h params.h poly.h randombytes.h ntt.h error_correction.h crypto_hash_sha256.h  fips202.h crypto_stream_aes256ctr.h
CFILES  = crypto_stream_chacha20.c poly.c precomp.c error_correction.c newhope.c crypto_hash_sha256.c chacha.S cbd.s consts.c fips202.c omegas.c ntt_double.s pwmul.s bitrev.s crypto_stream_aes256ctr.o hr.s rec.s

all:	test/test_newhope \
			test/speed  \
			test/testvectors


test/test_newhope: $(HEADERS) $(CFILES) test/test_newhope.c randombytes.c
	$(CC) $(CFLAGS) $(CFILES) test/test_newhope.c randombytes.c -o $@

test/speed: $(HEADERS) $(CFILES) test/speed.c cpucycles.c randombytes.c
	$(CC) $(CFLAGS) $(CFILES) test/speed.c cpucycles.c randombytes.c -o $@

test/testvectors: $(HEADERS) $(CFILES) test/testvectors.c
	$(CC) $(CFLAGS) $(CFILES) -DTESTVECTORS test/testvectors.c cpucycles.c -o $@

crypto_stream_aes256ctr.o: crypto_stream_aes256ctr.c
	$(CC) -c -m64 -march=native -mtune=native -O3 -fomit-frame-pointer $^ -o $@

.PHONY: clean

clean:
	-rm *.o
	-rm test/test_newhope	
	-rm test/speed
	-rm test/testvectors

