function GroupBtnFilePushed(Group_btn_file,SaveName)
    [file,path] = uigetfile('*.xlsx','*.xls');
    fullpath = [path file];
    saveTo = SaveName.Value;
    GroupMedians(fullpath,saveTo);
    returnToGUI;
end