function t = read_t(dat, t_r)

    ax_to_int = ["X", "Y", "Z"];

    t = zeros(0,3);
    for i = t_r(1):t_r(2)
        line = dat(i);
        if any(ismember(upper(line{1}),'0':'9'))
            x0s = regexp(line{1},' +','split');
            if size(x0s,2) ~= 1
                x0i = [str2double(x0s{1}), ...
                       find(ax_to_int==x0s{2}), ...
                       str2double(x0s{3})];
                t(end+1,:) = x0i; 
            end
        end
    end
end