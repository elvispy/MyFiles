/*Now lets talk about boolnea data types
in scilab, True and False are represented by
%T and %F
*/

a = %T;

b = %F;

// The logical opérators are |, & and ~

//Its time to define complex numbers. Just use the complex built-in function

z = complex(2, 3)

real(z)
imag(z)

/*
Arrays are defined by enclosing values separated by spaces or comas
with brackets. Note that complex()is capable of recieving 
two lists as inputs*/

listc = complex([1 3 5 6], [7 3 0 1])
disp(listc)

//Two interesting functions are imult, and isreal
//imult will efficiently multiply the number by %i and 
//isreal will check whether the input has an element 
// which has imaginary part diferent to zero

b = [3 %i]
a = [1 2 3]

isreal(b) //is False
isreal(a) // is true

/