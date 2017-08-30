program AppLoadDll;

uses
  Vcl.Forms,
  uApp in 'uApp.pas' {Form1},
  FixD_Relays in 'FixD_Relays.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
