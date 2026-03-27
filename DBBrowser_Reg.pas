unit DBBrowser_Reg;

interface

procedure Register;

implementation

uses
  System.SysUtils, ToolsAPI, DBBrowser_View;

var
  CustomViewIndex: Pointer = nil;

procedure Register;
var
  View: INTACustomEditorSubView; // Delphi 12에서도 기본적으로 지원하는 서브 뷰 사용
  EditorViewServices: IOTAEditorViewServices140;
begin
  if Supports(BorlandIDEServices, IOTAEditorViewServices140, EditorViewServices) then
  begin
    View := TDBBrowserCustomView.Create;
    CustomViewIndex := EditorViewServices.RegisterEditorSubView(View);
  end;
end;

procedure RemoveRegistration;
var
  EditorViewServices: IOTAEditorViewServices140;
begin
  if Assigned(CustomViewIndex) and Supports(BorlandIDEServices, IOTAEditorViewServices140, EditorViewServices) then
  begin
    EditorViewServices.UnregisterEditorSubView(CustomViewIndex);
    CustomViewIndex := nil;
  end;
end;

initialization

finalization
  RemoveRegistration;

end.
