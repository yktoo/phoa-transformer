object dXMLConvOptions: TdXMLConvOptions
  Left = 421
  Top = 219
  BorderStyle = bsDialog
  Caption = 'PhoA -> XML converter options'
  ClientHeight = 169
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    442
    169)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 201
    Height = 89
    Caption = 'Thumbnails'
    TabOrder = 0
    object CopyThumbnails: TCheckBox
      Left = 16
      Top = 24
      Width = 137
      Height = 17
      Caption = 'Copy to this subfolder:'
      TabOrder = 0
      OnClick = CopyThumbnailsClick
    end
    object ThumbnailSubDir: TEdit
      Left = 32
      Top = 48
      Width = 153
      Height = 21
      TabOrder = 1
      Text = 'Thumbs'
    end
  end
  object ExtractMetadata: TCheckBox
    Left = 12
    Top = 108
    Width = 153
    Height = 17
    Caption = 'Extract EXIF Metadata'
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 224
    Top = 12
    Width = 201
    Height = 89
    Caption = 'Time shift'
    TabOrder = 2
    object lTimeShiftAmount: TLabel
      Left = 96
      Top = 28
      Width = 15
      Height = 13
      Caption = '&By:'
      FocusControl = TimeShiftAmount
    end
    object TimeShiftDirection: TRadioGroup
      Left = 8
      Top = 16
      Width = 81
      Height = 57
      ItemIndex = 0
      Items.Strings = (
        'Forward'
        'Backward')
      TabOrder = 0
    end
    object TimeShiftAmount: TDateTimePicker
      Left = 96
      Top = 44
      Width = 81
      Height = 21
      Date = 38211.000000000000000000
      Time = 38211.000000000000000000
      Kind = dtkTime
      TabOrder = 1
    end
  end
  object ButtonOK: TButton
    Left = 275
    Top = 135
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 355
    Top = 135
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      '*.Font.Name'
      'ThumbnailSubDir.Text')
    Left = 8
    Top = 132
    LangData = {
      0F0064584D4C436F6E764F7074696F6E73010100000001000000070043617074
      696F6E010A000000090047726F7570426F783101010000000300000007004361
      7074696F6E000E00436F70795468756D626E61696C7301010000000400000007
      0043617074696F6E000F005468756D626E61696C53756244697200000F004578
      74726163744D65746164617461010100000006000000070043617074696F6E00
      090047726F7570426F7832010100000007000000070043617074696F6E001000
      6C54696D655368696674416D6F756E7401010000000800000007004361707469
      6F6E00120054696D655368696674446972656374696F6E010100000009000000
      05004974656D73000F0054696D655368696674416D6F756E7400000800427574
      746F6E4F4B01010000000A000000070043617074696F6E000C00427574746F6E
      43616E63656C01010000000B000000070043617074696F6E00}
  end
end
