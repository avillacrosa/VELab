function [Geo, Mat, Set] = tfm_ve(Geo, Mat, Set)
    nn = 2;
    dn = nn-1;
    Geo.ns = [nn nn 3];
    Geo.ds = [1/dn 1/dn 1/8];
    
    Geo.uBC = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 (Geo.ns(3)-1)*Geo.ds(3) 3 0];
    Geo.u   = 'output/u_tfm_ve_pre.mat';
    
    Mat.type  = 'hookean';
    Mat.visco = 1;
    Mat.rheo  = 'kelvin';
    Mat.P     = [57.6923 38.4615]; 

    Set.n_steps   = 1;
    Set.time_incr = 5;
    Set.save_freq = 1;
end