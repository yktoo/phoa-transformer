object dOptions: TdOptions
  Left = 385
  Top = 246
  BorderStyle = bsDialog
  Caption = 'Program Options'
  ClientHeight = 93
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    366
    93)
  PixelsPerInch = 96
  TextHeight = 13
  object lLanguage: TLabel
    Left = 12
    Top = 12
    Width = 96
    Height = 13
    Caption = 'Interface &Language:'
    FocusControl = cbLanguage
  end
  object ButtonOK: TButton
    Left = 200
    Top = 60
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object Button2: TButton
    Left = 280
    Top = 60
    Width = 75
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object cbLanguage: TComboBox
    Left = 12
    Top = 28
    Width = 342
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
  end
  object dklcMain: TDKLanguageController
    IgnoreList.Strings = (
      '*.Font.Name')
    Left = 8
    Top = 56
    LangData = {
      0800644F7074696F6E73010100000001000000070043617074696F6E01040000
      000A0063624C616E677561676500000800427574746F6E4F4B01010000000400
      0000070043617074696F6E000700427574746F6E320101000000050000000700
      43617074696F6E0009006C4C616E677561676501010000000600000007004361
      7074696F6E00}
  end
end
