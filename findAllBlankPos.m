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