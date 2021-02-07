function [fine, debug] = check(member)
    fine = 0;   %initial
    sequences = parse(member);
    debug = {};
    
    for i = 1:9
        [fine,debugR] = validate(member(i,:),fine,{'Row';i});      %Row Check
        [fine,debugC] = validate(member(:,i),fine,{'Col';i});      %Col Check
        [fine,debugLG] = validate(sequences(i,:),fine,{'LG';i});   %Little Grid Check
        debug = [debug,debugR,debugC,debugLG];
    end
end

function [fine, debug] = validate(sequence, fine, cellInfo)
debug = {};
    for number = 1:9
        all = sum(sequence == number);
        if all > 1
            fine = fine + all - 1;
            debug = [cellInfo;{number;all-1}];
        end
    end
end

function sequences = parse(grid)
startingPointsR = [1,4,7,1,4,7,1,4,7];
startingPointsC = [1,1,1,4,4,4,7,7,7];
sequences = zeros(9);
for i=1:9
    pom = 1;
    for j=startingPointsR(i):startingPointsR(i)+2
        for k=startingPointsC(i):startingPointsC(i)+2
            sequences(i,pom) = grid(j,k);
            pom = pom + 1;
        end
    end
end
end