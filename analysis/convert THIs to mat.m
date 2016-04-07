folder  = 'C:\Users\Dan Wexler\Documents\school\year 3\lab3\superconductors\T_H_I\';
fList = dir([folder,'*.csv']);
T_H_I = struct('heat_V',[],'heat_I',[],'T_ohm',[],'H_amp',[],'I_sc',[],'v_sc',[]);

for ind = 1:length(fList)
    fNum(ind) = str2double(fList(ind).name(1:strfind(fList(ind).name,'.')-1));
end
[~,sortInd] = sort(fNum);

for jnd = 1:length(fList)
    ind = sortInd(jnd);
    temp = csvread([folder,fList(ind).name],0,0);
    temp = [zeros(size(temp,1),6-size(temp,2)),temp];
    temp_hV = temp(find(temp(:,1)),1);
    if ~isempty(temp_hV)
        T_H_I(jnd).heat_V = mean(temp_hV);
    end
    temp_hI = temp(find(temp(:,2)),2);
    if ~isempty(temp_hI)
        T_H_I(jnd).heat_I = mean(temp_hI);
    end
    temp_T = temp(find(temp(:,3)),3);
    if ~isempty(temp_T)
        T_H_I(jnd).T_ohm = mean(temp_T);
    else
        T_H_I(jnd).T_ohm = T_H_I(jnd-1).T_ohm;
    end
    temp_H = temp(find(temp(:,4)),4);
    if ~isempty(temp_H)
        T_H_I(jnd).H_amp = mean(temp_H);
    else
        T_H_I(jnd).H_amp = 0;
    end
    T_H_I(jnd).I_sc = temp(:,5);
    T_H_I(jnd).v_sc = temp(:,6);
end
