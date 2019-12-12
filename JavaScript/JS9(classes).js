//JS9, introduction to classes
//Calsses are very similar to python classes
class Dog {
  constructor(name) {
    this._name = name;
    this._behavior = 0;
  }//end of the constructor

  get name(){
    return this._name;
  }

  isBad(){
    console.log(`${this._name} is a bad boy`);
  }
}

const halley = new Dog('Halley'); // Create new Dog instance
console.log(halley.name); // Log the name value saved to halley
// Output: 'Halley'
halley.isBad();
