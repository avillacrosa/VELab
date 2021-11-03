%--------------------------------------------------------------------------
% Obtain the B 2nd rank tensor including the vectorized shape function
% derivatives with respect to x
%--------------------------------------------------------------------------
function B = getB(dNdx)
    n = size(dNdx,1);
    d = size(dNdx,2);
    
    B = zeros(d*(d+1)/2,d,n);
    
    for h = 1:n
        if d == 2
            B(:,:,h) = [dNdx(h,1)      0         
                            0        dNdx(h,2)   
                         dNdx(h,2)   dNdx(h,1)];
        elseif d == 3
            B(:,:,h) = [dNdx(h,1)      0          0 
                            0       dNdx(h,2)     0
                            0          0        dNdx(h,3)   
                         dNdx(h,2)   dNdx(h,1)    0
                         dNdx(h,3)     0        dNdx(h,1)
                            0        dNdx(h,3)  dNdx(h,2)];
        end
    end
end