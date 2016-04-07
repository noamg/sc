function monitorTemprature

tempResDevice = openGPIBDevice('CONTEC',0,6);
didclose = 0;
startTime = clock;

tMax = 90;
dt = 0.5;

t = zeros(tMax/dt,1);
Temp = zeros(tMax/dt,1);

ind = 1;

figure
try
    while etime(clock,startTime) < tMax  
        fprintf(tempResDevice, 'READ?');
        pause(dt)
        tempResistance = readMeas(tempResDevice);
        t(ind) = etime(clock,startTime);
        Temp(ind) = pt100_convert(tempResistance);
        if ~isempty(t(Temp~=0))
            plot(t(Temp~=0),Temp(Temp~=0),'.','markerSize',15)
        end
        ind = ind + 1;
    end
catch err
    disp(err)
    fclose(tempResDevice);
    didclose = 1;
end
if didclose
    fclose(tempResDevice);
end