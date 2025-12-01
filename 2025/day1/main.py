def add(origin, amount):
    if origin + amount > 99:
        result = (origin + amount) - 100
    else:
        result = origin + amount
    return result


def sub(origin, amount):
    if origin - amount < 0:
        rest = amount - origin
        result = 99 - rest + 1
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
        input = (line[0], int(line[1:]))
        result_list.append(input)
    return result_list


def calculating_rotation(position, amount, direction, new_position):
    counter = 0
    cross_over = 0
    complete_rotation = amount // 100
    remainer = amount % 100

    if new_position == 0 and position != 0:
        counter = 1

    if new_position != 0 and position != 0:
        if direction == "L" and (position - remainer) < 0:
            cross_over = 1

        elif direction == "R" and (position + remainer) > 100:
            cross_over = 1

    rotation = complete_rotation + cross_over
    return rotation, counter


def process(tuple, position):
    direction = tuple[0]
    amount = tuple[1]
    san_amount = amount % 100
    if direction == "R":
        new_position = add(position, san_amount)
    elif direction == "L":
        new_position = sub(position, san_amount)
    rotation, counter = calculating_rotation(position, amount, direction, new_position)
    return new_position, rotation, counter


input = load_file("./input")
san_input = sanitize_input(input)
position = 50
counter = 0
rotation = 0
for i in san_input:
    position, nbr_rotation, nbr_counter = process(i, position)
    rotation += nbr_rotation
    counter += nbr_counter
    print("value", i, position, "counter", counter, "rotation", rotation)
print("result part 1:", counter)
print("result part 2:", counter + rotation)
