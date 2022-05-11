function Geo = buildTFM(Geo)
%     if isfield(Geo, 'u_file')
%         u = load(Geo.u(1));
%     else
%         u = Geo.u;
%     end
% 	if isfield(ustruct, 'ux')
%         nx = size(ustruct.ux,1);
%         ny = size(ustruct.ux,2);
%     elseif  size(ustruct,2) >= 4
%     xs = unique(u(:,1)); ys = unique(u(:,2));
%     nx = numel(xs);
%     ny = numel(ys);
%     Geo.ds(1) = xs(2) - xs(1);
%     Geo.ds(2) = ys(2) - ys(1);
% 	end
    Geo.ns         = [nx, ny, Geo.ns(1)];
end