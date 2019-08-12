lol = pwd();

b = chdir("C:\Users\USUARIO CIAC\Documents\GITRepos\MyFiles\SciLab\CSVPractise");
xd = pwd();

// Save a matrix as csv file format
M = [1:10; 2:11] * 0.1;
filename = fullfile(xd, "data.csv");
csvWrite(M, filename);

// Read as text
//mgetl(filename)

r = csvRead(filename);



chdir(lol);
