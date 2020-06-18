#!/usr/bin/env python3

"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
"""


def sum_function(file) -> int:
    """
    Method for sum
    """
    sum_one = 0
    for i in file:
        sum_one = sum_one + i

    print(sum_one)


def divide_array() -> str:
    """
    get data file
    """
    file_open = open('DATA.lst', "r")
    data_file = file_open.read()
    # En la lista recorrermos del caracter en la posicion 3 hasta la 163
    one_data = data_file[3:163]
    # La lista la pasamos a una sola, separando por coma cada paquete de numero como string
    data_convert = one_data.split()
    # Los elementos de la lista la pasamos a entero y la volvemos a meter en una lista
    convert_int = list(map(int, data_convert))
    sum_function(convert_int)


divide_array()

# $ python cleancamera.py
# 27098
