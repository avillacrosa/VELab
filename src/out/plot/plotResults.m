function plotResults(Geo, Mat, Set, Result)
	if Geo.dim == 2
		femplot(Geo.X,Result.x(:,:,end),Geo.n)
	end
	if Set.plot_stress && Mat.visco ~=0
		if Geo.dim == 2
			plotStress2D(Geo, Mat, Set, Result);
		elseif Geo.dim == 3
			plotStress3D(Geo, Mat, Set, Result);
		end
	end
	if Set.plot_strain && Mat.visco ~=0
		if Geo.dim == 2
			plotStrain2D(Geo, Mat, Set, Result);
		elseif Geo.dim == 3
			plotStrain3D(Geo, Mat, Set, Result);
		end
	end
end