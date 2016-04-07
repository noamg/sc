function T_out = pt100_convert(R_in)
    T_a = 273.15;
    r_pt100_a = 100;
    r_pt100_b = 80.31;
    T_b = -50 + 273.15;
    T_out = T_a + (T_b - T_a) / (r_pt100_b - r_pt100_a) * (R_in - r_pt100_a);
end