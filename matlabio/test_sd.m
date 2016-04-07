function visa_yoni
    didCloseDevices=false;
    try
        % Init:
        tempResDevice= openGPIBDevice('CONTEC',0,6);
        sampleVoltageDevice=openGPIBDevice('CONTEC',0,22);
        sampleCurrentDevice=openGPIBDevice('CONTEC',0,19);
        coilCurrentDevice=openGPIBDevice('CONTEC',0,4);

        %%% Coil-current init ( for H field generation):
        % Current limit:
        fprintf(coilCurrentDevice,'CURRENT:PROTECTION 7');
        % Voltage limit:
        fprintf(coilCurrentDevice,'VOLTAGE:PROTECTION:STATE 0');
        % Output ON, duh
        fprintf(coilCurrentDevice,'OUTPUT ON');
       
        %%% Sample-current init:
        % Slect the +6V output:
        %fprintf (sampleCurrentDevice,'INSTRUMENT P6V');
        % Output ON, duh
        fprintf(sampleCurrentDevice,'OUTPUT ON');
        
        % Field and sample-current values for execution:
        coilCurrent=[0:0.1:4];%0:0.5:6.5; % Amps
        sampleCurrent=[2]; % Amps
        heatCurr=0.0455; %0.073;
        
        temp = zeros(1, 2*length(sampleCurrent));
        
        temp(1:2:length(temp)) = sampleCurrent;
        %temp = sampleCurrent;
        sampleCurrent=temp;
        
        pauseInterval=0.3; % Seconds
        
        savePath='C:\\ds\\calibrate\\2\\';
        fnamePattern='SupCondData';
        fname=nextAvailableFilename(savePath,fnamePattern,'csv');
       	header='Time(sec),TempRes(Ohm),SampVolt(V),SampCurr(A),CoilCurr(A)\n';
        file=fopen(fname,'w+');
        fprintf(file,header);
        fclose(file);
 
        

        startTime=clock;
        tempResistance = 0;
        sampleCurrentMeas = 0;
        coilCurrentMeas = 0;
        i = 1;
        %while(true)
        for i=1:length(coilCurrent)
            % Set coil current:
            fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,coilCurrent(i)));
            %pause(pauseInterval);
            %toc;
            pause(1);
            for j=1:length(sampleCurrent)
                %Set sample current:
                fprintf(sampleCurrentDevice,sprintf ('INST P6V; CURR %f; INST P25V; CURR %f',sampleCurrent(j),heatCurr));
                toc;
                ['stop'];
                %fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,sampleCurrent(j)));
                pause(pauseInterval);
                time=etime(clock,startTime);
                
                % Read:
                %fprintf(tempResDevice, 'READ?');
                %tempResistance = readMeas(tempResDevice);

                fprintf(sampleVoltageDevice, 'READ?');
                sampleVoltage = readMeas(sampleVoltageDevice);
  
                
                %fprintf(sampleCurrentDevice, 'INST P6V; CURRENT?');
                %sampleCurrentMeas = readMeas(sampleCurrentDevice);

                
                %fprintf(coilCurrentDevice, 'CURRENT?');
                %coilCurrentMeas = readMeas(coilCurrentDevice);
                time
                fprintf(sampleVoltageDevice, 'READ?');
                sampleVoltage = readMeas(sampleVoltageDevice);
                time=etime(clock,startTime)
                
                dlmwrite (fname,[time,tempResistance,...
                                sampleVoltage,sampleCurrentMeas,...
                                coilCurrentMeas],'-append');
                
                
                  
            end
            %save (fname,'time','tempRes','sampVolt','sampCurr','recordNumber');
          
        end
          fprintf(sampleCurrentDevice,'P6V; CURR 0');
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
end
