unit EditorBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, StdCtrls, ExtCtrls;

type
  TFrameEditorBase = class(TFrame)
    PanelLeft: TPanel;
    Button2: TButton;
    Button4: TButton;
    EditFileName: TEdit;
    Button8: TButton;
    alMain: TActionList;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionSaveAs: TAction;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PanelRight: TPanel;
    Editor: TMemo;
    StaticText1: TStaticText;
    procedure EditorChange(Sender: TObject);
    procedure ActionOpenExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionSaveAsExecute(Sender: TObject);
  protected
     // We keep text here to minimize WM_GETTEXT calls
    FText: String;
    FDirty: Boolean;
    procedure SetText(const Value: String); virtual;
  public
    constructor Create(Owner: TComponent); override;
    procedure DoOpen(const AFileName: String); virtual;
    procedure DoSave(const AFileName: String); virtual;
    procedure Closing(const Prompt: String = ''); virtual;
    property Text: String read FText write SetText;
  end;

implementation
{$R *.dfm}

  procedure SetTabStops(Control: TWinControl; Value: Integer);
  begin
    SendMessage(Control.Handle, EM_SETTABSTOPS, 1, Integer(@Value));
  end;

  constructor TFrameEditorBase.Create(Owner: TComponent);
  begin
    inherited;
    SetTabStops(Editor, 16);
  end;

  procedure TFrameEditorBase.DoOpen(const AFileName: String);
  begin
    { does nothing }
  end;

  procedure TFrameEditorBase.DoSave(const AFileName: String);
  begin
    { does nothing }
  end;

  procedure TFrameEditorBase.EditorChange(Sender: TObject);
  begin
    FText := Editor.Text;
    FDirty := true;
    ActionSave.Enabled := Text <> '';
    ActionSaveAs.Enabled := Text <> '';
  end;


  function ExtractFileNameWithoutExt(FileName: String): String;
  var N: Integer;
  begin
    Result := ExtractFileName(FileName);
    N := Pos('.', Result);
    if N <> 0 then Result := Copy(Result, 1, N - 1);
  end;

  procedure TFrameEditorBase.ActionOpenExecute(Sender: TObject);
  begin
    Closing();
    if OpenDialog.Execute then begin
      DoOpen(OpenDialog.FileName);
      SaveDialog.FileName := OpenDialog.FileName;
      EditFileName.Text := ExtractFileNameWithoutExt(OpenDialog.FileName);
      FDirty := false;
    end;
  end;

  procedure TFrameEditorBase.ActionSaveExecute(Sender: TObject);
  begin
    if SaveDialog.FileName = '' then
      if not SaveDialog.Execute then Abort;
    DoSave(SaveDialog.FileName);
    EditFileName.Text := ExtractFileNameWithoutExt(SaveDialog.FileName);
    FDirty := false;
  end;

  procedure TFrameEditorBase.ActionSaveAsExecute(Sender: TObject);
  begin
    if not SaveDialog.Execute then
      Abort;
    DoSave(SaveDialog.FileName);
    EditFileName.Text := ExtractFileNameWithoutExt(SaveDialog.FileName);
    FDirty := false;
  end;

  procedure TFrameEditorBase.Closing(const Prompt: String);
  begin
    if FDirty then begin
      case MessageDlg(Format(Prompt, [SaveDialog.FileName]), mtConfirmation, mbYesNoCancel, 0) of
        mrYes:    ActionSave.Execute();
        mrCancel: Abort;
      end;
    end;
  end;

  procedure TFrameEditorBase.SetText(const Value: String);
  begin
    Editor.Text := Value;
  end;

end.
