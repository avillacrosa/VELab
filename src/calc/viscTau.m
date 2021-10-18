function tau = viscTau(time, series, target_f)
    tau = zeros(size(series,2),1);
    %TODO FIXIT Yeah...
    for tx = 1:1
        f0 = series(end,tx)*target_f;
        tau(tx) = interp1(series(:,tx), time, f0);
    end
end