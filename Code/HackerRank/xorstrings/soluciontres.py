"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
"""


def strings(param_one: str, param_two: str) -> str:
    """
    comparison of arrays
    """
    array_final = ""
    for i in range(0, 5):
        if param_one[i] == param_two[i]:
            array_final += '0'
        else:
            array_final += '1'

    return array_final


def divide_array() -> str:
    """
    get data file
    """
    file_open = open('DATA.lst', "r")
    data_array = file_open.read()
    one_data = data_array[5:10]
    two_data = data_array[0:5]
    data_final = strings(one_data, two_data)
    print(data_final)


divide_array()
