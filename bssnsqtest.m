function [Geo, Mat, Set] = bssnsqtest(Geo, Mat, Set)
    gel_height = 107.75; % gel_height/(Geo.ns(3)-1)
    %     settings.H = 1.0775e-04; %height of the hydrogel in meter from
    %     PIM's explist

    Geo.ns = [60,60,3];
    Geo.ds = [2 2 5];

    Geo.u   = 'random';   
    Geo.uBC = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 10 3 0];

    Mat.type  = 'hookean';
    Mat.E = 100; % In Pa
    Mat.nu = 0.3;

    Set.n_steps = 1;

    Set.newton_tol = 1e-4;
end
