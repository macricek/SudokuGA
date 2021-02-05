function newGrid = fillIn(vector,info)
%% fills grid with vector of generated numbers
    oldGrid = info{2,3};
    newGrid = oldGrid;
    for i = 1:length(vector)
        row = info{i+1,1};
        col = info{i+1,2};
        numberInVector = vector(i);
        if oldGrid(row,col) == 0
            newGrid(row,col) = numberInVector;
        else
            disp('You rewrote wrong pos!');
        end
    end
end