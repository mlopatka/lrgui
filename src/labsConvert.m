function labs = labsConvert(loc)
labs = cell(1,size(loc,2));
for k = 1:size(loc,2)
    temp = unique(loc(:,k));
    temp2 = loc(:,k);
    temp3 = zeros([numel(loc(:,k)),1]);

    for i = 1:numel(temp) %implicitly every different label is now a unique integer
        [ind, ind2]= find(ismember(temp2, temp(i)));
        temp3(ind,ind2) = i; %we convert all labels to integer labels.
    end
    labs{k} = temp3;
end
if isa(labs, 'double')
    labs = {labs};
end
