# RSA cipher of text files implemeneted in Racket

Reference code: https://gist.github.com/JonCooperWorks/5314103

## Steps required for the implementation based on the RSA algorithm:

### Private and public key generation

#### 1) Obtain n = p * q, where p and q are prime numbers
#### 2) Obtain phi = (p-1) * (q-1)
#### 3) Obtain e where 1<e<phi and is coprime to phi
#### 4) Obtain d which is the multiplicative inverse of (e mod phi)

#### The public key is composed of: [n,e] 
#### The private key is composed of: [n,d]

### Encryption formula: 
#### c = m^e mod n

#### Decryption formula: 
#### m = c^d mod n



