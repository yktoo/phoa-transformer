object FrameEditorBase: TFrameEditorBase
  Left = 0
  Top = 0
  Width = 903
  Height = 237
  TabOrder = 0
  object PanelLeft: TPanel
    Left = 0
    Top = 0
    Width = 102
    Height = 237
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Button2: TButton
      Left = 8
      Top = 44
      Width = 88
      Height = 23
      Action = ActionOpen
      TabOrder = 0
    end
    object Button4: TButton
      Left = 8
      Top = 72
      Width = 88
      Height = 23
      Action = ActionSave
      TabOrder = 1
    end
    object EditFileName: TEdit
      Left = 2
      Top = 20
      Width = 95
      Height = 21
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object Button8: TButton
      Left = 8
      Top = 100
      Width = 88
      Height = 23
      Action = ActionSaveAs
      TabOrder = 3
    end
    object StaticText1: TStaticText
      Left = 0
      Top = 0
      Width = 102
      Height = 16
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Color = clInactiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInactiveCaptionText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 4
      Transparent = False
    end
  end
  object PanelRight: TPanel
    Left = 102
    Top = 0
    Width = 801
    Height = 237
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Editor: TMemo
      Left = 0
      Top = 0
      Width = 801
      Height = 237
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      WantTabs = True
      OnChange = EditorChange
    end
  end
  object alMain: TActionList
    Left = 120
    Top = 16
    object ActionOpen: TAction
      Caption = 'Open'
      OnExecute = ActionOpenExecute
    end
    object ActionSave: TAction
      Caption = 'Save'
      OnExecute = ActionSaveExecute
    end
    object ActionSaveAs: TAction
      Caption = 'Save As'
      OnExecute = ActionSaveAsExecute
    end
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofEnableSizing, ofDontAddToRecent]
    Left = 172
    Top = 16
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'xsl'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing, ofDontAddToRecent]
    Left = 228
    Top = 16
  end
end
