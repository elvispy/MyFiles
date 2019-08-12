a = eye(2,2); b = ones(a);
save('val1.dat', 'a', 'b');
clear a
clear b
load('val1.dat', 'a', 'b');
