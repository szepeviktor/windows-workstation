#!/bin/bash
#
# Alert on new ASUS firmware release.
#
# VERSION       :0.1.0
# DATE          :2018-04-16
# URL           :https://github.com/szepeviktor/windows-workstation
# AUTHOR        :Viktor Szépe <viktor@szepe.net>
# LICENSE       :The MIT License (MIT)
# BASH-VERSION  :4.2+
# DEPENDS       :apt-get install jq
# LOCATION      :/usr/local/bin/asus-firmware-notify.sh
# CRON-DAILY    :/usr/local/bin/asus-firmware-notify.sh

# Hardcoded model name and product ID hash
#
# https://www.asus.com/supportonly/RT-AC56U/HelpDesk_BIOS/
PRODUCT_MODEL="RT-AC56U"
PRODUCT_ID="ejvcVtFQNPxjVH5w"

set -e

BIOS_VERSION="$1"

if [ -z "$BIOS_VERSION" ]; then
    echo "Please provide current BIOS version." 1>&2
    exit 10
fi

# Callback parameter should be empty
printf -v API_URL "https://www.asus.com/support/api/product.asmx/GetPDBIOS?website=global&pdhashedid=%s&model=%s&callback=" \
    "$PRODUCT_ID" "$PRODUCT_MODEL"

JSON="$(wget -q -O- "$API_URL")"

NEW_VERSION="$(jq -r ".Result.Obj[0].Files[0].Version" <<< "$JSON")"

if [ "$NEW_VERSION" != "$BIOS_VERSION" ]; then
    printf "Download new BIOS version %s for ASUS %s from %s\n" \
        "$NEW_VERSION" "$PRODUCT_MODEL" "$(jq -r ".Result.Obj[0].Files[0].DownloadUrl.Global" <<< "$JSON")"
fi

exit 0
