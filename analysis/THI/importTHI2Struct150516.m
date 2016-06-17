folder = 'C:\Users\Dan Wexler\Documents\school\year 3\lab3\superconductors\sc\data\150516\';

flist = dir([folder, 'THI_manThrmAutoMeas_6*.csv']);
% 
% delList = [];
% for ind = 1:length(flist)
%     ix = strfind(flist(ind).name,'_');
%     if length(ix)< 3
%         delList = [delList, ind];
%     elseif str2num(flist(ind).name(ix(end)+1:ix(end)+2))<4
%         delList = [delList, ind];
%     end
% end
% flist(delList) = [];

THI150516.files = {flist.name};

for ind = 1:length(flist)
    temp = csvread([folder,flist(ind).name],1,0);
    THI150516.Time{ind} = temp(:,1);
    THI150516.TempRes{ind} = temp(:,2);
    THI150516.SampVolt{ind} = temp(:,3);
    THI150516.SampCurr{ind} = temp(:,4);
    THI150516.coilCurr{ind} = temp(:,5);
    THI150516.HeatingCurr{ind} = temp(:,6);
    THI150516.SampCurr_order{ind} = temp(:,7);
    THI150516.SampVoltFix{ind} = [THI150516.SampVolt{ind}(1); THI150516.SampVolt{ind}(2:2:end) - THI150516.SampVolt{ind}(3:2:end)];
end

% save([folder,'allRelevantData150516.mat'],'THI150516');

for ind = 1:length(flist)
    figure(ind)
    plot(THI150516.SampCurr{ind},THI150516.SampVolt{ind},'.')
end

figure
hold on
errorbar(THI150516.SampCurr{16},THI150516.SampVolt{16}*1e6,2*ones(length(THI150516.SampCurr{16}),1),'.')
grid on
xlabel('I_{int} [A]')
ylabel('V [\mu V]')