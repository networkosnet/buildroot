#!/usr/bin/env python2.7
# Interprets mini language for creating binary image
import argparse
import sys
import shutil
import os

parser = argparse.ArgumentParser()
parser.add_argument('output', help='target file')
ns = parser.parse_args()

def parse_size(s):
    mul = 1
    if s.endswith('k'):
        mul = 1024
        s = s[:-1]
    return int(s) * mul

def write_zeros(file, n):
    while n:
        s = min(n, 4096)
        file.write('\0' * s)
        n -= s

output = open(ns.output + '.tmp', 'wb')

for lineno, line in enumerate(sys.stdin):
    line = line.strip()
    if not line or line.startswith('#'):
        continue

    cmd, arg = line.split(None, 1)
    print('%s %s' % (cmd, arg))

    if cmd == 'cat':
        input = open(arg, 'rb')
        shutil.copyfileobj(input, output)
    elif cmd == 'writehex':
        output.write(arg.decode('hex'))
    elif cmd == 'pad':
        size = parse_size(arg)
        current = output.tell()
        delta = size - (current % size)
        write_zeros(output, delta)
    elif cmd == 'seek':
        target = parse_size(arg)
        current = output.tell()
        if current > target:
            sys.exit('line %d: attempted to seek backwards (from %d to %d)' % (lineno, current, target))
        delta = target - current
        write_zeros(output, delta)
    elif cmd == 'check':
        target = parse_size(arg)
        current = output.tell()
        if current > target:
            sys.exit('line %d: image too big!' % (lineno, current, target))
    else:
        sys.exit('line %d: bad command %r' % (lineno, cmd))

print('final size: %dk' % int(output.tell() / 1024))
output.close()
os.rename(ns.output + '.tmp', ns.output)
