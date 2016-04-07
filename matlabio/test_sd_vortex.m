function visa_yoni
    tic;
    didCloseDevices=false;
    secondsMeasured= 3;
    try
        % Init:
        tempResDevice= openGPIBDevice('CONTEC',0,6);
        sampleVoltageDevice=openGPIBDevice('CONTEC',0,22);
        sampleCurrentDevice=openGPIBDevice('CONTEC',0,19);
        coilCurrentDevice=openGPIBDevice('CONTEC',0,4);

        %%% Coil-current init ( for H field generation):
        % Current limit:
        fprintf(coilCurrentDevice,'CURRENT:PROTECTION 4');
        % Voltage limit:
        fprintf(coilCurrentDevice,'VOLTAGE:PROTECTION:STATE 0');
        % Output ON, duh
        fprintf(coilCurrentDevice,'OUTPUT ON');
        %%% Sample-current init:
        % Slect the +6V output:
        fprintf (sampleCurrentDevice,'INSTRUMENT P6V');
        % Output ON, duh
        fprintf(sampleCurrentDevice,'OUTPUT ON');
       pause;
        
        % Field and sample-current values for execution:
        coilCurrent=[0:0.03:0.5];%0:0.5:6.5; % Amps
        sampleCurrent=[2]; % Amps
        heatCurr=0.073;
        
        temp = zeros(1, 2*length(sampleCurrent));
        
        temp(1:2:length(temp)) = sampleCurrent;
        sampleCurrent=temp;
        
        pauseInterval= 0.01; %0.25; % Seconds
        
        savePath='C:\\ds\\BvsH\\';
        fnamePattern='dist1_exp';
        fname=nextAvailableFilename(savePath,fnamePattern,'csv');
       	header='Time(sec),TempRes(Ohm),SampVolt(V),SampCurr(A),CoilCurr(A)\n';
        file=fopen(fname,'w+');
        fprintf(file,header);
        fclose(file);
        

        startTime=clock;
        
        %while(true)
        for i=1:length(coilCurrent)
            % Set coil current:
            fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,coilCurrent(i)));
            print(coilCurrent(i));
            pause(pauseInterval);
            j = 1;
            for t=1:secondsMeasured
                %Set sample current:
                fprintf(sampleCurrentDevice,sprintf ('INST P6V; CURR %f; INST P25V; CURR %f',sampleCurrent(j),heatCurr));
                %fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,sampleCurrent(j)));
                pause(pauseInterval);
                time=etime(clock,startTime);
                
                % Read:

                fprintf(sampleVoltageDevice, 'READ?');
                sampleVoltage = readMeas(sampleVoltageDevice);
  
                
                fprintf(sampleCurrentDevice, 'INST P6V; CURRENT?');
                sampleCurrentMeas = readMeas(sampleCurrentDevice);

                fprintf(tempResDevice, 'READ?');
                tempResistance = readMeas(tempResDevice);
                
                fprintf(coilCurrentDevice, 'CURRENT?');
                coilCurrentMeas = readMeas(coilCurrentDevice);
                %coilCurrentMeas = 0;
                
                dlmwrite (fname,[time,tempResistance,...
                                sampleVoltage,sampleCurrentMeas,...
                                coilCurrentMeas],'-append');
                
                if j == 1
                    fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,0));
                end
                pause (ceil(time) - time); 
                  
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
    toc;
end
