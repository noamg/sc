%function RT_meas
tic;
didCloseDevices=false;
try
    % Init:
    tempResDevice= openGPIBDevice('CONTEC',0,6);
    sampleVoltageDevice=openGPIBDevice('CONTEC',0,23);
    sampleCurrentDevice=openGPIBDevice('CONTEC',0,19);
    coilCurrentDevice=openGPIBDevice('CONTEC',0,4);
%    tempResistance = readMeas(tempResDevice);
    %%% Coil-current init ( for H field generation):
    % Current limit:
    %fprintf(coilCurrentDevice,'CURRENT:PROTECTION 4');
    % Voltage limit:
    %fprintf(coilCurrentDevice,'VOLTAGE:PROTECTION:STATE 0');
    % Output ON, duh
    fprintf(coilCurrentDevice,'OUTPUT ON');
    
    %%% Sample-current init:
    % Slect the +6V output:
    %fprintf (sampleCurrentDevice,'INSTRUMENT P6V');
    % Output ON, duh
    fprintf(sampleCurrentDevice,'OUTPUT ON');
    
    % Field and sample-current values for execution:
    coilCurrent=0; % Amps
    sampleCurrent=0.5; % Amps
    heatCurr=0;
    
    temp = zeros(1, 2*length(sampleCurrent));
    
    temp(1:2:length(temp)) = sampleCurrent;
    sampleCurrent=temp;
    
    pauseInterval=0.25; % Seconds
    
    savePath='C:\Documents and Settings\owner\Desktop\dan_noam\data_1\270316\';
    fnamePattern='cooling_long';
    fname=nextAvailableFilename(savePath,fnamePattern,'csv');
    header='Time(sec),TempRes(Ohm),SampVolt(V),SampCurr(A),CoilCurr(A)\n';
    file=fopen(fname,'w+');
    fprintf(file,header);
    fclose(file);
    
    fprintf(tempResDevice, 'READ?');
    tempResistance = readMeas(tempResDevice);
    
    startTime=clock;
    fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,coilCurrent));
    fprintf(sampleCurrentDevice,sprintf ('INST P6V; CURR %f; INST P25V; CURR %f',0.5,heatCurr));
    flag=tempResistance>23;
    while(flag)
        % Set coil current:
        
        %pause(pauseInterval);
        
        %Set sample current:
        
        %fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,sampleCurrent(j)));
        pause(pauseInterval);
        time=etime(clock,startTime);
        
        % Read:
        fprintf(tempResDevice, 'READ?');
        tempResistance = readMeas(tempResDevice);
        
        fprintf(sampleVoltageDevice, 'READ?');
        sampleVoltage = readMeas(sampleVoltageDevice);
        
        
        fprintf(sampleCurrentDevice, 'INST P6V; CURRENT?');
        sampleCurrentMeas = readMeas(sampleCurrentDevice);
        
        
        fprintf(coilCurrentDevice, 'CURRENT?');
        coilCurrentMeas = readMeas(coilCurrentDevice);
        
       
        
        dlmwrite (fname,[time,tempResistance,...
            sampleVoltage,sampleCurrentMeas,...
            coilCurrentMeas],'-append');
        
        
        
        
        %save (fname,'time','tempRes','sampVolt','sampCurr','recordNumber');
        
        
        
        flag=tempResistance>23;
%         flag=flag+1;
        disp(sampleVoltage)
    end
    %setting the currents back to zero
    fprintf(sampleCurrentDevice,sprintf ('INST P6V; CURR %f; INST P25V; CURR %f',0,0));
    fprintf(coilCurrentDevice,'OUTPUT OFF');
catch err
    disp (err);
    
    fclose(tempResDevice);
    fclose(sampleVoltageDevice);
    fclose(sampleCurrentDevice);
    fclose(coilCurrentDevice);
    
    didCloseDevices=true;
    rethrow (err);
end
if (~didCloseDevices)
    fclose(tempResDevice);
    fclose(sampleVoltageDevice);
    fclose(sampleCurrentDevice);
    fclose(coilCurrentDevice);
    
end
disp ('Done!!!!!!!!');
toc;
%end
