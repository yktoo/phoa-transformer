unit phXML;

interface

uses Classes, SysUtils, XMLIntf, XMLDoc, phPhoa, Progressor;


type
  TConvertDirection = (cdPhoaToXml, cdXmlToPhoa);
  TXmlMapping = (xmDefault, xmNode, xmAttribute);
const
  DefaultXmlMapping: TXmlMapping = xmAttribute;
type
   // Converter class
  TPhoaConverter = class(TObject)
  private
    FExtractMetadata: Boolean;
    FCopyThumbnails: Boolean;
    FXMLDoc: IXMLDocument;
//    FBaseDir: string;
    FThumbnailSubDir: string;
    FDirection: TConvertDirection;
    FTimeShift: Integer;
    FPhoaStreamer: TPhoaStreamer;
    FMapping: TXmlMapping;
    FProgressor: IProgressor;
  public
    constructor Create;
     // Main conversion proc
    procedure Convert;
    property Direction: TConvertDirection read FDirection write FDirection;
     // Valid TPhoaStreamer object
    property PhoaStreamer: TPhoaStreamer read FPhoaStreamer write FPhoaStreamer;
     // Valid IXMLDocument object.
     // In case of cdXmlToPhoa conversion XMLDoc must have root node.
    property XMLDoc: IXMLDocument read FXMLDoc write FXMLDoc;
     // if true, copies thumbnails to files
    property CopyThumbnails: Boolean read FCopyThumbnails write FCopyThumbnails;
     // Path with trailing backslash. Thumnail images will be placed in
     // BaseDir + ThumbnailSubDir directory
  //  property BaseDir: string read FBaseDir write FBaseDir;
     // Subdir of BaseDir (may be empty). Used as a relative path
     // for thumbnails in xml document.
    property ThumbnailSubDir: string read FThumbnailSubDir write FThumbnailSubDir;
     // Way of chunk presentation in xml
     //  xmNode - as child node with text: <chunk>value</chunk>
     //  xmAttribute - as attribute: <... chunk = "value" ...>
     //  xmDefault - DefaultXmlMapping is used
    property Mapping: TXmlMapping read FMapping write FMapping;
     // Get EXIF data from source image file and insert it to xml
    property ExtractMetadata: Boolean read FExtractMetadata write FExtractMetadata;
     // Adds specified value (in seconds) to picture time
    property TimeShift: Integer read FTimeShift write FTimeShift;
    property Progressor: IProgressor read FProgressor write FProgressor;
  end;


  // helper procedures
  procedure StringToFile(S: string; FileName: string);
  function FileToString(FileName: string): string;

implementation
uses Variants, phMetadata;

