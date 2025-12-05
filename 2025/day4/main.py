import time


def better_file_reader(file_path: str) -> list[str]:
    with open(file_path, "r") as file:
        return [line.strip() for line in file]


def better_parser(list_str: list[str], char_to_find: str) -> list[list[bool]]:
    list_list = []
    for line_id, line in enumerate(list_str):
        line_list = []
        for char_id, char in enumerate(line):
            if char == char_to_find:
                line_list.append(True)
            else:
                line_list.append(False)
        list_list.append(line_list)
    return list_list


def better_block_evaluator(i, j, threshold: int, bloc_map: list[list[bool]]) -> bool:
    good_block_counter = 0
    directions = [
        (i - 1, j + 1),
        (i, j + 1),
        (i + 1, j + 1),
        (i - 1, j),
        (i + 1, j),
        (i - 1, j - 1),
        (i, j - 1),
        (i + 1, j - 1)
    ]
    counter = 0
    for i_d, j_d in directions:
        max_i = len(bloc_map[j]) - 1
        max_j = len(bloc_map) - 1
        if (i_d < 0 or i_d > max_i) or (j_d < 0 or j_d > max_j):
            good_block_counter += 1
        elif bloc_map[i_d][j_d]:
            good_block_counter += 1

        counter += 1
        if good_block_counter > threshold:
            return True
        elif 8 - counter < threshold - good_block_counter:
            return False

    return False


def generate_map(length, width: int) -> list[tuple]:
    map = []
    for j in range(length):
        for i in range(width):
            map.append((i, j))
    return map


def location_updater(model, to_remove: list[tuple]) -> list[tuple]:
    return [coord for coord in model if coord not in to_remove]


def map_updater(block_map: list[list[bool]], coord: list[tuple]):
    for i, j in coord:
        block_map[i][j] = True


def main():
    input = better_file_reader("./input")
    bloc_map = better_parser(input, ".")

    start = time.time_ns()
    print("Part 1:", part1(input, bloc_map), end='')
    time_part_1 = (time.time_ns() - start) / 1e6
    print(" in", time_part_1, "ms")

    start_part2 = time.time_ns()
    print("Part 2:", part2(input, bloc_map), end='')
    time_part_2 = (time.time_ns() - start_part2) / 1e6
    print(" in", time_part_2, "ms")


def part1(input: list[str], block_map: list[list[bool]]) -> int:
    location_to_visit = generate_map(len(input), len(input[0]))
    block_counter = 0
    for i, j in location_to_visit:
        if better_block_evaluator(i, j, 4, block_map) and not block_map[i][j]:
            block_counter += 1
    return block_counter


def part2(input: list[str], block_map: list[list[bool]]) -> int:
    loc_to_visit = generate_map(len(input), len(input[0]))
    first_time = True
    loc_to_remove = []
    block_counter = 0
    while len(loc_to_remove) != 0 or first_time:
        loc_to_remove = []
        first_time = False
        for i, j in loc_to_visit:
            if block_map[i][j]:
                loc_to_remove.append((i, j))

            elif better_block_evaluator(i, j, 4, block_map):
                block_counter += 1
                loc_to_remove.append((i, j))

        loc_to_visit = location_updater(
            loc_to_visit, loc_to_remove)
        map_updater(block_map, loc_to_remove)
    return block_counter


if __name__ == '__main__':
    main()
