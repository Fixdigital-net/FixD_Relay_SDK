unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses uCOM_Relay;

{$R *.dfm}

function IntArray2HexSTR(Arr: Array of byte): String;
var len,i: integer;
    txt: string;
begin
  len := length(Arr);
  txt := '';
  txt := IntToHex(Arr[0],2);
  for i:=1 to len-1 do
    txt := txt + ' '+IntToHex(Arr[i],2);
  txt := txt;
  IntArray2HexSTR := txt;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ComboBox1.Items.Clear;
  uCOM_Relay.ReloadComPort(ComboBox1,True);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  uCOM_Relay.testbuka(StringReplace(ComboBox1.Items.Strings[ComboBox1.ItemIndex],'COM','',[rfReplaceAll, rfIgnoreCase]));

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Relay_ON(1, True);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    Relay_ON(1,False);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    Relay_ON(12, False);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    Relay_ON(12,True);
end;

procedure TForm1.Button7Click(Sender: TObject);
var areply : TByteArr;
begin
  areply := Relay_ON_wReply(1,True);
  memo1.lines.add(IntArray2HexSTR(areply));
end;

end.
