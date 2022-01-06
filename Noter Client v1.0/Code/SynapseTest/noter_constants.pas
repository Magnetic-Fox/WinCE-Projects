unit noter_constants;

{$mode objfpc}{$H+}

interface

{ Constants }

{ Files }
const helpFile=                    '\Windows\Help\Noter Client.lnk';

{ Additional codes }
const emptyImage=                  -10240;
const connecting=                  10240;

{ Answer codes }
const getError=                    -1024;
const serviceDisabled=             -768;
const serverError=                 -512;
const noteAlreadyUnlocked=         -14;
const noteAlreadyLocked=           -13;
const noteLocked=                  -12;
const userRemoveError=             -11;
const userNotExist=                -10;
const noteNotExist=                -9;
const noNecessaryInfo=             -8;
const userDeactivated=             -7;
const loginIncorrect=              -6;
const unknownAction=               -5;
const noCredentials=               -4;
const userExists=                  -3;
const noUsableInfoInPOST=          -2;
const invalidRequest=              -1;
const OK=                          0;
const userCreated=                 1;
const userUpdated=                 2;
const userRemoved=                 3;
const listSuccessful=              4;
const noteGetSuccessful=           5;
const noteCreateSuccessful=        6;
const noteUpdateSuccessful=        7;
const noteDeleteSuccessful=        8;
const userInfoGetSuccessful=       9;
const noteLockSuccessful=          10;
const noteUnlockSuccessful=        11;
const serverChangedSuccessful=     1024;

{ Default strings}
const DEFAULT_NOJSON=              'No usable JSON data.';
const DEFAULT_NOLIBRARY=           'Library could not be loaded!'#13#10'Application finishes.';

implementation

end.
