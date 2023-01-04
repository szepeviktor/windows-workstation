#!/bin/bash
#
# Create certificate overrides for Basilisk.
#
# AUTHOR        :Viktor Szépe <viktor@szepe.net>
# DEPENDS       :pip3 install firefox-cert-override

Save_certificate()
{
    local DOMAIN="$1"

    # Download certificate
    openssl s_client -connect "${DOMAIN}:443" -servername "${DOMAIN}" </dev/null | openssl x509 -outform PEM -out "${DOMAIN}.crt"
}

declare -a -r DOMAINS=(
    # OTP Bank login
    www.otpbank.hu
    # OTPdirekt
    www.otpbankdirekt.hu
    # Új OTPdirekt
    internetbank.otpbank.hu
    # static assets
    cdnjs.cloudflare.com
    # Mastercard
    cap.attempts.securecode.com
)
declare -a CERT_OVERRIDE_PARAMS=()

set -e

# Save certificates
for CERT in "${DOMAINS[@]}"; do
    echo "${CERT} ..."
    Save_certificate "${CERT}"
    CERT_OVERRIDE_PARAMS+=( "${CERT}:443=${CERT}.crt[U]" )
done

# Generate cert_override.txt
firefox-cert-override "${CERT_OVERRIDE_PARAMS[@]}" >certificates/cert_override.txt

# Clean up
for CERT in "${DOMAINS[@]}"; do
    rm "${CERT}.crt"
done

echo "OK."
