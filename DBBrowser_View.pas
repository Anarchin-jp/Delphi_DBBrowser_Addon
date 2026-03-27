unit DBBrowser_View;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, ToolsAPI, DBBrowser_Frame, DesignIntf;

type
  { INTACustomEditorSubView 하단을 탭으로 분할해 보여주는 인터페이스 구현 }
  TDBBrowserCustomView = class(TInterfacedObject, INTACustomEditorSubView)
  private
    FFrame: TDBBrowserFrame;
  public
    { INTACustomEditorSubView }
    function GetCanCloneView: Boolean;
    function GetCaption: string;
    function GetPriority: Integer;
    function GetViewIdentifier: string;
    
    procedure Display(const AContext: IInterface; AViewObject: TObject);
    function EditAction(const AContext: IInterface; Action: TEditAction; AViewObject: TObject): Boolean;
    function GetEditState(const AContext: IInterface; AViewObject: TObject): TEditState;
    function Handles(const AContext: IInterface): Boolean;
    procedure Hide(const AContext: IInterface; AViewObject: TObject);
    procedure ViewClosed(const AContext: IInterface; AViewObject: TObject);
    
    function GetFrameClass: TCustomFrameClass;
    procedure FrameCreated(AFrame: TCustomFrame);
  end;

implementation

{ TDBBrowserCustomView }

function TDBBrowserCustomView.GetCanCloneView: Boolean;
begin
  Result := False;
end;

procedure TDBBrowserCustomView.Display(const AContext: IInterface; AViewObject: TObject);
begin
  if Assigned(AViewObject) and (AViewObject is TDBBrowserFrame) then
  begin
    FFrame := TDBBrowserFrame(AViewObject);
    // 뷰를 표시할 때 추가적인 상태 갱신이 필요하다면 여기서 처리합니다.
    FFrame.AutoConnectIfNeeded;
  end;
end;

function TDBBrowserCustomView.EditAction(const AContext: IInterface; Action: TEditAction; AViewObject: TObject): Boolean;
begin
  Result := False;
end;

function TDBBrowserCustomView.GetEditState(const AContext: IInterface; AViewObject: TObject): TEditState;
begin
  Result := [];
end;

function TDBBrowserCustomView.Handles(const AContext: IInterface): Boolean;
begin
  Result := True;
end;

procedure TDBBrowserCustomView.Hide(const AContext: IInterface; AViewObject: TObject);
begin
  // Hide
end;

procedure TDBBrowserCustomView.ViewClosed(const AContext: IInterface; AViewObject: TObject);
begin
  if FFrame = AViewObject then
    FFrame := nil;
end;

function TDBBrowserCustomView.GetFrameClass: TCustomFrameClass;
begin
  Result := TDBBrowserFrame;
end;

procedure TDBBrowserCustomView.FrameCreated(AFrame: TCustomFrame);
begin
  if AFrame is TDBBrowserFrame then
    FFrame := TDBBrowserFrame(AFrame);
end;

function TDBBrowserCustomView.GetCaption: string;
begin
  Result := 'DB Browser'; // 하단 탭에 나타날 내용
end;

function TDBBrowserCustomView.GetPriority: Integer;
begin
  Result := 70; // History 탭 우측에 주로 띄웁니다.
end;

function TDBBrowserCustomView.GetViewIdentifier: string;
begin
  Result := 'CustomView.DBBrowser';
end;

end.
