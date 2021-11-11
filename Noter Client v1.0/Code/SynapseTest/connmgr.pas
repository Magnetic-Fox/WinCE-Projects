{
 *  connmgr for WinCE
 *  Copyright (c)2007 Adrian Veith
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 }

unit connmgr;
interface
uses
  Windows;

  const
    External_library='cellcore'; {Setup as you need}

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  { 436EF144-B4FB-4863-A041-8F905A62C572 }
  {DEFINE_GUID(IID_DestNetInternet,     0x436ef144, 0xb4fb, 0x4863, 0xa0, 0x41, 0x8f, 0x90, 0x5a, 0x62, 0xc5, 0x72); }
  { A1182988-0D73-439e-87AD-2A5B369F808B }
  {DEFINE_GUID(IID_DestNetCorp,         0xa1182988, 0x0d73, 0x439e, 0x87, 0xad, 0x2a, 0x5b, 0x36, 0x9f, 0x80, 0x8b); }
  { 7022E968-5A97-4051-BC1C-C578E2FBA5D9 }
  {DEFINE_GUID(IID_DestNetWAP,          0x7022e968, 0x5a97, 0x4051, 0xbc, 0x1c, 0xc5, 0x78, 0xe2, 0xfb, 0xa5, 0xd9); }
  { F28D1F74-72BE-4394-A4A7-4E296219390C }
  {DEFINE_GUID(IID_DestNetSecureWAP,    0xf28d1f74, 0x72be, 0x4394, 0xa4, 0xa7, 0x4e, 0x29, 0x62, 0x19, 0x39, 0x0c); }
  { }


  const
    IID_DestNetInternet: GUID = (D1: $436ef144; D2: $b4fb; D3: $4863 ;D4: ($a0, $41, $8f, $90, $5a, $62, $c5, $72));
    IID_DestNetCorp: GUID = (D1: $a1182988; D2: $0d73; D3: $439e; D4: ($87, $ad, $2a, $5b, $36, $9f, $80, $8b));
    IID_DestNetWAP: GUID = (D1: $7022e968; D2: $5a97; D3: $4051; D4: ($bc, $1c, $c5, $78, $e2, $fb, $a5, $d9));
    IID_DestNetSecureWAP: GUID = (D1: $f28d1f74; D2: $72be; D3: $4394; D4: ($a4, $a7, $4e, $29, $62, $19, $39, $0c));
  
     CONNMGR_PARAM_GUIDDESTNET = $1;     { @constdefine guidDestNet field is valid }
     CONNMGR_PARAM_MAXCOST = $2;     { @constdefine MaxCost field is valid }
     CONNMGR_PARAM_MINRCVBW = $4;     { @constdefine MinRcvBw field is valid }
     CONNMGR_PARAM_MAXCONNLATENCY = $8;     { @constdefine MaxConnLatency field is valid }

  { ----------------------------------------------------------------------------- }

     CONNMGR_FLAG_PROXY_HTTP = $1;     { @constdefine HTTP Proxy supported }
     CONNMGR_FLAG_PROXY_WAP = $2;     { @constdefine WAP Proxy (gateway) supported }
     CONNMGR_FLAG_PROXY_SOCKS4 = $4;     { @constdefine SOCKS4 Proxy supported }
     CONNMGR_FLAG_PROXY_SOCKS5 = $8;     { @constdefine SOCKS5 Proxy supported }
  { ----------------------------------------------------------------------------- }
     CONNMGR_FLAG_SUSPEND_AWARE = $10;     { @constdefine suspended connections supported }
     CONNMGR_FLAG_REGISTERED_HOME = $20;     { @constdefine only dial out if we're registered on the home network }
     CONNMGR_FLAG_NO_ERROR_MSGS = $40;     { @constdefine don't show any error messages for failed connections }
     CONNMGR_FLAG_WAKE_ON_INCOMING = $80;     { @constdefine to satisfy request use only those interfaces that can wake the system on incoming traffic }
  { ----------------------------------------------------------------------------- }
     CONNMGR_PRIORITY_VOICE = $20000;
  { @constdefine Voice, highest priority, reserved for internal use only. }
     CONNMGR_PRIORITY_USERINTERACTIVE = $08000;     
  { @constdefine User initiated action caused this request, and UI is        	 }
  { currently pending on the creation of this connection. }
  { This is appropriate for an interactive browsing session, }
  { or if the user selects "MORE" at the bottom of a truncated }
  { mail message, etc. }
     CONNMGR_PRIORITY_USERBACKGROUND = $02000;     
  { @constdefine User initiated connection which has recently become idle. }
  { A connection should be marked as idle when it is no }
  { longer the user's current task.		 }
     CONNMGR_PRIORITY_USERIDLE = $0800;     
  { @constdefine Interactive user task which has been idle for an application }
  { specified time.  The application should toggle the state }
  { between CONNMGR_PRIORITY_USERIDLE and CONNMGR_PRIORITY_USERINTERACTIVE as the user }
  { uses the application.  This helps ConnectionManager }
  { optimize responsiveness to the interactive application, }
  { while sharing the connection with background applications. }
     CONNMGR_PRIORITY_HIPRIBKGND = $0200;     
  { @constdefine High priority background connection }
     CONNMGR_PRIORITY_IDLEBKGND = $0080;     
  { @constdefine Idle priority background connection }
     CONNMGR_PRIORITY_EXTERNALINTERACTIVE = $0020;     
  { @constdefine Connection is requested on behalf of an external entity, but }
  { is an interactive session (e.g. AT Command Iterpreter) }
     CONNMGR_PRIORITY_LOWBKGND = $0008;     
  { @constdefine Lowest priority. Only connects if another higher priority client is already using the same path. }
     CONNMGR_PRIORITY_CACHED = $0002;     
  { @constdefine Cached connection, reserved for internal use only. }
     CONNMGR_PRIORITY_ALWAYS_ON = $0001;     
  { @constdefine Always on  connection, reserved for internal use only. }
  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @struct CONNMGR_CONNECTIONINFO | Information about connection request }
  { }
  { @comm None }
  { }
  { ----------------------------------------------------------------------------- }
  { @field Size of this structure }
  { @field Valid parms, set of CONNMGR_PARAM_* }
  { @field Connection flags, set of CONNMGR_FLAG_* }
  { @field Priority, one of CONNMGR_PRIORITY_* }
  { @field Connection is exclusive, see comments }
  { @field Don't actually connect }
  { @field GUID of network to connect to }
  { @field hWnd to post status change messages to }
  { @field Msg to use when posting status changes }
  { @field lParam to use when posting status changes }
  { @field Max acceptable cost of connection }
  { @field Min acceptable receive bandwidth of connection }
  { @field Max acceptable connect latency }

  type

     _CONNMGR_CONNECTIONINFO = record
          cbSize : DWORD;
          dwParams : DWORD;
          dwFlags : DWORD;
          dwPriority : DWORD;
          bExclusive : BOOL;
          bDisabled : BOOL;
          guidDestNet : GUID;
          hWnd : HWND;
          uMsg : UINT;
          lParam : LPARAM;
          ulMaxCost : ULONG;
          ulMinRcvBw : ULONG;
          ulMaxConnLatency : ULONG;
       end;
     CONNMGR_CONNECTIONINFO = _CONNMGR_CONNECTIONINFO;

  { @comm bExclusive: If false, the connection is shared among all applications, and other }
  { applications with an interest in a connection to this network will be notified that }
  { the connection is available.  If true, then this connection can not be shared with other }
  { applications, and no other applications will be notified, and any application requesting }
  { a connection to the same network will be treated as a contender for }
  { the same resource, and not permitted to share the existing connection.  A decision will be made }
  { between this connection and the others based on connection priority. }
  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Creates a connection request. }
  { }
  { @comm Return Value:  S_OK if success, error code otherwise }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm Params describing requested connection }
  { @parm Returned connection handle }

  function ConnMgrEstablishConnection(var pConnInfo:CONNMGR_CONNECTIONINFO; var phConnection:HANDLE):HRESULT;external External_library name 'ConnMgrEstablishConnection';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Creates a connection request. }
  { }
  { @comm Return Value:  Same as ConnMgrEstablishConnection, but doesn't return }
  { until connection has either been established or failed. }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm Params describing requested connection }
  { @parm Returned connection handle }
  { @parm Timeout }
  { @parm Final status value, one of CONNMGR_STATUS_* }

  function ConnMgrEstablishConnectionSync(var pConnInfo:CONNMGR_CONNECTIONINFO; var phConnection:HANDLE; dwTimeout:DWORD; var pdwStatus:DWORD):HRESULT;external External_library name 'ConnMgrEstablishConnectionSync';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @constants Status values | Describes the current status of the connection }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }

  const
     CONNMGR_STATUS_UNKNOWN = $00;     { @constdefine Unknown status }
     CONNMGR_STATUS_CONNECTED = $10;     { @constdefine Connection is up }
     CONNMGR_STATUS_SUSPENDED = $11;     { @constdefine Connection is up but suspended }
     CONNMGR_STATUS_DISCONNECTED = $20;     { @constdefine Connection is disconnected }
     CONNMGR_STATUS_CONNECTIONFAILED = $21;     { @constdefine Connection failed and cannot not be reestablished }
     CONNMGR_STATUS_CONNECTIONCANCELED = $22;     { @constdefine User aborted connection }
     CONNMGR_STATUS_CONNECTIONDISABLED = $23;     { @constdefine Connection is ready to connect but disabled }
     CONNMGR_STATUS_NOPATHTODESTINATION = $24;     { @constdefine No path could be found to destination }
     CONNMGR_STATUS_WAITINGFORPATH = $25;     { @constdefine Waiting for a path to the destination }
     CONNMGR_STATUS_WAITINGFORPHONE = $26;     { @constdefine Voice call is in progress }
     CONNMGR_STATUS_PHONEOFF = $27;     { @constdefine Phone resource needed and phone is off }
     CONNMGR_STATUS_EXCLUSIVECONFLICT = $28;     { @constdefine the connection could not be established because it would multi-home an exclusive connection }
     CONNMGR_STATUS_NORESOURCES = $29;     { @constdefine Failed to allocate resources to make the connection. }
     CONNMGR_STATUS_CONNECTIONLINKFAILED = $2A;     { @constdefine Connection link disconnected prematurely. }
     CONNMGR_STATUS_AUTHENTICATIONFAILED = $2B;     { @constdefine Failed to authenticate user. }
     CONNMGR_STATUS_NOPATHWITHPROPERTY = $2C;     { @constdefine Path with connection having requested property, ex. WAKE_ON_INCOMING, is not available. }
     CONNMGR_STATUS_WAITINGCONNECTION = $40;     { @constdefine Attempting to connect }
     CONNMGR_STATUS_WAITINGFORRESOURCE = $41;     { @constdefine Resource is in use by another connection }
     CONNMGR_STATUS_WAITINGFORNETWORK = $42;     { @constdefine Network is used by higher priority thread or device is roaming. }
     CONNMGR_STATUS_WAITINGDISCONNECTION = $80;     { @constdefine Connection is being brought down }
     CONNMGR_STATUS_WAITINGCONNECTIONABORT = $81;     { @constdefine Aborting connection attempt }
  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Returns status about the current connection. }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm Handle to connection, returned from ConnMgrEstablishConnection }
  { @parm Returns current connection status, one of CONNMGR_STATUS_* }

  function ConnMgrConnectionStatus(hConnection:HANDLE; var pdwStatus:DWORD):HRESULT;external External_library name 'ConnMgrConnectionStatus';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Deletes specified connection request, potentially dropping the physical connection. }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm Handle to connection, returned from ConnMgrEstablishConnection }
  { @parm ConnMgr can cache connection }
  function ConnMgrReleaseConnection(hConnection:HANDLE; lCache:LONG):HRESULT;external External_library name 'ConnMgrReleaseConnection';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Changes a connection's priority. }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm Handle to connection, returned from ConnMgrEstablishConnection }
  { @parm New priority }
  function ConnMgrSetConnectionPriority(hConnection:HANDLE; dwPriority:DWORD):HRESULT;external External_library name 'ConnMgrSetConnectionPriority';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func General purpose (backdoor) API for exchanging information with planner or providers. }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm Optional, Handle to connection }
