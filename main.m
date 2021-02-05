clc
clear
close all

grid = [3, 0, 6, 5, 0, 8, 4, 0, 0;
        5, 2, 0, 0, 0, 0, 0, 0, 0; 
        0, 8, 7, 0, 0, 0, 0, 3, 1;
        0, 0, 3, 0, 1, 0, 0, 8, 0; 
        9, 0, 0, 8, 6, 3, 0, 0, 5; 
        0, 5, 0, 0, 9, 0, 6, 0, 0; 
        1, 3, 0, 0, 0, 0, 2, 5, 0; 
        0, 0, 0, 0, 0, 0, 0, 7, 4; 
        0, 0, 5, 2, 0, 6, 3, 0, 0]
    
numOfUnknown = sum(sum(grid == 0));
vector = zeros(1,numOfUnknown);
info_my = findAllBlankPos(grid);


%initialization
numOfMembers = 50;                          % size of population
numOfCycles = 500;
Space = [ones(1,numOfUnknown);ones(1,numOfUnknown)*9];     % rozsah prvkov v retazci
Amp = ones(1,numOfUnknown);                           % rozsah pre aditivnu mutaciu
initPop = round(genrpop(numOfMembers,Space));
fit = fitness(initPop,info_my);
pop = initPop;
minOfFit = zeros(1,numOfCycles);
minOfFit(1) = min(fit);
%GA starting - selection
for i = 2:numOfCycles
bestOne = selbest(pop,fit,1);
sortedBest = selsort(pop,fit,5);
diversityBest = seldiv(pop,fit,4,1);
workPop1 = selsus(pop,fit,15);
workPop2 = seltourn(pop,fit,15);
newPop = genrpop(10,Space);

sortedBest = swapgen(sortedBest, 0.1);
diversityBest = swappart(diversityBest, 0.1);

workPop1 = mutx(workPop1,0.1,Space);
workPop2 = around(workPop2,0,1.25,Space);

pop = [bestOne;sortedBest;diversityBest;workPop1;workPop2;newPop];
pop = change(pop,2,Space);
pop = round(pop);
fit = fitness(pop,info_my);

if min(fit) < minOfFit(i-1)
    minOfFit(i) = min(fit);
else
    minOfFit(i) = minOfFit(i-1);
end
end
bestOne = selbest(pop,fit,1);
newGrid = fillIn(bestOne,info_my)

figure
plot(minOfFit)

function info = findAllBlankPos(grid)
%% gives back information structure contains blank positions to fill
%% info = {row,col}
k = 1;
info{k,1} = 'row';
info{k,2} = 'col';
info{k,3} = 'grid';
info{2,3} = grid;
for i = 1:9
    for j = 1:9
        if grid(i,j) == 0
            k = k + 1;
            info{k,1} = i;
            info{k,2} = j;
        end
    end
end
end
