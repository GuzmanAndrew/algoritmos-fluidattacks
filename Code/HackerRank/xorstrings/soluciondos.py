DATA_FILE = open('DATA.lst', "r")

ONE_DATA = ''
TWO_ONE = ''


def data(param: str) -> str:
    file_open = param
    data_array = file_open.read()
    global ONE_DATA
    global TWO_ONE
    ONE_DATA = data_array[5:10]
    TWO_ONE = data_array[0:5]


data(DATA_FILE)


def strings(param_one: str, param_two: str) -> str:
    array_final = ""
    for i in range(0, 5):
        if param_one[i] == param_two[i]:
            array_final += '0'
        else:
            array_final += '1'

    return array_final


RESULT_FUNCTION = strings(ONE_DATA, TWO_ONE)

print(RESULT_FUNCTION)
