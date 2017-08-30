unit uDM1;

interface

uses
  System.SysUtils, System.Classes, IdUDPClient, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPServer, IdStack;

type
  TDM1 = class(TDataModule)
    IdUDPServer1: TIdUDPServer;
    IdUDPClient1: TIdUDPClient;
  private
    { Private declarations }
  public
    { Public declarations }
    zUdpSrvPort: Integer;
    zUdpSubnerBC: String;

    function StopUDPServer: integer;
    function StartUDPServer(iPort: integer = 2666): integer;
    function UDPCl_SendCMD(aTo:PChar; aMsg:PChar; iPort:Integer = 2666): integer;
  end;

var
  DM1: TDM1;

implementation
uses uRtnNetwork;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function GetSubnetIP: String;
var aLocalIP: String;
begin
  aLocalIP := idStack.GStack.LocalAddress;
  Result := copy(aLocalIP,0,LastDelimiter('.',aLocalIP))+'255';
end;

function TDM1.StopUDPServer: integer;
begin
  Result := -1;
  IdUDPServer1.Active := False;
  IdUDPServer1.Free;
  IdUDPClient1.Free;
  if not IdUDPServer1.Active then
  begin
    Result := 1;
  end;
end;

function TDM1.StartUDPServer(iPort: integer): integer;
begin

  Result := -1;
  zUdpSrvPort := iPort;
  IdUDPServer1 := TIdUDPServer.Create(nil);
  IdUDPClient1 := TIdUDPClient.Create(nil);

  //IdUDPServer1.ThreadedEvent := True;
  IdUDPServer1.DefaultPort := zUdpSrvPort;
  IdUDPServer1.Active := True;
  if IdUDPServer1.Active then
  begin
    zUdpSubnerBC := GetSubnetIP;
    Result := 1;
  end;
end;

function TDM1.UDPCl_SendCMD(aTo:PChar; aMsg:PChar; iPort:Integer): integer;
begin
  Result := -1;

  if IdUDPClient1 = nil then IdUDPClient1 := TIdUDPClient.Create(nil);

  if TRIM(zUdpSubnerBC)='' then zUdpSubnerBC := GetSubnetIP;
  if (aTo = String('all')) OR (aTo = String('')) then
  begin
    IdUDPClient1.Send(zUdpSubnerBC,iPort,String(aMsg));
  end else
  begin
    //_a pakai IP
    IdUDPClient1.Send(String(aTo),iPort,String(aMsg));
  end;
  Result := 1;
end;

end.
