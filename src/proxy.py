#!/usr/bin/env python
# coding: utf-8

dORD=ord('🇦')-ord('A')
import sys, re, yaml
import urllib.parse as url

codes=sys.argv[1:]

types = {'广东专线' : 'IEPL'}
regex = r'^(..) .*?-(.*?) (.*)$'
pattern = re.compile(regex)

def sub(name):
    if not pattern.fullmatch(name):
        return name
    t = pattern.sub('\\2', name)
    t = types.get(t, t)
    return pattern.sub(f'\\1 {t} - \\3', name)

def code2flag(i, d=1):
    o = ''
    for c in i:
        o += chr(ord(c) + d*dORD)
    return o

# Proxies
proxies = []
names = []
for line in sys.stdin:
    o = url.urlparse(line.rstrip())
    qs = url.parse_qs(o.query)
    name = sub(url.unquote(o.fragment))
    param = {'name': name, 
              'type': o.scheme, 
              'server': o.hostname, 
              'port': o.port, 
              'password': o.username, 
              'udp': True, 
              'sni': qs['sni'][0]
              }
    proxies.append(param)
    names.append(name)
yaml.dump({ 'proxies' : proxies }, sys.stdout, default_flow_style=False, allow_unicode=True, sort_keys=False)

# Proxy Groups
groups=[{
    'name': 'PROXY',
    'type': 'select',
    'proxies': []
    }]
for code in codes:
    flag=code2flag(code)
    groups[0]['proxies'].append(flag)
    used=[]
    for name in names:
        if name[:2] == flag:
            used.append(name)
    groups.append({
        'name': flag,
        'type': 'url-test',
        'proxies': used,
        'url': 'http://www.gstatic.com/generate_204',
        'interval': 3600
        })
groups[0]['proxies'].append('🌎')
groups.append({
    'name': '🌎',
    'type': 'select',
    'proxies': names
    })
yaml.dump({ 'proxy-groups': groups }, sys.stdout, default_flow_style=False, allow_unicode=True, sort_keys=False)
