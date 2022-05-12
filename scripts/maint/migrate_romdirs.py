#!/usr/bin/env python3
#
# hacky little script to see if the yaml 
# to migrate directories based on last entry
# in retronas_systems
#
import yaml
import argparse
import os
import shutil

RN_VARS="../../ansible/retronas_vars.yml"
RN_SYSTEMS="../../ansible/retronas_systems.yml"
RN_IGNORE = [
    "system_map",
    "system_links",
    "system_template", 
    "system_unsupported",
    "system_idsoftware",
    "system_tools"
    ]
RN_ROMDIR='roms'

def _log(s):
    print(s)

def read_yaml(ydata):

    with open(ydata,'r') as file:
        try:
            return yaml.safe_load(file)
        except yaml.YAMLError as e:
            _log(e)
            return None

def main():
    yaml_data = None


    if not os.path.exists(RN_VARS):
        _log("vars file not found did you start retronas yet?")
        exit(1)

    rn_vars = read_yaml(RN_VARS)
    rn_path = rn_vars['retronas_path']
    
    rn_systems = read_yaml(RN_SYSTEMS)

    if rn_systems is not None:
        for manufacturer in rn_systems:
            if manufacturer not in RN_IGNORE:
                for system in rn_systems[manufacturer]:

                    # yes our dest here is the src key
                    dest = os.path.join(rn_path,RN_ROMDIR,system['src'])
                    # last location of this system
                    last = os.path.join(rn_path,RN_ROMDIR,system['last'])

                    if system['last'] != "":
                        move = False
                        if os.path.exists(last) and os.path.isdir(last):
                            
                            # parent directory
                            parent = os.path.dirname(dest)
                            if not os.path.isdir(parent):
                                _log("Creating parent directory: %s" % parent)
                                os.makedirs(parent)

                            # if dest is a symlink remove it
                            if os.path.islink(dest):
                                _log("Destination is a symlink, removing: %s" % dest)
                                os.remove(dest)
                                move = True

                            # move if dest isn't a dir
                            if not os.path.isdir(dest):
                                _log("Dest %s, doesn't exist, this is good we can move to this location" % dest)
                                move = True
                            else:
                                _log("Can't move %s, already exists: %s, already migrated?" % (last, dest))
                                move = False

                            # if dest is a file cancel dont move
                            if os.path.isfile(dest):
                                _log("%s is a file, check and remove this manually" % dest)
                                move = False

                            if move:
                                try:
                                    _log("Moving %s to %s" % (last, dest))
                                    shutil.move(last, dest)
                                except:
                                    _log("Move failed for %s" % (last))
                            else:
                                _log("Not moving: %s" % last)

                        else:
                            _log("Not found: %s" % last)
                            pass
                    else:
                        pass


    return


if __name__ == "__main__":
    main()
