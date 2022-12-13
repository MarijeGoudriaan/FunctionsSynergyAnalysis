function [Wgrouped, Hgrouped] = GroupSimSyn(nSyn,indTotal, nMuscles, W, H)
% GroupSimSyn sorts synergies per gait cycle based on their activation patterns (peaks
% of activity) in a gait cycle. Synergy one will be the synergy with the
% highest activation at the beginning of the gait cycle, the last synergy
% with the highest activation at the end of swing. 

% INPUT:    nSyn: number of synergies
%           nMuscles: Number of muscles per synergy
%           indTotal: indices appointed to each synergy from kMeans
%           cluster analysis (nSyn,nCycles);
%           W: Weights from NNMF for nSyn (nMuscles*nCycles, nSyn);
%           H: Activations from NNMF (nSyn*nCycles,length cycle)or previous kMeans analysis (nCycles,length cycle*nSyn)

% OUTPUT:   Wgrouped: sorted synergy weights 
%           Hgrouped: sorted synergy activations per grouped weights
%
% Marije Goudriaan 17 April 2020
%%
y = size(indTotal,2);
L = size(H,2);
Wgrouped = zeros(size(W));
Hgrouped = zeros(y,nSyn*L);

for n = 1:nSyn
    for i = 1:y
        Wgrouped(((i*nMuscles)-(nMuscles-1):i*nMuscles),n) = W(((i*nMuscles)-(nMuscles-1):i*nMuscles),indTotal(n,i));
        Hgrouped(i,(n*L)-(L-1):n*L) =  H((i*nSyn)-nSyn+indTotal(n,i),:);
    end
end

clearvars IND i y n
end

