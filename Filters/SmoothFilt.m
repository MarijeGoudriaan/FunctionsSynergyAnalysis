function [Filtered] = SmoothFilt(EMG,fco1, order, type, fs)
%% This funstion can be used to smooth analog signals, like EMGs using a lowpass Butterworth filter on rectified EMG signals. 
% Input: struct with EMG signals (file.EMGname), cut-off frequency,
% filter order, filter type (low, high), sample frequency.
% Ouput: struct with filtered signals.

% Updated 13-12-2019 Marije Goudriaan 
%%

[b, a] = butter(order, fco1/(fs/2),type);

Signalnames = fieldnames(EMG);
for i = 1:length(Signalnames)
    EMGraw = EMG.(Signalnames{i,1});
        EMG_abs = abs(hilbert(EMGraw)); % Use hilbert transform
%         EMG_abs = abs(EMG.(Signalnames{i,1}));
        EMGfilt = filtfilt(b, a, EMG_abs);
        Filtered.(Signalnames{i,1}) = EMGfilt;
end


