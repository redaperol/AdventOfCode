def add(origin, amount):
    if origin + amount > 99:
        result = (origin + amount) - 100
    else:
        result = origin + amount
    return result


def sub(origin, amount):
    if origin - amount < 0:
        rest = amount - origin
        result = 100 - rest
    else:
        result = origin - amount
    return result


def load_file(path):
    with open(path) as file:
        file_input = file.readlines()
        return file_input


def sanitize_input(list):
    result_list = []
    for line in list:
        input = (line[0], int(line[1:]) % 100)
        result_list.append(input)
    return result_list


def process(tuple, position):
    direction = tuple[0]
    amount = tuple[1]
    if direction == "R":
        return add(position, amount)
    elif direction == "L":
        return sub(position, amount)


input = load_file("./input")
san_input = sanitize_input(input)
position = 50
counter = 0
for i in san_input:
    position = process(i, position)
    if position == 0:
        counter += 1
print("result part 1:", counter)