(* Const before type ignored *)
  { @parm Provider GUID }
  { @parm Optional index, used to address multiple providers associated with connection }
  { @parm General param 1 }
  { @parm General param 2 }
  { @param Pointer to params structure }
  { @param size of params structure }
  function ConnMgrProviderMessage(hConnection:HANDLE; var pguidProvider:GUID; pdwIndex:PDWORD; dwMsg1:DWORD; dwMsg2:DWORD;
             pParams:PBYTE; cbParamSize:ULONG):HRESULT;external External_library name 'ConnMgrProviderMessage';


  const
     CONNMGR_MAX_DESC = 128;     { @constdefine Max size of a network description }
  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @struct CONNMGR_DESTINATION_INFO | Information about a specific network }
  { }
  { @comm None }
  { }
  { ----------------------------------------------------------------------------- }
  { @field GUID associated with network }
  { @field Description of network }
  { @field Is it OK to allow multi-homing on the network }

  type

     _CONNMGR_DESTINATION_INFO = record
          guid : GUID;
          szDescription : array[0..(CONNMGR_MAX_DESC)-1] of TCHAR;
          fSecure : BOOL;
       end;
     CONNMGR_DESTINATION_INFO = _CONNMGR_DESTINATION_INFO;
  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Enumerates available networks. }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @param Index of network }
  { @param ptr to structure to fill in with info about network }

  function ConnMgrEnumDestinations(nIndex:longint; var pDestInfo:CONNMGR_DESTINATION_INFO):HRESULT;external External_library name 'ConnMgrEnumDestinations';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @struct SCHEDULEDCONNECTIONINFO | Information about a scheduled connection }
  { }
  { @comm None }
  { }
  { ----------------------------------------------------------------------------- }
  { @field Guid of network }
  { @field Starting time, same ref as filetime }
  { @field Ending time, same ref as filetime }
  { @field Period between schedule attempts }
  { @field App name to execute when scheduled }
  { @field Cmd line to execute when scheduled }
  { @field Unique token identifying this scheduled connection }
  { @field If true, execute app whenever network is available }

  type

     _SCHEDULEDCONNECTIONINFO = record
          guidDest : GUID;
          uiStartTime : UINT64;
          uiEndTime : UINT64;
          uiPeriod : UINT64;
          szAppName : array[0..(MAX_PATH)-1] of TCHAR;
          szCmdLine : array[0..(MAX_PATH)-1] of TCHAR;
          szToken : array[0..31] of TCHAR;
          bPiggyback : BOOL;
       end;
     SCHEDULEDCONNECTIONINFO = _SCHEDULEDCONNECTIONINFO;
  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Registers a scheduled connection }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @param Ptr to struct describing scheduled connection }

  function ConnMgrRegisterScheduledConnection(var pSCI:SCHEDULEDCONNECTIONINFO):HRESULT;external External_library name 'ConnMgrRegisterScheduledConnection';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Unregisters a scheduled connection }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @param Token of scheduled connection to unregister }
  function ConnMgrUnregisterScheduledConnection(pwszToken:LPCTSTR):HRESULT;external External_library name 'ConnMgrUnregisterScheduledConnection';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Maps a URL to a destination network GUID }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm URL to map }
  { @parm Returned network GUID }
  { @parm Index in table for next search }
  function ConnMgrMapURL(pwszURL:LPCTSTR; var pguid:GUID; pdwIndex: PDWORD):HRESULT;external External_library name 'ConnMgrMapURL';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Returns a handle to an event which becomes signaled when the ConnMgr API }
  { is ready to be used. Caller is responsible for calling CloseHandle on the returned event. }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  function ConnMgrApiReadyEvent:HANDLE;external External_library name 'ConnMgrApiReadyEvent';

  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @constants Defines the type of a connection reference }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @constdefine NAP connection reference }
  { @constdefine PROXY connection reference }

  type

     _ConnMgrConRefTypeEnum = (ConRefType_NAP = 0,ConRefType_PROXY
       );
     ConnMgrConRefTypeEnum = _ConnMgrConRefTypeEnum;
  { ----------------------------------------------------------------------------- }
  { }
  { @doc EXTERNAL }
  { }
  { @func Maps a connection reference to its corresponding GUID }
  { }
  { @comm none }
  { }
  { ----------------------------------------------------------------------------- }
  { @parm Specify type of connection reference }
  { @parm Connection reference to map }
  { @parm Returned connection reference GUID }

  function ConnMgrMapConRef(e:ConnMgrConRefTypeEnum; szConRef:LPCTSTR; var pGUID:GUID):HRESULT;external External_library name 'ConnMgrMapConRef';

  const
     CMPROXY_PROXYSERVER_MAXSIZE = 256;
     CMPROXY_USERNAME_MAXSIZE = 32;
     CMPROXY_PASSWORD_MAXSIZE = 32;
     CMPROXY_EXTRAINFO_MAXSIZE = 256;
     CMPROXY_PROXYOVERRIDE_MAXSIZE = 64;

     IID_ConnPrv_IProxyExtension: GUID = (D1: $af96b0bd; D2: $a481; D3: $482c; D4: ($a0, $94, $a8, $44, $87, $67, $a0, $c0));

  type

     _PROXY_CONFIG = record
          dwType : DWORD;
          dwEnable : DWORD;
          szProxyServer : array[0..(CMPROXY_PROXYSERVER_MAXSIZE)-1] of TCHAR;
          szUsername : array[0..(CMPROXY_USERNAME_MAXSIZE)-1] of TCHAR;
          szPassword : array[0..(CMPROXY_PASSWORD_MAXSIZE)-1] of TCHAR;
          szProxyOverride : array[0..(CMPROXY_PROXYOVERRIDE_MAXSIZE)-1] of TCHAR;
          szExtraInfo : array[0..(CMPROXY_EXTRAINFO_MAXSIZE)-1] of TCHAR;
       end;
     PROXY_CONFIG = _PROXY_CONFIG;
     
     { TConnection }

    TConnection = class
    private
      FPath: WideString;
      FWithProxy: Boolean;
      FhConnection: HANDLE;  // Connection Manager Handle
      FUseCache: Boolean;       // should we cache this connection when we 'hangup'
      FNetwork: GUID;     // the GUID for the network we are connecting to.
      FStatus: DWORD;      // last connection status
      FThreadStopEvent: HANDLE;  // Event
      FConnectionThread: HANDLE;    // Thread
      FProxyRequired: Boolean;
      FProxyInfo: PROXY_CONFIG;
      function CheckForRequiredProxy(hConn: HANDLE): Boolean;
      function GetCorpNetPath: Widestring;
      function GetInternetPath: Widestring;
      function GetProxyServer: Widestring;

    protected
      function DoStatusUpdate(dwStatus: DWORD): HRESULT; virtual;
      //
      // Override these methods
      //

      //
      // Called when we
      //
      function DoEstablishingConnection: HRESULT; virtual;
      
      //
      // Called when there was an error while connecting
      // generally due to network connection not being available (no modem, no nic etc).
      //
      function DoConnectingError: HRESULT; virtual;

      //
      // Called when a connection is now available.
      //
      function DoConnected: HRESULT; virtual;

      //
      // Called when the existing connection has been disconnected
      // by another network request. we return E_FAIL to hangup here
      //
      function DoDisconnected: HRESULT; virtual;

      //
      // Called when we are waiting for the network to become available.
      //
      function DoWaitingForConnection: HRESULT; virtual;

      //
      // Called when we have released the connection
      //
      function DoReleaseConnection: HRESULT; virtual;

      //
      // Sets the network GUID from a path.
      //
      function GetNetworkFromPath(const sPath: Widestring): HRESULT;

      //
      // Thread proc
      // Starts a connection to the network
      //
      function ConnectionThread: DWORD;

    public
      constructor Create;
      destructor Destroy; override;
      function IsAvailable(const sPath: Widestring = ''; bProxy: Boolean = FALSE): HRESULT;
      function AttemptConnect(const sPath: Widestring = ''; bProxy: Boolean =FALSE ): HRESULT;
      function HangupConnection: HRESULT;
      function IsProxyRequired: Boolean;
      
      property Connection: HANDLE read FhConnection;
      property Status: DWORD  read FStatus;
      property UseCache: Boolean read  FUseCache write FUseCache;
      property NetworkGuid: GUID read FNetwork;
      property WithProxy: Boolean read FWithProxy write FWithProxy;
      property NetworkPath: WideString read FPath;
      property ProxyServer: Widestring read GetProxyServer; //() { }

      property InternetPath: Widestring read GetInternetPath;
      property CorpNetPath: Widestring read GetCorpNetPath;


    end;

