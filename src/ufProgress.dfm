object fProgress: TfProgress
  Left = 271
  Top = 257
  BorderStyle = bsNone
  Caption = 'Please wait...'
  ClientHeight = 74
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 373
    Height = 74
    Align = alClient
    ParentBackground = False
    TabOrder = 0
    object lMain: TLabel
      Left = 12
      Top = 12
      Width = 349
      Height = 29
      AutoSize = False
      Layout = tlBottom
    end
    object pbMain: TProgressBar
      Left = 12
      Top = 44
      Width = 349
      Height = 17
      Max = 1000
      TabOrder = 0
      Visible = False
    end
  end
end
