unit stringtable_consts;

{$mode objfpc}{$H+}

interface

{ Library information section }

const LIBINFO_EN_LANGNAME=          001;
const LIBINFO_LANGUAGE=             002;
const LIBINFO_FORVERSION=           003;
const LIBINFO_CREATEDBY=            004;
const LIBINFO_CREATIONDATE=         005;

{ Information section }

const INFO_PREVIOUSSERVER=          101;
const INFO_OK=                      102;
const INFO_USERCREATED=             103;
const INFO_USERUPDATED=             104;
const INFO_USERDELETED=             105;
const INFO_NOTELISTGOT=             106;
const INFO_NOTERETRIEVED=           107;
const INFO_NOTECREATED=             108;
const INFO_NOTEUPDATED=             109;
const INFO_NOTEDELETED=             110;
const INFO_USERINFOGOT=             111;
const INFO_NOTELOCKED=              112;
const INFO_NOTEUNLOCKED=            113;
const INFO_SERVERCHANGED=           114;

{ Question section }

const QUESTION_UNSAVEDCHANGES=      201;
const QUESTION_DELETEACCOUNT=       202;
const QUESTION_CHANGECREDENTIALS=   203;
const QUESTION_UPDATENOTE=          204;
const QUESTION_DELETENOTE=          205;
const QUESTION_WANTLOGOUT=          206;

{ Error section }

const ERROR_NOHELPFILE=             301;
const ERROR_FILLFORMS=              302;
const ERROR_PROVIDEPASSWORD=        303;
const ERROR_PASSWORDNOTMATCHING=    304;
const ERROR_WRONGANSWER=            305;
const ERROR_SERVERSHUTDOWN=         306;
const ERROR_INTERNALSERVER=         307;
const ERROR_NOTEALREADYUNLOCKED=    308;
const ERROR_NOTEALREADYLOCKED=      309;
const ERROR_NOTELOCKED=             310;
const ERROR_USERDELETE=             311;
const ERROR_WRONGUSER=              312;
const ERROR_WRONGNOTE=              313;
const ERROR_NONEEDEDDATA=           314;
const ERROR_USERLOCKED=             315;
const ERROR_WRONGCREDENTIALS=       316;
const ERROR_WRONGCOMMAND=           317;
const ERROR_NOCREDENTIALS=          318;
const ERROR_USERNAMETAKEN=          319;
const ERROR_NOUSABLEDATA=           320;
const ERROR_WRONGREQUEST=           321;
const ERROR_UNKNOWNCODE=            322;

{ Label section }

const LABEL_CONNECTIONCHECKERROR=   401;
const LABEL_CONNECTIONCHECKOK=      402;
const LABEL_REGISTEREDSUCCESSFULLY= 403;
const LABEL_REGISTRATIONERROR=      404;
const LABEL_LOGGEDINSUCCESSFULLY=   405;
const LABEL_LOGGINGINERROR=         406;
const LABEL_ID=                     407;
const LABEL_DATE=                   408;
const LABEL_SERVERADDRESS=          409;
const LABEL_SHARE=                  410;
const LABEL_USERNAME=               411;
const LABEL_PASSWORD=               412;
const LABEL_REGISTER=               413;
const LABEL_CHECKINGCONNECTION=     414;
const LABEL_NOTES=                  415;
const LABEL_CONFIRMPASSWORD=        416;
const LABEL_REGISTRATION=           417;
const LABEL_TERMSACCEPT=            418;
const LABEL_SUBJECT=                419;
const LABEL_ENTRY=                  420;
const LABEL_NEWNOTE=                421;
const LABEL_NOTEID=                 422;
const LABEL_ADDDATE=                423;
const LABEL_LASTMODDATE=            424;
const LABEL_ADDEDUSING=             425;
const LABEL_CHANGEDUSING=           426;
const LABEL_USERID=                 427;
const LABEL_REGISTRATIONDATE=       428;
const LABEL_REGISTEREDUSING=        429;
const LABEL_USERLASTCHANGES=        430;
const LABEL_USERLASTCHANGEDUSING=   431;
const LABEL_SERVERNAME=             432;
const LABEL_TIMEZONE=               433;
const LABEL_SERVERVERSION=          434;
const LABEL_CHANGINGPASSWORD=       435;
const LABEL_CURRENTPASSWORD=        436;
const LABEL_NEWPASSWORD=            437;
const LABEL_CONFIRMNEWPASSWORD=     438;
const LABEL_ACCOUNTDELETION=        439;
const LABEL_DELETIONWARNING=        440;
const LABEL_SERVERCHANGING=         441;
const LABEL_VERSION=                442;
const LABEL_PROGRAMMER=             443;
const LABEL_CONTACT=                444;
const LABEL_PRODUCTIONTIME=         445;
const LABEL_INFORMATIONFORMNAME=    446;
const LABEL_DELETE=                 447;
const LABEL_UNDO=                   448;
const LABEL_CUT=                    449;
const LABEL_COPY=                   450;
const LABEL_PASTE=                  451;
const LABEL_SELECTALL=              452;
const LABEL_TERMS=                  453;
const LABEL_TERMSPART1=             454;
const LABEL_TERMSPART2=             455;
const LABEL_PRIVACYPOLICY=          456;
const LABEL_PRIVACYTEXT=            457;
const LABEL_NOQUESTIONS=            458;
const LABEL_SOMEQUESTIONS=          459;
const LABEL_ALLQUESTIONS=           460;
const LABEL_PROGRAMSETTINGS=        461;
const LABEL_AVAILABLELANGUAGES=     462;
const LABEL_DISPLAYEDQUESTIONS=     463;
const LABEL_ASKUNSAVEDCHANGES=      464;
const LABEL_ASKDELETEACCOUNT=       465;
const LABEL_ASKCHANGECREDENTIALS=   466;
const LABEL_ASKUPDATENOTE=          467;
const LABEL_ASKDELETENOTE=          468;
const LABEL_ASKWANTLOGOUT=          469;
const LABEL_LANGLIBINFO=            470;
const LABEL_LANGLIBAUTHOR=          471;
const LABEL_LANGLIBDATE=            472;

{ Button section }

const BUTTON_ADD=                   501;
const BUTTON_UPDATE=                502;
const BUTTON_LOCK=                  503;
const BUTTON_UNLOCK=                504;
const BUTTON_START=                 505;
const BUTTON_BACK=                  506;
const BUTTON_CONTINUE=              507;
const BUTTON_REGISTER=              508;
const BUTTON_DELETE=                509;
const BUTTON_CLOSE=                 510;
const BUTTON_CHANGEPASSWORD=        511;
const BUTTON_LOGOUT=                512;
const BUTTON_CHANGESERVER=          513;
const BUTTON_CANCEL=                514;
const BUTTON_SERVER=                515;
const BUTTON_LANGUAGE=              516;
const BUTTON_MESSAGES=              517;
const BUTTON_APPLY=                 518;
const BUTTON_BACK2=                 519;

implementation

end.
