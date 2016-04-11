function [desiredCurr,finalTemp] = thermalize1min(desiredTempRes)


didclose = 0;
startTime = clock;

tMax = 60;
dt = 0.5;

t = zeros(tMax/dt,1);
Temp = zeros(tMax/dt,1);

ind = 1;
try
    tempResDevice = openGPIBDevice('CONTEC',0,6);
    sampleCurrentDevice = openGPIBDevice('CONTEC',0,19);

    fprintf(tempResDevice, 'READ?');
    tempResistance = readMeas(tempResDevice);
    fprintf(sampleCurrentDevice,'OUTPUT ON');
    overshootTempRes = desiredTempRes + 6 * (desiredTempRes - tempResistance);
    overshootCurr = calcCurrForHeat(overshootTempRes);
    desiredCurr = calcCurrForHeat(desiredTempRes);
    fprintf(sampleCurrentDevice,sprintf ('INST P25V; VOLT %f',25));
    fprintf(sampleCurrentDevice,sprintf ('INST P25V; CURR %f',overshootCurr));
    
    figure
    while etime(clock,startTime) < tMax  
        fprintf(tempResDevice, 'READ?');
        pause(dt)
        tempResistance = readMeas(tempResDevice);
        t(ind) = etime(clock,startTime);
        Temp(ind) = tempResistance;
        if ~isempty(t(Temp~=0))
            plot(t(Temp~=0),Temp(Temp~=0),'.','markerSize',15)
        end
        ind = ind + 1;
    end
    
catch err
    disp(err)
    fprintf(sampleCurrentDevice,sprintf ('INST P25V; CURR %f',desiredCurr));
    fclose(tempResDevice);
    fclose(sampleCurrentDevice)
    didclose = 1;
end
if ~didclose
    fprintf(sampleCurrentDevice,sprintf ('INST P25V; CURR %f',desiredCurr));
    fclose(tempResDevice);
    fclose(sampleCurrentDevice)
    finalTemp = pt100_convert(Temp(end));
end