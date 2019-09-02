a = eye(2,2); b = ones(a);
chdir("C:\Users\USUARIO CIAC\Documents\GITRepos\MyFiles\SciLab\CSVPractise")
save('val1.dat', 'a', 'b');
clear a
clear b
load('val1.dat', 'a', 'b');