implementation

      // Rigged paths that will map  to the correct GUID.

  var
    TConnection_InternetPath: Widestring;
    TConnection_CorpNetPath: Widestring;
    
function SUCCEEDED(hr: HANDLE): Boolean; inline;
begin
  Result:= hr >= 0;
end;

function FAILED(hr: HANDLE): Boolean; inline;
begin
  Result:= hr < 0;
end;


{ TConnection }

function TConnection.CheckForRequiredProxy(hConn: HANDLE): Boolean;
begin
  FProxyRequired:= False;
  ZeroMemory(@FProxyInfo, sizeof(FProxyInfo));
  FProxyInfo.dwType:= CONNMGR_FLAG_PROXY_HTTP;
  if (SUCCEEDED(ConnMgrProviderMessage(   hConn,
                                          IID_ConnPrv_IProxyExtension,
                                          nil,
                                          0,
                                          0,
                                          PBYTE(@FProxyInfo),
                                          sizeof(FProxyInfo))))
  then begin
    if (FProxyInfo.dwType = CONNMGR_FLAG_PROXY_HTTP)
    then begin
        FProxyRequired:= TRUE;
       // SECURITY: Zero out the username/password from memory.
       ZeroMemory(@FProxyInfo.szUsername, sizeof(FProxyInfo.szUsername));
       ZeroMemory(@FProxyInfo.szPassword, sizeof(FProxyInfo.szPassword));
    end;
  end;
  Result:= FProxyRequired;
