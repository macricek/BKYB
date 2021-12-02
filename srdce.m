clear;
clear;
close all;

load("data_KT1.mat");

%% find peaks
num_of_samples = length(p0);
t_sample = t0(2) - t0(1);

train =0;
freq = four(train);

p0_f = movmean(p0, 50);   % smooth input

window_w = round(5/(freq*t_sample));    % window for analysing
min_peak_dist = round(0.5/(freq*t_sample)); % minimum distance between peaks

cnt = 1;
t_hr = [];
heart = [];
peaks_all = [];
t_peaks = [];

for i = 1:window_w:(num_of_samples-window_w)
    to = i + window_w;
   
    maxes = max(p0_f(i:to));
    th = median(p0_f(i:to));
    
    [peaks, inds] = findpeaks(p0_f(i:to), 'MinPeakDistance', min_peak_dist, 'MinPeakHeight', th);
    inds = inds + i;
    t_peaks = [t_peaks, t0(inds)];
    peaks_all = [peaks_all, peaks];
    % calculate the averaget time between peaks
    sum_dt = 0;
    for j = 2:length(inds)
        sum_dt = sum_dt + (t0(inds(j)) - t0(inds(j-1)));
    end
    % get the average frequency of peaks
    f = (length(inds) - 1) / sum_dt;
    heart(cnt) = f;
    t_hr(cnt) = t0(floor(mean([i, to])));
    cnt = cnt + 1;
end

figure;
hold on;
heart = movmean(heart, 5);
heart1 = heart*60; %BP/sec -> BP/min
plot(t_hr, heart1);
title("Tep");
xlabel("t [s]");
ylabel("tep [BPM]");

global Ts
global initVal
global stepTime
global stopTime
global outS
global xInit
global init
global A
global B
global C
global D

Ts = 0.01;
t_sampleF = t_hr(2)-t_hr(1);
tLatka = 4636.37;
tLvzorka = find(t_hr > tLatka, 1);
initVal = 4;
stepTime = 150;
stopTime = 6700-4636.37;

tLatkaEnd = 6700;
tLvzorkaE = find(t_hr > tLatkaEnd, 1);

tii = t_hr(tLvzorka:tLvzorkaE) - tLatka;
h = heart(tLvzorka:tLvzorkaE);
init = 1.6;
outS.time = tii;
outS.signals.values = h';
outS.signals.dimensions = 1;

if train == 0
% ga
numCycle = 2;                           % pocet cyklov hladania
popSize = 50;                              % velkost  populacie - kolko retazcov naraz testujem
Space = [ones(1,7)*-0.10;ones(1,7)*0.10];
Amp = Space(2,:)*0.1;                          % rozsah pre aditivnu mutaciu

pop = genrpop(popSize,Space);              % generovanie n- nahodnych retazcov 
fit = identFitS(pop);                      

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
    fit = identFitS(pop);                        
        [minFitnew,indx]=min(fit);          %zistenie minima
        
        if minFitnew<minFit                 %kontrola, ci sa naslo nove minimum
        minFit=minFitnew;                   %ak ano, prepise sa
        end
    grafFit(i)=minFit;                      %graffit uchova najlepsie hodnoty jednotlivych cyklov
    i
    minFit
end

save(strcat("paramsFull2",".mat"),'Best','grafFit');

else
    load('paramsFull2');
end

a0 = Best(1);
a1 = Best(2);
b0 = Best(3);
a2 = Best(4);
b1 = Best(5);
a3 = Best(6);
b2 = Best(7);

[A,B,C,D] = tf2ss([b2, b1, b0],[a3, a2,a1,a0]);
xInit = [0, init/C(2), 0];
dat = sim('identifikaciaS');

figure
hold on
plot(grafFit);
xlabel('Cykly')
ylabel('Fitness');
title('Evolucia');

figure;
hold on;
plot(tii,h*60);
plot(dat.y*60);
title("Tep");
xlabel("t [s]");
ylabel("tep [BPM]");
legend('Namerane','Ident');

