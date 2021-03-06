function vStr = writeVec(f, label)
    vStr = sprintf("VECTORS %s float\n", label);
    for t_i = 1:size(f,1)
        t = f(t_i,:);
        vStr = vStr + sprintf("%.9f %.9f %.9f \n",...
            t(1), t(2), t(3));
    end
end