end;

function TConnection.GetCorpNetPath: Widestring;
begin
  Result:= TConnection_CorpNetPath;
end;

function TConnection.GetInternetPath: Widestring;
begin
  Result:= TConnection_InternetPath;
end;

function TConnection.GetProxyServer: Widestring;
begin
  if FProxyRequired then
    Result:= FProxyInfo.szProxyServer
  else
    Result:= '';
end;

function TConnection.DoStatusUpdate(dwStatus: DWORD): HRESULT;
begin
  Result:= S_OK;
  if (dwStatus and CONNMGR_STATUS_DISCONNECTED <> 0)
  then begin
    if ( dwStatus <> CONNMGR_STATUS_DISCONNECTED ) then
      Result:= DoConnectingError()
    else
      Result:= DoDisconnected();
    UseCache:=  dwStatus = CONNMGR_STATUS_DISCONNECTED;
  end else if ( dwStatus = CONNMGR_STATUS_CONNECTED )
  then begin
    Result:= DoConnected();
  end else if ( dwStatus and CONNMGR_STATUS_WAITINGCONNECTION <> 0)
  then begin
      Result:= DoWaitingForConnection();
  end;
end;

function TConnection.DoEstablishingConnection: HRESULT;
begin
  Result:= S_OK;
end;

function TConnection.DoConnectingError: HRESULT;
begin
  Result:= E_FAIL;
