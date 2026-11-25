program EGiftCardApp;

{
  Copy this Application project to its own project folder
  Refactory the copy by:
  * Renaming the project with a name relating to new Application purpose.
  * Edit Application.versioninfo.rc to relate also to this new Service name
  * Delete this comment

}

{$R 'Application.versioninfo.res' 'Application.versioninfo.rc'}

uses
  Forms,
  SysUtils,
  Log4D,
  Windows,
  uTools,
  EGiftCard in 'EGiftCard.pas' {frmEGiftCard} ;


{$R *.res}
//improve ability to run Application from a network location or removable drive
//copys exe to SWAP file so if either disconnected app should still function
{$SETPEOPTFLAGS IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE}
{$SETPEFLAGS IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

begin
  //specify which sub logger (log category) this app uses, any un-specified entry will be added to the application category
  DetermineSubLoggers([]); //eg
  ConfigureLog4D;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HintHidePause := 10000;

  //replace me - form that provides examples on how to use some ..\..\Common Units
  Application.CreateForm(TfrmEGiftCard, frmEGiftCard);
  Application.Run;

end.
