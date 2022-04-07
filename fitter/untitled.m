figure
ah = axes;
x = linspace(0, 3*pi);
y1 = sin(x);
y2 = sin(x - pi/4);
hold on;
p1 = plot(x,y1);
p3 = plot(x,y1, '*');
p2 = plot(x,y2);
p4 = plot(x,y2,'+');
hold off
%% Plot the first legend
lh = legend(ah, [p1 p2], 'p1', 'p2');
lh.Location='North';
%% Copy the axes and plot the second legned
ah2 = copyobj(ah, gcf);
lh2 = legend(ah2, [p3 p4], 'p3', 'p4');
lh2.Location='South';