end;

function TConnection.DoConnected: HRESULT;
begin
  CheckForRequiredProxy(Connection);
  Result:= S_OK;
end;

function TConnection.DoDisconnected: HRESULT;
begin
  Result:= E_FAIL;
end;

function TConnection.DoWaitingForConnection: HRESULT;
begin
  Result:= S_OK;
end;

function TConnection.DoReleaseConnection: HRESULT;
begin
  Result:= S_OK;
end;

function TConnection.GetNetworkFromPath(const sPath: Widestring): HRESULT;
begin
  if sPath <> ''
  then begin
    FPath:= sPath;;
  end;
  Result:= ConnMgrMapURL(PWideChar(sPath), FNetwork, nil);
end;

function s_ConnectionThread(pData: Pointer): DWORD;
begin
  if TObject(pData) is TConnection then
    Result:= TConnection(pData).ConnectionThread
  else
    Result:= -1;
end;

function TConnection.ConnectionThread: DWORD;
var
  hThisThread: Handle;
  ConnInfo: CONNMGR_CONNECTIONINFO;
  hr: HRESULT;
  hObjects: array[0..1] of HANDLE;
  bStop: Boolean;
  dwResult: DWORD;
const
  cCacheTime: array[Boolean] of Integer = (0, 1);
begin
  hThisThread:= FConnectionThread;
  ZeroMemory(@ConnInfo, sizeof(ConnInfo));
  ConnInfo.cbSize:= sizeof(ConnInfo);
  ConnInfo.dwParams:= CONNMGR_PARAM_GUIDDESTNET;
  if WithProxy then
    ConnInfo.dwFlags:= CONNMGR_FLAG_PROXY_HTTP
  else
    ConnInfo.dwFlags:= 0;
  ConnInfo.dwPriority:= CONNMGR_PRIORITY_USERINTERACTIVE ;
  ConnInfo.guidDestNet:= NetworkGuid;

  hr:= ConnMgrEstablishConnection(ConnInfo, FhConnection);
  if  FAILED( hr )
  then begin
      DoConnectingError();
      UseCache:= FALSE;
  end else begin
      DoEstablishingConnection();

      hObjects[0]:= FhConnection;
      hObjects[1]:= FThreadStopEvent;
      bStop:=FALSE;

      ResetEvent(FThreadStopEvent);

      while( bStop = FALSE )
      do begin
          case WaitForMultipleObjects( 2, @hObjects, FALSE, INFINITE) of
            WAIT_OBJECT_0: begin
                hr:= ConnMgrConnectionStatus(FhConnection, FStatus);
                if( SUCCEEDED(hr))
                then begin
                  if DoStatusUpdate(Status) <> S_OK then
                    bStop:= TRUE;
                end else begin
                  FStatus:= hr;
                  bStop:= TRUE;
                end;
              end;
            else begin // failures, or signalled to stop.
              bStop:= TRUE;
              ResetEvent(FThreadStopEvent);
            end;
          end;
      end;
  end;
  DoReleaseConnection();

  // Release the connection, caching if we should.
  if( FhConnection <> 0 )
  then begin
    ConnMgrReleaseConnection(FhConnection, cCacheTime[UseCache]);
  end;

  CloseHandle(hThisThread);

  Result:= Status;

