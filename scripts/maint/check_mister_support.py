#!/usr/bin/env python3

# check_mister_support - sairuk
#
# Checks the main MiSTer distro against RetroNAS mister entries and reports differences
#

import os
import yaml
import requests
import json

IGNORED_KEYS = [
    'system_map',
    'system_links'
]

IGNORED_SYSTEMS = [
    "MEMTEST"
]

MISTER_DIRS = [
    'games',
]

MISTER_REPOS = [
    'https://api.github.com/repos/MiSTer-devel/Distribution_MiSTer/git/trees/main?recursive=1',
    'https://api.github.com/repos/MiSTer-DB9/Distribution_MiSTer/git/trees/main?recursive=1',
]

# maybe support these later
"""
https://github.com/MiSTer-LLAPI/LLAPI_folder_MiSTer/tree/main/_LLAPI
https://github.com/jotego/jtcores_mister

"""

RETRONAS_SYSTEMS = 'https://raw.githubusercontent.com/danmons/retronas/main/ansible/retronas_systems.yml'

def _log(s):
    print(s)

def _get(url):
    _log("Getting data from %s" % url)
    r = requests.get(url)
    if r.status_code == 200:
        return r.content
    else:
        _log("Failed to get %s, code was %s" % (url, r.status_code))
    return None


def main():

    mister_systems = []

    # mister github data
    for MISTER_REPO in MISTER_REPOS:
        mister_c = _get(MISTER_REPO)
        if mister_c is not None:
            mister_d = json.loads(mister_c)



            for item in mister_d['tree']:
                for dirs in MISTER_DIRS:
                    if dirs in item['path'] and item['path'].count('/') == 1:
                        filename = item['path'].replace("%s/" % dirs,'')
                        mister_systems.append(filename)
                        #mister_systems.append(filename.split('_')[0])

    # retronas data
    retronas_c = _get(RETRONAS_SYSTEMS)
    if retronas_c is not None:
        retronas_d = yaml.safe_load(retronas_c)

        retronas_mister_systems = []
        for key in retronas_d.keys():
            if key not in IGNORED_KEYS:
                for system in retronas_d[key]:
                    if system['mister'] != "":
                        retronas_mister_systems.append(system['mister'])

    # compare
    _log("Checking for MiSTer Systems not in retronas based on distro repo")
    found = False
    for system in mister_systems:
        if system not in retronas_mister_systems and system not in IGNORED_SYSTEMS:
            _log(" %s" % system)
            found = True

    if not found:
        _log("No missing systems found")

    return

if __name__ == "__main__":
    main()
