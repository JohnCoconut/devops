#### openssl guide

1. generate CA private/public key pair

openssl genrsa -out ca-key.pem 2048

2. create self-signed CA certificate

openssl req -x509 -nodes -new -key ca-key.pem -days 10000 -subj "/CN=www.example.com" -out ca.pem 

1. generate private/public key pairs

openssl genrsa -out test-key.pem 2048

2. to view key pair info

openssl rsa -in test-key.pem -text -noout

3. extract pub key

openssl rsa -in test-key.pem -pubout -out test-pub.pem

4. to view public key info 

openssl rsa -pubin -in test-pub.pem -text -noout

5. 
