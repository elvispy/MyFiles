disp("Define three variables named a, b, c");

a = 10

b = 12.2

c = a*b

disp("Checking if the variables have been defined as a, c, b")
disp(isdef("a"))
disp(isdef("b"))
disp(isdef("c"))
disp("After clearing the vairable a")
clear a
disp(isdef("a"))
disp(isdef("b"))
disp(isdef("c"))

