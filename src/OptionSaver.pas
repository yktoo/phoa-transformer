unit OptionSaver;

interface

  function GetOption(const Name: String; const Default: Variant): Variant;
  procedure SetOption(const Name: String; const Value: Variant);

implementation
uses IniFiles, SysUtils;

const
  SecOptions = 'Options';
  
var
  IniFile: TIniFile;

  procedure InitOptions;
  begin
    if IniFile=nil then IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  end;

  function GetOption(const Name: String; const Default: Variant): Variant;
  begin
    InitOptions;
    Result := IniFile.ReadString(SecOptions, Name, Default);
  end;

  procedure SetOption(const Name: String; const Value: Variant);
  begin
    InitOptions;
    IniFile.WriteString(SecOptions, Name, Value);
  end;

initialization
finalization
  IniFile.Free;
end.
