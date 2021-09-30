function uStr = writeU(Result)
    uStr = "VECTORS Displacements float\n";
    for u_i = 1:size(Result.u,1)
        u = Result.u(u_i,:);
        uStr = uStr + sprintf("%.2f %.2f %.2f \n", u(1), u(2), u(3));
    end
end