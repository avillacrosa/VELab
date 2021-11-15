function writeU(Result, Geo, Set, name)    
    u = Result.u;
    if strcmpi(Set.output, 'normal')
        if isfield(Result,'times')
            t = Result.times;
        else
            t = 0;
        end
        save(sprintf('output/u_%s.mat', name), 'u', 't');    
    elseif strcmpi(Set.output, 'tfm')
        ux = zeros(Geo.ns(1), Geo.ns(1), size(u,3));
        uy = zeros(Geo.ns(2), Geo.ns(2), size(u,3));
        % Yeah...
        zmax = Geo.X(:,3)==max(Geo.X(:,3));
        for ti = 1:size(u,3)
            ut = u(:,:,ti);
            uxt = ut(zmax, 1);
            uyt = ut(zmax, 2);
            uxt = reshape(uxt, [Geo.ns(1), Geo.ns(1)])';
            uyt = reshape(uyt, [Geo.ns(2), Geo.ns(2)])';
            ux(:,:,ti) = uxt;
            uy(:,:,ti) = uyt;
        end
        
        if isfield(Result,'times')
            t = Result.times;
        else
            t = 0;
        end
        save(sprintf('output/u_%s.mat', name), 'ux', 'uy', 't');
    end
%     u_str = "";
%     for ui = 1:size(u,1)
%         ut = u(ui,:);
%         if Geo.dim == 2
%             u_str = u_str + sprintf("%.3f %.3f \n", ut(1), ut(2));
%         elseif Geo.dim == 3
%             u_str = u_str + sprintf("%.3f %.3f %.3f \n", ut(1), ut(2), ut(3));
%         end
%         
%     end
%     fileH = fopen(sprintf('output/u_%s.txt', name), 'w+');
%     fprintf(fileH, u_str);
end