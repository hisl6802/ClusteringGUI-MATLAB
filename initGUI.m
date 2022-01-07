function initGUI
clear;clc;
%%
%--------------------------------------------------------------------------
% 05-23-20. Creating the elements of the GUI that are needed to create the
% wanted functionality including three buttons designed to go to three
% seperate locations allowing the user to quickly accomplish the tasks they
% are hoping to using the clustering GUI. 
%
% 05-26-20. Added more buttons to increase functionality of the Clustering
% GUI while also looking into the sepearation of variables to allow for the
% reduction in the complexity of the initGUI code. 
%--------------------------------------------------------------------------

%% Initialize clutering GUI homepage
hMainFigure = uifigure('Name','Clustering GUI');

%Determing the size of the figure to allow for elements to be appropriately
%sized. 
size_Figure = hMainFigure.Position;
size_files_vert = size_Figure(4)-40;
size_files_hor = size_Figure(3)-40;

%Initialize the panel allowing the user to determine the action
Main_panel = uipanel(hMainFigure,'Title','Clustering Analysis Homepage',...
                                 'BackgroundColor',[0.0784 0.149 0.6118],...
                                 'ForegroundColor', [0.8902 0.6745 0.26274],...
                                 'Position',[20 20  size_files_hor size_files_vert],...
                                 'TitlePosition','centertop','FontSize',20);
                           
%Create button to open uiopen and allow user to load an excel sheet
%allowing the user to generate the data needed to evaluate the linkage
%functions. 
size_panel = Main_panel.Position;
btn_hor = size_panel(3)*0.4;
btn_vert = size_panel(4)*0.3;
btm_btn = size_panel(4) - 1.5*btn_vert;
side_btn = size_panel(3)*0.05;
Cluster_btn = uibutton(Main_panel,'push','Text','Create Clustergram',...
                                  'Position',[side_btn btm_btn btn_hor btn_vert],...
                                  'FontSize',16,...
                                  'FontColor',[0.0784 0.149 0.6118],...
                                  'BackgroundColor',[0.8902 0.6745 0.26274],...
                                  'ButtonPushedFcn', @(Cluster_btn,event) clusterBtnPushed(Cluster_btn));      
                           
%Create button for volcano plot data integrity checks
btm_comp = btm_btn - 1.5*btn_vert;
Comp_btn = uibutton(Main_panel,'push','Text','Data Integrity (Volcano)',...
                               'Position',[side_btn btm_comp btn_hor btn_vert],...
                               'FontSize',16,...
                               'FontColor',[0.0784 0.149 0.6118],...
                               'BackgroundColor',[0.8902 0.6745 0.26274],...
                               'ButtonPushedFcn', @(Comp_btn,event) compBtnPushed(Comp_btn));
                            
%Create button for grouping medians allowing for the rapid determination of
%medians to group.
side_group = 3*side_btn + btn_hor;
Group_btn = uibutton(Main_panel,'push','Text','Group Medians',...
                                'Position',[side_group btm_btn btn_hor btn_vert],...
                                'FontSize',16,...
                                'FontColor',[0.0784 0.149 0.6118],...
                                'BackgroundColor',[0.8902 0.6745 0.26274],...
                                'ButtonPushedFcn', @(Group_btn,event) GroupBtnPushed(Group_btn));
                            
%Create button for going from clusters to peaks to pathways

clustPeaksToPathways = uibutton(Main_panel,'push','Text','Peaks to Pathways',...
                                           'Position',[side_group btm_comp btn_hor btn_vert],...
                                           'FontSize',16,...
                                           'FontColor',[0.0784 0.149 0.6118],...
                                           'BackgroundColor',[0.8902 0.6745 0.26274],...
                                           'ButtonPushedFcn', @(clustPeaksToPathways,event) PeaksToPathways(clustPeaksToPathways));
                            
%Create label for the save text area so the user knows to input the name
%that should be used to save the data. 
label_side = 0.05*size_panel(3);
label_btm = 0.825*size_panel(4);
label_length = size_panel(3) - 2*label_side;
label_height = 50;
saveNameLabel = uilabel(Main_panel,'Text','Input name for the medians output file:',...
                                   'Position',[label_side label_btm label_length label_height],...
                                   'FontSize',18,...
                                   'Visible','off');
                               
%Create text area to allow for the user to input the name for the output
%file. 
saveNameBtm = 0.8*size_panel(4);
side_btn_group = 0.25*size_panel(3);
btn_hor_group = 0.5*size_panel(3);
SaveName = uitextarea(Main_panel,'Position',[side_btn_group saveNameBtm btn_hor_group 20],...
                                 'Visible','off');
                              
                            
%Create a button that appears when the group medians button is pushed.

Group_btn_file = uibutton(Main_panel,'push','Text','Select Data',...
                                     'Position',[side_btn_group 20 btn_hor_group btn_vert],...
                                     'FontSize',16,...
                                     'Visible','off',...
                                     'ButtonPushedFcn', @(Group_btn_file,event) GroupBtnFilePushed(Group_btn_file,SaveName));
%Return to normal 
sideReturn = size_panel(3)*0.275;
btmReturn = size_panel(4)*.015;
returnHor = size_panel(3)*0.45;
returnVert = size_panel(4)*0.075;
returnHome = uibutton(Main_panel,'Position',[sideReturn btmReturn returnHor returnVert],...
                                     'Text','Return to Homepage',...
                                     'FontSize',20,...
                                     'Visible','off',...
                                     'ButtonPushedFcn',@(returnHome,event) btnReturnHome(returnHome));                

function GroupBtnPushed(Group_btn)
    Cluster_btn.Visible = 'off';
    Comp_btn.Visible = 'off';
    Valid_btn.Visible = 'off';
    Group_btn.Visible = 'off';
    clustPeaksToPathways.Visible = 'off';
    Main_panel.Title = 'Grouping Medians';
    Group_btn_file.Visible = 'on';
    saveNameLabel.Visible = 'on';
    SaveName.Visible = 'on';
    returnHome.Visible = 'on';
end

function btnReturnHome(returnHome)
    Cluster_btn.Visible = 'on';
    Comp_btn.Visible = 'on';
    Valid_btn.Visible = 'on';
    Group_btn.Visible = 'on';
    clustPeaksToPathways.Visible = 'on';
    Main_panel.Title = 'Clustering Analysis Homepage';
    Group_btn_file.Visible = 'off';
    saveNameLabel.Visible = 'off';
    SaveName.Visible = 'off';
    returnHome.Visible = 'off';    
end
end