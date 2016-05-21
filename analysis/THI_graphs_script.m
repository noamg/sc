Curr2HField = 100;

figure
hold on
xlabel('I [A]')
ylabel('H [G]')
zlabel('V [V]')
title('V(I) per H-field value (T = 111.87±0.05 kelvin)')

for ind = 3%length(THI040416.files)
    HVec = unique(THI040416.coilCurr{ind});
    for jnd = 1: length(HVec);
        ix = (THI040416.coilCurr{ind} == HVec(jnd)) & (THI040416.SampCurr{ind}>1e-3);
        ix(find(THI040416.coilCurr{ind} == HVec(jnd),1)) = true;
        plot3(THI040416.SampCurr{ind}(ix),Curr2HField*THI040416.coilCurr{ind}(ix),abs(THI040416.SampVolt{ind}(ix)),'.-')
    end
end


islog = false; %true

figure
hold on
grid on
xlabel('I [A]')
ylabel('T [K]')
if islog
    zlabel ('log V [dBVolt]')
else
    zlabel('V [V]')
end
title('V(I) per Temperature (H = 0+(<<1) Gauss)')
HVec = unique(THI040416.coilCurr{1});

for ind = 1:length(THI040416.files)
    for jnd = 1:1;
        ix = (THI040416.coilCurr{ind} == 0) & (THI040416.SampCurr{ind}>1e-3);
        ix(1) = true;
        if islog
            plot3(THI040416.SampCurr{ind}(ix),pt100_convert(THI040416.TempRes{ind}(ix),0),log10(abs(THI040416.SampVoltFix{ind}(ix(1:2:end)))),'.-')
        else
            plot3(THI040416.SampCurr{ind}(ix),pt100_convert(THI040416.TempRes{ind}(ix),0),(abs(THI040416.SampVoltFix{ind}(ix(1:2:end)))),'.-')
        end
    end
end

Curr2HField = 100;

figure
hold on
xlabel('I [A]')
ylabel('H [G]')
zlabel('V [V]')
title('V(I) per H-field value (T = 111.87±0.05 kelvin)')

for ind = 5%length(THI040416.files)
    HVec = unique(THI040416.coilCurr{ind});
    for jnd = 1: length(HVec);
        ix = (THI040416.coilCurr{ind} == HVec(jnd)) & (THI040416.SampCurr{ind}>1e-3);
        ix(find(THI040416.coilCurr{ind} == HVec(jnd),1)) = true;
        plot3(THI040416.SampCurr{ind}(ix),Curr2HField*THI040416.coilCurr{ind}(ix),abs(THI040416.SampVoltFix{ind}(ix(1:2:end))),'.-')
    end
end

