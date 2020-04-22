"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 5.00/10, +5.00)
"""

import math

FILE_OPEN = open('DATA.lst', 'r')
MESSAGE = FILE_OPEN.read()
DATA = [MESSAGE]

def is_smart_number(number):
    """
    Method for finding the factors
    """
    val = int(math.sqrt(number))
    if num / val == val:
        return True
    return False

for line in DATA:
    TYPE_DATA = line.split()
    DATA_INT = list(map(int, TYPE_DATA))

for line in DATA_INT:
    num = line
    ans = is_smart_number(num)
    if ans:
        print("YES")
    else:
        print("NO")

FILE_OPEN.close()

# $ python cleancamera.py
# YES NO NO YES
