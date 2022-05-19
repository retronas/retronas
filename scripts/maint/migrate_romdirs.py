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

def _log(s, level=0):
    log_level = "INFO"
    if level >= 1:
        log_level = "WARN"
    elif level >= 2:
        log_level = "ERRR"
    
    print("[%s] %s" % (log_level, s))

def read_yaml(ydata):
    with open(ydata,'r') as file:
        try:
            return yaml.safe_load(file)
        except yaml.YAMLError as e:
            _log(e)
            return None

def process_dir(dirname, tree=[]):
    # loop over the old dir files
    _log("Building entries for %s" % dirname)
    dir_contents = os.listdir(dirname)
    for entry in dir_contents:
        path = os.path.join(dirname, entry)
        if os.path.isdir(path):
            process_dir(path, tree)
        else:
            tree.append(path)
            path = None
    return tree

def main(args):
    yaml_data = None

    if not os.path.exists(RN_VARS):
        _log("vars file not found did you start retronas yet?", 2)
        exit(1)

    rn_vars = read_yaml(RN_VARS)
    rn_path = rn_vars['retronas_path']
    
    rn_systems = read_yaml(RN_SYSTEMS)

    if rn_systems is not None:
        for manufacturer in rn_systems:
            if manufacturer not in RN_IGNORE:
                for system in rn_systems[manufacturer]:

                    if system['last'] != "":
                        entries = []
                        # yes our dest here is the src key
                        dest = os.path.join(rn_path,RN_ROMDIR,system['src'])
                        # last location of this system
                        last = os.path.join(rn_path,RN_ROMDIR,system['last'])

                        move = False
                        move_files = False
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
                                _log("Can't move %s, already exists: %s, already migrated? (try --file-mode?)" % (last, dest), 1)
                                if args.file_mode:
                                    _log("We are in file-mode so flagging to move files instead for %s" % last)
                                    move_files = True
                                move = False

                            # if dest is a file cancel dont move
                            if os.path.isfile(dest):
                                _log("%s is a file, check and remove this manually" % dest, 1)
                                move = False

                            # dir mode
                            if move and not move_files:
                                try:
                                    _log("Moving %s to %s (file-mode not needed)" % (last, dest))
                                    shutil.move(last, dest)
                                except:
                                    _log("Move failed for %s" % (last), 1)
                            else:
                                _log("Flagged for no dir-mode move: %s" % last)


                            # file mode ... though shutil.move was going to cover this but OK.
                            if not move and move_files:
                                _log("We are in file-mode")
                                _log("We will be COPYING found files and confirm they are preset in %s before removing it from %s" % (dest, last))

                                # loop over the old dir files
                                entries = process_dir(last, [])
                                _log("Found %d file(s) for %s" % ( len(entries), last))
                                for entry in entries:
                                    # dirs
                                    last_dirname = os.path.dirname(entry)
                                    dest_dirname = os.path.dirname(entry).replace(last, dest)

                                    if not os.path.exists(dest_dirname):
                                        _log("Creating directory %s" % dest_dirname )
                                        os.makedirs(dest_dirname)
                                        dest_dirname = None

                                    # files
                                    src_file = entry
                                    dest_file = entry.replace(last, dest)

                                    if src_file == dest_file:
                                        _log("something is wrong, src/dest should not match, exiting", 2)
                                        exit(1)

                                    # check src filesize for use later
                                    src_stat = os.path.getsize(src_file)
                                    _log("%s size is %s" % (src_file, src_stat))

                                    # check disk usage
                                    if shutil.disk_usage(dest).free <= src_stat:
                                        _log("You are out of space on %s, free up space and try try again" % dest, 2)
                                        exit(1)
                                    else:
                                        _log("You have enough free space on %s for %s" % (dest, dest_file))
                                        # copy the file
                                        _log("Attempting to COPY file %s to %s" % (src_file, dest_file))
                                        if not os.path.exists(dest_file):
                                            shutil.copy2(src_file, dest_file)
                                        else:
                                            _log("Destination %s already exists, it will be checked against the src file in the next step" % dest_file)

                                        if os.path.exists(dest_file):
                                            # check dest filesize for use later
                                            dest_stat = os.path.getsize(dest_file)
                                            _log("%s size is %s" % (dest_file, dest_stat))

                                            # only remove the file if the copy was successful
                                            # this way the user will have at least one copy
                                            if os.path.exists(dest_file) and os.path.isfile(dest_file) and src_stat == dest_stat:
                                                _log("%s exists, is a file and is the correct size, so it is OK to remove the old file" % dest_file)
                                                os.remove(src_file)
                                                if not os.path.exists(src_file):
                                                    _log("%s removed successfully from %s" % (src_file, last))
                                            else:
                                                _log("%s exists, but does not match %s remove it manually to replace" % (dest, src_file), 2)
                                        else:
                                            _log("%s does not exist, can't process a file that not there" % src_file, 1)

                                    """
                                    # remove the empy src dir
                                    if os.path.exists(last_dirname):
                                        _log('Trying to remove the old dir %s' % last_dirname)
                                        try:
                                            os.rmdir(last_dirname)
                                        except OSError as e:
                                            _log("Directory %s isn't empty yet, going for another round" % last_dirname)

                                    if not os.path.exists(last_dirname):
                                        _log("%s removed successfully" % last_dirname)
                                    """

                            else:
                                _log("Flagged for no file-mode move: %s" % last)
                            _log("----")

                        else:
                            _log("Not found: %s, do not need to migrate" % last)
                            pass
                    else:
                        pass


    return


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='validate retronas_systems.yml')
    parser.add_argument('--file-mode', help='move the individual files (default is dir-mode)', default=False, const=True, nargs='?', required=False)
    args = parser.parse_args()
    main(args)
