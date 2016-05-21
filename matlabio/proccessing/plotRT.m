function plotRT(Tc,markTc)

vErr = 3e-6;
tErr = 1.4;


folder = 'C:\Users\Dan Wexler\Documents\school\year 3\lab3\superconductors\sc\data';
dirlist = dir(folder);
dirlist(~[dirlist.isdir]) = [];
dirlist(strcmp({dirlist.name},'.')|strcmp({dirlist.name},'..')) = [];

colHeads = {'Time(sec)','TempRes(Ohm)','SampVolt(V)','SampCurr(A)','CoilCurr(A)'};

hf = figure;
title('Critical Temperature (at 0 external field)')
xlabel('T [K]')
ylabel('R [Ohm]')
hold on
grid on

valid_indjnd_list = [1,1;4,2;4,3;6,1;7,2;8,1;9,1];
%files: 040416\cooling_long_1.csv
%       080316\3-cooling.csv
%       080.16\4-cooling.csv
%       110413\cooling_long_2.csv
%       130316\9-cooling-from-room.csv
%       150316\14-cooling.csv
%       150516\cooling_long_2.csv
valid_count = 1;

run_valids = true;
for ind = 1:length(dirlist)
    temp = dir([folder,'\',dirlist(ind).name,'\*cooling*.csv']);
    temp([temp.bytes]<=1e3) = [];
    for jnd = 1:length(temp)
        if strcmp(temp(jnd).name(1:12),'cooling_long')
            [Time, TempRes, SampVolt, SampCurr, CoilCurr] =...
                csvimport([folder,'\',dirlist(ind).name,'\',temp(jnd).name],'columns',colHeads);
        else
            mat = csvread([folder,'\',dirlist(ind).name,'\',temp(jnd).name],3,2);
            SampCurr = 0.5;
            Time = mat(:,1);
            TempRes = mat(:,2);
            SampVolt = mat(:,3);
        end
        
        if valid_count<8 && ind==valid_indjnd_list(valid_count,1) && jnd==valid_indjnd_list(valid_count,2)
            x = pt100_convert(TempRes,0);
            y = abs(SampVolt./SampCurr);
            rErr = vErr/mean(SampCurr);
            h(valid_count) = plot(x,y,'.');
            set(h(valid_count),'markersize',15)
            if valid_count ~= 7
                set(h(valid_count),'displayname',['original test head - ',dirlist(ind).name,', ',num2str(mean(SampCurr)),'A'],...
                    'marker','.')
            else
                set(h(valid_count),'displayname',['new test head',', ',num2str(mean(SampCurr)),'A'],...
                    'marker','.')
            end
            mrkx = Tc(valid_count)*[1,1];
            mrky = [-1e-4,1e-4];
            if markTc
                axis([100,125,-2e-4,4e-4])
                plot(mrkx,mrky,'color',get(h(valid_count),'color'),'linewidth',2)
            end
            if valid_count == 1
                figure
                hold on
                h_y = errorbar(x(1:5:end),y(1:5:end),rErr*ones(size(x(1:5:end))),'.');
                h_x = herrorbar(x(1:5:end),y(1:5:end),tErr*ones(size(x(1:5:end))),'.');
                title('Critical Temperature (at 0 external field) with errorbars')
                xlabel('T [K]')
                ylabel('R [Ohm]')
                figure(hf)
            end
            valid_count = valid_count + 1;
        end
            
    end
%     flist(1:length(temp),ind) = temp;
end
legend(h)