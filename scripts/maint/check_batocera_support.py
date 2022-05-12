#!/usr/bin/env python3

# check_batocera_support - sairuk
#
# Checks the main batocera distro against RetroNAS batocera entries and reports differences
# gitlab paginates the response max 100 and is moving to keyset based pagination in the reponse headers

import os
import yaml
import requests
import json
import time

IGNORED_KEYS = [
    'system_map',
    'system_links'
]

IGNORED_SYSTEMS = []
BATOCERA_SYSTEMS = 'https://raw.githubusercontent.com/batocera-linux/batocera.linux/master/package/batocera/emulationstation/batocera-es-system/es_systems.yml'
RETRONAS_SYSTEMS = 'https://raw.githubusercontent.com/danmons/retronas/main/ansible/retronas_systems.yml'


def _log(s):
    print(s)

def _get(url):
    _log("Getting data from %s" % url)
    pagination = None
    next_page = None
    r = requests.get(url)
    if r.status_code == 200:
        if "Link" in r.headers:
            pagination = r.headers['Link'].split('<')
            last_page = pagination[2].split(';')[0]
            next_page = pagination[1].split(';')[0]
            if next_page == last_page:
                next_page = None
            else:
                next_page = r.headers['Link'].split('; ')[0].replace('<','').replace('>','')
        return [r.content, next_page]
    else:
        _log("Failed to get %s, code was %s" % (url, r.status_code))
    return None

def main():

    # batocera data
    batocera_systems = []
    batocera_c = _get(BATOCERA_SYSTEMS)

    if batocera_c is not None:
        batocera_d = yaml.safe_load(batocera_c[0])

        for key in batocera_d.keys():
            batocera_systems.append(key)
  
    # retronas data
    retronas_c = _get(RETRONAS_SYSTEMS)
    if retronas_c is not None:
        retronas_d = yaml.safe_load(retronas_c[0])

        retronas_batocera_systems = []
        for key in retronas_d.keys():
            if key not in IGNORED_KEYS:
                for system in retronas_d[key]:
                    if system['batocera'] != "":
                        retronas_batocera_systems.append(system['batocera'])

    _log("Checking against %s found Batocera systems" % len(batocera_systems))
    _log("Checking against %s found RetroNAS (Batocera) systems" % len(retronas_batocera_systems))
    # compare
    _log("Checking for Batocera Systems not in RetroNAS")
    found = False

    # batocera -> retronas
    for system in batocera_systems:
        if system not in retronas_batocera_systems and system not in IGNORED_SYSTEMS:
            _log(" %s" % system)
            found = True

    if not found:
        _log("-- No missing systems found Batocera->RetroNAS (excluding ignored)")

    # retronas -> batocera
    _log("Checking for RetroNAS Systems no longer in Batocera")
    _log("-- Note: These should be cleaned up, Batocera has removed support")
    for system in retronas_batocera_systems:
        if system not in batocera_systems and system not in IGNORED_SYSTEMS:
            _log(" %s" % system)
            found = True

    if not found:
        _log("-- No missing systems found RetroNAS->Batocera (excluding ignored)")

    return

if __name__ == "__main__":
    main()
