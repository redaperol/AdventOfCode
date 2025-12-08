import time
from math import sqrt


def better_file_reader(file_path: str) -> list[str]:
    with open(file_path, "r") as file:
        return [line.strip() for line in file]


def parser(input: list[str]) -> list[int]:
    result = []
    for line in input:
        result.append([int(x) for x in line.split(',')])
    return result


def main():
    input = better_file_reader("./input")

    start_part1 = time.time_ns()
    print("Part 1:", part1(input), end='')
    time_part_1 = (time.time_ns() - start_part1) / 1e6
    print(" in", time_part_1, "ms")

    # start_part2 = time.time_ns()
    # print("Part 2:", part2(input), end='')
    # time_part_2 = (time.time_ns() - start_part2) / 1e6
    # print(" in", time_part_2, "ms")


def part1(list_points: list[list[int]]) -> int:
    list_neighbour = []
    ...
    return list_neighbour


def part2():
    results = 0
    return results


def get_distance(list_A, list_B: list[int]) -> float:
    xa, ya, za = list_A
    xb, yb, zb = list_B
    return sqrt((xa - xb)**2 + (ya - yb)**2 + (za - zb)**2)


def find_min_distance(list_A: list[int], list_B: list[list[int]]) -> list[int]:
    candidate_distance = 9999999
    candidate_point = []
    for point in list_B:
        distance = get_distance(list_A, point)
        if distance < candidate_distance and distance != 0:
            candidate_point, candidate_distance = point, distance
    return candidate_point


if __name__ == '__main__':
    main()
