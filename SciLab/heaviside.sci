function y = heaviside(x)
  [r, c] = size(x);
  y = zeros(r, c);
  y(x == 0) = 1/2;
  y(x > 0) = 1;
endfunction
