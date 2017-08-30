library Dll_Project1;

uses
  System.SysUtils,
  System.Classes,
  //Vcl.Dialogs,
  //Vcl.Forms,
  Unit1 in 'Unit1.pas';

{$R *.res}

function FDX_Init(_b,_c: integer): integer; stdcall;
begin
  Result := InitStart(_b,_c);
end;

function FDX_Setting(_a:Integer;_b,_c:PChar; _e: integer): integer; stdcall;
begin
  //type -> 1 i2c, 2 i2c, 3 i2c
  zClientPort:= _a;
  zEPSN := String(_b);
  zEPSecret := String(_c);
  zTipe := _e; //1=1 i2c, 2,3
  Result := 1;
end;

function FDX_Stop(): integer; stdcall;
begin
  Result := StopUDPServer;
end;

function FDX_SendCMD(_a:PChar; _s:PChar; _b: integer): integer; stdcall;
begin
  Result := UDPCl_SendCMD(_a,_s,_b);
end;

function FDX_SwON(_b:Integer): integer; stdcall;
begin
  Result := CMD_SwOnOff(_b, True);
end;

function FDX_SwON_All(): integer; stdcall;
begin
  Result := CMD_SwOnOffAll(True);
end;

function FDX_SwOFF(_b:Integer): integer; stdcall;
begin
  Result := CMD_SwOnOff(_b, False);
end;

function FDX_SwOFF_All(): integer; stdcall;
begin
  Result := CMD_SwOnOffAll(False);
end;

function FDX_Reboot(): integer; stdcall;
begin
  Result := EPReboot();
end;

function FDX_SetSecretKey(aOldSecret, aNewSecret:PChar): integer; stdcall;
begin
  Result := EPGantiSecret(aNewSecret);
end;

function FDX_SetWifi_Sta(aStaName, aStaPass:PChar): integer; stdcall;
begin
  Result := EPSetWifi(aStaName,aStaPass);
end;

function FDX_SetWifi_Ap(aApName, aApPass:PChar): integer; stdcall;
begin
  Result := EPSetWifi(aApName,aApPass,True);
end;

function FDX_GetInfo(): integer; stdcall;
begin
  Result := EPGetInfo();
end;


exports
  FDX_Init,
  FDX_Stop,
  FDX_Setting,
  FDX_SwON,
  FDX_SwON_All,
  FDX_SwOFF,
  FDX_SwOFF_All,
  FDX_SendCMD,
  FDX_SetSecretKey,
  FDX_SetWifi_Sta,
  FDX_SetWifi_Ap,
  FDX_GetInfo,
  FDX_Reboot;

begin
  //Application.Initialize;
end.
