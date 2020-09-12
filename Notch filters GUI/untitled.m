function varargout = untitled(varargin)
global ind CENTERS RADII ORDER;
ind = 0;
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 28-Dec-2012 23:45:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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

% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global Spectrum Picture hp M N;
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName, PathName] = uigetfile({'*.bmp'; '*.gif'; '*.hdf'; '*.jpg'; '*.jpeg'; '*.pbm'; '*.pgm'; '*.png'; '*.pnm'; '*.ppm'; '*.ras'; '*.tif'; '*.tiff'});
if FileName~=0
    FullName = [PathName FileName];
    Picture = imread(FullName);
    axes(handles.axes1); %choose the first axes
    imshow(Picture);
end
[M, N]  = size(Picture);
F = fft2(Picture); %2d Fourier transform
axes(handles.axes2); %choose the second axes
Spectrum = fftshift(log(1+abs(F)));
Im = imshow(Spectrum,[]); %obtain a spectrum in which pulses are visible
%center the spectrum with fftshift
set(Im,'ButtonDownFcn',@axes2_ButtonDownFcn)
hp = impixelinfo;
set(hp,'Visible','Off'); %Sets an invisible pixel coordinate bar


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles) %Funckija, kas saliek masîvâ izvelçtas punktu
%koordinâtas no spektra attçla, kas filtram bûs centru masîvs
try
global Spectrum hp x y CENTERS ind;
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
childHandles=get(hp,'Children');
Pixel = get(childHandles(1),'String'); %Obtain pixel coordinates and values in the form: (y, x) pixel_value
isX = 0;
x = '';
y = '';
ind = ind+1; %Creates an array element index
for i=2:length(Pixel)
    if Pixel(i)==',' %If a comma is read, it means that the value of x is over
             isX = 1;         
    end
    
    if Pixel(i)~=',' && isX == 0 %Until the comma is reached
         
        y = strcat(y,Pixel(i)); %select y coordinate
        
    end
    
    if isX == 1 && Pixel(i)~=',' %read after comma
        
        if Pixel(i) == ')' %If the symbol ) is reached, it means that the value of y is over
            break;
        end
        x = strcat(x,Pixel(i)); %select x coordinate
        
    end
    
end
%Creates a center coordinate matrix
CENTERS(ind,1) = str2num(x);
CENTERS(ind,2) = str2num(y);

catch
    msgbox('Please open the image to filter!','The image to filter is not open!','warn');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) %Notch filter
global M N CENTERS RADII ORDER Picture g;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RADII = get(handles.edit1,'String'); %Radius value
status1 = 0;
if isempty(RADII) %If radiuss is not entered
    msgbox('Please enter a radius!','No radius entered!','warn');
else
    [RADII, status1] = str2num(RADII); %Checks if the radius is a number
    if status1 == 0
        msgbox('Please enter a valid radius!','Invalid radius entered!','warn');
    end
end

ORDER = get(handles.edit2,'String'); %Gets the value of the filter order
status2 = 0;
if isempty(ORDER) %If no filter order is entered
    msgbox('Please enter a filter order!','No filter order entered!','warn');
else
    [ORDER, status2] = str2num(ORDER); %Checks if the filter order is a number
    if status2 == 0
        msgbox('Please enter a valid filter order!','Wrong order entered!','warn');
    end
end

if isempty(CENTERS)==0 && isempty(Picture)==0
    if isempty(RADII)==0 && isempty(ORDER)==0 && status1==1 && status2==1
        Hnr = notchfilter('reject', M, N, CENTERS, RADII, ORDER); %Notch-stop filter
        q = dftfilt(Picture,Hnr); %filters image f with a notch-stop filter
        g = gscale(q); %Intensity scaling to 8-bit intensities (all intensities in the range [0 255])
        axes(handles.axes3); %choose the third axes
        imshow(g,[]);
        axes(handles.axes6); %choose the sixth axes
        %With a notch-pass filter obtain a noise image
        Hnp = 1 - Hnr; %Obtain a notch-pass filter
        qn = dftfilt(Picture, Hnp); %Filters the image f with a notch-pass filter
        imshow(qn,[]);
    end
else
     msgbox('Please open an image or mark centers!','Incorrect / no center or no image open!','warn');
end


function edit1_Callback(hObject, eventdata, handles) %the function for collecting the value (radius) of the first edit window
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles) %the function of collecting the value (filter order) of the second edit window
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles) %Function for saving a filtered image

global g
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(g)==0
[FileName, PathName] = uiputfile({'*.bmp'; '*.gif'; '*.hdf'; '*.jpg'; '*.jpeg'; '*.pbm'; '*.pgm'; '*.png'; '*.pnm'; '*.ppm'; '*.ras'; '*.tif'; '*.tiff'}, 'Save As');
if FileName~=0
   [path,name,ext]=fileparts(FileName);
   imwrite(g, [PathName FileName],ext(2:length(ext)));
end
else
    msgbox('Please filter the image for saving!','No filtered image!','warn');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) %function that opens an image for image difference

global g
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(g)==0
[FileName, PathName] = uigetfile({'*.bmp'; '*.gif'; '*.hdf'; '*.jpg'; '*.jpeg'; '*.pbm'; '*.pgm'; '*.png'; '*.pnm'; '*.ppm'; '*.ras'; '*.tif'; '*.tiff'});
if FileName~=0
    FullName = [PathName FileName];
    g2 = imread(FullName);
    axes(handles.axes5); %choose the fifth axes
    d = imsubtract(g,g2); %image difference
    imshow(d,[]);
end
else
    msgbox('Please filter the image for comparison!','No filtered image!','warn');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles) %clean the centers
global CENTERS ind;
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CENTERS = [];
ind = 0;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles) %A function that calls when an application is closed
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles) %A function that turns on zooming
global Spectrum
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(Spectrum)==0
axes(handles.axes2); %choose the second axes
zoom on
else
    msgbox('Please open the image to filter!','No image open!','warn');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles) %A function that turns off zooming
global Spectrum
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(Spectrum)==0
axes(handles.axes2); %choose the second axes
zoom off
else
    msgbox('Please open the image to filter!','No image open!','warn');
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles) %A function that returns the spectrum to its original size
global Spectrum
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(Spectrum)==0
axes(handles.axes2); %choose the second axes
zoom out
else
    msgbox('Please open the image to filter!','No image open!','warn');
end
