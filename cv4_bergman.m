clc
clear
close all

%% load
T = readtable('Dat_FK.csv',"NumHeaderLines",2);
ar = table2array(T);
T = ar(:,1);
I = ar(:,2) / 6;

T2 = readtable('Dat_FD.csv',"NumHeaderLines",2);
ar2 = table2array(T2);
T2 = ar2(:,1);
I2 = ar2(:,2) / 64.4;
%% visualize
figure(1)
title('Toky glukozy')
hold on
xlabel('Cas [min]');
ylabel('[mg/kg/min]');
plot(T2,I2,'ok');

figure(2)
title('Toky glukozy')
hold on
xlabel('Cas [min]');
ylabel('[mg/kg/min]');
plot(T2,I2,'ok');

figure(3)
hold on
title('Glykemia');

%% vzorove data
TI = 44.55;
kI = 0.1645;
VI = 138.8;
S1b = 1.2528e4;
S2b = S1b;
Ib = 12.3165;

%berg
Si = 0.00159;
p2 = 0.0106;
Sg = 0;
Vg = 1.467;
Gb = 153;
s1 = sim('bergman');
figure(1)
plot(s1.int);
figure(2)
plot(s1.product);
figure(3)
s1.G.Data = s1.G.Data/18;
plot(s1.G);
load('paramsFull1');
Si = Best(1) / 10;
p2 = Best(2) / 10;
s1 = sim('bergman');
figure(1)
plot(s1.int);
legend('PD','Ra(t)','Ra(t)[GA]');
figure(2)
plot(s1.product);
legend('PD','V_GX(t)G(t)','V_GX(t)G(t)[GA]');

figure(3)

s1.G.Data = s1.G.Data/18;
plot(s1.G);
plot([0,600],[Gb Gb]/18,'--');
legend('G(t)','G(t)[GA]','Gb');
ylabel('[mmol/l]');
xlabel('Cas [min]');