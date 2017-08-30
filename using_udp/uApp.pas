unit uApp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FixD_Relays, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label5: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button8: TButton;
    Button9: TButton;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Button7: TButton;
    Panel2: TPanel;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iServerPort: Integer;
  end;

var
  Form1: TForm1;
  hFDX: THandle;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var iRet: Integer;
    aClientPort : Integer;
    aEPSN : String;
    aEPSecret : String;
    iTipe : Integer;
begin
  if Button1.Caption='Start' then
  begin
    iServerPort:= StrToInt(Edit1.Text);
    iRet := FDX_Init(iServerPort);
    if iRet > 0 then
    begin
      Button1.Caption := 'Stop';

      // do setting
      //setting called after ini, or before make command
      aClientPort := StrToInt(Edit4.Text);
      aEPSN := Edit5.Text;
      aEPSecret := Edit6.Text;
      //tipe EndPoint : 1 untuk 8 Switch, 2 untuk 16 Switch, 3 untuk 24 Switch
      iTipe := ComboBox1.ItemIndex;
      iRet := FDX_Setting(aClientPort,PChar(aEPSN),PChar(aEPSecret),iTipe);
    end
    else
    begin
      Button1.Caption := 'Start';
    end;
  end else
  begin
    iRet := FDX_Stop();
    Button1.Caption := 'Start';
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var iRet: Integer;
begin
  iRet := FDX_SendCMD(PChar('all'),PChar(Edit2.Text),iServerPort);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  FDX_SwON(1);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  FDX_SwON(12);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  FDX_SwOFF(1);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  FDX_SwOFF(12);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  FDX_SwON_All;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  FDX_SwOFF_All;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 //Load Library SDX
  hFDX := Loadlibrary(PWideChar(ExtractFilePath(Application.ExeName)+'Dll_Project1.dll'));
  if hFDX = 0 then
  begin
    ShowMessage('Error: Dll cannot loaded!');
    Exit;
  end;

  FDX_Init := GetProcAddress(hFDX, 'FDX_Init');
  FDX_Setting := GetProcAddress(hFDX, 'FDX_Setting');
  FDX_Stop := GetProcAddress(hFDX, 'FDX_Stop');
  FDX_SwON := GetProcAddress(hFDX, 'FDX_SwON');
  FDX_SwOFF := GetProcAddress(hFDX, 'FDX_SwOFF');
  FDX_SwON_All := GetProcAddress(hFDX, 'FDX_SwON_All');
  FDX_SwOFF_All := GetProcAddress(hFDX, 'FDX_SwOFF_All');

  //for advanced jika ingin manual handle by ip address
  FDX_SendCMD := GetProcAddress(hFDX, 'FDX_SendCMD');

end;

end.
