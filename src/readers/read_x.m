function x = read_x(dat, x_r)
    % TODO hardcoded dimension...
    x = zeros(0,3);
    for i = x_r(1):x_r(2)
        line = dat(i);
        if ~any(ismember(upper(line{1}),'A':'Z'))
            xs = regexp(line{1},' +','split');
            if size(xs,2) ~= 1
                if size(xs, 2) == 2
                    x(end+1,:)=[str2num(xs{1}), str2num(xs{2})];
                elseif size(xs, 2) == 3
                    x(end+1,:)=[str2num(xs{1}), str2num(xs{2}), str2num(xs{3})];
                end
            end
        end
    end
end