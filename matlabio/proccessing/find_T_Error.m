folder = 'C:\Users\Dan Wexler\Documents\school\year 3\lab3\superconductors\sc\data\080316\';
f1 = csvread([folder,'3-cooling.csv'],3,2);
Time1 = f1(:,1);
TempRes1 = f1(:,2);
SampVolt1 = f1(:,3);
f2 = csvread([folder,'4-cooling.csv'],3,2);
Time2 = f2(:,1);
TempRes2 = f2(:,2);
SampVolt2 = f2(:,3);

V = linspace(1e-5,min([max(abs(SampVolt1)),max(abs(SampVolt2))]),1e3);
T1 = pt100_convert(interp1(abs(SampVolt1(abs(SampVolt1)>1e-5)),TempRes1(abs(SampVolt1)>1e-5),V),0);
T2 = pt100_convert(interp1(abs(SampVolt2(abs(SampVolt2)>1e-5)),TempRes2(abs(SampVolt2)>1e-5),V),0);

figure
plot(T1(2:end),abs(T1(2:end)-T2(2:end)))

% and it shows that max difference is ~2.75 kelvin so it is legitimate to
% assume ±1.4 degrees error