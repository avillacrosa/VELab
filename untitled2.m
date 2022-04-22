x0 = [7,5];
r0 = [2 2];
rpl = norm(x0-r0);

nt = 1000;
xt = zeros(nt,2);
hold on
plot(r0(1),r0(2), 'o')
plot(x0(1),x0(2), 'o')
for t = 1:10000
	ui = [0,0];
	ui(1) = rpl*sin(0.001*t)-x0(1);
	ui(2) = rpl*cos(0.001*t)-x0(2);
	xt(t,:) = x0+ui+r0;
end
plot(xt(:,1), xt(:,2), 'o');

x0 = [7,-5];
r0 = [2 2];
rpl = norm(x0-r0);

nt = 1000;
xt = zeros(nt,2);
hold on
plot(r0(1),r0(2), 'o')
plot(x0(1),x0(2), 'o')
for t = 1:10000
	ui = [0,0];
	ui(1) = rpl*sin(0.001*t)-x0(1);
	ui(2) = rpl*cos(0.001*t)-x0(2);
	xt(t,:) = x0+ui+r0;
end
plot(xt(:,1), xt(:,2), 'o');