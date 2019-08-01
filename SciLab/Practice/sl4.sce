/* 
There are global and local variables, just as in other languages.
To define a global variable, use the global reserved word
*/

global x;
x =6
 //You can kill global variables by using
 clearglobal
 
 //and ask whether a variable  is global or not
 isglobal("x") //remember to use the quotes!
 
 //You can ask about the variables with the who command
 
 who('local')
 who('get')
 who('global')
