# PGP Keys

Yes my `secring.gpg` file is published, I am *fully* aware of that. I
have decided that it is safe to publish after researching and undertaking
a number of precautions.

* It is protected with a strong passphrase, part of which is
  stored on a [YubiKey](http://www.yubico.com/products/yubikey-hardware/).

* I've changed the GnuPG configuration to use the slowest key derivation
  possible, SHA512 with 65011712 iterations, making any brute force
  attempt painfully slow.

* The only secret keys are sub keys, the primary signing key is stored
  offline on removable storage. This is per Debian
  [recommendations](https://wiki.debian.org/subkeys).

The first two should make it near impossible to brute force the secret
keys whilst the third precaution should limit any damage if somebody
does find a way to unlock the secret keys.

## References

* http://nullprogram.com/blog/2012/06/24/
