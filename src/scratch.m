selector = [9,38,22,10];
ylabs = {};
counter = 1;
y = [];

for i = selector
   disp(['selector',num2str(i)])
        temp = x(labels==i,:);
        ylabs{counter,1} = [num2str(i),'0_mean'];
        y(counter,:) = mean(temp);
        counter =counter+1;
end