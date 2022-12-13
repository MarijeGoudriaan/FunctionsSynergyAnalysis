
function [analogs, StartFrame, OtherData, markers, Afs, Vfs, ratio, Events] = ExtractAllData(SelectedFile)

% Extracts names of  signals.

acq = btkReadAcquisition(SelectedFile);
Afs = btkGetAnalogFrequency(acq);
ratio = btkGetAnalogSampleNumberPerFrame(acq);
Vfs = Afs/ratio;
Events = btkGetEvents(acq);
StartFrame = btkGetFirstFrame(acq);

analogs = btkGetAnalogs(acq);
markers = btkGetMarkers(acq);
angles = btkGetAngles(acq);
moments = btkGetMoments(acq);
power = btkGetPowers(acq);

a = fieldnames(angles);
m = fieldnames(moments);
p = fieldnames(power);
all_fields = [a;m;p]; 

if isempty(a) == 1
    OtherData = {};
else
    for i = 1:length(a)
        OtherData.(all_fields{i,:}) = angles.(a{i,:});
    end
    clearvars i

    for i=1:length(m)
        OtherData.(all_fields{(i+length(a)),:}) = moments.(m{i,:});
    end
    clearvars i

    for i=1:length(p)
        OtherData.(all_fields{(i+length(a)+length(m)),:}) = power.(p{i,:});
    end
end

 
