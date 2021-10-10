close all
clc
clear

%% load
T = readtable('Dat_IVGTT_RI.csv');
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
title('Glykemia IVGTT [RI]')
xlabel('time [min]');
ylabel('G(t) [mmol/l]');
plot(ar(:,1),ar(:,2),'r*');
plot(xq,glucose_int,'--');
legend('Merane','Interpolovane');

figure(2)
hold on
title('Inzulin IVGTT [RI]')
xlabel('time[min]');
ylabel('I(t) [mikroU/ml]');
plot(ar(:,1),ar(:,3),'r*');
plot(xq,insuline_int,'--');
legend('Merane','Interpolovane');

%% simulacia
p2 = 6.3098e-2;
Si = 8.9844e-4;

Sg = 3.3574e-10;
G_0 = 13.5;

p3 = Si*p2;
Ib = insuline(1);
Gb = glucose(1);
s = sim('bergman');

figure(1)
plot(s.G);
legend('Namerane','Interpolovane','Model');

figure(3)
hold on
plot(s.X);
title('X IVGTT [RI]')
xlabel('time [min]');
ylabel('X(t) [l/min]');