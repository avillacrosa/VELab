function tStr = writeT(Result)
    tStr = "VECTORS Forces float\n";
    for t_i = 1:size(Result.t,1)
        t = Result.t(t_i,:);
        tStr = tStr + sprintf("%.2f %.2f %.2f \n",...
            t(1), t(2), t(3));
    end
end