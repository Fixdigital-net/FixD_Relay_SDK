unit uCOM_Relay;

interface
uses WinApi.Windows, System.SysUtils, System.Classes, Vcl.Dialogs, System.Win.Registry,
     Vcl.StdCtrls, Vcl.Forms, IniFiles, uComPort, uComBridge;

type
  TByteArr = uComBridge.TByteArr;

    procedure ReloadComPort(sSender:TObject; isShort:Boolean=False);
    procedure testbuka(aStrComNum:String; iComBaud:Integer = 115200);

    procedure Relay_ON(idLampu:Integer; isOn:Boolean=False);
    function Relay_ON_wReply(idLampu:Integer; isOn:Boolean): TByteArr;
    //procedure bukaComPort(aStrComNum:String; aComBaud:Integer = 115200);
    //procedure SendDoCMD2COM(aStr:String);
    //procedure SendCMD2COM(aStr:String);

    //procedure GetGeneralRelaySet;
    //procedure PerintahNyalaSingle(aIDLampu:String; blOn:Boolean);
    //procedure PerintahNyalaMulti(aIDLampu:String; blOn:Boolean);

implementation

procedure ReloadComPort(sSender:TObject; isShort:Boolean);
var
  reg,reg2: TRegistry;
  st: TStrings;
  i: Integer;
  aStr1,aStr2: String;
begin

  //if Trim(uRtnVar.vr_CustomKoneksi_Add) <> '' then TComboBox(sSender).Items.Add(uRtnVar.vr_CustomKoneksi_Add);

  reg := TRegistry.Create;
  reg.Access := KEY_READ;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('HARDWARE\DEVICEMAP\SERIALCOMM', False);
    st := TstringList.Create;
    try
      reg.GetValueNames(st);
      for i := 0 to st.Count - 1 do
      begin
        //Memo1.Lines.Add(reg.Readstring(st.strings[i]));
        //bsSKinComboBox1.Items.Add(reg.Readstring(st.strings[i]));

        reg2 := TRegistry.Create;
        reg2.Access := KEY_READ;
        reg2.RootKey := HKEY_LOCAL_MACHINE;
        aStr2 := Copy(st.strings[i],AnsiPos('#PORTS#',st.strings[i])+7,(LastDelimiter('#',st.strings[i])) - (AnsiPos('#PORTS#',st.strings[i])+7) );
        aStr1 := 'SYSTEM\CurrentControlSet\Enum\Root\PORTS\' + aStr2;

        reg2.OpenKey(aStr1, False);
        if isShort then
        begin
          TComboBox(sSender).Items.Add(reg.Readstring(st.strings[i]));
        end else
        begin
          TComboBox(sSender).Items.Add(reg.Readstring(st.strings[i]) +' -> '+reg2.ReadString('FriendlyName'));
        end;
        reg2.CloseKey;
        reg2.Free;

      end;
    finally
      st.Free;
    end;
    reg.CloseKey;
  finally
    reg.Free;
  end;
  //GetCommConfig();

end;

procedure testbuka(aStrComNum:String; iComBaud:Integer);
begin
      uComport.ComNum  := StrToInt(aStrComNum);
      uComport.ComBaud := iComBaud;
      xComPortNum := ComNum;
      xPortNum := ComNum+MaxEnumComNum;
      //Form1.MemLog.Clear;
      //Form1.AddLinesLog('# COM '+ inttostr(PortNum - 25) + ' Selected');
      //Form1.AddLinesLog('# Baudrate set to '+cbBaud.Text+' b/s');
      //Form1.AddLinesLog('');
      uComport.ChangeComSpeed(ComBaud);
      uComport.OpenCom(True);
end;

procedure Relay_ON(idLampu:Integer; isOn:Boolean);
var pck : TByteArr;
    iEP : Integer;
    bEP,bGroup, bOnOff: Integer;
