inherited FrameEditorXSL: TFrameEditorXSL
  inherited PanelLeft: TPanel
    inherited StaticText1: TStaticText
      Height = 17
      Caption = 'Template'
    end
  end
  inherited OpenDialog: TOpenDialog
    Filter = 'XSLT Files (*.xsl; *,xslt)|*.xsl; *,xslt'
    Title = 'Open Template File'
  end
  inherited SaveDialog: TSaveDialog
    Filter = 'XSLT Files (*.xsl; *,xslt)|*.xsl; *,xslt'
    Title = 'Save Template File'
  end
end
