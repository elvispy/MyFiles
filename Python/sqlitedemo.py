#sqlite demo
import sqlite3
from SQLexample import Employee

#con = sqlite3.connect(':memory:') to create an in memory DB. This DB won's save after its closed.
conn = sqlite3.connect('employee.db') #connects with the database

c = conn.cursor() #this is like a "reader"

##c.execute("""CREATE TABLE employees (
##            first text,
##            last text,
##            pay integer
##            )""")
#So the last piece of code created a table, but an error will be raised
#if you try to uncomment and run it. That's because the table already exists.




#-------------------------------------------

def insert_emp(emp):
    with conn:
        c.execute("INSERT INTO employees VALUES (:first, :last, :pay)", {'first':emp.first,
                                                                'last':emp.last, 'pay':emp.pay})

def select_emp():
    c.execute("SELECT * FROM employees")
    return c.fetchall()

emp_1 = Employee("Juanito", "Alcachofas", 250)
emp_2 = Employee("Jane", "Vera", 9500)
emp_3 = Employee("Dove", "Cameron", 123)
emp_4 = Employee("Hum", "lolazo", 0)

#c.execute("INSERT INTO employees VALUES ('Alexander', 'Vera', 900)")

c.execute("INSERT INTO employees VALUES (?, ?, ?)", (emp_1.first, emp_1.last, emp_1.pay)) #this is one way of using placeholders to pass variables to the class
#this is not unique to insert statements.

#c.execute("INSERT INTO employees VALUES (:first, :last, :pay)", {'first':emp_2.first,
#                                                                'last':emp_2.last, 'pay':emp_2.pay}) #this is the other way of passing placeholders, using dictionaries.
#insert_emp(emp_4)


print(select_emp())

"""
It seems like c.execute (SELECT STATEMENT) is not sufficient to display the results.
For that, we will need the fetchone(), fetchmany(number), fetchall() methods. They will
return a list of tuples with the results. (None if any results were found)

"""

#c.execute("DELETE FROM employees WHERE first = 'Alexander'")

conn.commit() #this saves the changes that we do

conn.close()



