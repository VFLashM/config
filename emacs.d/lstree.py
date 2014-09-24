#!/usr/bin/env python2.7

import sys
import os
import pathspec

IGNORED = set([
        '.git',
        '.svn',
        ])

def not_ignored(names, spec):
    ignored = IGNORED
    if spec:
        ignored = IGNORED | set(spec.match_files(names))
    return [name for name in names if not name in ignored]

def lstree(root):
    try:
        with open(os.path.join(root, '.gitignore')) as f:
            spec = pathspec.PathSpec.from_lines(pathspec.GitIgnorePattern, f.readlines())
    except IOError:
        spec = None

    for name in not_ignored(os.listdir(root), spec):
        path = os.path.join(root, name)
        if os.path.isdir(path):
            yield name + '/'
            subnames = [os.path.join(name, subname) for subname in lstree(path)]
            for subname in not_ignored(subnames, spec):
                yield subname
        else:
            yield name
            
assert len(sys.argv) == 2
for name in lstree(os.path.expanduser(sys.argv[1])):
    print name
