unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, StdCtrls, OleCtrls, ExtCtrls, SHDocVw, ComCtrls,
  Progressor, EditorOutput, EditorXSL, EditorBase, EditorXML, XPMan,
  DKLang, ToolWin, StdActns, ImgList;

type
  TfMain = class(TForm)
    FrameEditorXML: TFrameEditorXML;
    Splitter1: TSplitter;
    FrameEditorXSL: TFrameEditorXSL;
    Splitter2: TSplitter;
    FrameEditorOutput: TFrameEditorOutput;
    DKLanguageController1: TDKLanguageController;
    CoolBar1: TCoolBar;
    PanelXMLOptions: TPanel;
    EditPath: TEdit;
    ButtonSelectGroup: TButton;
    mMain: TMainMenu;
    ImageListMain: TImageList;
    FileExit: TFileExit;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    ToolBarMenu: TToolBar;
    ActionSelectGroup: TAction;
    ActionOptions: TAction;
    ProgramOptions1: TMenuItem;
    HelpContents1: THelpContents;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    procedure ActionSelectGroupExecute(Sender: TObject);
    procedure ActionSelectGroupUpdate(Sender: TObject);
    procedure PanelXMLOptionsResize(Sender: TObject);
    procedure ActionOptionsExecute(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure FrameEditorOutputButton2Click(Sender: TObject);
    procedure DKLanguageController1LanguageChanged(Sender: TObject);
  published
    ActionListMain: TActionList;
    Transform: TAction;
    procedure TransformExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TransformUpdate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}
uses
  DateUtils, ShellAPI, XMLDoc, XMLIntf,
  phPhoa,
  phXML, OptionSaver, udSelGroup, udOptions;

const
  SecOptions = 'Options';

  function GetLangSubDir: String;
  var i: Integer;
  begin
    Result := '';
    i := Languages.IndexOf(GetUserDefaultLCID);
    if i<>-1 then Result := '\'+Languages.Ext[i];
  end;

   //===================================================================================================================
   // TFormMain
   //===================================================================================================================

  procedure TfMain.FormCreate(Sender: TObject);
  begin
    FrameEditorOutput.Button2.Action := Transform;
    ForceCurrentDirectory := false;
    LangManager.ScanForLangFiles(ExtractFilePath(ParamStr(0))+'language', '*.lng', False);
    LangManager.LanguageID := GetOption('Language', LangManager.LanguageID);
    FrameEditorXML.Height  := GetOption('PanelSourceHeight', FrameEditorXML.Height);
    FrameEditorXSL.Height  := GetOption('PanelTemplateHeight', FrameEditorXSL.Height);
    FrameEditorXML.OpenDialog.InitialDir := GetOption('SourceDir', '');
    FrameEditorXSL.OpenDialog.InitialDir := GetOption('TemplateDir', ExtractFilePath(ParamStr(0)) + 'Templates' + GetLangSubDir());
    // do this AFTER LangManager initialization
    ToolBarMenu.Menu := mMain;
  end;

  procedure TfMain.FormDestroy(Sender: TObject);
  begin
    SetOption('PanelSourceHeight', FrameEditorXML.Height);
    SetOption('PanelTemplate.Height', FrameEditorXSL.Height);
  end;

  procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin
    FrameEditorXML.Closing;
    FrameEditorXSL.Closing;
    FrameEditorOutput.Closing;
  end;

  procedure TfMain.TransformExecute(Sender: TObject);
  var
    XMLDoc: IXMLDocument;
    XSLDoc: IXMLDocument;
    Output: WideString;
    Progressor: IProgressor;
    RootNode: IXMLNode;
  begin
    Progressor := BeginProgress(LangManager.ConstantValue['SLoading']);
    XMLDoc := LoadXMLData(AnsiToUtf8(FrameEditorXML.Text));
    XSLDoc := LoadXMLData(AnsiToUtf8(FrameEditorXSL.Text));
    Progressor.Text := LangManager.ConstantValue['STransforming'];
    if EditPath.Text <> '' then
      RootNode := FindPhoaGroup(XMLDoc, EditPath.Text, true)
    else
      RootNode := FindChildElement(XMLDoc.DocumentElement, 'group', false);
    if RootNode <> nil then RootNode.Attributes['selected'] := 'yes';
    XMLDoc.DocumentElement.TransformNode(XSLDoc.DocumentElement, Output);
    FrameEditorOutput.OutputDir := ExtractFilePath(FrameEditorXML.OpenDialog.FileName);
    FrameEditorOutput.Text := Output;
  end;

  procedure TfMain.TransformUpdate(Sender: TObject);
  begin
    Transform.Enabled := (FrameEditorXML.Text <> '') and (FrameEditorXSL.Text <> '');
  end;

  procedure TfMain.ActionSelectGroupExecute(Sender: TObject);
  var Path: String;
  begin
    Path := EditPath.Text;
    if SelectPhoaGroup(Self, LoadXMLData(AnsiToUtf8(FrameEditorXML.Text)), Path) then EditPath.Text := Path;
  end;

  procedure TfMain.ActionSelectGroupUpdate(Sender: TObject);
  begin
    ActionSelectGroup.Enabled := Text <> '';
  end;

  procedure TfMain.PanelXMLOptionsResize(Sender: TObject);
  begin
    ButtonSelectGroup.Left := PanelXMLOptions.ClientWidth - ButtonSelectGroup.Width - 1;
    EditPath.Width := ButtonSelectGroup.Left - EditPath.Left;
  end;

  procedure TfMain.ActionOptionsExecute(Sender: TObject);
  begin
    with TdOptions.Create(Application) do
      try
        if ShowModal=mrOk then SetOption('Language', LangManager.LanguageID);
      finally
        Free;
      end;
  end;

  function TfMain.FormHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
  begin

    ShellExecute(Handle, 'Open', PChar(ChangeFileExt(ParamStr(0), '.chm')), nil, nil, SW_NORMAL);
    Result := true;
  end;

  procedure TfMain.FrameEditorOutputButton2Click(Sender: TObject);
  begin
    FrameEditorOutput.ActionOpenExecute(Sender);
  end;

procedure TfMain.DKLanguageController1LanguageChanged(Sender: TObject);
begin
  ToolBarMenu.Menu := nil;
  ToolBarMenu.Menu := mMain;
end;

end.
