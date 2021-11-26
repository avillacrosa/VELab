function [tx,ty]=inverseBSSNSQ(E,nu,d,h,ux,uy,usemode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This subroutine computes a traction field T=(tx,ty) from
% a displacement field (ux,uy) of a flat semi-infinite elastic slab
% having Young Modulus (Stiffness) E and Poisson Ration nu by means of
% the algorithm/theory implemented in 
% Trepat et al. Physical forces during collective cell migration.
% Nature Physics (2009). Supplement 3 


%by  Vito Conte and Jose Mu?oz
%based on a previous formulation by Xavier Trepat et al.

% VARIABLES:
%usemode=0: algorithm based on classic Boussinesq formula, which doesn't account for gel's height
%usemode=1: algorithm based on corrected Boussinesq formula, which account for gel's height (see formula (S7) in Trepat et al. Nature Physics (2009))
% E: Young Modulus
% nu: Poisson Ratio %0.457 Takigawa et al
% d: pace of the mesh in x and y , i.e. size of the traction pixel (cross-correlation window of the PIV on lfuorescent beads producing displacements)
% h: height of the hydrogel
% ux: x-component of the gel's displacement field
% uy: y-component of the gel's displacement field
% N.B.: IF ALL LENGTHS Dx, Dy, d, and h ARE IN METRES then E, Tx and Ty WILL ALL BE IN PASCALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tx_hat=NaN*ux.';% initialise (see formula S4 of Supplement 3) 
ty_hat=NaN*uy.';%initialise (see formula S5 of Supplement 3) 

% useful factors often appearing in formulas of Supplement 3
s1=size(ux,1);%vertical size of displacement matrix
s2=size(ux,2);%horizontal size of displacement matrix
M=s1*d;%vertical dimension of the lattice in units of length
N=s2*d;%horizontal dimension of the lattice in units of length
two_pi_M=2*pi/M;
two_pi_N=2*pi/N;
f1p1=1+nu; 
f1m1=1-nu; 
f12=1-2*nu;
f34=3-4*nu;
f112=1-nu^2; 
mu=E/(2*(1+nu));
u0_hat=fft2(ux).'; % map x-displacement field in the Fourier Space (u0_hat in formulas S7)
v0_hat=fft2(uy).'; % map y-displacement field in the Fourier Space (v0_hat in formulas S7)

for j=1:s2
    for i=1:s1
        %DETERMINE THE WAVE VECTOR k=(alpha,beta) in each point of the matrix from formulas (S1)
        %N.B.1 This is a DISCRETE FOURIER TRANSFORM on A GRID of dimensions M=s1 and N=S2 (in units of length)
        %N.B.2 Supplement 3 defines VECTOR r=(x,y), which means the Fourier Transform is utilising the field theory convention 
        %      i.e. factors of 2pi/M and 2pi/N are included in the frequency/wavevector domain integrals and is therefore included in the VECTOR k
        if j<=s2/2%determine alpha, the first component of k
            alpha=(j-1)*two_pi_N;
        else
            alpha=(j-1-s2)*two_pi_N;
        end
        if i<=s1/2%determine beta, the second component of k
            beta=(i-1)*two_pi_M;
        else
            beta=(i-1-s1)*two_pi_M;
        end
        k=sqrt(alpha^2+beta^2);
        r=k*h;
        s=sinh(r);
        c=cosh(r);
        gamma=((f34*c^2)+f12^2+r^2)/(f34*s*c+r);
        %DETERMINE TRACTIONS IN FOURIER SPACE via formulas S4,S5 and S6
        if k==0 %long-wavelengths approximation (see formula S6)
            tx_hat(1,1)=mu*u0_hat(1,1)/h;
            ty_hat(1,1)=mu*v0_hat(1,1)/h;
        else %for finite wavelengths use formulas S4 and S6
            u0h_ij=u0_hat(j,i); %fourier coeficients of the displacement field.
            v0h_ij=v0_hat(j,i);
            switch usemode
                case{-1}%CLASSIC BOUSSINESQ
                    %short-wavelengths approximation [do not account for gel's height and use classic Boussinseq formulas (S7) in Trepat et al. 2009]
                    tx_hat(j,i)=E*(u0h_ij*(k^2*f1m1+alpha^2*nu))/(2*f112*k);
                    ty_hat(j,i)=E*(v0h_ij*(k^2*f1m1+beta^2*nu))/(2*f112*k);
                case{1}%CORRECTED BOUSSINESQ, BEST
                    %account for gel's height h and use corrected Boussinesq formulas (S4,S5) in Trepat et al. 2009
                    tx_hat(j,i)=-E*beta *c*(v0h_ij*alpha-u0h_ij*beta)/(2*f1p1*k*s) ...
                        + E*alpha*gamma*(alpha*u0h_ij+beta*v0h_ij)/(2*f112*k);
                    ty_hat(j,i)=+E*alpha*c*(v0h_ij*alpha-u0h_ij*beta)/(2*f1p1*k*s) ...
                        + E*beta *gamma*(alpha*u0h_ij+beta*v0h_ij)/(2*f112*k);
            end
        end
    end
end
%map back to non-transformed space
tx=real(ifft2(tx_hat).');
ty=real(ifft2(ty_hat).');