begin

  iEP := idLampu mod 8;
  if iEP = 0 then iEP := 8;

  if iEP=1 then bEP:=$31
  else if iEP=2 then bEP:=$32
  else if iEP=3 then bEP:=$33
  else if iEP=4 then bEP:=$34
  else if iEP=5 then bEP:=$35
  else if iEP=6 then bEP:=$36
  else if iEP=7 then bEP:=$37
  else if iEP=8 then bEP:=$38;

  if isOn then bOnOff := $30 else bOnOff := $31;

  if (idLampu < 9) then bGroup := $31;
  if (idLampu > 8) AND (idLampu < 17) then bGroup := $32;
  if (idLampu > 16) AND (idLampu < 25) then bGroup := $33;

  if not(InitializeINTERFACE) then exit;
  setlength(pck,15);

  pck[0] := $72;
  pck[1] := $6F;
  pck[2] := $6E;
  pck[3] := $6F;
  pck[4] := $66;
  pck[5] := $66;
  pck[6] := $28;
  pck[7] := bOnOff;
  pck[8] := $2C;
  //pck[9] := $31; -
  pck[9] := bEP;
  pck[10] := $2C;
  //pck[11] := 31;  -
  pck[11] := bGroup;
  pck[12] := $29;
  pck[13] := $0D;
  pck[14] := $0A;
  //0D, 0A //end of line

  Send_CMD(pck);
  Sleep(300);

end;

function Relay_ON_wReply(idLampu:Integer; isOn:Boolean): TByteArr;
var pck, reply : TByteArr;
    iEP : Integer;
    bEP,bGroup, bOnOff: Integer;
begin

  iEP := idLampu mod 8;
  if iEP = 0 then iEP := 8;

  if iEP=1 then bEP:=$31
  else if iEP=2 then bEP:=$32
  else if iEP=3 then bEP:=$33
  else if iEP=4 then bEP:=$34
  else if iEP=5 then bEP:=$35
  else if iEP=6 then bEP:=$36
  else if iEP=7 then bEP:=$37
  else if iEP=8 then bEP:=$38;

  if isOn then bOnOff := $30 else bOnOff := $31;

  if (idLampu < 9) then bGroup := $31;
  if (idLampu > 8) AND (idLampu < 17) then bGroup := $32;
  if (idLampu > 16) AND (idLampu < 25) then bGroup := $33;

  if not(InitializeINTERFACE) then exit;
  setlength(pck,15);

  pck[0] := $72;
  pck[1] := $6F;
  pck[2] := $6E;
  pck[3] := $6F;
  pck[4] := $66;
  pck[5] := $66;
  pck[6] := $28;
  pck[7] := bOnOff;
  pck[8] := $2C;
  //pck[9] := $31; -
  pck[9] := bEP;
  pck[10] := $2C;
  //pck[11] := 31;  -
  pck[11] := bGroup;
  pck[12] := $29;
  pck[13] := $0D;
  pck[14] := $0A;
  //0D, 0A //end of line

  Send_CMD(pck);
  //Sleep(300);
  reply := uComBridge.ReadCMD;
  result := reply;
end;

