unit EditorXML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditorBase, ActnList, StdCtrls, ExtCtrls;

type
  TFrameEditorXML = class(TFrameEditorBase)
  private
  public
    procedure DoOpen(const AFileName: String); override;
    procedure DoSave(const AFileName: String); override;
    procedure Closing(const Prompt: String = ''); override;
  end;

var
  FrameEditorXML: TFrameEditorXML;

implementation
{$R *.dfm}
uses
  XMLDoc, XMLIntf, DKLang, phPhoa, Progressor, phXML, OptionSaver, udXMLConvOptions, udSelGroup;

  procedure TFrameEditorXML.Closing(const Prompt: String = '');
  begin
    inherited Closing(LangManager.ConstantValue['SSavePromptXML']);
  end;

  procedure TFrameEditorXML.DoOpen(const AFileName: String);
  var Progressor: IProgressor;

    function ConvertPhoaToXML(const PhoaFileName: String): String;
    var ConvObj: TPhoaConverter;
    begin
      ConvObj := TPhoaConverter.Create;
      try
        ConvObj.Direction := cdPhoaToXml;
        ConvObj.Mapping := xmAttribute; // xmNode;
        ConvObj.ThumbnailSubDir := GetOption('ThumbnailSubDir', ConvObj.ThumbnailSubDir);
        ConvObj.CopyThumbnails  := GetOption('CopyThumbnails', true);
        ConvObj.ExtractMetadata := GetOption('ExtractMetadata', true);
        with TdXMLConvOptions.Create(Application) do
          try
            Converter := ConvObj;
            if ShowModal<>mrOk then Abort;
          finally
            Free;
          end;
        SetOption('ThumbnailSubDir', ConvObj.ThumbnailSubDir);
        SetOption('CopyThumbnails',  ConvObj.CopyThumbnails);
        SetOption('ExtractMetadata', ConvObj.ExtractMetadata);
        Progressor := BeginProgress(LangManager.ConstantValue['SPreparing']);
        ConvObj.Progressor := Progressor;
        ConvObj.PhoaStreamer := TPhoaFiler.Create(psmRead, PhoaFileName);
        ConvObj.XMLDoc := NewXMLDocument();
        ConvObj.XMLDoc.Encoding := 'UTF-8';
        ConvObj.XMLDoc.Options := [doNodeAutoIndent];
        Progressor.Text := LangManager.ConstantValue['SConvertingPhoAToXML'];
        ConvObj.Convert();
        Progressor.Progress := NoProgress;
        Progressor.Text := LangManager.ConstantValue['SOpeningXML'];
        ConvObj.XMLDoc.SaveToXML(Result);
      finally
        ConvObj.PhoaStreamer.Free;
        ConvObj.Free;
      end;
    end;

  var Ext: String;
  begin
    SetOption('SourceDir', ExtractFilePath(AFileName));
    Ext := ExtractFileExt(AFileName);
    if CompareText(Ext, '.phoa') = 0 then
      Text := UTF8ToAnsi(ConvertPhoaToXML(AFileName))
    else if CompareText(Ext, '.xml') = 0 then begin
      Progressor := BeginProgress(LangManager.ConstantValue['SOpeningXML']);
      Text := UTF8ToAnsi(FileToString(AFileName));
    end;
    SaveDialog.InitialDir := ExtractFilePath(AFileName);
  end;

  procedure TFrameEditorXML.DoSave(const AFileName: String);
  var Progressor: IProgressor;

    procedure ConvertXMLToPhoa(XML: String; PhoaFileName: String);
    var
      Converter: TPhoaConverter;
      Stream: TMemoryStream;
    begin
      Converter := TPhoaConverter.Create;
      Stream := TMemoryStream.Create;
      try
        Progressor := BeginProgress(LangManager.ConstantValue['SPreparing']);
        Converter.Direction := cdXmlToPhoa;
        Converter.Mapping := xmAttribute;
         // We do not use TPhoaFiler.Create(psmWrite, PhoaFileName) here
         // because it would damage existing file in case of exception inside Convert().
        Converter.PhoaStreamer := TPhoaStreamer.Create(Stream, psmWrite, ExtractFilePath(PhoaFileName));
        Converter.XMLDoc := LoadXMLData(XML);
        Progressor.Text := LangManager.ConstantValue['SConvertingXMLToPhoA'];
        Converter.Convert();
        Stream.SaveToFile(PhoaFileName);
      finally
        Converter.PhoaStreamer.Free;
        Converter.Free;
        Stream.Free;
      end;
    end;

  var Ext: String;
  begin
    Ext := ExtractFileExt(AFileName);
    if CompareText(Ext, '.phoa') = 0 then
      ConvertXMLToPhoa(AnsiToUtf8(Text), AFileName)
    else if CompareText(Ext, '.xml') = 0 then begin
      Progressor := BeginProgress(LangManager.ConstantValue['SSavingXML']);
      StringToFile(AnsiToUtf8(Text), AFileName);
    end;
  end;

end.
