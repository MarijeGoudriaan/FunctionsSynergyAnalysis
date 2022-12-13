function [IDXall,SynergyCenter,sumdall,Dall] = SynergyKmeans_weights(Wj,nSyn,nMuscles)
% SynergyCenter determines the cluster centers (centroids) for the synergy weights
% based on kmeans cluster analysis.

% Input:    nSyn: number of synergies to be used in the cluster analysis.
%           nMuscles: Number of muscles included in the analysis.        
%           Wj: pxnSyn matrix containting the synergy weights. 
%               p has the size of the nMuscles*observations (individual
%               gait cycles e.g.)
% Output:   Cluster centers (centroids) of nSyn for the inlcuded muscles per
%           observation. 
%% 27 May 2021 Marije Goudriaan

[nRows,~] = size(Wj);

C = 1:nMuscles:nRows;
wj = [];

for c = 1:length(C)
    signal = Wj((C(c):C(c)+nMuscles-1),:);
    if ~iszero(var(signal))    
        wj = [wj signal];  
    else
        continue
    end
    Wj_Temp = wj;
    [IDXall,SynergyCenter,sumdall,Dall] =kmeans(Wj_Temp',nSyn,'replicates',3000);
end