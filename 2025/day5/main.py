import time


def better_file_reader(file_path: str) -> list[str]:
    with open(file_path, "r") as file:
        return [line.strip() for line in file]


def main():
    input = better_file_reader("./input")
    range_list, value_list = better_parser(input)

    start = time.time_ns()
    print("Part 1:", part1(range_list, value_list), end='')
    time_part_1 = (time.time_ns() - start) / 1e6
    print(" in", time_part_1, "ms")

    start_part2 = time.time_ns()
    print("Part 2:", part2(range_list), end='')
    time_part_2 = (time.time_ns() - start_part2) / 1e6
    print(" in", time_part_2, "ms")


def part1(range_list: list[tuple[int]], value_list: list[int]) -> int:
    fresh_counter = 0
    for v in value_list:
        for r in range_list:
            if is_in_range(v, r):
                fresh_counter += 1
                break
    return fresh_counter


def part2(range_list: list[tuple[int]]):
    return calculate_number_id(actual_range(range_list))


def better_parser(list_str: list[str]) -> tuple[list[tuple], list[int]]:
    list_range = []
    list_value = []

    for string in list_str:
        if "-" in string:
            i, j = string.split("-")
            list_range.append((int(i), int(j)))
        elif string:
            list_value.append(int(string))
    return list_range, list_value


def is_in_range(value: int, range_val: tuple[int]) -> bool:
    if range_val[0] <= value and value <= range_val[1]:
        return True
    else:
        return False


def actual_range(list_range: list[tuple[int]]):
    better_list = []
    sorted_range = sorted(list_range)
    # print(sorted_range)
    start_x, candidate_y = sorted_range[0]
    sorted_range.pop(0)
    while len(sorted_range) != 0:
        x, y = sorted_range[0]

        if x <= candidate_y or x == candidate_y + 1:
            candidate_y = y

        else:
            better_list.append((start_x, candidate_y))
            start_x = x
            candidate_y = y

        sorted_range.pop(0)
        if len(sorted_range) == 0:
            if candidate_y > y:
                better_list.append((start_x, candidate_y))
            else:
                candidate_y = y
                better_list.append((start_x, candidate_y))
    # print("-----------------------------------------------------------")
    # print("-----------------------------------------------------------")
    print(better_list)
    return better_list


def calculate_number_id(list_range: list[tuple[int]]) -> int:
    result = 0
    for x, y in list_range:
        # print(y - x + 1)
        result += y - x + 1
    return result


if __name__ == '__main__':
    main()

#  334572241531681
#  334572241531681
#  334572241531695
