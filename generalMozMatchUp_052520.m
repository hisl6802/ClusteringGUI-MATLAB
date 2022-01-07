function generalMozMatchUp_052520
%%-------------------------------------------------------------------------
% This code is designed to handle clusters name G1-GN (N=number of
% clusters). This code matches the m/z values for each cluster with the
% retention times and the m/z values allowing for the analysis of the
% pathways in the body. 
%
% *****Make sure to download the mozPeaksToPathways.m function and dict.mat
% file, to the current folder. 
%
%%-------------------------------------------------------------------------

% 05-18-20
% Generalizing the code for ability to loop through any number of clusters
% that is input to function. Allowing for the user to input as many
% clusters selected during the clustering analysis to the peaks to pathways
% analysis. 

% 05-19-20
% Added the mozPeaksToPathways function to allow for the direct creation of
% files for peaks to pathways analysis in Metaboanalyst using mummichog. 
% Changed the way the file is read in to allow for the user to not need to
% specify the range over which they need to look for data values in the
% excel sheet.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;
disp('Select Cluster .mat file when the file selection box appears');
pause(2);
[Clustername path] = uigetfile('*.mat');
fullpath = [path Clustername];
%Clustername = input('Input .mat file containing selected clusters ','s');
load(fullpath);

clear Clustername path fullpath ans;clc;

Clusters = who;

%Number of rows in 3D array.
n = zeros(length(Clusters),1);

for i = 1:length(Clusters)
    try 
        C_cur = eval(string(Clusters(i)));
        C_cur_length = length(C_cur.ExprValues);
        n(i) = C_cur_length;
    catch
        base_message = 'Unable to evaluate Cluster';
        num_cluster = string(i);
        warn = base_message + num_cluster;
        warning(warn);
    end
end


% Number of groups in the study.
try
    C_cur = eval(string(Clusters(i)));
    groups = size(C_cur.ExprValues,2);
catch
    error('Unable to determine the number of groups in the clustergram');
end

% Input all values to 3D matrix for analysis.
ExprValues(:,:,1) = zeros(max(n),groups);
for j =1:length(Clusters)
    try
        C_cur = eval(string(Clusters(j)));
        ExprValues(1:size(C_cur.ExprValues,1),1:size(C_cur.ExprValues,2),j) = C_cur.ExprValues;
    catch
        error('Unable to input a Cluster to the ExprValues 3D matrix');
    end
end

%Select and open an excel sheet to compare the cluster function values
%against.
disp('Select excel worksheet containing median m/z values from XCMS Output');
pause(2);
[filename path] = uigetfile('*.xlsx','*.xls');
filename = [path filename];
clc;
%Check the sheet number of the Medians
attempts = 0;
while(1)
    attempts =attempts + 1;
    disp('Are the calculated medians on sheet 1? (Y or N) ');
    Sheet_check = input('Are the calculated medians on sheet 1? (Y or N) ','s');
    clc;
    if Sheet_check == 'Y' || Sheet_check == 'y'
        try
            Median_moz_table = readtable(filename);
            break;
        catch
            error('Filename does not exist or was input incorrectly');
        end
    elseif Sheet_check == 'N' || Sheet_check == 'n'
        Sheet_pre = 'Sheet';
        disp('Please input the sheet number: (ex. 2) ');
        Sheet_num = input('Please input the sheet number:(ex. 2) ','s');
        clc;
        Sheet_pre = string(Sheet_pre);
        Sheet = str2num(Sheet_num);
        try
            Median_moz_table = readtable(filename,'Sheet',Sheet);
            break;
        catch
            if string(filename(length(filename)-4:length(filename))) ~= '.xlsx' || string(filename(length(filename)-3:length(filename))) ~= '.xls'
                if ischar(filename)
                    filename = string(filename);
                    filename = filename + '.xlsx';
                    try
                        Median_moz_table = readtable(filename,'Sheet',Sheet);
                        break
                    catch
                        filename = char(filename);
                        filename = filename(1:length(filename)-5);
                        filename = string(filename) + '.xls';
                        try
                            Median_moz_table = readtable(filename,'Sheet',Sheet);
                        catch
                            error('Error in the input of the sheet number or the filetype check file to ensure appropriate filename and sheet number');
                        end
                    end
                end
            else
                error('Error in the input of the sheet number or the filetype check file to ensure appropriate filename and sheet number');
            end
        end
    else
        if attempts == 3
            error('You did not input (Y or N) and have failed out of this program after three attempts!');
        end
    end
