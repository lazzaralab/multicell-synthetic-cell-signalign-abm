clear all; close all; clc;

param = "d-express-thresh";

mkdir(param)
cd(param)

e = [9 10 11];

for y = 1:length(e)
   mkdir("1A|1B_SphRad-5.3_"+param+"-"+ e(y))
end

cd ..