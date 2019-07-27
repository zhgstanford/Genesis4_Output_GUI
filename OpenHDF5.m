hinfo = hdf5info(FileName);
%dset = hdf5read(hinfo.GroupHierarchy.Groups(2).Datasets(1));

Name{1}=hinfo.GroupHierarchy.Name;

for I1=1:numel(hinfo.GroupHierarchy.Groups)
    Name{2}=hinfo.GroupHierarchy.Groups(I1).Name;
    for I2=1:numel(hinfo.GroupHierarchy.Groups(I1).Datasets)
        Name{3} = hinfo.GroupHierarchy.Groups(I1).Datasets(I2).Name ;
        N1Temp = regexprep(Name{2}(1+length(Name{1}):end),'-','_');
        N2Temp = regexprep(Name{3}(2+length(Name{2}):end),'-','_');
        Data.(N1Temp).(N2Temp) =  hdf5read(hinfo.GroupHierarchy.Groups(I1).Datasets(I2));
    end
end