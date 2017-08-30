unit uComBridge;

interface
uses Winapi.Windows, System.SysUtils, Vcl.Dialogs;

type
  TByteArr = Array of byte;

  Function InitializeINTERFACE: Boolean;

  Function ReadCMD: TByteArr;
  Function Send_CMD(CMD: Array of byte): boolean;
  Function DO_CMD(CMD_in: array of byte;ADD_CRC,ADD_EOq:boolean;READ_REPLY:Boolean): Boolean;

  function CRC16Qualcomm(aMSL: String;sEOQ:Byte):String;

const
  MaxEnumComNum = 25;
  Q0_Refresh: ARRAY[1..3] OF BYTE= ($7E,$7E,$7E);

  EOQ = $7E;
  STX = $02;
  SEPQ = $00;
  EOT = $04;

var
  xComPortNum : integer;
  xPortNum : integer;

implementation
uses uComPort;

function HexB (b: Byte): String;
 const HexChar: Array[0..15] of Char = '0123456789ABCDEF';
begin
  result:= HexChar[b shr 4]+HexChar[b and $0f];
end;

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

function CRC16_Calc0(DataPtr: Pointer; DataLen: Integer): Word;
const    CRC16_arr : array[Byte] of Word =
    ($0000, $1189, $2312, $329b, $4624, $57ad, $6536, $74bf,
     $8c48, $9dc1, $af5a, $bed3, $ca6c, $dbe5, $e97e, $f8f7,
     $1081, $0108, $3393, $221a, $56a5, $472c, $75b7, $643e,
     $9cc9, $8d40, $bfdb, $ae52, $daed, $cb64, $f9ff, $e876,
     $2102, $308b, $0210, $1399, $6726, $76af, $4434, $55bd,
     $ad4a, $bcc3, $8e58, $9fd1, $eb6e, $fae7, $c87c, $d9f5,
     $3183, $200a, $1291, $0318, $77a7, $662e, $54b5, $453c,
     $bdcb, $ac42, $9ed9, $8f50, $fbef, $ea66, $d8fd, $c974,
     $4204, $538d, $6116, $709f, $0420, $15a9, $2732, $36bb,
     $ce4c, $dfc5, $ed5e, $fcd7, $8868, $99e1, $ab7a, $baf3,
     $5285, $430c, $7197, $601e, $14a1, $0528, $37b3, $263a,
     $decd, $cf44, $fddf, $ec56, $98e9, $8960, $bbfb, $aa72,
     $6306, $728f, $4014, $519d, $2522, $34ab, $0630, $17b9,
     $ef4e, $fec7, $cc5c, $ddd5, $a96a, $b8e3, $8a78, $9bf1,
     $7387, $620e, $5095, $411c, $35a3, $242a, $16b1, $0738,
     $ffcf, $ee46, $dcdd, $cd54, $b9eb, $a862, $9af9, $8b70,
     $8408, $9581, $a71a, $b693, $c22c, $d3a5, $e13e, $f0b7,
     $0840, $19c9, $2b52, $3adb, $4e64, $5fed, $6d76, $7cff,
     $9489, $8500, $b79b, $a612, $d2ad, $c324, $f1bf, $e036,
     $18c1, $0948, $3bd3, $2a5a, $5ee5, $4f6c, $7df7, $6c7e,
     $a50a, $b483, $8618, $9791, $e32e, $f2a7, $c03c, $d1b5,
     $2942, $38cb, $0a50, $1bd9, $6f66, $7eef, $4c74, $5dfd,
     $b58b, $a402, $9699, $8710, $f3af, $e226, $d0bd, $c134,
     $39c3, $284a, $1ad1, $0b58, $7fe7, $6e6e, $5cf5, $4d7c,
     $c60c, $d785, $e51e, $f497, $8028, $91a1, $a33a, $b2b3,
     $4a44, $5bcd, $6956, $78df, $0c60, $1de9, $2f72, $3efb,
     $d68d, $c704, $f59f, $e416, $90a9, $8120, $b3bb, $a232,
     $5ac5, $4b4c, $79d7, $685e, $1ce1, $0d68, $3ff3, $2e7a,
     $e70e, $f687, $c41c, $d595, $a12a, $b0a3, $8238, $93b1,
     $6b46, $7acf, $4854, $59dd, $2d62, $3ceb, $0e70, $1ff9,
     $f78f, $e606, $d49d, $c514, $b1ab, $a022, $92b9, $8330,
     $7bc7, $6a4e, $58d5, $495c, $3de3, $2c6a, $1ef1, $0f78);
