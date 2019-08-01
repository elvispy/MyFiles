#unit testing in python test_calc
import unittest
import calc

class TestCalc(unittest.TestCase):

    def test_add(self):
        self.assertEqual(calc.add(10,5), 15)
        self.assertEqual(calc.add(-1,1), 0)
        self.assertEqual(calc.add(-1,-1), -2)

    def test_multiply(self):
        self.assertEqual(calc.multiply(10,5), 50)
        self.assertEqual(calc.multiply(-1,1), -1)
        self.assertEqual(calc.multiply(-1,-1), 1)

    def test_quotient(self):
        self.assertEqual(calc.quotient(10,5), 2)
        self.assertEqual(calc.quotient(-1,1), -1)
        self.assertEqual(calc.quotient(-1,-1), 1)
        self.assertEqual(calc.quotient(10, 4),2.5)
   
        self.assertRaises(ZeroDivisionError, calc.quotient, 10, 0)
        #Checks whether it raises an error
if __name__ == '__main__':
    unittest.main()


'''Below all the assert methods are listed.
assertEqual(a, b)        a == b

assertNotEqual(a, b)     a != b

assertTrue(x)            bool(x) is True

assertFalse(x)            bool(x) is False

assertIs(a, b)            a is b

assertIsNot(a, b)         a is not b

assertIsNone(x)           x is None

assertIsNotNone(x)        x is not None

assertIn(a, b)            a in b

assertNotIn(a, b)        a not in b

assertIsInstance(a, b)    isinstance(a, b)

assertNotIsInstance(a, b) not isinstance(a,b)


'''
