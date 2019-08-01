//While loop
i = 1 
while i<20
    disp(i)
    i = 2 * i;
    disp("Esto es una cadena de texto")
    
end

//for loop

for i = 1:10
    if modulo(i, 3) == 0
        disp("c mamo")
        disp(i)
    end
end

//if statement
i = 0
if i == 3 then
    disp("val1")
elseif i>-1 then
    disp("val2")
else
    disp("lolazo")
end

//we also have the switch case structure
x = input("lolazo: ")
switch x
case 1
    disp("es igual a uno")
case 2
    disp("es igual a dos")
case 3
    disp("es igual a 3")
otherwise
    disp("sorry numero equivocado")
end
