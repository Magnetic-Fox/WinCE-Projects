program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1
  {$IFDEF LCLWinCE}
  , WinCEInt
  {$ENDIF}
  { you can add units after this };

{$R *.res}

begin
     RequireDerivedFormResource := True;
     {$IFDEF LCLWinCE}
     WinCEWidgetset.WinCETitlePolicy:=tpOKButtonOnlyOnDialogs;
     {$ENDIF}
     Application.Title:='Noter Client v1.0';
     Application.Initialize;
     Application.CreateForm(TForm1, Form1);
     Application.Run;
end.
