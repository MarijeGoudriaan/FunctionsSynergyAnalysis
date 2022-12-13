function [Concatenated,PerCycle, GCsUsed] = EventBasedSplit_v2(signals, EMGnames,FS,nGCsIncl, normSize, randStrides)
% This function time normalized strides to normSize. Strides are randomized to avoid selection bias.

% INPUT:        signals:    the whole signal that you want to split into strides 
%                           and then time normalize those strides
%               EMGnames:   names of the EMGsignals that you want to
%                           normalize the signal for.
%               FS:         The foot strike data
%               nGCsIncl:   The number of strides that you want to include
%                           and normalize.
%               normSize:   Normalization factor. If kept empty, the
%                           signals are split based on the foot strikes, but not
%                           normalized. 
%               randStrides: Indicate if you want to randomize the strides
%                            for each signal. 1=randomize for each signal,
%                            2=randomize the same for all signals, []=do
%                            not randomize.
%                
% 
% OUTPUT:       Concatenated: The normalized concatenated signal
%               PerCycle:   The normalized individual strides
%               GCsUsed:    The strides that were used.

% Marije Goudriaan 1 July 2022
% 5 December 2022. Updates to allow for different ways of randomizing the
% strides. Marije Goudriaan
%%
nSignals = length(EMGnames);

if ~isempty(normSize)
    y = 1:length(rand(1,normSize));
    for n = 1:nSignals
        GCsPresent = size(FS.(EMGnames{n}),1);
        GCsUsed.(EMGnames{n}) = [];
        PerCycle.(EMGnames{n}) = nan(1,normSize);
        Concatenated.(EMGnames{n}) = nan(1,normSize);
        if (isempty(GCsPresent) || iszero(GCsPresent)) || isempty(FS.(EMGnames{n}))
            GCsUsed_temp = [] ;
        else
            if GCsPresent>1 && (isempty(nGCsIncl) || iszero(nGCsIncl))
               nGCsIncl_temp = GCsPresent;
               if ~isempty(randStrides) && (randStrides ==2 && n==1)
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif ~isempty(randStrides) && randStrides ==1
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif isempty(randStrides)
                   GCsUsed_temp = 1:GCsPresent;
               end
            elseif GCsPresent==1 && (isempty(nGCsIncl) || iszero(nGCsIncl)) && ~isempty(FS.(EMGnames{n}))
                GCsUsed_temp = 1;
            else 
                nGCsIncl_temp = nGCsIncl; 
               if ~isempty(randStrides) && (n ==1 && randStrides ==2)
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif ~isempty(randStrides) && randStrides ==1
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif isempty(randStrides)
                   GCsUsed_temp = 1:GCsPresent;
               end
            end
            for g = 1:length(GCsUsed_temp)
                signalSplit = signals.(EMGnames{n})(FS.(EMGnames{n})(GCsUsed_temp(g),1):FS.(EMGnames{n})(GCsUsed_temp(g),2),:);
                x = linspace(1, length(y), length(signalSplit));
                signalGC = interp1(x, signalSplit, y);
                PerCycle.(EMGnames{n})(g,:) = signalGC;
                Concatenated.(EMGnames{n}) = [Concatenated.(EMGnames{n}) signalGC];
            end
        end
        GCsUsed.(EMGnames{n}) = GCsUsed_temp;
    end
else
     for n = 1:nSignals
         GCsPresent = size(FS.(EMGnames{n}),1);
         if isempty(GCsPresent) || iszero(GCsPresent) || isempty(FS.(EMGnames{n}))
            GCsUsed_temp = [] ;
         else
            if GCsPresent>1 && (isempty(nGCsIncl) || iszero(nGCsIncl))
               nGCsIncl_temp = GCsPresent;
                if ~isempty(randStrides) && (n ==1 && randStrides ==2)
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif ~isempty(randStrides) && randStrides ==1
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif isempty(randStrides)
                   GCsUsed_temp = 1:GCsPresent;
               end
            elseif GCsPresent==1 && (isempty(nGCsIncl) || iszero(nGCsIncl)) && ~isempty(FS.(EMGnames{n}))
                GCsUsed_temp = 1;
            else 
                nGCsIncl_temp = nGCsIncl; 
                if ~isempty(randStrides) && (n ==1 && randStrides ==2)
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif ~isempty(randStrides) && randStrides ==1
                   GCsUsed_temp = randperm(GCsPresent,nGCsIncl_temp);
               elseif isempty(randStrides)
                   GCsUsed_temp = 1:GCsPresent;
               end
            end
            Concatenated.(EMGnames{n}) = [];
             for g = 1:length(GCsUsed_temp)
                 signalSplit = signals.(EMGnames{n})(FS.(EMGnames{n})(GCsUsed_temp(g),1):FS.(EMGnames{n})(GCsUsed_temp(g),2),:);
                 PerCycle.(EMGnames{n})(g,:).(['gc' num2str(g)]) = signalSplit;
                 Concatenated.(EMGnames{n}) =  [Concatenated.(EMGnames{n}) signalSplit];
             end
         end
         GCsUsed.(EMGnames{n}) = GCsUsed_temp;
    end
end

