unit EditorOutput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditorBase, ActnList, StdCtrls, ExtCtrls, OleCtrls, SHDocVw;

type
  TFrameEditorOutput = class(TFrameEditorBase)
    RadioGroupView: TRadioGroup;
    WebBrowser: TWebBrowser;
    procedure RadioGroupViewClick(Sender: TObject);
  private
    FTempFile: String;
    FOutputDir: String;
    procedure DeleteTempFile;
    procedure UpdateHTML;
  protected
    procedure SetText(const Value: String); override;
  public
    destructor Destroy; override;
    procedure DoSave(const AFileName: String); override;
    procedure Closing(const Prompt: String = ''); override;
    property OutputDir: String read FOutputDir write FOutputDir;
  end;

var
  FrameEditorOutput: TFrameEditorOutput;

implementation
{$R *.dfm}
uses Main, phXML, Progressor, DKLang;

  procedure TFrameEditorOutput.Closing(const Prompt: String);
  begin
    inherited Closing(LangManager.ConstantValue['SSavePromptOutput']);
  end;

  procedure TFrameEditorOutput.DeleteTempFile;
  begin
    if FTempFile <> '' then begin
      DeleteFile(FTempFile);
      FTempFile := '';
    end;
  end;

  destructor TFrameEditorOutput.Destroy;
  begin
    DeleteTempFile;
    inherited;
  end;

  procedure TFrameEditorOutput.DoSave(const AFileName: String);
  begin
    BeginProgress(LangManager.ConstantValue['SSavingOutput']);
    StringToFile(AnsiToUtf8(Text), AFileName);
  end;

  procedure TFrameEditorOutput.RadioGroupViewClick(Sender: TObject);
  begin

    if RadioGroupView.ItemIndex = 0 then
      Editor.BringToFront
    else begin
      UpdateHTML();
      WebBrowser.BringToFront;
    end;
  {
    Editor.Visible := RadioGroupView.ItemIndex = 0;
    WebBrowser.Visible := RadioGroupView.ItemIndex = 1;
  }
  end;

  function RemoveMetaTag(S: String): String;
  var N, I: Integer;
  begin
    Result := S;
    N := Pos('<META', S);
    if N <> 0 then begin
      for I := N to Length(S) do
        if S[I] = '>' then begin
          Delete(Result, N, I - N + 1);
          Break;
        end;
    end;
  end;

  procedure TFrameEditorOutput.SetText(const Value: String);
  begin
    inherited SetText(RemoveMetaTag(Value));
    if RadioGroupView.ItemIndex = 1 then UpdateHTML();
  end;

  procedure TFrameEditorOutput.UpdateHTML;
  var Buffer: array[0..MAX_PATH] of char;
  begin
    BeginProgress(LangManager.ConstantValue['SOpeningHTML']);
    if GetTempFileName(PChar(OutputDir), '~', 0, @Buffer) = 0 then
      raise Exception.Create(LangManager.ConstantValue['SNoTempFile']);
    DeleteTempFile;
    FTempFile := Buffer;
    StringToFile(Text, FTempFile);
    WebBrowser.Navigate(FTempFile);
  end;

end.
