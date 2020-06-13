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
    # Convierto mi DATA que es un String en un Array de String
    TYPE_DATA = line.split()
    # Convierto mi Array de String en un Array de Enteros y lo casteo a una lista
    DATA_INT = list(map(int, TYPE_DATA))


DATA_FIND = DATA_INT.count(82)

print(DATA_FIND)

FILE_OPEN.close()

# $ python guzmanandrew.py
# 7
