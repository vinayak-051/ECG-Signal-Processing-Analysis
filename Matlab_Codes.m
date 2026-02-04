% 1. Data Exploration

%Loading ECG data and printing the first five rows
data = readtable('104samples.csv');
sig = data.x_V5_;
fs = 360;
t = (0:length(sig)-1) / fs;
disp(head(data,5));

% 2. ECG Signal Behaviour Analysis

%Plotting the raw signal
figure;
plot(t, sig);
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('ECG signal with PQRST waves');
hold on;

% PQRST Identification and Annotation
% R wave: Peak with highest amplitude
% Q wave: First negative deflection before R-peak
% S wave: First negative deflection after R-peak
% T wave: Positive deflection after S wave
% P wave: Positive deflection before QRS complex

%R wave detection
[~, r_locs] = findpeaks(sig, 'MinPeakHeight', 0.5, 'MinPeakDistance', 0.6 * fs);
plot(t(r_locs), sig(r_locs), 'ro');

for i = 1:length(r_locs)
    %Q wave detection
    q_start = max(1, r_locs(i) - 50);
    q_reg = sig(q_start:r_locs(i));
    [~, q_off] = min(q_reg);
    q_loc = q_start + q_off - 1;
    plot(t(q_loc), sig(q_loc), 'go');
      
    %S wave detection
    s_end = min(length(sig), r_locs(i) + 50);
    s_reg = sig(r_locs(i):s_end);
    [~, s_off] = min(s_reg);
    s_loc = r_locs(i) + s_off - 1;
    plot(t(s_loc), sig(s_loc), 'bo');
    
    %T wave detection
    t_end = min(length(sig), s_loc + 200);
    t_reg = sig(s_loc:t_end);
    [~, t_off] = max(t_reg);
    t_loc = s_loc + t_off - 1;
    plot(t(t_loc), sig(t_loc), 'mo');

    %P wave detection
    p_start = max(1, q_loc - 150);
    p_reg = sig(p_start:q_loc);
    [~, p_off] = max(p_reg);
    p_loc = p_start + p_off - 1;
    plot(t(p_loc), sig(p_loc), 'co');
end

legend('ECG', 'R', 'Q', 'S', 'T', 'P');
hold off;

% Applying Fourier Transform to the applied signal
N = length(sig);
Y = fft(sig);
f = (0:N-1) * (fs / N);
P2 = abs(Y / N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2 * P1(2:end-1);
f1 = f(1:N/2+1);

figure;
subplot(2,1,1);
plot(t, sig);
xlabel('Time (s)');
ylabel('Amplitude');
title('ECG');
grid on;

subplot(2,1,2);
plot(f1, P1, 'b');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Fast Fourier Transform');
grid on;
xlim([0 100]);

% Calculation of average heart rate(BPM) based on detected R-peaks
rr = diff(r_locs) / fs;
Heart_Rate = 60 / mean(rr);
fprintf('Heart Rate : %.2f BPM\n', Heart_Rate);

% 3. Feature Extraction and Correlations

% RR Interval Analysis
figure;
histogram(rr * 1000, 20);
xlabel('RR Intervals(ms)');
ylabel('Frequency');
title('RR Distribution');
grid on;


% Analyzing the effect of noise
f_pli = 50; 
A_pli = 0.075; 
pli_noise = A_pli * sin(2 * pi * f_pli * t)';
noisy_sig = sig + pli_noise;
% ECG signal plot of both signals (with and without noise)
figure;
subplot(2,1,1);
plot(t, sig);
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('ECG Signal Without Noise');
grid on;

subplot(2,1,2);
plot(t, noisy_sig, 'r');
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('ECG Signal With 50Hz PLI Noise');
grid on;
% FFT plot of both signals (with and without noise)
Y_noisy = fft(noisy_sig);
P2_noisy = abs(Y_noisy / N);
P1_noisy = P2_noisy(1:N/2+1);
P1_noisy(2:end-1) = 2 * P1_noisy(2:end-1);

figure;
subplot(2,1,1);
plot(f1, P1, 'b');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of ECG Signal Without PLI Noise');
grid on;
xlim([0 100]);

subplot(2,1,2);
plot(f1, P1_noisy, 'r');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of ECG Signal With 50Hz PLI Noise');
grid on;
xlim([0 100]);

% 4.Noise Reduction and Signal Processing

% Design a 50Hz Notch Filter 
wo = 50/(fs/2); 
bw = wo/35; 
[b_notch, a_notch] = iirnotch(wo, bw);

% Notch filter to remove 50Hz PLI
filtered_sig_notch = filtfilt(b_notch, a_notch, noisy_sig);

% Low-pass filter (100Hz cutoff) to remove high-frequency noise
fc = 100; 
[b_lp, a_lp] = butter(16, fc/(fs/2), 'low');

filtered_sig = filtfilt(b_lp, a_lp, filtered_sig_notch);

% ECG Signal plot for comparison
figure;
subplot(2,1,1);
plot(t, noisy_sig, 'r');
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('Noisy ECG Signal (With 50Hz PLI and High-Frequency Noise)');
grid on;

subplot(2,1,2);
plot(t, filtered_sig, 'b');
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('Fully Filtered ECG Signal (Notch + Low-pass)');
grid on;

% Fast Fourier plot for noisy and filtered signals
N = length(noisy_sig);
Y_noisy = fft(noisy_sig);
P2_noisy = abs(Y_noisy / N);
P1_noisy = P2_noisy(1:N/2+1);
P1_noisy(2:end-1) = 2 * P1_noisy(2:end-1);
f1 = (0:N/2) * (fs / N);

Y_filtered = fft(filtered_sig);
P2_filtered = abs(Y_filtered / N);
P1_filtered = P2_filtered(1:N/2+1);
P1_filtered(2:end-1) = 2 * P1_filtered(2:end-1);

figure;
subplot(2,1,1);
plot(f1, P1_noisy, 'r');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of Noisy ECG Signal (PLI + High-Frequency Noise)');
grid on;
xlim([0 100]);

subplot(2,1,2);
plot(f1, P1_filtered, 'b');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of Filtered ECG Signal (After Notch + Low-pass)');
grid on;
xlim([0 100]);

% Calculating Mean and Standard Deviation of signals before and after
% adding noise
mean_before = mean(sig);
std_before = std(sig);

mean_after = mean(noisy_sig);
std_after = std(noisy_sig);

fprintf('Mean before adding noise: %.4f mV\n', mean_before);
fprintf('Standard deviation before adding noise: %.4f mV\n', std_before);
fprintf('Mean after adding noise: %.4f mV\n', mean_after);
fprintf('Standard deviation after adding noise: %.4f mV\n', std_after);

