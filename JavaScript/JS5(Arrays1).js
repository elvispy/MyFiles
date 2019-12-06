//JavaScript Arrays

//Arrays in JS are quite similar to Arrays in Python.

let myarr = ['hola', 2, [2, null, undefined]]; //multiple data types are allowed

console.log(myarr[2][1]); //indexing is the same
//we can index a string value also
var cmamo = 'asdf;lkjj';
console.log(cmamo[4]);

myarr[1] = 42; //reassignment is the same

//some methods

//.pop() will delete last value and return it
//.push(val) will add values separated by commas at the end of the Array
//.indexOf(val) will return the index of the value
//.splice(pos, nb) will remove nb elements from the array starting at pos
// and return them
//.shit() will remoove the first element
//.unshift(val) will add an element to the first part of the list
