clear all; close all; clc;

mkdir 'HomotypicAdhesion_ExpExpressionConst'
cd 'HomotypicAdhesion_ExpExpressionConst'

hc = [25 75 100];
hd = [25 75 100];
c = [0.05 0.2 10];
d = [0.05 0.2 10];
for x = 1:length(c)
    for y = 1:length(d)
        for z = 1:length(hc)
            for k = 1:length(hd)
                mkdir("1A|1B_SphRad-5.3_HomoC-"+hc(z) +"_HomoD-"+ hd(k) +"_ExpC-"+c(x)+"_ExpD-"+d(y))  
            end
        end
    end
end

cd ..