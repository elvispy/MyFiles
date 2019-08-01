//  let's make matrix indexing

a = rand(7, 6, 'normal') * 10

disp(a(4,2)) //printing a value

a(2,2) = 0 //setting a value

b = 1:6

c = b([3, 4])

disp(a([2, 3], [1, 3]))

//Just as matlab, : will select an entire column/row
//to delete a row/column, asign it to a empty matrix

a(3,:) = []

/*
The cat(n, A, B) will concatenate the two arrays through dimension n
*/

A = rand(3,3)

B = rand(3,3)

C = cat(1, A, B)

D = cat(2, A, B)

E = cat(3, A, B)

F = cat(4, A, B)

// Justa as in R, we can do logical operators on arrays, which will return a boolean array

disp(rand(3,3) > rand(3,3))


//linspace is the same as matlab (lineally spaced points)

o = linspace(1, 20, 150)

//logspace will create list of logaritmic spaced points

//triangular upper and triangular lower matrices can be formed with the builtin functions
//tril() and triu()

disp(triu(A))

disp(tril(A)) //remember that tiru does not include the main diagonal

//we also have the ones, zeros and diagonal built in functions

ones(3,3)

zeros(4,3)

diag([1 2 3 4])

//the transpose is obtained using an aphostrophe (')

//other functions are primes(x) returns an array of primes up to x
//factor(n) return the prime factorization of n
//rat(n) gives a rational approximation of n
//perms(array) returns all the permutations of a given array (repeated)