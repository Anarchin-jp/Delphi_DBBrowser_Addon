unit DBBrowser_ConnectForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmDBConnect = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbDriverID: TComboBox;
    edtServer: TEdit;
    edtDatabase: TComboBox;
    edtUsername: TEdit;
    edtPassword: TEdit;
    chkUseSSL: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnFetch: TButton;
    btnBrowse: TButton;
    OpenDialog1: TOpenDialog;
    lblSSLCert: TLabel;
    edtSSLCert: TEdit;
    btnSSLBrowse: TButton;
    OpenDialogSSL: TOpenDialog;
    procedure btnFetchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbDriverIDChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure chkUseSSLClick(Sender: TObject);
    procedure btnSSLBrowseClick(Sender: TObject);
  private
    procedure UpdateSSLVisibility;
  public
    FEncoding: string;
  end;

var
  frmDBConnect: TfrmDBConnect;

implementation

uses
  FireDAC.Comp.Client, FireDAC.Phys.Intf;

{$R *.dfm}

{ TfrmDBConnect }

procedure TfrmDBConnect.FormShow(Sender: TObject);
begin
  cbDriverIDChange(nil);
  UpdateSSLVisibility;
end;

procedure TfrmDBConnect.UpdateSSLVisibility;
var
  ShowSSL: Boolean;
begin
  ShowSSL := chkUseSSL.Checked and chkUseSSL.Visible;
  lblSSLCert.Visible := ShowSSL;
  edtSSLCert.Visible := ShowSSL;
  btnSSLBrowse.Visible := ShowSSL;
end;

procedure TfrmDBConnect.chkUseSSLClick(Sender: TObject);
begin
  UpdateSSLVisibility;
end;

procedure TfrmDBConnect.cbDriverIDChange(Sender: TObject);
var
  IsSQLite: Boolean;
begin
  IsSQLite := (cbDriverID.Text = 'SQLite');
  
  edtServer.Visible := not IsSQLite;
  Label2.Visible := not IsSQLite;
  edtUsername.Visible := not IsSQLite;
  Label4.Visible := not IsSQLite;
  edtPassword.Visible := not IsSQLite;
  Label5.Visible := not IsSQLite;
  chkUseSSL.Visible := not IsSQLite;
  btnFetch.Visible := not IsSQLite;
  
  btnBrowse.Visible := IsSQLite;
  UpdateSSLVisibility;
end;

procedure TfrmDBConnect.btnSSLBrowseClick(Sender: TObject);
begin
  if OpenDialogSSL.Execute then
    edtSSLCert.Text := OpenDialogSSL.FileName;
end;

procedure TfrmDBConnect.btnBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if edtDatabase.Items.IndexOf(OpenDialog1.FileName) < 0 then
      edtDatabase.Items.Add(OpenDialog1.FileName);
    edtDatabase.ItemIndex := edtDatabase.Items.IndexOf(OpenDialog1.FileName);
    edtDatabase.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmDBConnect.btnFetchClick(Sender: TObject);
var
  FDConn: TFDConnection;
begin
  FDConn := TFDConnection.Create(nil);
  try
    FDConn.DriverName := cbDriverID.Text;
    if cbDriverID.Text = 'SQLite' then
    begin
       // For SQLite, fetch might not be needed in the same way, but let's keep logic
       // Usually it's just a file.
    end
    else
    begin
      FDConn.Params.Values['Server'] := edtServer.Text;
      FDConn.Params.Values['User_Name'] := edtUsername.Text;
      FDConn.Params.Values['Password'] := edtPassword.Text;
      if chkUseSSL.Checked then
      begin
        if cbDriverID.Text = 'MySQL' then
        begin
          FDConn.Params.Values['UseSSL'] := 'True';
          if edtSSLCert.Text <> '' then
            FDConn.Params.Values['SSL_ca'] := edtSSLCert.Text;
        end
        else if cbDriverID.Text = 'MSSQL' then
          FDConn.Params.Values['Encrypt'] := 'yes';
      end;
      
      if (FEncoding <> '') and (FEncoding <> 'Default') then
        FDConn.Params.Values['CharacterSet'] := FEncoding;
    end;

    try
      FDConn.Connected := True;
      edtDatabase.Items.Clear;
      FDConn.GetCatalogNames('', edtDatabase.Items);
      if edtDatabase.Items.Count > 0 then
      begin
        edtDatabase.ItemIndex := 0;
        ShowMessage('Database names fetched!');
      end
      else
        ShowMessage('Connected, but no databases found.');
    except
      on E: Exception do
        ShowMessage('Connection Error: ' + E.Message);
    end;
  finally
    FDConn.Free;
  end;
end;

end.


