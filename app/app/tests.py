"""
Simple tests
"""
from django.test import SimpleTestCase

from app import calc


class CalcTests(SimpleTestCase):
    """ Test th calc module. """

    def test_add_numbers(self):
        """ Test adding numbers together. """
        res = calc.add(5, 6)

        self.assertEquals(res, 11)

    def test_subtract_numbers(self):
        """Test Subtracting numbers. """
        res = calc.subtract(10, 15)

        self.assertEqual(res, 5)
