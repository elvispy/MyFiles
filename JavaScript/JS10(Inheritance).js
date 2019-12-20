//JS10, inheritance

class HospitalEmployee {
  constructor(name) {
    this._name = name;
    this._remainingVacationDays = 20;
  }

  get name() {
    return this._name;
  }

  get remainingVacationDays() {
    return this._remainingVacationDays;
  }

  takeVacationDays(daysOff) {
    this._remainingVacationDays -= daysOff;
  }

  static genPass(){
    return Math.floor(Math.random()*10001);
  }//this static method cannot be called on instances, but using the
  //hole class name. It will be inherited from all subclasses
}

class Nurse extends HospitalEmployee {
  constructor(name, certifications) {
    super(name); //to use the constructor of the parent class
    this._certifications = certifications;
  }

  get certifications(){
    return this._certifications;
  }

  addCertification(newCertification){
    this._certifications.push(newCertification);
  }
}

const nurseOlynyk = new Nurse('Olynyk', ['Trauma','Pediatrics']);
nurseOlynyk.takeVacationDays(5);
console.log(nurseOlynyk.remainingVacationDays);
nurseOlynyk.addCertification('Genetics');
console.log(nurseOlynyk.certifications);



//For using in the next script
module.exports = nurseOlynyk;
