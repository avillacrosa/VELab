function x0 = read_x0(dat, x0_r)

    ax_to_int = ["X", "Y", "Z"];

    x0 = zeros(0,3);
    for i = x0_r(1):x0_r(2)
        line = dat(i);
        if any(ismember(upper(line{1}),'0':'9'))
            x0s = regexp(line{1},' +','split');
            if size(x0s,2) ~= 1
                x0i = [str2double(x0s{1}), ...
                       find(ax_to_int==x0s{2}), ...
                       str2double(x0s{3})];
                x0(end+1,:) = x0i; 
            end
        end
    end
end