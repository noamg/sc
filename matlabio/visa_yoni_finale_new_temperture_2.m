function visa_yoni_finale_new_temperture_1
    
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
        fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,0));
       
        %%% Sample-current init:
        % Slect the +6V output:
        %fprintf (sampleCurrentDevice,'INSTRUMENT P6V');
        % Output ON, duh
        fprintf(sampleCurrentDevice,'OUTPUT ON');
        fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,0));
        
        % Field and sample-current values for execution:
        if true
            scSmallDelta = 1e-2;
            scN = 10;
            sampleCurrent=linspace(0.2, 2.2, 20); % Amps ##################
            hcDelta = 5e-3;
            heatCurr= 0.167 - [5,5.5] * hcDelta;
            wait_T = 210;
            wait_H = 0.1;
            wait_L = 0.15;
            H_res = 1/6;
            H_margin = 0.5;
            minMaxH = [1.3-H_margin,4;...
                1.3-H_margin,4];
        end
        
        if false
            coilCurrent= 1; % Amps ##################
            sampleCurrent= 0.5; % Amps ##################
            heatCurr= 0.1;
            wait_T = 10;
            wait_H = 5;
        end

        if false
            temp = zeros(1, 2*length(sampleCurrent));

            temp(1:2:length(temp)) = sampleCurrent;
            sampleCurrent=temp;
        end;
        
        %pauseInterval=1.0; % Seconds ######################
        
        savePath='C:\Documents and Settings\owner\Desktop\dan_noam\data_1\270316\';
        fnamePattern='THI_finale_new';
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
            coilCurrent = minMaxH(heat_current_ind,1):H_res:minMaxH(heat_current_ind,2);
            for i=1:length(coilCurrent)
                % Set coil current:
                fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,coilCurrent(i)));
                pause(wait_H)
                %pause(pauseInterval); ##########################
                disp(['Now at coilCurrent ' num2str(coilCurrent(i)) '[A]\n']);
                
                fprintf(tempResDevice, 'READ?');
                tempResistance = readMeas(tempResDevice);
                
                for minClck = 0:scN-1
                    for majClck=1:length(sampleCurrent)
                        current = minClck*scSmallDelta + sampleCurrent(majClck);
                        %Set sample current:
                        %fprintf(sampleCurrentDevice,sprintf ('INST P6V; CURR %f; INST P25V; CURR %f',sampleCurrent(j),heatCurr));
                        fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,current));
                        %pause(pauseInterval);

                        % Read:
% 
%                         while etime(clock,startTime)<1e4
                        fprintf(multi_meter_device, 'READ?');
                        sampleVoltage = readMeas(multi_meter_device);
                        time=etime(clock,startTime);
                        if true
                            dlmwrite (fname,[time,tempResistance,...
                                        sampleVoltage, heatCurr(heat_current_ind),...
                                        coilCurrent(i),current ],'-append');
                        end
                        disp(['Now at sampleVolt ' num2str(sampleVoltage) '[V]'])
%                         end;


                        if false

                            fprintf(sampleVoltageDevice, 'READ?');
                            sampleVoltage = readMeas(sampleVoltageDevice);

                            fprintf(sampleCurrentDevice, 'INST P6V; CURRENT?');
                            sampleCurrentMeas = readMeas(sampleCurrentDevice);

                            fprintf(coilCurrentDevice, 'CURRENT?');
                            coilCurrentMeas = readMeas(coilCurrentDevice);

                            fprintf(multi_meter_device, 'READ?');
                            sampleVoltage = readMeas(multi_meter_device);

                            if true
                                dlmwrite (fname,[time,tempResistance,...
                                        sampleVoltage, heatCurr(heat_current_ind),...
                                        coilCurrent(i),sampleCurrent(j) ],'-append');
                            end

                        end

                    end
                    fprintf(sampleCurrentDevice,'P6V; CURR 0');
                    pause(wait_L);
                end
                %save (fname,'time','tempRes','sampVolt','sampCurr','recordNumber');

            end
            
            fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,0));
        
            if true
              fprintf(sampleCurrentDevice,'P6V; CURR 0');
%                 fprintf(coilCurrentDevice,'OUTPUT OFF'); 
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
