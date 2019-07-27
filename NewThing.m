function varargout = NewThing(varargin)
% NEWTHING MATLAB code for NewThing.fig
%      NEWTHING, by itself, creates a new NEWTHING or raises the existing
%      singleton*.
%
%      H = NEWTHING returns the handle to a new NEWTHING or the handle to
%      the existing singleton*.
%
%      NEWTHING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWTHING.M with the given input arguments.
%
%      NEWTHING('Property','Value',...) creates a new NEWTHING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewThing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewThing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewThing

% Last Modified by GUIDE v2.5 04-Feb-2019 11:44:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewThing_OpeningFcn, ...
                   'gui_OutputFcn',  @NewThing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before NewThing is made visible.
function NewThing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewThing (see VARARGIN)

% Choose default command line output for NewThing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NewThing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NewThing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Filename_Callback(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Filename as text
%        str2double(get(hObject,'String')) returns contents of Filename as a double


% --- Executes during object creation, after setting all properties.
function Filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
update_axis(handles)


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
FileName=get(handles.Filename,'string');
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

handles.Data=Data;
Blen_fs=Data.Global.slen/3/10^8;
handles.BLen_fs=Blen_fs;
dt_fs=handles.BLen_fs/length(Data.Beam.alphax);
handles.dt_fs=dt_fs;
time= (1:length(Data.Beam.alphax))*handles.dt_fs;
handles.time=(1:length(Data.Beam.alphax))*handles.dt_fs;
time_fs=10^15*(1:length(Data.Beam.alphax))*handles.dt_fs;
handles.time_fs=time_fs;
z=Data.Lattice.z;
handles.z=z; [SA,SB]=size(handles.Data.Beam.xposition);
handles.SimSteps=SB;
guidata(hObject, handles);
%save TEMP Data Blen_fs dt_fs time time_fs z
update_axis(handles)
Limits_k = [0.95*min(Data.Lattice.aw(Data.Lattice.aw>0.5)*sqrt(2)),1.05*max(Data.Lattice.aw(Data.Lattice.aw>0.5)*sqrt(2))] ;
set(handles.edit2,'string',['[',num2str(Limits_k(1),4),',',num2str(Limits_k(2),4),']']);
set(handles.slider1,'SliderStep',[1/SB,0.1]);

function update_axis(handles)
area(handles.axes1, handles.z, handles.Data.Lattice.aw*sqrt(2));
Limits=str2num(get(handles.edit2,'string')); ylim(handles.axes1,Limits);
normalizzazione=handles.Data.Beam.current/(sum(handles.Data.Beam.current));
Xpos=normalizzazione.'*handles.Data.Beam.xposition*10^6;
Ypos=normalizzazione.'*handles.Data.Beam.yposition*10^6;
cla(handles.ORBITS);
plot(handles.ORBITS,handles.z,Xpos(2:end),'k','linewidth',2); hold(handles.ORBITS,'on'); plot(handles.ORBITS,handles.z,Ypos(2:end),'r','linewidth',2);
xlim(handles.ORBITS,[min(handles.z),max(handles.z)])
xlim(handles.axes1,[min(handles.z),max(handles.z)])
Image=make_orbit_plot(handles.Data.Beam.xposition*10^6,[5,20,75,150,500],1);
image(handles.z,handles.time_fs,Image,'parent',handles.axes9); set(handles.axes9,'ydir','normal')
Image=make_orbit_plot(handles.Data.Beam.yposition*10^6,[5,20,75,150,500],1);
image(handles.z,handles.time_fs,Image,'parent',handles.axes10); set(handles.axes10,'ydir','normal')
Image=make_orbit_plot((ones(2,1)*linspace(0,750,1000)).',[5,20,75,150,500],1);
image(linspace(0,1,10),linspace(0,750,10),Image,'parent',handles.axes11); set(handles.axes11,'ydir','normal')
plot(handles.axes14, handles.Data.Beam.current, handles.time_fs);
ylim(handles.axes14,[min(handles.time_fs),max(handles.time_fs)])


function out=f_red(val,s,levels)
DL=diff(levels);
if(s)
   val=abs(val);
   out = 1.*(val<levels(1)) + 1.*(val>=levels(1)).*(val<levels(2)) + 1*(val>=levels(1)).*(val<levels(3)) + (1-(val-levels(3))/DL(3)).*(val>=levels(3)).*(val<levels(4)) + 0*(val>=levels(4)).*(val<levels(5)) + 0*(val>=levels(5)) ; 
else
    
end

function out=f_blue(val,s,levels)
DL=diff(levels);
if(s)
    val=abs(val);
   out = 1.*(val<levels(1)) + (1-(val-levels(1))/DL(1)).*(val>=levels(1)).*(val<levels(2)) + 0*(val>=levels(2)).*(val<levels(3)) + 0*(val>=levels(3)).*(val<levels(4)) + ( 1-(val-levels(4))/DL(4)).*(val>=levels(4)).*(val<levels(5))  + 0*(val>=levels(5)) ; 
else
    
end

function out=f_green(val,s,levels)
DL=diff(levels);
if(s)
    val=abs(val);
   out = 1.*(val<levels(1)) + 1.*(val>=levels(1)).*(val<levels(2)) + (1-(val-levels(2))/DL(2)).*(val>=levels(2)).*(val<levels(3)) + ((val-levels(3))/DL(3)).*(val>=levels(3)).*(val<levels(4)) + 0*(val>=levels(4)).*(val<levels(5))  + 0*(val>=levels(5)) ;
else
    
end

function Matrix=make_orbit_plot(Data,Levels,Symmetric)
Matrix=zeros(size(Data,1),size(Data,2),3);
Matrix(:,:,1)=f_red(Data,Symmetric,Levels); Matrix(:,:,2)=f_green(Data,Symmetric,Levels); Matrix(:,:,3)=f_blue(Data,Symmetric,Levels);
Matrix(:,:,2)=f_green(Data,Symmetric,Levels); Matrix(:,:,2)=f_green(Data,Symmetric,Levels); Matrix(:,:,3)=f_blue(Data,Symmetric,Levels);
Matrix(:,:,3)=f_blue(Data,Symmetric,Levels); Matrix(:,:,2)=f_green(Data,Symmetric,Levels); Matrix(:,:,3)=f_blue(Data,Symmetric,Levels);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
VAL=get(handles.slider1,'value');
VAL2=round(VAL*handles.SimSteps);
if(VAL2<1)
    VAL2=1;
elseif(VAL2>handles.SimSteps)
    VAL2=handles.SimSteps;
end
set(handles.text1,'string',num2str(VAL2));
set(handles.edit5,'string',num2str(handles.z(VAL2)));
plot(handles.axes12,handles.time_fs,handles.Data.Field.power(:,VAL2));

xlim(handles.axes12,[min(handles.time_fs),max(handles.time_fs)]);

Image=make_orbit_plot(handles.Data.Beam.xposition(:,VAL2).'*10^6,[5,20,75,150,500],1);
image(handles.time_fs,handles.z(VAL2),Image,'parent',handles.axes15); set(handles.axes15,'ydir','normal')
Image=make_orbit_plot(handles.Data.Beam.yposition(:,VAL2).'*10^6,[5,20,75,150,500],1);
image(handles.time_fs,handles.z(VAL2),Image,'parent',handles.axes16); set(handles.axes16,'ydir','normal')
set(handles.axes15,'YTick',handles.z(VAL2)); set(handles.axes16,'YTick',handles.z(VAL2));
ZeroPad=zeros(30000,1);
ZeroPad(15000 + ( - round(length(handles.Data.Field.power(:,VAL2))/2):(-round(length(handles.Data.Field.power(:,VAL2))/2) + length(handles.Data.Field.power(:,VAL2)) -1 ))) = sqrt(handles.Data.Field.intensity_farfield(:,VAL2)).*exp(1i*handles.Data.Field.phase_farfield(:,VAL2));
Spectrum=circshift(fft(ZeroPad),15000);
%save TEMPX
PE=1240/(handles.Data.Global.lambdaref*10^9);
F=3*10^8/handles.Data.Global.lambdaref;
DelF=1/2/(30000*handles.dt_fs);
ENEREL=(-15000:14999)*DelF/F*PE;
plot(handles.axes13,ENEREL,abs(Spectrum).^2);

if(isfield(handles,'AllSpikes'))
    hold(handles.axes12,'on');
    plot(handles.axes12,handles.time_fs,handles.AllSpikes{VAL2}.FitFunction);
    hold(handles.axes12,'off');
end
% figure
% plot()

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
Ratio=str2num(get(handles.AreaRatio,'string'));
Options=optimset;
Options.MaxIter=200;
handles.MaxPower=max(handles.Data.Field.power);
handles.PowerInArea=ones(size(handles.Data.Field.power,2),1)*NaN;
handles.PulseEnergy=sum(handles.Data.Field.power,1)*handles.dt_fs;
handles.FWHM=ones(size(handles.Data.Field.power,2),1)*NaN;
handles.Duration_Area=ones(size(handles.Data.Field.power,2),1)*NaN;
GFIT=get(handles.checkbox2,'value');
if(GFIT)
    handles.Spikes85=ones(size(handles.Data.Field.power,2),1)*NaN;
    handles.Spikes90=ones(size(handles.Data.Field.power,2),1)*NaN;
    handles.Spikes95=ones(size(handles.Data.Field.power,2),1)*NaN;
end
for II=1:size(handles.Data.Field.power,2)
    [MV,MP]=max(handles.Data.Field.power(:,II));
    I1=find(handles.Data.Field.power(:,II)>MV/2,1,'first');
    I2=find(handles.Data.Field.power(:,II)>MV/2,1,'last');
    if(~isempty(I1) && ~isempty(I2))
        handles.FWHM(II)=(I2-I1)*handles.dt_fs*10^15;
    else
        handles.FWHM(II)=NaN;
    end
    [OUT,TopArea] = AreaLength(handles.Data.Field.power(:,II), Ratio);
    handles.Duration_Area(II)=OUT*handles.dt_fs*10^15;
    try
        handles.PowerInArea(II)=mean(handles.Data.Field.power(TopArea(1):TopArea(2),II));
    end
    if(GFIT)
        handles.AllSpikes{II} = SpikeCounter(handles.Data.Field.power(:,II),Options,25);
        if(~isempty(handles.AllSpikes{II}.Spikes85))
            handles.Spikes85(II)=handles.AllSpikes{II}.Spikes85;
        else
            handles.Spikes85(II)=NaN;
        end
        if(~isempty(handles.AllSpikes{II}.Spikes90))
            handles.Spikes90(II)=handles.AllSpikes{II}.Spikes90;
        else
            handles.Spikes90(II)=NaN;
        end
        if(~isempty(handles.AllSpikes{II}.Spikes95))
            handles.Spikes95(II)=handles.AllSpikes{II}.Spikes95;
        else
            handles.Spikes95(II)=NaN;
        end
        II
    end
end

guidata(hObject, handles);

% figure
% plot(handles.Duration_Area)
% figure
% plot(handles.FWHM)
% figure
% plot(handles.Spikes90)



function AreaRatio_Callback(hObject, eventdata, handles)
% hObject    handle to AreaRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AreaRatio as text
%        str2double(get(hObject,'String')) returns contents of AreaRatio as a double


% --- Executes during object creation, after setting all properties.
function AreaRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AreaRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
if(isfield(handles,'MaxPower'))
    if(length(handles.z) == length(handles.MaxPower))
        semilogy(handles.axes17, handles.z,handles.MaxPower);
    elseif(length(handles.z) < length(handles.MaxPower))
        semilogy(handles.axes17, handles.z,handles.MaxPower((end-length(handles.z)+1):end));
    else
        semilogy(handles.axes17, handles.z(1:length(handles.MaxPower)),handles.MaxPower);
    end    
end
    



% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
if(isfield(handles,'PowerInArea'))
    if(length(handles.z) == length(handles.PowerInArea))
        semilogy(handles.axes17, handles.z,handles.PowerInArea);
    elseif(length(handles.z) < length(handles.PowerInArea))
        semilogy(handles.axes17, handles.z,handles.PowerInArea((end-length(handles.z)+1):end));
    else
        semilogy(handles.axes17, handles.z(1:length(handles.PowerInArea)),handles.PowerInArea);
    end    
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
if(isfield(handles,'PowerInArea'))
    if(length(handles.z) == length(handles.Spikes85))
        plot(handles.axes17, handles.z,handles.Spikes85);
    elseif(length(handles.z) < length(handles.Spikes85))
        plot(handles.axes17, handles.z,handles.Spikes85((end-length(handles.z)+1):end));
    else
        plot(handles.axes17, handles.z(1:length(handles.Spikes85)),handles.Spikes85);
    end    
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
if(isfield(handles,'PowerInArea'))
    if(length(handles.z) == length(handles.Spikes90))
        plot(handles.axes17, handles.z,handles.Spikes90);
    elseif(length(handles.z) < length(handles.Spikes90))
        plot(handles.axes17, handles.z,handles.Spikes90((end-length(handles.z)+1):end));
    else
        plot(handles.axes17, handles.z(1:length(handles.Spikes90)),handles.Spikes90);
    end    
end


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
if(isfield(handles,'PowerInArea'))
    if(length(handles.z) == length(handles.Spikes95))
        plot(handles.axes17, handles.z,handles.Spikes95);
    elseif(length(handles.z) < length(handles.Spikes95))
        plot(handles.axes17, handles.z,handles.Spikes95((end-length(handles.z)+1):end));
    else
        plot(handles.axes17, handles.z(1:length(handles.Spikes95)),handles.Spikes95);
    end    
end



% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
if(isfield(handles,'PowerInArea'))
    if(length(handles.z) == length(handles.PulseEnergy))
        semilogy(handles.axes17, handles.z,handles.PulseEnergy);
    elseif(length(handles.z) < length(handles.PulseEnergy))
        semilogy(handles.axes17, handles.z,handles.PulseEnergy((end-length(handles.z)+1):end));
    else
        semilogy(handles.axes17, handles.z(1:length(handles.PulseEnergy)),handles.PulseEnergy);
    end    
end


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
if(isfield(handles,'PowerInArea'))
    if(length(handles.z) == length(handles.FWHM))
        plot(handles.axes17, handles.z,handles.FWHM);
    elseif(length(handles.z) < length(handles.FWHM))
        plot(handles.axes17, handles.z,handles.FWHM((end-length(handles.z)+1):end));
    else
        plot(handles.axes17, handles.z(1:length(handles.FWHM)),handles.FWHM);
    end    
end


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
if(isfield(handles,'PowerInArea'))
    if(length(handles.z) == length(handles.Duration_Area))
        plot(handles.axes17, handles.z,handles.Duration_Area);
    elseif(length(handles.z) < length(handles.Duration_Area))
        plot(handles.axes17, handles.z,handles.Duration_Area((end-length(handles.z)+1):end));
    else
        plot(handles.axes17, handles.z(1:length(handles.Duration_Area)),handles.Duration_Area);
    end    
end
