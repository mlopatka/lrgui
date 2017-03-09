function ADJ = makeAdjascencyMatrix(dCell)
LRThresh = 1.6;

data  = [];
counter = 1;

for i = 1:size(dCell, 2)
    if isnumeric(dCell{1,i})
        data(:,counter) = cell2mat(dCell(:,i));
        counter=counter+1;
    end
end

lr = data(:,end);

ADJ = squareform(lr)>LRThresh;
