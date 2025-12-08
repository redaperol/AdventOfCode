import unittest

from main import part1, part2, find_min_distance

EXAMPLE_INPUT = [
    [162, 817, 812],
    [57, 618, 57],
    [906, 360, 560],
    [592, 479, 940],
    [352, 342, 300],
    [466, 668, 158],
    [542, 29, 236],
    [431, 825, 988],
    [739, 650, 466],
    [52, 470, 668],
    [216, 146, 977],
    [819, 987, 18],
    [117, 168, 530],
    [805, 96, 715],
    [346, 949, 466],
    [970, 615, 88],
    [941, 993, 340],
    [862, 61, 35],
    [984, 92, 344],
    [425, 690, 689],
]


class Test_part(unittest.TestCase):
    def test_part1(self):
        self.assertEqual(part1())

    def test_part2(self):
        self.assertEqual(part2())


class Test_func(unittest.TestCase):
    def test_min_distance_I(self):
        self.assertEqual([425, 690, 689], find_min_distance([162, 817, 812], EXAMPLE_INPUT))

    def test_min_distance_II(self):
        self.assertEqual([162, 817, 812], find_min_distance([431, 825, 988], EXAMPLE_INPUT))
    ...
