function VolcanoDataIntegrity(fileName)

%--------------------------------------------------------------------------
% This function checks the integrity of the data downloaded from
% the volcano plots on metaboanalyst, allowing the user to ensure that the
% data is appropriately configured before further analysis.
%
%
% fileName- corresponds to the excel worksheet that contains the groups
% created for initial input to metaboanlyst.
%
% saveName- corresponds to location and name for the output of corrected
% volcano plot data file. This will not be used if the data from the volcano
% plot download file is appropriately configured
%--------------------------------------------------------------------------

%% Data Integrity Check for Volcano Plots
%%
% 05/02/20 Adding the ability to check the data integrity from Volcano
% plots.
% 06/02/20 Adding a call to this function from the 
clc;
saveName =fileName;
% Load in data from Volcano plot up regulated and down regulated 
[data] = xlsread(fileName);

% Checking for NaN in the data set.
Corrupt = 0;
for i = 1:length(data)
    if isnan(data(i,1))
        disp('Data Integrity issue, will correct issue.');
        Corrupt = 1;
        break;
    end
end


if Corrupt == 1
    fixed_Data = zeros(length(data),1);
    %opening the file in a different manner to allow for parsing through the
    %data
    fileID = fopen(fileName);
    fLine = fgetl(fileID);
    N = 1;
    while(1)
        N = N + 1;
        Line = fgetl(fileID);
        L_length = length(Line);
        %Has first number been found
        first_num = 0;
        %quotation marks (how many have been found per line.
        q_m = 0;
        %decimals points found
        d_p = 0;
        %New string for new line
        curString = '';
        %Looping over the line to find first column value
        for i = 1:L_length
            curVal = Line(i);
            %Finding the value in the string
            if curVal == '"'
                q_m = q_m + 1;
%                 if q_m == 2
%                     fixed_Data(N-1,1) = str2double(curString);
%                 end
            elseif curVal ==','
                fixed_Data(N-1,1) = str2double(curString);
                break;
            elseif curVal == '.'
                d_p = d_p + 1;
                if d_p ~= 2
                    curString = [curString curVal];
                end
            elseif curVal == '0' || curVal == '1' || curVal == '2' || curVal == '3'
                curString = [curString curVal];
            elseif curVal == '4' || curVal == '5' || curVal == '6'
                curString = [curString curVal];
            elseif curVal == '7' || curVal == '8' || curVal == '9'
                curString = [curString curVal];
            end
        end
        %breaking the while loop so that we don't have an infinite loop
        if length(Line) == 1
            break;
        end
    end

end
if Corrupt == 1
    %Parse though excel spreadsheet
    data(:,1) = fixed_Data;
    m_z = data(:,1);
    FC = data(:,2);
    log_FC = data(:,3);
    p_val = data(:,4);
    neg_log_10_p = data(:,5);
    table_fixed_data = table(m_z,FC,log_FC,p_val,neg_log_10_p);
    writetable(table_fixed_data,saveName);
end

end
    




