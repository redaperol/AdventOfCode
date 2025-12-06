import unittest

from main import part1, part2, better_parser, actual_range

EXAMPLE_RANGE = [
    (3, 5),
    (10, 14),
    (16, 20),
    (12, 18),
]

EXAMPLE_VALUE = [1, 5, 8, 11, 17, 32]

EXAMPLE_INPUT = [
    "3-5",
    "10-14",
    "16-20",
    "12-18"
    "",
    "1",
    "5",
    "8",
    "11",
    "17",
    "32",
]

EXAMPLE_ACTUAL_RANGE = [
    (3, 5),
    (10, 20)
]


class Test_part(unittest.TestCase):
    def test_part1(self):
        self.assertEqual(3, part1(EXAMPLE_RANGE, EXAMPLE_VALUE))

    def test_part2(self):
        self.assertEqual(14, part2(EXAMPLE_RANGE))


class Test_func(unittest.TestCase):

    def test_better_parser(self):
        self.assertEqual((EXAMPLE_RANGE, EXAMPLE_VALUE),  better_parser(EXAMPLE_INPUT))

    def test_actual_range(self):
        self.assertEqual((EXAMPLE_ACTUAL_RANGE),  actual_range(EXAMPLE_RANGE))
