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



def part1(range_list: list[tuple[int]], value_list: list[int]) -> int:
    fresh_counter = 0
    for v in value_list:
        for r in range_list:
            if is_in_range(v, r):
                fresh_counter += 1
                break
    return fresh_counter




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




if __name__ == '__main__':
    main()
