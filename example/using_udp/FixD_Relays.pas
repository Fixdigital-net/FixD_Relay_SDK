unit FixD_Relays;

interface

type

// ====================================================================
TFDX_Init = function(iPort: Integer; StartUdpServer:Integer=1): integer; stdcall;
// Untuk initiate fungsi dan library
// Return value:
//	< 1 => Error (Termasuk 0, Nilai 1 keatas Success)
//	Opsi StartUdpServer, adalah utk start udp server. default started.
//  isi 0 jika tidak ingin start.

TFDX_Setting = function(EPPort:Integer; EPSn,EPKey:PChar; EPTipe: integer): integer; stdcall;
TFDX_Stop = function(): Integer; stdcall;
TFDX_SendCMD = function(aTujuan:PChar; aMessage:PChar; iPort:Integer): integer; stdcall;
TFDX_SwON = function(iNomor:Integer): integer; stdcall;
TFDX_SwOFF = function(iNomor:Integer): integer; stdcall;
TFDX_SwON_All = function(): integer; stdcall;
TFDX_SwOFF_All = function(): integer; stdcall;

TFDX_Reboot = function(): integer; stdcall;
TFDX_SetSecretKey = function(aOldSecret, aNewSecret:PChar): integer; stdcall;
TFDX_SetWifi_Sta = function(aStaName, aStaPass:PChar): integer; stdcall;
TFDX_SetWifi_Ap = function(aApName, aApPass:PChar): integer; stdcall;
TFDX_GetInfo = function(): integer; stdcall;


const
  FDXMSG_SUCCESS  : integer = 1;                                     // Success

  // Error codes ========================================================
  FDXMSG_ERROR_INSIDE_FUNCTION			    : integer = 0;
  FDXMSG_ERROR_BEFORE_START_FUNCTION    : integer = -1;


 var
  useUdpServer: Integer;
  FDX_Init          : TFDX_Init;
  FDX_Setting       : TFDX_Setting;
  FDX_Stop          : TFDX_Stop;
  FDX_SendCMD       : TFDX_SendCMD;
  FDX_SwON          : TFDX_SwON;
  FDX_SwOFF         : TFDX_SwOFF;
  FDX_SwON_All      : TFDX_SwON_All;
  FDX_SwOFF_All     : TFDX_SwOFF_All;
  FDX_Reboot        : TFDX_Reboot;
  FDX_SetSecretKey  : TFDX_SetSecretKey;
  FDX_SetWifi_Sta   : TFDX_SetWifi_Sta;
  FDX_SetWifi_Ap    : TFDX_SetWifi_Ap;
  FDX_GetInfo       : TFDX_GetInfo;

implementation

end.

