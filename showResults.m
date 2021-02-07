close all
clc
clear

load('results')
bestOne = pools{where,3};
grid
newGrid = fillIn(bestOne,info_my)

if globalMinOfFit(end) ~= 0
[~, debug] = check(newGrid)        
end

figure
plot(globalMinOfFit)
title('Evolution')
xlabel('Generations')
ylabel('Fitness function')