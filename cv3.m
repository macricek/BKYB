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
ylabel('[mmol/l]');
plot(ar(:,1),ar(:,2),'r*');
plot(xq,glucose_int,'--');

figure(2)
hold on
title('Inzulin IVGTT [SN]')
xlabel('time[min]');
ylabel('I(t) [mikroU/ml]');
plot(ar(:,1),ar(:,3),'r*');
plot(xq,insuline_int,'--');

%% simulacia
p2 = 3.2736e-2;
Si = 1.0278e-13;
p3 = Si*p2;
Sg = 3.0031e-2;
G_0 = 14.9;

Ib = insuline(1);
Gb = glucose(1);
