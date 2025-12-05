import unittest

from main import part1, part2, location_updater, better_parser

EXAMPLE = [
    "..@@.@@@@.",
    "@@@.@.@.@@",
    "@@@@@.@.@@",
    "@.@@@@..@.",
    "@@.@@@@.@@",
    ".@@@@@@@.@",
    ".@.@.@.@@@",
    "@.@@@.@@@@",
    ".@@@@@@@@.",
    "@.@.@@@.@."
]

MODEL = [(0, 0), (1, 1), (1, 0), (0, 1)]
TO_REMOVE = [(1, 0), (0, 1)]

EXAMPLE_PARSER = ["..@.", "@.@.", "@..@"]

RESULT_BETTER_PARSER = [
    [True, True, False, True],
    [False, True, False, True],
    [False, True, True, False]
]


class Test_part(unittest.TestCase):
    def test_part1(self):
        self.assertEqual(13, part1(EXAMPLE, better_parser(EXAMPLE, '.')))

    def test_part2(self):
        self.assertEqual(43, part2(EXAMPLE, better_parser(EXAMPLE, '.')))


class Test_func(unittest.TestCase):
    def test_map_updater(self):
        self.assertEqual([(0, 0), (1, 1)], location_updater(MODEL, TO_REMOVE))

    def test_better_parser(self):
        self.assertEqual(RESULT_BETTER_PARSER,
                         better_parser(EXAMPLE_PARSER, "."))
