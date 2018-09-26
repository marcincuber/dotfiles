#!/bin/bash
# From p7b file extract cer and ca
P7B="$1"
CER="${1%.p7b}.cer"
CA="${1%.p7b}.ca"

openssl pkcs7 \
  -print_certs \
  -inform der \
  -in "$P7B" | awk -v CER="$CER" -v CA="$CA" 'BEGIN {
    printf "" > CER
    printf "" > CA
  }
  {
  if (incert) {
    if (cert==1) printf "%s\n",$0 >> CER
    else printf "%s\n",$0 >> CA
    if ($0 == "-----END CERTIFICATE-----") {
      incert=0
      # End of cert
    }
    } else if ($0 == "-----BEGIN CERTIFICATE-----") {
      echo "----START"
      incert=1
      cert++
      if (cert==1) printf "%s\n",$0 >> CER
      else printf "%s\n",$0 >> CA
    }
  }'
