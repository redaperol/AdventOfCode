import time


def better_file_reader(file_path: str) -> list[str]:
    with open(file_path, "r") as file:
        return [line.strip() for line in file]


def better_value_parser(list_str: list[str]) -> dict[list[int]]:
    dic_value = {}
    for line in list_str:
        for nbr_idx, nbr in enumerate(line.split()):
            if nbr_idx not in dic_value.keys():
                dic_value[nbr_idx] = []
            dic_value[nbr_idx].append(int(nbr))
    return dic_value


def better_value_parser2(list_str: list[str]) -> dict[list[int]]:
    dic_value = {}
    nbr_idx = 0
    for x in range(len(list_str[0]), 0, -1):
        if list_str[-1][x - 1] == " " and list_str[0][x - 1] == " ":
            nbr_idx += 1
        else:
            string = ""
            for y in range(0, len(list_str)):
                string += list_str[y][x - 1]
            if nbr_idx not in dic_value.keys():
                dic_value[nbr_idx] = []
            dic_value[nbr_idx].append(int(string))
    return dic_value


def multiply(list_int: list[int]) -> int:
    results = 1
    for val in list_int:
        results *= val
    return results


def main():
    input = better_file_reader("./input")

    start_part1 = time.time_ns()
    print("Part 1:", part1(input), end='')
    time_part_1 = (time.time_ns() - start_part1) / 1e6
    print(" in", time_part_1, "ms")

    start_part2 = time.time_ns()
    print("Part 2:", part2(input), end='')
    time_part_2 = (time.time_ns() - start_part2) / 1e6
    print(" in", time_part_2, "ms")


def part1(input: list[str]) -> int:
    results = 0
    dic_value = better_value_parser(input[:len(input) - 1])
    operations = input[-1].split()
    for index, operations in enumerate(operations):
        if operations == "+":
            results += sum(dic_value[index])
        else:
            results += multiply(dic_value[index])
    return results


def part2(input: list[str]) -> int:
    results = 0
    dic_value = better_value_parser2(input[:len(input) - 1])
    operations = input[-1].split()
    operations.reverse()
    for index, operations in enumerate(operations):
        if operations == "+":
            results += sum(dic_value[index])
        else:
            results += multiply(dic_value[index])
    return results


if __name__ == '__main__':
    main()