type
  TNodeData = record
    Code:    TPhChunkCode;   // Chunk code
    Value:   Variant;        // Value to convert
    XmlNode: IXMLNode;
  end;

   // specific value-convertion procedure template
  TConvertProc = procedure(Converter: TPhoaConverter; var Data: TNodeData);

   // phoa - xml correspondence table entry
  PChunkInfo = ^TChunkInfo;
  TChunkInfo = record
    Code:         TPhChunkCode;   // Chunk code
    Parent:       TPhChunkCode;   // Parent chunk code (is nessesary because of not-unique XML node names)
    Tag:          PChar;          // XML node name
    Mapping:      TXmlMapping;    // specific mapping
    Proc:         TConvertProc;   // specific value-convertion procedure
  end;

   // specific procedure for date attributes
  procedure ConvertDate(Converter: TPhoaConverter; var Data: TNodeData);
  begin
    case Converter.Direction of
      cdPhoaToXml:
  //      Data.Value := FormatDateTime('yyyy-mm-dd', PhoaDateToDate(Data.Value));
        Data.Value := DateToStr(PhoaDateToDate(Data.Value));
      cdXmlToPhoa:
        Data.Value := DateToPhoaDate(StrToDate(Data.Value));
    end;
  end;

  function Module(X, Y: Integer): Integer;
  begin
    Result := X mod Y;
    if Result < 0 then
      Result := Y + Result;
  end;

   // specific procedure for time attributes
  procedure ConvertTime(Converter: TPhoaConverter; var Data: TNodeData);
  begin
    case Converter.Direction of
      cdPhoaToXml:
  //      Data.Value := FormatDateTime('hh:nn:ss', PhoaTimeToTime(Data.Value));
        Data.Value := TimeToStr(PhoaTimeToTime(Module(Data.Value + Converter.TimeShift, 60*60*24)));
      cdXmlToPhoa:
        Data.Value := Module(TimeToPhoaTime(StrToTime(Data.Value)) + Converter.TimeShift, 60*60*24);
    end;
  end;


   // helper procedure used in ConvertThumbnail
  procedure StringToFile(S: string; FileName: string);
  var
    Stream: TFileStream;
    P: PChar;
  begin
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      P := PChar(S);
      Stream.Write(P^, Length(S));
    finally
      Stream.Free;
    end;
  end;


  // helper procedure used in ConvertThumbnail
  function FileToString(FileName: string): string;
  var
    Stream: TFileStream;
    P: PChar;
  begin
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      SetLength(Result, Stream.Size);
      P := PChar(Result);
      Stream.Read(P^, Length(Result));
    finally
      Stream.Free;
    end;
  end;


   // specific procedure for thumbnail data
  procedure ConvertThumbnail(Converter: TPhoaConverter; var Data: TNodeData);
  var
    RelativeFileName: string;
  begin
    case Converter.Direction of
      cdPhoaToXml:
        begin
          RelativeFileName := Format('%s\%d.jpg', [Converter.ThumbnailSubDir, Integer(Data.XmlNode.Attributes['id'])]);
          if Converter.CopyThumbnails then
            StringToFile(Data.Value, Converter.PhoaStreamer.BasePath + RelativeFileName);
          Data.Value := RelativeFileName;
        end;
      cdXmlToPhoa:
        begin
          if Converter.CopyThumbnails then begin
            RelativeFileName := Format('%s\%d.jpg', [Converter.ThumbnailSubDir, Integer(Data.XmlNode.Attributes['id'])]);
            Data.Value := FileToString(Converter.PhoaStreamer.BasePath + RelativeFileName);
          end;
        end;
    end;
  end;

  function RationalToFloat(Src: string): string;
  var N, X, Y: Integer;
  begin
    Result := Src;
    N := Pos('/', Src);
    if N <> 0 then begin
      X := StrToIntDef(Copy(Src, 1, N - 1), -1);
      Y := StrToIntDef(Copy(Src, N + 1, MaxInt), 0);
      if (X <> -1) and (Y <> 0) then Result := FormatFloat('0.###', X / Y);
    end;
  end;

  procedure ExtractMetadata(Converter: TPhoaConverter; var Data: TNodeData);
  var
    Metadata: TImageMetadata;
    I: Integer;
    ExifTag: PEXIFTag;
    Child: IXMLNode;
    FileName, Folder: string;
  begin
    if Converter.Direction = cdPhoaToXml then begin
      FileName := Data.Value;
      Folder := ExtractFilePath(FileName);
      Data.Value := Copy(Data.Value, Length(Folder) + 1, MaxInt);
      Data.XmlNode.Attributes['folder'] := Folder;
      if Converter.ExtractMetadata then begin
        Metadata := TImageMetadata.Create(FileName);
        try
          if Metadata.StatusCode = IMS_OK then begin
            for I := 0 to Metadata.EXIFData.Count - 1 do begin
              ExifTag := FindEXIFTag(Integer(Metadata.EXIFData.Objects[I]));
              if ExifTag <> nil then begin
                Child := Data.XmlNode.AddChild('exif');
                Child.Attributes['tag'] := IntToHex(ExifTag.iTag, 0);
                Child.Attributes['name'] := ExifTag.sName;
                Child.Attributes['value'] := RationalToFloat(Metadata.EXIFData[I]);
              end;
            end;
          end;
        finally
          Metadata.Free;
        end;
      end;
    end else begin
      Data.Value := Data.XmlNode.Attributes['folder'] + Data.Value;
    end;
  end;


