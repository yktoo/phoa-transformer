unit ufProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Progressor,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TfProgress = class(TForm, IProgressor)
    pMain: TPanel;
    lMain: TLabel;
    pbMain: TProgressBar;
  private
    FSaveCursor: TCursor;
    FRefCount: Integer;
     // Ticks when last update was invoked
    FLastUpdatedTicks: Cardinal;
     // IInterface
    procedure SetText(const Value: String);
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
     // IProgressor
    procedure SetProgress(const Value: Double);
     // Updates the progress form in not less than .1 sec interval
    procedure TimedUpdate;
  end;

implementation
{$R *.dfm}

var
  fProgress: TfProgress;

  procedure TfProgress.SetProgress(const Value: Double);
  begin
    if Value<0 then
      pbMain.Visible := False
    else begin
      pbMain.Position := Round(pbMain.Max*Value);
      pbMain.Visible := True;
    end;
    TimedUpdate;
  end;

  procedure TfProgress.SetText(const Value: String);
  begin
    lMain.Caption := Value;
    TimedUpdate;
  end;

  procedure TfProgress.TimedUpdate;
  var cCurTicks: Cardinal;
  begin
    cCurTicks := GetTickCount;
    if cCurTicks-FLastUpdatedTicks>100 then begin
      Update;
      FLastUpdatedTicks := cCurTicks;
    end;
  end;

  function TfProgress._AddRef: Integer;
  begin
    Inc(FRefCount);
    Result := FRefCount;
    if Result=1 then begin
      FSaveCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      Show;
    end;
  end;

  function TfProgress._Release: Integer;
  begin
    Dec(FRefCount);
    Result := FRefCount;
    if Result=0 then begin
      Screen.Cursor := FSaveCursor;
      Hide;
    end;
  end;

  function GetFormProgressor: IProgressor;
  begin
    if fProgress=nil then fProgress := TfProgress.Create(Application);
    Result := fProgress;
  end;

initialization
  SetProgressor(GetFormProgressor);
end.
