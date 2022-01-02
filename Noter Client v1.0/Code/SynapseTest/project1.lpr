program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2, Windows
  {$IFDEF LCLWinCE}
  , WinCEInt, comobj
  {$ENDIF}
  { you can add units after this };

{$R *.res}

var existingWindow: windows.HWND;

begin
     RequireDerivedFormResource:=True;
     {$IFDEF LCLWinCE}
     WinCEWidgetset.WinCETitlePolicy:=tpOKButtonOnlyOnDialogs;
     {$ENDIF}
     existingWindow:=windows.FindWindowW(nil,PWideChar('Noter Client'));
     If existingWindow<>0 then
     begin
          windows.SendMessageW(existingWindow,windows.WM_USER,1,0);
          Exit;
     end;
     Application.Title:='Noter Client';
     Application.Initialize;
     Application.CreateForm(TForm1, Form1);
     Application.CreateForm(TForm2, Form2);
     Application.Run;
end.
