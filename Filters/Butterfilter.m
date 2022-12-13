function [Filtered] = Butterfilter(EMG, fco1, fco2, order, type, fs)
%% This funstion can be used to filter analog signals, like EMGs using a Butterworth filter. 

% Input: struct with EMG signals (file.EMGname), cut-off frequencies (in case of high or low pass, fc02 should be []),
% filter order, filter type (low, high, bandpass, or bandstop), sample frequency.
% Ouput: struct with filtered signals.

% Updated 13-12-2019 Marije Goudriaan 
%%
Signalnames = fieldnames(EMG);

if fco1 ==0 | isnan(fco1) == 1 |isempty(fco1) == 1 
    w1 = fco2/(fs/2);
    [b,a] = butter(order, w1, type);    
elseif fco2 ==0 | isnan(fco2) == 1 | isempty(fco2) == 1 
    w1 = fco1/(fs/2);
    [b,a] = butter(order, w1, type);
elseif isnan(fco1) == 0 | isempty(fco1) == 0 & isnan(fco2) == 0 | isempty(fco2) == 0 & fco1 < fco2 == 1
    w1 = fco1/(fs/2);
    w2 = fco2/(fs/2);
    [b,a] = butter(order, [w1 w2], type);
elseif isnan(fco1) == 0 | isempty(fco1) == 0 & isnan(fco2) == 0 | isempty(fco2) == 0 & fco1 > fco2 == 1
    w1 = fco2/(fs/2);
    w2 = fco1/(fs/2);
    [b,a] = butter(order, [w1 w2], type);
end

for i = 1:length(Signalnames)
    EMGraw = EMG.(Signalnames{i,1});
    EMGfilt1 = filtfilt(b,a,EMGraw);
    Filtered.(Signalnames{i,1}) = EMGfilt1;

end




    



