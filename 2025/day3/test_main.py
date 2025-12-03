
class Day03Test_part2(unittest.TestCase):
    def test_generatebank2_I(self):
        self.assertEqual(987654321111, generate_bank2("987654321111111"))

    def test_generatebank2_II(self):
        self.assertEqual(811111111119, generate_bank2("811111111111119"))

    def test_generatebank2_III(self):
        self.assertEqual(434234234278, generate_bank2("234234234234278"))

    def test_generatebank2_IV(self):
        self.assertEqual(888911112111, generate_bank2("818181911112111"))

    # def test_part2(self):
    #     self.assertEqual(3121910778619, part2(EXAMPLE))
