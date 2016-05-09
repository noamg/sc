function [startTime]=visa_yoni_manThermalAutoMeas_10(internalCurrent, internal_sign,coilCurrent,const_externalCurrent, const_external_Current_sign)
disp('is current sign correct???')
didCloseDevices=false;
try
    tempResDevice = openGPIBDevice('CONTEC',0,6);
    sampleVoltageDevice = openGPIBDevice('CONTEC',0,22);
    sampleCurrentDevice = openGPIBDevice('CONTEC',0,19);
    coilCurrentDevice = openGPIBDevice('CONTEC',0,4);
    multi_meter_device = openGPIBDevice('CONTEC',0,23);
    multi_meter_device2 = openGPIBDevice('CONTEC',0,24);%enter address!!!

     %%% Coil-current init ( for H field generation):
    fprintf(coilCurrentDevice,'OUTPUT ON');
    fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,0));

    %%% Sample-current init:
    fprintf(sampleCurrentDevice,'OUTPUT ON');
    fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,0));

    % set heating current
    fprintf(sampleCurrentDevice,sprintf ('APPL P25V, %f %f',25,internalCurrent));
    
    %scSmallDelta = 0.1;
    %scN = 3;
%         N = 30;
%         externalCurrent_no_zeros= const_externalCurrent * ones(N,1);
%         pad = zeros(2 * N, 1);
%         externalCurrent = repmat([externalCurrent_no_zeros; pad],1);
        external_no_repet = (0:0.1:1) * const_externalCurrent;
        externalCurrent = zeros(100, 1);
        for i = 0:9
            externalCurrent(10 * i + 1 : 10 * i + 10) = external_no_repet(i+1);
        end
% 
%     externalCurrent = zeros(10 * length(externalCurrent_no_zeros), 1);
%     externalCurrent(1:10:end) = externalCurrent_no_zeros;
    %hugeCurrent = 5;
    %numHugeCurr = 5;
    wait_H = 0.1;
    wait_L = 0.15;
    wait_I = 0.2;

    savePath='C:\dan_noam_sc.git\data\090516\';
    fnamePattern='THI_manThermalAutoMeas_9';
    fname=nextAvailableFilename(savePath,fnamePattern,'csv');
    % header_all='Time(sec),TempRes(Ohm),SampVolt(V),SampCurr(A),CoilCurr(A),heat_current(A),coil_current_order(A), sample_current_order(A)\n';
    % header_skinny = 'Time(sec),TempRes(Ohm),SampVolt(V),heat_current(A),coil_current_order(A), sample_current_order(A)\n';
    header = 'Time(sec),TempRes(Ohm),SampVolt(V),extCurr(A),CoilCurr(A),intCurr(A),SampCurr_order(A),intCurr_sign,extCurr_sign';
    
    file=fopen(fname,'w+');
    fprintf(file,header);
    fclose(file);

    if nargin<=3 || ~exist('startTime','var')
        startTime=clock;
    end;

    for H_ind = 1:length(coilCurrent)
        %assert(to_escape == false)
        % set coil current
        fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,coilCurrent(H_ind)));
        pause(wait_H)
        % read temperature ressistance     
        fprintf(tempResDevice, 'READ?');
        tempResistance = readMeas(tempResDevice);
        % cycle over sample currents
        tempI = zeros(length(externalCurrent), 1);
        tempV = zeros(length(externalCurrent), 1);
        tempT = zeros(length(externalCurrent), 1);
        
        figure
        hold on
        for i_curr = 1:length(externalCurrent)
            current = externalCurrent(i_curr);
            fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,current));
            % if i_curr > 1 && sampleCurrent_diffs(i_curr - 1) > I_max_step
            pause(wait_I)
            fprintf(multi_meter_device2, 'READ?'); % make sure to read current!!!!
            fprintf(multi_meter_device, 'READ?');
            externalCurrent_act = readMeas(multi_meter_device2);
            sampleVoltage = readMeas(multi_meter_device);
            time=etime(clock,startTime);
            fprintf(tempResDevice, 'READ?');
            tempResistance = readMeas(tempResDevice);
            tempT(i_curr) = tempResistance;
            dlmwrite (fname,[time,tempResistance,...
                sampleVoltage, externalCurrent_act, coilCurrent(H_ind),...
                internalCurrent, current, internal_sign, const_external_Current_sign ],'-append');
            tempI(i_curr) = externalCurrent_act;
            tempV(i_curr) = sampleVoltage;
            if externalCurrent(i_curr) > 0
                plot(time, sampleVoltage, '*r')
            else
                plot(time, sampleVoltage, '*b')
            end
            
        end
        fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,0));
        pause(wait_L);
        
  
      
        figure
        plot(tempI, tempV, '.')
        title(num2str([internalCurrent * internal_sign, const_externalCurrent * const_external_Current_sign]))
        xlabel('I')
        ylabel('V')
        figure
        plot(tempT)
        %plot(tempI, tempV, '.')
        pause(wait_L)
    end
    
%     fprintf(coilCurrentDevice,'OUTPUT OFF');
    fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,0));

    %fprintf(sampleCurrentDevice,'OUTPUT OFF');
    fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,0));
    
catch err
    disp (err);

    %fprintf(coilCurrentDevice,'OUTPUT OFF');
    disp('note!!!! output is still on!!!!!!!')
    fprintf(coilCurrentDevice,sprintf ('APPL %f, %f',15,0));

%     fprintf(sampleCurrentDevice,'OUTPUT OFF');
    fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,0));
    
    fclose(tempResDevice);
    fclose(sampleVoltageDevice);
    fclose(sampleCurrentDevice);
    fclose(coilCurrentDevice);
    fclose(multi_meter_device);
    fclose(multi_meter_device2);

    didCloseDevices=true;
    rethrow (err);
end

if ~didCloseDevices
    fclose(tempResDevice);
    fclose(sampleVoltageDevice);
    fclose(sampleCurrentDevice);
    fclose(coilCurrentDevice);
    fclose(multi_meter_device);
    fclose(multi_meter_device2);
end

disp('measurement done!')
