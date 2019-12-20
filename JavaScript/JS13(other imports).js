//JS13 other imports

//We saw in JS12 that other means of exporting object were created
//in the ES6 standard. Lets import those objects

//The default export has to be imported in the following way
import flightRequirements from 'JS12(other exports).js';

//Named exports are imported in the following way:
import { availableAirplanes, meetsStaffRequirements} from 'JS12(other exports)';


console.log(flightRequirements.availableAirplanes);

import lolazo from 'JS12(other exports)'; //extension may be omitted
//you can alias an object when importing, even though it was not
//aliased when exported
//ex: import {isLowSodium as saltFree} from 'Menu';

// you can import everything as an object, like python
import * as myobj from 'JS12(other exports).js';
