
uT_init = unique(TempResOhm);
uH = unique(coil_current_orderA);
uI = unique(sample_current_orderA);

uT = reshape(uT,13,198/13)




for n = 1:12
    indx = 3781-315*n:4095-315*n;
    figure
    plot3(coil_current_orderA(indx),sample_current_orderA(indx),SampVoltV(indx),'.')
    xlabel('H')
    ylabel('I')
    zlabel('V')
    tStr = [num2str(n), ': ', num2str(mean(TempResOhm(indx))),' \pm ',num2str(std(TempResOhm(indx),1))];
    title(tStr)
end

figure
xlabel('H')
ylabel('I')
zlabel('V')
hold all
for ind = 1:21
    indx_1 = indx(1+(ind-1)*15:ind*15);
    plot3(coil_current_orderA(indx_1),sample_current_orderA(indx_1),SampVoltV(indx_1),'.-.')
end

