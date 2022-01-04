unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, Buttons, Menus, httpsend, synacode, fpjson, jsonparser,
  Dos, Windows, synacrypt, IniFiles, Clipbrd, Unit2
  {$IFDEF LCLWinCE}
  , sipapi
  {$ENDIF}
  ;

{ ---------------------------------------------------------------------------- }

{ Constants }

{ Files }
const helpFile=                    '\Windows\Help\Noter Client.lnk';

{ Additional codes }
const emptyImage=                  -10240;
const connecting=                  10240;

{ Answer codes }
const getError=                    -1024;
const serviceDisabled=             -768;
const serverError=                 -512;
const noteAlreadyUnlocked=         -14;
const noteAlreadyLocked=           -13;
const noteLocked=                  -12;
const userRemoveError=             -11;
const userNotExist=                -10;
const noteNotExist=                -9;
const noNecessaryInfo=             -8;
const userDeactivated=             -7;
const loginIncorrect=              -6;
const unknownAction=               -5;
const noCredentials=               -4;
const userExists=                  -3;
const noUsableInfoInPOST=          -2;
const invalidRequest=              -1;
const OK=                          0;
const userCreated=                 1;
const userUpdated=                 2;
const userRemoved=                 3;
const listSuccessful=              4;
const noteGetSuccessful=           5;
const noteCreateSuccessful=        6;
const noteUpdateSuccessful=        7;
const noteDeleteSuccessful=        8;
const userInfoGetSuccessful=       9;
const noteLockSuccessful=          10;
const noteUnlockSuccessful=        11;
const serverChangedSuccessful=     1024;

{ Temporary booleans }
const askUnsavedChanges=           true;
const askDeleteAccount=            true;
const askChangeCredentials=        true;
const askUpdateNote=               true;
const askDeleteNote=               true;
const askWantLogout=               true;

{ ---------------------------------------------------------------------------- }

{ Structures definition }

{ Element structure }
type element = record
     { name:    utf8string; }
     lastMod: TDateTime;
     id:      integer;
end;

{ Note structure }
type note = record
     id:             integer;
     subject, entry: utf8string;
     added, lastMod: TDateTime;
     locked:         boolean;
     UA, lastUA:     utf8string;
end;

{ User structure }
type user = record
     id:          integer;
     username:    utf8string;
     registered:  TDateTime;
     UA:          utf8string;
     lastChanged: TDateTime;
     lastUA:      utf8string;
end;

{ Server information structure }
type serverInfo = record
     name, timezone, version: utf8string;
end;

{ Additional types }
type att= array of utf8string;
type elm= array of element;

{ ---------------------------------------------------------------------------- }

{ Functions and procedures prototypes }

{$IFDEF LCLWinCE}
Function SHGetShortcutTarget(szShortcut, szTarget: LPTSTR; cbMax: integer): WordBool; stdcall; external 'coredll.dll' name 'SHGetShortcutTarget';
Function wndCallBack(Ahwnd: HWND; uMsg: UINT; wParam: WParam; lParam: LParam): LRESULT; stdcall;
Procedure OpenSIPWhenNecessary;
Procedure CloseSIPWhenNecessary;
{$ENDIF}
Function Question(text: utf8string; ask: boolean = true): boolean;
Procedure Information(text: utf8string);
Procedure Error(text: utf8string);
Function userOrServerChanged(): boolean;
Function generateKey(server: utf8string): utf8string;
Function Post(action, username, password: utf8string; subject: utf8string = ''; entry: utf8string = ''; newPassword: utf8string = ''; noteID: integer = 0): utf8string;
Function whichCode(code: integer): utf8string;
Function getAnswerInfo(input: utf8string; var attachment: att): integer;
Function getUser(input: utf8string; var output: user): boolean;
Function getList(input: utf8string; var elements: elm; var ListBox: TListBox): boolean;
Function getNote(input: utf8string; var output: note): boolean;
Function getServer(input: utf8string; var output: serverInfo): boolean;
Function getNewID(input: utf8string; var newID: integer): boolean;
Procedure changeIconAndLastCode(code: integer);
Procedure bringToFront;
Function LoadResourceString(var Lib: THandle; Index: longint; maxBuffer: longint = 1024): utf8string;
Procedure LoadStringTable(var Lib: THandle);

{ ---------------------------------------------------------------------------- }

