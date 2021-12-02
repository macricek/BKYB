close all
clear
clc

load('data_KT1.mat')
%plot(t0,p0);

%% first do Fourier transform to find main freq of heart
train = 1;
freq = four(train);

num_of_samples = length(p0);
t_sample = t0(2) - t0(1);

window_w = round(1/(freq*t_sample));
%0.5*(2*i+window_w))
cnt = 1;
for i = 1:window_w:(num_of_samples-window_w)
    diastolic = min(p0(i:(i+window_w)));
    systolic = max(p0(i:(i+window_w)));
    t(cnt) = t0(floor(mean([2*i,window_w])));  % time
    p(cnt) = diastolic + 1/3 * (systolic-diastolic);  % value
    cnt = cnt + 1;
end
%DTK + (STK - DTK)/3
pFilter = movmean(p, 15);

figure;
hold on;
plot(t0, p0, 'DisplayName', "Namerane");
plot(t, p, 'DisplayName', "spracovane");
plot(t, pFilter, 'DisplayName', "moving average");
legend;
xlabel("t [s]");
ylabel("tlak [mmHg]");
title("Tlak - spracovane");

global Ts
global tf1
global initVal
global stepTime
global stopTime
global outS
global num
global den
Ts = 0.01;
t_sampleF = t(2)-t(1);
tLatka = 4636.37;
tLvzorka = find(t > tLatka, 1);
initVal = pFilter(tLvzorka);

tL = t(tLvzorka:end) - tLatka;
pL = pFilter(tLvzorka:end);

stepTime = 133;
stopTime = tL(end);
outS.time = tL;
outS.signals.values = pL';
outS.signals.dimensions = 1;

if train == 0
% ga
numCycle = 100;                           % pocet cyklov hladania
popSize = 50;                              % velkost  populacie - kolko retazcov naraz testujem
Space = [ones(1,7)*-1000;ones(1,7)*1000];
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

else
    load('paramsFull1');
end
a0 = Best(1);
a1 = Best(2);
b0 = Best(3);
a2 = Best(4);
b1 = Best(5);
a3 = Best(6);
b2 = Best(7);
num = [b2, b1, b0];
den = [a3, a2, a1, a0];
dat = sim('identifikacia');

figure
hold on
plot(tL,pL,'DisplayName', 'Tlak namerany');
plot(dat.y,'DisplayName', 'Identifikovany');
title('Prechodovy dej po L-name');
xlabel("t [s]");
ylabel("tlak [mmHg]");
legend('Location','southeast');

figure
hold on
plot(grafFit);
xlabel('Cykly')
ylabel('Fitness');
title('Evolucia');