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

figure
hold on
for ind = [9,10,1,12,2,6]
    B=[];
    for jnd = 1:length(THI070416_prcssd.coilCurr{ind})
       B(jnd) = THI070416_prcssd.fitData2{ind}{jnd}.b;
    end
    h = plot(THI070416_prcssd.coilCurr{ind}*100,B,'.-');
    tempStr = num2str(THI070416_prcssd.tempMean{ind}(1));
    set(h,'displayname',[tempStr(1:6),' [K]'])
end
grid on
legend('show')
xlabel('H [G]')
ylabel('\alpha [AU]')
title({'V = I*exp(-\alpha/I) fit','\alpha(H) per temperature'})


% plot THI surface
figure
hold on
for ind = [1,12,2,6]
        plot(THI070416_prcssd.sampCurr{ind}{1},THI070416_prcssd.sampVolt{ind}{1})
end

% HC2
T_Hc2 = cellfun(@(v) v(1),THI070416_prcssd.tempMean([9,10,1,12,2,6]));
H_Hc2 = [0,20,30,65,190,400];
TErr = 0.3*ones(size(T_Hc2));
HErr = sqrt(3^2*ones(size(H_Hc2)) + (H_Hc2/20).^2);

figure
hold on
errorbar(T_Hc2,H_Hc2,HErr,'.--b','linewidth',1.5)
herrorbar(T_Hc2,H_Hc2,TErr,TErr,'.b')
grid('on')
title('H_{C2}(T)')
xlabel('T [K]')
ylabel('H [G]')