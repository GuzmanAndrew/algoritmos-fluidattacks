"""
$ pylint birthday_cake_candles.py
Your code has been rated at 10.00/10 (previous run: 5.00/10, +5.00)

"""

AGE_RANGE_THREE = [82, 49, 82, 82, 41, 82, 15, 63, 38, 25]

def birthday_cake_candles(ar_one):
    """Function for validation of candles."""
    print ar_one.count(82)

birthday_cake_candles(AGE_RANGE_THREE)

# $ python birthday_cake_candles.py
# 4
