function [startTime]=visa_yoni_manThermalAutoMeas_6a(heatCurr,coilCurrent, is_external, startTime)
disp('make sure that you set heat current manualy to the func!')
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
    fprintf(sampleCurrentDevice,sprintf ('APPL P25V, %f %f',25,heatCurr));
    
    %scSmallDelta = 0.1;
    %scN = 3;
    if is_external
        sampleCurrent_no_zeros=linspace(0, 3.9, 15);
        fnamePattern='THI_manThrmAutoMeas_6_external';
    else
%         sampleCurrent_no_zeros=linspace(0, 3, 15);
        sampleCurrent_no_zeros=linspace(4, 0, 30);
        fnamePattern='THI_manThrmAutoMeas_6_internal';
    end
    sampleCurrent = sampleCurrent_no_zeros;
%     sampleCurrent = zeros(2 * length(sampleCurrent_no_zeros), 1);
%     sampleCurrent(2:2:end) = sampleCurrent_no_zeros;
    sampleCurrent_diffs = diff(sampleCurrent);
    %hugeCurrent = 5;
    %numHugeCurr = 5;
    wait_H = 0.1;
    wait_L = 0.15;
    wait_I = 0.5;

    savePath='C:\dan_noam_sc.git\data\150516\';
    %fnamePattern='THI_manThrmAutoMeas_5';
    fname=nextAvailableFilename(savePath,fnamePattern,'csv');
    % header_all='Time(sec),TempRes(Ohm),SampVolt(V),SampCurr(A),CoilCurr(A),heat_current(A),coil_current_order(A), sample_current_order(A)\n';
    % header_skinny = 'Time(sec),TempRes(Ohm),SampVolt(V),heat_current(A),coil_current_order(A), sample_current_order(A)\n';
    header = 'Time(sec),TempRes(Ohm),SampVolt(V),SampCurr(A),CoilCurr(A),HeatingCurr(A),SampCurr_order(A)';
    
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
        tempI = zeros(length(sampleCurrent), 1);
        tempV = zeros(length(sampleCurrent), 1);
        
        for i_curr = 1:length(sampleCurrent)
            current = sampleCurrent(i_curr);
            fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,current));
            % if i_curr > 1 && sampleCurrent_diffs(i_curr - 1) > I_max_step
            pause(wait_I)
            fprintf(multi_meter_device2, 'READ?'); % make sure to read current!!!!
            fprintf(multi_meter_device, 'READ?');
            sampleCurrent_act = readMeas(multi_meter_device2);
            sampleVoltage = readMeas(multi_meter_device);
            time=etime(clock,startTime);
            dlmwrite (fname,[time,tempResistance,...
                sampleVoltage, sampleCurrent_act, coilCurrent(H_ind),...
                heatCurr, current ],'-append');
            tempI(i_curr) = sampleCurrent_act;
            tempV(i_curr) = sampleVoltage;
            
        end
        fprintf(sampleCurrentDevice,sprintf ('APPL P6V, %f, %f',6,0));
        pause(wait_L);
        
  
      
        figure
        %plot(tempI(2:2:end-2), tempV(2:2:end-2)-0.5*tempV(1:2:end-2)-0.5*tempV(3:2:end), '.')
        plot(tempI, tempV, '.')
        title(num2str(coilCurrent(H_ind)))
        xlabel('I')
        ylabel('V')
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
