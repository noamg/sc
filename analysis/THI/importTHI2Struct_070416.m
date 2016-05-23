folder = 'H:\Physics Lab 3\supercondutors\sc2.git\data\070416\';

flist = dir([folder, 'THI_manThrmAutoMeas_3_*.csv']);

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

flist([flist.bytes] < 2e2 ) = [];

THI070416.files = {flist.name};

for ind = 1:length(flist)
    temp = csvread([folder,flist(ind).name],1,0);
    THI070416.Time{ind} = temp(:,1);
    THI070416.TempRes{ind} = temp(:,2);
    THI070416.SampVolt{ind} = temp(:,3);
    THI070416.SampCurr{ind} = temp(:,4);
    THI070416.coilCurr{ind} = temp(:,5);
    THI070416.HeatingCurr{ind} = temp(:,6);
    THI070416.SampCurr_order{ind} = temp(:,7);
    THI070416.SampVoltFix{ind} = [THI070416.SampVolt{ind}(1); THI070416.SampVolt{ind}(2:2:end) - THI070416.SampVolt{ind}(3:2:end)];
end

save([folder,'allRelevantData070416.mat'],'THI070416');