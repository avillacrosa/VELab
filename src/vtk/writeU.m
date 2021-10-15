function uStr = writeU(u)
    uStr = "VECTORS Displacements float\n";
    for u_i = 1:size(u,1)
        uc = u(u_i,:);
        uStr = uStr + sprintf("%.2f %.2f %.2f \n", uc(1), uc(2), uc(3));
    end
end