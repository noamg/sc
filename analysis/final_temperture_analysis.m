% it seems that T_fin = T_LN + alpha * I_heat ** 2
% alpha = 9.1 ohm / deciampere ** 2 = 910 ohm / ampere ** 2
I_heat = 10 .* [0.104, 0.108, 0.115, 0.130, 0.139];
T_fin = [34.44, 35.12, 36.49, 40.01, 42.1];
T_err = 0.02 * ones(length(T_fin), 1);
figure()
plot(I_heat, T_fin, '.')
errorbar(I_heat, T_fin, T_err, '.')
title('T_fin(I_heat)')
xlim([0, 5])
ylim([0, 50])
figure()
hold
plot(I_heat .^ 2, T_fin, '.')
errorbar(I_heat .^ 2, T_fin, T_err, '.')
title('T_fin(I_heat ** 2)')
xlim([0, 5])
ylim([0, 50])
p = polyfit(I_heat .^ 2, T_fin, 1);
yfit = p(1) * I_heat .^ 2 + p(2);
plot(I_heat .^ 2, yfit)


