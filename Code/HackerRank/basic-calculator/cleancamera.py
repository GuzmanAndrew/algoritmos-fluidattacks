"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
"""

FILE_OPEN = open('DATA.lst', 'r')
MESSAGE = FILE_OPEN.read().split(" ")
ARRAY_ONE = MESSAGE[0]
ARRAY_SECOND = MESSAGE[1]
NUM_ONE = float(ARRAY_ONE)
NUM_TWO = int(ARRAY_SECOND)

def sum_one(param_one, param_two):
    """
    Method of addition
    """
    sum_num = param_one + param_two
    print(sum_num)

def res_one(param_one, param_two):
    """
    Method of subtraction
    """
    res_num = param_one - param_two
    print(res_num)

def mul_one(param_one, param_two):
    """
    Method for multiplication
    """
    mul_num = param_one * param_two
    print(mul_num)

def div_one(param_one, param_two):
    """
    Method of division
    """
    div_num = param_one / param_two
    div_decimal = round(div_num, 2)
    print(div_decimal)

def quo_div(param_one, param_two):
    """
    quotient method
    """
    div_int = param_one // param_two
    print(div_int)

sum_one(NUM_ONE, NUM_TWO)
res_one(NUM_ONE, NUM_TWO)
mul_one(NUM_ONE, NUM_TWO)
div_one(NUM_ONE, NUM_TWO)
quo_div(NUM_ONE, NUM_TWO)

# $ python cleancamera.py
# 6.3
# -1.7
# 9.2
# 0.57
