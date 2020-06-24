#!/usr/bin/env python3

"""
$ pylint cleancamera.py
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
"""

DATA_INT = []

def sum_list(listaNumeros: int) -> int:
    laSuma = 0
    for i in listaNumeros:
        laSuma = laSuma + i
    return laSuma

def divide_array() -> str:
    """
    get data file
    """
    FILE_OPEN = open('DATA.lst', 'r')
    MESSAGE = FILE_OPEN.read()
    DATA = [MESSAGE]
    for line in DATA:
      TYPE_DATA = line.split()
      DATA_INT = list(map(int, TYPE_DATA))
    print(sum_list(DATA_INT))

divide_array()

# $ python cleancamera.py
# 10000
