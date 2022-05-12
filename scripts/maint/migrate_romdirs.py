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

def main(args):
    yaml_data = None


    if not os.path.exists(RN_VARS):
        _log("[ERR ] vars file not found did you start retronas yet?")
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
                        move_files = False
                        if os.path.exists(last) and os.path.isdir(last):
                            
                            # parent directory
                            parent = os.path.dirname(dest)
                            if not os.path.isdir(parent):
                                _log("[INFO] Creating parent directory: %s" % parent)
                                os.makedirs(parent)

                            # if dest is a symlink remove it
                            if os.path.islink(dest):
                                _log("[INFO] Destination is a symlink, removing: %s" % dest)
                                os.remove(dest)
                                move = True

                            # move if dest isn't a dir
                            if not os.path.isdir(dest):
                                _log("[INFO] Dest %s, doesn't exist, this is good we can move to this location" % dest)
                                move = True
                            else:
                                _log("[WARN] Can't move %s, already exists: %s, already migrated? (try --file-mode?)" % (last, dest))
                                if args.file_mode:
                                    _log("[INFO] We are in file-mode so flagging to move files instead for %s" % last)
                                    move_files = True
                                move = False

                            # if dest is a file cancel dont move
                            if os.path.isfile(dest):
                                _log("[WARN] %s is a file, check and remove this manually" % dest)
                                move = False

                            # dir mode
                            if move and not move_files:
                                try:
                                    _log("[ OK ] Moving %s to %s (file-mode not needed)" % (last, dest))
                                    shutil.move(last, dest)
                                except:
                                    _log("[WARN] Move failed for %s" % (last))
                            else:
                                _log("[INFO] Flagged for no dir-mode move: %s" % last)


                            # file mode ... though shutil.move was going to cover this but OK.
                            if not move and move_files:
                                _log("[INFO] We are in file-mode")
                                _log("[INFO] We will be COPYING found files and confirm they are preset in %s before removing it from %s" % (dest, last))
                                _log("[INFO] Space is the final frontier, so you'll need enough")
                                try:
                                    # loop over the old dir files
                                    for root, dirs, files in os.walk(last):
                                        for filename in files:
                                            dest_file = os.path.join(dest, filename)
                                            src_file = os.path.join(last, filename)
                                            
                                            # check src filesize for use later
                                            src_stat = os.path.getsize(src_file)
                                            _log("[INFO] %s size is %s" % (src_file, src_stat))

                                            # check disk usage
                                            if shutil.disk_usage(dest).free <= src_stat:
                                                _log("[ERR ] You are out of space on %s, free up space and try try again" % dest)
                                                exit(1)

                                            # copy the file
                                            _log("[INFO] Attempting to COPY file %s to %s" % (src_file, dest_file))
                                            shutil.copy2(src_file, dest_file)

                                            # check dest filesize for use later
                                            dest_stat = os.path.getsize(dest_file)
                                            _log("[INFO] %s size is %s" % (dest_file, dest_stat))

                                            # only remove the file if the copy was successful
                                            # this way the user will have at least one copy
                                            if os.path.exists(dest_file) and os.path.isfile(dest_file) and src_stat == dest_stat:
                                                _log("[ OK ] %s exists, is a file and is the correct size, so it is OK to remove the old file" % dest)
                                                os.remove(src_file)
                                                if not os.path.exists(src_file):
                                                    _log("[ OK ] %s removed successfully from %s" % (src_file, last))

                                    # remove the empy src dir
                                    try:
                                        _log('[INFO] Trying to remove the old  dir %s' % last)
                                        os.rmdir(last)
                                        if not os.path.exists(last):
                                            _log("[ OK ] %s removed successfully" % last)
                                    except:
                                        _log('[WARN] Could not remove the old  dir %s, do that manually' % last)

                                except:
                                    _log("[WARN] Move failed for %s" % last)
                            else:
                                _log("[INFO] Flagged for no file-mode move: %s" % last)


                        else:
                            _log("[ OK ] Not found: %s, do not need to migrate" % last)
                            pass
                    else:
                        pass


    return


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='validate retronas_systems.yml')
    parser.add_argument('--file-mode', help='move the individual files (default is dir-mode)', default=False, const=True, nargs='?', required=False)
    args = parser.parse_args()
    main(args)