{ Main form definition }

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button2: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Notebook1: TNotebook;
    Page1: TPage;
    Page10: TPage;
    Page11: TPage;
    Page12: TPage;
    Page2: TPage;
    Page3: TPage;
    Page4: TPage;
    Page5: TPage;
    Page6: TPage;
    Page7: TPage;
    Page8: TPage;
    Page9: TPage;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    ScrollBox1: TScrollBox;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Edit10Enter(Sender: TObject);
    procedure Edit10Exit(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure Edit11Enter(Sender: TObject);
    procedure Edit11Exit(Sender: TObject);
    procedure Edit12Change(Sender: TObject);
    procedure Edit12Enter(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Enter(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit6Enter(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit7Enter(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure Edit8Enter(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit9Enter(Sender: TObject);
    procedure Edit9Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label25Click(Sender: TObject);
    procedure Label25MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label25MouseEnter(Sender: TObject);
    procedure Label25MouseLeave(Sender: TObject);
    procedure Label25MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label58Click(Sender: TObject);
    procedure Label58MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label58MouseEnter(Sender: TObject);
    procedure Label58MouseLeave(Sender: TObject);
    procedure Label58MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1Enter(Sender: TObject);
    procedure Memo1Exit(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure Page10BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page10Resize(Sender: TObject);
    procedure Page11BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page11Resize(Sender: TObject);
    procedure Page12BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page12Resize(Sender: TObject);
    procedure Page1BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page1Resize(Sender: TObject);
    procedure Page2BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page2Resize(Sender: TObject);
    procedure Page3BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page3Resize(Sender: TObject);
    procedure Page4BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page4Resize(Sender: TObject);
    procedure Page5BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page5Resize(Sender: TObject);
    procedure Page6BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page6Resize(Sender: TObject);
    procedure Page7BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page7Resize(Sender: TObject);
    procedure Page8BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page8Resize(Sender: TObject);
    procedure Page9BeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure Page9Resize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

{ ---------------------------------------------------------------------------- }

{ Variables }

var Form1: TForm1;
    elements: array of element;
    userAgent, server, share, username, password, iniFile: utf8string;
    ini: TIniFile;
    settingsLoaded, newSize, noteChanged, userChanged, serverChanged, newIDSet: boolean;
    selectedNoteIndex, newID, FormSize, lastCode: integer;
    tempNote: note;
    tempUser: user;
    tempServer: serverInfo;
    {$IFDEF LCLWinCE}
    PrevWndProc: WNDPROC;
    {$ENDIF}

{ String variables }
var informationPreviousServer, infoOK, infoUserCreated, infoUserUpdated, infoUserDeleted,
    infoNoteListGot, infoNoteRetrieved, infoNoteCreated, infoNoteUpdated, infoNoteDeleted,
    infoUserInfoGot, infoNoteLocked, infoNoteUnlocked, infoServerChanged, questionUnsavedChanges,
    questionDeleteAccount, questionChangeCredentials, questionUpdateNote, questionDeleteNote,
    questionWantLogout, errorNoHelpFile, errorFillForms, errorProvidePassword, errorPasswordNotMatching,
    errorWrongAnswer, errorServerShutdown, errorInternalServer, errorNoteAlreadyUnlocked,
    errorNoteAlreadyLocked, errorNoteLocked, errorUserDelete, errorWrongUser, errorWrongNote,
    errorNoNeededData, errorUserLocked, errorWrongCredentials, errorWrongCommand, errorNoCredentials,
    errorUsernameTaken, errorNoUsableData, errorWrongRequest, errorUnknownCode, labelConnectionCheckError,
    labelConnectionCheckOK, labelRegisteredSuccessfully, labelRegistrationError, labelLoggedInSuccessfully,
    labelLoggingInError, labelID, labelDate, buttonAdd, buttonUpdate, buttonLock, buttonUnlock: utf8string;

implementation

{$R *.lfm}

{ TForm1 }

{$IFDEF LCLWinCE}
Function wndCallBack(Ahwnd: HWND; uMsg: UINT; wParam: WParam; lParam: LParam): LRESULT; stdcall;
var x: SIPInfo;
    zw:widestring;
    z: PWideChar;
    i: integer;
begin
     if uMsg=WM_SETTINGCHANGE then
     begin
          If wParam=SPI_SETSIPINFO then
          begin
               system.FillChar(x,sizeof(x),0);
               x.cbSize:=sizeof(x);
               If SipGetInfo(Addr(x)) then
               begin
                    If ((x.fdwFlags and 1)=1) then
                       Form1.Height:=FormSize-(x.rcSipRect.Bottom-x.rcSipRect.Top)
                    else
                       Form1.Height:=FormSize;
               end;
          end;
     end
     else if uMsg=WM_HELP then
     begin
          zw:='';
          For i:=0 to 1024 do zw:=zw+' ';
          z:=PWideChar(zw);
          If SHGetShortcutTarget(helpFile,z,1024) then
          begin
               zw:=z;
               delete(zw,1,1);
               delete(zw,length(zw),1);
               zw:='file:'+zw+'#Contents';
               z:=PWideChar(zw);
               CreateProcess('peghelp.exe',z,nil,nil,false,0,nil,nil,nil,nil);
          end
          else Error(errorNoHelpFile);
     end
     else if uMsg=WM_USER then
     begin
          If wParam=1 then Form1.Timer2.Enabled:=true;
     end;
     Result:=CallWindowProc(PrevWndProc,Ahwnd,uMsg,WParam,LParam);
end;

Procedure OpenSIPWhenNecessary;
var x: SIPInfo;
begin
     system.FillChar(x,sizeof(x),0);
     x.cbSize:=sizeof(x);
     If SipGetInfo(Addr(x)) then
     begin
          If((x.fdwFlags and 1)=0) then SipShowIM(SIPF_ON);
     end
     else SipShowIM(SIPF_ON);
end;

Procedure CloseSIPWhenNecessary;
var x: SIPInfo;
begin
     system.FillChar(x,sizeof(x),0);
     x.cbSize:=sizeof(x);
     If SipGetInfo(Addr(x)) then
     begin
          If((x.fdwFlags and 1)=1) then SipShowIM(SIPF_OFF);
     end
     else SipShowIM(SIPF_OFF);
end;
{$ENDIF}

Function Question(text: utf8string; ask: boolean = true): boolean;
var {$IFDEF LCLWinCE}
    txW, titleW: widestring;
    {$ELSE}
    tx, title: string;
    {$ENDIF}
begin
     If not ask then
     begin
          Result:=true;
          exit;
     end;
     {$IFDEF LCLWinCE}
     txW:=UTF8ToAnsi(text);
     titleW:=UTF8ToAnsi(Application.Title);
     Result:=(Windows.MessageBox(Form1.Handle,PWideChar(txW),PWideChar(titleW),Windows.MB_ICONQUESTION+Windows.MB_YESNO)=Windows.IDYES);
     {$ELSE}
     tx:=UTF8ToAnsi(text);
     title:=UTF8ToAnsi(Application.Title);
     Result:=(Windows.MessageBox(Form1.Handle,PChar(tx),PChar(title),Windows.MB_ICONQUESTION+Windows.MB_YESNO)=Windows.IDYES);
     {$ENDIF}
end;

Procedure Information(text: utf8string);
var {$IFDEF LCLWinCE}
    txW, titleW: widestring;
    {$ELSE}
    tx, title: string;
    {$ENDIF}
begin
     {$IFDEF LCLWinCE}
     txW:=UTF8ToAnsi(text);
     titleW:=UTF8ToAnsi(Application.Title);
     Windows.MessageBox(Form1.Handle,PWideChar(txW),PWideChar(titleW),Windows.MB_ICONINFORMATION);
     {$ELSE}
     tx:=UTF8ToAnsi(text);
     title:=UTF8ToAnsi(Application.Title);
     Windows.MessageBox(Form1.Handle,PChar(tx),PChar(title),Windows.MB_ICONINFORMATION);
     {$ENDIF}
end;

Procedure Error(text: utf8string);
var {$IFDEF LCLWinCE}
    txW, titleW: widestring;
    {$ELSE}
    tx, title: string;
    {$ENDIF}
begin
     {$IFDEF LCLWinCE}
     txW:=UTF8ToAnsi(text);
     titleW:=UTF8ToAnsi(Application.Title);
     Windows.MessageBox(Form1.Handle,PWideChar(txW),PWideChar(titleW),Windows.MB_ICONERROR);
     {$ELSE}
     tx:=UTF8ToAnsi(text);
     title:=UTF8ToAnsi(Application.Title);
     Windows.MessageBox(Form1.Handle,PChar(tx),PChar(title),Windows.MB_ICONERROR);
     {$ENDIF}
end;

Function userOrServerChanged(): boolean;
begin
     if userChanged or serverChanged then
     begin
          if Question(questionUnsavedChanges,askUnsavedChanges) then
          begin
               userChanged:=false;
               serverChanged:=false;
               Result:=true;
          end
          else Result:=false;
     end
     else Result:=true;
end;

Function generateKey(server: utf8string): utf8string;
var temp, temp2: utf8string;
    x:           integer;
begin
     temp:=SHA1(server+server+server);
     temp2:='';
     For x:=1 to 10 do
     begin
          temp2:=temp2+Chr(Ord(temp[x])+Ord(temp[x+10]));
     end;
     temp2:=temp2+temp[11]+temp[20];
     Result:=EncodeBase64(temp2);
end;

Function Post(action, username, password: utf8string; subject: utf8string = ''; entry: utf8string = ''; newPassword: utf8string = ''; noteID: integer = 0): utf8string;
var test: THTTPSend;
    urldata: utf8string;
    ss: TStringStream;
    res: utf8string;
begin
     test:=THTTPSend.Create;
     test.Timeout:=5000;
     test.MimeType:='application/x-www-form-urlencoded';
     test.Document.Clear;
     urldata:='action='+EncodeURL(action)
             +'&username='+EncodeURL(username)
             +'&password='+EncodeURL(password);
     if(length(subject)>0) then urldata:=urldata+'&subject='+EncodeURL(subject);
     if(length(entry)>0) then urldata:=urldata+'&entry='+EncodeURL(entry);
     if(length(newPassword)>0) then urldata:=urldata+'&newPassword='+EncodeURL(newPassword);
     if(noteID>0) then urldata:=urldata+'&noteID='+EncodeURL(IntToStr(noteID));
     test.Document.Write(Pointer(urldata)^,Length(urldata));
     test.UserAgent:=userAgent;
     test.HTTPMethod('POST','http://'+server+'/'+share+'/index.php');
     res:='';
     if test.MimeType='application/json' then
     begin
          ss:=TStringStream.Create('');
          ss.CopyFrom(test.Document,0);
          res:=ss.DataString;
          ss.Free;
     end;
     test.Free;
     Result:=res;
end;

Function whichCode(code: integer): utf8string;
begin
     Case code of
          getError:                Result:=errorWrongAnswer;
          serviceDisabled:         Result:=errorServerShutdown;
          serverError:             Result:=errorInternalServer;
          noteAlreadyUnlocked:     Result:=errorNoteAlreadyUnlocked;
          noteAlreadyLocked:       Result:=errorNoteAlreadyLocked;
          noteLocked:              Result:=errorNoteLocked;
          userRemoveError:         Result:=errorUserDelete;
          userNotExist:            Result:=errorWrongUser;
          noteNotExist:            Result:=errorWrongNote;
          noNecessaryInfo:         Result:=errorNoNeededData;
          userDeactivated:         Result:=errorUserLocked;
          loginIncorrect:          Result:=errorWrongCredentials;
          unknownAction:           Result:=errorWrongCommand;
          noCredentials:           Result:=errorNoCredentials;
          userExists:              Result:=errorUsernameTaken;
          noUsableInfoInPOST:      Result:=errorNoUsableData;
          invalidRequest:          Result:=errorWrongRequest;
          OK:                      Result:=infoOK;
          userCreated:             Result:=infoUserCreated;
          userUpdated:             Result:=infoUserUpdated;
          userRemoved:             Result:=infoUserDeleted;
          listSuccessful:          Result:=infoNoteListGot;
          noteGetSuccessful:       Result:=infoNoteRetrieved;
          noteCreateSuccessful:    Result:=infoNoteCreated;
          noteUpdateSuccessful:    Result:=infoNoteUpdated;
          noteDeleteSuccessful:    Result:=infoNoteDeleted;
          userInfoGetSuccessful:   Result:=infoUserInfoGot;
          noteLockSuccessful:      Result:=infoNoteLocked;
          noteUnlockSuccessful:    Result:=infoNoteUnlocked;
          serverChangedSuccessful: Result:=infoServerChanged;
     else
         Result:=errorUnknownCode;
     end;
end;

Function getAnswerInfo(input: utf8string; var attachment: att): integer;
var jData: TJSONData;
    count, x, code: integer;
    atta:   array of utf8string;
begin
     Try
        jData:=GetJSON(input);
        If jData=nil then raise Exception.Create('No usable JSON data.');
        count:=jData.FindPath('answer_info').FindPath('attachment').Count;
        SetLength(atta,0);
        SetLength(atta,count);
        For x:=0 to count-1 do
        begin
             atta[x]:=jData.FindPath('answer_info').FindPath('attachment['+IntToStr(x)+']').AsString;
        end;
        attachment:=atta;
        code:=jData.FindPath('answer_info').FindPath('code').AsInteger;
        jData.Free;
        Result:=code;
     Except
        On E: Exception do
        begin
             Result:=getError;
        end;
     end;
end;

Function getUser(input: utf8string; var output: user): boolean;
var jData: TJSONData;
begin
     Try
        jData:=GetJSON(input);
        if jData=nil then raise Exception.Create('No usable JSON data.');
        output.id:=jData.FindPath('answer').FindPath('user').FindPath('id').AsInteger;
        output.username:=jData.FindPath('answer').FindPath('user').FindPath('username').AsString;
        output.registered:=StrToDateTime(jData.FindPath('answer').FindPath('user').FindPath('date_registered').AsString);
        output.UA:=jData.FindPath('answer').FindPath('user').FindPath('user_agent').AsString;
        output.lastChanged:=StrToDateTime(jData.FindPath('answer').FindPath('user').FindPath('last_changed').AsString);
        output.lastUA:=jData.FindPath('answer').FindPath('user').FindPath('last_user_agent').AsString;
        jData.Free;
     Except
        On E: Exception do
        begin
             Result:=false;
        end;
     end;
     Result:=true;
end;

Function getList(input: utf8string; var elements: elm; var ListBox: TListBox): boolean;
var jData: TJSONData;
    x, count: integer;
    name:     utf8string;
    list:     array of element;
    obj:      element;
begin
     Try
        jData:=GetJSON(input);
        if jData=nil then raise Exception.Create('No usable JSON data.');
        count:=jData.FindPath('answer').FindPath('count').AsInteger;
        SetLength(list,0);
        SetLength(list,count);
        ListBox.Clear;
        For x:=0 to count-1 do
        begin
             obj.id:=jData.FindPath('answer').FindPath('notes_summary['+IntToStr(x)+']').FindPath('id').AsInteger;
             {obj.}name:=jData.FindPath('answer').FindPath('notes_summary['+IntToStr(x)+']').FindPath('subject').AsString;
             obj.lastMod:=StrToDateTime(jData.FindPath('answer').FindPath('notes_summary['+IntToStr(x)+']').FindPath('last_modified').AsString);
             ListBox.AddItem({obj.}name,nil);
             list[x]:=obj;
        end;
        elements:=list;
        jData.Free;
     Except
        On E: Exception do
        begin
             Result:=false;
        end;
     end;
     Result:=true;
end;

Function getNote(input: utf8string; var output: note): boolean;
var jData: TJSONData;
begin
     Try
        jData:=GetJSON(input);
        if jData=nil then raise Exception.Create('No usable JSON data.');
        output.id:=jData.FindPath('answer').FindPath('note').FindPath('id').AsInteger;
        output.subject:=jData.FindPath('answer').FindPath('note').FindPath('subject').AsString;
        output.entry:=jData.FindPath('answer').FindPath('note').FindPath('entry').AsString;
        output.added:=StrToDateTime(jData.FindPath('answer').FindPath('note').FindPath('date_added').AsString);
        output.lastMod:=StrToDateTime(jData.FindPath('answer').FindPath('note').FindPath('last_modified').AsString);
        output.locked:=jData.FindPath('answer').FindPath('note').FindPath('locked').AsBoolean;
        output.UA:=jData.FindPath('answer').FindPath('note').FindPath('user_agent').AsString;
        output.lastUA:=jData.FindPath('answer').FindPath('note').FindPath('last_user_agent').AsString;
        jData.Free;
     Except
        On E: Exception do
        begin
             Result:=false;
        end;
     end;
     Result:=true;
end;

Function getServer(input: utf8string; var output: serverInfo): boolean;
var jData: TJSONData;
begin
     Try
        jData:=GetJSON(input);
        if jData=nil then raise Exception.Create('No usable JSON data.');
        output.name:=jData.FindPath('server').FindPath('name').AsString;
        output.timezone:=jData.FindPath('server').FindPath('timezone').AsString;
        output.version:=jData.FindPath('server').FindPath('version').AsString;
        jData.Free;
     Except
        On E: Exception do
        begin
             Result:=false;
        end;
     end;
     Result:=true;
end;

Function getNewID(input: utf8string; var newID: integer): boolean;
var jData: TJSONData;
begin
     Try
        jData:=GetJSON(input);
        if jData=nil then raise Exception.Create('No usable JSON data.');
        newID:=jData.FindPath('answer').FindPath('new_id').AsInteger;
        jData.Free;
     Except
        On E: Exception do
        begin
             Result:=false;
        end;
     end;
     Result:=true;
end;

Procedure changeIconAndLastCode(code: integer);
var imgCode: integer;
begin
     If code<>connecting then lastCode:=code;
     If code<OK then imgCode:=3
        else if code=OK then imgCode:=2
             else imgCode:=1;
     If code=emptyImage then imgCode:=0
        else if code=connecting then imgCode:=4;
     Form1.ImageList1.StretchDraw(Form1.Image1.Canvas,imgCode,Form1.Image1.ClientRect);
end;

Procedure bringToFront;
begin
     Application.Minimize;
     Application.Restore;
     Application.BringToFront;
end;

Function LoadResourceString(var Lib: THandle; Index: longint; maxBuffer: longint = 1024): utf8string;
var temp: widestring;
begin
     SetLength(temp,maxBuffer);
     SetLength(temp,LoadStringW(Lib,Index,Addr(temp[1]),Length(temp)));
     Result:=temp;
end;

Procedure LoadStringTable(var Lib: THandle);
begin
     { Information }
     informationPreviousServer:=  LoadResourceString(Lib,101);
     infoOK:=                     LoadResourceString(Lib,102);
     infoUserCreated:=            LoadResourceString(Lib,103);
     infoUserUpdated:=            LoadResourceString(Lib,104);
     infoUserDeleted:=            LoadResourceString(Lib,105);
     infoNoteListGot:=            LoadResourceString(Lib,106);
     infoNoteRetrieved:=          LoadResourceString(Lib,107);
     infoNoteCreated:=            LoadResourceString(Lib,108);
     infoNoteUpdated:=            LoadResourceString(Lib,109);
     infoNoteDeleted:=            LoadResourceString(Lib,110);
     infoUserInfoGot:=            LoadResourceString(Lib,111);
     infoNoteLocked:=             LoadResourceString(Lib,112);
     infoNoteUnlocked:=           LoadResourceString(Lib,113);
     infoServerChanged:=          LoadResourceString(Lib,114);

     { Questions }
     questionUnsavedChanges:=     LoadResourceString(Lib,201);
     questionDeleteAccount:=      LoadResourceString(Lib,202);
     questionChangeCredentials:=  LoadResourceString(Lib,203);
     questionUpdateNote:=         LoadResourceString(Lib,204);
     questionDeleteNote:=         LoadResourceString(Lib,205);
     questionWantLogout:=         LoadResourceString(Lib,206);

     { Errors }
     errorNoHelpFile:=            LoadResourceString(Lib,301);
     errorFillForms:=             LoadResourceString(Lib,302);
     errorProvidePassword:=       LoadResourceString(Lib,303);
     errorPasswordNotMatching:=   LoadResourceString(Lib,304);
     errorWrongAnswer:=           LoadResourceString(Lib,305);
     errorServerShutdown:=        LoadResourceString(Lib,306);
     errorInternalServer:=        LoadResourceString(Lib,307);
     errorNoteAlreadyUnlocked:=   LoadResourceString(Lib,308);
     errorNoteAlreadyLocked:=     LoadResourceString(Lib,309);
     errorNoteLocked:=            LoadResourceString(Lib,310);
     errorUserDelete:=            LoadResourceString(Lib,311);
     errorWrongUser:=             LoadResourceString(Lib,312);
     errorWrongNote:=             LoadResourceString(Lib,313);
     errorNoNeededData:=          LoadResourceString(Lib,314);
     errorUserLocked:=            LoadResourceString(Lib,315);
     errorWrongCredentials:=      LoadResourceString(Lib,316);
     errorWrongCommand:=          LoadResourceString(Lib,317);
     errorNoCredentials:=         LoadResourceString(Lib,318);
     errorUsernameTaken:=         LoadResourceString(Lib,319);
     errorNoUsableData:=          LoadResourceString(Lib,320);
     errorWrongRequest:=          LoadResourceString(Lib,321);
     errorUnknownCode:=           LoadResourceString(Lib,322);

     { Labels }
     labelConnectionCheckError:=  LoadResourceString(Lib,401);
     labelConnectionCheckOK:=     LoadResourceString(Lib,402);
     labelRegisteredSuccessfully:=LoadResourceString(Lib,403);
     labelRegistrationError:=     LoadResourceString(Lib,404);
     labelLoggedInSuccessfully:=  LoadResourceString(Lib,405);
     labelLoggingInError:=        LoadResourceString(Lib,406);
     labelID:=                    LoadResourceString(Lib,407);
     labelDate:=                  LoadResourceString(Lib,408);

     Form1.Label3.Caption:=       LoadResourceString(Lib,409);
     Form1.Label4.Caption:=       LoadResourceString(Lib,410);
     Form1.Label5.Caption:=       LoadResourceString(Lib,411);
     Form1.Label6.Caption:=       LoadResourceString(Lib,412);
     Form1.CheckBox1.Caption:=    LoadResourceString(Lib,413);
     Form1.Label8.Caption:=       LoadResourceString(Lib,414);
     Form1.Label2.Caption:=       LoadResourceString(Lib,405);
     Form1.Label9.Caption:=       LoadResourceString(Lib,415);
     Form1.Label12.Caption:=      LoadResourceString(Lib,416);
     Form1.Label57.Caption:=      LoadResourceString(Lib,417);
     Form1.Label58.Caption:=      LoadResourceString(Lib,418);
     Form1.Label13.Caption:=      LoadResourceString(Lib,419);
     Form1.Label14.Caption:=      LoadResourceString(Lib,420);
     Form1.CheckBox2.Caption:=    LoadResourceString(Lib,421);
     Form1.Label15.Caption:=      LoadResourceString(Lib,422);
     Form1.Label17.Caption:=      LoadResourceString(Lib,423);
     Form1.Label19.Caption:=      LoadResourceString(Lib,424);
     Form1.Label21.Caption:=      LoadResourceString(Lib,425);
     Form1.Label23.Caption:=      LoadResourceString(Lib,426);
     Form1.Label26.Caption:=      LoadResourceString(Lib,427);
     Form1.Label28.Caption:=      LoadResourceString(Lib,411);
     Form1.Label30.Caption:=      LoadResourceString(Lib,428);
     Form1.Label32.Caption:=      LoadResourceString(Lib,429);
     Form1.Label34.Caption:=      LoadResourceString(Lib,430);
     Form1.Label36.Caption:=      LoadResourceString(Lib,431);
     Form1.Label52.Caption:=      LoadResourceString(Lib,409);
     Form1.Label54.Caption:=      LoadResourceString(Lib,410);
     Form1.Label38.Caption:=      LoadResourceString(Lib,432);
     Form1.Label65.Caption:=      LoadResourceString(Lib,433);
     Form1.Label40.Caption:=      LoadResourceString(Lib,434);
     Form1.Label42.Caption:=      LoadResourceString(Lib,435);
     Form1.Label43.Caption:=      LoadResourceString(Lib,436);
     Form1.Label44.Caption:=      LoadResourceString(Lib,437);
     Form1.Label45.Caption:=      LoadResourceString(Lib,438);
     Form1.Label46.Caption:=      LoadResourceString(Lib,439);
     Form1.Label47.Caption:=      LoadResourceString(Lib,412);
     Form1.Label45.Caption:=      LoadResourceString(Lib,438);
     Form1.Label48.Caption:=      LoadResourceString(Lib,440);
     Form1.Label49.Caption:=      LoadResourceString(Lib,441);
     Form1.Label50.Caption:=      LoadResourceString(Lib,409);
     Form1.Label51.Caption:=      LoadResourceString(Lib,410);
     Unit2.version:=              LoadResourceString(Lib,442);
     Unit2.programmer:=           LoadResourceString(Lib,443);
     Unit2.contact:=              LoadResourceString(Lib,444);
     Unit2.productionTime:=       LoadResourceString(Lib,445);
     Unit2.informationFormName:=  LoadResourceString(Lib,446);
     Form1.MenuItem18.Caption:=   LoadResourceString(Lib,407);
     Form1.MenuItem20.Caption:=   LoadResourceString(Lib,408);
     Form1.MenuItem1.Caption:=    LoadResourceString(Lib,447);
     Form1.MenuItem2.Caption:=    LoadResourceString(Lib,448);
     Form1.MenuItem10.Caption:=   LoadResourceString(Lib,448);
     Form1.MenuItem4.Caption:=    LoadResourceString(Lib,449);
     Form1.MenuItem12.Caption:=   LoadResourceString(Lib,449);
     Form1.MenuItem5.Caption:=    LoadResourceString(Lib,450);
     Form1.MenuItem13.Caption:=   LoadResourceString(Lib,450);
     Form1.MenuItem6.Caption:=    LoadResourceString(Lib,451);
     Form1.MenuItem14.Caption:=   LoadResourceString(Lib,451);
     Form1.MenuItem7.Caption:=    LoadResourceString(Lib,447);
     Form1.MenuItem15.Caption:=   LoadResourceString(Lib,447);
     Form1.MenuItem9.Caption:=    LoadResourceString(Lib,452);
     Form1.MenuItem17.Caption:=   LoadResourceString(Lib,452);
     Form1.Label56.Caption:=      LoadResourceString(Lib,453);
     Form1.Label59.Caption:=      LoadResourceString(Lib,454,3900);
     Form1.Label60.Caption:=      LoadResourceString(Lib,455);
     Form1.Label61.Caption:=      LoadResourceString(Lib,456);
     Form1.Label62.Caption:=      LoadResourceString(Lib,457,1900);

     { Buttons }
     buttonAdd:=                  LoadResourceString(Lib,501);
     buttonUpdate:=               LoadResourceString(Lib,502);
     buttonLock:=                 LoadResourceString(Lib,503);
     buttonUnlock:=               LoadResourceString(Lib,504);

     Form1.Button1.Caption:=      LoadResourceString(Lib,505);
     Form1.Button2.Caption:=      LoadResourceString(Lib,506);
     Form1.Button3.Caption:=      LoadResourceString(Lib,507);
     Form1.Button4.Caption:=      LoadResourceString(Lib,508);
     Form1.Button5.Caption:=      LoadResourceString(Lib,506);
     Form1.Button12.Caption:=     LoadResourceString(Lib,501);
     Form1.Button13.Caption:=     LoadResourceString(Lib,509);
     Form1.Button22.Caption:=     LoadResourceString(Lib,510);
     Form1.Button26.Caption:=     LoadResourceString(Lib,503);
     Form1.Button14.Caption:=     LoadResourceString(Lib,511);
     Form1.Button15.Caption:=     LoadResourceString(Lib,509);
     Form1.Button17.Caption:=     LoadResourceString(Lib,512);
     Form1.Button16.Caption:=     LoadResourceString(Lib,513);
     Form1.Button18.Caption:=     LoadResourceString(Lib,511);
     Form1.Button19.Caption:=     LoadResourceString(Lib,514);
     Form1.Button20.Caption:=     LoadResourceString(Lib,509);
     Form1.Button21.Caption:=     LoadResourceString(Lib,514);
     Form1.Button23.Caption:=     LoadResourceString(Lib,513);
     Form1.Button24.Caption:=     LoadResourceString(Lib,514);
     Form1.Button25.Caption:=     LoadResourceString(Lib,506);
     Unit2.buttonClose:=          LoadResourceString(Lib,510);
end;

{ Form elements }

procedure TForm1.FormCreate(Sender: TObject);
var version: word;
    aes:     TSynaAes;
    lib:     THandle;
    {$IFDEF LCLWinCE}
    libPath: widestring;
    {$ELSE}
    libPath: string;
    {$ENDIF}
begin
     FormSize:=Form1.Height;
     Form1.Caption:='Noter Client';
     libPath:=UTF8ToAnsi(Application.Location+'test.dll');
     {$IFDEF LCLWinCE}
     lib:=LoadLibrary(PWideChar(libPath));
     {$ELSE}
     lib:=LoadLibrary(PChar(libPath));
     {$ENDIF}
     If lib=0 then
     begin
          Error('Library could not be loaded!'#13#10'Application finishes.');
          Application.Terminate;
     end
     else
     begin
          LoadStringTable(lib);
          FreeLibrary(lib);
     end;
     {$IFDEF LCLWinCE}
     PrevWndProc:=Windows.WNDPROC(SetWindowLong(Self.Handle,GWL_WNDPROC,PtrInt(@WndCallback)));
     {$ENDIF}
     version:=DosVersion;
     {$IFDEF LCLWinCE}
     userAgent:='Noter Client/1.0 (Windows CE OS '+IntToStr(Lo(version))+'.'+IntToStr(Hi(version))+')';
     {$ELSE}
     userAgent:='Noter Client/1.0 (Windows OS '+IntToStr(Lo(version))+'.'+IntToStr(Hi(version))+')';
     {$ENDIF}
     {$IFNDEF LCLWinCE}
     Edit6.PopupMenu:=nil;
     Memo1.PopupMenu:=nil;
     {$ENDIF}
     lastCode:=emptyImage;
     settingsLoaded:=false;
     newSize:=false;
     noteChanged:=false;
     userChanged:=false;
     serverChanged:=false;
     selectedNoteIndex:=-1;
     newID:=0;
     newIDSet:=false;
     iniFile:=Application.Location+'config.ini';
     ini:=TIniFile.Create(iniFile);
     If ini.SectionExists('server') then
     begin
          server:=ini.ReadString('server','address','');
          share:=ini.ReadString('server','share','');
          Edit1.Text:=server;
          Edit2.Text:=share;
     end;
     If ini.SectionExists('user') then
     begin
          username:=ini.ReadString('user','username','');
          aes:=TSynaAes.Create(generateKey(server));
          password:=aes.DecryptCFBblock(DecodeBase64(ini.ReadString('user','password','')));
          aes.Free();
          Edit3.Text:=username;
          Edit4.Text:=password;
     end;
     If ini.SectionExists('server') and ini.SectionExists('user') then
     begin
          settingsLoaded:=((length(server)>0) and (length(share)>0) and (length(username)>0) and (length(password)>0));
          Notebook1.PageIndex:=1;
     end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     if((length(Edit1.Text)>0) and (length(Edit2.Text)>0) and (length(Edit3.Text)>0) and (length(Edit4.Text)>0)) then
     begin
          server:=Edit1.Text;
          share:=Edit2.Text;
          username:=Edit3.Text;
          password:=Edit4.Text;
          if CheckBox1.Checked then Notebook1.PageIndex:=3
             else Notebook1.PageIndex:=1;
     end
     else
     begin
          Error(errorFillForms);
     end;
end;

procedure TForm1.Button20Click(Sender: TObject);
var data: utf8string;
    res:  integer;
    atta: att;
begin
     If Length(Edit10.Text)>0 then
     begin
          If Question(questionDeleteAccount,askDeleteAccount) then
          begin
               data:=Post('remove',username,Edit10.Text);
               res:=GetAnswerInfo(data,atta);
               if res=userRemoved then
               begin
                    Information(whichCode(res));
                    Edit3.Text:='';
                    Edit4.Text:='';
                    Edit5.Text:='';
                    ListBox1.Clear;
                    Edit6.Text:='';
                    Memo1.Clear;
                    Edit10.Text:='';
                    tempNote.id:=0;
                    tempNote.added:=0;
                    tempNote.lastMod:=0;
                    tempNote.locked:=false;
                    tempNote.UA:='';
                    tempNote.lastUA:='';
                    tempNote.subject:='';
                    tempNote.entry:='';
                    changeIconAndLastCode(emptyImage);
                    username:='';
                    password:='';
                    noteChanged:=false;
                    userChanged:=false;
                    serverChanged:=false;
                    settingsLoaded:=false;
                    ini.DeleteKey('user','username');
                    ini.DeleteKey('user','password');
                    Button6.Enabled:=false;
                    Button6.Visible:=false;
                    Button7.Enabled:=false;
                    Button7.Visible:=false;
                    Button8.Enabled:=false;
                    Button8.Visible:=false;
                    Button9.Enabled:=false;
                    Button9.Visible:=false;
                    Button10.Enabled:=false;
                    Button10.Visible:=false;
                    Button11.Enabled:=false;
                    Button11.Visible:=false;
                    Label25.Enabled:=false;
                    Label25.Visible:=false;
                    CheckBox2.Checked:=true;
                    Button12.Caption:=buttonAdd;
                    selectedNoteIndex:=-1;
                    newSize:=false;
                    Notebook1.Height:=Form1.Height;
                    Notebook1.PageIndex:=0;
               end
               else if res<OK then
               begin
                    Error(whichCode(res));
               end;
          end;
     end
     else
     begin
          Error(errorProvidePassword);
     end;
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
     Edit10.Text:='';
     Notebook1.PageIndex:=6;
end;

procedure TForm1.Button22Click(Sender: TObject);
var CanClose: boolean;
begin
     CanClose:=true;
     If noteChanged then
     begin
          CanClose:=Question(questionUnsavedChanges,askUnsavedChanges);
     end;
     If CanClose then
     begin
          Edit6.Text:='';
          Memo1.Clear;
          noteChanged:=false;
          CheckBox2.Checked:=true;
          Button12.Caption:=buttonAdd;
          tempNote.id:=0;
          tempNote.added:=0;
          tempNote.lastMod:=0;
          tempNote.locked:=false;
          tempNote.UA:='';
          tempNote.lastUA:='';
          tempNote.subject:='';
          tempNote.entry:='';
          changeIconAndLastCode(emptyImage);
          If newIDSet then selectedNoteIndex:=0;
          Notebook1.PageIndex:=2;
     end;
end;

procedure TForm1.Button23Click(Sender: TObject);
var CanClose: boolean;
    data, tempServer, tempShare: utf8string;
    res:      integer;
    atta:     att;
    aes:      TSynaAes;
begin
     CanClose:=true;
     If noteChanged or userChanged then
     begin
          CanClose:=Question(questionUnsavedChanges,askUnsavedChanges);
     end;
     If CanClose then
     begin
          tempServer:=server;
          tempShare:=share;
          server:=Edit11.Text;
          share:=Edit12.Text;
          data:=Post('info',username,password);
          res:=getAnswerInfo(data,atta);
          if res<OK then
          begin
               If res=loginIncorrect then
               begin
                    If Question(questionChangeCredentials,askChangeCredentials) then
                    begin
                         ini.WriteString('server','address',server);
                         ini.WriteString('server','share',share);
                         Edit1.Text:=server;
                         Edit2.Text:=share;
                         Edit3.Text:='';
                         Edit4.Text:='';
                         Edit5.Text:='';
                         ListBox1.Clear;
                         Edit6.Text:='';
                         Memo1.Clear;
                         username:='';
                         password:='';
                         tempNote.id:=0;
                         tempNote.added:=0;
                         tempNote.lastMod:=0;
                         tempNote.locked:=false;
                         tempNote.UA:='';
                         tempNote.lastUA:='';
                         tempNote.subject:='';
                         tempNote.entry:='';
                         changeIconAndLastCode(emptyImage);
                         noteChanged:=false;
                         userChanged:=false;
                         serverChanged:=false;
                         settingsLoaded:=false;
                         ini.DeleteKey('user','username');
                         ini.DeleteKey('user','password');
                         Button6.Enabled:=false;
                         Button6.Visible:=false;
                         Button7.Enabled:=false;
                         Button7.Visible:=false;
                         Button8.Enabled:=false;
                         Button8.Visible:=false;
                         Button9.Enabled:=false;
                         Button9.Visible:=false;
                         Button10.Enabled:=false;
                         Button10.Visible:=false;
                         Button11.Enabled:=false;
                         Button11.Visible:=false;
                         Label25.Enabled:=false;
                         Label25.Visible:=false;
                         CheckBox2.Checked:=true;
                         Button12.Caption:=buttonAdd;
                         selectedNoteIndex:=-1;
                         newSize:=false;
                         Notebook1.Height:=Form1.Height;
                         Notebook1.PageIndex:=0;
                    end
                    else
                    begin
                         server:=tempServer;
                         share:=tempShare;
                         Edit11.Text:=server;
                         Edit12.Text:=share;
                         serverChanged:=false;
                         Information(informationPreviousServer);
                    end;
               end
               else
               begin
                    Error(whichCode(res));
                    server:=tempServer;
                    share:=tempShare;
               end;
          end
          else
          begin
               if res=userInfoGetSuccessful then
               begin
                    Information(whichCode(serverChangedSuccessful));
                    ini.WriteString('server','address',server);
                    ini.WriteString('server','share',share);
                    aes:=TSynaAes.Create(generateKey(server));
                    ini.WriteString('user','password',EncodeBase64(aes.EncryptCFBblock(password)));
                    aes.Free;
                    Edit3.Text:='';
                    Edit4.Text:='';
                    Edit5.Text:='';
                    ListBox1.Clear;
                    Edit6.Text:='';
                    Memo1.Clear;
                    tempNote.id:=0;
                    tempNote.added:=0;
                    tempNote.lastMod:=0;
                    tempNote.locked:=false;
                    tempNote.UA:='';
                    tempNote.lastUA:='';
                    tempNote.subject:='';
                    tempNote.entry:='';
                    changeIconAndLastCode(emptyImage);
                    serverChanged:=false;
                    userChanged:=false;
                    noteChanged:=false;
                    CheckBox2.Checked:=true;
                    Button12.Caption:=buttonAdd;
                    selectedNoteIndex:=-1;
                    settingsLoaded:=true;
                    Notebook1.PageIndex:=1;
               end
               else if res<OK then
               begin
                    Error(whichCode(res));
               end;
          end;
     end;
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
     If userOrServerChanged() then Notebook1.PageIndex:=7;
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
     Notebook1.PageIndex:=3;
end;

procedure TForm1.Button26Click(Sender: TObject);
var data: utf8string;
    res, noteID:  integer;
    atta: att;
begin
     If newIDSet then noteID:=newID
        else noteID:=elements[selectedNoteIndex].id;
     If tempNote.locked then
     begin
          data:=Post('unlock',username,password,'','','',noteID);
          res:=getAnswerInfo(data,atta);
          If res=noteUnlockSuccessful then
          begin
               tempNote.locked:=false;
               Button26.Caption:=buttonLock;
               Button13.Enabled:=true;
          end
          else if res<OK then
          begin
               Error(whichCode(res));
          end;
     end
     else
     begin
          data:=Post('lock',username,password,'','','',noteID);
          res:=getAnswerInfo(data,atta);
          If res=noteLockSuccessful then
          begin
               tempNote.locked:=true;
               Button26.Caption:=buttonUnlock;
               Button13.Enabled:=false;
          end
          else if res<OK then
          begin
               Error(whichCode(res));
          end;
     end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
     If userOrServerChanged() then Notebook1.PageIndex:=7;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
     Form1.Close();
end;

procedure TForm1.Button12Click(Sender: TObject);
var data: utf8string;
    res: integer;
    atta: att;
begin
     If ((Length(Edit6.Text)>0) and (Length(Memo1.Lines.GetText)>0)) then
     begin
          changeIconAndLastCode(connecting);
          If CheckBox2.Checked then
          begin
               data:=Post('add',username,password,Edit6.Text,Memo1.Lines.Text);
               res:=getAnswerInfo(data,atta);
               if res=noteCreateSuccessful then
               begin
                    If getNewID(data,newID) then
                    begin
                         changeIconAndLastCode(res);
                         newIDSet:=true;
                         data:=Post('retrieve',username,password,'','','',newID);
                         res:=getAnswerInfo(data,atta);
                         selectedNoteIndex:=0;
                         If getNote(data,tempNote) then
                         begin
                              noteChanged:=false;
                              CheckBox2.Checked:=false;
                         end
                         else
                         begin
                              changeIconAndLastCode(getError);
                         end;
                    end
                    else
                    begin
                         changeIconAndLastCode(getError);
                    end;
               end
               else if res<OK then
               begin
                    changeIconAndLastCode(res);
               end;
          end
          else
          begin
               If Question(questionUpdateNote,askUpdateNote) then
               begin
                    if newIDSet then data:=Post('update',username,password,Edit6.Text,Memo1.Lines.Text,'',newID)
                       else data:=Post('update',username,password,Edit6.Text,Memo1.Lines.Text,'',elements[selectedNoteIndex].id);
                    res:=getAnswerInfo(data,atta);
                    if res=noteUpdateSuccessful then
                    begin
                         changeIconAndLastCode(res);
                         if newIDSet then data:=Post('retrieve',username,password,'','','',newID)
                            else data:=Post('retrieve',username,password,'','','',elements[selectedNoteIndex].id);
                         res:=getAnswerInfo(data,atta);
                         If getNote(data,tempNote) then
                         begin
                              noteChanged:=false;
                         end
                         else
                         begin
                              changeIconAndLastCode(getError);
                         end;
                    end
                    else if res<OK then
                    begin
                         changeIconAndLastCode(res);
                    end;
               end
               else changeIconAndLastCode(lastCode);
          end;
     end
     else
     begin
          Error(errorFillForms);
     end;
end;

procedure TForm1.Button13Click(Sender: TObject);
var data: utf8string;
    res, noteID:  integer;
    atta: att;
    CanClose: boolean;
begin
     CanClose:=true;
     If noteChanged or userChanged or serverChanged then
     begin
          CanClose:=Question(questionUnsavedChanges,askUnsavedChanges);
     end;
     If ((CanClose) and (Question(questionDeleteNote,askDeleteNote))) then
     begin
          If newIDSet then noteID:=newID
             else noteID:=elements[selectedNoteIndex].id;
          data:=Post('delete',username,password,'','','',noteID);
          res:=getAnswerInfo(data,atta);
          if res=noteDeleteSuccessful then
          begin
               tempNote.id:=0;
               tempNote.added:=0;
               tempNote.lastMod:=0;
               tempNote.locked:=false;
               tempNote.UA:='';
               tempNote.lastUA:='';
               tempNote.subject:='';
               tempNote.entry:='';
               changeIconAndLastCode(emptyImage);
               Edit6.Text:='';
               Memo1.Clear;
               noteChanged:=false;
               selectedNoteIndex:=-1;
               CheckBox2.Checked:=true;
               Button12.Caption:=buttonAdd;
               Notebook1.PageIndex:=2;
          end
          else if res<OK then
          begin
               Error(whichCode(res));
          end;
     end;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
     Notebook1.PageIndex:=8;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
     Notebook1.PageIndex:=9;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
     Notebook1.PageIndex:=10;
end;

procedure TForm1.Button17Click(Sender: TObject);
var CanClose: boolean;
begin
     CanClose:=true;
     If noteChanged or userChanged or serverChanged then
     begin
          CanClose:=Question(questionUnsavedChanges,askUnsavedChanges);
     end;
     If CanClose then
     begin
          If Question(questionWantLogout,askWantLogout) then
          begin
               Edit3.Text:='';
               Edit4.Text:='';
               Edit5.Text:='';
               ListBox1.Clear;
               Edit6.Text:='';
               Memo1.Clear;
               username:='';
               password:='';
               tempNote.id:=0;
               tempNote.added:=0;
               tempNote.lastMod:=0;
               tempNote.locked:=false;
               tempNote.UA:='';
               tempNote.lastUA:='';
               tempNote.subject:='';
               tempNote.entry:='';
               changeIconAndLastCode(emptyImage);
               noteChanged:=false;
               userChanged:=false;
               serverChanged:=false;
               settingsLoaded:=false;
               ini.DeleteKey('user','username');
               ini.DeleteKey('user','password');
               Button6.Enabled:=false;
               Button6.Visible:=false;
               Button7.Enabled:=false;
               Button7.Visible:=false;
               Button8.Enabled:=false;
               Button8.Visible:=false;
               Button9.Enabled:=false;
               Button9.Visible:=false;
               Button10.Enabled:=false;
               Button10.Visible:=false;
               Button11.Enabled:=false;
               Button11.Visible:=false;
               Label25.Enabled:=false;
               Label25.Visible:=false;
               CheckBox2.Checked:=true;
               Button12.Caption:=buttonAdd;
               selectedNoteIndex:=-1;
               newSize:=false;
               Notebook1.Height:=Form1.Height;
               Notebook1.PageIndex:=0;
          end;
     end;
end;

procedure TForm1.Button18Click(Sender: TObject);
var data: utf8string;
    res:  integer;
    atta: att;
    aes:  TSynaAes;
begin
     If((length(Edit7.Text)>0) and (length(Edit8.Text)>0) and (length(Edit9.Text)>0)) then
     begin
          If Edit8.Text=Edit9.Text then
          begin
               data:=Post('change',username,Edit7.Text,'','',Edit8.Text);
               res:=getAnswerInfo(data,atta);
               If res=userUpdated then
               begin
                    password:=Edit8.Text;
                    aes:=TSynaAes.Create(generateKey(server));
                    ini.WriteString('user','password',EncodeBase64(aes.EncryptCFBblock(password)));
                    aes.Free();
                    userChanged:=false;
                    Information(whichCode(2));
                    Notebook1.PageIndex:=6;
               end
               else if res<OK then
               begin
                    Error(whichCode(res));
               end;
          end
          else
          begin
               Error(errorPasswordNotMatching);
          end;
     end
     else
     begin
          Error(errorFillForms);
     end;
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
     if userOrServerChanged() then Notebook1.PageIndex:=6;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     Notebook1.PageIndex:=0;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     Notebook1.PageIndex:=2;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     if Edit4.Text=Edit5.Text then Notebook1.PageIndex:=1
        else Error(errorPasswordNotMatching);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     Notebook1.PageIndex:=0;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     If userOrServerChanged() then Notebook1.PageIndex:=2;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
     If userOrServerChanged() then Notebook1.PageIndex:=4;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
     If userOrServerChanged() then Notebook1.PageIndex:=5;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
     If userOrServerChanged() then Notebook1.PageIndex:=6;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
     If tempNote.id=0 then
     begin
          CheckBox2.Checked:=true;
     end
     else
     begin
          If CheckBox2.Checked then Button12.Caption:=buttonAdd
             else Button12.Caption:=buttonUpdate;
     end;
end;

procedure TForm1.Edit10Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit10Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit11Change(Sender: TObject);
begin
     serverChanged:=true;
end;

procedure TForm1.Edit11Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit11Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit12Change(Sender: TObject);
begin
     serverChanged:=true;
end;

procedure TForm1.Edit12Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit12Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit1Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit2Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit3Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit3Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit4Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit4Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit5Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit5Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit6Change(Sender: TObject);
begin
     noteChanged:=true;
end;

procedure TForm1.Edit6Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit6Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit7Change(Sender: TObject);
begin
     userChanged:=true;
end;

procedure TForm1.Edit7Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit7Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit8Change(Sender: TObject);
begin
     userChanged:=true;
end;

procedure TForm1.Edit8Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit8Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.Edit9Change(Sender: TObject);
begin
     userChanged:=true;
end;

procedure TForm1.Edit9Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit9Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
     ini.Free();
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
     If noteChanged or userChanged or serverChanged then
     begin
          CanClose:=Question(questionUnsavedChanges,askUnsavedChanges);
     end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
     Notebook1.Width:=Form1.Width;
     if(newSize) then
     begin
          Notebook1.Height:=Form1.Height-16;
          Button6.Top:=Form1.Height-16;
          Button7.Top:=Form1.Height-16;
          Button8.Top:=Form1.Height-16;
          Button9.Top:=Form1.Height-16;
          Button10.Top:=Form1.Height-16;
          Button11.Top:=Form1.Height-16;
          Label25.Left:=Form1.Width-134;
          Label25.Top:=Form1.Height-15;
     end
     else Notebook1.Height:=Form1.Height;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
     If lastCode=emptyImage then exit
        else
        begin
             If lastCode<OK then Error(whichCode(lastCode))
                else Information(whichCode(lastCode));
        end;
end;

procedure TForm1.Label25Click(Sender: TObject);
begin
     Form2.ShowModal;
end;

procedure TForm1.Label25MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Label25.Font.Style:=[fsBold];
end;

procedure TForm1.Label25MouseEnter(Sender: TObject);
begin
     Label25.Font.Style:=[fsBold];
end;

procedure TForm1.Label25MouseLeave(Sender: TObject);
begin
     Label25.Font.Style:=[];
end;

procedure TForm1.Label25MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Label25.Font.Style:=[];
end;

procedure TForm1.Label58Click(Sender: TObject);
begin
     Notebook1.PageIndex:=11;
end;

procedure TForm1.Label58MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Label58.Font.Style:=[fsBold, fsUnderline];
end;

procedure TForm1.Label58MouseEnter(Sender: TObject);
begin
     Label58.Font.Style:=[fsBold, fsUnderline];
end;

procedure TForm1.Label58MouseLeave(Sender: TObject);
begin
     Label58.Font.Style:=[fsBold];
end;

procedure TForm1.Label58MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Label58.Font.Style:=[fsBold];
end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: boolean);
var load: boolean;
    res:  integer;
    atta: att;
    data: utf8string;
begin
     If User then
     begin
          load:=false;
          If ListBox1.ItemIndex>-1 then
          begin
               If noteChanged then
               begin
                    If Question(questionUnsavedChanges,askUnsavedChanges) then
                    begin
                         selectedNoteIndex:=ListBox1.ItemIndex;
                         load:=true;
                    end
                    else
                    begin
                         load:=false;
                         ListBox1.ItemIndex:=selectedNoteIndex;
                    end;
               end
               else
               begin
                    selectedNoteIndex:=ListBox1.ItemIndex;
                    load:=true;
               end;
          end;
          If load then
          begin
               data:=Post('retrieve',username,password,'','','',elements[selectedNoteIndex].id);
               res:=getAnswerInfo(data,atta);
               If res=noteGetSuccessful then
               begin
                    If getNote(data,tempNote) then
                    begin
                         Edit6.Text:=tempNote.subject;
                         Memo1.Text:=tempNote.entry;
                         CheckBox2.Checked:=false;
                         noteChanged:=false;
                         changeIconAndLastCode(emptyImage);
                         Notebook1.PageIndex:=4;
                    end
                    else
                    begin
                         Error(whichCode(getError));
                    end;
               end
               else if res<OK then
               begin
                    Error(whichCode(res));
               end;
          end;
     end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
     noteChanged:=true;
end;

procedure TForm1.Memo1Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=false;
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Memo1Exit(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     Timer1.Enabled:=true;
     {$ENDIF}
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
     Memo1.Undo;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
     Memo1.CutToClipboard;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
begin
     Memo1.CopyToClipboard;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
     Memo1.PasteFromClipboard;
end;

procedure TForm1.MenuItem15Click(Sender: TObject);
var temp: utf8string;
    sel:  integer;
begin
     temp:=Memo1.Text;
     sel:=Memo1.SelStart;
     Delete(temp,Memo1.SelStart+1,Memo1.SelLength);
     Memo1.Text:=temp;
     Memo1.SelStart:=sel;
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
begin
     Memo1.SelectAll;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
var data: utf8string;
    res:  integer;
    atta: att;
begin
     If Question(questionDeleteNote,askDeleteNote) then
     begin
          data:=Post('delete',username,password,'','','',elements[ListBox1.ItemIndex].id);
          res:=getAnswerInfo(data,atta);
          if res=noteDeleteSuccessful then
          begin
               selectedNoteIndex:=-1;
               If tempNote.id=elements[ListBox1.ItemIndex].id then
               begin
                    newIDSet:=true;
                    tempNote.id:=0;
                    tempNote.added:=0;
                    tempNote.lastMod:=0;
                    tempNote.locked:=false;
                    tempNote.UA:='';
                    tempNote.lastUA:='';
                    CheckBox2.Checked:=true;
                    Button12.Caption:=buttonAdd;
               end;
               Form1.Page3BeforeShow(Sender,nil,0);
          end
          else if res<OK then
          begin
               Error(whichCode(res));
          end;
     end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
     Edit6.Undo;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
     Edit6.CutToClipboard;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
     Edit6.CopyToClipboard;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
     Edit6.PasteFromClipboard;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
var temp:  utf8string;
    sel:   integer;
begin
     temp:=Edit6.Text;
     sel:=Edit6.SelStart;
     Delete(temp,Edit6.SelStart+1,Edit6.SelLength);
     Edit6.Text:=temp;
     Edit6.SelStart:=sel;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
     Edit6.SelectAll;
end;

procedure TForm1.Page10BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=256;
     Edit10.Text:='';
end;

procedure TForm1.Page10Resize(Sender: TObject);
begin
     Edit10.Width:=Page10.Width-16;
     Label48.Width:=Page10.Width-16;
end;

procedure TForm1.Page11BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=160;
     Edit11.Text:=server;
     Edit12.Text:=share;
     serverChanged:=false;
end;

procedure TForm1.Page11Resize(Sender: TObject);
begin
     Edit11.Width:=Page11.Width-16;
     Edit12.Width:=Page11.Width-16;
end;

procedure TForm1.Page12BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=128;
     ScrollBox1.VertScrollBar.Position:=0;
end;

procedure TForm1.Page12Resize(Sender: TObject);
begin
     Label63.Width:=Page12.Width-16;
     ScrollBox1.Height:=Page12.Height-92;
     ScrollBox1.Width:=Page12.Width;
     Button25.Top:=Page12.Height-36;
end;

procedure TForm1.Page1BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=264;
end;

procedure TForm1.Page1Resize(Sender: TObject);
begin
     Label1.Width:=Page1.Width-16;
     Edit1.Width:=Page1.Width-16;
     Edit2.Width:=Page1.Width-16;
     Edit3.Width:=Page1.Width-16;
     Edit4.Width:=Page1.Width-16;
     Button1.Left:=Page1.Width-104;
end;

procedure TForm1.Page2BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
var atta: att;
    res:  integer;
    data: utf8string;
    aes:  TSynaAes;
begin
     Form1.Constraints.MinHeight:=144;
     if CheckBox1.Checked then data:=Post('register',username,password)
        else data:=Post('info',username,password);
     res:=getAnswerInfo(data,atta);
     if res=getError then Label8.Caption:=labelConnectionCheckError
        else Label8.Caption:=labelConnectionCheckOK;
     if res>=OK then
     begin
          Button3.Enabled:=true;
          Label10.Caption:='';
          if res=userCreated then
          begin
               Label2.Caption:=labelRegisteredSuccessfully;
               CheckBox1.Checked:=false;
          end
          else Label2.Caption:=labelLoggedInSuccessfully;
          Label2.Font.Color:=clGreen;
          if(settingsLoaded) then
          begin
               Notebook1.PageIndex:=2;
          end
          else
          begin
               aes:=TSynaAes.Create(generateKey(server));
               ini.WriteString('server','address',server);
               ini.WriteString('server','share',share);
               ini.WriteString('user','username',username);
               ini.WriteString('user','password',EncodeBase64(aes.EncryptCFBblock(password)));
               aes.Free();
          end;
     end
     else
     begin
          Button3.Enabled:=false;
          Label10.Caption:=whichCode(res)+'.';
          if CheckBox1.Checked then Label2.Caption:=labelRegistrationError
             else Label2.Caption:=labelLoggingInError;
          if(settingsLoaded) then settingsLoaded:=false;
          Label2.Font.Color:=clRed;
     end;
end;

procedure TForm1.Page2Resize(Sender: TObject);
begin
     Label7.Width:=Page2.Width-16;
     Label8.Width:=Page2.Width-16;
     Label10.Width:=Page2.Width-16;
     Button2.Top:=Page2.Height-36;
     Button3.Top:=Page2.Height-36;
     Button3.Left:=Page2.Width-104;
end;

procedure TForm1.Page3BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
var data:       utf8string;
    res{, x}:     integer;
    attachment: att;
begin
     Form1.Constraints.MinHeight:=64;
     newID:=0;
     newIDSet:=false;
     if not newSize then
     begin
          newSize:=true;
          Notebook1.Height:=Form1.Height-16;
          Button6.Enabled:=true;
          Button6.Visible:=true;
          Button7.Enabled:=true;
          Button7.Visible:=true;
          Button8.Enabled:=true;
          Button8.Visible:=true;
          Button9.Enabled:=true;
          Button9.Visible:=true;
          Button10.Enabled:=true;
          Button10.Visible:=true;
          Button11.Enabled:=true;
          Button11.Visible:=true;
          Label25.Enabled:=true;
          Label25.Visible:=true;
          Form1.FormResize(ASender);
     end;
     data:=Post('list',username,password);
     res:=getAnswerInfo(data,attachment);
     if res=listSuccessful then
     begin
          if getList(data,elements,ListBox1) then
          begin
               { ListBox1.Clear;
                 For x:=0 to length(elements)-1 do
                 begin
                      ListBox1.AddItem(elements[x].name,nil);
                 end; }
               Label64.Caption:=IntToStr(length(elements));
               ListBox1.ItemIndex:=selectedNoteIndex;
               If selectedNoteIndex>=0 then Label64.Caption:=IntToStr(selectedNoteIndex+1)+'/'+Label64.Caption;
          end
          else
          begin
               Label64.Caption:='0';
               Error(whichCode(getError));
          end;
     end
     else if(res<OK) then
     begin
          Error(whichCode(res));
     end;
end;

procedure TForm1.Page3Resize(Sender: TObject);
begin
     ListBox1.Width:=Page3.Width;
     ListBox1.Height:=Page3.Height-16;
     Label64.Left:=Page3.Width-120;
end;

procedure TForm1.Page4BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=176;
end;

procedure TForm1.Page4Resize(Sender: TObject);
begin
     Edit5.Width:=Page4.Width-16;
     Button5.Top:=Page4.Height-36;
     Button4.Top:=Page4.Height-36;
     Button4.Left:=Page4.Width-104;
end;

procedure TForm1.Page5BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=128;
end;

procedure TForm1.Page5Resize(Sender: TObject);
begin
     Edit6.Width:=Page5.Width;
     Memo1.Width:=Page5.Width;
     Memo1.Height:=Page5.Height-72;
     CheckBox2.Top:=Page5.Height-16;
     Button12.Top:=Page5.Height-16;
     Button12.Left:=Page5.Width-80;
     Image1.Left:=Page5.Width-96;
     Image1.Top:=Page5.Height-16;
end;

procedure TForm1.Page6BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=200;
     If tempNote.id=0 then
     begin
          Label16.Caption:='-';
          Button13.Enabled:=false;
          Button26.Enabled:=false;
     end
     else
     begin
          Label16.Caption:=IntToStr(tempNote.id);
          If not tempNote.locked then Button13.Enabled:=true
             else Button13.Enabled:=false;
          Button26.Enabled:=true;
     end;
     If tempNote.locked then Button26.Caption:=buttonUnlock
        else Button26.Caption:=buttonLock;
     If tempNote.added=0 then Label18.Caption:='-'
        else Label18.Caption:=DateTimeToStr(tempNote.added);
     If tempNote.lastMod=0 then Label20.Caption:='-'
        else Label20.Caption:=DateTimeToStr(tempNote.lastMod);
     If tempNote.UA='' then Label22.Caption:='-'
        else Label22.Caption:=tempNote.UA;
     If tempNote.lastUA='' then Label24.Caption:='-'
        else Label24.Caption:=tempNote.lastUA;
end;

procedure TForm1.Page6Resize(Sender: TObject);
begin
     Label16.Width:=Page6.Width-16;
     Label18.Width:=Page6.Width-16;
     Label20.Width:=Page6.Width-16;
     Label22.Width:=Page6.Width-16;
     Label24.Width:=Page6.Width-16;
end;

procedure TForm1.Page7BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
var data: utf8string;
    res:  integer;
    atta: att;
begin
     Form1.Constraints.MinHeight:=232;
     data:=Post('info',username,password);
     res:=getAnswerInfo(data,atta);
     if res=userInfoGetSuccessful then
     begin
          If getUser(data,tempUser) then
          begin
               Label27.Caption:=IntToStr(tempUser.id);
               Label29.Caption:=tempUser.username;
               Label31.Caption:=DateTimeToStr(tempUser.registered);
               Label33.Caption:=tempUser.UA;
               Label35.Caption:=DateTimeToStr(tempUser.lastChanged);
               Label37.Caption:=tempUser.lastUA;
          end
          else
          begin
               Error(whichCode(getError));
          end;
     end
     else if res<OK then
     begin
          Error(whichCode(res));
     end;
end;

procedure TForm1.Page7Resize(Sender: TObject);
begin
     Label27.Width:=Page7.Width-16;
     Label29.Width:=Page7.Width-16;
     Label31.Width:=Page7.Width-16;
     Label33.Width:=Page7.Width-16;
     Label35.Width:=Page7.Width-16;
     Label37.Width:=Page7.Width-16;
end;

procedure TForm1.Page8BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
var data: utf8string;
    atta: att;
begin
     Form1.Constraints.MinHeight:=200;
     data:=Post('info',username,password);
     getAnswerInfo(data,atta);
     if getServer(data,tempServer) then
     begin
          Label53.Caption:=server;
          Label55.Caption:=share;
          Label39.Caption:=tempServer.name;
          Label66.Caption:=tempServer.timezone;
          Label41.Caption:=tempServer.version;
     end
     else
     begin
          Error(whichCode(getError));
     end;
end;

procedure TForm1.Page8Resize(Sender: TObject);
begin
     Label53.Width:=Page8.Width-16;
     Label55.Width:=Page8.Width-16;
     Label39.Width:=Page8.Width-16;
     Label66.Width:=Page8.Width-16;
     Label41.Width:=Page8.Width-16;
end;

procedure TForm1.Page9BeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
     Form1.Constraints.MinHeight:=208;
     Edit7.Text:='';
     Edit8.Text:='';
     Edit9.Text:='';
     userChanged:=false;
end;

procedure TForm1.Page9Resize(Sender: TObject);
begin
     Edit7.Width:=Page9.Width-16;
     Edit8.Width:=Page9.Width-16;
     Edit9.Width:=Page9.Width-16;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
     MenuItem1.Enabled:=not (ListBox1.ItemIndex=-1);
     If MenuItem1.Enabled then
     begin
          MenuItem18.Caption:=labelID+IntToStr(elements[ListBox1.ItemIndex].id);
          MenuItem20.Caption:=labelDate+DateTimeToStr(elements[ListBox1.ItemIndex].lastMod);
          MenuItem18.Visible:=true;
          MenuItem19.Visible:=true;
          MenuItem20.Visible:=true;
     end
     else
     begin
          MenuItem18.Visible:=false;
          MenuItem19.Visible:=false;
          MenuItem20.Visible:=false;
     end;
end;

procedure TForm1.PopupMenu2Popup(Sender: TObject);
begin
     { Undo }
     MenuItem2.Enabled:=Edit6.CanUndo;
     { Cut, Copy, Delete }
     MenuItem4.Enabled:=Edit6.SelLength>0;
     MenuItem5.Enabled:=Edit6.SelLength>0;
     MenuItem7.Enabled:=Edit6.SelLength>0;
     { Paste }
     MenuItem6.Enabled:=Length(Clipboard.AsText)>0;
     { Select all }
     MenuItem9.Enabled:=not ((Length(Edit6.Text)=0) or (Edit6.SelLength=Length(Edit6.Text)));
end;

procedure TForm1.PopupMenu3Popup(Sender: TObject);
begin
     { Undo }
     MenuItem10.Enabled:=Memo1.CanUndo;
     { Cut, Copy, Delete }
     MenuItem12.Enabled:=Memo1.SelLength>0;
     MenuItem13.Enabled:=Memo1.SelLength>0;
     MenuItem15.Enabled:=Memo1.SelLength>0;
     { Paste }
     MenuItem14.Enabled:=Length(Clipboard.AsText)>0;
     { Select all }
     MenuItem17.Enabled:=not ((Length(Memo1.Text)=0) or (Memo1.SelLength=Length(Memo1.Text)));
end;

procedure TForm1.ScrollBox1Resize(Sender: TObject);
begin
     Label59.AutoSize:=false;
     Label59.Constraints.MaxWidth:=0;
     Label59.Width:=ScrollBox1.Width-32;
     Label59.Constraints.MaxWidth:=Label59.Width;
     Label59.AutoSize:=true;
     Label60.AutoSize:=false;
     Label60.Constraints.MaxWidth:=0;
     Label60.Width:=ScrollBox1.Width-32;
     Label60.Constraints.MaxWidth:=Label60.Width;
     Label60.Top:=Label59.Top+Label59.Height+24;
     Label60.AutoSize:=true;
     Label61.AutoSize:=false;
     Label61.Constraints.MaxWidth:=0;
     Label61.Top:=Label60.Top+Label60.Height+24;
     Label61.AutoSize:=true;
     Label62.AutoSize:=false;
     Label62.Constraints.MaxWidth:=0;
     Label62.Width:=ScrollBox1.Width-32;
     Label62.Constraints.MaxWidth:=Label62.Width;
     Label62.Top:=Label61.Top+Label61.Height+24;
     Label62.AutoSize:=true;
     ScrollBox1.VertScrollBar.Range:=Label62.Top+Label62.Height+8-ScrollBox1.Height;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     Timer1.Enabled:=false;
     {$IFDEF LCLWinCE}
     CloseSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
     Timer2.Enabled:=false;
     bringToFront;
end;

end.
