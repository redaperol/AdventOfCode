import unittest

from main import part1, part2, better_value_parser

EXAMPLE_INPUT = [
    "123 328  51 64",
    "45 64  387 23 ",
    "6 98  215 314",
    "*   +   *   +  ",
]

EXAMPLE_DIC = {
    0: [123, 45, 6],
    1: [328, 64, 98],
    2: [51, 387, 215],
    3: [64, 23, 314]
}


class Test_part(unittest.TestCase):
    def test_part1(self):
        self.assertEqual(4277556, part1(EXAMPLE_INPUT))

    # def test_part2(self):
     #   self.assertEqual(part2())


class Test_func(unittest.TestCase):
    def test_better_value_parser(self):
        self.assertEqual(EXAMPLE_DIC, better_value_parser(EXAMPLE_INPUT[:3]))
    ...
