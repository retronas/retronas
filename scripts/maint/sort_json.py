#!/usr/bin/env python3

#
# reindex items in a menu
# code is fairly jank but will do for now
#


import os, json, argparse

def main(args):

    tmp = {}
    input_file = args.input

    if os.path.exists(input_file):
        data = None
        with open(input_file, 'r') as f:
            data = json.load(f)

        menu = data["menu"]
        items = []

        # grab items and stick them in a temp dict
        back = None
        for item in menu["items"]:
            if item["title"] != "Back":
                tmp[item["title"]] = item
            else:
                back = item
     
        # soft the dict
        tmp_sorted = sorted(tmp.items())
        tmp_sorted.insert(0, ( "Back", back ))
        
        for idx, item in enumerate(tmp_sorted):
            entry = item[1]
            pidx = str(idx + 1).zfill(2)
            entry["index"] = pidx
            items.append(entry)

        data["menu"]["items"] = items

        output_data = json.dumps(data)
        print(output_data)

    return

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('--input', type=str, required=True)

    args = parser.parse_args()
    main(args)