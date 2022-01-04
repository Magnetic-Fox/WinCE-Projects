unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Clipbrd, ExtCtrls, Windows;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
    procedure Label5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var Form2: TForm2;
    version, programmer, contact, productionTime, buttonClose, informationFormName: utf8string;

implementation

{$R *.lfm}

{ TForm2 }

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
     Windows.MessageBox(Form2.Handle,PWideChar(txW),PWideChar(titleW),Windows.MB_ICONINFORMATION);
     {$ELSE}
     tx:=UTF8ToAnsi(text);
     title:=UTF8ToAnsi(Application.Title);
     Windows.MessageBox(Form2.Handle,PChar(tx),PChar(title),Windows.MB_ICONINFORMATION);
     {$ENDIF}
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
     Form2.Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
     Label9.Caption:=version;
     Label3.Caption:=programmer;
     Label4.Caption:=contact;
     Label6.Caption:=productionTime;
     Button1.Caption:=buttonClose;
     Form2.Caption:=informationFormName;
end;

procedure TForm2.FormResize(Sender: TObject);
begin
     Label3.Constraints.MaxWidth:=Form2.Width-16;
     Label3.Constraints.MinWidth:=Form2.Width-16;
     Label3.Width:=Form2.Width-16;
     Label2.Width:=Form2.Width-16;
     Label5.Width:=Form2.Width-16;
     Label7.Width:=Form2.Width-16;
     Label8.Width:=Form2.Width-16;
     Button1.Width:=Form2.Width-16;
     Button1.Top:=Form2.Height-32;
     Label2.Top:=Label3.Top+Label3.Height+(16-(Label3.Height mod 16));
     Label4.Top:=Label2.Top+24;
     Label5.Top:=Label4.Top+16;
     Label6.Top:=Label5.Top+24;
     Label7.Top:=Label6.Top+16;
     Label8.Top:=Label7.Top+Label7.Height+Round((Button1.Top-(Label7.Top+Label7.Height)-Label7.Height)/2);
end;

procedure TForm2.Label5Click(Sender: TObject);
begin
     Clipboard.AsText:=Label5.Caption;
     Information('Skopiowano adres e-mail do schowka');
end;

procedure TForm2.Label5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Label5.Font.Style:=[fsBold,fsUnderline];
     Label5.Font.Color:=clBlue;
end;

procedure TForm2.Label5MouseEnter(Sender: TObject);
begin
     Label5.Font.Style:=[fsBold,fsUnderline];
     Label5.Font.Color:=clBlue;
end;

procedure TForm2.Label5MouseLeave(Sender: TObject);
begin
     Label5.Font.Style:=[];
     Label5.Font.Color:=clDefault;
end;

procedure TForm2.Label5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Label5.Font.Style:=[];
     Label5.Font.Color:=clDefault;
end;

end.