var
  i: Integer;
begin
  Result := $ffff;
  while ((PByte(DataPtr)^)=$7e)
    do
      begin
        Inc(PByte(DataPtr));
        Dec(DataLen);
      end;
  for i := 0 to DataLen - 1 do
  begin
    Result := CRC16_arr[Byte(Result xor PByte(DataPtr)^)] xor
              ((Result shr 8) and $0ff);
    Inc(PByte(DataPtr));
  end;
  Result := Result Xor $ffff;
end;

Procedure QAPPEND_CRC(var CMD: TByteArr; CHKsum: word);
var
  crc1,crc2: byte;
  len: integer;
begin
  crc1 := (CHKsum ) ;
  crc2 := (CHKsum Shr 8) and $00FF ;
  len := Length(CMD);
  len := Len+1;
  SetLength(CMD,Len);
  CMD[Len-1] :=  crc1;
  len := Len+1;
  SetLength(CMD,Len);
  CMD[Len-1] :=  crc2;
end;

Function QSerialize(DataPtr:TByteArr): TByteArr;
var buf1: TByteArr;
  i, offset, DataLEn : integer;
begin
  offset := 0;
  DataLEn := Length(DataPtr);
  SetLength(buf1,DataLEn);
  for i:=0 to DataLEn-1 do
      begin
        case (DataPTR[i]) of
          $7e : if i=0 then buf1[i+offset] := DataPtr[i]
                else
                begin
                  setlength (buf1,length(buf1)+1);
                  buf1[i+offset] := $7d;
                  Inc(offset);
                  buf1[i+offset] := $5e;
                end;
          $7d : begin
                  setlength (buf1,length (buf1)+1);
                  buf1[i+offset] := $7d;
                  Inc(offset);
                  buf1[i+offset] := $5d;
                end;
          else buf1[i+offset] := DataPtr[i];
        end;
    end;
  result := buf1;
end;

function CRC16Qualcomm(aMSL: String;sEOQ:Byte):String;
const ADD_CRC : Boolean = True;
      ADD_EOq : Boolean = True;
var
  CMD_in : array of byte;
  I,lenH,loop, len : integer;
  CHKsum : word;
  CMD : TByteArr;
  aOut: string;
  DataPtr : pointer;
  DataLen: Integer;
begin
  aMSL := TRIM(StringReplace(aMSL,' ','',[rfReplaceAll, rfIgnoreCase]));

  lenH := StrToInt(FloatToStr(Length(aMSL) / 2));

    SetLength(CMD_in,lenH);
    loop := 1;
    for I := 0 to lenH-1 do
    begin
      CMD_in[I] := StrToInt('$'+copy(aMSL,loop,2));
      loop := loop + 2;
    end;

  len := lenH;
  if len = 0 then exit;

  SetLength(CMD,len);
  for i:=0 to len-1 do CMD[i] := CMD_in[i];

  DataPtr := CMD;
  DataLen := Len;

  while ((PByte(DataPtr)^)=$7e) do
  begin
    Inc(PByte(DataPtr));
    Dec(DataLen);
  end;

  if ADD_CRC then
  begin
    CHKsum := CRC16_Calc0(DataPtr, DataLen);
  end;

  if ADD_CRC then QAPPEND_CRC(CMD,CHKsum);
  CMD := QSerialize(CMD);
  len:=  Length(CMD);

    if ADD_EOq then
    begin
      if (CMD[len-1] <> sEOq) then
      begin
            len := Len+1;
            SetLength(CMD,len);
            CMD[len-1] := sEOq;
      end;
    end;
  aOut := '';
  for I := 0 to Length(CMD) - 1 do
    begin
      aOut := aOut + HexB(CMD[I]);
    end;
    Result := aOut;
