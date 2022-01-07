function reloadingClustergramObject(file,path)

% loading in a clustergram object.
fullpath = [path file];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(fullpath);
clc;
close all force;
ClusteringGUI;
clc;
cgo.view;

end
