function [OUT,Fit]=Fit_MGauss(TARGET, PARM0, Options)

OUT = fminsearch(@(PARM) MGauss_Err(TARGET,PARM),PARM0, Options);
Fit = Fun_MGauss(length(TARGET),OUT);