end;

Function QUN_Serialize(DataPtr:TByteArr): TByteArr;
var
  buf1: TByteArr;
  i, offset, DataLEn : integer;
  sel: boolean;
begin
  sel := false;
  offset := 0;
  DataLEn := Length(DataPtr);
  SetLength(buf1,DataLEn);

  for i:=0 to DataLEn-2 do
        case DataPTR[i] of
            $7d : begin
                    setlength (buf1,length(buf1)-1);
                    Inc(offset);
                    sel := true;
                  end;
            $5d : begin
                    if sel then buf1[i-offset] := $7d
                       else buf1[i-offset] := $5d;
                    sel := false;
                  end;
            $5e : begin
                    if sel then buf1[i-offset] := $7e
                       else buf1[i-offset] := $5e;
                    sel := false;
                  end;
            else buf1[i-offset] := DataPtr[i];
        end;
  result := buf1;
end;

function ZComOpen : integer;
begin
  result := 0;
  if xportnum > MaxEnumComNum then
  begin
    if GetComStat then
    begin
      result := 0;
      exit;
    end;

    result := OpenCom(True);
  end;
end;

Procedure Z_INTERFACE_CLOSE;
begin
  if (ComNum<>0) then    // COM
      begin
       if GetComStat then
          begin
            CloseCom;
            //Form1.MemLog.Lines.Add('<COM'+IntToStr(ComNum)+' interface closed>');
          end;
      end;
end;

Function InitializeINTERFACE: Boolean;
begin
  result := False;

  if xComPortNum = 0 then
     begin
       ShowMessage('Error: Koneksi belum dipilih!');
       exit;
     end;

  try
    if xComPortNum = 0 then
       begin
        ShowMessage('- Interface Speed auto-set : 115200 b/s');
        ComBaud := 115200;
       end;

    ChangeComSpeed(ComBaud);

    if ZComOpen <> 0 then
       begin
         ShowMessage('Error: Koneksi sedang digunakan!');
         Z_INTERFACE_CLOSE;
         exit;
       end;

    result := True;

  except
    //nothing
  end;
end;

Procedure Debugga(typ: shortint;arr: array of byte);
var
  len: integer;
  str : String;
begin
  //with Form1 do
    begin
    len := length(arr);
    if (len > 0)  then
      begin
        str := IntToStr(len)+'> ';
        while length(str)< 5 do
              str := '0'+str;
        case typ of
          0 : begin
                str := '<len:'+str;
                //Form1.MemLog.Lines.Add(str+IntArray2HexSTR(arr)+'   ');
              end;
          2 : begin
                str := '<TX:'+str;
                //Form1.MemLog.Lines.Add(str+IntArray2ASCIISTR(arr));
                //AForm1.MemLog.Lines.Add(str+IntArray2HexSTR(arr));
              end;
          3 : begin
                str := '<RX:'+str;
                //AddLinesLog(str+IntArray2ASCIISTR(arr));
                //AddLinesLog(str+IntArray2HexSTR(arr));
              end;
          4 : begin
              str := '<len:'+str;
              //AddLinesLog(str+IntArray2ASCIISTR(arr));
              //AddLinesLog(str+IntArray2HexSTR(arr));
              end;
          else ShowMessage(IntArray2HexSTR(arr));
        end
      end
    //else ShowMessage('- Phone Not Connected');

  end;
end;

Function Send_CMD(CMD: Array of byte): boolean;
begin
  result := False;

  if not(InitializeINTERFACE) then exit;
  if (length(CMD) = 0) then
      begin
        //Form1.MemLog.Lines.Add('- Not Connected'+IntArray2HexSTR(CMD));
        exit;
      end;

  Debugga(2,CMD);

  if COMnum > 0 then      //COM
     begin
       result := WriteCom(@CMD, length(CMD));
       exit;
     end
