program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2
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
     Application.Title:='Noter Client';
     Application.Initialize;
     Application.CreateForm(TForm1, Form1);
     Application.CreateForm(TForm2, Form2);
     Application.Run;
end.
