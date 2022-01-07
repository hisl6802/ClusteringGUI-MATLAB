# ClusteringGUI-MATLAB

Please contact, brady.hislop@student.montana.edu with any questions about this Clustering GUI. Please email for tutorial on selecting clusters and submitting them to the peaks to pathways function. Documentation will be uploaded to Wiki pages asap.


## After downloading the zip file, open the following .m file and run the script:

`initGUI.m`

### NOTE: All output files will be saved to the directory containing the source code.


## Functionalities


### Create Clustergram
Allows for direct input of data for generation of clustergrams, offering four linkage functions (complete, single, average, ward) with the distance measure set to Euclidean distance.

### Group Medians
Allows user to input files orginally submitted to Metaboanalyst, for calculated of Group (treatment level) medians, generating output file which can be submitted to the Create Clustergram function once the retention time column has been added to the far right of the data.

### Data Integrity
Corrects double decimals caused by the detection of the same m/z values, when the data is originally submitted to Metaboanalyst. This function outputs an updated file with no double decimals. 


### Peaks to Pathways
Generates files from clusters selected after creating a clustergram. These files can be submitted directly to the mummichog algorithm for the determination of the relevant pathways for a given cluster. 
