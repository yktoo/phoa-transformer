unit udXMLConvOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, phXML, ComCtrls, DKLang;


type
  TdXMLConvOptions = class(TForm)
    GroupBox1: TGroupBox;
    CopyThumbnails: TCheckBox;
    ThumbnailSubDir: TEdit;
    ExtractMetadata: TCheckBox;
    GroupBox2: TGroupBox;
    TimeShiftDirection: TRadioGroup;
    TimeShiftAmount: TDateTimePicker;
    lTimeShiftAmount: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    dklcMain: TDKLanguageController;
    procedure ButtonOKClick(Sender: TObject);
    procedure CopyThumbnailsClick(Sender: TObject);
  private
    FConverter: TPhoaConverter;
    procedure SetConverter(Value: TPhoaConverter);
  public
    property Converter: TPhoaConverter read FConverter write SetConverter;
  end;

var
  dXMLConvOptions: TdXMLConvOptions;

implementation
{$R *.dfm}

  procedure TdXMLConvOptions.SetConverter(Value: TPhoaConverter);
  begin
    FConverter := Value;
    CopyThumbnails.Checked       := Converter.CopyThumbnails;
    ThumbnailSubDir.Text         := Converter.ThumbnailSubDir;
    ExtractMetadata.Checked      := Converter.ExtractMetadata;
    TimeShiftDirection.ItemIndex := Ord(Converter.TimeShift < 0);
    TimeShiftAmount.Time         := Abs(Converter.TimeShift) / (24*60*60);
    ThumbnailSubDir.Enabled      := CopyThumbnails.Checked;
  end;

  procedure TdXMLConvOptions.ButtonOKClick(Sender: TObject);
  begin
    Converter.CopyThumbnails  := CopyThumbnails.Checked;
    Converter.ThumbnailSubDir := ThumbnailSubDir.Text;
    Converter.ExtractMetadata := ExtractMetadata.Checked;
    Converter.TimeShift       := Trunc(24*60*60*Frac(TimeShiftAmount.Time));
    if TimeShiftDirection.ItemIndex=1 then Converter.TimeShift := -Converter.TimeShift;
  end;

  procedure TdXMLConvOptions.CopyThumbnailsClick(Sender: TObject);
  begin
    ThumbnailSubDir.Enabled := CopyThumbnails.Checked;
  end;

end.
