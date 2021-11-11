{
 *  CePowerMan - WinCE Powermanger API
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
unit CePowerMan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, syncobjs;


const
  POWER_STATE_MASK      = $FFFF0000;  // power state mask
  POWER_STATE_ON        = $00010000;  // on state
  POWER_STATE_OFF       = $00020000; // no power, full off
  POWER_STATE_CRITICAL  = $00040000; // critical off
  POWER_STATE_BOOT      = $00080000; // boot state
  POWER_STATE_IDLE      = $00100000; // idle state
  POWER_STATE_SUSPEND   = $00200000; // suspend state
  POWER_STATE_RESET     = $00800000; // reset state

  PBT_TRANSITION          = $00000001; // broadcast specifying system power state transition
  PBT_RESUME              = $00000002; // broadcast notifying a resume, specifies previous state
  PBT_POWERSTATUSCHANGE   = $00000004; // power supply switched to/from AC/DC
  PBT_POWERINFOCHANGE     = $00000008; // some system power status field has changed

// OEMS may define power notifications starting with this ID and
// going up by powers of 2.
  PBT_OEMBASE             = $00010000;

// This bitmask indicates that an application would like to receive all
// types of power notifications.
  POWER_NOTIFY_ALL = $FFFFFFFF;

  MSGQUEUE_NOPRECOMMIT = $00000001;
  MSGQUEUE_ALLOW_BROKEN = $00000002;
  MSGQUEUE_MSGALERT = $00000001;
  
  
type

  MSGQUEUEOPTIONS = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwMaxMessages: DWORD;
    cbMaxMessage: DWORD;
    bReadAccess: BOOL;
  end;
  PMSGQUEUEOPTIONS = ^MSGQUEUEOPTIONS;
  TMSGQUEUEOPTIONS = MSGQUEUEOPTIONS;
  POWER_BROADCAST = record
    Message: DWORD;
    Flags: DWORD;
    Length: DWORD;
    SystemPowerState: array[0..0] of WCHAR;
  end;
  PPOWER_BROADCAST = ^POWER_BROADCAST;
  TPOWER_BROADCAST = POWER_BROADCAST;
  CEDEVICE_POWER_STATE = (  PwrDeviceUnspecified = -1,
    D0 = 0,
    D1,
    D2,
    D3,
    D4,
    PwrDeviceMaximum);
  PCEDEVICE_POWER_STATE = ^CEDEVICE_POWER_STATE;
  TCEDEVICE_POWER_STATE = CEDEVICE_POWER_STATE;
  POWER_BROADCAST_POWER_INFO = record
    dwBatteryLifeTime: DWORD;
    dwBatteryFullLifeTime: DWORD;
    dwBackupBatteryLifeTime: DWORD;
    dwBackupBatteryFullLifeTime: DWORD;
    bACLineStatus: BYTE;
    bBatteryFlag: BYTE;
    bBatteryLifePercent: BYTE;
    bBackupBatteryFlag: BYTE;
    bBackupBatteryLifePercent: BYTE;
  end;
  PPOWER_BROADCAST_POWER_INFO = ^POWER_BROADCAST_POWER_INFO;
  TPOWER_BROADCAST_POWER_INFO = POWER_BROADCAST_POWER_INFO;
  
  TPowerNotify = procedure(var ABroadcast: TPOWER_BROADCAST; var AInfo: TPOWER_BROADCAST_POWER_INFO; AInfoIsValid: Boolean) of object;
  TPowerLogEvent = procedure(const AMess: string) of object;
  { TPowerMessageThread }

  TPowerMessageThread = class(TThread)
  private
    FMsgQueue: HANDLE;
    FEventStop: THandle;
    FHandleMsg: HANDLE;
    FOnLogEvent: TPowerLogEvent;
    FOnPowerMessage: TPowerNotify;
    FBroadcast: TPOWER_BROADCAST;
    FInfo: TPOWER_BROADCAST_POWER_INFO;
    FInfoIsValid: Boolean;
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
    procedure ReadPowerMessage(AQue: THANDLE);
    procedure CallPowerMessage;
    procedure Log(const AMess: string);
  public
    constructor Create(ANotify: TPowerNotify);
    destructor Destroy; override;
    property OnPowerMessage: TPowerNotify read FOnPowerMessage write FOnPowerMessage;
    property OnLogEvent: TPowerLogEvent read FOnLogEvent write FOnLogEvent;
  end;
  
function RequestPowerNotifications(hMsgQ: HANDLE; Flags: DWORD): HANDLE; external KernelDLL name 'RequestPowerNotifications';
function StopPowerNotifications(h: HANDLE): BOOL; external KernelDLL name 'StopPowerNotifications';
function CreateMsgQueue(lpszName: LPCWSTR; var lpOptions: TMSGQUEUEOPTIONS): HANDLE; external KernelDLL name 'CreateMsgQueue';
function ReadMsgQueue(hMsgQ: HANDLE; lpBuffer: LPVOID; cbBufferSize: DWORD; var lpNumberOfBytesRead: DWORD; dwTimeout: DWORD; var pdwFlags: DWORD): BOOL; external KernelDLL name 'ReadMsgQueue';
function CloseMsgQueue(hMsgQ: HANDLE): BOOL; external KernelDLL name 'CloseMsgQueue';
function CeRunAppAtTime(pwszAppName: LPCWSTR; pTime: PSYSTEMTIME): BOOL; external KernelDLL name 'CeRunAppAtTime';
implementation

{ TPowerMessageThread }

procedure TPowerMessageThread.Execute;
var
  Msg: TMsg;
  WaitHandles : array[0..1] of THandle;
  hQue: THANDLE;
  QueOpt: TMSGQUEUEOPTIONS;
begin
  QueOpt.dwSize:= sizeof(TMSGQUEUEOPTIONS);
  QueOpt.dwFlags:= 0; //MSGQUEUE_NOPRECOMMIT;
  QueOpt.dwMaxMessages:= 20;
  QueOpt.cbMaxMessage:= 1024;
  QueOpt.bReadAccess:= True;
  try
    hQue:= CreateMsgQueue('PowerMsgQ', QueOpt);
    try
      //CallPowerMessage;
      while not Terminated do begin
        {if WaitForSingleObject(FMsgQueue, 1000) = 0 then begin
          ReadPowerMessage(hQue);
        end;}
        WaitHandles[1]:= FEventStop;
        WaitHandles[0]:= FMsgQueue;
        case MsgWaitForMultipleObjects(2, @WaitHandles, False, INFINITE, QS_SENDMESSAGE) of
          WAIT_OBJECT_0 + 1: begin
            Terminate;
          end;
          WAIT_OBJECT_0 + 0: begin
            ReadPowerMessage(hQue);
          end;
          WAIT_OBJECT_0+2:
            PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE)
        end;
        //CallPowerMessage;
      end;
    finally
      CloseHandle(hQue);
    end;
  except
  end;
