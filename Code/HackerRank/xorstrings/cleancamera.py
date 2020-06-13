s = [1, 0, 1, 0, 1]
t = [0, 0, 1, 0, 1]
r = []

def strings_xor(s, t):
    for i in range(len(s)):
        if s[i] == t[i]:
            r.append('0')
        else:
            r.append('1')

    cadena = " ".join(r)
    result = cadena.replace(" ", "")
    enter = int(result)
    return enter

print(strings_xor(s, t))

-------------------------------------- SEGUNDA SOLUCION -------------------------------

"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 5.00/10, +5.00)
"""

FILE_OPEN = open('DATA.lst', 'r')
MESSAGE = FILE_OPEN.read()
s = MESSAGE[5:10]
t = MESSAGE[0:5]

def strings_xor(s, t):
    """
    comparison of arrays
    """
    res = ""
    for i in range(len(s)):
        if s[i] == t[i]:
            res = res + '0';
        else:
            res = res + '1';

    return res


print(strings_xor(s, t))

# $ python cleancamera.py
# 10000

-------------------------------------- TERCERA SOLUCION -------------------------------

"""
$ pylint cleancamera.py.py
Your code has been rated at 10.00/10 (previous run: 10.00/10, +0.00)
"""

FILE_OPEN = open('DATA.lst', 'r')
MESSAGE = FILE_OPEN.read()
ARRAY_ONE = MESSAGE[5:10]
ARRAY_SECOND = MESSAGE[0:5]

def strings_xor(one_param, second_param):
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


print(strings_xor(ARRAY_ONE, ARRAY_SECOND))

# $ python cleancamera.py
# 10000

