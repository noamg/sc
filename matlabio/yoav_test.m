

coilCurrentDevice=openGPIBDevice('CONTEC',0,4);
% Current limit:
fprintf(coilCurrentDevice,'CURRENT:PROTECTION 4');
% Voltage limit:
fprintf(coilCurrentDevice,'VOLTAGE:PROTECTION:STATE 0');
% Output ON, duh
fprintf(coilCurrentDevice,'OUTPUT ON');
fprintf(coilCurrentDevice,sprintf('CURR %f',0));
fprintf(coilCurrentDevice,sprintf('VOLT %f',15));

