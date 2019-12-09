//JS iterators
//In this script we will see some built-in iterators methods for lists

const mylist = [1, 2, 'tre', 'qattre', [5, 'six']];

//First, we have the forEach method
//the syntax is list.forEach(function)

mylist.forEach(lalis => { console.log(lalis)}); //will apply the fuction to every elements

//THe map function returns an Array

const myresult = mylist.map(arg => {
  return ((typeof arg === typeof 1) ? 0 : arg[0]);
});

console.log(myresult);

//the filter method will filter your list.

const nonnumbers = mylist.filter(arg => {return typeof arg !== typeof 0});
console.log(nonnumbers); //just non number


//find index method
const animals = ['hippo', 'tiger', 'lion', 'seal', 'cheetah', 'monkey', 'salamander', 'elephant'];

const foundAnimal = animals.findIndex(arg => {return arg === 'elephant'}); //eill equal to last index

//we also have the reduce function, which will return only one value

const newNumbers = [1, 3, 5, 7];

const newSum = newNumbers.reduce((accumulator, currentValue) => {
  console.log('The value of accumulator: ', accumulator);
  console.log('THe value of currentValue: ', currentValue);
  return accumulator + currentValue;
}, 10);

console.log(newSum)//is 26
