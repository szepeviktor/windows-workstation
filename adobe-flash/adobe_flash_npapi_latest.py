#!/usr/bin/env python
"""Get the URL of latest Adobe Flash version for Firefox under Windows 10"""
#
# VERSION       :0.1.0
# SOURCE        :https://get.adobe.com/flashplayer/otherversions/
# URL           :https://get.adobe.com/flashplayer/webservices/json/?platform_type=Windows&platform_dist=Windows%208&platform_arch=&platform_misc=&exclude_version=&browser_arch=&browser_type=&browser_vers=&browser_dist=&eventname=flashplayerotherversions
# OLD-URL       :http://download.macromedia.com/get/flashplayer/current/licensing/win/install_flash_player_@@_plugin.exe"
# OLD-URL       :http://download.macromedia.com/get/flashplayer/current/licensing/win/install_flash_player_@@_active_x.exe
# LOCATION      :/usr/local/bin/adobe_flash_npapi_latest.py

import urllib
import urllib2
import json


def get_flash_url():
    """Return the URL of latest Adobe Flash version for Firefox under Windows 10"""
    flash_json_url = 'https://get.adobe.com/flashplayer/webservices/json/?%s'
    flash_json_params = {
        'platform_type': 'Windows',
        'platform_dist': 'Windows 8',
        'platform_arch': '',
        'platform_misc': '',
        'exclude_version': '',
        'browser_arch': '',
        'browser_type': '',
        'browser_vers': '',
        'browser_dist': '',
        'eventname': 'flashplayerotherversions',
    }

    flash_json_params_string = urllib.urlencode(flash_json_params)
    req = urllib2.urlopen(flash_json_url % flash_json_params_string)
    # @TODO HTTP & JSON error handling
    flash = json.loads(req.read())

    # Look for NPAPI
    for version in flash:
        if 'NPAPI' in version['Name']:
            #return version['Version']
            return version['download_url']

    return ''

def main():
    """Print the URL of latest Adobe Flash version"""
    print(get_flash_url())

main()
