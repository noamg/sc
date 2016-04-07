T_a = 273.15;
r_pt100_a = 100;
r_pt100_b = 80.31;
T_b = -50 + 273.15;

pt100_convert = @(R) (T_a + (T_b - T_a) / (r_pt100_b - r_pt100_a) * (R - r_pt100_a));

% disp(pt100_convert([100, 103.9, 107.79, 111.67, 115.54, 119.4]) - 273.15);

decay = @(T_i, b, T_f, t) (T_i - T_f) * exp(-b * t) + T_f;

for i = 1 : length(t_seps) - 1
    is_between = t6 > t_seps(i) & t6 < t_seps(i + 1);
    t_temp_global = t6(is_between);
    T_temp = T6(is_between);
    t_temp = t_temp_global - t_temp_global(1);
    
    fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0, 75],...
               'Upper',[Inf,inf, inf],...
               'StartPoint',[T_temp(1), 0.004, T_temp(end)]);
    fit_type = fittype(decay, 'independent', 't', 'options', fo);

   
    fits{i} = fit(t_temp, T_temp, fit_type);
    figure()
    hold
    plot(t_temp, T_temp, '.')
    plot(t_temp, decay(fits{i}.T_i, fits{i}.b, fits{i}.T_f, t_temp), 'r')
    title(fits{i}.T_f)
    
end