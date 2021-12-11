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
%p0_f = p0;
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
heart1 = heart; %BP/sec -> BP/min*60
plot(t_hr, heart1);
title("Tep");
xlabel("t [s]");
ylabel("tep [BPM]");