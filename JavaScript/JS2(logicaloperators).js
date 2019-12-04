//Basic logical operators in JavaScript
var myBool = false;
let myAge = 21;
//the if statement is identical to the one in R:
if (myBool) { //implicit evaluation, same as python
  console.log("Elvisitante"); //this way you print out information to the user
} else if (myBool === false) {
  console.log("You can add strings just like python" + " jojo " + myAge);
} else {
  myAge = 20; //you dont need to use var the second time you use a variable
}

//it is possible to use ternary operators, also, just as c++
var mybo = myAge > 12 ? "You can drive" : "Drive not recommended.";

//js also has switch cases:
switch (myAge) {
  case 0:
  case 1:
    console.log("Valio madres"); //these two will take the same output.
    break; //same as python
  case 14:
    console.log("Este tambien");
    break; //break is intended to kill the switch statement.
  case 21:
    console.log("Ahora si prro");
    break;
  default:
    mybo = true;
}
