unit EditorXSL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditorBase, ActnList, StdCtrls, ExtCtrls;

type
  TFrameEditorXSL = class(TFrameEditorBase)
  private
  public
    procedure DoOpen(const AFileName: String); override;
    procedure DoSave(const AFileName: String); override;
    procedure Closing(const Prompt: String = ''); override;
  end;

var
  FrameEditorXSL: TFrameEditorXSL;

implementation
{$R *.dfm}
uses phXML, Progressor, DKLang, OptionSaver;

  procedure TFrameEditorXSL.Closing(const Prompt: String);
  begin
    inherited Closing(LangManager.ConstantValue['SSavePromptXSL']);
  end;

  procedure TFrameEditorXSL.DoOpen(const AFileName: String);
  begin
    SetOption('TemplateDir', ExtractFilePath(AFileName));
    BeginProgress(LangManager.ConstantValue['SOpeningXSL']);
    Text := UTF8ToAnsi(FileToString(AFileName));
  end;

  procedure TFrameEditorXSL.DoSave(const AFileName: String);
  begin
    BeginProgress(LangManager.ConstantValue['SSavingXSL']);
    StringToFile(AnsiToUtf8(Text), AFileName);
  end;

end.
