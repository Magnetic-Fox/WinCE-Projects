unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, Buttons, httpsend, synacode, fpjson, jsonparser, Dos,
  Windows, synacrypt, IniFiles, Unit2
  {$IFDEF LCLWinCE}
  , sipapi
  {$ENDIF}
  ;

{ ---------------------------------------------------------------------------- }

{ Constants }

{ Files }
const helpFile=                '\Windows\Help\Noter Client.lnk';

{ Additional codes }
const emptyImage=              -10240;
const connecting=              10240;

{ Answer codes }
const getError=                -1024;
const serviceDisabled=         -768;
const serverError=             -512;
const noteAlreadyUnlocked=     -14;
const noteAlreadyLocked=       -13;
const noteLocked=              -12;
const userRemoveError=         -11;
const userNotExist=            -10;
const noteNotExist=            -9;
const noNecessaryInfo=         -8;
const userDeactivated=         -7;
const loginIncorrect=          -6;
const unknownAction=           -5;
const noCredentials=           -4;
const userExists=              -3;
const noUsableInfoInPOST=      -2;
const invalidRequest=          -1;
const OK=                      0;
const userCreated=             1;
const userUpdated=             2;
const userRemoved=             3;
const listSuccessful=          4;
const noteGetSuccessful=       5;
const noteCreateSuccessful=    6;
const noteUpdateSuccessful=    7;
const noteDeleteSuccessful=    8;
const userInfoGetSuccessful=   9;
const noteLockSuccessful=      10;
const noteUnlockSuccessful=    11;
const serverChangedSuccessful= 1024;

{ ---------------------------------------------------------------------------- }

{ Structures definition }

