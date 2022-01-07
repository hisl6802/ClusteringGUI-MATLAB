function [data] = excelDataCheck(file,path,Type,Dimension)
%%-------------------------------------------------------------------------
%
% 05-29-20. Adding the functionality of checking the appropriate sheet
% number before sending the information back as an appropriately sized and
% input data array. Additional work will be done to ensure theuser can
% access the appropriate file and get the appropriate results for the
% appropriate callout to the excel sheet.
%--------------------------------------------------------------------------
clc;

%Check to ensure that the number of input arguments is appropriate for the
%model and set any needed parameters based upon
if nargin == 2
    Type = 'P2P';
    Dimension = 'NA';
elseif nargin == 3 && Type == 'P2P'
    Dimension = 'NA';
elseif nargin == 3 && Type == 'Med'
    Dimension = 'C';
elseif nargin < 2 || nargin > 4
    error('Inappropriate number of input arguments');
end

% Read in the file for the first time to allow for the determination of the
% appropriate size to read in. 
filename = [path file];
data = readtable(filename);

%Check the sheet number of the file
attempts = 0;
while(1)
    attempts =attempts + 1;
    disp('Is the wanted data on sheet 1? (Y or N) ');
    Sheet_check = input('Is the wanted data on sheet 1? (Y or N) ','s');
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
        Sheet = Sheet_pre + Sheet_num;
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

if Type == 'P2P'
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
end



end