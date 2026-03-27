unit DBBrowser_Frame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.ExprFuncs, Vcl.ComCtrls;

type
  TDBBrowserFrame = class(TFrame)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    Splitter1: TSplitter;
    MemoQuery: TMemo;
    DBGrid1: TDBGrid;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    btnConnectDB: TButton;
    lblEncoding: TLabel;
    cbEncoding: TComboBox;
    TreeView1: TTreeView;
    Splitter2: TSplitter;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    ButtonRun: TButton;
    procedure btnConnectDBClick(Sender: TObject);
    procedure ButtonRunClick(Sender: TObject);
    procedure MemoQueryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MemoQueryKeyPress(Sender: TObject; var Key: Char);
    procedure TreeView1DblClick(Sender: TObject);
  private
    FAutoConnectTried: Boolean;
    FShiftEnterPressed: Boolean;
    procedure PopulateTreeView(const ADBName: string);
  public
    procedure AutoConnectIfNeeded;
  end;

implementation

uses DBBrowser_ConnectForm, System.IniFiles, ToolsAPI;

function GetActiveProjectDir: string;
var
  ModuleServices: IOTAModuleServices;
  ProjectGroup: IOTAProjectGroup;
  Project: IOTAProject;
begin
  Result := '';
  if Supports(BorlandIDEServices, IOTAModuleServices, ModuleServices) then
  begin
    ProjectGroup := ModuleServices.MainProjectGroup;
    if Assigned(ProjectGroup) then
    begin
      Project := ProjectGroup.ActiveProject;
      if Assigned(Project) then
        Result := ExtractFilePath(Project.FileName);
    end;
    if Result = '' then
    begin
      Project := ModuleServices.GetActiveProject;
      if Assigned(Project) then
        Result := ExtractFilePath(Project.FileName);
    end;
  end;
end;

procedure TDBBrowserFrame.PopulateTreeView(const ADBName: string);
var
  Tables, Views: TStringList;
  I: Integer;
  RootNode, TableNode, ViewNode: TTreeNode;
  ObjName: string;
  DotIdx: Integer;
begin
  TreeView1.Items.BeginUpdate;
  try
    TreeView1.Items.Clear;
    RootNode := TreeView1.Items.Add(nil, ADBName);
    TableNode := TreeView1.Items.AddChild(RootNode, 'Table');
    ViewNode := TreeView1.Items.AddChild(RootNode, 'View');
    
    Tables := TStringList.Create;
    Views := TStringList.Create;
    try
      // 실제 테이블 가져오기
      FDConnection1.GetTableNames('', '', '', Tables, [osMy, osOther], [tkTable]);
      for I := 0 to Tables.Count - 1 do
      begin
        ObjName := Tables[I];
        DotIdx := ObjName.LastIndexOf('.');
        if DotIdx >= 0 then
          ObjName := ObjName.Substring(DotIdx + 1);
          
        TreeView1.Items.AddChild(TableNode, ObjName);
      end;
      
      // 뷰 가져오기
      FDConnection1.GetTableNames('', '', '', Views, [osMy, osOther], [tkView]);
      for I := 0 to Views.Count - 1 do
      begin
        ObjName := Views[I];
        DotIdx := ObjName.LastIndexOf('.');
        if DotIdx >= 0 then
          ObjName := ObjName.Substring(DotIdx + 1);
          
        TreeView1.Items.AddChild(ViewNode, ObjName);
      end;
    finally
      Tables.Free;
      Views.Free;
    end;
    
    RootNode.Expand(False);
    TableNode.Expand(False);
    ViewNode.Expand(False);
    
    if TreeView1.Items.Count > 0 then
    begin
      TreeView1.Selected := TreeView1.Items[0];
      TreeView1.TopItem := TreeView1.Items[0];
    end;
  finally
    TreeView1.Items.EndUpdate;
  end;
end;


procedure TDBBrowserFrame.AutoConnectIfNeeded;
var
  Dir: string;
  Ini: TIniFile;
