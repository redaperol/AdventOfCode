def load_file(path):
    with open(path) as file:
        return file.read()


def sanitize_input(string_input):
    san_input = []
    split = string_input.split(",")
    for i in split:
        x, y = i.split("-")
        san_input.append((int(x), int(y)))
    return san_input


def create_liststring(tuple):
    result = []
    for i in range(tuple[0], tuple[1]+1):
        if len(str(i)) % 2 == 0:
            result.append(str(i))
    return result


def validate_number(num):
    full_length = len(num)
    half_length = full_length//2
    if num[0:half_length] == num[half_length:]:
        return True
    else:
        return False


san_input = sanitize_input(load_file("./input"))
invalid_number = []
for numb_range in san_input:
    for num in create_liststring(numb_range):
        # print("evalutating :", num)
        if validate_number(num):
            print("Invalid_number :", num)
            invalid_number.append(int(num))
print("Answer part 1 :", sum(invalid_number))
