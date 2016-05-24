% R_b is bad - H dependent

figure
hold on
for ind = 1:length(THI070416_prcssd.tempMean)
    for jnd = 1:length(THI070416_prcssd.coilCurr{ind})
       scatter3(THI070416_prcssd.tempMean{ind}(jnd),THI070416_prcssd.coilCurr{ind}(jnd),THI070416_prcssd.fitData1{ind}{jnd}.a,100,THI070416_prcssd.fitData1{ind}{jnd}.a,'.','MarkerFaceColor',[0 0 0])
    end
end
for ind = 1:length(THI040416_prcssd.tempMean)
    for jnd = 1:length(THI040416_prcssd.coilCurr{ind})
       scatter3(THI040416_prcssd.tempMean{ind}(jnd),THI040416_prcssd.coilCurr{ind}(jnd),THI040416_prcssd.fitData1{ind}{jnd}.a,15,THI040416_prcssd.fitData1{ind}{jnd}.a)
    end
end

set(gca,'CLim',[0 3e-3]);

%arbitrary fit for phase change
figure
hold on
for ind = 1:length(THI070416_prcssd.tempMean)
    for jnd = 1:length(THI070416_prcssd.coilCurr{ind})
       scatter3(THI070416_prcssd.tempMean{ind}(jnd),THI070416_prcssd.coilCurr{ind}(jnd),THI070416_prcssd.fitData2{ind}{jnd}.b,100,THI070416_prcssd.fitData2{ind}{jnd}.b,'.')
    end
end
for ind = 1:length(THI040416_prcssd.tempMean)
    for jnd = 1:length(THI040416_prcssd.coilCurr{ind})
       scatter3(THI040416_prcssd.tempMean{ind}(jnd),THI040416_prcssd.coilCurr{ind}(jnd),THI040416_prcssd.fitData2{ind}{jnd}.b,15,THI040416_prcssd.fitData2{ind}{jnd}.b)
    end
end