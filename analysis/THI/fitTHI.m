
% fitO1 = fitoptions(options,'Lower',[0,0],'Upper',[inf,inf]);
fitT1 = fittype(@(a,b,x) a*x.^2./(a/b+x),'independent','x');
fitT2 = fittype(@(a,b,x) a*x.*exp(-b./x),'independent','x');
fitO1 = fitoptions(fitT1);
fitO2 = fitoptions(fitT2);
fitO1.Lower = [1,1]*1e-10;
fitO1.Upper = [inf,inf];

for ind = 1: length(THI070416.files)
    uniqueCoilCurr = unique(THI070416.coilCurr{ind});
    for jnd = 1:length(uniqueCoilCurr)
        ix = THI070416.coilCurr{ind} == uniqueCoilCurr(jnd);
        THI070416_prcssd.tempMean{ind}(jnd) = pt100_convert(mean(THI070416.TempRes{ind}),0);
        THI070416_prcssd.tempSpecific{ind}(jnd) = pt100_convert(mean(THI070416.TempRes{ind}(ix)),0);
        THI070416_prcssd.tempSTD{ind}(jnd) = std(pt100_convert(THI070416.TempRes{ind},0));
        THI070416_prcssd.coilCurr{ind}(jnd) = uniqueCoilCurr(jnd);
        THI070416_prcssd.sampCurr{ind}{jnd} = abs(THI070416.SampCurr{ind}(ix));
        THI070416_prcssd.sampVolt{ind}{jnd} = abs(THI070416.SampVolt{ind}(ix));
        if strcmp(THI070416.files{ind}(23),'6')
            THI070416_prcssd.tempMean{ind}(jnd) = pt100_convert(mean(THI070416.TempRes{ind}(30:end)),0);
            THI070416_prcssd.tempSTD{ind}(jnd) = std(pt100_convert(THI070416.TempRes{ind}(30:end),0));
            if uniqueCoilCurr(jnd) == 0.128
                THI070416_prcssd.coilCurr{ind}(jnd) = 0;
                THI070416_prcssd.sampCurr{ind}{jnd} = abs(THI070416.SampVolt{ind}(ix));
                THI070416_prcssd.sampVolt{ind}{jnd} = abs(THI070416.TempRes{ind}(ix));
            end
            THI070416_prcssd.sampCurr{ind}{jnd}(1:2:end) = [];
            THI070416_prcssd.sampVolt{ind}{jnd}(1:2:end) = [];
        else
            THI070416_prcssd.sampCurr{ind}{jnd}(2:2:end) = [];
            THI070416_prcssd.sampVolt{ind}{jnd}(2:2:end) = [];
        end
        THI070416_prcssd.fitData1{ind}{jnd} = fit(THI070416_prcssd.sampCurr{ind}{jnd},THI070416_prcssd.sampVolt{ind}{jnd},fitT1,fitO1);
        THI070416_prcssd.fitData2{ind}{jnd} = fit(THI070416_prcssd.sampCurr{ind}{jnd},THI070416_prcssd.sampVolt{ind}{jnd},fitT2,fitO2);
    end
end


figure
hold on
for ind = 1:length(THI070416_prcssd.tempMean)
    for jnd = 1:length(THI070416_prcssd.coilCurr{ind})
       plot3(THI070416_prcssd.tempMean{ind}(jnd),THI070416_prcssd.coilCurr{ind}(jnd),THI070416_prcssd.fitData2{ind}{jnd}.b,'.')
    end
end



% fitO1 = fitoptions(options,'Lower',[0,0],'Upper',[inf,inf]);
fitT1 = fittype(@(a,b,x) a*x.^2./(a/b+x),'independent','x');
fitT2 = fittype(@(a,b,x) a*x.*exp(-b./x),'independent','x');
fitO1 = fitoptions(fitT1);
fitO2 = fitoptions(fitT2);
fitO1.Lower = [1,1]*1e-10;
fitO1.Upper = [inf,inf];

