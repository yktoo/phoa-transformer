unit udSelGroup;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, XMLDoc, XMLIntf, ImgList, DKLang;

type
  TdSelGroup = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    TreeViewGroup: TTreeView;
    ilMain: TImageList;
    dklcMain: TDKLanguageController;
  end;

  function SelectPhoaGroup(Owner: TComponent; XMLDoc: IXMLDocument; var Path: String): Boolean;
  function FindPhoaGroup(XMLDoc: IXMLDocument; Path: String; RaiseExcept: Boolean = true): IXMLNode;
  function FindChildElement(Node: IXMLNode; Name: String; RaiseExcept: Boolean = true; Attribute: String = ''; AttrValue: String = ''): IXMLNode;

implementation
{$R *.dfm}
uses Variants;

const
  TagGroups = 'groups';
  TagGroup = 'group';
  AttrText = 'text';

  function GetToken(var S: String; Delimiter: String): String;
  var Position: Integer;
  begin
    Position := Pos(Delimiter, S);
    if Position > 0 then begin
      Result := Copy(S, 0, Position - 1);
      S := Copy(S, Position + Length(Delimiter), MaxInt);
    end else begin
      Result := S;
      S := '';
    end;
  end;

  function FindChildElement(Node: IXMLNode; Name: String; RaiseExcept: Boolean = true; Attribute: String = ''; AttrValue: String = ''): IXMLNode;
  var
    I: Integer;
    Value: OleVariant;
    Elem: String;
  begin
    for I := 0 to Node.ChildNodes.Count - 1 do begin
      Result := Node.ChildNodes[I];
      if (Result.NodeType = ntElement) and (AnsiCompareText(Result.NodeName, Name) = 0) then begin
        if Attribute = '' then
          Exit;
        Value := Result.Attributes[Attribute];
        if (Value <> Null) and (AnsiCompareText(Value, AttrValue) = 0) then
          Exit;
      end;
    end;
    if RaiseExcept then begin
      if Attribute = '' then
        Elem := Name
      else
        Elem := Format('%s[@%s="%s"]', [Name, Attribute, AttrValue]);
      raise Exception.CreateFmt(LangManager.ConstantValue['SElementNotFound'], [Elem]);
    end else
      Result := nil;
  end; 

  function FindPhoaGroup(XMLDoc: IXMLDocument; Path: String; RaiseExcept: Boolean = true): IXMLNode;
  var GroupText: String;
  begin
    Result := FindChildElement(XMLDoc.DocumentElement, TagGroup, RaiseExcept);
    if Result = nil then Exit;
    while Path<>'' do begin
      GroupText := GetToken(Path, '/');
      Result := FindChildElement(Result, TagGroups, RaiseExcept);
      if Result=nil then Exit;
      Result := FindChildElement(Result, TagGroup, RaiseExcept, AttrText, GroupText);
      if Result=nil then Exit;
    end;
  end;

  function AddGroupToTree(Items: TTreeNodes; Parent: TTreeNode; XMLNode: IXMLNode; Selected: IXMLNode): TTreeNode;
  var I: Integer;
  begin
    if Parent = nil then
      Result := Items.AddChild(nil, LangManager.ConstantValue['SAllGroups'])
    else
      Result := Items.AddChild(Parent, VarToStr(XMLNode.Attributes[AttrText]));
    Result.ImageIndex := 0;
    if XMLNode = Selected then
      Result.Selected := true;
    XMLNode := FindChildElement(XMLNode, TagGroups);
    if XMLNode <> nil then
      for I := 0 to XMLNode.ChildNodes.Count - 1 do
        if XMLNode.ChildNodes[I].NodeType = ntElement then
          AddGroupToTree(Items, Result, XMLNode.ChildNodes[I], Selected);
  end;

  function GetNodePath(Node: TTreeNode): String;
  begin
    Result := '';
    while Node <> nil do begin
      Result := '/' + Node.Text + Result;
      Node := Node.Parent;
    end;
     // trim "/All Groups" from the beginning
    Result := Copy(Result, Length(LangManager.ConstantValue['SAllGroups']) + 3, MaxInt);
  end;

  function SelectPhoaGroup(Owner: TComponent; XMLDoc: IXMLDocument; var Path: String): Boolean;
  var Selected: IXMLNode;
  begin
    with TdSelGroup.Create(Owner) do 
      try
        Selected := FindPhoaGroup(XMLDoc, Path, false);
        AddGroupToTree(TreeViewGroup.Items, nil, FindChildElement(XMLDoc.DocumentElement, TagGroup), Selected).Expand(false);
        Result := ShowModal = mrOk;
        if Result then Path := GetNodePath(TreeViewGroup.Selected);
      finally
        Free;
      end;
  end;

end.
