Program project1;

{$apptype gui}

{

Really Simple Magic Packet Send Utility
Version 1.0

(C)2023 Bartłomiej "Magnetic-Fox" Węgrzyn!

}

{ Uses section }
Uses Interfaces, lnetComponents, IniFiles, SysUtils, Windows;

{ Global variables }
Var GL_info, GL_error: bool;

{ Additional types }
Type macAddr= array[0..5] of byte;
     magicPacket= array[0..101] of byte;

{ Function for converting hex numbers }
Function toInt(s: string): integer;
Begin
     Try
        Result:=StrToInt('$'+s); { Nice cheat ;) }
     Except
        Result:=0;
     End;
End;

{ Too simple function for gathering mac address byte
  from order XX:XX:XX:XX:XX:XX, and similar }
Function getMacBytes(s: string): macAddr;
Var mac: macAddr;
Begin
     Try
        mac[0]:=toInt(s[1]+s[2]);
        mac[1]:=toInt(s[4]+s[5]);
        mac[2]:=toInt(s[7]+s[8]);
        mac[3]:=toInt(s[10]+s[11]);
        mac[4]:=toInt(s[13]+s[14]);
        mac[5]:=toInt(s[16]+s[17]);
        Result:=mac;
     Except
        If GL_error then Windows.MessageBox(0,'Erroneous Data!','Error',Windows.MB_ICONERROR);
     End;
End;

{ Function for generating magic packets }
Function generateMagicPacket(mac: macAddr): magicPacket;
Var x, y: integer;
    mp:   magicPacket;
Begin
     For x:=0 to 5 do mp[x]:=$FF;
     For x:=0 to 15 do
     Begin
          For y:=0 to 5 do mp[6+6*x+y]:=mac[y];
     End;
     Result:=mp;
End;

{ Another variables }
Var udp:   TLUDPComponent;
    iniFN, address, portS, macS: string;
    port:  word;
    ini:   TIniFile;
    mac:   macAddr;
    mp:    magicPacket;

{ Main program code }

{$R *.res}

Begin
     Try
        iniFN:=ExtractFilePath(ParamStr(0))+'config.ini';{ Get config.ini file }
        ini:=TIniFile.Create(iniFN);                     { Create object }
        address:=ini.ReadString('server','address','');  { Read data from INI }
        portS:=ini.ReadString('server','port','');
        macS:=ini.ReadString('server','mac','');
        GL_info:=ini.ReadBool('misc','showInformation',true);
        GL_error:=ini.ReadBool('misc','showErrors',true);
        port:=StrToInt(portS);                           { Convert data }
        mac:=getMacBytes(macS);
        mp:=generateMagicPacket(mac);
        udp:=TLUDPComponent.Create(nil);                 { Create "UDP" object }
        udp.Connect(address,port);                       { "Connect" }
        udp.Send(mp,102);                                { Send data }
        udp.Disconnect;                                  { "Disconnect" }
        udp.Free;                                        { Free objects }
        ini.Free;
        If GL_info then Windows.MessageBox(0,'Magic packet sent successfully.','Information',Windows.MB_ICONINFORMATION);
     Except
        If GL_error then Windows.MessageBox(0,'An error occurred.','Error',Windows.MB_ICONERROR);
     End;
End.
