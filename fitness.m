function fit = fitness(pop,info)

[numOfMembers, ~] = size(pop);
    fit = zeros(1,numOfMembers);
    for i=1:numOfMembers
        member = fillIn(pop(i,:), info);
        fit(i) = check(member);
    end
end

function fine = check(member)
    fine = 0;   %initial
    sequences = parse(member);
    for i = 1:9
        fine = validate(member(i,:),fine);      %Row Check
        fine = validate(member(:,i),fine);      %Col Check
        fine = validate(sequences(i,:),fine);   %Little Grid Check
    end
end

function fine = validate(sequence,fine)
    for number = 1:9
        all = sum(sequence == number);
        if all > 1
            fine = fine + all - 1;
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