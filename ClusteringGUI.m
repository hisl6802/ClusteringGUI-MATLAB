function ClusteringGUI
%%
%--------------------------------------------------------------------------
% 05-23-20. Creating the clustering GUI that will allow the user to quickly
% create the clustergram object and save it and then return to the homepage
% to analyze the appropriate linkage function and validity index of the
% clustering technique.
%
% 05-25-20. Creating the clustergram creation GUI setup to allow the user
% to select the appropriate values for each needed input. And then creating
% the clustergram object that can be loaded to allow for the user to create
% the clustergram that can be used for analysis of validity and linkage
% functions. 
%
% 05-28-20. Created another button to allow the user to return to the
% homepage of the GUI. With the function created outside of the
% ClusteringGUI function to allow the team to use the code in other places.
%--------------------------------------------------------------------------

close all force;
%Create the main figure for Creating the Clustering object.
clustGUI = uifigure('Name','Clustergram Creation');

%Determing the size of the figure to allow for elements to be appropriately
%sized. 
size_Figure = clustGUI.Position;
size_files_vert = size_Figure(4)-40;
size_files_hor = size_Figure(3)-40;

%Initialize the panel allowing the user to determine the action
mainClustPanel = uipanel(clustGUI,'Title','Clustergram Options',...
                                 'BackgroundColor','white',...
                                 'Position',[20 20  size_files_hor size_files_vert],...
                                 'TitlePosition','centertop','FontSize',20);
                             
%Create the list box to allow for the user to select the appropriate input for each portion of clustergram input. 
size_panel_clust = mainClustPanel.Position;
size_panel_vert = (size_panel_clust(4)/2)-40;
size_panel_hor = (size_panel_clust(3)/2)-40;
btm_list = size_panel_clust(4) - 1.35*size_panel_vert;

%Items for the linkage function
Items_link = {'-----Linkage Functions-----','complete','single','average','ward'};

listBoxLinkageFunctions = uilistbox(mainClustPanel,'Position',[20 btm_list size_panel_hor size_panel_vert],...
                                                   'Items',Items_link,...
                                                   'FontSize',15);                                          
%Items for the colormap selection
Items_color = {'-----ColorMap Options-----','parula','jet','hsv','hot','cool','spring','summer','autumn',...
               'winter','gray','bone','copper','pink','lines','colorcube',...
               'prism','flag'};
listBoxColorLoc = listBoxLinkageFunctions.Position;
listBoxColorLoc = listBoxColorLoc(3) + 40;
listBoxColorClustergram = uilistbox(mainClustPanel,'Position',[listBoxColorLoc btm_list size_panel_hor size_panel_vert],...
                                                 'Items',Items_color,...
                                                 'FontSize',15);
                                             
                                             
%Create text box for the message to display so user knows what to select
%before they enter the analysis.
innerPanel = mainClustPanel.InnerPosition;
btmText = innerPanel(4) - 30;
sizeHorText = innerPanel(3) - 40;

msgToUser = uilabel(mainClustPanel,'Position',[20 btmText sizeHorText 20],...
                                   'Text','Select linkage function and colormap before selecting data...',...
                                   'FontSize',16); 
    
% %Sheet number Check
textArea_side = innerPanel(3)*0.6 + 40;
textArea_bottom = innerPanel(4)*0.425;
sheetNum = uitextarea(mainClustPanel,'Position',[textArea_side textArea_bottom 40 20],...
                                     'Visible','on');
                                 
%Create label describing the wanted input.
labelLength = innerPanel(3)*0.6;
labelSheet = uilabel(mainClustPanel,'Position',[20 textArea_bottom labelLength 20],...
                                    'Text','Please input the sheet number for the excel sheet',...
                                    'Visible','on');
                                                 
% Create the button for the selecting the appropriate 
side_dist_btn = size_panel_clust(3)*0.05;
btm_dist_btn = size_panel_clust(4)*0.125;
size_btn_hor = size_panel_clust(3)*0.42;
size_btn_vert = size_panel_clust(4)*0.25;
btn_xcms = uibutton(mainClustPanel,'Position',[side_dist_btn btm_dist_btn size_btn_hor size_btn_vert],...
                                   'Text','Select Data to Analyze',...
                                   'FontSize',20,...
                                   'ButtonPushedFcn', @(btn_xcms,event) btnXCMS(btn_xcms,listBoxColorClustergram,listBoxLinkageFunctions,sheetNum));
                               
% Create button to reload clustergram objects
side_dist_btn_reload = size_panel_clust(3) * 0.53;
btnReload = uibutton(mainClustPanel,'Position',[side_dist_btn_reload btm_dist_btn size_btn_hor size_btn_vert],...
                                    'Text','Reload Clustergram',...
                                    'FontSize',20,...
                                    'ButtonPushedFcn',@(btnReload,event) btnReloadPush(btnReload));
                                
%Create button to allow for the user to return to the Clustering GUI
%homepage
sideReturn = size_panel_clust(3)*0.275;
btmReturn = size_panel_clust(4)*.015;
returnHor = size_panel_clust(3)*0.45;
returnVert = size_panel_clust(4)*0.1;
returnHome = uibutton(mainClustPanel,'Position',[sideReturn btmReturn returnHor returnVert],...
                                     'Text','Return to Homepage',...
                                     'FontSize',20,...
                                     'ButtonPushedFcn',@(returnHome,event) btnReturn(returnHome));


function fullpath = btnXCMS(btn_xcms,listBoxColorClustergram,listBoxLinkageFunctions,sheetNum)
    try
        [file,path] = uigetfile('*.xlsx','*.xls');
        linkage = listBoxLinkageFunctions.Value;
        color = listBoxColorClustergram.Value;
        fullpath = [path file];
        sheet = sheetNum.Value;
        clustergramRead(file,path,linkage,color,sheet);
    end
end

function btnReloadPush(btnReload)
    try
        [file,path] = uigetfile('*.mat');
        reloadingClustergramObject(file,path);
    end
    
end
end