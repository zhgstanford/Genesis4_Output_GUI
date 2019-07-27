SLICE=1415;
fid = H5F.open('scan_taper_U3_67.out.h5'); 

tic
SLICES=zeros(301,301,2944);
INT=zeros(1,2944);
for II=1:1:2944
    dset_id1 = H5D.open(fid,['/slice0',num2str(II,'%.5d'),'/field-imag']);
    dset_id2 = H5D.open(fid,['/slice0',num2str(II,'%.5d'),'/field-real']);
    REAL = reshape(H5D.read(dset_id2),[301,301]);
    IMAG = reshape(H5D.read(dset_id1),[301,301]);
    POW=REAL.^2+IMAG.^2;
    SLICES(:,:,II)=REAL+1i*IMAG;
    INT(II)=sum(sum(REAL.^2 + IMAG.^2));
    H5D.close(dset_id1);
    H5D.close(dset_id2);
end
toc


H5F.close(fid);
