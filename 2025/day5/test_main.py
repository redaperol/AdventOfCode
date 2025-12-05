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



class Test_part(unittest.TestCase):
    def test_part1(self):
        self.assertEqual(3, part1(EXAMPLE_RANGE, EXAMPLE_VALUE))



class Test_func(unittest.TestCase):

    def test_better_parser(self):
        self.assertEqual((EXAMPLE_RANGE, EXAMPLE_VALUE),  better_parser(EXAMPLE_INPUT))

