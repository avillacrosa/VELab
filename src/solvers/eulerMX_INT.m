%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_t, u_v_t, T_t] = eulerMX_INT(u_t, u_v_t, dof, fix, dt, k, F_t, T_t, K, BB, Geo, Mat, Set)
	% Kv dot(u_v) = R
	% Ke dot(u - u_v) = dot(R)
	eta = Mat.visco;
	
	u_t_vec = ref_nvec(u_t(:,k), Geo.n_nodes, Geo.dim);
	u_t_v_vec = ref_nvec(u_v_t(:,k), Geo.n_nodes, Geo.dim);
	D = plane_stress(Geo.dim, Mat);
	u_v_t = dt/eta*u_t_vec*D - dt/eta*u_t_v_vec*D-u_t_v_vec;
	u_t(dof,k+1) = K(dof,dof)\...
					(F_t(dof,k+1)-F_t(dof,k)...
					-K(dof,dof)*(u_v_t(dof,k+1)-u_v_t(dof,k))...
					-K(dof,fix)*(u_v_t(fix,k+1)-u_v_t(fix,k))...
					-K(dof,fix)*(u_t(fix,k+1)-u_t(fix,k))...
					-u_t(dof,k));
end   
