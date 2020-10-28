#!/usr/bin/env python

import titlecase
import re
import fileinput

titleline = re.compile(r'.*title,*(.*)')


def process(line):
    m = titleline.match(line)
    if m:
        print(line[:m.start(1)]
              + titlecase.titlecase(m.group(1)
              + line[m.end(1)]), end='')
    else:
        print(line, end='')


if __name__ == "__main__":
    for line in fileinput.input(inplace=True):
        process(line)
