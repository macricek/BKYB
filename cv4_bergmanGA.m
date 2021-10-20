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
load('paramsI');
global S1b
global S2b
global Ib
global TI
global kI
global VI
global Sg
global Vg
global Gb
%% vzorove data
TI = 44.55;
kI = 0.1645;
VI = 138.8;
S1b = 1.2528e4;
S2b = S1b;
Ib = 12.3165;
Sg = 0;
Vg = 1.467;
Gb = 153;
global Si
global p2


%% ga
numCycle = 100;                           % pocet cyklov hladania
popSize = 50;                              % velkost  populacie - kolko retazcov naraz testujem
Space = [ones(1,2)*0;[10,10]];
Amp = ones(1,4)*0.05;                          % rozsah pre aditivnu mutaciu

pop = genrpop(popSize,Space);              % generovanie n- nahodnych retazcov 
fit = tuneGAb(pop);                      

[minFit,indx] = min(fit);                   % najlepsi retazec
grafFit = zeros(1,numCycle);

for i=1:numCycle
    Best = selbest(pop,fit,1);              % jeden najlepsi                                        [1]
    BestPop = selsort(pop,fit,4);           % vyber 8 najlepsich                                    [4]
    BestPop1 = selbest(pop,fit,[2 2 1]);    % 3 + 2 + 2                                             [5]
    BestPop = [BestPop;BestPop1];           %                                                       [10]
    SortPop = selrand(pop,fit,10);          % prva pracovna populacia                               [10]
    WorkPop = selsus(pop,fit,10);           % druha pracovna populacia                              [10]
    NPop = genrpop(20,Space);                                                                      %[50]
    SortPop = around(SortPop,0,1.25,Space); %medzilahle krizenie, random, alfa 1,25
    WorkPop = mutx(WorkPop,0.15,Space);     %globalna mutacia, sanca 5%
    BestPop = muta(BestPop,0.01,Amp,Space); %aditivna mutacia, sanca 1% - AMP 1ky
    NewPop = [SortPop;BestPop;WorkPop;NPop];     %spojenie do jedneho
    pop = [NewPop;Best];                    %populacia
    fit = tuneGAb(pop);                       
        [minFitnew,indx]=min(fit);          %zistenie minima
        
        if minFitnew<minFit                 %kontrola, ci sa naslo nove minimum
        minFit=minFitnew;                   %ak ano, prepise sa
        end
    grafFit(i)=minFit;                      %graffit uchova najlepsie hodnoty jednotlivych cyklov
    i
    minFit
end

save(strcat("paramsFull",".mat"),'Best','grafFit');

%berg
Si = Best(1) / 1000;
p2 = Best(2) / 1000;
s1 = sim('bergman');
plot(s1.product);
plot(s1.int);
legend('PD','Ra(t)','V_GX(t)G(t)');

figure(2)
hold on
title('Glykemia');

s1.G.Data = s1.G.Data/18;
plot(s1.G);
plot([0,600],[Gb Gb]/18,'--');
legend('G(t)','Gb');
ylabel('[mmol/l]');
xlabel('Cas [min]');