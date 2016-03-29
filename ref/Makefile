CC = /usr/bin/gcc
CFLAGS = -Wall -Wextra -O3 -fomit-frame-pointer -msse2avx -march=corei7-avx

HEADERS = crypto_stream_chacha20.h params.h poly.h randombytes.h ntt.h error_correction.h reduce.h
CFILES  = crypto_stream_chacha20.c poly.c ntt.c precomp.c error_correction.c newhope.c reduce.c fips202.c

all:	test/test_newhope \
			test/test_statistical \
			test/speed  \
			test/testvectors \

test/test_newhope: $(HEADERS) $(CFILES) test/test_newhope.c randombytes.c
	$(CC) $(CFLAGS) $(CFILES) randombytes.c test/test_newhope.c -o $@

test/test_statistical: $(HEADERS) $(CFILES) test/test_statistical.c randombytes.c
	$(CC) $(CFLAGS) $(CFILES) -DSTATISTICAL_TEST randombytes.c test/test_statistical.c -o $@

test/speed: $(HEADERS) $(CFILES) test/speed.c cpucycles.c randombytes.c
	$(CC) $(CFLAGS) $(CFILES) randombytes.c test/speed.c cpucycles.c -o $@

test/testvectors: $(HEADERS) $(CFILES) test/testvectors.c
	$(CC) $(CFLAGS) $(CFILES) test/testvectors.c cpucycles.c -o $@

.PHONY: clean

clean:
	-rm test/test_newhope	
	-rm test/test_statistical
	-rm test/speed
	-rm test/testvectors

