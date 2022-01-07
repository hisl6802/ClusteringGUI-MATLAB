function clustergramRead(file,path,linkage,color,sheet)
%%
% -------------------------------------------------------------------------
% 05-24-20
% Adding in the check for the readtable to allow the user to simply input
% the file and not have to worry about getting the approrpriate range and
% sheet number. 
%
% 05-25-20. 
% Added check to ensure that the sheet number input is correct and the user
% is able to input the appropriate sheet further work can be done to catch
% errors that are caused by inappropriate inputs for the sheet number. This
% problem should be mitgated by the use of the GroupMedians code that takes
% the original groups created and allows the user to create the needed
% medians of the group metabolites. 
% -------------------------------------------------------------------------
%


%Read in the table
fullpath = [path file];%full path of file
sheetNum = cell2mat(sheet);
sheetNum = str2num(sheetNum);

data = readtable(fullpath,'Sheet',sheetNum);

range_start = 'A1:';
range_end = string(size(data,1));
range_index = size(data,2);
load('dict.mat');
if range_index < 26
    range_index = dict(range_index,:);
    range_index = strip(range_index,'right');
else
    range_index = dict(range_index,:);
end
Range = string(range_start)+string(range_index)+range_end;
data = readtable(fullpath,'Sheet',sheetNum,'Range',Range);
data = table2array(data);

%maximum groups
maxGroups = size(data,2)-1;
%Resize table so that only the median values are clustered
data = data(:,2:maxGroups);

%create the clustergram
cgo = clustergram(data,'standardize','row','linkage',linkage,'colormap',color);

ending = string('_Clustergram.mat');
if file(length(file)-4:length(file)) == '.xlsx'
    fileName = string(file(1:length(file)-5));
elseif file(length(file)-3:length(file)) == '.xls'
    fileName = string(file(1:length(file)-4));
end

fileName = fileName + ending;

save(fileName,'cgo')


end
