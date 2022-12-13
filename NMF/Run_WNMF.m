function [Wj, Hj, VAF, tVAF, VAFPerMuscle, Frob, tFrob,FrobPerMuscle] = Run_WNMF(signals, nSyn)
% INPUT:   signals: matrix containing EMG data. Each row is a different
%           EMG signal/muscle
%           nSyn: number of synergies.
% OUTPUT:   W: synergy weights
%           H: Synergy activations
%           VAF: variance accounted for for nSyn based on the uncentered R^2
%           totalVAF: variance accounted for per synergy based on the uncentered R^2
%           Frob: Variance accounted fro based on the Frobenius norm
%           totalFrob: variance accounted for per synergy based on the Frobenius norm
% 
% Marije Goudriaan, 12 May 2020
% Update 27 October 2020 Marije Goudriaan: Allow for calculation of VAFs when adding
% synergies iteratively.
%%% -----------------------------------------------------------------------

% Uncomment if you want to scale your data to have unit variance.
%         stdev = std(signals'); %scale the data to have unit variance of this data set
%         signals = diag(1./stdev)*signals;


    % Run WNMF
    option.distance = 'ls';
    option.iter = 3000;
    option.dis = false;
    option.residual=1e-4;
    option.tof=1e-6;
    
    tVAF = zeros(1,nSyn);
    tFROB = zeros(1,nSyn);
    Wj = []; Hj = [];
    
    [nSignals,~] = size(signals);
    
    for k = 1:nSyn
        [W,H,numIter,tElapsed,finalResidual] = wnmfrule(signals,k,option);
         Wj = [Wj W]; Hj = [Hj; H];

        % Total variance based on uncentered R^2 (Torres-Oviedo, 2006)
        signals(isnan(signals)) = 0;
        recon = W*H;
        e = signals - recon;
        tVAF(1,k) = 1 - sum(sum(e.^2))/sum(sum(signals.^2));

        % Total variance based on Frobenius norm
        n0 = norm(signals, 'fro');
        no=@(X) norm(X,'fro');
        tFrob(1,k) = 1-no(signals-(recon))/n0;
    end
    
    % Calculate VAF and Frob when adding one muscle at a time. 
    if nSignals == nSyn
       Frob = zeros(1,nSyn);
       VAF = zeros(1,nSyn);
       FrobPerMuscle = zeros(1, nSyn);
       VAFPerMuscle = zeros(1, nSyn);
        for k = 1:nSyn
            % Use same method as totalVAF (Torres-Oviedo, 2006)
            e_sub = signals - W(:,1:k)*H(1:k,:);
            VAF(k) = 1 - sum(sum(e_sub.^2))/sum(sum(signals.^2));
            recon_temp = W(:,1:k)*H(1:k,:);
            Frob(k) = 1-no(signals-(recon_temp))/n0;

            e_subPm = signals - W(:,k)*H(k,:);
            VAFPerMuscle(k) = 1 - sum(sum(e_subPm.^2))/sum(sum(signals.^2));
            recon_tempPm = W(:,k)*H(k,:);
            FrobPerMuscle(k) = 1-no(signals-(recon_tempPm))/n0;
        end
    else
        Frob = [];
        VAF = [];
        FrobPerMuscle = [];
        VAFPerMuscle = [];
    end
end