unit XMLEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, XMLDoc, XMLIntf;

type
  TFrameXMLEditor = class(TFrame)
    TreeView: TTreeView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    MemoText: TMemo;
    Splitter2: TSplitter;
    MemoAttr: TMemo;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    FXMLDocument: IXMLDocument;
    procedure SetXMLDocument(const Value: IXMLDocument);
    function GetXML: string;
    procedure SetXML(const Value: string);
    { Private declarations }
  public
    constructor Create(Owner: TComponent); override;
    procedure UpdateData;
    property XMLDocument: IXMLDocument read FXMLDocument;
    property XML: string read GetXML write SetXML;
    { Public declarations }
  end;

implementation

{$R *.dfm}


{ TFrameXMLTree }


{ TFrameXMLTree }

constructor TFrameXMLEditor.Create(Owner: TComponent);
begin
  inherited;
  FXMLDocument := NewXMLDocument();
end;

function TFrameXMLEditor.GetXML: string;
begin

end;

procedure TFrameXMLEditor.SetXML(const Value: string);
begin

end;

procedure TFrameXMLEditor.SetXMLDocument(const Value: IXMLDocument);
begin
  FXMLDocument := Value;
end;

procedure TFrameXMLEditor.UpdateData;
{
  procedure AddToTree(Nodes: TTreeNodes; AParent: TTreeNode; XMLNode: IXMLNode);
  var
    I: Integer;
    Child: TTreeNode;
  begin
    Child := Nodes.AddChildObject(AParent, XMLNode.NodeName, Pointer(XMLNode));
    for I := 0 to XMLNode.ChildNodes.Count - 1 do begin
      AddToTree(Nodes, Child, XMLNode.ChildNodes[I]);
    end;
  end;

begin
  TreeView.Items.Clear;
  AddToTree(TreeView.Items, nil, XMLDocument.DocumentElement);
}
begin
  TreeView.Items.AddChildObject(nil, XMLDocument.DocumentElement.NodeName, Pointer(XMLDocument.DocumentElement)).HasChildren := true;
end;

procedure TFrameXMLEditor.TreeViewChange(Sender: TObject; Node: TTreeNode);
var
  XMLNode: IXMLNode;
  I: Integer;
begin
  XMLNode := IXMLNode(Node.Data);
  MemoAttr.Lines.Clear;
  for I := 0 to XMLNode.AttributeNodes.Count - 1 do
    MemoAttr.Lines.Add(XMLNode.AttributeNodes[I].NodeName + '=' + XMLNode.AttributeNodes[I].NodeValue);
  if XMLNode.ChildNodes.Count = 0 then
    MemoText.Text := XMLNode.Text
  else
    MemoText.Text := '';
end;

procedure TFrameXMLEditor.TreeViewExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  XMLNode: IXMLNode;
  XMLChild: IXMLNode;
  Child: TTreeNode;
  I: Integer;
begin
  if Node.Count = 0 then begin
    XMLNode := IXMLNode(Node.Data);
    for I := 0 to XMLNode.ChildNodes.Count - 1 do begin
      XMLChild := XMLNode.ChildNodes[I];
      if XMLChild.NodeType <> ntText then begin
        Child := TreeView.Items.AddChildObject(Node, XMLChild.NodeName, Pointer(XMLChild));
        Child.HasChildren := XMLChild.ChildNodes.Count > 0;
      end;
    end;
  end;
end;

end.
