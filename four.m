function freq = four(a)
load('data_KT1.mat')

t_sample = t0(2) - t0(1);
fs = 1/(t_sample);

ind_start = 2046080; %start of action
ind_end = 2403700;  %end of action
num_samples = ind_end - ind_start;
%num_samples = length(p0);

fourier = fft(p0(ind_start:ind_end));
%fourier = fft(p0);

P2 = abs(fourier/num_samples);
P1 = P2(1:floor(num_samples/2)+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(num_samples/2))/num_samples;
if a>0
figure;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)');
ylabel('|P1(f)|');
ylim([0 1])
end
[pks1,frqs1] = findpeaks(P1, f, 'MinPeakHeight', 0.5);
idxes = find(frqs1>1);
Pk_n = pks1(idxes);
f_n = frqs1(idxes);

if a>0
figure;
plot(f_n,Pk_n) 
title('Peaks of Amplitude Spectrum of X(t)')
xlabel('f (Hz)');
ylabel('|P1(f)|');
end

[~, ix] = max(Pk_n);
freq = f_n(ix)
end