function n = read_n(dat, n_r)
    % TODO hardcoded number of nodes per elements...
    n_e = 8;
    n = zeros(0,n_e);
    for i = n_r(1):n_r(2)
        line = dat(i);
        if ~any(ismember(upper(line{1}),'A':'Z'))
            ns = regexp(line{1},' +','split');
            if size(ns,2) ~= 1
                ni = zeros(n_e,1);
                for j = 1:n_e
                    ni(j,:) = str2num(ns{j});
                end
                n(end+1,:)=ni;
            end
        end
    end
end