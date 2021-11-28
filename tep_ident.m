clc
clear
close all

load('tep.mat');

global A
global B
global C
global D
global a0
global a1
global a2
global b1
global b0
global d
global init
global xInit
global outS
global Ts

Ts = 0.01;
init = tepN(1);
% ga
numCycle = 100;                           % pocet cyklov hladania
popSize = 50;                              % velkost  populacie - kolko retazcov naraz testujem
Space = [ones(1,5)*-1000;ones(1,5)*1000];
Amp = Space(2,:)*0.1;                          % rozsah pre aditivnu mutaciu

pop = genrpop(popSize,Space);              % generovanie n- nahodnych retazcov 
fit = identFit(pop);                      

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
    fit = identFit(pop);                        
        [minFitnew,indx]=min(fit);          %zistenie minima
        
        if minFitnew<minFit                 %kontrola, ci sa naslo nove minimum
        minFit=minFitnew;                   %ak ano, prepise sa
        end
    grafFit(i)=minFit;                      %graffit uchova najlepsie hodnoty jednotlivych cyklov
    i
    minFit
end

save(strcat("paramsFull1",".mat"),'Best','grafFit');
