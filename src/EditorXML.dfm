inherited FrameEditorXML: TFrameEditorXML
  inherited PanelLeft: TPanel
    inherited StaticText1: TStaticText
      Caption = 'Source'
    end
  end
  inherited OpenDialog: TOpenDialog
    Filter = 'PhoA files (*.phoa)|*.phoa|XML files (*.xml)|*.xml'
    Title = 'Open Source File'
  end
  inherited SaveDialog: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'PhoA files (*.phoa)|*.phoa|XML files (*.xml)|*.xml'
    Title = 'Save Source File'
  end
end
