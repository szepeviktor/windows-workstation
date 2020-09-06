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
    openssl s_client -connect "${DOMAIN}:443" </dev/null | openssl x509 -outform PEM -out "${DOMAIN}.crt"
}

declare -a -r DOMAINS=(
    # OTP Bank login
    www.otpbank.hu
    # OTPdirekt
    www.otpbankdirekt.hu
    # static assets
    cdnjs.cloudflare.com
    # Mastercard
    cap.attempts.securecode.com
)
declare -a CERT_OVERRIDE_PARAMS=()

set -e

# Save certificates
for CERT in "${DOMAINS[@]}"; do
    Save_certificate "$CERT"
    CERT_OVERRIDE_PARAMS+=( "${CERT}:443=${CERT}.crt[U]" )
done

# Generate cert_override.txt
firefox-cert-override "${CERT_OVERRIDE_PARAMS[@]}" >certdbs9/cert_override.txt

# Clean up
for CERT in "${DOMAINS[@]}"; do
    rm "${CERT}.crt"
done

echo "OK."
