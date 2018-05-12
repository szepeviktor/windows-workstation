#!/bin/bash
#
# Create certificate database with only provided certificates.
#
# AUTHOR        :Viktor Szépe <viktor@szepe.net>
# DOCS          :https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/NSS_Releases
# DOCS          :https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Reference/NSS_tools_:_certutil
# DEPENDS       :apt-get install libnss3-tools

Save_certificate()
{
    local DOMAIN="$1"
    # Download certificate
    openssl s_client -connect "${DOMAIN}:443" < /dev/null | openssl x509 -outform PEM -out "${DOMAIN}.crt"
    # Add certificate to certdb
    certutil -A -d "$DB_DIR" -i "${DOMAIN}.crt" -n "$DOMAIN" -t "C,,"
    # Clean up
    rm "${DOMAIN}.crt"
}

DB_DIR="certdbs/"

# Create new SQLite databases
export NSS_DEFAULT_DB_TYPE="sql"

set -e

# Start with empty database
mkdir certdbs

certutil -N -d "$DB_DIR" -f /dev/null

# Save certificates
# OTP Bank  login          otpdirekt            static assets        mastercard
for CERT in www.otpbank.hu www.otpbankdirekt.hu cdnjs.cloudflare.com cap.attempts.securecode.com; do
    Save_certificate "$CERT"
done

# List all certificates
certutil -L -d "$DB_DIR"

echo "OK."
