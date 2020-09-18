%Mohnish Kumar - 170102040
%EE320 Assignment 2

%% Initialize

clc;
clear;

%Read audio file
[audio,Fs] = audioread('audio.mp3');

%Select a single channel
audio = audio(5*Fs:19.5*Fs,1);
audio_length = length(audio);

%Play original audio file
sound = audioplayer(audio, Fs);
%playblocking(sound);    %Uncomment to play
display('Played original audio');

%% FFT of the original signal

[fft_original, f] = single_sided_fft(audio, Fs);    %Helper function to generate single-sided spectrum
figure('Name', 'FFT of original signal');
plot(f, fft_original);

% There are huge peaks around 90 Hz and lower frequency ranges. The peaks
% around 150-200 and its integer multiples should be because of the female
% voice since the fundamental frequency lies around that range.

%% Zero padding effects

% t = 5:1/Fs:19.5;
% reconstruct1 = ifft(fft_double);
% figure(2);
% plot(t, reconstruct1);

%Create subplots for 4 cases
figure('Name', 'Zero padding effects on FFT');
%No padding
subplot(4,1,1); 
[zero_pad0, f] = single_sided_fft(audio, Fs);
plot_range = find(f < 1000); %Range of frequencies to plot
plot(f(plot_range), zero_pad0(plot_range));
title('No zeros');
%1000 zeros
subplot(4,1,2); 
[zero_pad1, f] = single_sided_fft([audio;zeros(1000,1)], Fs);
plot_range = find(f < 1000);
plot(f(plot_range), zero_pad1(plot_range));
title('1000 zeros');
%10000 zeros
subplot(4,1,3); 
[zero_pad2, f] = single_sided_fft([audio;zeros(10000,1)], Fs);
plot_range = find(f < 1000);
plot(f(plot_range), zero_pad2(plot_range));
title('10000 zeros');
%100000 zeros
subplot(4,1,4); 
[zero_pad3, f] = single_sided_fft([audio;zeros(100000,1)], Fs);
plot_range = find(f < 1000);
plot(f(plot_range),zero_pad3(plot_range));
title('100000 zeros');

% We find that there are slight changes in the FFT due to the zero padding
% but the difference isn't very big due to the very high sampling rate and
% the initial length of the audio

%% BONUS SECTION - Filter design

%I've provided ideas of 5 different methods below-

% 1. Using LPF/HPF/BPF
% Since the voice fundamental frequency and its formants mostly lie within
% 4KHz range while music spectrum in the higher bands, we can use an LPF
% to get a good enough difference. This I tried to implement using LPF, HPF
% and BPF but the results weren't very good for the given data.

% 2. Since human female voice(here) fundamental frequency lie between
% 150-250 range while the music fundamental is at a higher frequency, 
% using bandstop filters at this freq range and its
% harmonics until 4KHz, most of the voice can be removed. This I tried to
% implement but the results weren't very good either.

% 3. Music sounds are usually periodic while human sounds are very
% aperiodic, we can use this feature to distinguish between them.

% 4. Most musical instrument sounds are a function of length(eg. Guitar 
% string length, flutes/pipes length etc), and vocal tract also act as a
% variable length filter. We can try to find the components corresponding
% to the female vocal tract for the given voice(Ref. Priyankoo Sir, HSS
% Dept).

% 5. Subtracting L and R channels provide with only the music sound since
% the voice is same in both but the music is phase shifted. Since we have
% the input and the sample data output(only music) too, we can build an
% adaptive filter that can extract the voice and music. 

%My implementations - The results weren't very good though
%LPF implementation
[audio_filt, d_filt] = lowpass(audio, 5000, Fs, 'Steepness', 0.95);
% fvtool(d_lp);   %Uncomment to display filter response

%Several notch filters
w = 150/(Fs/2);
for i=1:50
[num, den] = iirnotch(i*w, i*w/10);
audio_filt = filter(num, den, audio_filt);
end

%FFT on filtered audio
[fft_filtered, f] = single_sided_fft(audio_filt, Fs);
figure('Name', 'FFT of filtered signal');
plot(f, fft_filtered);

%Play filtered audio file
sound_filtered = audioplayer(audio_filt, Fs);
%playblocking(sound_filtered);    %Uncomment to play
disp('Played filtered audio');
