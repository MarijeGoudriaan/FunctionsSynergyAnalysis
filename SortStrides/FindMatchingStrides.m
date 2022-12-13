function [matchStrides] = FindMatchingStrides(FS1,FS2)
% This function finds the matching/cosest contralateral foot strikes. 
% INPUT:    FS1 = is the stride for which you want to find the closest
%                 contralateral strides
%           FS2 = a row with the foot strikes of the contralateral side. 
% OUTPUT:   matchStrides: are the 3 indices of the matching contralateral
%           side

% Marije Goudriaan 1 July 2022
%%
    d = sort(abs(FS1-FS2));
    [~, ii, ~] = unique(d,'first');
    ind_dupl = find(not(ismember(1:numel(d),ii)));
    matchStrides = zeros(3,1);
    if ind_dupl>4
        ind_dupl = [];
    end
    if length(d)== 1 && isempty (ind_dupl)
       matchStrides(1,:) = find(abs(FS1-FS2)==d(1));
       matchStrides(2,:) = 0;
       matchStrides(3,:) = 0; 
    elseif length(d)== 2 && isempty (ind_dupl)
       matchStrides(1,:) = find(abs(FS1-FS2)==d(1));
       matchStrides(2,:) = find(abs(FS1-FS2)==d(2));
       matchStrides(3,:) = 0; 
    elseif length(d)== 2 && ind_dupl==2
        ind_temp =  find(abs(FS1-FS2)==d(2));
        matchStrides(1,:) = ind_temp(1);
        matchStrides(2,:) = ind_temp(2);
        matchStrides(3,:) = 0; 
    else
        if isempty(ind_dupl) && length(FS2)>2
           matchStrides(1,:) = find(abs(FS1-FS2)==d(1));
           matchStrides(2,:) = find(abs(FS1-FS2)==d(2));
           matchStrides(3,:) = find(abs(FS1-FS2)==d(3));
           matchStrides = sort(matchStrides);
        end
        if length(ind_dupl)>=2 && ind_dupl(2)<=4 
            ind_dupl = ind_dupl(1:2);
            if  isempty(ind_dupl)&& ind_dupl(2)< 4
                ind_temp =  find(abs(FS1-FS2)==d(1));
                matchStrides(1,:) = ind_temp(1);
                matchStrides(2,:) = ind_temp(2);
                matchStrides(3,:) = ind_temp(3);
                matchStrides = sort(matchStrides);
            end
            if  ind_dupl(1)== 2 && ind_dupl(2)== 4
                ind_temp =  find(abs(FS1-FS2)==d(1));
                ind_temp2 =  find(abs(FS1-FS2)==d(3));
                matchStrides(1,:) = ind_temp(1);
                matchStrides(2,:) = ind_temp(2);
                matchStrides(3,:) = ind_temp2(1);
                matchStrides = sort(matchStrides);
            end
        end
        if length(ind_dupl)==1 || length(ind_dupl)>=2 && ind_dupl(2)>4 
           ind_dupl = ind_dupl(1);
            if ind_dupl == 2
               ind_temp =  find(abs(FS1-FS2)==d(2));
               matchStrides(1,:) = ind_temp(1);
               matchStrides(2,:) = ind_temp(2);
               matchStrides(3,:) = find(abs(FS1-FS2)==d(3));
               matchStrides = sort(matchStrides);
            end
            if ind_dupl == 3
                ind_temp =  find(abs(FS1-FS2)==d(3));
                matchStrides(1,:) = find(abs(FS1-FS2)==d(1));
                matchStrides(2,:) = ind_temp(1);
                matchStrides(3,:) = ind_temp(2);
                matchStrides = sort(matchStrides);
            end
            if  ind_dupl == 4 
                ind_temp =  find(abs(FS1-FS2)==d(4));
                matchStrides(1,:) = find(abs(FS1-FS2)==d(1));
                matchStrides(2,:) = find(abs(FS1-FS2)==d(2));
                matchStrides(3,:) = ind_temp(1);
                matchStrides = sort(matchStrides);
            end
        end
    end
end

