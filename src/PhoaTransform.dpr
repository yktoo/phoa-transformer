program PhoaTransform;

uses
  Forms,
  Main in 'Main.pas' {fMain},
  phXML in 'phXML.pas',
  udXMLConvOptions in 'udXMLConvOptions.pas' {dXMLConvOptions},
  Progressor in 'Progressor.pas',
  ufProgress in 'ufProgress.pas' {fProgress},
  udSelGroup in 'udSelGroup.pas' {dSelGroup},
  EditorBase in 'EditorBase.pas' {FrameEditorBase: TFrame},
  EditorXML in 'EditorXML.pas' {FrameEditorXML: TFrame},
  EditorXSL in 'EditorXSL.pas' {FrameEditorXSL: TFrame},
  EditorOutput in 'EditorOutput.pas' {FrameEditorOutput: TFrame},
  udOptions in 'udOptions.pas' {dOptions},
  OptionSaver in 'OptionSaver.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PhoA Transformer';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
