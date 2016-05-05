

inFile = 'H:\Physics Lab 3\supercondutors\resultsFromHen\first\200416_1447_Gavish_T_I_V.txt';
tempInstances = [1:503:15593, 15594];

for ind = 1:length(tempInstances)-1
    data(:,:,ind) = dlmread(inFile,'\t',[tempInstances(ind)+1, 0, tempInstances(ind+1)-2, 4]);
end

figure
hold all
for ind = 1:size(data,3)
    plot3(data(:,3,ind),data(:,4,ind),data(:,5,ind))
end
xlabel('T')
ylabel('I')
zlabel('V')