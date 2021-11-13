clc
clear
close all
loaded = 1;

%initialization
numOfMembers = 50;                          % size of population
numCycle = 100000;

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
[vector,k] = fillUnknown(grid);
info_my = findAllBlankPos(grid);
pop = repmat(vector,numOfMembers,1);
fit = fitness(pop,info_my);
grafFit = zeros(1,numCycle);
minFit = min(fit);
for i=1:numCycle
    Best = selbest(pop,fit,1); 
    newPop = processGenetic(pop,fit,k);                    
    
    pop = [newPop;Best];     
    fit = fitness(pop,info_my);
    [minFitnew,indx]=min(fit);          %zistenie minima
        
    if minFitnew<minFit                 %kontrola, ci sa naslo nove minimum
        minFit=minFitnew;                   %ak ano, prepise sa
    end
    i
    minFit
    grafFit(i)=minFit;                      %graffit uchova najlepsie hodnoty jednotlivych cyklov
    if minFit == 0
        grafFit = grafFit(1:i);
        save('results3','Best','grafFit','grid','info_my');
        break
    end
end

function newPop = processGenetic(pop, fit, k)
    TournPop = seltourn(pop,fit,4);          
    TournPop = swappart(TournPop,0.25);
    
    NewPop = selsort(pop,fit,25);    
    WorkPop = seltourn(pop,fit,20);  
    minFit = min(fit);
    sanca = 0.05*minFit;
    if sanca < 0.1
        sanca = 0.1;
    end
    if sanca > 0.6
        sanca = 0.6;
    end
    pocet = length(k);
    idx_start = 1;
    idx_end = 0;
    NewPop1 = [];
    WorkPop1 = [];
    
    for i=1:pocet
        %temp = [];
        idx_end = idx_end + k(i);
        temp = NewPop(:,idx_start:idx_end);
        temp = swapgen(temp, sanca);
        NewPop1 = [NewPop1, temp];
        %temp = [];
        temp = WorkPop(:,idx_start:idx_end);
        temp = shake(temp, 0.1);
        WorkPop1 = [WorkPop1, temp];
        
        idx_start = idx_start + k(i);
    end
    newPop = [TournPop;NewPop1;WorkPop1];
end

function [vector,k] = fillUnknown(grid)
vector = [];
for i=1:9
    row = grid(i,:); 
    [~,u] = fillRow(row);
    k(i) = length(u);
    vector = [vector,u];
end
end

function [row,unknown] = fillRow(row)
unknown = [];
for i=1:9
    now = sum(row == i);
    if now == 0
        unknown = [unknown, i];
    end
end
j=1;
for i=1:9
    if row(i) == 0
        row(i) = unknown(j);
        j=j+1;
    end
end

end
