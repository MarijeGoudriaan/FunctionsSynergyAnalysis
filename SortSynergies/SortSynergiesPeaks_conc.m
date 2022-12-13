function [Wsorted, Hsorted, PeakSort] = SortSynergiesPeaks_conc(W, H, nGCs, nSyn,L)
% SortSynergiesPeaks sorts the activations based on the timing of the peaks
% INPUT:        W: synergy weights (nMuscles*nSessions,nSyn)
%               H: synergy activations (nSyn,nGCs*L)
%               nGCs: number of concatenated strides
%               nSyn: number of synergies
%               L: stride length
% OUTPUT:       Wsorted: sorted weights
%               Hsorted: sorted activations
%               Results: results of the sortation

% Marije Goudriaan 1 July 2022.
%%
% Update to improve correct peak detection. 
% Marije Goudriaan 6 December 2022
%%
% Predefine parameters
    Hsorted = zeros(size(H));
    Wsorted = zeros(size(W));
    [nSessions,~] = size(H);
    Hj_pGC = zeros (nGCs,L);
    Hj_avGC = zeros(nSyn,L);

    Results.peaks = nan(nSyn,L);
    Results.location = nan(nSyn,L);
    Results.width = nan(nSyn,L);
    Results.prominance = nan(nSyn,L);
    yPeak = nan(1,nSyn);
    yProm = nan(1,nSyn);
    yWidth = nan(1,nSyn);
    peakLoc = nan(1,nSyn);
    
    % Determine if there are different sessions (could be different
    % participants groups as well)
    if nSessions > 1
        H_temp = mean(H);
    else
        H_temp = H;
    end
    
    % Split concatented signal into seperate strides and average
    for n = 1:nSyn
        for g = 1:nGCs
            Hj_pGC(g,:) = H_temp(1,((((n-1)*(nGCs*L)+(g*L))-L+1)):((n-1)*(nGCs*L)+(g*L)));
        end
        Hj_avGC(n,:) = mean (Hj_pGC);

        % Calculate peaks + locations
        [pks, locs, width,prom] = findpeaks(Hj_avGC(n,:));
        Results.peaks(n,1:length(pks)) = pks;
        Results.location(n,1:length(locs)) = locs;
        Results.width(n,1:length(width)) = width;
        Results.prominance(n,1:length(prom)) = prom;
    end
    clearvars n g
    
    % Check when a peak is highest and has the most prominance of largest
    % width. If not, remmove the location of that peak and move to the
    % next.
    for n = 1:nSyn
        tempPeak = rmmissing(Results.peaks(n,:));
        if ~isempty(tempPeak) 
            while ~isempty(tempPeak)
                [~,yPeak(n)] = max(Results.peaks(n,:));
                [~,yProm(n)] = max(Results.prominance(n,:));
                [~, yWidth(n)] = max(Results.width(n,:));
                if yPeak(n) == yProm(n) || yPeak(n) == yWidth(n)
                    peakLoc(n) = Results.location(n,yPeak(n));
                    break
                else
                    Results.peaks(n,yPeak(n)) = NaN;
                    Results.prominance(n,yProm(n)) = NaN;
                    Results.width(n,yWidth(n)) = NaN;
                end
            end
        else
            % If there are no clear peaks detected, the order of the
            % synergies remain the same.
            peakLoc(n) = n;
        end
    end
    clearvars n

    [~,PeakSort] = sort(peakLoc);

    for n = 1:nSyn
       Hsorted(:,((L*nGCs)*PeakSort(n)-((L*nGCs)-1):(L*nGCs)*PeakSort(n))) = H(:,(((L*nGCs)*n)-((L*nGCs)-1):(L*nGCs)*n));
       Wsorted(:,PeakSort(n)) = W(:,n);
    end
end 



