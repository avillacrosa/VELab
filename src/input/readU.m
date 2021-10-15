function u = readU(file, dim)
    if endsWith(file, '.mat')
        ustruct = load(file);
        u       = ustruct.usave;
    else
        u_data = regexp(fileread(file),'\n','split');
        u_data = u_data(~cellfun('isempty',u_data));
        u = zeros(0,dim);
        for u_l = 1:size(u_data,2)
            line = strtrim(u_data(:,u_l));
            us = regexp(line{1},' +','split');
            ux = str2double(us{1});
            uy = str2double(us{2});
            if dim == 2
                u(end+1,:) = [ux, uy];
            elseif dim == 3
                uz = str2double(us{3});
                u(end+1,:) = [ux, uy, uz];
            end
        end
    end
end