for ind = 1: length(THI040416.files)
    uniqueCoilCurr = unique(THI040416.coilCurr{ind});
    for jnd = 1:length(uniqueCoilCurr)
        ix = THI040416.coilCurr{ind} == uniqueCoilCurr(jnd);
        THI040416_prcssd.tempMean{ind}(jnd) = pt100_convert(mean(THI040416.TempRes{ind}),0);
        THI040416_prcssd.tempSpecific{ind}(jnd) = pt100_convert(mean(THI040416.TempRes{ind}(ix)),0);
        THI040416_prcssd.tempSTD{ind}(jnd) = std(pt100_convert(THI040416.TempRes{ind},0));
        THI040416_prcssd.coilCurr{ind}(jnd) = uniqueCoilCurr(jnd);
        THI040416_prcssd.sampCurr{ind}{jnd} = abs(THI040416.SampCurr{ind}(ix));
        THI040416_prcssd.sampVolt{ind}{jnd} = abs(THI040416.SampVolt{ind}(ix));
        if strcmp(THI070416.files{ind}(23),'6')
            THI040416_prcssd.sampCurr{ind}{jnd}(1:2:end) = [];
            THI040416_prcssd.sampVolt{ind}{jnd}(1:2:end) = [];
        else
            THI040416_prcssd.sampCurr{ind}{jnd}(2:2:end) = [];
            THI040416_prcssd.sampVolt{ind}{jnd}(2:2:end) = [];
        end
        THI040416_prcssd.fitData1{ind}{jnd} = fit(THI040416_prcssd.sampCurr{ind}{jnd},THI040416_prcssd.sampVolt{ind}{jnd},fitT1,fitO1);
        THI040416_prcssd.fitData2{ind}{jnd} = fit(THI040416_prcssd.sampCurr{ind}{jnd},THI040416_prcssd.sampVolt{ind}{jnd},fitT2,fitO2);
    end
end


figure
hold on
for ind = 1:length(THI040416_prcssd.tempMean)
    for jnd = 1:length(THI040416_prcssd.coilCurr{ind})
       plot3(THI040416_prcssd.tempMean{ind}(jnd),THI040416_prcssd.coilCurr{ind}(jnd),THI040416_prcssd.fitData1{ind}{jnd}.a,'.')
    end
end


figure
hold on
for ind = 1:length(THI070416_prcssd.coilCurr{12})
    plot3(THI070416_prcssd.coilCurr{12}(ind)*ones(size(THI070416_prcssd.sampCurr{12}{ind})),THI070416_prcssd.sampCurr{12}{ind},THI070416_prcssd.sampVolt{12}{ind},'.-')
    THI070416_prcssd.fitData2{12}{ind}.b
end

figure
hold on
for ind = 1:length(THI070416_prcssd.tempMean)
    H = [];
    B = [];
    T = ones(size(THI070416_prcssd.coilCurr{ind}))* THI070416_prcssd.tempMean{ind}(1);
    for jnd = 1:length(THI070416_prcssd.coilCurr{ind})
        H(jnd) = THI070416_prcssd.coilCurr{ind}(jnd);
        B(jnd) = THI070416_prcssd.fitData1{ind}{jnd}.a;
    end
    plot3(T,H,B,'*-')
end

% figure
% hold on
for ind = 1:length(THI040416_prcssd.tempMean)
    H = [];
    B = [];
    T = ones(size(THI040416_prcssd.coilCurr{ind}))* THI040416_prcssd.tempMean{ind}(1);
    for jnd = 1:length(THI040416_prcssd.coilCurr{ind})
        H(jnd) = THI040416_prcssd.coilCurr{ind}(jnd);
        B(jnd) = THI040416_prcssd.fitData1{ind}{jnd}.a;
    end
    plot3(T,H,B,'.-')
end