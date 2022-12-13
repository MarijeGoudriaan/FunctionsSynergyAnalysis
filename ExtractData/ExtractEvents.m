function [FSr,FOr,FSl,FOl] = ExtractEvents(events, corrFactor, delay)
% ExtractEvents converts the events data collected with a different 
% sample frequency (video) to the analog sample frequency

%INPUT:     events: struct with event data
%           Afs: analog sample frequency
%OUTPUT:    Events in analog data samples.   

% Marije Goudriaan 18-04-2020
%%        
FSr = [];
FOr = [];
FSl = [];
FOl = [];
eventNames = fieldnames(events);            
        for n = 1:length(eventNames)
            eventsCorr.(eventNames{n,1}) = events.(eventNames{n,1});
            parts = strsplit(eventNames{n,1}, '_');
            if  strcmp(parts{1,1}, 'Right') ==1 && strcmp(parts{1,end}, 'Strike') 
                FSr = round(nonzeros(((eventsCorr.(eventNames{n,1})+delay)*corrFactor)));  
            end
            if  strcmp(parts{1,1}, 'Right') ==1 && strcmp(parts{1,end}, 'Off') 
                FOr = round(nonzeros(((eventsCorr.(eventNames{n,1})+delay)*corrFactor)));  
            end
            if strcmp(parts{1,1}, 'Left') ==1 && strcmp(parts{1,end}, 'Strike')
               FSl = round(nonzeros(((eventsCorr.(eventNames{n,1})+delay)*corrFactor)));  

            end
            if strcmp(parts{1,1}, 'Left') ==1 && strcmp(parts{1,end}, 'Off')
               FOl = round(nonzeros(((eventsCorr.(eventNames{n,1})+delay)*corrFactor)));  
            end
        end
end

