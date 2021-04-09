unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lNetComponents, lNet;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LTCPComponent1: TLTCPComponent;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormResize(Sender: TObject);
begin
     Edit1.Width:=Form1.Width-16;
     Edit2.Width:=Form1.Width-16;
     Memo1.Width:=Form1.Width-16;
     Memo1.Height:=Form1.Height-169;
     Button1.Top:=Form1.Height-49;
     Button1.Width:=Form1.Width;
     Button2.Top:=Button1.Top+25;
     Button2.Width:=Form1.Width;
end;

procedure TForm1.LTCPComponent1Connect(aSocket: TLSocket);
begin
     try
        LTCPComponent1.SendMessage(Memo1.Text);
     except
        ShowMessage('Wystąpił błąd podczas wysyłania wiadomości.');
     end;
     Sleep(50);
     try
        LTCPComponent1.Disconnect();
     except
        ShowMessage('Wystąpił błąd podczas rozłączania.');
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     Application.Terminate;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     LTCPComponent1.Connect(Edit1.Text,StrToInt(Edit2.Text));
end;

end.
