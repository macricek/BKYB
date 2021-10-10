clc
clear
close all

%% data for simulation
global time;
global glucose;
global insuline;
global xq;
global glucose_int;
global insuline_int;
global Ib;
global Gb;
global p2;
global Si;
global Sg;
global G_0;

%cv3
cv3a

%% simulacia
%load('params3');
load('paramsRI');
p2 = Best(1);%3.2736e-2;
Si = Best(2);%1.0278e-13;
Sg = Best(3);%3.0031e-2;
G_0 = Best(4);%14.9;

p3 = Si*p2;
Ib = insuline(1);
Gb = glucose(1);
s = sim('bergman');

figure(1)
plot(s.G);
legend('Namerane','Interpolovane','Model','GA model');

figure(3)
plot(s.X);
legend('Model','GA model');

figure(5)
plot(grafFit);
title('Vyvoj ucelovej funkcie');
xlabel('Pocet cyklov');
ylabel('F(x)');