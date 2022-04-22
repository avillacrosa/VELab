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
		lgdStr = ["\sigma_{xx}","\sigma_{yy}", "\sigma_{zz}"];
		ylabel("\sigma", "FontSize", 14);
		xlabel("t(s)", "FontSize", 12)
		if strcmpi(Mat.rheo, 'maxwell')
			stress_1d = max(abs(Result.strain(:,1,1)))*Mat.E*exp(-Mat.E*Result.time/Mat.visco);
			lgdStr(end+1) = "1D Solution";
			plot(Result.time, stress_1d);
		end
		lgd = legend(lgdStr);
		lgd.FontSize = 10;
		lgd.Location = 'northeast';
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
			strain_1d = max(abs(Result.stress(:,1,1)))/Mat.E*(1-exp(-Mat.E*Result.time/Mat.visco));
			lgdStr(end+1) = "1D Solution";
			plot(Result.time, strain_1d);
		end
		lgd = legend(lgdStr);
		lgd.FontSize = 10;
		lgd.Location = 'northwest';
		figure
		hold on
% 		[~, xy] = max(abs(Result.strain(:,4,:)),[],1,'linear');
% 		[~, xz] = max(abs(Result.strain(:,5,:)),[],1,'linear');
% 		[~, yz] = max(abs(Result.strain(:,6,:)),[],1,'linear');
% 		epsxy = Result.strain(:,4,:);
% 		epsxz = Result.strain(:,5,:);
% 		epsyz = Result.strain(:,6,:);
		plot(Result.time, reshape(max(Result.strain(:,4,:),[],1), size(Result.time)), 'o');
		plot(Result.time, reshape(max(Result.strain(:,5,:),[],1), size(Result.time)), 'o');
		plot(Result.time, reshape(max(Result.strain(:,6,:),[],1), size(Result.time)), 'o');
% 		plot(Result.time, reshape(epsxy(xy), size(Result.time)), 'o');
% 		plot(Result.time, reshape(epsxz(xz), size(Result.time)), 'o');
% 		plot(Result.time, reshape(epsyz(yz), size(Result.time)), 'o');
		lgdStr = [char(949)+"_{xy}",char(949)+"_{xz}", char(949)+"_{yz}"];
		ylabel(char(949), "FontSize", 14);
		xlabel("t(s)", "FontSize", 12)
		if Geo.w ~= 0
			strain_1d = max(abs(Result.strain(:,4,:)),[], "all")*abs(sin(Geo.w*Result.time));
			lgdStr(end+1) = "1D Solution";
			plot(Result.time, strain_1d);
		end
		lgd = legend(lgdStr);
		lgd.FontSize = 10;
		lgd.Location = 'northwest';

		
	end
end