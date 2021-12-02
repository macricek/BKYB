% clc
% close all
% clear
load('arxt.mat');
DATA = iddata(o,i,Ts);
SYS = arx(DATA, [10 10 0]);
figure
compare(DATA,SYS)
tf1 = idtf(SYS);
Num1 = tf1.Numerator;
Den1 = tf1.Denominator;
