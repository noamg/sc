% read single temperature THI files
folder = 'C:\Documents and Settings\owner\Desktop\dan_noam\data_1\040416\good\';
flist = dir([folder,'*.csv']);

colHeads = {'Time(sec)','TempRes(Ohm)','SampVolt(V)','SampCurr(A)','CoilCurr(A)','HeatingCurr(A)','SampCurr_order(A)'};

fitO1 = fitoptions(,'Lower',[0,0],'Upper',[inf,inf]);
fitT1 = fittype(@(a,b,x) a*x.^2./(a/b+x),'independent','x','lower','options',fitO1);
fitT2 = fittype(@(a,b,c,d,x) a*(x-d).^3 + b*(x-d).^2 + c*(x-d),'independent','x');

for ind = 1: length(flist)
    [Time, TempRes, SampVolt, SampCurr, CoilCurr, HeatingCurr, SampCurr_order] = csvimport([folder,flist(ind).name],'columns',colHeads);
    SampVolt = abs(SampVolt);
    H_axis = unique(CoilCurr);
    for jnd = 1: length(H_axis)
        indx = CoilCurr == H_axis(jnd);
        fitData1{ind,jnd} = fit(SampCurr(indx),SampVolt(indx),fitT1);
        fitData2{ind,jnd} = fit(SampCurr(indx),SampVolt(indx),fitT2);
    end
end


for ind = 5:5% length(flist)
    [Time, TempRes, SampVolt, SampCurr, CoilCurr, HeatingCurr, SampCurr_order] = csvimport([folder,flist(ind).name],'columns',colHeads);
    SampVolt = abs(SampVolt);
    H_axis = unique(CoilCurr);
    for jnd = 1: length(H_axis)
        figure(jnd)
        title(['coil current =',num2str(H_axis(jnd))])
        xlabel('I')
        ylabel('V')
        %text(20,20,['params us:',num2str(coeffvalues(fitData1{ind,jnd})),'\nparams hen:',num2str(coeffvalues(fitData2{ind,jnd}))]);
        hold on
        indx = CoilCurr == H_axis(jnd);
        plot(SampCurr(indx),SampVolt(indx),'.')
        plot(fitData1{ind,jnd})
        plot(fitData2{ind,jnd},'--')
    end
end

for ind = 1: length(flist)
    H_axis = unique(CoilCurr);
    for jnd = 1: length(H_axis)
        a1(ind,jnd) = fitData1{ind,jnd}.a;
        b1(ind,jnd) = fitData1{ind,jnd}.b;
        a2(ind,jnd) = fitData2{ind,jnd}.a;
        b2(ind,jnd) = fitData2{ind,jnd}.b;
        c2(ind,jnd) = fitData2{ind,jnd}.c;
        d2(ind,jnd) = fitData2{ind,jnd}.d;
    end
end

T = fliplr([34.44, 35.12, 36.49, 40.01, 42.1]);
figure
surf(H_axis,T,a1)
xlabel('H')
ylabel('T')
zlabel('R_{boundry}')

figure
surf(H_axis,T,b1)
xlabel('H')
ylabel('T')
zlabel('R_{boundry} / \alpha')

figure
surf(H_axis,T,b1)
xlabel('H')
ylabel('T')
zlabel('R_{boundry} / \alpha')

