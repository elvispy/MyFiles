//In this script we will see some objects, their methods

//An object seems to be the equivalent of dictionaries in python

let myobj = {
  prop:'This is the value of the property',
  name:123,
  another:{
    lol:1,
    func:'equide'
  },
  printit: () => {
    console.log("Es cuestion de imprimirlo.");
  }
};

console.log(myobj.printit())

//If we wanted to reference the object itself, we need to use the this keyword,
//just as in C++

const goat = {
  dietTYpe:'herbivore',
  makeSound(){
    console.log("baaa");
  },
  diet(){
    console.log(this.dietTYpe);
  }//you cannot use arrow notation
};

goat.diet();


//We want some properties to be static or private to some scope.
//Javascript does not have privacy policies built in, but the convention is to use
//underscore before the variable to pretend that the variable is private.
//To access and set properties of a private value, use setters and getters.

let oneobj = {
  _name:'alo polisia',
  set name(newname){
    if(typeof newname === typeof ''){
      this._name = newname;
    }else{
      console.log("The name must be a string");
    }//end if
  }//end setter
  ,
  get name(){
    return this._name;
  }//end getter
}

console.log(oneobj.name);
