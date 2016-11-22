#!/usr/bin/env python3

# Copyright (C) 2016, Mert Bora ALPER <bora@boramalper.org>
# All rights reserved.


from os.path import expanduser
from sys import argv, exit


def main():
    # When invoked without any argument, print the length of the history log.
    if len(argv) == 1:
        count = 0
        with open(expanduser("~/.local/share/fish/fish_history")) as hist_log:
            for line in hist_log:
                if line.startswith("- cmd: "):
                    count += 1   
        print(count - 1)

    # When invoked with a single integer argument, print the history entry at
    # that position (zero-indexed) in the following format:
    #
    #     <PROGRAM> [ARGUMENTS ...] [PATHS ...]
    #     [PATH 0]
    #     [PATH 1]
    #       ...
    #     [PATH n]
    #
    elif len(argv) == 2:
        req_i = int(argv[1])
        assert req_i >= 0

        with open(expanduser("~/.local/share/fish/fish_history")) as hist_log:
            i = 0
            while i <= req_i:
                line = hist_log.readline()
                if line.startswith("- cmd: "):
                    i += 1
                elif not line:
                    exit("{}: error: EOF (i={} is too large)".format(argv[0], i))

            print(line[7:].strip())  # cmd

            assert hist_log.readline().startswith("  when: ")

            if hist_log.readline().startswith("  paths:"):
                while True:
                    path = hist_log.readline()
                    if path.startswith("    - "):
                        print(path[6:].strip())  # path
                    else:
                        break
    else:
        exit("{}: error: wrong number of arguments".format(argv[0]))


if __name__ == "__main__":
    exit(main())
