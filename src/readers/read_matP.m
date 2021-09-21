function P = read_matP(dat, P_r)
    % TODO hardcoded dimension...
    P = zeros(0,2);
    for i = P_r(1):P_r(2)
        line = dat(i);
        if ~any(ismember(upper(line{1}),'A':'Z'))
            Ps = regexp(line{1},' +','split');
            if size(Ps,2) ~= 1
                P(end+1,:)=[str2num(Ps{1}), str2num(Ps{2})];
            end
        end
    end
end