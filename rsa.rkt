;Emiliano Peredo 
;Raziel Martinez
;Alfredo Quintero
;15/06/2020

#lang racket

; Write a simple line with a new line character
(define (write-line n out)
    (displayln n out))

; Write a single line
(define (write-single-line line out-file)
    (call-with-output-file out-file #:exists 'truncate
        (lambda (out)
            (write-line line out))))

; Writes a list to a file where each line is an element of a 
; Credits to: Gilberto Echeverria
(define (write-key key out-file)
    (call-with-output-file out-file #:exists 'truncate
        (lambda (out)
            (let loop
                ([key key])
                (if (empty? key)
                    (displayln "Finished writing key")
                    (begin
                        (write-line (car key) out)
                        (loop (cdr key))))))))

; Reads lines from a file and converts them to a list of numbers
; Credits to: Gilberto Echeverria
(define (lines->list-numbers in)
    (let loop
        ([result empty])
        (define line (read-line in))
        (if (eof-object? line)
            result
            ; Each line contains a number, so it must be converted
            (loop (append result (list (string->number line)))))))

; Reads a list of integers from a file. This represents a private/public key
(define (read-key key-file)
    (call-with-input-file key-file lines->list-numbers))

; Reads lines from a text
(define (file-lines in)
    (let loop
        ([result empty])
        (define line (read-line in))
        (if (eof-object? line)
            result
            ; Each line contains a number, so it must be converted
            (loop (append result (list line))))))

; Reads lines from a file and separates each line with separator into a string
(define (read-message file separator)
    (string-join (call-with-input-file file file-lines) separator))

; Euclid's algorithm for determining the greatest common divisor
(define (gcd a b)
    (if (equal? b 0)
        a
        (gcd b (modulo a b))))

; Extended Euclid's algorithm to find multiplicative inverse of a (mod b)
; Computes x, y such that ax + by = gcd(a, b)
(define (multiplicative-inverse a b)
  (let loop 
        ([d 0] 
         [x1 0] 
         [x2 1]
         [y1 1] 
         [b b] 
         [a a]
         [old_a a]   ; save in case there is a negative value
         [old_b b])  ; save in case there is a negative value
    (if (zero? b)
        (cond
            [(< x2 0) (list a (+ x2 old_b) d)]
            [(< d 0) (list a x2 (+ d old_a))]
            [else (list a x2 d)]
        )
        ;;; (list a x2 d)
        (loop y1                            ; now is d
            (- x2 (* (quotient a b) x1))    ; now is x1
            x1                              ; now is x2
            (- d (* (quotient a b) y1))     ; now is y1  
            (- a (* (quotient a b) b))      ; now is b
            b                               ; now is a
            old_a
            old_b))))                           

; Checks whether a number is prime or not
(define (isPrime n)
    (cond
        [(equal? n 2) #t]
        [(or (< n 2) (zero? (modulo n 2))) #f]
        [else 
            (let loop 
                ([x 3])
                (if (<= x (sqrt n))
                    (if (zero? (modulo n x))
                        #f
                        (loop (+ x 2))  
                    )
                    #t
                ))]))

; Determine random coprime number "e" such that:
; 1 < e < phi
; Coprime with phi
(define (chooseE phi)
    (let 
        ([e (floor (+ (random (- phi 2)) 2))]) ; Random in [2, phi)
        (cond
            [(equal? (gcd e phi) 1) e]
            [else (chooseE phi)]
        )
    )
)

; Generates public and private keys
(define (generateKeys p q)
    (cond 
        [(and (isPrime p) (isPrime q))
            (let 
                ([n (* p q)]
                 [phi (* (- p 1) (- q 1))] ; Definition of phi: number of coprime numbers of p*q
                )
                (let 
                    ([e (chooseE phi)])
                        (let
                            ([d (car (cdr (multiplicative-inverse  e phi)))]) 
                            (list (list n e) (list n d))
                        )
                )
            )                        
        ]
    )
)

; Generates public and private keys and saves them to indicated files
; Example usage: (generateKeysAndSave 97 107 "public_keys.txt" "private_keys.txt")
(define (generateKeysAndSave p q public-key-file private-key-file)
    (define keys (generateKeys p q))
    (write-key (first keys) public-key-file)
    (write-key (second keys) private-key-file))

;Encrypts a number with number^e mod n
(define (encrypt publicK number)
    (let 
     ([n (car publicK)]
      [e (car (cdr publicK))])
        (modulo (expt number e) n)
    )
)

;Encrypts string making each characater an integer and returning a string with each encrypted character followeb by a space
;Note: Since racket max character is integer 1114111 this can fail if n < 1114111, if you not are using special characters this should work fine if n > 255
(define (encrypt-text publicK text)
    (string-join (map number->string (map (lambda (n) (encrypt publicK n)) (map char->integer (string->list text)))) " ")
)

;Decrpyts a number with number^d mod n
(define (decrypt privateK number)
    (let
    ([n (car privateK)]
      [d (car (cdr privateK))])
        (modulo (expt number d) n)
    )
)

;Decrypts string with the encrypted format making the original string again 
(define (decrypt-text privateK text)
    (list->string (map integer->char (map (lambda (n) (decrypt privateK n)) (map string->number (string-split text)))))
)

;Reads a plain text file and generates encrypted file with suffix encrypted-
(define (encryptFileAndSave publicK filename)
    (define text (read-message filename "\n"))
    (define encryptedText (encrypt-text publicK text))
    (displayln encryptedText)
    (write-single-line encryptedText (string-append "encrypted-" filename)))

;Reads a cyphered text file and generates a decrypted file with suffix decrypted-
(define (decryptFileAndSave privateK filename)
    (define text (read-message filename " "))
    (define decryptedText (decrypt-text privateK text))
    (displayln decryptedText)
    (write-single-line decryptedText (string-append "decrypted-" filename)))

;display a UI which user generates keys and encrypt and decrypts a file to test all methods
(define (displayUI)
    (display "Select one of the options or any key to exit: \n1. Encrypt a file \n2. Decrypt a file \n")
    (define option (read))
    (cond
        [(equal? option 1)
            (display "Insert the first prime number: ")
            (define firstP (read))
            (display "Insert the second prime number: ")
            (define secondP (read))
            (generateKeysAndSave firstP secondP "public_keys.txt" "private_keys.txt")
            (display "Insert filename to encrypt: ")
            (define eFilename (read))
            (encryptFileAndSave (read-key "public_keys.txt") (symbol->string eFilename))
        ]
        [(equal? option 2)
            (display "Insert filename to decrypt: ")
            (define dFilename (read))
            (decryptFileAndSave (read-key "private_keys.txt") (symbol->string dFilename))
        ]
        [else (exit)]
    ))