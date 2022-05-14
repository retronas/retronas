#!/usr/bin/env python3

#
#
#

import os
import json
from random import randint

retronas_json = '../../../config/retronas.json'


def _log(s):
    print(s)

def main():
    if os.path.exists(retronas_json):
        _log("[START] Starting tests")
        try:
            data = None
            with open(retronas_json, 'r') as f:
                data = json.load(f)

            if data is not None:
                _log(" [TEST] JSON config Version: %s" % data['version'])

                # menus titles
                menus = []
                for menu in data['dialog']:
                    menus.append(menu)

                # random item
                menu = randint(0,len(data['dialog'])-1)
                _log(" [TEST] Random Menu: \"%s\"" % data['dialog'][menus[menu]]['title'])

            _log("[RESULT] PASS can process the json data")

        except json.JSONDecodeError as e:
            _log("Failed to read json data: %s" % e)

    else:
        _log("Failed to find %s" % retronas_json)


if __name__ == "__main__":
    main()

