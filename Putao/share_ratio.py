#!/usr/bin/python

# tested with Python 3.5

import math

def rm_quantifier(text):
    if len(text) <= 1:
        return eval(text)
    if text[-1] in ['g', 'G']:
        return eval(text[:-1])
    if text[-1] in ['m', 'M']:
        return eval(text[:-1])/1024
    if text[-1] in ['t', 'T']:
        return eval(text[:-1])*1024
    if len(text) == 2:
        return eval(text)
    if text[-2:] in ['gb', 'GB']:
        return eval(text[:-2])
    if text[-2:] in ['mb', 'MB']:
        return eval(text[:-2])/1024
    if text[-2:] in ['tb', 'TB']:
        return eval(text[:-2])*1024
    return eval(text)

# obtain the download and upload value; save it in $down and $up
while 1:
    text = input('upload amout (GiB) is: ')
    try:
        up = rm_quantifier(text)
    except:
        print ('Error! A float is expected here.')
    else:
        break
while 1:
    text = input('download amout (GiB) is: ')
    try:
        down = rm_quantifier(text)
    except:
        print ('Error! A float is expected here.')
    else:
        break

# give the correct output
if down >= 400:
    rate = 0.7
elif down >= 200:
    rate = 0.6
elif down >= 100:
    rate = 0.5
elif down >= 50:
    rate = 0.4
else:
    rate = 0.3
if down >= 20 and up/down < rate:
    print (math.ceil((down*rate - up)/10)*2000, 'magic points are needed.')
else:
    print ('No danger!')
