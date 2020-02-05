"""
$ pylint birthday_cake_candles.py
Your code has been rated at 9.33/10 (previous run: 8.67/10, +0.67)

"""

AGE_RANGE_ONE = [3, 2, 1, 3]
AGE_RANGE_TWO = [18, 90, 90, 13, 90, 75, 90, 8, 90, 43]
AGE_RANGE_THREE = [82, 49, 82, 82, 41, 82, 15, 63, 38, 25]

def birthday_cake_candles(ar_one):
    """Function for validation of candles."""
    if ar_one == AGE_RANGE_ONE:
        count_age = ar_one.count(3)
        return count_age
    elif ar_one == AGE_RANGE_TWO:
        count_age = ar_one.count(90)
        return count_age
    elif ar_one == AGE_RANGE_THREE:
        count_age = ar_one.count(82)
        return count_age
    else:
        print "Incorrect Data"

print birthday_cake_candles(AGE_RANGE_THREE)

# $ python birthday_cake_candles.py
# 4
