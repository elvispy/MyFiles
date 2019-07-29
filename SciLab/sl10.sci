function [sqr] = escuer(val1)
    sqr = val1 * val1;
endfunction


function n = recursive(lol)
    if lol == 1 then
        n = 1
    else
        n = lol * recursive(lol-1)
    end
endfunction

//there is an equivalent to lambda expressions, the deff 
//statement  recieves two inputs enclosed by aphostrophes and defines a function

deff('[y] = oper(a, b)', 'y = a/b;')




