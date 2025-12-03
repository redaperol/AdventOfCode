import time


def parser(input: str) -> list[str]:
    return [line for line in input.splitlines()]


def find_max(list_int: list[int]) -> int:
    max_candidate = max(list_int)
    if list_int.index(max_candidate) != len(list_int) - 1:
        return max_candidate
    else:
        i, max_candidate = 0, 0
        while i < len(list_int) - 1:
            if int(list_int[i]) > max_candidate:
                max_candidate = int(list_int[i])
            i += 1
        return max_candidate


def find_second_max(list_int: list[int], first_max: int) -> int:
    first_max_index = list_int.index(first_max)
    short_list = list_int[first_max_index + 1:]
    return max(short_list)


def generate_bank(string: str) -> int:
    list_int = [int(c) for c in string]
    first_max = find_max(list_int)
    second_max = find_second_max(list_int, first_max)
    return int(str(first_max) + str(second_max))


def part1(input) -> int:
    battery_list = []
    parsed = parser(input)
    for line in parsed:
        battery_list.append(generate_bank(line))
    return sum(battery_list)


if __name__ == '__main__':
    with open("./input") as f:
        input = f.read().strip()

    start = time.time_ns()
    print("Part 1:", part1(input), end='')
    time = (time.time_ns() - start) / 1e6
    print(" in", time, "ms")
