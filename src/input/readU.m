function u = readU(file)
    u_data = regexp(fileread(file),'\n','split');
    u = zeros(0,3);
    for u_l = 1:size(u_data,2)
        line = strtrim(u_data(:,u_l));
        us = regexp(line{1},' +','split');
        ux = str2double(us{1});
        uy = str2double(us{2});
        uz = str2double(us{3});
        u(end+1,:) = [ux, uy, uz];
    end
end