begin
  if FAutoConnectTried then Exit;
  FAutoConnectTried := True;

  if FDConnection1.Connected then Exit;

  Dir := GetActiveProjectDir;
  if Dir = '' then Exit;
  if not FileExists(Dir + 'dbbrowser.ini') then Exit;

  Ini := TIniFile.Create(Dir + 'dbbrowser.ini');
  try
    var encodingStr := Ini.ReadString('Connection', 'Encoding', 'Default');
    cbEncoding.ItemIndex := cbEncoding.Items.IndexOf(encodingStr);
    if cbEncoding.ItemIndex < 0 then cbEncoding.ItemIndex := 0;


    FDConnection1.Close;
    FDConnection1.Params.Clear;
    
    if cbEncoding.ItemIndex > 0 then
      FDConnection1.Params.Values['CharacterSet'] := cbEncoding.Text;

    FDConnection1.DriverName := Ini.ReadString('Connection', 'DriverID', '');
    if FDConnection1.DriverName = '' then Exit;

    if FDConnection1.DriverName = 'SQLite' then
    begin
      FDConnection1.Params.Values['Database'] := Ini.ReadString('Connection', 'Database', '');
    end
    else
    begin
      FDConnection1.Params.Values['Server'] := Ini.ReadString('Connection', 'Server', '');
      FDConnection1.Params.Values['Database'] := Ini.ReadString('Connection', 'Database', '');
      FDConnection1.Params.Values['User_Name'] := Ini.ReadString('Connection', 'User_Name', '');
      FDConnection1.Params.Values['Password'] := Ini.ReadString('Connection', 'Password', '');
      if Ini.ReadBool('Connection', 'UseSSL', False) then
      begin
        if FDConnection1.DriverName = 'MySQL' then
        begin
          FDConnection1.Params.Values['UseSSL'] := 'True';
          var sslCert := Ini.ReadString('Connection', 'SSL_Cert', '');
          if sslCert <> '' then
            FDConnection1.Params.Values['SSL_ca'] := sslCert;
        end
        else if FDConnection1.DriverName = 'MSSQL' then
          FDConnection1.Params.Values['Encrypt'] := 'yes';
      end;
    end;

    try
      FDConnection1.Connected := True;
      var dbName := FDConnection1.Params.Values['Database'];
      if FDConnection1.DriverName = 'SQLite' then
        dbName := ExtractFileName(dbName);
      PopulateTreeView(dbName);
    except
      // Failed to auto connect, do nothing
    end;
  finally
    Ini.Free;
  end;
end;

{$R *.dfm}

procedure TDBBrowserFrame.btnConnectDBClick(Sender: TObject);
var
  Dlg: TfrmDBConnect;
  Dir: string;
  Ini: TIniFile;
  dbName: string;
begin
  Dlg := TfrmDBConnect.Create(nil);
  try
    // Set default Driver based on current connection if assigned
    if FDConnection1.DriverName <> '' then
      Dlg.cbDriverID.ItemIndex := Dlg.cbDriverID.Items.IndexOf(FDConnection1.DriverName);

    Dlg.FEncoding := cbEncoding.Text;

    Dir := GetActiveProjectDir;
    if Dir <> '' then
    begin
      Ini := TIniFile.Create(Dir + 'dbbrowser.ini');
      try
        if Ini.ReadString('Connection', 'DriverID', '') <> '' then
          Dlg.cbDriverID.ItemIndex := Dlg.cbDriverID.Items.IndexOf(Ini.ReadString('Connection', 'DriverID', ''));
          
        if Dlg.cbDriverID.Text = 'SQLite' then
        begin
          Dlg.edtDatabase.Text := Ini.ReadString('Connection', 'Database', Dlg.edtDatabase.Text);
        end
        else
        begin
          Dlg.edtServer.Text := Ini.ReadString('Connection', 'Server', Dlg.edtServer.Text);
          Dlg.edtUsername.Text := Ini.ReadString('Connection', 'User_Name', Dlg.edtUsername.Text);
          Dlg.edtPassword.Text := Ini.ReadString('Connection', 'Password', Dlg.edtPassword.Text);
          Dlg.chkUseSSL.Checked := Ini.ReadBool('Connection', 'UseSSL', Dlg.chkUseSSL.Checked);
          Dlg.edtSSLCert.Text := Ini.ReadString('Connection', 'SSL_Cert', '');
          
          var savedDb := Ini.ReadString('Connection', 'Database', '');
          if savedDb <> '' then
          begin
            if Dlg.edtDatabase.Items.IndexOf(savedDb) < 0 then
              Dlg.edtDatabase.Items.Add(savedDb);
            Dlg.edtDatabase.ItemIndex := Dlg.edtDatabase.Items.IndexOf(savedDb);
          end;
        end;
      finally
        Ini.Free;
      end;
    end;

    if Dlg.ShowModal = mrOk then
    begin
      FDConnection1.Close;
      FDConnection1.Params.Clear;
      
      if cbEncoding.ItemIndex > 0 then
        FDConnection1.Params.Values['CharacterSet'] := cbEncoding.Text;
      
      FDConnection1.DriverName := Dlg.cbDriverID.Text;
      
      if Dlg.cbDriverID.Text = 'SQLite' then
      begin
        FDConnection1.Params.Values['Database'] := Dlg.edtDatabase.Text;
        if FDConnection1.Params.Values['Database'] = '' then
          FDConnection1.Params.Values['Database'] := ':memory:'; // Default to memory
      end
      else
      begin
        // MSSQL or MySQL
        FDConnection1.Params.Values['Server'] := Dlg.edtServer.Text;
        FDConnection1.Params.Values['Database'] := Dlg.edtDatabase.Text;
        FDConnection1.Params.Values['User_Name'] := Dlg.edtUsername.Text;
        FDConnection1.Params.Values['Password'] := Dlg.edtPassword.Text;
        
        // Handling SSL based on CheckBox
        if Dlg.chkUseSSL.Checked then
        begin
          if Dlg.cbDriverID.Text = 'MySQL' then
          begin
            FDConnection1.Params.Values['UseSSL'] := 'True';
            if Dlg.edtSSLCert.Text <> '' then
              FDConnection1.Params.Values['SSL_ca'] := Dlg.edtSSLCert.Text;
          end
          else if Dlg.cbDriverID.Text = 'MSSQL' then
            FDConnection1.Params.Values['Encrypt'] := 'yes';
        end;
      end;
      
      try
        FDConnection1.Connected := True;
        
        if Dlg.cbDriverID.Text = 'SQLite' then
          dbName := ExtractFileName(Dlg.edtDatabase.Text)
        else
          dbName := Dlg.edtDatabase.Text;
        PopulateTreeView(dbName);

        Dir := GetActiveProjectDir;
        if Dir <> '' then
        begin
          Ini := TIniFile.Create(Dir + 'dbbrowser.ini');
          try
            Ini.WriteString('Connection', 'DriverID', Dlg.cbDriverID.Text);
            if Dlg.cbDriverID.Text = 'SQLite' then
            begin
              Ini.WriteString('Connection', 'Database', Dlg.edtDatabase.Text);
            end
            else
            begin
              Ini.WriteString('Connection', 'Server', Dlg.edtServer.Text);
              Ini.WriteString('Connection', 'Database', Dlg.edtDatabase.Text);
              Ini.WriteString('Connection', 'User_Name', Dlg.edtUsername.Text);
              Ini.WriteString('Connection', 'Password', Dlg.edtPassword.Text);
              Ini.WriteBool('Connection', 'UseSSL', Dlg.chkUseSSL.Checked);
              if Dlg.chkUseSSL.Checked and (Dlg.edtSSLCert.Text <> '') then
                Ini.WriteString('Connection', 'SSL_Cert', Dlg.edtSSLCert.Text);
            end;
            Ini.WriteString('Connection', 'Encoding', cbEncoding.Text);
          finally
            Ini.Free;
          end;
        end;

        ShowMessage(Format('%s Database Connected Successfully!', [Dlg.cbDriverID.Text]));
      except
        on E: Exception do
          ShowMessage('Connection Error: ' + E.Message);
      end;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TDBBrowserFrame.TreeView1DblClick(Sender: TObject);
