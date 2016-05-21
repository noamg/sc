folder = 'C:\Users\Dan Wexler\Documents\school\year 3\lab3\superconductors\sc\data\040416\';

flist = dir([folder, 'THI_manThrmAutoMeas_*.csv']);

delList = [];
for ind = 1:length(flist)
    ix = strfind(flist(ind).name,'_');
    if length(ix)< 3
        delList = [delList, ind];
    elseif str2num(flist(ind).name(ix(end)+1:ix(end)+2))<4
        delList = [delList, ind];
    end
end
flist(delList) = [];

THI040416.files = {flist.name};

for ind = 1:length(flist)
    temp = csvread([folder,flist(ind).name],1,0);
    THI040416.Time{ind} = temp(:,1);
    THI040416.TempRes{ind} = temp(:,2);
    THI040416.SampVolt{ind} = temp(:,3);
    THI040416.SampCurr{ind} = temp(:,4);
    THI040416.coilCurr{ind} = temp(:,5);
    THI040416.HeatingCurr{ind} = temp(:,6);
    THI040416.SampCurr_order{ind} = temp(:,7);
    THI040416.SampVoltFix{ind} = [THI040416.SampVolt{ind}(1); THI040416.SampVolt{ind}(2:2:end) - THI040416.SampVolt{ind}(3:2:end)];
end

save([folder,'allRelevantData040416.mat'],'THI040416');