function OUT=Fun_MGauss(VLEN,PARM)

OUT=zeros(1,VLEN);
for II=1:(length(PARM)/3)
    OUT=OUT+PARM(3*(II-1)+1)*exp(-((1:VLEN) - PARM(3*(II-1)+2)).^2/2/(PARM(3*(II-1)+3)^2));
end
