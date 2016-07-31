# NewHope Java Port

This directory contains a straight translation of the reference C code
to Java.  There are two classes in the org.pqcrypto.newhope package:

 * NewHope - Main API for the Java implementation of NewHope.
 * NewHopeTests - Some test cases to verify the implementation.

Only the NewHope class needs to be imported into a user application.
The NewHopeTests class is not needed except for verification.

## Using the Java Port

Using the NewHope class is pretty straight-forward:

    import org.pqcrypto.newhope.NewHope;

    // Generate the private and public keys for Alice.
    NewHope alice = new NewHope();
    byte[] senda = new byte [NewHope.SENDABYTES];
    alice.keygen(senda, 0);

    // Generate the public key and shared secret for Bob.
    NewHope bob = new NewHope();
    byte[] sendb = new byte [NewHope.SENDBBYTES];
    byte[] key_b = new byte [NewHope.SHAREDBYTES];
    bob.sharedb(key_b, 0, sendb, 0, senda, 0);

    // Generate the shared secret for Alice.
    byte[] key_a = new byte [NewHope.SHAREDBYTES];
    alice.shareda(key_a, 0, sendb, 0);

The 0 values in the code above are offsets into the respective arrays
in case you need to write the key values to somewhere else in the
caller-supplied buffers.

The NewHopeTests class provides some more examples.

## Random Number Generation

The NewHope class uses the Java standard SecureRandom class to generate
random numbers.  If this isn't good enough, then the randombytes() method
can be overridden in a subclass to provide an alternative source of
random numbers.  This can also be used to provide a static source of
random numbers for test vectors (as is done in NewHopeTests).

## License

Public domain, same as the original C code.
