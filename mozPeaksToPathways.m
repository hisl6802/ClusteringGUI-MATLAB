function mozPeaksToPathways(filenameXCMS,filenameCluster,numClust,maxNumMetab,Range,Sheet)

%% Peaks to Pathways Code for Checking the m/z values against the output from ClusterGroup
% 05-18-20 Adding functionality to this function to allow for it to read in
% the excel file that contains the m/z values from xcms. This will then be
% used to determine m/z values in the cluster that are grouped together and
% thus allow a peaks to pathways analysis of this clusterGroup. 
%
% 05-25-20. Added two more inputs to further generalize this function
% allowing the user to input the medians file and selected clusters to the
% generalMozMatchUp_###### code and get an output of peaks to pathway files
% for each set of data. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Will need to specify the number of sheets by knowing the number of groups
% created or by having this be a function that is called in the
% generalMozMatchUp file.
clc;

%Filenames from XCMS and following clustering and m/z match up.

moz_xcms = readtable(filenameXCMS,'Sheet',Sheet,'Range',Range);

%Read in the Cluster for all selected clusters.
Clusters = zeros(maxNumMetab,numClust);
for i = 1:numClust
    Sheet_name = 'Sheet';
    Sheet_num = string(i);
    Sheet = Sheet_name+Sheet_num;
    Clust_current = readtable(filenameCluster,'Sheet',Sheet);
    Clust_current = table2array(Clust_current);
    Clusters(1:size(Clust_current,1),i) = Clust_current(:,2);
end

%initialize the moz_matrix which will contain all of the values for the
%pathways analysis.
moz_xcms_initial = table2array(moz_xcms);
moz_xcms = zeros(length(moz_xcms_initial),3,numClust);
for i = 1:numClust
    moz_xcms(:,1,i) = moz_xcms_initial;
end

%Set the p.values for the each cluster to 0.04 or 1 depending on whether or
%not it is in the cluster. 
for k = 1:numClust
    for i =1:length(moz_xcms)
        for j = 1:maxNumMetab
            if moz_xcms(i,1,k) == Clusters(j,k)
                moz_xcms(i,2,k) = 0.04;
                moz_xcms(i,3,k) = 1;
                break;
            else
                moz_xcms(i,2,k) = 1;
                moz_xcms(i,3,k) = 2;
            end
        end
    end
end   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%There is an issue with my sorting function.
%Sorting through the ranks and adding them to a current table of the
%appropriate order
moz_xcms_sorted = zeros(length(moz_xcms),2,numClust);
for i = 1:numClust
    change = 0;
    for j = 1:2
        for k = 1:length(moz_xcms)
            if j == 1 && moz_xcms(k,3,i) == 1
                moz_xcms_sorted(change+1,:,i) = moz_xcms(k,1:2,i);
                change = change +1;
            elseif j == 2 && moz_xcms(k,3,i) == 2
                moz_xcms_sorted(change+1,:,i) = moz_xcms(k,1:2,i);
                change = change + 1;
            end
        end
    end
end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Would it be better to change this so that it writes to many different
% spreadsheets 
OutputPrefix = 'PeaksToPathways_';
suffix = '.csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Should allow user to input dataset name.
for i = 1:numClust
    dataset_name = 'JakeCluster';
    moz_xcms_sorted_cur = array2table(moz_xcms_sorted(:,:,i));
    moz_xcms_sorted_cur.Properties.VariableNames = {'m_z','p_value'};
    Cluster_number = string(i);
    Cluster_number = dataset_name + Cluster_number;
    OutputName_cur = OutputPrefix + Cluster_number + suffix;
    writetable(moz_xcms_sorted_cur,OutputName_cur);
end



end
            

