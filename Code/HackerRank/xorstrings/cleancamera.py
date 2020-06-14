#!/usr/bin/env python3

# El comando de arriba sirve para soluciona los errores 1 y 2 de abajo
#1 = ./cleancamera.py: line 8: syntax error near unexpected token `('
#2 = ./cleancamera.py: line 8: `FILE_OPEN = open("DATA.lst", "r")'

"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
"""

def strings():
    """
    comparison of arrays
    """
    file_open = open("DATA.lst", "r")
    data_array = file_open.read()
    array_one = data_array[5:10]
    array_second = data_array[0:5]

    array_final = ""
    for i in range(0, 5):
        if array_one[i] == array_second[i]:
            array_final += '0'
        else:
            array_final += '1'

    return array_final


RESULT_FUNCTION = strings()

print(RESULT_FUNCTION)

# $ python cleancamera.py
# 10000