{ Element structure }
type element = record
     { name:    utf8string;
       lastMod: TDateTime; }
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
    ScrollBox1: TScrollBox;
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
    procedure Edit11Change(Sender: TObject);
    procedure Edit11Enter(Sender: TObject);
    procedure Edit12Change(Sender: TObject);
    procedure Edit12Enter(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit4Enter(Sender: TObject);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit6Enter(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit7Enter(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure Edit8Enter(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit9Enter(Sender: TObject);
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
    procedure ScrollBox1Resize(Sender: TObject);
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
          else Error('Plik pomocy nie został zainstalowany!');
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
          if Question('Czy chcesz porzucić niezapisane zmiany?') then
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
          -1024:Result:='Błędna odpowiedź serwera';
          -768: Result:='Serwer tymczasowo wyłączony';
          -512: Result:='Wewnętrzny błąd serwera';
          -14:  Result:='Notatka już odblokowana';
          -13:  Result:='Notatka już zablokowana';
          -12:  Result:='Notatka jest zablokowana';
          -11:  Result:='Błąd usuwania użytkownika';
          -10:  Result:='Użytkownik nie istnieje';
          -9:   Result:='Notatka nie istnieje';
          -8:   Result:='Brak wymaganych informacji';
          -7:   Result:='Użytkownik jest zablokowany';
          -6:   Result:='Nieprawidłowe dane logowania';
          -5:   Result:='Nieznane polecenie';
          -4:   Result:='Brak danych logowania';
          -3:   Result:='Wybrana nazwa użytkownika jest zajęta';
          -2:   Result:='Brak użytecznych informacji w żądaniu';
          -1:   Result:='Nieprawidłowy typ żądania';
          0:    Result:='OK';
          1:    Result:='Pomyślnie utworzono użytkownika';
          2:    Result:='Pomyślnie zaktualizowano użytkownika';
          3:    Result:='Pomyślnie usunięto użytkownika';
          4:    Result:='Pomyślnie odebrano listę notatek';
          5:    Result:='Pomyślnie odebrano notatkę';
          6:    Result:='Pomyślnie utworzono notatkę';
          7:    Result:='Pomyślnie zaktualizowano notatkę';
          8:    Result:='Pomyślnie usunięto notatkę';
          9:    Result:='Pomyślnie odebrano informacje o użytkowniku';
          10:   Result:='Pomyślnie zablokowano notatkę';
          11:   Result:='Pomyślnie odblokowano notatkę';
          1024: Result:='Pomyślnie zmieniono serwer';
     else
         Result:='Nieznany kod odpowiedzi serwera';
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
             { obj.lastMod:=StrToDateTime(jData.FindPath('answer').FindPath('notes_summary['+IntToStr(x)+']').FindPath('last_modified').AsString); }
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

{ Form elements }

procedure TForm1.FormCreate(Sender: TObject);
var version: word;
    aes:     TSynaAes;
begin
     FormSize:=Form1.Height;
     {$IFDEF LCLWinCE}
     PrevWndProc:=Windows.WNDPROC(SetWindowLong(Self.Handle,GWL_WNDPROC,PtrInt(@WndCallback)));
     {$ENDIF}
     version:=DosVersion;
     {$IFDEF LCLWinCE}
     userAgent:='Noter Client/1.0 (Windows CE OS '+IntToStr(Lo(version))+'.'+IntToStr(Hi(version))+')';
     {$ELSE}
     userAgent:='Noter Client/1.0 (Windows OS '+IntToStr(Lo(version))+'.'+IntToStr(Hi(version))+')';
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
          Error('Musisz wypełnić widoczne pola.');
     end;
end;

procedure TForm1.Button20Click(Sender: TObject);
var data: utf8string;
    res:  integer;
    atta: att;
begin
     If Length(Edit10.Text)>0 then
     begin
          If Question('Czy na pewno chcesz usunąć swoje konto?'#13#10'Ten proces jest nieodwracalny!') then
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
                    Button12.Caption:='Dodaj';
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
          Error('Aby usunąć konto, musisz podać swoje hasło.');
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
          CanClose:=Question('Czy chcesz porzucić niezapisane zmiany?');
     end;
     If CanClose then
     begin
          Edit6.Text:='';
          Memo1.Clear;
          noteChanged:=false;
          CheckBox2.Checked:=true;
          Button12.Caption:='Dodaj';
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
          ListBox1.ItemIndex:=selectedNoteIndex;
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
          CanClose:=Question('Czy chcesz porzucić niezapisane zmiany?');
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
                    If Question('Ponieważ serwer został zmieniony, obecne dane logowania są niepoprawne. Czy chcesz je zmienić?') then
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
                         Button12.Caption:='Dodaj';
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
                         Information('Poprzednie dane serwera zostały przywrócone');
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
                    Button12.Caption:='Dodaj';
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
               Button26.Caption:='Zablokuj';
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
               Button26.Caption:='Odblokuj';
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
               If Question('Czy na pewno chcesz zaktualizować tą notatkę?') then
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
          Error('Musisz wypełnić widoczne pola.');
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
          CanClose:=Question('Czy chcesz porzucić niezapisane zmiany?');
     end;
     If ((CanClose) and (Question('Czy na pewno chcesz usunąć tą notatkę?'))) then
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
               ListBox1.ItemIndex:=selectedNoteIndex;
               CheckBox2.Checked:=true;
               Button12.Caption:='Dodaj';
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
          CanClose:=Question('Czy chcesz porzucić niezapisane zmiany?');
     end;
     If CanClose then
     begin
          If Question('Czy na pewno chcesz się wylogować?') then
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
               Button12.Caption:='Dodaj';
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
               Error('Hasła nie są takie same!');
          end;
     end
     else
     begin
          Error('Musisz wypełnić widoczne pola.');
     end;
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
     if userOrServerChanged() then
     begin
          Edit7.Text:='';
          Edit8.Text:='';
          Edit9.Text:='';
          Notebook1.PageIndex:=6;
     end;
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
        else Error('Hasła nie są takie same!');
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
          If CheckBox2.Checked then Button12.Caption:='Dodaj'
             else Button12.Caption:='Zaktualizuj';
     end;
end;

procedure TForm1.Edit10Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit11Change(Sender: TObject);
begin
     serverChanged:=true;
end;

procedure TForm1.Edit11Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit12Change(Sender: TObject);
begin
     serverChanged:=true;
end;

procedure TForm1.Edit12Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit1Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit2Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit3Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit4Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit5Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit6Change(Sender: TObject);
begin
     noteChanged:=true;
end;

procedure TForm1.Edit6Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit7Change(Sender: TObject);
begin
     userChanged:=true;
end;

procedure TForm1.Edit7Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit8Change(Sender: TObject);
begin
     userChanged:=true;
end;

procedure TForm1.Edit8Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
     {$ENDIF}
end;

procedure TForm1.Edit9Change(Sender: TObject);
begin
     userChanged:=true;
end;

procedure TForm1.Edit9Enter(Sender: TObject);
begin
     {$IFDEF LCLWinCE}
     OpenSIPWhenNecessary;
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
          CanClose:=Question('Czy chcesz porzucić niezapisane zmiany?');
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
                    If Question('Czy chcesz porzucić niezapisane zmiany?') then
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
     OpenSIPWhenNecessary;
     {$ENDIF}
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
     if res=getError then Label8.Caption:='Sprawdzanie połączenia... BŁĄD'
        else Label8.Caption:='Sprawdzanie połączenia... OK';
     if res>=OK then
     begin
          Button3.Enabled:=true;
          Label10.Caption:='';
          if res=userCreated then
          begin
               Label2.Caption:='Pomyślnie zarejestrowano! :)';
               CheckBox1.Checked:=false;
          end
          else Label2.Caption:='Pomyślnie zalogowano! :)';
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
          if CheckBox1.Checked then Label2.Caption:='Nie udało się zarejestrować. :('
             else Label2.Caption:='Nie udało się zalogować. :(';
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
     If tempNote.locked then Button26.Caption:='Odblokuj'
        else Button26.Caption:='Zablokuj';
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

end.
