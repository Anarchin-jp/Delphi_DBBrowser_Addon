object DBBrowserFrame: TDBBrowserFrame
  Left = 0
  Top = 0
  Width = 1053
  Height = 643
  TabOrder = 0
  DesignSize = (
    1053
    643)
  object Splitter1: TSplitter
    Left = 0
    Top = 153
    Width = 1053
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 269
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 1053
    Height = 153
    Align = alTop
    Caption = 'PanelTop'
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      1053
      153)
    object lblEncoding: TLabel
      Left = 176
      Top = 14
      Width = 53
      Height = 15
      Caption = 'Encoding:'
    end
    object MemoQuery: TMemo
      Left = 8
      Top = 40
      Width = 1035
      Height = 105
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      Lines.Strings = (
        'SELECT * FROM TableName')
      ParentFont = False
      TabOrder = 0
      OnKeyDown = MemoQueryKeyDown
      OnKeyPress = MemoQueryKeyPress
    end
    object btnConnectDB: TButton
      Left = 8
      Top = 9
      Width = 150
      Height = 25
      Caption = 'Connect DB'
      TabOrder = 1
      OnClick = btnConnectDBClick
    end
    object cbEncoding: TComboBox
      Left = 240
      Top = 9
      Width = 100
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'Default'
      Items.Strings = (
        'Default'
        'utf8'
        'utf8mb4'
        'euckr'
        'cp949')
    end
  end
  object Panel1: TPanel
    Left = 840
    Top = 5
    Width = 212
    Height = 33
    Anchors = [akTop, akRight]
    TabOrder = 1
    DesignSize = (
      212
      33)
    object CheckBox1: TCheckBox
      Left = 16
      Top = 7
      Width = 59
      Height = 17
      Anchors = [akTop]
      Caption = 'Auto'
      Checked = True
      State = cbChecked
      TabOrder = 0
      ExplicitLeft = 8
    end
    object ButtonRun: TButton
      Left = 84
      Top = 4
      Width = 120
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Execute (Shift+Enter)'
      TabOrder = 1
      OnClick = ButtonRunClick
      ExplicitLeft = 46
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 156
    Width = 1053
    Height = 487
    Align = alClient
    Caption = 'PanelBottom'
    ShowCaption = False
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 129
      Top = 1
      Height = 485
    end
    object DBGrid1: TDBGrid
      Left = 132
      Top = 1
      Width = 920
      Height = 485
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object TreeView1: TTreeView
      Left = 1
      Top = 1
      Width = 128
      Height = 485
      Align = alLeft
      Indent = 19
      TabOrder = 1
      OnDblClick = TreeView1DblClick
    end
  end
  object FDConnection1: TFDConnection
    LoginPrompt = False
    Left = 320
    Top = 232
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 408
    Top = 232
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 496
    Top = 232
  end
end
