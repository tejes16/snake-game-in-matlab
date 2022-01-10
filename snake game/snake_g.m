function varargout = snake_g(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @snake_g_OpeningFcn, ...
                   'gui_OutputFcn',  @snake_g_OutputFcn, ...
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
function snake_g_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
axes(handles.axes1);
axis('off');
function varargout = snake_g_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
start_game_Callback(hObject, eventdata, handles);
function up_Callback(hObject, eventdata, handles)
global direction move_status;
if ~(direction==4)
    direction=2;
    move_status=1;
end
function right_Callback(hObject, eventdata, handles)
global direction move_status;
if ~(direction==3)
    direction=1;
    move_status=1;
end
function down_Callback(hObject, eventdata, handles)
global direction move_status;
if ~(direction==2)
    direction=4;
    move_status=1;
end
function left_Callback(hObject, eventdata, handles)
global direction move_status;
if ~(direction==1)
    direction=3;
    move_status=1;
end
function pause_Callback(hObject, eventdata, handles)
global move_status;
move_status=0;
function start_game_Callback(hObject, eventdata, handles)
global mat_r mat_g mat_b;
global direction; direction=2;
global points;points=0;
global move_status; move_status=0;
t=0.1;
locx=[50 50 50 50 50 50 50 50 50];
locy=[60 61 62 63 64 65 66 67 68];

mat_r=zeros(100,100);
mat_g=zeros(100,100);
mat_b=zeros(100,100);
update_snake(locx,locy);

while(1)
    pt_x=randperm(size(mat_r,1),1);
    pt_y=randperm(size(mat_r,1),1);
    if sum(locx==pt_x & locy==pt_y)==0
        break;
    end
end
mat_r(pt_x,pt_y)=255;
mat_g(pt_x,pt_y)=255;
mat_b(pt_x,pt_y)=255;


imshow(uint8(cat(3,mat_r,mat_g,mat_b)));
while(1)
    imshow(uint8(cat(3,mat_r,mat_g,mat_b)));
    pause(t);
    if(move_status)
        len=length(locx);
        for i=1:len
            mat_r(locx(i),locy(i))=0;
            mat_g(locx(i),locy(i))=0;
            mat_b(locx(i),locy(i))=0;
        end
        if sum((locx(1)==pt_x) & (locy(1)==pt_y))==1
            locx(2:len+1)=locx(1:len);
            locy(2:len+1)=locy(1:len);
            while(1)
                pt_x=randperm(size(mat_r,1),1);
                pt_y=randperm(size(mat_r,1),1);
                if sum(locx==pt_x & locy==pt_y)==0
                    break;
                end
            end
            mat_r(pt_x,pt_y)=255;
            mat_g(pt_x,pt_y)=255;
            mat_b(pt_x,pt_y)=255;
            points=points+1;
            set(handles.score,'String',num2str(points));
        else
            locx(2:len)=locx(1:len-1);
            locy(2:len)=locy(1:len-1);
        end
         if direction==1
             if locy(1)==100
                 locy(1)=1;
             else
                 locy(1)=locy(1)+1;
             end
         elseif direction==2
             if locx(1)==1
                 locx(1)=100;
             else 
                 locx(1)=locx(1)-1;
             end
         elseif direction==3
             if locy(1)==1
                 locy(1)=100;
             else
                 locy(1)=locy(1)-1;
             end
         elseif direction==4
             if locx(1)==100
                 locx(1)=1;
             else
                 locx(1)=locx(1)+1;
             end
         end
         if sum((locx(2:end)==locx(1)) & (locy(2:end)==locy(1)))
             mat_r(:,:)=255;
             mat_g(:,:)=0;
             mat_b(:,:)=0;
             imshow(uint8(cat(3,mat_r,mat_g,mat_b)));
             msgbox('Game over..!');
             break;
         end
         update_snake(locx,locy);
         if points==5
             t=0.08;
         elseif points==10
             t=0.05;
         elseif points==15
             t=0.03;
         elseif points==30
             t=0.01;
         elseif points==50
             t=0.008;
         end
    end
end
function end_game_Callback(hObject, eventdata, handles)
close;
function update_snake(locx,locy)
global mat_r mat_g mat_b
    mat_r(locx(1),locy(1))=255;
    mat_g(locx(1),locy(1))=0;
    mat_b(locx(1),locy(1))=0;

    for i=2:length(locx)
        mat_r(locx(i),locy(i))=0;
        mat_g(locx(i),locy(i))=255;
        mat_b(locy(i),locy(i))=0;
    end
function figure1_KeyPressFcn(hObject, eventdata, handles)
global direction move_status;
switch(eventdata.Key)
    case 'uparrow'
        if ~(direction==4)
            direction=2;
            move_status=1;
        end
    case 'downarrow'
        if ~(direction==2)
            direction=4;
            move_status=1;
        end
    case 'rightarrow'
        if ~(direction==3)
            direction=1;
            move_status=1;
        end
    case 'leftarrow'
        if ~(direction==1)
            direction=3;
            move_status=1;
        end
    case 'return'
        move_status=0;
    otherwise
        direction=direction;
        move_status=1;
end
        