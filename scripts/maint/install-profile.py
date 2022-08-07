#!/usr/bin/env python3

import os
import json
import argparse
import subprocess

from configparser import ConfigParser


rn_dir = "/opt/retronas"
rn_ansible_runner = os.path.join(rn_dir, "lib/ansible_runner.sh")


def ini2dict(profile):
    if os.path.exists(profile):

        config= ConfigParser()
        config.read(profile)
        return config
    else:
        print("Couldn't read from profile: %s" % profile)

    return None

def ansible_run(profile):
    p = subprocess.Popen([rn_ansible_runner, profile])
    p.wait()
    return

def main(args):

    config = ini2dict(args.profile)
    if config is not None:
        for item in config["package"]:
            ansible_run(item)
    return



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='replay installation profile')
    parser.add_argument('--profile', help='profile name to replay', type=str, required=True)
    args = parser.parse_args()
    main(args)