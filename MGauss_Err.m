function OUT=MGauss_Err(TARGET,PARM)

OUT=(TARGET - Fun_MGauss(length(TARGET),PARM));
OUT=sum(OUT.^2);