const
   // phoa - xml correspondence table
  ChunkInfoTable: Array[0..60] of TChunkInfo = (
    (Code: IPhChunk_Remark;                                                     Tag: 'remark'             ),
    (Code: IPhChunk_PhoaGenerator;                                              Tag: 'generator'          ),
    (Code: IPhChunk_PhoaSavedDate;                                              Tag: 'saveddate'      ; Proc: ConvertDate    ),
    (Code: IPhChunk_PhoaSavedTime;                                              Tag: 'savedtime'      ; Proc: ConvertTime    ),
    (Code: IPhChunk_PhoaDescription;                                            Tag: 'description'        ),
    (Code: IPhChunk_PhoaThumbQuality;                                           Tag: 'thumbquality'       ),
    (Code: IPhChunk_PhoaThumbWidth;                                             Tag: 'thumbwidth'         ),
    (Code: IPhChunk_PhoaThumbHeight;                                            Tag: 'thumbheight'        ),
    (Code: IPhChunk_Pic_ID;                Parent: IPhChunk_Pic_Open;           Tag: 'id'             ; Mapping: xmAttribute   ),
    (Code: IPhChunk_Pic_ThumbnailData;     Parent: IPhChunk_Pic_Open;           Tag: 'thumbnail'      ; Proc: ConvertThumbnail ),
    (Code: IPhChunk_Pic_ThumbWidth;        Parent: IPhChunk_Pic_Open;           Tag: 'thumbwidth'         ),
    (Code: IPhChunk_Pic_ThumbHeight;       Parent: IPhChunk_Pic_Open;           Tag: 'thumbheight'        ),
    (Code: IPhChunk_Pic_PicFileName;       Parent: IPhChunk_Pic_Open;           Tag: 'filename'       ; Proc: ExtractMetadata ),
    (Code: IPhChunk_Pic_PicFileSize;       Parent: IPhChunk_Pic_Open;           Tag: 'filesize'           ),
    (Code: IPhChunk_Pic_PicWidth;          Parent: IPhChunk_Pic_Open;           Tag: 'width'              ),
    (Code: IPhChunk_Pic_PicHeight;         Parent: IPhChunk_Pic_Open;           Tag: 'height'             ),
    (Code: IPhChunk_Pic_PicFormat;         Parent: IPhChunk_Pic_Open;           Tag: 'format'             ),
    (Code: IPhChunk_Pic_Date;              Parent: IPhChunk_Pic_Open;           Tag: 'date'           ; Proc: ConvertDate      ),
    (Code: IPhChunk_Pic_Time;              Parent: IPhChunk_Pic_Open;           Tag: 'time'           ; Proc: ConvertTime      ),
    (Code: IPhChunk_Pic_Place;             Parent: IPhChunk_Pic_Open;           Tag: 'place'              ),
    (Code: IPhChunk_Pic_FilmNumber;        Parent: IPhChunk_Pic_Open;           Tag: 'filmnumber'         ),
    (Code: IPhChunk_Pic_FrameNumber;       Parent: IPhChunk_Pic_Open;           Tag: 'framenumber'        ),
    (Code: IPhChunk_Pic_Author;            Parent: IPhChunk_Pic_Open;           Tag: 'author'             ),
    (Code: IPhChunk_Pic_Media;             Parent: IPhChunk_Pic_Open;           Tag: 'media'              ),
    (Code: IPhChunk_Pic_Desc;              Parent: IPhChunk_Pic_Open;           Tag: 'desc'               ),
    (Code: IPhChunk_Pic_Notes;             Parent: IPhChunk_Pic_Open;           Tag: 'notes'              ),
    (Code: IPhChunk_Pic_Keywords;          Parent: IPhChunk_Pic_Open;           Tag: 'keywords'           ),
    (Code: IPhChunk_Pic_Rotation;          Parent: IPhChunk_Pic_Open;           Tag: 'rotation'           ),
    (Code: IPhChunk_Pic_Flips;             Parent: IPhChunk_Pic_Open;           Tag: 'flips'              ),
    (Code: IPhChunk_Group_ID;              Parent: IPhChunk_Group_Open;         Tag: 'id'             ; Mapping: xmAttribute   ),
    (Code: IPhChunk_Group_Text;            Parent: IPhChunk_Group_Open;         Tag: 'text'               ),
    (Code: IPhChunk_Group_Expanded;        Parent: IPhChunk_Group_Open;         Tag: 'expanded'           ),
    (Code: IPhChunk_Group_Description;     Parent: IPhChunk_Group_Open;         Tag: 'desc'               ),
    (Code: IPhChunk_GroupPic_ID;           Parent: IPhChunk_GroupPics_Open;     Tag: 'ref'            ; Mapping: xmNode        ),
    (Code: IPhChunk_View_Name;             Parent: IPhChunk_View_Open;          Tag: 'name'               ),
    (Code: IPhChunk_ViewGrouping_Prop;     Parent: IPhChunk_ViewGrouping_Open;  Tag: 'prop'               ),
    (Code: IPhChunk_ViewGrouping_Unclass;  Parent: IPhChunk_ViewGrouping_Open;  Tag: 'unclass'            ),
    (Code: IPhChunk_ViewSorting_Prop;      Parent: IPhChunk_ViewSorting_Open;   Tag: 'prop'               ),
    (Code: IPhChunk_ViewSorting_Order;     Parent: IPhChunk_ViewSorting_Open;   Tag: 'order'              ),
    (Code: IPhChunk_Pics_Open;                                                  Tag: 'pics'               ),
    (Code: IPhChunk_Pic_Open;              Parent: IPhChunk_Pics_Open;          Tag: 'pic'                ),
    (Code: IPhChunk_Group_Open;           {Parent: IPhChunk_Groups_Open; }      Tag: 'group'              ),
    (Code: IPhChunk_Groups_Open;                                                Tag: 'groups'             ),
    (Code: IPhChunk_GroupPics_Open;        Parent: IPhChunk_Group_Open;         Tag: 'refs'               ),
    (Code: IPhChunk_Views_Open;                                                 Tag: 'views'              ),
    (Code: IPhChunk_View_Open;             Parent: IPhChunk_Views_Open;         Tag: 'view'               ),
    (Code: IPhChunk_ViewGroupings_Open;    Parent: IPhChunk_View_Open;          Tag: 'groupings'          ),
    (Code: IPhChunk_ViewGrouping_Open;     Parent: IPhChunk_ViewGroupings_Open; Tag: 'grouping'           ),
    (Code: IPhChunk_ViewSortings_Open;     Parent: IPhChunk_View_Open;          Tag: 'sortings'           ),
    (Code: IPhChunk_ViewSorting_Open;      Parent: IPhChunk_ViewSortings_Open;  Tag: 'sorting'            ),
    (Code: IPhChunk_Pics_Close;            Tag: ''                   ),
    (Code: IPhChunk_Pic_Close;             tag: ''                   ),
    (Code: IPhChunk_Group_Close;           Tag: ''                   ),
    (Code: IPhChunk_Groups_Close;          Tag: ''                   ),
    (Code: IPhChunk_GroupPics_Close;       Tag: ''                   ),
    (Code: IPhChunk_Views_Close;           Tag: ''                   ),
    (Code: IPhChunk_View_Close;            Tag: ''                   ),
    (Code: IPhChunk_ViewGroupings_Close;   Tag: ''                   ),
    (Code: IPhChunk_ViewGrouping_Close;    Tag: ''                   ),
    (Code: IPhChunk_ViewSortings_Close;    Tag: ''                   ),
    (Code: IPhChunk_ViewSorting_Close;     Tag: ''                   ));

   // Search ChunkInfoTable by chunk code
  function ChunkInfoByCode(Code: TPhChunkCode): PChunkInfo;
  var
    I: Integer;
  begin
    for I := 0 to High(ChunkInfoTable) do begin
      Result := @ChunkInfoTable[I];
      if Result.Code = Code then
         Exit;
    end;
    Result := nil;
  end;

   // Search ChunkInfoTable by tag name and parent code
  function ChunkInfoByTag(ParentCode: TPhChunkCode; Tag: string): PChunkInfo;
  var
    I: Integer;
  begin
    for I := 0 to High(ChunkInfoTable) do begin
      Result := @ChunkInfoTable[I];
      if (Result.Parent = ParentCode) and (CompareText(Result.Tag, Tag) = 0) then
         Exit;
    end;
     // if not found? search amoung items with Parent = 0 (nessesary for "group" tag)
    for I := 0 to High(ChunkInfoTable) do begin
      Result := @ChunkInfoTable[I];
      if (Result.Parent = 0) and (CompareText(Result.Tag, Tag) = 0) then
         Exit;
    end;
  //  raise Exception.CreateFmt('Node not recognised: Name = %s, Parent = %d', [Tag, ParentCode]);
    Result := nil;
  end;


   // this procedure is used due to missed method
   // TPhoaStreamer.WriteChunkValue(Code: TPhChunkCode; Value: Variant);
  procedure WriteChunkValue(Filer: TPhoaStreamer; Code: TPhChunkCode; Value: Variant);
  var
    pe: PPhChunkEntry;
  begin
    pe := FindChunkStrict(Code);
    Filer.WriteChunk(Code, pe.Datatype);
    if Value = Null then begin
      if pe.Datatype in [pcdByte, pcdWord, pcdInt] then
        Value := 0
      else if pe.Datatype in [pcdStringB, pcdStringW, pcdStringI] then
        Value := '';
    end;
    case pe.Datatype of
      pcdByte:    Filer.WriteByte(Value);
      pcdWord:    Filer.WriteWord(Value);
      pcdInt:     Filer.WriteInt(Value);
      pcdStringB: Filer.WriteStringB(Value);
      pcdStringW: Filer.WriteStringW(Value);
      pcdStringI: Filer.WriteStringI(Value);
    end;
  end;







  { TPhoaConverter }

  procedure TPhoaConverter.Convert;

    procedure ShowProgress;
    begin
      if FProgressor <> nil then
        FProgressor.Progress := PhoaStreamer.Stream.Position / PhoaStreamer.Stream.Size;
    end;

     // calls specific value-convertion procedure if assigned
    procedure ConvertValue(Node: IXMLNode; ChunkInfo: PChunkInfo; var Value: Variant);
    var
      NodeData: TNodeData;
    begin
      if Assigned(ChunkInfo.Proc) then begin
        NodeData.Value := Value;
        NodeData.XmlNode := Node;
        NodeData.Code := ChunkInfo.Code;
        ChunkInfo.Proc(Self, NodeData);
        Value := NodeData.Value;
      end;
    end;

     // Phoa-Xml conversion for the single node and its children
    procedure ConvertToXml(Node: IXMLNode; ParentCode: TPhChunkCode);
    var
      Code: TPhChunkCode;
      Datatype: TPhChunkDatatype;
      vValue: Variant;
      ChunkInfo: PChunkInfo;
      Mapping: TXmlMapping;
    begin
      while PhoaStreamer.ReadChunkValue(Code, Datatype, vValue, True, True) = rcrOK do begin
        ShowProgress;
        if IsCloseChunk(Code, ParentCode) then
          Exit;
        ChunkInfo := ChunkInfoByCode(Code);
        if (ChunkInfo <> nil) and (ChunkInfo.Tag <> '') then begin
          if IsOpenChunk(Code) then
            ConvertToXml(Node.AddChild(ChunkInfo.Tag), Code)
          else begin
            ConvertValue(Node, ChunkInfo, vValue);
            Mapping := ChunkInfo.Mapping;
            if Mapping = xmDefault then
              Mapping := Self.Mapping;
            if Mapping = xmDefault then
              Mapping := DefaultXmlMapping;
            if Mapping = xmNode then
              Node.AddChild(ChunkInfo.Tag).Text := vValue
            else
              Node.SetAttributeNS(ChunkInfo.Tag, '', vValue);
          end;
        end;
      end;
    end;

     // Xml-Phoa conversion for the single node and its children
    procedure ConvertToPhoa(Node: IXMLNode; ParentCode: TPhChunkCode);
    var
      ChunkInfo: PChunkInfo;
      I: Integer;
      Value: Variant;
    begin
      for I := 0 to Node.AttributeNodes.Count - 1 do begin
        ShowProgress;
  //      WriteLn(Node.AttributeNodes[I].NodeName);
        ChunkInfo := ChunkInfoByTag(ParentCode, Node.AttributeNodes[I].NodeName);
        if ChunkInfo <> nil then begin
          Value := Node.AttributeNodes[I].NodeValue;
          ConvertValue(Node, ChunkInfo, Value);
          WriteChunkValue(PhoaStreamer, ChunkInfo.Code, Value);
        end;
      end;
      for I := 0 to Node.ChildNodes.Count - 1 do begin
        ShowProgress;
  //      WriteLn(Node.ChildNodes[I].NodeName);
        ChunkInfo := ChunkInfoByTag(ParentCode, Node.ChildNodes[I].NodeName);
        if ChunkInfo <> nil then begin
          if Node.ChildNodes[I].IsTextElement then begin
            Value := Node.ChildNodes[I].Text;
            ConvertValue(Node, ChunkInfo, Value);
            WriteChunkValue(PhoaStreamer, ChunkInfo.Code, Value);
          end else begin
            if IsOpenChunk(ChunkInfo.Code) then
              PhoaStreamer.WriteChunk(ChunkInfo.Code);
            ConvertToPhoa(Node.ChildNodes[I], ChunkInfo.Code);
            if IsOpenChunk(ChunkInfo.Code) then
              PhoaStreamer.WriteChunk(ChunkInfo.Code or $8000);
          end;
        end;
      end;
    end;


  begin
    if Direction = cdPhoaToXml then begin
      CreateDir(PhoaStreamer.BasePath + ThumbnailSubDir);
      PhoaStreamer.ReadHeader;
      ConvertToXml(XmlDoc.AddChild('album'), 0);
    end else begin
      PhoaStreamer.WriteHeader;
      ConvertToPhoa(XmlDoc.DocumentElement, 0);
    end;
  end;

  constructor TPhoaConverter.Create;
  begin
    inherited;
    FExtractMetadata := false;
    FCopyThumbnails := true;
    FThumbnailSubDir := 'Thumbs';
    FDirection := cdPhoaToXml;
    FTimeShift := 0;
    FMapping := xmDefault;
  end;


end.
