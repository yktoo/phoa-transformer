inherited FrameEditorOutput: TFrameEditorOutput
  inherited PanelLeft: TPanel
    inherited Button4: TButton
      TabOrder = 5
    end
    object RadioGroupView: TRadioGroup [4]
      Left = 8
      Top = 148
      Width = 77
      Height = 57
      Caption = 'View'
      ItemIndex = 0
      Items.Strings = (
        'Text'
        'HTML')
      TabOrder = 1
      OnClick = RadioGroupViewClick
    end
    inherited StaticText1: TStaticText
      Height = 17
      Caption = 'Output'
    end
  end
  inherited PanelRight: TPanel
    object WebBrowser: TWebBrowser [0]
      Left = 0
      Top = 0
      Width = 801
      Height = 237
      Align = alClient
      TabOrder = 1
      ControlData = {
        4C000000C95200007F1800000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  inherited OpenDialog: TOpenDialog
    Filter = 'HTML files|*.htm;*.html|TEXT files|*.txt'
  end
  inherited SaveDialog: TSaveDialog
    Filter = 'HTML files|*.htm;*.html|TEXT files|*.txt'
    Title = 'Save Output File'
  end
end
