function [Tc,deltaT]  = cooling_long_displayAll(x)
%add x in output if created in run (and remove from input)



folder = 'C:\Users\Dan Wexler\Documents\school\year 3\lab3\superconductors\sc\data';
dirlist = dir(folder);
dirlist(~[dirlist.isdir]) = [];
dirlist(strcmp({dirlist.name},'.')|strcmp({dirlist.name},'..')) = [];

colHeads = {'Time(sec)','TempRes(Ohm)','SampVolt(V)','SampCurr(A)','CoilCurr(A)'};

hf = figure;
hold on

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
        
        if ~run_valids
            h(ind+(jnd-1)*100) = plot3(pt100_convert(TempRes,0),abs(SampVolt./SampCurr),ind*ones(size(TempRes)),'.');
            set(h(ind+(jnd-1)*100),'displayname',[dirlist(ind).name,'\',temp(jnd).name],'markersize',15)
        else
            if valid_count<8 && ind==valid_indjnd_list(valid_count,1) && jnd==valid_indjnd_list(valid_count,2)
%                 tempfig = figure;
%                 plot(pt100_convert(TempRes,0),abs(SampVolt./SampCurr),'.')
%                 pause()
%                 [x{valid_count},y{valid_count}] = ginput(2);
%                 close(tempfig)
%                 figure(hf)
                h(valid_count) = plot(pt100_convert(TempRes,0),abs(SampVolt./SampCurr),'.');
                set(h(valid_count),'markersize',15)
                if valid_count ~= 7
                    set(h(valid_count),'displayname',['original test head - ',num2str(valid_count),', ',num2str(mean(SampCurr)),'A'],...
                        'marker','x')
                else
                    set(h(valid_count),'displayname',['new test head',', ',num2str(mean(SampCurr)),'A'],...
                        'marker','*')
                end
                [Tc(valid_count), deltaT(valid_count)] = findTcAndTransTempRange(x{valid_count},pt100_convert(TempRes,0),abs(SampVolt./SampCurr));
                valid_count = valid_count + 1;
            end
        end
            
    end
%     flist(1:length(temp),ind) = temp;
end
