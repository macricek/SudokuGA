clc
clear
close all
loaded = 1;

grid = [3, 0, 6, 5, 0, 8, 4, 0, 0;
        5, 2, 0, 0, 0, 0, 0, 0, 0; 
        0, 8, 7, 0, 0, 0, 0, 3, 1;
        0, 0, 3, 0, 1, 0, 0, 8, 0; 
        9, 0, 0, 8, 6, 3, 0, 0, 5; 
        0, 5, 0, 0, 9, 0, 6, 0, 0; 
        1, 3, 0, 0, 0, 0, 2, 5, 0; 
        0, 0, 0, 0, 0, 0, 0, 7, 4; 
        0, 0, 5, 2, 0, 6, 3, 0, 0];
    
numOfUnknown = sum(sum(grid == 0));
vector = zeros(1,numOfUnknown);
info_my = findAllBlankPos(grid);


%initialization
numOfMembers = 450;                          % size of population
numOfCycles = 100000;
intervalOfMigration = 100;
global numOfPools;
numOfPools = 9;
Space = [ones(1,numOfUnknown);ones(1,numOfUnknown)*9];      % rozsah prvkov v retazci
Amp = [ones(1,numOfUnknown)*0.5;ones(1,numOfUnknown)*3];     % rozsah pre aditivnu mutaciu
initPop = round(genrpop(numOfMembers,Space));
if loaded
    load('savedres');
    start = length(globalMinOfFit);
else
pools{1,1} = 'PopOfPool';
pools{1,2} = 'Fitness';
pools{1,3} = 'BestOneFromPool';
pools{1,4} = 'BestFitnessFromPool';
pools{1,5} = 'Passing';
fit = fitness(initPop,info_my);

for k = 1:numOfPools
pools{k+1,1} = initPop(k*50-49:k*50,:);
pools{k+1,2} = fit(k*50-49:k*50);
pools{k+1,4} = inf;
end
start = 2;
globalMinOfFit = zeros(1,numOfCycles);
globalMinOfFit(1) = min(fit);
end

%% GA starting - selection
for i = start:start+numOfCycles-1
    if mod(i,intervalOfMigration) == 0
        pools = migrate(pools);
    end
for j = 2:numOfPools+1
    pop = pools{j,1};
    minclen = pools{j,3};
    fit = fitness(pop,info_my);
    bestOne = selbest(pop,fit,1);
    diversityBest = seldiv(pop,fit,15,1);       %15
    workPop1 = selsus(pop,fit,15);              %15
    workPop2 = seltourn(pop,fit,15);            %15
    newPop = genrpop(4,Space);                  %5
                                                %50    
    %operations
    if mod(j,3) == 0
        diversityBest = swappart(diversityBest, 0.1);
        workPop1 = mutx(workPop1,0.2,Space);
        workPop2 = around(workPop2,0,1.25,Space);
    elseif mod(j,3) == 1
        diversityBest = swapgen(diversityBest, 0.1);
        workPop1 = mutx(workPop1,0.1,Space);
        workPop2 = around(workPop2,0,1.25,Space);
    else
        diversityBest = swapgen(diversityBest, 0.2);
        workPop1 = mutx(workPop1,0.15,Space);
        workPop2 = mutm(workPop2,0.2,Amp,Space);
    end
    %LOCAL min
    pop = [bestOne;diversityBest;workPop1;workPop2;newPop];
    pop = change(pop,2,Space);
    pop = round(pop);
    
    fit = fitness(pop,info_my);
    [localMinimum,idxMin] = min(fit);
    if localMinimum < pools{j,4}
        pools{j,3} = pop(idxMin,:);  %store best one
        pools{j,4} = localMinimum;
    end
    pools{j,1} = pop;
    pools{j,2} = fit;
    
    if mod(i,intervalOfMigration) == intervalOfMigration-1
        pools{j,5} = seldiv(pop,fit,3,1);
    end
end 
    [globalMinOfFit(i),where] = globalMin(pools);
    if mod(i,1000) == 0
    globalMinOfFit(i)
    i
    end
    if globalMinOfFit(i) == 0
        disp('Solved');
        break
    end
end

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

function pools = migrate(pools)
[sizeOfMigrationPart, ~] = size(pools{2,5});
[membersOfPop, ~]   =    size(pools{2,1});
global numOfPools
numOfMigrated = sizeOfMigrationPart*(numOfPools-1);
needToBePickedBy = membersOfPop - numOfMigrated;

    for i=2:numOfPools+1
        pop = pools{i,1};
        fit = pools{i,2};
        passing = pass(pools, i);
        fromOld = seltourn(pop,fit,needToBePickedBy);
        pop = [passing;fromOld];
        pools{i,1} = pop;
        pools{i,2} = NaN;
    end
end

function passing = pass(pools, numOfPool)
global numOfPools
passing = [];
    for i=2:numOfPools+1
        if i ~= numOfPool
            act = pools{i,5};
            passing = [passing;act];
        end
    end
end

function [absoluteMin,where] = globalMin(pools)
global numOfPools
absoluteMin = inf;
    for i=2:numOfPools+1
        if pools{i,4} < absoluteMin
        absoluteMin = pools{i,4};
        where = i;
        end   
    end
end

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
