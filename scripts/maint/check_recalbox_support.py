#!/usr/bin/env python3

# check_recalbox_support - sairuk
#
# Checks the main recalbox distro against RetroNAS recalbox entries and reports differences
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

IGNORED_SYSTEMS = [
    '.templates'
]

REPOS = [
    'https://gitlab.com/api/v4/projects/2396494/repository/tree?path=package/recalbox-romfs2/systems&per_page=100&pagination=keyset&page_token=keyset',
]

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

    # recalbox data
    recalbox_systems = []
    dataset = []
    for repo in REPOS:
        data = _get(repo)
        dataset.append(data[0])
        while data[1] is not None:
            data = _get(data[1])
            dataset.append(data[0])
            time.sleep(2)

    data_names = []
    for data_items in dataset:
        json_data = data_items.decode('utf-8')
        data_names.append(json.loads(json_data))

    for setname in data_names:
        for entry in setname:
            recalbox_systems.append(entry['name'])

  
    # retronas data
    retronas_c = _get(RETRONAS_SYSTEMS)
    if retronas_c is not None:
        retronas_d = yaml.safe_load(retronas_c[0])

        retronas_recalbox_systems = []
        for key in retronas_d.keys():
            if key not in IGNORED_KEYS:
                for system in retronas_d[key]:
                    if system['recalbox'] != "":
                        retronas_recalbox_systems.append(system['recalbox'])

    _log("Checking against %s found Recalbox systems" % len(recalbox_systems))
    _log("Checking against %s found RetroNAS (Recalbox) systems" % len(retronas_recalbox_systems))
    # compare
    _log("Checking for Recalbox Systems not in RetroNAS")
    found = False

    # recalbox -> retronas
    for system in recalbox_systems:
        if system not in retronas_recalbox_systems and system not in IGNORED_SYSTEMS:
            _log(" %s" % system)
            found = True

    if not found:
        _log("-- No missing systems found RecalBox->RetroNAS (excluding ignored)")

    # retronas -> recalbox
    _log("Checking for RetroNAS Systems no longer in RecalBox")
    _log("-- Note: These should be cleaned up, RecalBox has removed support")
    for system in retronas_recalbox_systems:
        if system not in recalbox_systems and system not in IGNORED_SYSTEMS:
            _log(" %s" % system)
            found = True

    if not found:
        _log("-- No missing systems found RetroNAS->RecalBox (excluding ignored)")

    return

if __name__ == "__main__":
    main()
