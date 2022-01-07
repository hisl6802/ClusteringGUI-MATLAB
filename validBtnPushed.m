function validBtnPushed(Valid_btn)
    cur_dir = cd;
    cd('C:\');
    [file,path]=uigetfile('*.mat');
    full_path = [path file];
    cd(cur_dir);
end