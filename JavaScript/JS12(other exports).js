//JS12 other kind of exports
//There are other two types of exports. Default exports and
//named exports.
//First lets define some objects to export

let availableAirplanes = [{
 name: 'AeroJet',
 fuelCapacity: 800,
 availableStaff: ['pilots', 'flightAttendants', 'engineers',
  'medicalAssistance', 'sensorOperators'],
},
{name: 'SkyJet',
 fuelCapacity: 500,
 availableStaff: ['pilots', 'flightAttendants']
}];

let flightRequirements = {
  requiredStaff: 4,
};

function meetsStaffRequirements(availableStaff, requiredStaff) {
  if (availableStaff.length >= requiredStaff) {
    return true;
  } else {
    return false;
  }
};
//Next is  the default export syntax: It will export that variable
//But be careful, only one export is allowed per snippet
export default flightRequirements;

//This is the Named export syntax: It will export every variable
//individually
export { availableAirplanes, meetsStaffRequirements};

//we can also export a variable as soon as it's defined.
export let thevar = 1;

//it is possible to export a variable changing its name

export {thevar as lolazo};
