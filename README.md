# RSA cipher of text files implemented in Racket

Reference code: https://gist.github.com/JonCooperWorks/5314103

## Steps required for the implementation based on the RSA algorithm:

### Private and public keys generation

#### 1) Obtain *n = p * q*, where p and q are prime numbers. 
#### 2) Obtain *phi = (p-1) * (q-1)*, where phi is the number of coprime numbers of p*q.
#### 3) Obtain *e* where *1<e<phi* and is coprime to *phi*.
#### 4) Obtain d which is the multiplicative inverse of (e mod phi).

#### The public key is composed of: [n,e] 
#### The private key is composed of: [n,d]

### Encryption formula: 
#### *c = m^e mod n*

### Decryption formula: 
#### *m = c^d mod n*

## Usage
### To use the program you have to run it, then use the function (displayUI), and then: ...

### Encryption
#### To encrypt a file, when prompted you have to choose the encryption option, then you will be asked for two prime numbers and finally you have to provide the name of the file to encrypt, results can be found in the terminal, as well as in a new text file named with the prefix "encrypted-" plus the name of the file provided before.

![Test1](https://user-images.githubusercontent.com/22597425/84837609-26755880-affe-11ea-81a2-c74cae83bd79.png)

#### The public and private keys generated to make the encryption can be found in the files "private_keys.txt" and "public_keys.txt"

### Decryption
#### To decrypt a file you have to select the decryption option to decrypt and then provide the name of the file to decrypt, results can be found in the terminal, as well as in a new text file named with the prefix "decrypted-" plus the name of the file provided before.

![Screenshot_2](https://user-images.githubusercontent.com/22597425/84837995-fa0e0c00-affe-11ea-9cc9-1899bcb1007d.png)

#### Here is a brief explanation of the methods used in the program "rsa.rkt". For further understanding check the code in "rsa.rkt".

![methods1](https://user-images.githubusercontent.com/22597425/84838784-eb285900-b000-11ea-8b14-3160c083ddfc.png)

![methods2](https://user-images.githubusercontent.com/22597425/84838802-fda29280-b000-11ea-94d6-5855a3ec4c67.png)
