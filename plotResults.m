function plotResults(Geo, Mat, Set, Result)
	if Geo.dim == 2
		femplot(Geo.X,Result.x(:,:,end),Geo.n)
	end
	if Set.plot_stress
		figure
		hold on
		plot(Result.time, reshape(max(Result.stress(:,1,:),[],1), size(Result.time)), 'o');
		plot(Result.time, reshape(max(Result.stress(:,2,:),[],1), size(Result.time)), 'o');
		plot(Result.time, reshape(max(Result.stress(:,3,:),[],1), size(Result.time)), 'o');
		ylabel("\sigma", "FontSize", 14);
		xlabel("t(s)", "FontSize", 12)
		lgd = legend(["\sigma_{xx}","\sigma_{yy}", "\sigma_{zz}"]);
		lgd.FontSize = 10;
		lgd.Location = 'northwest';
	end
	if Set.plot_strain
		figure
		hold on
		plot(Result.time, reshape(max(Result.strain(:,1,:),[],1), size(Result.time)), 'o');
		plot(Result.time, reshape(max(Result.strain(:,2,:),[],1), size(Result.time)), 'o');
		plot(Result.time, reshape(max(Result.strain(:,3,:),[],1), size(Result.time)), 'o');
		lgdStr = [char(949)+"_{xx}",char(949)+"_{yy}", char(949)+"_{zz}"];
		ylabel(char(949), "FontSize", 14);
		xlabel("t(s)", "FontSize", 12)
		if strcmpi(Mat.rheo, 'kelvin')
			strain_x = max(abs(Result.stress(:,1,1)))/Mat.E*(1-exp(-Mat.E*Result.time/Mat.visco));
			lgdStr(end+1) = "1D Solution";
			plot(Result.time, strain_x);
		end
		lgd = legend(lgdStr);
		lgd.FontSize = 10;
		lgd.Location = 'northwest';

	end
end