end;

constructor TConnection.Create;
begin
  FThreadStopEvent := CreateEvent(nil, FALSE, FALSE, nil);
  FConnectionThread := 0;
  FPath := '';
end;

destructor TConnection.Destroy;
begin
  HangupConnection();

  if( FThreadStopEvent <> 0 )
  then begin
      CloseHandle( FThreadStopEvent );
      FThreadStopEvent:= 0;
  end;

  inherited Destroy;
end;

function TConnection.IsAvailable(const sPath: Widestring; bProxy: Boolean
  ): HRESULT;
var
  bAvailable: Boolean;
  hConn: HANDLE;
  ci: CONNMGR_CONNECTIONINFO;
  dwStatus: DWORD;
begin
  Result:= GetNetworkFromPath(sPath);
  WithProxy:= bProxy;

  if (SUCCEEDED(Result))
  then begin
    bAvailable := FALSE;
    hConn := 0;

    ZeroMemory(@ci, sizeof(ci));
    ci.cbSize           := sizeof(ci);
    ci.dwParams         := CONNMGR_PARAM_GUIDDESTNET
                                or CONNMGR_PARAM_MAXCONNLATENCY;
    if bProxy then ci.dwFlags:= CONNMGR_FLAG_PROXY_HTTP else ci.dwFlags:= 0;
    ci.ulMaxConnLatency := 4000;         // 4 second
    ci.bDisabled        := TRUE;
    ci.dwPriority       := CONNMGR_PRIORITY_USERINTERACTIVE;
    ci.guidDestNet      := NetworkGuid;
    
    Result:= ConnMgrEstablishConnection(ci, hConn);
    if (SUCCEEDED(Result))
    then begin
      case WaitForSingleObject(hConn, 400) of
        WAIT_OBJECT_0: begin
            if ( SUCCEEDED(ConnMgrConnectionStatus(hConn, dwStatus)) and
                ( (dwStatus = CONNMGR_STATUS_CONNECTED) or (dwStatus = CONNMGR_STATUS_CONNECTIONDISABLED) ))
            then begin
                Result:= S_OK;
                CheckForRequiredProxy(hConn);
            end else begin
                Result:= S_FALSE;
            end;
          end;

        WAIT_TIMEOUT:
            Result:= E_FAIL;
      end;
      ConnMgrReleaseConnection(hConn, 0);
    end;
  end;

end;

function TConnection.AttemptConnect(const sPath: Widestring; bProxy: Boolean
  ): HRESULT;
var
  dwDummy: DWORD;
begin
  Result:= GetNetworkFromPath(sPath);
  WithProxy:= bProxy;

  if ( FThreadStopEvent = 0 )
  then begin
    Result:= E_INVALIDARG;
    exit;
  end;

  if( SUCCEEDED(Result) )
  then begin
    Result:= HangupConnection();
    if( SUCCEEDED ( Result ))
    then begin
        // kick off new thread,

        FConnectionThread := CreateThread(nil, 0, @s_ConnectionThread, Pointer(self), 0, dwDummy);

        if ( FConnectionThread = 0 ) then
          Result:= E_FAIL;
    end;
  end;
end;

function TConnection.HangupConnection: HRESULT;
begin
  if ( FConnectionThread <> 0 )
  then begin
    SetEvent(FThreadStopEvent);
			//wait a few seconds at most for the thread to die
		WaitForSingleObject(FConnectionThread, 3000);
    FConnectionThread:= 0;
  end;
  Result:= S_OK;
end;

function TConnection.IsProxyRequired: Boolean;
begin
  Result:= FProxyRequired;
end;


end.


