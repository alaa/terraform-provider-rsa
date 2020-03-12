# terraform-provider-rsa

The main purpose of this provider is to be able to calculate the Public Key from a provided PEM encoded Private Key.

### Build on Linux:

```
GOOS=linux GOARCH=amd64 make clean deps build test
```

### Build on Mac:

```
GOOS=darwin GOARCH=amd64 make clean deps build test
```

This RSA provider has only one resource `rsa_public_key` which accepts one argument which is the `private_key`.
The `private_key` value should be a wraped string without line breaks, However if you wish to pass unwraped private_key
you can pass a `HERE DOC` as a value.

### Example:

```
resource "rsa_public_key" "my-public-key" {
  private_key = <<EOF
-----BEGIN RSA PRIVATE KEY-----
...
-----END RSA PRIVATE KEY-----
EOF
}

```
