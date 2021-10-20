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
I2 = ar2(:,2);
%% visualize
figure(1)
title('Koncentracia inzulinu')
hold on
yyaxis left
xlabel('Cas [min]');
ylabel('I(t) [\muU/ml]');
plot(T,I,'ok');

%% vzorove data
TI = 44.55;
kI = 0.1645;
VI = 138.8;
S1b = 1.2528e4;
S2b = S1b;
Ib = 12.3165;
s1 = sim('cv4model');
plot(s1.I);
yyaxis right
plot(s1.v);
ylabel("v(t) [\muU/kg/min]")
legend('namerane','model','v(t)');

