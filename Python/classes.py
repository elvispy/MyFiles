#I Will use this script as an example using classes
import requests
class Employee:
    """ This is the doc string """
    num_of_emps=0
    raise_amt=1.05

    def __init__(self, first, last, pay):
        self.first=first
        self.last=last
        self.pay=pay
        #self.email=first + "." + last + "@gmail.com" #email should depend
        #on first and last, that is why we are creating a property

		
        Employee.num_of_emps += 1
    @property #so now you call employee.fullname, not employee.fullname() anymore
    def fullname(self):
        return "{0.first} {0.last}".format(self)
        

    @property
    def email(self):
        return "{0.first}.{0.last}@gmail.com".format(self)
    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amt)


    #This is a Dunder/Magic method

    def __repr__(self):
        #What this dunder does is print out information about the
        #employee in a user-friendly manner
        #so when you ask about an instance it won't return you <class Employee>
        #but rather the format you give python to print.
        return "Employee('{}','{}', {})".format(self.first, self.last,
                                                 self.pay)

    def __str__(self):
        #This is another way of printing the same thing, but with the print() method
        return '{} - {}'.format(self.fullname(), self.email)


    def __add__(self,other):
        #this is another example, it will emulate the sum of two numbers
        return self.pay+other.pay


    def __len__(self):
        #Another example of a magic function, using len
        return len(self.fullname())
    #This is the end of the dunders
	
    @classmethod
    def set_raise_amt(cls,amount):
        cls.raise_amt=amount

    @classmethod
    #This is a class method, so it has to recieve the class as
    #the first argument
    def from_string(cls, emp_str):
        first, last, pay = emp_str.split("-")
        return cls(first, last, pay)
    
    @staticmethod
##    """ This is a static method. So it does not recieve any arguments related to
##        any instance or the class itself.
##    """
    def is_workday(day):
        if day.weekday() in [5,6]:
            return False
        return True


    def monthly_schedule(self, month):
        response = requests.get('https://www.facebook.com/')

        if response.ok:
            return response.text
        else:
            return "Bad getaway!"

class Developer(Employee):
    raise_amt=1.07 #will change the raise amount of all Developers

    def __init__(self,first,last,pay,language):
        super().__init__(first,last,pay) #This will call Employee to
        #fill all data that we dont wan to code again here

        #We can also use Employee.__init__(self, first, last, pay)
        self.language=language


class Manager3(Employee):

    def __init__(self, first, last, pay, employees=None):
        super().__init__(first, last, pay)
        if employees is None:
            self.employees = []
        else:
            self.employees = employees

    def add_emp(self, employ):
        if employ not in self.employees:
            self.employees.append(employ)

    def remove_emp(self, employ):
        if employ  in self.employees:
            self.employees.remove(employ)

    def print_emps(self):
        for emp in self.employees:
            print("-->",emp.fullname())

        
emp_1 = Employee("Elvis", "Aguero", 1000)
emp_2= Employee("Test", "Employee", 500)

Dev_1 = Developer('Sissi','Vera',3000,'Visual Basic')
Dev_2 = Developer("Ana","Rizitos",2500,"Cmamo")

Man_1=Manager3("Mom", "An", 10000,[emp_2, Dev_1])


#print(emp_1.pay)
emp_1.apply_raise()
#print(emp_1.pay)

##Python has two useful builtin functions isinstance() and issubclass()
## remember that inheritance preserves instantiation


## Another comment: Methods which begin and end with "__" are called Dunders
