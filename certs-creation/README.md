# certs

- Generate CSR openssl req -new -newkey rsa:2048 -nodes -keyout domain.key -out domain.csr
- For the Common Name, enter *.domain.com
- Put the cert in domain.crt
- Append the root certification to domain.crt