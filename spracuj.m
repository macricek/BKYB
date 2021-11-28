clc
clear
close all

tout = 1:180;
o = ones(1,5);
tep = [o*125 o*121 o*119 o*113 o*110 o*108 o*105 o*101 o*102 o*97 o*95 o*94, ...
       o*92 o*93 o*90 o*90 o*87 o*92 o*88 o*85 o*85 o*86 o*82 o*81, ...
       o*81, o*79, o*77, o*80, o*81, o*82, o*79, o*77, o*78, o*80, o*81, o*79];

plot(tout,tep)


tepN = tep -77;
plot(tout,tepN)
outS.time = tout;
outS.signals.values = tep';
outS.signals.dimensions = 1;

save('tep.mat');