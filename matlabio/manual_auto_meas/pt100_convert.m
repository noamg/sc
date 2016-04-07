function T_out = pt100_convert(R_in,T2R)
    % T2R - optional flag to calc Ressistance for temperature (assumes R_in is temp in kelvin and returns res in T_out)
    T_a = 273.15;
    r_pt100_a = 100;
    r_pt100_b = 80.31;
    T_b = -50 + 273.15;
    if nargin == 1 || ~T2R
        T_out = T_a + (T_b - T_a) / (r_pt100_b - r_pt100_a) * (R_in - r_pt100_a);
    else
        T_out = r_pt100_a + (R_in - T_a)/(T_b-T_a)*(r_pt100_b - r_pt100_a);
    end
end