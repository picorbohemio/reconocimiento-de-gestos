function out=getListFiles(folderAddress,gender,type)

    path=[folderAddress '/' gender];
    list_dir=dir(fullfile(path,type));
    list_dir={list_dir.name};
    out=list_dir(3:end);

end