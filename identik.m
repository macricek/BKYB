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

%% ga
numCycle = 50;                           % pocet cyklov hladania
popSize = 50;                              % velkost  populacie - kolko retazcov naraz testujem
Space = [ones(1,2)*0.001;[0.01,50]];
Amp = [0.001, 1];                          % rozsah pre aditivnu mutaciu

pop = genrpop(popSize,Space);              % generovanie n- nahodnych retazcov 
fit = tuneGA(pop);                      

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
    fit = tuneGA(pop);                       
        [minFitnew,indx]=min(fit);          %zistenie minima
        
        if minFitnew<minFit                 %kontrola, ci sa naslo nove minimum
        minFit=minFitnew;                   %ak ano, prepise sa
        end
    grafFit(i)=minFit;                      %graffit uchova najlepsie hodnoty jednotlivych cyklov
    i
    minFit
end

save(strcat("identified1",".mat"),'Best','grafFit');