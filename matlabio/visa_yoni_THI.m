function visa_yoni_skinny
    ;
    didCloseDevices=false;
    try
        % Init:
        tempResDevice= openGPIBDevice('CONTEC',0,6);
        sampleVoltageDevice=openGPIBDevice('CONTEC',0,22);
        sampleCurrentDevice=openGPIBDevice('CONTEC',0,19);
        coilCurrentDevice=openGPIBDevice('CONTEC',0,4);
        multi_meter_device=openGPIBDevice('CONTEC',0,23);

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
        if true
            coilCurrent= 0:0.075:1.5; % Amps ##################
            sampleCurrent=linspace(0, 0.5, 15); % Amps ##################
            heatCurr= 0.14:-.005:0.08;
            wait_T = 120;
        end

        if false
            temp = zeros(1, 2*length(sampleCurrent));

            temp(1:2:length(temp)) = sampleCurrent;
            sampleCurrent=temp;
        end;
        
        %pauseInterval=1.0; % Seconds ######################
        
        savePath='C:\Documents and Settings\owner\Desktop\dan_noam\data_1\220316\';
        fnamePattern='ds';
        fname=nextAvailableFilename(savePath,fnamePattern,'csv');
       	header_all='Time(sec),TempRes(Ohm),SampVolt(V),SampCurr(A),CoilCurr(A),heat_current(A),coil_current_order(A), sample_current_order(A)\n';
        header_skinny = 'Time(sec),TempRes(Ohm),SampVolt(V),heat_current(A),coil_current_order(A), sample_current_order(A)\n';
        
        file=fopen(fname,'w+');
        fprintf(file,header_skinny);
        fclose(file);
 
        

        startTime=clock;
        
        for heat_current_ind=1:length(heatCurr)
            %set T
            fprintf(sampleCurrentDevice,sprintf ('INST P25V; CURR %f',heatCurr(heat_current_ind)));
            pause(wait_T)
            %while(true)
            for i=1:length(coilCurrent)
                % Set coil current:
                fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,coilCurrent(i)));
                %pause(pauseInterval); ##########################
                disp(['Now at coilCurrent ' num2str(coilCurrent(i)) '[A]\n']);
                
                fprintf(tempResDevice, 'READ?');
                tempResistance = readMeas(tempResDevice);
                
                for j=1:length(sampleCurrent)
                    %Set sample current:
                    %fprintf(sampleCurrentDevice,sprintf ('INST P6V; CURR %f; INST P25V; CURR %f',sampleCurrent(j),heatCurr));
                    fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,sampleCurrent(j)));
                    %pause(pauseInterval);
                    time=etime(clock,startTime);

                    % Read:
                    
                    
                    

                    if false
                        
                        fprintf(sampleVoltageDevice, 'READ?');
                        sampleVoltage = readMeas(sampleVoltageDevice);
                        
                        fprintf(sampleCurrentDevice, 'INST P6V; CURRENT?');
                        sampleCurrentMeas = readMeas(sampleCurrentDevice);

                        fprintf(coilCurrentDevice, 'CURRENT?');
                        coilCurrentMeas = readMeas(coilCurrentDevice);
                        
                    end

                    
                    fprintf(multi_meter_device, 'READ?');
                    sampleVoltage = readMeas(multi_meter_device);
                    



                   
                    

                    
                    if true
                        dlmwrite (fname,[time,tempResistance,...
                                    sampleVoltage, heatCurr(heat_current_ind),...
                                    coilCurrent(i),sampleCurrent(j) ],'-append');
                    end
                    


                end
                %save (fname,'time','tempRes','sampVolt','sampCurr','recordNumber');

            end
        
            if true
              fprintf(sampleCurrentDevice,'P6V; CURR 0');
                fprintf(coilCurrentDevice,'OUTPUT OFF'); 
            end
           
        end
    %end
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
