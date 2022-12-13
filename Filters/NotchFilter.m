function [Filtered] = NotchFilter(signal, fco, width, fs)
%% This funstion can be used to notch filter analog signals
% Input: struct with EMG signals (file.EMGname), cut-off frequency, 
% the width o fthe notch,and the sample frequency of the signal.

% Marije Goudriaan 4 July 2022. 
%%

fields = fieldnames(signal);

% Notch filter settings
w1 = fco/(fs/2);
notchWidth = width;
notchZeros = [exp( sqrt(-1)*pi*w1 ), exp( -sqrt(-1)*pi*w1 )];

%#Compute poles
notchPoles = (1-notchWidth) * notchZeros;

b = poly(notchZeros); %# Get moving average filter coefficients
a = poly(notchPoles); %# Get autoregressive filter coefficients

for i = 1:length(fields)
        EMGraw = signal.(fields{i,1});
        EMGfilt1 = filter(b,a,EMGraw); 
        Filtered.(fields{i,1}) = EMGfilt1;
end
end



   