#!/usr/bin/env python3
#
# hacky little script to see if the yaml 
# is parsable -- sairuk
#
import yaml
import argparse

RN_SYSTEMS="../../ansible/retronas_systems.yml"
RN_IGNORE = [
    "system_map",
    "system_links",
    "system_template", 
    "system_unsupported",
    "system_idsoftware",
    "system_tools"
    ]

def main(args):

    keymatch = args.key

    yaml_data = None
    with open(RN_SYSTEMS,'r') as file:
        try:
            yaml_data = yaml.safe_load(file)
        except yaml.YAMLError as e:
            print(e)

    if yaml_data is not None:
        print("RETRONAS SYSTEMS output, data is good, no data is :'(")
        print("-" * 130)
        print("{:<30} | {:<40} | {:30}".format("manufacturer", "romdir", "key:%s" % keymatch))
        print("-" * 130)
        for manufacturer in yaml_data:
            if manufacturer not in RN_IGNORE:
                for system in yaml_data[manufacturer]:
                    if keymatch in system:
                        print("{:<30} | {:<40} | {:30}".format(manufacturer, system['src'], system[keymatch]))
    return


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='validate retronas_systems.yml')
    parser.add_argument('--key', help='match this key in the yaml', type=str, default='src', required=False)
    args = parser.parse_args()
    main(args)
