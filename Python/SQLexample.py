
class Employee:
    """A sample employee class """

    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay

    @property
    def email(self):
        return'{} {}@hotmail.com'.format(self.first, sef.last)

    def __str__(self):
        return "Employee('{}', '{}', {})".format(self.first, self.last, self.pay)
