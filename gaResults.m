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

close all
clc
clear

%% load
T = readtable('Dat_IVGTT_SN.csv');
ar = table2array(T);
time = ar(:,1);
glucose = ar(:,2);
insuline = ar(:,3);
%vq = interp1(x,v,xq)
xq = time(1):0.01:time(end);
glucose_int = interp1(time,glucose,xq);
insuline_int = interp1(time,insuline,xq);
%ar(1,:) = ar(1,:)*60; %min to sec

%% vizualizacia
figure(1)
hold on
title('Glykemia IVGTT [SN]')
xlabel('time [min]');
ylabel('G(t) [mmol/l]');
plot(ar(:,1),ar(:,2),'r*');
plot(xq,glucose_int,'--');
legend('Merane','Interpolovane');

figure(2)
hold on
title('Inzulin IVGTT [SN]')
xlabel('time[min]');
ylabel('I(t) [mikroU/ml]');
plot(ar(:,1),ar(:,3),'r*');
plot(xq,insuline_int,'--');
legend('Merane','Interpolovane');

%% simulacia
p2 = 3.2736e-2;
Si = 1.0278e-13;

Sg = 3.0031e-2;
G_0 = 14.9;

p3 = Si*p2;
Ib = insuline(1);
Gb = glucose(1);
s = sim('bergman');

figure(1)
plot(s.G);

figure(3)
hold on
plot(s.X);
title('X IVGTT [SN]')
xlabel('time [min]');
ylabel('X(t) [l/min]');

%% simulacia
load('params3');
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
title('X IVGTT [SN]')
xlabel('time [min]');
ylabel('X(t) [l/min]');
legend('Model','GA model');

figure(5)
plot(grafFit);
title('Vyvoj ucelovej funkcie');
xlabel('Pocet cyklov');
ylabel('F(x)');