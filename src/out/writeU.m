function writeU(Geo, Set, Result, name)    
    if strcmpi(Set.output, 'normal')
        usave = Result.u;
        save(sprintf('output/u_%s.mat', name), 'usave');
    elseif strcmpi(Set.output, 'tfm')
        zmax = Result.x(:,3)==max(Result.x(:,3));
        Result.u(zmax,:);
        ux = Result.u(zmax, 1);
        uy = Result.u(zmax, 2);
        ux = reshape(ux, [Geo.ns(1), Geo.ns(1)])';
        uy = reshape(uy, [Geo.ns(2), Geo.ns(2)])';
        save(sprintf('output/u_%s.mat', name), 'ux', 'uy');
    end
    
    u_str = "";
    for ui = 1:size(Result.u,1)
        u = Result.u(ui,:);
        if Geo.dim == 2
            u_str = u_str + sprintf("%.3f %.3f \n", u(1), u(2));
        elseif Geo.dim == 3
            u_str = u_str + sprintf("%.3f %.3f %.3f \n", u(1), u(2), u(3));
        end
        
    end
    fileH = fopen(sprintf('output/u_%s.txt', name), 'w+');
    fprintf(fileH, u_str);
end