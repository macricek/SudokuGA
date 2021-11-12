close all
clc
clear

opt = 2;
if opt == 1
load('results')
bestOne = pools{where,3};
grid
newGrid = fillIn(bestOne,info_my)
else
    load('druhy')
    grid
    newGrid = fillIn(Best,info_my)
    globalMinOfFit = grafFit;
end

if globalMinOfFit(end) ~= 0
[ch, debug] = check(newGrid)        
end

figure
plot(globalMinOfFit)
title('Evolution')
xlabel('Generations')
ylabel('Fitness function')