{
procedure SendDoCMD2COM(aStr:String);
var pck : TByteArr;
    I,loop,lenData: Integer;
begin

  lenData := StrToInt(floattostr(Length(aStr) / 2));
  if not(InitializeINTERFACE) then exit;
  setlength(pck,lenData);

  //purestring
  //for I := 0 to Length(aStr) -1 do
  //begin
  //  pck[I] := StrToInt(copy(aStr,I+1,1));
  //end;

  //hex
  loop := 1;
  for I := 0 to lenData-1 do
  begin
    pck[I] := StrToInt('$'+copy(aStr,loop,2));
    loop := loop + 2;
  end;

  DO_CMD(pck,False,False,False);

end;

procedure SendCMD2COM(aStr:String);
var pck : TByteArr;
    I,loop,lenData: Integer;
begin

  lenData := StrToInt(floattostr(Length(aStr) / 2));
  if not(InitializeINTERFACE) then exit;
  setlength(pck,lenData);

  //purestring
  //for I := 0 to Length(aStr) -1 do
  //begin
  //  pck[I] := StrToInt(copy(aStr,I+1,1));
  //end;

  //hex
  aStr := TRIM(StringReplace(aStr,' ','',[rfReplaceAll, rfIgnoreCase]));
  loop := 1;
  for I := 0 to lenData-1 do
  begin
    pck[I] := StrToInt('$'+copy(aStr,loop,2));
    loop := loop + 2;
  end;

  Send_CMD(pck);
  Sleep(300);

end;

procedure GetGeneralRelaySet;
var aIniFile : TiniFile;
begin

  aIniFile := TiniFile.Create(ExtractFilePath(Application.ExeName)+'relay.ini');

    zSingleON := UpperCase(aIniFile.ReadString('GENERAL','singleon',''));
    zSingleOFF := UpperCase(aIniFile.ReadString('GENERAL','singleoff',''));
    zModeOn := UpperCase(aIniFile.ReadString('GENERAL','modeon',''));
    zModeOff := UpperCase(aIniFile.ReadString('GENERAL','modeoff',''));

  aIniFile.Free;

end;

procedure PerintahNyalaSingle(aIDLampu:String; blOn:Boolean);
var aIniFile : TiniFile;
    aCMD: String;
begin
  if (Trim(zSingleON) = '') OR (Trim(zSingleOFF) = '') then GetGeneralRelaySet;


  aIniFile := TiniFile.Create(ExtractFilePath(Application.ExeName)+'relay.ini');

  if blOn then
  begin
    aCMD := aIniFile.ReadString(zSingleON,aIDLampu,'');
  end else
  begin
    aCMD := aIniFile.ReadString(zSingleOFF,aIDLampu,'');
  end;

  SendCMD2COM(aCMD);

  aIniFile.Free;

end;

procedure PerintahNyalaMulti(aIDLampu:String; blOn:Boolean);
var aIniFile : TiniFile;
    aCMD,aListLampu,aModul: String;
    aList: TStringList;
    I,iLampu: Integer;
begin
  if (Trim(zModeOn) = '') OR (Trim(zModeOFF) = '') then GetGeneralRelaySet;

  aList := TStringList.Create;
  //aList.LineBreak := '';

  if blOn then
  begin
    aList.Text := uRtnSrv.GetListRoomUsed;
  end else
  begin
    //aList.Text := uRtnSrv.GetListRoomNotUsed;
    aList.Text := uRtnSrv.GetListRoomUsed;
  end;

  if copy(aIDLampu,1,1) = '0' then iLampu := StrToInt(copy(aIDLampu,2,Length(aIDLampu)-1))
  else iLampu := StrToInt(aIDLampu);
  aModul := '';

  if (iLampu < 5) then
  begin
    aListLampu := '';
    for I := 0 to aList.Count-1 do
    begin
        if (StrToInt(aList[I]) < 5 ) then
        begin
          aListLampu := aListLampu + TRIM(aList[I]);
          aModul := '1';
        end;
    end;
  end else
  if (iLampu > 4) AND (iLampu < 9) then
  begin
    aListLampu := '';
    for I := 0 to aList.Count-1 do
    begin
       if (StrToInt(aList[I]) > 4) AND (StrToInt(aList[I]) < 9 ) then
        begin
            aListLampu := aListLampu + TRIM(aList[I]);
            aModul := '2';
        end;
    end;
  end else
  if (iLampu > 8) AND (iLampu < 13) then
  begin
    aListLampu := '';
    for I := 0 to aList.Count-1 do
    begin
        if (StrToInt(aList[I]) > 8) AND (StrToInt(aList[I]) < 13 ) then
        begin
          aListLampu := aListLampu + TRIM(aList[I]);
          aModul := '3';
        end;
    end;
  end else
  if (iLampu > 12) AND (iLampu < 17) then
  begin
    aListLampu := '';
    for I := 0 to aList.Count-1 do
    begin
        if (StrToInt(aList[I]) > 12) AND (StrToInt(aList[I]) < 17 ) then
        begin
          aListLampu := aListLampu + TRIM(aList[I]);
          aModul := '4';
        end;
    end;
  end;

  aList.Free;

  aIniFile := TiniFile.Create(ExtractFilePath(Application.ExeName)+'relay.ini');

  if blOn then
  begin
    aCMD := aIniFile.ReadString(zModeON,aListLampu,'');
  end else
  begin
    //aCMD := aIniFile.ReadString(zModeOFF,aListLampu,'');
    aListLampu := StringReplace(aListLampu,aIDLampu,'',[rfReplaceAll, rfIgnoreCase]);
    aCMD := aIniFile.ReadString(zModeON,aListLampu,'');

    if (Trim(aCMD) = '') AND (aModul <> '') then
    begin
      //aCmd := aModul + '30';
      aCMD := aIniFile.ReadString('ALLOFF',aModul,'');
    end;
  end;

  //showmessage(aIDLampu+'|'+aCMD+#13+aListLampu);
  SendCMD2COM(aCMD);
  aIniFile.Free;
end;
}
end.
