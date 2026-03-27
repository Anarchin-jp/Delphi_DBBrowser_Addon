object frmDBConnect: TfrmDBConnect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Database Connection'
  ClientHeight = 330
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 200
    Width = 87
    Height = 15
    Caption = 'Driver / DB Type:'
  end
  object Label2: TLabel
    Left = 24
    Top = 24
    Width = 35
    Height = 15
    Caption = 'Server:'
  end
  object Label3: TLabel
    Left = 24
    Top = 235
    Width = 51
    Height = 15
    Caption = 'Database:'
  end
  object Label4: TLabel
    Left = 24
    Top = 64
    Width = 56
    Height = 15
    Caption = 'Username:'
  end
  object Label5: TLabel
    Left = 24
    Top = 104
    Width = 53
    Height = 15
    Caption = 'Password:'
  end
  object lblSSLCert: TLabel
    Left = 24
    Top = 166
    Width = 84
    Height = 15
    Caption = 'SSL Cert (.pem):'
    Visible = False
  end
  object cbDriverID: TComboBox
    Left = 112
    Top = 197
    Width = 200
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = 'MSSQL'
    OnChange = cbDriverIDChange
    Items.Strings = (
      'MSSQL'
      'MySQL'
      'SQLite')
  end
  object edtServer: TEdit
    Left = 112
    Top = 21
    Width = 260
    Height = 23
    TabOrder = 0
  end
  object edtDatabase: TComboBox
    Left = 112
    Top = 232
    Width = 200
    Height = 23
    TabOrder = 6
  end
  object edtUsername: TEdit
    Left = 112
    Top = 61
    Width = 200
    Height = 23
    TabOrder = 1
  end
  object edtPassword: TEdit
    Left = 112
    Top = 101
    Width = 200
    Height = 23
    PasswordChar = '*'
    TabOrder = 2
  end
  object chkUseSSL: TCheckBox
    Left = 112
    Top = 141
    Width = 100
    Height = 17
    Caption = 'Use SSL'
    TabOrder = 3
    OnClick = chkUseSSLClick
  end
  object edtSSLCert: TEdit
    Left = 112
    Top = 163
    Width = 230
    Height = 23
    TabOrder = 10
    Visible = False
  end
  object btnSSLBrowse: TButton
    Left = 347
    Top = 163
    Width = 25
    Height = 23
    Caption = '...'
    TabOrder = 11
    Visible = False
    OnClick = btnSSLBrowseClick
  end
  object btnFetch: TButton
    Left = 318
    Top = 231
    Width = 54
    Height = 25
    Caption = 'Fetch'
    TabOrder = 5
    OnClick = btnFetchClick
  end
  object btnOK: TButton
    Left = 214
    Top = 285
    Width = 75
    Height = 25
    Caption = 'Connect'
    Default = True
    ModalResult = 1
    TabOrder = 7
  end
  object btnCancel: TButton
    Left = 297
    Top = 285
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object btnBrowse: TButton
    Left = 318
    Top = 231
    Width = 54
    Height = 25
    Caption = '...'
    TabOrder = 9
    Visible = False
    OnClick = btnBrowseClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'SQLite Database (*.db;*.sqlite;*.sqlite3)|*.db;*.sqlite;*.sqlite' +
      '3|All Files (*.*)|*.*'
    Left = 328
    Top = 96
  end
  object OpenDialogSSL: TOpenDialog
    Filter = 'PEM Certificate (*.pem)|*.pem|All Files (*.*)|*.*'
    Left = 328
    Top = 56
  end
end
