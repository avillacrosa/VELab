% MX plot
% k = 2*Result.P(2);
% theoStress = (k*Result.strain_0(1))*(exp(-k*Result.times));
% plot(Result.times, Result.sigmas(:,1),'LineWidth',2)
% hold on
% plot(Result.times, theoStress, '--','LineWidth',2);
% legend('Solution','Theoretical')
% xlabel("t")
% ylabel("strain")

% KV plot
% k = 2*Result.P(2);
% theoStr = (Result.sigma_0(1)/k)*(1-exp(-k*Result.times));
% 
% plot(Result.times, Result.strs(:,1),'LineWidth',2)
% hold on
% plot(Result.times, theoStr, '--','LineWidth',2);
% legend('Solution','Theoretical')
% xlabel("t")
% ylabel("stress")