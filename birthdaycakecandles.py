"""
$ pylint birthday_cake_candles.py
Your code has been rated at 10.00/10 (previous run: 5.00/10, +5.00)

"""

FILE_OPEN = open('DATA.lst', 'r')
MESSAGE = FILE_OPEN.read()

DATA = [MESSAGE]

TYPE_DATA = []

DATA_INT = []


for line in DATA:
    TYPE_DATA = line.split()
    DATA_INT = map(int, TYPE_DATA)


DATA_FIND = DATA_INT.count(82)

print(DATA_FIND)

FILE_OPEN.close()

# $ python birthday_cake_candles.py
# 7
