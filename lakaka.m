clear;
clc;
close all;

Ts = 0.1;
%% read data
basal = csvread("./Dat_D01_Basal.csv");
bolus = csvread("./Dat_D01_bolus.csv");
dat_CalBG = csvread("./Dat_D01_CalBG.csv");
carb = csvread("./Dat_D01_carb.csv");
dat_sensor = csvread("./Dat_D01_sensor.csv");
bolus(:, 2) = bolus(:, 2) * 10^6/64.5/5;
bolus = createImpulse(bolus, 5);
basal(:, 2) = basal(:, 2) * 10^6/64.5/60;
carb(:, 2) = carb(:, 2) * 10 *10^3/64.5/5;
carb = createImpulse(carb, 5);


%% set parameters

Ag = 0.95;
%id
Td = 33.474;
Sg = 0.032;

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

%% visualize
figure(1)
title('Toky glukozy')
hold on
xlabel('Cas [min]');
ylabel('[mg/kg/min]');

figure(2)
title('Toky glukozy')
hold on
xlabel('Cas [min]');
ylabel('[mg/kg/min]');

figure(3)
hold on
title('Glykemia');

figure(1)
plot(s1.int);
figure(2)
plot(s1.product);
figure(3)
s1.G.Data = s1.G.Data/18;
plot(s1.G);

