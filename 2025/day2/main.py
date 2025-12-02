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
    for i in range(tuple[0], tuple[1] + 1):
        result.append(str(i))
    return result


def create_nchunk(string_eval, number_of_chunk):
    size_chunk = len(string_eval) // number_of_chunk
    start = 0
    end = size_chunk
    result = []
    for c in range(0, number_of_chunk):
        result.append(string_eval[start:end])
        start = end
        end += size_chunk
    return result


def validate_number(num):
    full_length = len(num)
    half_length = full_length // 2
    if num[0:half_length] == num[half_length:]:
        return True
    else:
        return False


def validate_list(list):
    itera = iter(list)
    try:
        first = next(itera)
    except StopIteration:
        return True
    return all(first == x for x in itera)


def validate_Nnumber(number):
    start = len(number)
    while start != 2:
        if len(number) % start == 0:
            to_eval = create_nchunk(number, start)
            if validate_list(to_eval):
                return True
            else:
                start -= 1
        else:
            start -= 1
    return False


san_input = sanitize_input(load_file("./input"))
invalid_number = []
invalid_number2 = []
for numb_range in san_input:
    for num in create_liststring(numb_range):
        if validate_number(num):
            invalid_number.append(int(num))
        elif validate_Nnumber(num):
            invalid_number2.append(int(num))
print("Answer part 1 :", sum(invalid_number))
print("Answer part 2 :", sum(invalid_number) + sum(invalid_number2))
