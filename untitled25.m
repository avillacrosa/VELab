s = 1:10;
d = 10:19;
c = 19:28;
a = 28:37;
ftfm  = fopen('test.txt','w+');
[s; d; c; a]
fprintf(ftfm,'%d %d %d %d \n', [s; d; c; a]);