end;

procedure TPowerMessageThread.DoTerminate;
begin
  inherited DoTerminate;
end;

procedure TPowerMessageThread.ReadPowerMessage(AQue: THANDLE);
var
  buffer: array[0..1023] of byte;
  readBytes, readFlags: DWORD;
  pBroadcast: PPOWER_BROADCAST;
begin
  if ReadMsgQueue(AQue, @buffer[0], sizeof(buffer), readBytes, 500, readFlags)
  then begin
    pBroadcast:= @buffer[0];
    if Assigned(FOnPowerMessage) then begin
      FBroadcast:= pBroadcast^;
      FInfoIsValid:= (pBroadcast^.Flags AND PBT_POWERINFOCHANGE <> 0) AND (pBroadcast^.Length = sizeof(POWER_BROADCAST_POWER_INFO));
      if FInfoIsValid then
        FInfo:= PPOWER_BROADCAST_POWER_INFO(@pBroadcast^.SystemPowerState)^;
      CallPowerMessage;
      //Synchronize(@CallPowerMessage);
    end;
  end;
end;

procedure TPowerMessageThread.CallPowerMessage;
begin
  if Assigned(FOnPowerMessage) then
    FOnPowerMessage(FBroadcast, FInfo, FInfoIsValid);
end;

procedure TPowerMessageThread.Log(const AMess: string);
begin
  if Assigned(FOnLogEvent) then
    FOnLogEvent(AMess);
end;

constructor TPowerMessageThread.Create(ANotify: TPowerNotify);
var
  QueOpt: TMSGQUEUEOPTIONS;
begin
  QueOpt.dwSize:= sizeof(TMSGQUEUEOPTIONS);
  QueOpt.dwFlags:= 0; //MSGQUEUE_NOPRECOMMIT;
  QueOpt.dwMaxMessages:= 20;
  QueOpt.cbMaxMessage:= 1024;
  QueOpt.bReadAccess:= False;
  FMsgQueue:= CreateMsgQueue('PowerMsgQ', QueOpt);
  FEventStop:= CreateEvent(nil, False, False, nil);
  FHandleMsg:= RequestPowerNotifications(FMsgQueue, PBT_TRANSITION);
  OnPowerMessage:= ANotify;
  inherited Create(False);
end;

destructor TPowerMessageThread.Destroy;
begin
  Terminate;
  Windows.SetEvent(FEventStop);
  inherited Destroy;
  StopPowerNotifications(FHandleMsg);
  CloseHandle(FMsgQueue);
  CloseHandle(FEventStop);
end;

end.