var
  TableName: string;
  SaveSelStart: Integer;
begin
  if Assigned(TreeView1.Selected) and (TreeView1.Selected.Level = 2) then
  begin
    TableName := TreeView1.Selected.Text;
    if CheckBox1.Checked then
    begin
      MemoQuery.Lines.Text := 'SELECT * FROM ' + TableName;
      ButtonRunClick(nil);
    end
    else
    begin
      // Auto가 꺼져 있으면 현재 커서 위치에 테이블 이름 삽입
      SaveSelStart := MemoQuery.SelStart;
      MemoQuery.SelText := TableName;
      MemoQuery.SelStart := SaveSelStart + Length(TableName);
      MemoQuery.SetFocus;
    end;
  end;
end;

procedure TDBBrowserFrame.ButtonRunClick(Sender: TObject);
var
  SQL: string;
begin
  if not FDConnection1.Connected then
  begin
    ShowMessage(string('제대로 연결된 DB가 없습니다. 먼저 커넥션을 만들어보세요.'));
    Exit;
  end;

  // 선택된 텍스트가 있으면 해당 부분만 실행, 없으면 전체 실행
  if MemoQuery.SelLength > 0 then
    SQL := MemoQuery.SelText
  else
    SQL := MemoQuery.Lines.Text;

  SQL := Trim(SQL);
  if SQL = '' then Exit;

  try
    FDQuery1.Close;
    FDQuery1.SQL.Text := SQL;
    FDQuery1.Open;
  except
    on E: Exception do
      ShowMessage('쿼리 실행 에러: ' + E.Message);
  end;
end;

procedure TDBBrowserFrame.MemoQueryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Shift+Enter로 쿼리 실행
  if (Key = VK_RETURN) and (ssShift in Shift) then
  begin
    FShiftEnterPressed := True;
    Key := 0;
    ButtonRunClick(nil);
  end;
end;

procedure TDBBrowserFrame.MemoQueryKeyPress(Sender: TObject; var Key: Char);
begin
  // Shift+Enter의 WM_CHAR(LF 문자)가 선택 텍스트를 지우는 것을 차단
  if FShiftEnterPressed then
  begin
    FShiftEnterPressed := False;
    Key := #0;
  end;
end;

end.
