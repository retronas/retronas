#!/usr/bin/env python3

import os
import argparse
import yaml
import copy

retronas_systems = "../../ansible/retronas_systems.yml"
ignored = ["system_links"]

def main(args):

    with open(retronas_systems, "r") as input:
        data = yaml.safe_load(input)

    for key in ignored:
        data.pop(key)

    if args.add_new_system or args.add_new_project:
        if args.add_new_system and args.add_new_system not in data.keys():
            new = copy.deepcopy(data["system_template"])
            new[0]['pretty_name'] = args.add_new_system
            data["system_map"].append(new[0])

        if args.add_new_project:
            for key in data.keys():
                for entry in data[key]:
                    if not args.add_new_project in entry.keys():
                        entry[args.add_new_project] = ""

        print(yaml.dump(data, sort_keys=False, default_flow_style=False))

    elif args.check_project:
        chk_ignored = ["system_links"]
        for key in data.keys():
            for entry in data[key]:
                if args.check_project not in entry.keys() and key not in chk_ignored:
                    print(f"{args.check_project} not found in {entry['src']} ({key})")
        print(f"Check for {args.check_project} completed")

    else:
        print("Nothing to do, try asking for --help")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--add-new-system', type=str, help='process system, add new if not exists')
    parser.add_argument('--add-new-project', type=str, help='add new project to all systems')
    parser.add_argument('--check-project', type=str, help='check if project is included in all systems')
    args = parser.parse_args()
    main(args)
