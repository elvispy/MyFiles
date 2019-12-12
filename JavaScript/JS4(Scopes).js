//Scopes in javaScript
//The scopes are the same as in C++ and python

let myvar = "Hola gente";

function example(){
  let myvar = "Another String";
  console.log("This is " + myvar);
}

example(); //should input This is Another String