end
range_start = 'A1:';
range_end = string(size(Median_moz_table,1));
range_index = size(Median_moz_table,2);
load('dict.mat');
if range_index < 26
    range_index = dict(range_index,:);
    range_index = strip(range_index,'right');
else
    range_index = dict(range_index,:);
end

Range = string(range_start)+string(range_index)+range_end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
Median_moz = readtable(filename,'Sheet',Sheet,'Range',Range);

Median_moz = table2array(Median_moz);

%Taking the retention time out of the table
rt_med = Median_moz(:,size(Median_moz,2));

% Combine retention time and intensities
rt_peaks = rt_med;

% intensities
data = Median_moz(:,2:size(Median_moz,2)-1);

% add the intensities
rt_peaks(:,2:size(Median_moz,2)-1) = data;

%Initializing a Retention Times 3D array
RetTimes = zeros(max(n),8,length(Clusters));

n_stor = n;
n = max(n);
%number of changes
changes = 0;
% creation of a for loop to correlate the retention times to intensities
for k = 1:size(ExprValues,3)
    for l = 1:numel(ExprValues(:,:,1))
        %Finding column and row for the ExprValues
        column = ceil(l/n);
        %Setting the appropriate row
        if column > 1
            row = (l-(n*(column-1)));
        else
            row = l;
        end
        
        for i=1:size(data,2)
            %check for values being equal
            eq = 0;
            %check for zeros
            if ExprValues(row,column,k) == 0
                %breaking the loop to find the retention time for the next
                %non-zero intensity. 
                break;
            end
            
            for j=1:length(data)
                %Getting the current data intensity value
                current_intensity = data(j,i);
                %Checking to see if the intensity value matches intensity
                %value from data
                %if current_intensity == ExprValues(row,column,k)
                if abs(ExprValues(row,column,k)-current_intensity)< 0.001
                    eq = 1;
                    %ExprValues(row,column,k) = rt_peaks(j,1);
                    RetTimes(row,column,k) = rt_peaks(j,1);
                    changes = changes + 1;
                    %Exiting loop since intensity value is found in the
                    %data.
                    break;
                end
            end
            %Exit loop if value equals data value
            if eq == 1
                break;
            end
        end
    end    
end

if changes == 0
    %Error is currently on line 84.
    error("Intensity Values were not properly checked");
end

G_moz_values = zeros(length(RetTimes),length(Clusters));
G_ret_values = G_moz_values;

%Setting up for loop for determination of the m/z values corresponding to
%the retention times
for i = 1:length(Clusters)
    for j = 1:length(RetTimes)
        G_current = RetTimes(j,1,i);
        if G_current == 0
            for l = 2:size(RetTimes,2)
                G_current = RetTimes(j,l,i);
                if G_current ~= 0
                    for k =1:length(Median_moz)
                        if G_current == Median_moz(k,size(Median_moz,2))
                            G_moz_values(j,i) = Median_moz(k,1);
                            G_ret_values(j,i) = G_current;
                            break;
                        end
                    end
                    break;
                end
            end
        else
            for k =1:length(Median_moz)
                if G_current == Median_moz(k,size(Median_moz,2))
                    G_moz_values(j,i) = Median_moz(k,1);
                    G_ret_values(j,i) = G_current;
                end
            end
        end  
    end 
end

%% Writing the results to an excel spreadsheet
%removing the .xlsx suffix
name = filename(1:length(filename)-5);
midName = 'MediansMoz';
suffix = '.xlsx';
filename_o = [name midName suffix];

for i = 1:length(Clusters)
    clear G_table
    G_table = G_ret_values(1:n_stor(i),i);
    G_table(:,2) = G_moz_values(1:n_stor(i),i);
    G_table(:,3:column+2) = ExprValues(1:n_stor(i),:,i);
    G_table = array2table(G_table);
    C_cur = string(Clusters(i));
    C_cur = strip(C_cur,'left','G');
    C_cur = str2num(C_cur);
    if isempty(C_cur)
        C_cur = string(Clusters(i));
        C_cur = strip(C_cur,'left','G');
        C_cur = strip(C_cur,'left','_');
        C_cur = str2num(C_cur);
    end
    writetable(G_table,filename_o,'Sheet',C_cur)
end


%Sending the created file to the mozPeaksToPathways to ready for peaks to
%pathways analysis.
Range = string(range_start) + "A" + range_end;
mozPeaksToPathways(filename,filename_o,length(Clusters),n,Range,Sheet)

end