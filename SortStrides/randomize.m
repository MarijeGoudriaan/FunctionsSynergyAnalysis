function W = randomize(A)
%% This function randomizes the data in matrix A
% INPUT:    A = vector with the data needs to be randomized
% OUTPUT:   W = randomzed vector A

% Downloaded from Mathwork but could not find the correct reference..
% Marije Goudriaan 4 July 2022.
%%
[m,n] = size(A);
E = A(:);
W(1) = E(1);
E(1) =[];
N = m*n;
while length(E) > 0
    K = length(W);
    RandInd = randi(length(E),1);
    for j = 1: K 
       P(j) =  E(RandInd) ~= W(j); 
    end
    if all(P) 
    W =[W,E(RandInd)];
    E(RandInd) =[];
    end
end  
W = reshape(W,m,n);