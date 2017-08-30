unit uRtnNetwork;

interface
uses System.AnsiStrings, System.SysUtils, IdStack;

    function GetIP(var HostName, IPAddr: string): Boolean;
    function GetLocalHost: String;
    function GetLocalIP: String;
    function GetSubnetIP: String;
    function DNSLookup(const HostName: String): String;
    function ReverseDNSLookup(const IPAddress: String): String;
    function FormatAddress(const HostName, IPAddress: String): String;

implementation
uses WinSock;

function GetIP(var HostName, IPAddr: string): Boolean;
type
  Name = array[0..100] of AnsiChar;
  PName = ^Name;
var
  PHE: PHostEnt;
  HName: PName;
  WSAData: TWSAData;
  i: Integer;
begin
  Result := False;
  if WSAStartup($0101, WSAData) <> 0 then  Exit;
  IPAddr := '';
  New(HName);

  if GetHostName(HName^, SizeOf(Name)) = 0 then
  begin
    HostName := String(HName^);
    PHE := GetHostByName(HName^);
    for i := 0 to PHE^.h_length - 1 do
      IPaddr := Concat(IPAddr,
                  IntToStr(Ord(PHE^.h_addr_list^[i])) + '.');
    SetLength(IPAddr, Length(IPaddr) - 1);
    Result := True;
  end;
  Dispose(HName);
  WSACleanup;
end;

function GetLocalHost: String;
var HostName: array[0..512] of AnsiChar;
begin
  if gethostname(HostName, SizeOf(HostName)) = 0 then
    Result := String(System.AnsiStrings.StrPas(HostName))
  else
    Result := 'localhost';
end;

function GetLocalIP: String;
begin
  Result := GStack.LocalAddress;
end;

function GetSubnetIP: String;
begin
  Result := copy(GetLocalIP,0,LastDelimiter('.',GetLocalIP))+'255';
end;

function DNSLookup(const HostName: String): String;
var IP: TInAddr;
    HostEntry: PHostEnt;
begin
  Result := HostName;
  {$IFDEF UNICODE}
  HostEntry := gethostbyname(PAnsiChar(AnsiString(HostName)));
  {$ELSE}
  HostEntry := gethostbyname(PChar(HostName));
  {$ENDIF}
  if (HostEntry <> nil) and (HostEntry.h_addrtype = AF_INET) then
  begin
    IP := PInAddr(HostEntry^.h_addr^)^;
    Result := String(System.AnsiStrings.StrPas(inet_ntoa(IP)));
  end;
end;

function ReverseDNSLookup(const IPAddress: String): String;
var
  IP: TInAddr;
  HostEntry: PHostEnt;
begin
  Result := IPAddress;
  {$IFDEF UNICODE}
  IP := TInAddr(inet_addr(PAnsiChar(AnsiString(IPAddress))));
  {$ELSE}
  IP := TInAddr(inet_addr(PChar(IPAddress)));
  {$ENDIF}
  if Integer(IP.S_addr) <> Integer(INADDR_NONE) then
  begin
    HostEntry := gethostbyaddr(@IP, 4, AF_INET);
    if HostEntry <> nil then
      Result := String(System.AnsiStrings.StrPas(HostEntry^.h_name));
  end;
end;

function FormatAddress(const HostName, IPAddress: String): String;
var
  Name, IP: String;
begin
  if IPAddress = '' then
    IP := DNSLookup(HostName)
  else
    IP := IPAddress;
  if HostName = '' then
    Name := ReverseDNSLookup(IP)
  else
    Name :=  HostName;
  if Name <> IP then
    Result := Format('%s <%s>', [Name, IP])
  else
    Result := Name;
end;

end.
