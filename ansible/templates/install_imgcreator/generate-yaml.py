#!/bin/env python

import os, yaml

from yaml.representer import Representer
from yaml.dumper import Dumper
from yaml.emitter import Emitter
from yaml.serializer import Serializer
from yaml.resolver import Resolver

infile="formats.yml"
outfile="formats-new.yml"


class BlankNone(Representer):
    """
    Print None as blank when used as context manager
    https://stackoverflow.com/questions/37200150/can-i-dump-blank-instead-of-null-in-yaml-pyyaml
    """
    def represent_none(self, *_):
        return self.represent_scalar(u'tag:yaml.org,2002:null', u'')

    def __enter__(self):
        self.prior = Dumper.yaml_representers[type(None)]
        yaml.add_representer(type(None), self.represent_none)

    def __exit__(self, exc_type, exc_val, exc_tb):
        Dumper.yaml_representers[type(None)] = self.prior

def main():
    with open(infile,'r') as i:
        existing = yaml.safe_load(i.read())

    new = {}
    new['formats'] = {}

    for item in existing['formats']:
        for format in existing['formats'][item]:

            new['formats'][item] = {}

            # add new properties
            str_properties = ['platform','fs','ext']
            for property in str_properties:
                try:
                    new['formats'][item][property] = existing['formats'][item][property]
                except:
                    new['formats'][item][property] = None

            dict_properties = ['geometry','media']
            for property in dict_properties:
                try:
                    new['formats'][item][property] = existing['formats'][item][property]
                except:
                    new['formats'][item][property] = {}

            # create geometry section
            section = "geometry"
            properties = ['bytesize','tracks','sectors','sides','seek','layout']
            if section in existing['formats'][item].keys():
                next
            else:
                for property in properties:
                    try:
                        new['formats'][item][section][property] = existing['formats'][item][property]
                    except:
                        new['formats'][item][section][property] = None

            # create media section
            section = "media"
            properties = ['capacity','density','encoding','physical','rpm']
            if section in existing['formats'][item].keys():
                next
            else:
                for property in properties:
                    try:
                        new['formats'][item][section][property] = existing['formats'][item][property]
                    except:
                        new['formats'][item][section][property] = None
                try:
                    new['formats'][item][section]['capacity'] = existing['formats'][item]['media']
                except:
                     new['formats'][item][section]['capacity'] = None

            # add new properties
            str_properties = ['comment']
            for property in str_properties:
                try:
                    new['formats'][item][property] = existing['formats'][item][property]
                except:
                    new['formats'][item][property] = None

            list_properties = ['reference']
            for property in list_properties:
                try:
                    new['formats'][item][property] = existing['formats'][item][property]
                except:
                    new['formats'][item][property] = []


    with BlankNone():
        print(yaml.dump(new, default_flow_style=False, sort_keys=False))
    return


if __name__ == "__main__":
    main()
