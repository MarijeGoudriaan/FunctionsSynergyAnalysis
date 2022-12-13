function [SymSubj] = FindSymSubj(FileList)
% Find different files with the same subject_ID.
% INPUT:        FileLIst = Cell-array with filenames
% OUTPUT:       SymSub = Cell-array with similar subjects

% Marije Goudriaan, 22-04-2020

%%

Pt{length(FileList)} = {0};
pt_sim = zeros(length(FileList),1);
for j = 1:length(FileList)
%     parts = strsplit(FileList{1,j}, '_');
%     Pt{j} = parts{1,1};
    Pt{j} = FileList{1,j}(1:end-7);
end
clearvars j


for j = 1:length(FileList)-1
    PT_SIM = strcmpi(Pt{1,j},Pt{1,j+1});
    if isempty(PT_SIM)
        PT_SIM = 0;
    end
    pt_sim(j,:) = PT_SIM;
    [x,~] = find(pt_sim == 0);
end
x = [0;x;length(FileList)];
clearvars j

SymSubj{1,length(x)} = {0};
for j = 1: length(x)-1
    SymSubj {1,j} = FileList(1,x(j)+1:x(j+1));
end
end

