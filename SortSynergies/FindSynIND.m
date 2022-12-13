function [IND] = FindSynIND(nSyn)
% Finds the indices containing the correct synergy activations and weights.
% INPUT:        nSyn = number of synergies
% OUTPUT:       IND=indices 

% Marije Goudriaan, 22-04-2020
%%

Syn = [];
for n = 1:nSyn
   syn = (nSyn-n)+1;
   Syn = [Syn syn];
end
clearvars n
Syn = sort(Syn);

Ind = 1;
for n = 2:nSyn
   ind = sum(Syn(1):Syn(n-1))+1;
   Ind = [Ind ind];
end
clearvars n
IND = Ind(end):1:Ind(end)+nSyn-1;
end

