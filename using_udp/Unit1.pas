unit Unit1;

interface
uses System.SysUtils, System.Classes, Vcl.Dialogs,
  IdUDPClient, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer, IdStack,
  IdSocketHandle, IdGlobal, IdContext;

type
  TMnProcc = class
  public
    class procedure IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
              const AData: TIdBytes; ABinding: TIdSocketHandle);
  end;

type
  TDataRelay = class
    sw1,sw2,sw3,sw4,sw5,sw6,sw7,sw8,sw9,sw10,
    sw11,sw12,sw13,sw14,sw15,sw16,sw17,sw18,sw19,sw20,
    sw100: Integer;
  public
    //procedure DataChange(Sender: TObject; Field: TField);
  end;

var
    IdUDPServer1: TIdUDPServer;
    IdUDPClient1: TIdUDPClient;
    zData : TDataRelay;

    zUdpSrvPort: Integer;
    zUdpSubnerBC: String;

    zClientPort: Integer;
    zEPSN,
    zEPSecret : String;
    zTipe: Integer; //1=1 i2c, 2,3

    function InitStart(iPort:Integer; iUdpSrv:Integer=1): integer;
    function StopUDPServer: integer;
    function StartUDPServer(iPort: integer = 2666): integer;
    function CMD_SwOnOff(aLedNo:Integer; isblOn:Boolean): integer;
    function CMD_SwOnOffAll(isblOn:Boolean): integer;
    function UDPCl_SendCMD(aTo:PChar; aMsg:PChar; iPort:Integer = 2666): integer;
    function EPSetWifi(aStaName, aStaPass:PChar; isBlAP: Boolean=False): integer;
    function EPReboot(): integer;
    function EPGantiSecret(aNewSecret:PChar): integer;
    function EPGetInfo(): integer;

implementation

function GetSubnetIP: String;
var aLocalIP: String;
begin
  aLocalIP := idStack.GStack.LocalAddress;
  Result := copy(aLocalIP,0,LastDelimiter('.',aLocalIP))+'255';
end;


function InitStart(iPort,iUdpSrv:Integer): integer;
begin
  zUdpSrvPort := iPort;

  zData := TDataRelay.Create;
  IdUDPClient1 := TIdUDPClient.Create(nil);

  if iUdpSrv > 0 then
  begin
    Result := StartUDPServer(iPort);
  end else
  begin
    Result := 1;
  end;

end;

function StopUDPServer: integer;
begin
  Result := -1;
  IdUDPServer1.Active := False;
  zData.Free;
  IdUDPServer1.Free;
  IdUDPClient1.Free;
  if not IdUDPServer1.Active then
  begin
    Result := 1;
  end;
end;

function StartUDPServer(iPort: integer): integer;
begin
  Result := -1;
  IdUDPServer1 := TIdUDPServer.Create(nil);
    IdUDPServer1.ThreadedEvent := True;
    IdUDPServer1.DefaultPort := zUdpSrvPort;
    IdUDPServer1.OnUDPRead:= TMnProcc.IdUDPServer1UDPRead;
    IdUDPServer1.Active := True;
  if IdUDPServer1.Active then
  begin
    zUdpSubnerBC := GetSubnetIP;
    Result := 1;
  end;
end;

function UDPCl_SendCMD(aTo:PChar; aMsg:PChar; iPort:Integer): integer;
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

function CMD_SwOnOff(aLedNo:Integer; isblOn:Boolean): integer;
var iGroup, iEP, iOnOff: Integer;
begin
  iEP := aLedNo mod 8;
  if iEP = 0 then iEP := 8;

  if isblOn then iOnOff := 0 else iOnOff := 1;

  if (aLedNo < 9) then iGroup := 1;
  if (aLedNo > 8) AND (aLedNo < 17) then iGroup := 2;
  if (aLedNo > 16) AND (aLedNo < 25) then iGroup := 3;
  Result := UDPCl_SendCMD(PChar('all'),PChar('snep='+zEPSN+'&secret='+zEPSecret+'&i2cAddr='+IntToStr(iGroup)+'&LEDno='+IntToStr(iEP)+'&LEDact='+IntToStr(iOnOff)),zClientPort);
end;

function CMD_SwOnOffAll(isblOn:Boolean): integer;
var I, iOnOff: Integer;
begin
  if isblOn then iOnOff := 0 else iOnOff := 1;
  for I := 1 to zTipe do
  begin
    UDPCl_SendCMD(PChar('all'),PChar('snep='+zEPSN+'&secret='+zEPSecret+'&i2cAddr='+IntToStr(I)+'&LEDno=all&LEDact='+IntToStr(iOnOff)),zClientPort);
  end;
  Result := 1;
end;

function EPSetWifi(aStaName, aStaPass:PChar; isBlAP: Boolean): integer;
begin
  if isBlAP then
  begin
    UDPCl_SendCMD(PChar('all'),PChar('snep='+zEPSN+'&secret='+zEPSecret+'&setting=ganticfg&wfapname='+aStaName+'&wfappass='+aStaPass),zClientPort);
  end else
  begin
    UDPCl_SendCMD(PChar('all'),PChar('snep='+zEPSN+'&secret='+zEPSecret+'&setting=ganticfg&wfstaname='+aStaName+'&wfstapass='+aStaPass),zClientPort);
  end;
  Result := 1;
end;

function EPReboot(): integer;
begin
  begin
    UDPCl_SendCMD(PChar('all'),PChar('snep='+zEPSN+'&secret='+zEPSecret+'&setting=reboot'),zClientPort);
  end;
  Result := 1;
end;

function EPGantiSecret(aNewSecret:PChar): integer;
begin
  begin
    UDPCl_SendCMD(PChar('all'),PChar('snep='+zEPSN+'&secret='+zEPSecret+'&setting=ganticfg&newpass='+aNewSecret),zClientPort);
  end;
  Result := 1;
end;

function EPGetInfo(): integer;
begin
  begin
    UDPCl_SendCMD(PChar('all'),PChar('snep='+zEPSN+'&secret='+zEPSecret+'&getchild=yes&getinfo='+zEPSN),zClientPort);
  end;
  Result := 1;
end;

class procedure TMnProcc.IdUDPServer1UDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var  LMsg,aTtl1,aTtl2: string;
     aList: TStringList;
     I,iRec: Integer;
begin
  //proses melisting ip dari kasir

  if Length(AData) >= 0 then
  begin
    LMsg := BytesToString(AData);

    if LMsg='@1' then
    begin

    end
    else if LMsg='@2' then
    begin

    end
    else if LMsg[1]+LMsg[2]+LMsg[3]='@3#' then
    begin
      //proses terima Bill Report dari kasir
      //set variable billfnb di flash
      aTtl1 := Copy(LMsg,4,LastDelimiter('_',LMsg)-4);
      aTtl2 := Copy(LMsg,LastDelimiter('_',LMsg)+1,Length(LMsg)-LastDelimiter('_',LMsg));
      if (aTtl1 = '') then aTtl1 := '0';
      if (aTtl2 = '') then aTtl2 := '0';

    end
    else if LMsg[1]+LMsg[2]+LMsg[3]='@4#' then
    begin

    end
    else if LMsg[1]+LMsg[2]+LMsg[3]+LMsg[4]='@ZR#' then
    begin

    end
    else if LMsg='@ok' then
    begin
      showMessage(LMsg);
    end;

    ShowMessage('IP :'+ABinding.PeerIP +#13#10+
                'DisplayName:'+ ABinding.DisplayName +#13#10+
                ' Mesg: '+ LMsg);

  end;

end;

end.
