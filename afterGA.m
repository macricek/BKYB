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

logic = dat_sensor(:,1) > 400;
dat_s = dat_sensor(logic,:);

%% set parameters
global Ag
global TI
global kI
global VI
global S1b
global S2b
global Ib
global Si
global p2
global Vg
global Gb
global Sg
global Td

Ag = 0.95;
%id

TI = 44.55;
kI = 0.1645;
VI = 138.8;
S1b = 1.2528e4;
S2b = S1b;
Ib = 12.3165;

%berg
Si = 0.00159;
p2 = 0.0106;
Vg = 1.467;
Gb = 153;
load('identified');
figure(4)
hold on
title('Proces GA');
ylabel('F(x)');
xlabel('Cykly');
plot(grafFit);
s1 = sim('bergman');
load('identified1');
figure(5)
hold on
title('Proces GA');
ylabel('F(x)');
xlabel('Cykly');
plot(grafFit);
s2 = sim('bergman');
Td = 33.474;
Sg = 0.032;
s3 = sim('bergman');

%% visualize
figure(1)
title('Koncentracia inzulinu [porovnanie]')
hold on
xlim([400,1400])
xlabel('Cas [min]');
ylabel('[mg/kg/min]');
yyaxis left
figure(2)
title('Rychlost vstrebavania glukozy [porovnanie]')
hold on
xlim([400,1400])
xlabel('Cas [min]');
ylabel('[mg/kg/min]');
yyaxis left
figure(3)
hold on
xlim([400,1400])
title('Glykemia [porovnanie]');
xlabel('Cas [min]');
ylabel('[mmol/l]');

figure(1)
plot(s1.time, s1.I, 'r-');
plot(s2.time, s2.I, 'g-');
plot(s3.time, s3.I, 'b-');
legend('Ident1','Ident2','Ucebny material');
figure(2)
plot(s1.time, s1.int, 'r-');
plot(s2.time, s2.int, 'g-');
plot(s3.time, s3.int, 'b-');
legend('Ident1','Ident2','Ucebny material');
figure(3)
plot(s1.time, s1.G, 'r-');
plot(s2.time, s2.G, 'g-');
plot(s3.time, s3.G, 'b-');
legend('Ident1','Ident2','Ucebny material');

