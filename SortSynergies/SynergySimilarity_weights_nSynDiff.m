function [cTotal, indTotal] = SynergySimilarity_weights_nSynDiff(Wj, nMuscles,SynergyCenter)
%% Calculate similarity between subset of master set and new synergies 
% This function generates the correlation coefficients between the clusters
% generate with the kMeans cluster analysis and the individual muscle
% synergies by using the function similarity_weights
% INPUT:            Wj =            the weights of the synergies that need to
%                                   be grouped
%                   nMuscles =      the number of included muscles.
%                   SynergyCenter = the output from the Kmeans cluster
%                                   analysis.
% OUTPUT:           cTotal =        Correlation coefficients
%                   indTotal =      Indices of the best fitting synergies

% Marije Goudriaan 4 July 2022.
%%
[L,~] = size(Wj);
[nSyn,~] = size(SynergyCenter);
cTotal = zeros(nSyn,L/nMuscles);
indTotal = zeros(nSyn,length(Wj)/nMuscles);
    for j = 1:(L/nMuscles)
        Wsub = Wj(nMuscles*j-nMuscles+1:nMuscles*j,:)';
        [corr, indSyn]  = similarity_weights_nSynDiff(SynergyCenter, Wsub);
        cTotal (:,j)= corr (:,1);
        indTotal (:,j)= indSyn(:,2);
    end
end