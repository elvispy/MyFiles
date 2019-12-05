//We will see the two  ways of declaring functions

//the first way is the way shared by  python and R, not anonymous.

function MyFun(par1, par2 = "Defa") {
  console.log("this is a " + par1 + par2 + "ult argument");
}
//as you can see, par2 is an optional parameter, with identical syntaxis
//to python

MyFun("hola");

//the other way of defining functions is with the idea of anonymous functions

const mymul = function(row, col) {
  return row * col;
}

const another = (s1, s2) => {
  break;
}

//there is a third way of defining functions, called refactoring

const thefun = lavar => lavar * lavar;
