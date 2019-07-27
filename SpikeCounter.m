function OUT = SpikeCounter(SPEC,Options,THRES)

if nargin<2
    Options=optimset;
    THRES=25;
elseif nargin<3
    THRES=25;
end

if(~any(isnan(SPEC)))
    LP_GAUSS=exp(-(-20:20).^2/2/sqrt(250));
    LP_GAUSS=LP_GAUSS/sum(LP_GAUSS);
    SPECLP=conv(SPEC,LP_GAUSS,'same');
    DIFFSPEC=diff(SPECLP);
    NODE=(find(DIFFSPEC(1:(end-1)).*DIFFSPEC(2:end)<0))+1;
    PEAK=(find((DIFFSPEC(1:(end-1))>0)&(DIFFSPEC(1:(end-1)).*DIFFSPEC(2:end)<0)))+1;
    VALLEY=(find((DIFFSPEC(1:(end-1))<0)&(DIFFSPEC(1:(end-1)).*DIFFSPEC(2:end)<0)))+1;
    
    MAX=max(SPECLP);
    THRESHOLD=MAX/THRES;
    
    REALSPIKES=find(SPECLP(PEAK)>THRESHOLD);
    
    LOC=PEAK(REALSPIKES);
    AMP=SPECLP(LOC);
    SIGMA=ones(size(LOC))*20;
    try
        clear PARM
    end
    PARM(3:3:(3*length(LOC)))=SIGMA;
    PARM(1:3:end)=AMP;
    PARM(2:3:end)=LOC;

    [FitParameters,FitFunction]=Fit_MGauss(SPECLP.', PARM, Options);
    
    OUT.Spectrum=SPEC;
    OUT.Spectrum_Lowpass=SPECLP;
    OUT.FitParameters=FitParameters;
    OUT.FitFunction=FitFunction;
    OUT.Intensities=sort(PARM(1:3:end).*PARM(3:3:end),'descend');
    OUT.IntensitiesFrac=OUT.Intensities/sum(OUT.Intensities);
    OUT.CumulativeSumInt=cumsum(OUT.IntensitiesFrac);
    OUT.Spikes90=find(OUT.CumulativeSumInt>0.9,1,'first');
    OUT.Spikes95=find(OUT.CumulativeSumInt>0.95,1,'first');
    OUT.Spikes85=find(OUT.CumulativeSumInt>0.85,1,'first');
else
    OUT.Spectrum=SPEC;
    OUT.Spectrum_Lowpass=SPEC;
    OUT.FitParameters=NaN;
    OUT.FitFunction=SPEC;
    OUT.Intensities=NaN;
    OUT.IntensitiesFrac=NaN;
    OUT.CumulativeSumInt=NaN;
    OUT.Spikes90=NaN;
    OUT.Spikes95=NaN;
    OUT.Spikes85=NaN;
end
