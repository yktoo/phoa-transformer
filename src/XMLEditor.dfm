object FrameXMLEditor: TFrameXMLEditor
  Left = 0
  Top = 0
  Width = 588
  Height = 282
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 257
    Top = 0
    Height = 282
  end
  object TreeView: TTreeView
    Left = 0
    Top = 0
    Width = 257
    Height = 282
    Align = alLeft
    Indent = 19
    TabOrder = 0
    OnChange = TreeViewChange
    OnExpanding = TreeViewExpanding
  end
  object Panel1: TPanel
    Left = 260
    Top = 0
    Width = 328
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 0
      Top = 81
      Width = 328
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object MemoText: TMemo
      Left = 0
      Top = 0
      Width = 328
      Height = 81
      Align = alTop
      TabOrder = 0
    end
    object MemoAttr: TMemo
      Left = 0
      Top = 84
      Width = 328
      Height = 198
      Align = alClient
      TabOrder = 1
    end
  end
end
