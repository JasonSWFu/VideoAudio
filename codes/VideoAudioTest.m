function varargout = VideoAudioTest(varargin)


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VideoAudioTest_OpeningFcn, ...
                   'gui_OutputFcn',  @VideoAudioTest_OutputFcn, ...
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

% --- Executes just before VideoAudioTest is made visible.
function VideoAudioTest_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


LogoImage2 = importdata('123.jpg');
axes(handles.axes2);
image(LogoImage2);
axis off

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = VideoAudioTest_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in SpeechInput.
function SpeechInput_Callback(hObject, eventdata, handles)
CurrPath = pwd;
Datadir = uigetdir;
cd (Datadir)
Total = dir ;
cd(CurrPath)
num =size(Total,1);
List = [];
Floder = [];
for i=1:num
    if Total(i).isdir
        temp   = strcat (Datadir , '\');
        temp   = strcat (temp , Total(i).name);
        Floder = strvcat (Floder , temp);
        List   = strvcat (List, Total(i).name);
    end
end
List   = List(3:end,:);
Floder = Floder(3:end, :); 
[FoldNum, CC] = size(List);
PerNum = str2double (get(handles.PerNum,'String'));
set (handles.SpeechInput, 'UserData' ,Floder);      %Browser_UserData, Wave Dir
set (handles.MethodList, 'String'  ,List);
set (handles.MethodList, 'UserData',Datadir);           %SpeechData address in listbox userdata  
TotalNum = PerNum * FoldNum ;
AA = strcat('Total  ',num2str(TotalNum),' s');
set (handles.TestNum, 'String',AA);
set (handles.Texttype, 'enable', 'on');
set (handles.Del , 'enable', 'on');
set (handles.filmtype , 'enable', 'on');
set (handles.WordNum  , 'enable', 'on');
set (handles.run, 'enable' , 'on');


% --- Executes on selection change in Texttype.
function Texttype_Callback(hObject, eventdata, handles)
set (handles.ListInput, 'enable', 'on');

function Texttype_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in ListInput.
function ListInput_Callback(hObject, eventdata, handles)
Max_num_sentence=3000;
[FileName,PathName]      = uigetfile ('*.txt');
Currpath   = pwd;
cd (PathName)
Type = get (handles.Texttype, 'value');
DataList   = cell(Max_num_sentence,1);
%fileID = fopen(FileName,'r','n','Big5');

switch Type 
    case 2
        fileID = fopen(FileName,'r','n','Big5');

    case 3
        fileID = fopen(FileName,'r','n','UTF-8');
        
    case 4
        fileID = fopen(FileName,'r','n','US-ASCII');
end

tline = fgetl(fileID);
ind=1; DataList{ind}=tline; 
while ischar(tline)
    tline = fgetl(fileID);
    ind=ind+1; DataList{ind}=tline;
end
fclose(fileID);
DataList=DataList(1:ind-1);

cd (Currpath)
set (handles.ListInput, 'UserData', DataList); %BrowserList_UserData, Txt Dir
set (handles.WordNum  , 'enable', 'on');
%set (handles.filmtype, 'enable', 'on');

function filmtype_Callback(hObject, eventdata, handles)

%{
---
MP4
M4V
M0V
MPG
AVI
WMV
%}
set (handles.FilmInput, 'enable', 'on');

function filmtype_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in FilmInput.
function FilmInput_Callback(hObject, eventdata, handles)

CurrPath = pwd;
Datadir = uigetdir;
cd (Datadir)
filmtype = get (handles.filmtype, 'value'); 
totaltype = get (handles.filmtype, 'String'); 
type = strcat ('*.',totaltype{filmtype});
Total = dir (type);
cd(CurrPath)
num =size(Total,1);
List = [];
for i=1:num
    %if Total(i).isfile
        temp = strcat (Datadir, '\',Total(i).name); 

        List = strvcat (List, temp);
    %end
end
set (handles.FilmInput, 'UserData', List);
set (handles.filmtype, 'UserData' , Datadir);

set (handles.run, 'enable' , 'on');


function AnsText_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function AnsText_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Del_Callback(hObject, eventdata, handles)

DelNum = get(handles.MethodList, 'Value');
List   = get(handles.MethodList, 'String');
Floder = get(handles.SpeechInput, 'UserData');
num    = size(List,1);
if DelNum == 1
    NewList = List   (2:end,:);
    Floder  = Floder (2:end,:);
elseif DelNum == num
    set (handles.MethodList, 'Value',num-1);
    NewList = List  (1:end-1,:);
    Floder  = Floder(1:end-1,:);
else
    
    NewList =  strvcat(List(1:DelNum-1,:), List(DelNum+1:end,:));
    Floder  =  strvcat(Floder(1:DelNum-1,:), Floder(DelNum+1:end,:))
end

set (handles.MethodList, 'String', NewList);
set (handles.SpeechInput, 'UserData', Floder);
[FoldNum, CC] = size(NewList);
PerNum = str2double (get(handles.PerNum,'String'));
TotalNum = PerNum * FoldNum ;
AA = strcat('Total  ',num2str(TotalNum),' s');
set (handles.TestNum, 'String',AA);

function run_Callback(hObject, eventdata, handles)
SpeechList = get(handles.SpeechInput, 'UserData');     %  Speech dir
TextList   = get(handles.ListInput,   'UserData');     %  Text 
Filmtype   = get(handles.filmtype,   'Value'   );     %  Film address
MethodList = get(handles.MethodList,  'String'  );


Currpath = pwd;   
PerNum   = str2double(get(handles.PerNum, 'String'));
FolderNum= size (SpeechList,1);  
TotalNum = PerNum*FolderNum;
if Filmtype ==1
    Result   = zeros(3,FolderNum); % 1.Error Word 2. likeness 3.Faitage
else
    FolderNum = FolderNum*2;
    Result   = zeros(3,FolderNum);
    num = size (MethodList,1);
    Temp = [];
    for i = 1:num
        L1 = strcat (MethodList(i,:), '-NoViedo'  );
        L2 = strcat (MethodList(i,:), '-  Viedo');
        Temp = strvcat(Temp , L1 , L2);
        
    end
    TotalNum = TotalNum*2;
    AA = strcat('Total  ',num2str(TotalNum),' s');
    set (handles.TestNum, 'String',AA);
    MethodList = Temp ;
end


%Result   = zeros(1,FolderNum) ;  
B        = randperm(TotalNum);        % 設定 隨機數字為 1-TotalNum
C        = randperm(TotalNum);
WavList  = {};
WavFile  = {};
FilmList = {};

%Result_L = zeros(PerNum,FolderNum);
%Result_F = zeros(PerNum,FolderNum);
if isempty (SpeechList) |  isempty (TextList)
    
    H = msgbox('Please check Inputs of Speech and Text !', 'No Input');


elseif Filmtype ==1
    
    for i=1:FolderNum
        cd (SpeechList(i, :))
            for j = 1:PerNum
                

                SubWav = dir('*.wav') ;    % Define only search .wav
                temp = strcat (SpeechList(i,:), '\');
                WavList{B(j+(i-1)*PerNum)} = strcat (temp, SubWav(B(j+(i-1)*PerNum)).name);
                WavFile{B(j+(i-1)*PerNum)} = SpeechList(i, :);
            end
            cd (Currpath)
    end
    
else 
    for i = 1:FolderNum
        id = ceil(i/2);
        op = mod (i,2);
        cd (SpeechList(id, :))
        for j = 1:PerNum
            SubWav = dir('*.wav') ;    % Define only search .wav
            temp = strcat (SpeechList(id,:), '\');
            if op == 1;
                WavList{B(j+(i-1)*PerNum)} = strcat (temp, SubWav(B(j+(i-1)*PerNum)).name);
                WavFile{B(j+(i-1)*PerNum)} = SpeechList(id, :);
            else
                WavList{B(j+(i-1)*PerNum)} = strcat ('-',temp, SubWav(B(j+(i-1)*PerNum)).name);
                WavFile{B(j+(i-1)*PerNum)} = SpeechList(id, :);
            end
        end
        cd (Currpath)
    end
    
    
    
end
set (handles.AnsText,  'String'   , '     ');
set (handles.run  ,    'UserData' , WavList);  %測試檔案的順序
set (handles.Next ,    'enable'   , 'on'   );
set (handles.Next ,    'String'   , 'Start Test' );
set (handles.Del  ,    'UserData' , WavFile);  %測試檔案的資料夾順緒
%set (handles.Texttype , 'UserData' , B);
set (handles.PerNum ,  'UserData' , C);
set (handles.ErrorNum, 'UserData' , Result);
set (handles.WordNum  ,'enable'   , 'on');
set (handles.Score1   ,'String'   , MethodList)


function Replay_Callback(hObject, eventdata, handles)
Currsound = get (handles. Replay , 'UserData');
fs        = get (handles. Next   , 'UserData');
V         = get (handles. WordNum, 'UserData');
Filmadr  = get (handles.filmtype , 'UserData');

Currsound = Currsound/max(Currsound); 

if isempty (V)
    

    sound(Currsound, fs);
    
else
    V =  VideoReader( V ); 
    VW = V.Width/2;
    VH = V.Heigh/2;
    mov = struct ('cdata', zeros (VH,VW,3,'uint8'), 'colormap', []);
    k = 1;
    h = waitbar (0 , 'Viedo is loading !');
    while hasFrame(V)
        temp = readFrame(V);
        mov(k).cdata = imresize(temp,0.5);
        k = k+1;
    end
    close (h);
    %            sound(Currsound,fs)
    hf = figure;
    set (hf, 'position', [80 80 VW VH]);
    sound(Currsound,fs)
    movie (hf,mov,1,V.FrameRate);
    
    close (hf)
    
end
    

% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
CurrPath = pwd;
FileList = get(handles.run  , 'UserData');
PerNum   = str2double(get(handles.PerNum, 'String'));
TotalNum = size (FileList,2); 
%TotalNum = PerNum*FolderNum;
%TotalNum = PerNum*FolderNum;

WavList  = get (handles.run      , 'UserData');  % 播放檔案
DirList  = get (handles.Del      , 'UserData');  % 播放路徑
C        = get (handles.PerNum   , 'UserData');  % 播放順緒
TextList = get (handles.ListInput, 'UserData');  % 文字檔
FilmList = get (handles.FilmInput, 'UserData');  % 影片檔
filmtype = get (handles.filmtype , 'Value'   );
Filmadr  = get (handles.filmtype , 'UserData');
FileDir  = get (handles.MethodList, 'UserData');  %
MethList = get (handles.MethodList, 'String' );
ErrorNum = get (handles.ErrorNum , 'Value'   );  %錯字數
Likeless = get (handles.Likeless , 'Value'   );  % 喜好度
Fatigue  = get (handles.Fatigue  , 'Value'   );  % 疲勞度
WordNum  = get (handles.WordNum  , 'String'  );  %單句字數
Result   = get (handles.ErrorNum , 'UserData');
TestOption = get (handles.popupmenu1, 'Value'); 
VocoderSet = get (handles.popupmenu1, 'UserData');


%if ~isempty (FilmList)  %% 判斷是否AV-Test
if strcmp (get(handles.Next, 'String'),'Start Test'); % 判斷是否為測試起始
    
    num = C(1);
    cd (DirList{num})
    
    if strcmp (WavList{num}(1), '-')
        [Currsound,fs] = audioread (WavList{num}(2:end));
    else
        [Currsound,fs] = audioread (WavList{num});
    end
    %sound(Currsound,fs)
        
    cd (CurrPath)
    if TestOption == 2;
        [Currsound,fs] = eassim_CR (Currsound,fs, str2double(VocoderSet{1}), str2double(VocoderSet{2}),...
            str2double(VocoderSet{3}),VocoderSet{4}, VocoderSet{5},...
            str2double(VocoderSet{6}));       
    end
    if (filmtype ~=1)  &  (~strcmp (WavList{num}(1), '-'))  %判斷是否為AV-test
        cd(Filmadr)
        CurrFilm = FilmList(num,:);
        V = VideoReader(FilmList(num,:));   
        VW = V.Width/2;
        VH = V.Heigh/2;
        mov = struct ('cdata', zeros (VH,VW,3,'uint8'), 'colormap', []);
        %           mov = struct ('cdata', zeros (VH,VW,3,'uint8'), 'colormap', []);
        k = 1;
        h = waitbar (0 , 'Viedo is loading !');
        while hasFrame(V)
            temp = readFrame(V);
            mov(k).cdata = imresize(temp, 0.5);
            %mov(k).cdata = temp;
            k = k+1;
        end
        close (h);
        %            sound(Currsound,fs)
        hf = figure;
        set (hf, 'position', [80 80 VW VH]);
        Currsound = Currsound/max(Currsound); 
        sound(Currsound,fs)
        movie (hf,mov,1,V.FrameRate);
        close (hf)
        cd (CurrPath)
        set (handles.AnsText, 'ForegroundColor',[1 1 1])
        set (handles.WordNum, 'UserData', CurrFilm );
    elseif strcmp (WavList{num}(1), '-')
        Currsound = Currsound/max(Currsound); 
        sound(Currsound,fs)
        set (handles.AnsText, 'ForegroundColor',[1 1 1])
        set (handles.WordNum, 'UserData', [] );
    else
        Currsound = Currsound/max(Currsound); 
        sound(Currsound,fs)
        set (handles.AnsText, 'ForegroundColor',[0 0 0])
        set (handles.WordNum, 'UserData', [] );
        
    end
    set (handles.AnsText, 'String' , TextList{num});   %不顯示答案
    set (handles.Replay , 'UserData', Currsound); % Replay_UserData, Sound
    set (handles.AnsText, 'UserData', fs);        % Next_UserData  , fs
    set (handles.Next, 'UserData', fs);
    set (handles.Next, 'String', '1');
    set (handles.Replay, 'enable', 'on');
    set (handles.WordNum  , 'enable', 'off');
else
    i = str2double(get(handles.Next, 'String')) + 1;
    if i > TotalNum;
        set (handles.Next, 'String', '開始');
        %計分
        DirLen = size(FileDir,2);
        A= DirList{C(i-1)}(DirLen+2:end);
        Type = strmatch (A,  MethList);
        if (filmtype~=1) & strcmp (WavList{C(i-1)}(1), '-')
            Type=Type*2-1;
            A=[A '-NoVedio'];            
        elseif (filmtype~=1)
            Type=Type*2;
            A=[A '-Vedio'];        
        end
%         if FilmList~=1,Type=Type*2;end
%         if strcmp (WavList{C(i-1)}(1), '-')
%             A=[A '-NoVedio'];
%             Type=Type-1;
%         else
%             A=[A '-Vedio'];
%         end
        set (handles.Lastquestion, 'String', A);
        Result(1,Type) = Result(1,Type)+ErrorNum-1;
        Result(2,Type) = Result(2,Type)+Likeless;
        Result(3,Type) = Result(3,Type)+Fatigue;
        lastresult = [ErrorNum-1 , Likeless, Fatigue];
        set (handles.LastResult, 'String', lastresult);
        % 畫圖
        TestList=get(handles.Score1, 'String');
        X = 1:size(TestList,1);
        axes(handles.axes1);
        bar(X, Result(1,:));
        msgbox (num2str(Result'))
        xlswrite('Result.xlsx',Result, get(handles.edit3,'String'))
    else
        %% 計分
        DirLen = size(FileDir,2);
        A= DirList{C(i-1)}(DirLen+2:end);
        Type = strmatch (A,  MethList);
        if (filmtype~=1) & strcmp (WavList{C(i-1)}(1), '-')
            Type=Type*2-1;
            A=[A '-NoVedio'];            
        elseif (filmtype~=1)
            Type=Type*2;
            A=[A '-Vedio'];        
        end
%         if FilmList~=1,Type=Type*2;end
%         if strcmp (WavList{C(i-1)}(1), '-')
%             A=[A '-NoVedio'];
%             Type=Type-1;
%         else
%             A=[A '-Vedio'];
%         end
        set (handles.Lastquestion, 'String', A);
        Result(1,Type) = Result(1,Type)+ErrorNum-1;   % error word sum
        Result(2,Type) = Result(2,Type)+Likeless;     % likeness sum
        Result(3,Type) = Result(3,Type)+Fatigue;      % fatigue  sum
        lastresult = [ErrorNum-1 , Likeless, Fatigue];
        set (handles.LastResult, 'String', lastresult);
        set (handles.ErrorNum, 'UserData', Result);            
        set (handles.Score2  , 'String'  , Result(1,:));
        set (handles.Score3  , 'String'  , Result(2,:));
        set (handles.Score4  , 'String'  , Result(3,:));
        set (handles.Next, 'String', i);
        set (handles.Replay, 'enable', 'on');
        %%播下一題的聲音和影片               
        num = C(i);
        Curr= pwd;
        cd (DirList{num})
        if strcmp (WavList{num}(1), '-')
            [Currsound,fs] = audioread (WavList{num}(2:end));
        else
            [Currsound,fs] = audioread (WavList{num});
        end
        
        cd (Curr)
        if TestOption == 2;
            [Currsound,fs] = eassim_CR (Currsound,fs, str2double(VocoderSet{1}), str2double(VocoderSet{2}),...
                str2double(VocoderSet{3}),VocoderSet{4}, VocoderSet{5},...
                str2double(VocoderSet{6}));
        end
        if  (filmtype ~=1)  &  ~strcmp (WavList{num}(1), '-')

            cd (CurrPath)
            cd(Filmadr)
            CurrFilm = FilmList(num,:);
            V = VideoReader(FilmList(num,:));   
            VW = V.Width/2;
            VH = V.Heigh/2;
            mov = struct ('cdata', zeros (VH,VW,3,'uint8'), 'colormap', []);
            k = 1;
            h = waitbar (0  , 'Viedo is loading');        
            while hasFrame(V)
                temp = readFrame(V);
                mov(k).cdata = imresize(temp,0.5);           
                k = k+1;
            end
            close (h)
            %sound(Currsound,fs)
            hf = figure;
            set (hf, 'position', [80 80 VW VH]);
            Currsound = Currsound/max(Currsound); 
            sound(Currsound,fs)
            movie (hf,mov,1,V.FrameRate);
            close (hf)
            cd (CurrPath)        
            set (handles.AnsText, 'ForegroundColor',[1 1 1])
            set (handles.WordNum, 'UserData',CurrFilm );
            
        elseif strcmp (WavList{num}(1), '-')
            Currsound = Currsound/max(Currsound); 
            sound(Currsound,fs)
            set (handles.AnsText, 'ForegroundColor',[1 1 1])
            set (handles.WordNum, 'UserData', [] );
        else
            Currsound = Currsound/max(Currsound); 
            sound(Currsound,fs)
            set (handles.AnsText, 'ForegroundColor',[0 0 0])
            set (handles.WordNum, 'UserData', [] );
        end
        set (handles.AnsText, 'String' , TextList{num});
        set (handles.Replay, 'UserData', Currsound); % Replay_UserData, Sound
        set (handles.Next,   'UserData', fs);        % Next_UserData  , fs
    end
end
    
    
   
    
    %{
    else
    if strcmp (get(handles.Next, 'String'),'Start Test');
        num = C(1);
        cd (DirList{num})
        [Currsound,fs] = audioread (WavList{num});
        sound(Currsound,fs)
        % set (handles.AnsText, 'String' , TextList{num});   %不顯示答案
        set (handles.Replay , 'UserData', Currsound); % Replay_UserData, Sound
        set (handles.AnsText, 'UserData', fs);        % Next_UserData  , fs
        set (handles.Next, 'String', '1');
        set (handles.Replay, 'enable', 'on');
    else
        i = str2double(get(handles.Next, 'String')) + 1;
        num = C(i);
        cd (DirList{num})
        set (handles.AnsText, 'String' , TextList{num});
        [Currsound,fs] = audioread (WavList{num});
        %sound(Currsound,fs)
        cd (CurrPath)
        set (handles.Replay, 'UserData', Currsound); % Replay_UserData, Sound
        set (handles.Next,   'UserData', fs);        % Next_UserData  , fs
        if i == TotalNum;
            set (handles.run, 'String', '開始');
        else
            set (handles.Next, 'String', i);
            set (handles.Replay, 'enable', 'on');
        end
    end
end
    %}
    
function PerNum_Callback(hObject, eventdata, handles)
List   = get(handles.MethodList, 'String');
if ~isempty(List)
    PerNum = str2double(get(handles.PerNum,'String'));
    [FoldNum, CC] = size(List);
    TotalNum = PerNum * FoldNum;
    if FoldNum == 0
        set (handles.TestNum, 'String','Total 0 s');
    else
        AA = strcat('Total  ',num2str(TotalNum),' s');
        set (handles.TestNum, 'String',AA);
    end
else
     set (handles.TestNum, 'String','Total 0 s');
    return
end



% --- Executes during object creation, after setting all properties.
function PerNum_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenu1_Callback(hObject, eventdata, handles)
% Enhancement test 
% Vocoder test
Vocoderitem = {'ha_cutoff', 'r_nchn', 'enve_cutoff' , 'flag ( HA+CI or HA or CI)' ,...
              'vocoder_type (NV or TV)', 'CR'};
dlg_title   = 'Setup';
num_line    =  1;
default     = {'500', '4' , '400' , 'CI' , 'TV' , '1'};
VocoderSet  = inputdlg(Vocoderitem , dlg_title , num_line , default);
set (handles.popupmenu1 , 'UserData', VocoderSet)





function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MethodList.
function MethodList_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function MethodList_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)



function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WordNum_Callback(hObject, eventdata, handles)

WordNum = str2num(get (handles.WordNum, 'String'))
A = num2str([0:WordNum]');
set (handles.ErrorNum, 'String' , A);


% --- Executes during object creation, after setting all properties.
function WordNum_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ErrorNum.
function ErrorNum_Callback(hObject, eventdata, handles)




% --- Executes during object creation, after setting all properties.
function ErrorNum_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Likeless.
function Likeless_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Likeless_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Fatigue.
function Fatigue_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Fatigue_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
