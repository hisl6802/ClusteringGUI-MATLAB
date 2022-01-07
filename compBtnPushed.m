function compBtnPushed(Comp_btn)
    %Send the user to the VolcanoDataIntegrity plot.
    [file,path] = uigetfile('*.xlsx','*.xls','*.csv');
    full_path = [path file];
    VolcanoDataIntegrity(full_path)
end