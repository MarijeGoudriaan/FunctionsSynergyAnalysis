function [Concatenated,PerCycle, sideNames, UsedEMGs] = RenameSides(signals, EMGnames, SelectedSide)
% This function allows to identify a more or less-involved side and rename
% + regroup the signals accordingly. The signal used in the bilateral analysis is
% always the signal that is split based on the right foot strikes or the
% less involved side, depending on what the selection of SelectedSide is.

% INPUT:        signals:    Struct with concatenated and perCycle signals
%               EMGnames:   names of the EMGsignals included in the struct
%               SelectedSide: Which side you want to use as the most
%                           invloved side. If kept empty, left and right will be used
%                           as side names. 
% 
% OUTPUT:       Concatenated: The renamed concatenated signal
%               PerCycle:   The renamed individual strides
%               UsedEMGs:   The EMGnames related to more or less involved side.
%               sideNames:  The names of the sides that need to be used
%                           throughout the rest of the analyses (left/right or
%                           more/less-involved)

% Marije Goudriaan 1 July 2022
%%
sides = fieldnames(signals.Concatenated);
    if length(sides) >1 
    % Left is the most involved side    
        if ~isempty(SelectedSide) && strcmp(SelectedSide, 'Left') ==1 || strcmp(SelectedSide, 'left') == 1 ...
            || strcmp(SelectedSide, 'Both')   || strcmp(SelectedSide, 'both')
            for m = 1:length(EMGnames.Right)
                Concatenated.LessInvolv.(EMGnames.Right{m}) = signals.Concatenated.Right.(EMGnames.Right{m});
                PerCycle.LessInvolv.(EMGnames.Right{m}) = signals.PerCycle.Right.(EMGnames.Right{m});
            end
            clearvars m
            for m = 1:length(EMGnames.Left)
                Concatenated.Involv.(EMGnames.Left{m}) = signals.Concatenated.Left.(EMGnames.Left{m});
                PerCycle.Involv.(EMGnames.Left{m}) = signals.PerCycle.Left.(EMGnames.Left{m});
            end
            clearvars m
            for m = 1:length(EMGnames.Bilat)
                Concatenated.Bilat.(EMGnames.Bilat{m}) = signals.Concatenated.Bilat.(EMGnames.Bilat{m});
                PerCycle.Bilat.(EMGnames.Bilat{m}) =  signals.PerCycle.Bilat.(EMGnames.Bilat{m});
            end
            clearvars m
            EMGnames.BilatL = [EMGnames.Left;EMGnames.Right];
            for m = 1:length(EMGnames.BilatL)
                Concatenated.BilatL.(EMGnames.BilatL{m}) = signals.Concatenated.BilatL.(EMGnames.BilatL{m});
                PerCycle.BilatL.(EMGnames.BilatL{m}) =  signals.PerCycle.BilatL.(EMGnames.BilatL{m});
            end
            clearvars m

            UsedEMGs.Involv = EMGnames.Left;
            UsedEMGs.LessInvolv = EMGnames.Right;
            UsedEMGs.Bilat = [UsedEMGs.LessInvolv; UsedEMGs.Involv];
            sideNames = {'Bilat';'Involv';'LessInvolv'};
        end

    % Right is the most involved side  
        if ~isempty(SelectedSide) && strcmp(SelectedSide, 'Right') ==1 || strcmp(SelectedSide, 'right') == 1
            for m = 1:length(EMGnames.Right)
                Concatenated.Involv.(EMGnames.Right{m}) =signals.Concatenated.Right.(EMGnames.Right{m});
                PerCycle.Involv.(EMGnames.Right{m}) = signals.PerCycle.Right.(EMGnames.Right{m});
            end
            clearvars m
            for m = 1:length(EMGnames.Left)
               Concatenated.LessInvolv.(EMGnames.Left{m}) = signals.Concatenated.Left.(EMGnames.Left{m});
                PerCycle.LessInvolv.(EMGnames.Left{m}) =  signals.PerCycle.Left.(EMGnames.Left{m});
            end
            clearvars m
            for m = 1:length(EMGnames.Bilat)
                Concatenated.Bilat.(EMGnames.Bilat{m}) = signals.Concatenated.Bilat.(EMGnames.Bilat{m});
                PerCycle.Bilat.(EMGnames.Bilat{m}) =  signals.PerCycle.Bilat.(EMGnames.Bilat{m});
            end
            clearvars m
            EMGnames.BilatL = [EMGnames.Left;EMGnames.Right];
            Concatenated.BilatR =Concatenated.Bilat;
            PerCycle.BilatR = PerCycle.Bilat;
            PerCycle.Bilat = [];
            Concatenated.Bilat = [];
            for m = 1:length(EMGnames.BilatL)
                Concatenated.Bilat.(EMGnames.BilatL{m}) = signals.Concatenated.BilatL.(EMGnames.BilatL{m});
                PerCycle.Bilat.(EMGnames.BilatL{m}) =  signals.PerCycle.BilatL.(EMGnames.BilatL{m});
            end
            UsedEMGs.Involv = EMGnames.Right;
            UsedEMGs.LessInvolv = EMGnames.Left;
            UsedEMGs.Bilat = [UsedEMGs.LessInvolv; UsedEMGs.Involv];
            sideNames = {'Bilat';'LessInvolv';'Involv'};
        end

    % Use left and right instead of more/less-involved    
        if isempty(SelectedSide)
            for s = 1:length(sides)
                for m = 1:length(EMGnames.(sides{s}))
                   Concatenated.(sides{s}).(EMGnames.(sides{s}){m}) = signals.Concatenated.(sides{s}).(EMGnames.(sides{s}){m});
                   PerCycle.(sides{s}).(EMGnames.(sides{s}){m}) =  signals.PerCycle.(sides{s}).(EMGnames.(sides{s}){m});
                end
                UsedEMGs.(sides{s}) = EMGnames.(sides{s});
            end
            sideNames = sides;
        end
    else
        if ~isempty(SelectedSide)
            for m = 1:length(EMGnames.(sides{1,1}))
                   Concatenated.Involv.(EMGnames.(sides{1,1}){m}) = signals.Concatenated.(sides{1,1}).(EMGnames.(sides{1,1}){m});
                   PerCycle.Involv.(EMGnames.(sides{1,1}){m}) =  signals.PerCycle.(sides{1,1}).(EMGnames.(sides{1,1}){m});
            end
             UsedEMGs.Involv = EMGnames.(sides{1,1});
             sideNames = {'Involv'};
        else
            for m = 1:length(EMGnames.(sides{1,1}))
                   Concatenated.(sides{1,1}).(EMGnames.(sides{1,1}){m}) = signals.Concatenated.(sides{1,1}).(EMGnames.(sides{1,1}){m});
                   PerCycle.(sides{1,1}).(EMGnames.(sides{1,1}){m}) =  signals.PerCycle.(sides{1,1}).(EMGnames.(sides{1,1}){m});
           end
           UsedEMGs.(sides{1,1}) = EMGnames.(sides{1,1});
           sideNames = sides;
        end
    end
end

