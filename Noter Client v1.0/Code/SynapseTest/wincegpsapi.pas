{
 *  winceGpsAPI - WinCE GPS API
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
unit winceGpsAPI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows;

const
  GPSAPI_DLL = 'GPSAPI';
  GPS_MAX_SATELLITES = 12;
  GPS_MAX_PREFIX_NAME = 16;
  GPS_MAX_FRIENDLY_NAME = 64;
  GPS_VERSION_1 = 1;
  GPS_VALID_UTC_TIME = $00000001;
  GPS_VALID_LATITUDE = $00000002;
  GPS_VALID_LONGITUDE = $00000004;
  GPS_VALID_SPEED = $00000008;
  GPS_VALID_HEADING = $00000010;
  GPS_VALID_MAGNETIC_VARIATION = $00000020;
  GPS_VALID_ALTITUDE_WRT_SEA_LEVEL = $00000040;
  GPS_VALID_ALTITUDE_WRT_ELLIPSOID = $00000080;
  GPS_VALID_POSITION_DILUTION_OF_PRECISION = $00000100;
  GPS_VALID_HORIZONTAL_DILUTION_OF_PRECISION = $00000200;
  GPS_VALID_VERTICAL_DILUTION_OF_PRECISION = $00000400;
  GPS_VALID_SATELLITE_COUNT = $00000800;
  GPS_VALID_SATELLITES_USED_PRNS = $00001000;
  GPS_VALID_SATELLITES_IN_VIEW = $00002000;
  GPS_VALID_SATELLITES_IN_VIEW_PRNS = $00004000;
  GPS_VALID_SATELLITES_IN_VIEW_ELEVATION = $00008000;
  GPS_VALID_SATELLITES_IN_VIEW_AZIMUTH = $00010000;
  GPS_VALID_SATELLITES_IN_VIEW_SIGNAL_TO_NOISE_RATIO = $00020000;
  GPS_DATA_FLAGS_HARDWARE_OFF = $00000001;
  

type
  GPS_FIX_TYPE = (GPS_FIX_UNKNOWN, GPS_FIX_2D, GPS_FIX_3D);
  GPS_FIX_SELECTION = (GPS_FIX_SELECTION_UNKNOWN, GPS_FIX_SELECTION_AUTO, GPS_FIX_SELECTION_MANUAL);
  GPS_FIX_QUALITY = (GPS_FIX_QUALITY_UNKNOWN, GPS_FIX_QUALITY_GPS, GPS_FIX_QUALITY_DGPS);
  TGpsValidValue = (gvUTC_TIME,gvLATITUDE,gvLONGITUDE,gvSPEED,gvHEADING,gvMAGNETIC_VARIATION,
    gvALTITUDE_WRT_SEA_LEVEL,gvALTITUDE_WRT_ELLIPSOID,
    gvPOSITION_DILUTION_OF_PRECISION,gvHORIZONTAL_DILUTION_OF_PRECISION,
    gvVERTICAL_DILUTION_OF_PRECISION,gvSATELLITE_COUNT,gvSATELLITES_USED_PRNS,
    gvSATELLITES_IN_VIEW,gvSATELLITES_IN_VIEW_PRNS,gvSATELLITES_IN_VIEW_ELEVATION,
    gvSATELLITES_IN_VIEW_AZIMUTH,gvSATELLITES_IN_VIEW_SIGNAL_TO_NOISE_RATIO);
  TGpsValidValues = set of TGpsValidValue;
  GpsFloat = Windows.float;
  GPS_POSITION = record
   dwVersion: DWORD;
   dwSize: DWORD;

   dwValidFields: DWORD;

   dwFlags: DWORD;

   stUTCTime: SYSTEMTIME ;

   dblLatitude: double;
   dblLongitude: double;
   flSpeed: GpsFloat;
   flHeading: GpsFloat;
   dblMagneticVariation: double;
   flAltitudeWRTSeaLevel: GpsFloat;
   flAltitudeWRTEllipsoid: GpsFloat;

   FixQuality: GPS_FIX_QUALITY;
   FixType: GPS_FIX_TYPE;
   SelectionType: GPS_FIX_SELECTION;
   flPositionDilutionOfPrecision: GpsFloat;
   flHorizontalDilutionOfPrecision: GpsFloat;
   flVerticalDilutionOfPrecision: GpsFloat;

   dwSatelliteCount: DWORD;
   rgdwSatellitesUsedPRNs: array [0..GPS_MAX_SATELLITES -1] of DWORD;

   dwSatellitesInView: DWORD;
   rgdwSatellitesInViewPRNs: array [0..GPS_MAX_SATELLITES -1] of DWORD;
   rgdwSatellitesInViewElevation: array [0..GPS_MAX_SATELLITES -1] of DWORD;
   rgdwSatellitesInViewAzimuth: array [0..GPS_MAX_SATELLITES -1] of DWORD;
   rgdwSatellitesInViewSignalToNoiseRatio: array [0..GPS_MAX_SATELLITES -1] of DWORD;
  end;
  GPS_DEVICE = record
   dwVersion: DWORD;
   dwSize: DWORD;
   dwServiceState: DWORD;
   dwDeviceState: DWORD;
   ftLastDataReceived: FILETIME;
   szGPSDriverPrefix: array [0..GPS_MAX_PREFIX_NAME -1] of WCHAR;
   szGPSMultiplexPrefix: array [0.. GPS_MAX_PREFIX_NAME -1] of WCHAR;
   szGPSFriendlyName: array [0.. GPS_MAX_FRIENDLY_NAME -1] of WCHAR;
  end;

function GPSOpenDevice(hNewLocationData: THANDLE; hDeviceStateChange: THANDLE; szDeviceName: LPCWSTR; dwFlags: DWORD): THANDLE; external GPSAPI_DLL name 'GPSOpenDevice';
function GPSCloseDevice(hGPSDevice: THANDLE): DWORD; external GPSAPI_DLL name 'GPSCloseDevice';

function GPSGetDeviceState(out GPSDevice: GPS_DEVICE): DWORD;
function GPSGetPosition(hGPSDevice: THANDLE; out GPSPosition: GPS_POSITION; dwMaximumAge: DWORD; dwFlags: DWORD): DWORD;
function GPSValid(var GPSPosition: GPS_POSITION):TGpsValidValues; inline;
function GPSSpeedInKMH(var GPSPosition: GPS_POSITION): Double; inline;

function GeoDistance(ALat1, ALon1, ALat2, ALon2: double): double;
function ToDezCoord(ACoord: double): double;

function SystemTimeUTCToLocalDateTime(var AUtc: TSYSTEMTIME): TDateTime;


implementation

uses math;

function _GPSGetDeviceState(var GPSDevice: GPS_DEVICE): DWORD; external GPSAPI_DLL name 'GPSGetDeviceState';
function _GPSGetPosition(hGPSDevice: THANDLE; var GPSPosition: GPS_POSITION; dwMaximumAge: DWORD; dwFlags: DWORD): DWORD; external GPSAPI_DLL name 'GPSGetPosition';


function GPSGetDeviceState(out GPSDevice: GPS_DEVICE): DWORD;
begin
  GPSDevice.dwVersion:= GPS_VERSION_1;
  GPSDevice.dwSize:= sizeof(GPS_DEVICE);
  Result:= _GPSGetDeviceState(GPSDevice);
end;

function GPSGetPosition(hGPSDevice: THANDLE; out GPSPosition: GPS_POSITION; dwMaximumAge: DWORD; dwFlags: DWORD): DWORD;
begin
  GPSPosition.dwVersion:= GPS_VERSION_1;
  GPSPosition.dwSize:= sizeof(GPS_POSITION);
  Result:= _GPSGetPosition(hGPSDevice, GPSPosition, dwMaximumAge, dwFlags);
end;

function GPSValid(var GPSPosition: GPS_POSITION):TGpsValidValues;
begin
  Result:= TGpsValidValues(GPSPosition.dwValidFields);
end;

function GPSSpeedInKMH(var GPSPosition: GPS_POSITION): Double;
begin
  Result:= GPSPosition.flSpeed * 1.8520;
end;

function ToDezCoord(ACoord: double): double;
var
  x: Integer;
begin
  x:= Trunc(ACoord);
  Result:= (x div 100) + (((x mod 100) + frac(ACoord)) / 60);
end;

function GeoDistance(ALat1, ALon1, ALat2, ALon2: double): double;
begin
  ALat1:= degtorad(ALat1);
  ALon1:= degtorad(ALon1);
  ALat2:= degtorad(ALat2);
  ALon2:= degtorad(ALon2);
  Result:= sin(ALat1) * sin(ALat2) + cos(ALat1) * cos(ALat2) * cos(ALon2 - ALon1);
  if abs(Result) < 1 then
    Result:= 6378.137 * arccos(Result)
  else
    Result:= 0;
end;

function SystemTimeUTCToLocalDateTime(var AUtc: TSYSTEMTIME): TDateTime;
var
  ftime, ftime2: TFILETIME;
begin
  if SystemTimeToFileTime(AUtc, ftime)
    and FileTimeToLocalFileTime(ftime, ftime2)
    and FileTimeToSystemTime(ftime2, AUtc)
  then
    Result:= SystemTimeToDateTime(AUtc)
  else
    Result:= 0;
end;

end.

