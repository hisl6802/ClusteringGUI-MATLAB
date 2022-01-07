function GroupMedians(fileName,saveName)
%-------------------------------------------------------------------------
% This function creates the medians file for hierarchical clustering
% analysis using the medians of each metabolite for each group. This looks
% for the nomenclature laid out in Alyssa's protocol where groups are
% denoted as 1A-1N, 2A-2N, and so forth.
%
% fileName- corresponds to the excel worksheet that contains the groups
% created for initial input to metaboanlyst.
%
% saveName- corresponds to location and name for the output of the medians
% file. If the directory that you have the function is where you would like
% to save the file simply input the name of the excel sheet (ex.
% Jake_Medians.xlsx), if you would like to save it in another location
% specific the full path to where you would like to save the output (ex.
% C:\Users\bradyhislop\Box\Metabolomics Data\Jake_Medians.xlsx')
%
% Currently, you need to add the retention times to the last column to
% allow for access for the future use of this file in the peaks to pathways
% analysis. 

%%-------------------------------------------------------------------------
% 05-19-20 
% Changing the script to a function to allow the user to input the location
% of a file containing the groups and the location in which they would like
% to save the file. 

%% Determining the Medians for each metabolite.
clc;

% Need to write my function to look into size of the data with the excel
% sheet that is relevant.
[data,txt] = xlsread(fileName,'a1:egx25');

groups = cell2mat(txt(2:length(txt),1));
clear txt

%Columns for medians file
group_spacing = [];
num_its = 0;
last_it = 1;
max_group_num = 1;
group_num = 1;
for i =1:length(groups)
    %Number of iterations to determine the appropriate spacing for each
    %medians file
    num_its = num_its+1;
    %Finds group number
    cur_group_num = str2num(groups(i,1));
    if i>1 && cur_group_num > str2num(groups(i-1,1)) 
        group_spacing(group_num) = i - last_it;
        last_it = i;
        group_num = group_num + 1; 
    elseif i == length(groups) 
        group_spacing(group_num) = (i+1) -last_it;
    end
    group_order(i) = cur_group_num;
    if cur_group_num > max_group_num
        max_group_num = cur_group_num;
    end
end

%Tell computer how much space you need
Median = zeros(length(data),max_group_num+1);

%put the m/z values in the first column
Median(:,1) = data(1,:);


%Create starting group
G_num = 1;

for i =1:max_group_num
    for j = 1:length(Median)
        %Need to use group spacing in the future to create the appropriate
        %splits in a more general fashion
        Median(j,i+1) = median(data((4*(i-1)+1):(4*i),j));
    end
end

%Converting table to array.
Medians_output = array2table(Median);

writetable(Medians_output,saveName);

end
