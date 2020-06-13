"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
"""

FILE_OPEN = open('DATA.lst', 'r')
MESSAGE = FILE_OPEN.read()
ARRAY_ONE = MESSAGE[5:10]
ARRAY_SECOND = MESSAGE[0:5]


def strings(one_param: str, second_param: str) -> str:
    """
    comparison of arrays
    """
    array_final = ""
    for i in range(0, 5):
        if one_param[i] == second_param[i]:
            array_final += '0'
        else:
            array_final += '1'

    return array_final


RESULT_FUNCTION = strings(ARRAY_ONE, ARRAY_SECOND)

print(RESULT_FUNCTION)


# $ python cleancamera.py
# 10000

