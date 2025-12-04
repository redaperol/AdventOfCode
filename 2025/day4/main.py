import time


def better_file_reader(file_path: str) -> list[str]:
    with open(file_path, "r") as file:
        return [line.strip() for line in file]


def better_parser(list_str: list[str], char_to_find: str) -> dict:
    dic = {}
    for line_id, line in enumerate(list_str):
        line_dic = {}
        for char_id, char in enumerate(line):
            if char == char_to_find:
                line_dic[char_id] = True
            else:
                line_dic[char_id] = False
        dic[line_id] = line_dic
    return dic


def better_block_evaluator(i, j, threshold: int, bloc_map: dict) -> bool:
    good_block_counter = 0
    directions = {
        "top_left":  (i - 1, j + 1),
        "top":       (i, j + 1),
        "top_right": (i + 1, j + 1),
        "left":      (i - 1, j),
        "right":     (i + 1, j),
        "bot_left":  (i - 1, j - 1),
        "bot":       (i, j - 1),
        "bot_right": (i + 1, j - 1)
    }
    for d in directions:
        i_d = directions[d][0]
        j_d = directions[d][1]
        max_i = max(bloc_map[j].keys())
        max_j = max(bloc_map.keys())
        if (i_d < 0 or i_d > max_i) or (j_d < 0 or j_d > max_j):
            good_block_counter += 1
        elif bloc_map[i_d][j_d]:
            good_block_counter += 1

    if good_block_counter > threshold:
        return True
    else:
        return False


def generate_map(length, width: int) -> list[tuple]:
    map = []
    for j in range(width):
        for i in range(width):
            map.append((i, j))
    return map


def map_updater(model, to_remove: list[tuple]) -> list[tuple]:
    return [coord for coord in model if coord not in to_remove]


def main():
    input = better_file_reader("./input")
    start = time.time_ns()
    print("Part 1:", part1(input), end='')
    time_part_1 = (time.time_ns() - start) / 1e6
    print(" in", time_part_1, "ms")

    # start_part2 = time.time_ns()
    # print("Part 2:", part2(input), end='')
    # time_part_2 = (time.time_ns() - start_part2) / 1e6
    # print(" in", time_part_2, "ms")


def part1(input: list[str]) -> int:
    location_to_visit = generate_map(len(input), len(input[0]))
    bloc_map = better_parser(input, ".")
    block_counter = 0
    for coord in location_to_visit:
        i = coord[0]
        j = coord[1]
        if better_block_evaluator(i, j, 4, bloc_map) and not bloc_map[i][j]:
            block_counter += 1
    return block_counter


if __name__ == '__main__':
    main()
