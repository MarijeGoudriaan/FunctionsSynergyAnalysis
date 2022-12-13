function [corr, indSyn] = similarity_weights_nSynDiff(Wmaster, Wslave)
%% Calculate similarity between subset of master set and new synergies
% This function generates the correlation coefficients between the clusters
% generate with the kMeans cluster analysis and the individual muscle
% synergies.
% INPUT:            Wmaster =   synergy ceneter calcuated from the kMeans
%                               cluster analsysis
%                   Wslave =      the individual synergies.
% OUTPUT:           corr =         Correlation coefficients
%                   indSyn =       Indices of the best fitting synergies

% Marije Goudriaan 4 July 2022.
%%
corr_temp2 = zeros(size(Wmaster,1));
corr = zeros(size(Wmaster,1),1);
indSyn = zeros(size(Wmaster,1),2);

    % Determine the synergies that are most similar
    for i = 1:size(Wmaster,1) % Calculate correlations
        for j = 1:size(Wslave,1)
            corr_temp = corrcoef(Wmaster(i,:), Wslave(j,:)); % Pearson correlation coefficients
            corr_temp2(i,j) = abs(corr_temp(1,2));
        end    
    end
    clearvars i j
    
    for i = 1:size(Wmaster,1) % Sort by max correlation
        [c1, ind1] = max(corr_temp2,[],2); % Index of Wslave that is most similar to Wmaster
        [corr(i,:), ind2] = max(c1); % Index of Wmaster that is most similar
        indSyn(i,:) = [ind2 ind1(ind2)]; % Index of Wmaster and Wsub that were similar
        corr_temp2(ind2, :) = 0; % clear row and column of vectors that were similar
        corr_temp2(:, ind1(ind2)) = 0; 
    end
    clearvars i
    
    % Sort results so that in order of Wmaster synergies
    [~, SortIndY] = sort(indSyn(:,1));
    corr = corr(SortIndY,:);
    indSyn = indSyn(SortIndY, :);
    
    for i = 1:size(Wmaster,1)
        if iszero(corr(i))
            indSyn(i,2)=0;
        end
    end
end