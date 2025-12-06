import time


def better_file_reader(file_path: str) -> list[str]:
    with open(file_path, "r") as file:
        return [line.strip() for line in file]


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


def part1() -> int:
    results = 0
    return results


def part2():
    results = 0
    return results


if __name__ == '__main__':
    main()
