function [Depeaked, DepeakedInd] = Depeak(signal)

fields = fieldnames(signal);
for i = 1:length(fields)
    signal_sd = std(signal.(fields{i,1}));
    DepeakedInd.(fields{i,1}) = zeros(1:length(signal.(fields{i,1})));
    for j = 1:length(signal.(fields{i,1}))
        if signal.(fields{i,1})(j,:) >= 10*signal_sd || signal.(fields{i,1})(j,:) <= -10*signal_sd
           Depeaked.(fields{i,1})(j,:) = NaN;
           Depeaked.(fields{i,1}) = fillmissing(signal.(fields{i,1}), 'next');
           DepeakedInd.(fields{i,1})(j,:) = NaN;
        else
           Depeaked.(fields{i,1})(j,:) = signal.(fields{i,1})(j,:);
           DepeakedInd.(fields{i,1})(j,:) = DepeakedInd.(fields{i,1})(j,:); 
        end
    end
end

