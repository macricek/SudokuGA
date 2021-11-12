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
vector = fillUnknown(grid);
info_my = findAllBlankPos(grid);
pop = repmat(vector,numOfMembers,1);
fit = fitness(pop,info_my);
grafFit = zeros(1,numCycle);
minFit = min(fit);
for i=1:numCycle
    Best = selbest(pop,fit,1);              % jeden najlepsi                                        [1]
    NewPop = repmat(vector,9,1);           % vyber 9 najlepsich                              [9]
    SortPop = seltourn(pop,fit,20);          % prva pracovna populacia                              [20]
    WorkPop = selsort(pop,fit,20);           % druha pracovna populacia                              [20]
                                                                                                   %[50]
    SortPop = swapgen(SortPop,0.2);         %vymenenie poradia 10% sanca
    WorkPop = swappart(WorkPop,0.15);       %poriadne casti, 8%sanca
    
    pop = [SortPop;NewPop;WorkPop;Best];     %spojenie do jedneho
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
        break
    end
end

function vector = fillUnknown(grid)
vector = [];
for i=1:9
    row = grid(i,:); 
    [~,u] = fillRow(row);
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
