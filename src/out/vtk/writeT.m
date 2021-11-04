function tStr = writeT(f, label)
    tStr = sprintf("VECTORS %s float\n", label);
    for t_i = 1:size(f,1)
        t = f(t_i,:);
        tStr = tStr + sprintf("%.2f %.2f %.2f \n",...
            t(1), t(2), t(3));
    end
end