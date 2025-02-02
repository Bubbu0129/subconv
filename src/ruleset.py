#!/usr/bin/env python
# coding: utf-8

import sys

sys.stdin.readline()
ruleset=sys.argv[1]
policy=sys.argv[2].upper()

print(f'  # {ruleset} - {policy}')

def print_rule(t, arg):
    print(f'  - {t},{arg},{policy}')

if (ruleset[-4:] == 'cidr'):
    while cidr:=sys.stdin.readline()[5:-2]:
        if ':' in cidr:
            continue # IPV6
        print_rule('IP-CIDR', cidr)
    exit
while line:=sys.stdin.readline():
    if (line[5] == '+'):
        print_rule('DOMAIN-SUFFIX', line[7:-2])
    else:
        print_rule('DOMAIN', line[5:-2])