end;


function Z_PurgeCom(mode:DWord): boolean;
begin
  result := False;
  if xportnum = 0 then exit;
  if xportnum > MaxEnumComNum then      //COM
     begin
       result := PurgeCom(mode);
       exit;
     end
end;

Function ReadCMD: TByteArr;
var
  buffy: Array [0..4] of byte;
  reply : TByteArr;
  i, count : integer;
begin
  i:= 1;
  count:=0;

  if ComNum > 0 then        //COM
     while ReadCom(@buffy, 4) do
        begin
          i := 0;
          while i<length(buffy)-1 do
            begin
              count := count+1;
              setlength(reply,count);
              reply[count-1] := buffy[i];
              Inc(i);
            end;
        end;

  result := QUN_Serialize(reply);

  if count = 0 then Z_PurgeCom(PURGE_RXCLEAR) ;
  if not Z_PurgeCom(PURGE_RXCLEAR) then ShowMessage('- Error after read');

  Debugga(3,reply);

END;

Function DO_CMD(CMD_in: array of byte;ADD_CRC,ADD_EOq:boolean;READ_REPLY:Boolean): Boolean;
var
  i, j, len, DataLen: integer;
  str : String;
  CHKsum : word;
  CMD,reply : TByteArr;
  DataPtr : pointer;
begin
  str:='';
  DO_CMD := False;
  len := length(CMD_in);
  if len = 0 then exit;
  SetLength(CMD,len);
  for i:=0 to len-1 do CMD[i] := CMD_in[i];

  DataPtr :=  CMD;
  DataLen := Len;
  while ((PByte(DataPtr)^)=$7e) do
      begin
        Inc(PByte(DataPtr));
        Dec(DataLen);
      end;

  if ADD_CRC then
    begin
      CHKsum := CRC16_Calc0(DataPtr, DataLen);
      len := length(CMD);
    end;

  if ADD_CRC then QAPPEND_CRC(CMD,CHKsum);
  CMD := QSerialize(CMD);
  len:=  Length(CMD);

  if ADD_EOq then
     begin
      if (CMD[len-1] <> EOq) then
          begin
            len := Len+1;
            SetLength(CMD,len);
            CMD[len-1] := EOq;
          end;
      end;

  if str<>'' then ShowMessage(str);
  if Send_CMD(CMD) then DO_CMD := True
     else exit;

  if READ_REPLY then
     begin
       DO_CMD := False;
       reply := ReadCMD;
       i:=0;
       j:=0;

       if (length(reply)=0) then
          begin
            //Main.AddLinesLog('Reply = '+IntArray2HexSTR(CMD));
            Send_CMD(Q0_Refresh);
            reply := ReadCMD;
            if (length(reply)=0) then
                begin
                  ShowMessage('- Phone Delay Err..');
                  ShowMessage('- Please Try again');
                  exit;
                end;
          end;

        while reply[i] = $7e do Inc(i);
        while CMD[j] = $7e do Inc(j);

        if reply[0]=$13 then
           begin
             ShowMessage('- Phone State NOT Supported.');
             DO_CMD := False;
             exit;
           end;

        if CMD[j]=reply[i] then
           begin
             DO_CMD := True;
             exit;
           end
        else if (length(reply)=4) then
                case reply[i] of
                  $02 : begin
                          DO_CMD := True;
                          exit;
                        end;
                  $03 : ShowMessage('- ERR_ILLEGAL_MODE');
                  $13 : ShowMessage('- ERR_CMD_NOT_ALLOWED');
                  $14 : ShowMessage('- ERR_SYNTAX_ERR');
                  $15 : ShowMessage('- ERR_illegal_DATA');
                  else  ShowMessage('- ERR_ACK NO Reply: ? ? ? !');
                end
        else if reply[i] = $03 then ShowMessage('- ERR_ILLEGAL_MODE');
     end;
end;


end.
