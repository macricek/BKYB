close all
clc
clear

%% data for simulation
global time;
global glucose;
global insuline;
global xq;
global glucose_int;
global insuline_int;
global Ib;
global Gb;
global p2;
global Si;
global Sg;
global G_0;

T = readtable('Dat_IVGTT_SN.csv');
ar = table2array(T);
time = ar(:,1);
glucose = ar(:,2);
insuline = ar(:,3);
%vq = interp1(x,v,xq)
xq = time(1):0.01:time(end);
glucose_int = interp1(time,glucose,xq);
insuline_int = interp1(time,insuline,xq);
Ib = insuline(1);
Gb = glucose(1);

%% ga
numCycle = 100;                           % pocet cyklov hladania
popSize = 50;                              % velkost  populacie - kolko retazcov naraz testujem
Space = [ones(1,4)*1e-15;[1e-3,1e-12,0.1,20]];
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

save(strcat("params3",".mat"),'Best','grafFit');

