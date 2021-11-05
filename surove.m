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
Ag = 0.95;
%id
Td = 33.474;
Sg = 0.032;
load('identified1.mat');

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
s1 = sim('bergman');

time = s1.time;
G = s1.G(4001:end)/18;
I = s1.I(4001:end);
X = s1.X(4001:end);
v = s1.v(4001:end);
int = s1.int(4001:end);
d = s1.d;

%% visualize
figure(1)
title('Rychlost podavania inzulinu - bolus a bazal')
hold on
xlabel('Cas [min]');
ylabel('[mg/kg/min]');
figure(2)
title('Rychlost podavania sacharidov - spracovane data')
hold on
xlabel('Cas [min]');
ylabel('[mg/kg/min]');
figure(3)
hold on
title('Glykemia - spracovane data');
xlabel('Cas [min]');
ylabel('[mmol/l]');


figure(1)
plot(s1.bolus);
plot(s1.basal);
legend('Bolus','Basal');
ylabel("[\muU/kg/min]")
figure(2)
ylabel('[mg/kg/min]')
plot(time, d);
legend('d(t)');
figure(3)
plot(dat_s(:,1),dat_s(:,2), 'bo');
plot(dat_CalBG(:,1),dat_CalBG(:,2), 'rx');
legend('CGM','Glukomer');