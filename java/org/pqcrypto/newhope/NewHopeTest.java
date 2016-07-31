/*
 * Based on the public domain C reference code for New Hope.
 * This Java version is also placed into the public domain.
 * 
 * Original authors: Erdem Alkim, Léo Ducas, Thomas Pöppelmann, Peter Schwabe
 * Java port: Rhys Weatherley
 */

package org.pqcrypto.newhope;

/**
 * Test harness for NewHope.
 * 
 * This class applies tests to the NewHope class to verify the
 * implementation.  It is not needed in applications that use NewHope.
 */
public class NewHopeTest extends NewHope {

	public NewHopeTest()
	{
	}
	
	// -------------- testvectors.c --------------
	
	private static int[] seed = { 3,1,4,1,5,9,2,6,5,3,5,8,9,7,9,3,2,3,8,4,6,2,6,4,3,3,8,3,2,7,9,5 } ;
	private static int[] in = new int [12];
	private static int[] out = new int [8];
	private static int outleft = 0;
	
	private static int ROTATE(int x, int b)
	{
		return (x << b) | (x >>> (32 - b));
	}

	private static void surf()
	{
	  int[] t = new int [12];
	  int x; int sum = 0;
	  int r; int i; int loop;

	  for (i = 0;i < 12;++i) t[i] = in[i] ^ seed[12 + i];
	  for (i = 0;i < 8;++i) out[i] = seed[24 + i];
	  x = t[11];
	  for (loop = 0;loop < 2;++loop) {
	    for (r = 0;r < 16;++r) {
	      sum += 0x9e3779b9;
	      x = t[0] += (((x ^ seed[0]) + sum) ^ ROTATE(x, 5));
	      x = t[1] += (((x ^ seed[1]) + sum) ^ ROTATE(x, 7));
	      x = t[2] += (((x ^ seed[2]) + sum) ^ ROTATE(x, 9));
	      x = t[3] += (((x ^ seed[3]) + sum) ^ ROTATE(x, 13));

	      x = t[4] += (((x ^ seed[4]) + sum) ^ ROTATE(x, 5));
	      x = t[5] += (((x ^ seed[5]) + sum) ^ ROTATE(x, 7));
	      x = t[6] += (((x ^ seed[6]) + sum) ^ ROTATE(x, 9));
	      x = t[7] += (((x ^ seed[7]) + sum) ^ ROTATE(x, 13));

	      x = t[8]  += (((x ^ seed[8])  + sum) ^ ROTATE(x, 5));
	      x = t[9]  += (((x ^ seed[9])  + sum) ^ ROTATE(x, 7));
	      x = t[10] += (((x ^ seed[10]) + sum) ^ ROTATE(x, 9));
	      x = t[11] += (((x ^ seed[11]) + sum) ^ ROTATE(x, 13));
	    }
	    for (i = 0;i < 8;++i) out[i] ^= t[i + 4];
	  }
	}

	// Overrides the base class to provide static test data.
	@Override
	protected void randombytes(byte[] buffer, int offset, int size)
	{
		while (size > 0) {
			if (outleft == 0) {
				if ((++in[0]) == 0) {
					if ((++in[1]) == 0) {
						if ((++in[2]) == 0) {
							++in[3];
						}
					}
				}
				surf();
				outleft = 8;
			}
			buffer[offset++] = (byte)out[--outleft];
			--size;
		}
	}

	// -------------- test_newhope.c --------------
	
	private static final int NTESTS = 1000;
	
	private static boolean compare(byte[] a, byte[] b)
	{
		if (a.length != b.length)
			return false;
		for (int i = 0; i < a.length; ++i) {
			if (a[i] != b[i])
				return false;
		}
		return true;
	}

	private static void test_keys()
	{
		byte[] key_a = new byte [NewHope.SHAREDBYTES];
		byte[] key_b = new byte [NewHope.SHAREDBYTES];
		byte[] senda = new byte [NewHope.SENDABYTES];
		byte[] sendb = new byte [NewHope.SENDBBYTES];
		
		NewHope alice = new NewHope();
		NewHope bob = new NewHope();

		boolean ok = true;
		for (int i = 0; i < NTESTS; ++i) {
			alice.keygen(senda, 0);
			bob.sharedb(key_b, 0, sendb, 0, senda, 0);
			alice.shareda(key_a, 0, sendb, 0);
			
			if (!compare(key_a, key_b)) {
				System.out.println("test_keys(" + Integer.toString(i+1) + "): shared keys do not match");
				ok = false;
			}
		}
		
		alice.destroy();
		bob.destroy();
		
		if (ok)
			System.out.println("test_keys(): all tests pass");
	}

	// -------------- testvectors.c --------------
	
	private static void printHex(byte[] value)
	{
		String hexchars = "0123456789abcdef";
		for (int i = 0; i < value.length; ++i) {
			System.out.print(hexchars.charAt((value[i] >> 4) & 0x0f));
			System.out.print(hexchars.charAt(value[i] & 0x0f));
		}
		System.out.println();
	}

	private static void test_vectors()
	{
		byte[] key_a = new byte [NewHope.SHAREDBYTES];
		byte[] key_b = new byte [NewHope.SHAREDBYTES];
		byte[] senda = new byte [NewHope.SENDABYTES];
		byte[] sendb = new byte [NewHope.SENDBBYTES];
		
		NewHope alice = new NewHopeTest();
		NewHope bob = new NewHopeTest();

		for (int i = 0; i < NTESTS; ++i) {
			alice.keygen(senda, 0);
			printHex(senda);
			
			bob.sharedb(key_b, 0, sendb, 0, senda, 0);
			printHex(sendb);
			
			alice.shareda(key_a, 0, sendb, 0);
			printHex(key_a);
			printHex(key_b);
		}
	}

	public static void main(String[] args) {
		test_keys();
		test_vectors();
	}
}
