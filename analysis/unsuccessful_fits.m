for ind = 1:length(T_H_I)
    x = T_H_I(ind).I_sc;
    y = T_H_I(ind).v_sc*1e-3;
    ft = fittype('R*I^2/(c+I)','independent','I');
    fitted{ind} = fit(x,y,ft);
end

for ind = 1:length(T_H_I)
    ix = T_H_I(ind).v_sc > 5;
    if sum(ix)<3
        continue
    end
    x = T_H_I(ind).I_sc(ix);
    y = T_H_I(ind).v_sc(ix)*1e-3./T_H_I(ind).I_sc(ix).^2;
    ft = fittype('R/(c+I)','independent','I');
    fitted2{ind} = fit(x,y,ft);
end

for ind = 1:length(T_H_I)
    ix = T_H_I(ind).v_sc > 5;
    if sum(ix)<3
        continue
    end
    x = T_H_I(ind).I_sc(ix).^2./T_H_I(ind).v_sc(ix);
    y = T_H_I(ind).I_sc(ix);
    ft = fittype('R*I-c','independent','I');
    fitted3{ind} = fit(x,y,ft);
end