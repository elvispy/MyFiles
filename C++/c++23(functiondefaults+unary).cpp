#include<iostream>


int VolBox(unsigned int a = 2, unsigned int b = 3, unsigned int c=4){
	//Training default values on functions. Observe that the default ones should be on the 
	//rightmost position of the function parameter list. That is, if b is a default argument, c must also be a default arguments,
	//unless you change the position of the variables. 
	
	
	
	
	//if you put as default b and c, and ommit b in a function call, you then  MUST OMMIT  c in that call. That's why the order
	//matters as you can only ommit in certain order
	
	return a * b * c;
}





//this is another topíc: You can actually define variables outside the main functio and then use them inside other functions, using the unary operator
int number = 12;

int funct(int a = 3){
	return a * ::number;
}

int main(void ){
	int number = 10;
	std::cout << VolBox( 1, 1, 1) << "\n";
	std::cout << "However, the default value is: " << VolBox() << "\n";
	
	
	
	std::cout << "See that (local) " << number << " is different from " << ::number << " (global) \n";
	
	std::cout << funct();
	
	
	return 0;
}
