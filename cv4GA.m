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
% TI = 44.55;
% kI = 0.1645;
% VI = 138.8;

global S1b
global S2b
global Ib
global TI
global kI
global VI

S1b = 1.2528e4;
S2b = S1b;
Ib = 12.3165;

%% ga
numCycle = 100;                           % pocet cyklov hladania
popSize = 50;                              % velkost  populacie - kolko retazcov naraz testujem
Space = [ones(1,3)*0;[50,1,200]];
Amp = ones(1,4)*0.05;                          % rozsah pre aditivnu mutaciu

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

save(strcat("paramsI",".mat"),'Best','grafFit');

TI = Best(1);
kI = Best(2);
VI = Best(3);
s1 = sim('cv4model');
plot(s1.I);
yyaxis right
plot(s1.v);
ylabel("v(t) [\muU/kg/min]")
legend('namerane','model','v(t)');

