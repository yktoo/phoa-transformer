unit Progressor;

interface
uses SysUtils;

type
  IProgressor = interface(IInterface)
     // Prop handlers
    procedure SetText(const Value: String);
    procedure SetProgress(const Value: Double);
     // Props
    property Text: String write SetText;
    property Progress: Double write SetProgress;
  end;

  TProgressorCreateFunc = function: IProgressor;

const
  NoProgress = -1;

  function BeginProgress(const sText: String = ''): IProgressor;
  function SetProgressor(Value: TProgressorCreateFunc): TProgressorCreateFunc;

implementation

var
  ProgressorCreateFunc: TProgressorCreateFunc;

  function BeginProgress(const sText: String = ''): IProgressor;
  begin
    if not Assigned(ProgressorCreateFunc) then raise Exception.Create('ProgressorCreateFunc is not specified');
    Result := ProgressorCreateFunc();
    if sText<>'' then Result.Text := sText;
  end;

  function SetProgressor(Value: TProgressorCreateFunc): TProgressorCreateFunc;
  begin
    Result := ProgressorCreateFunc;
    ProgressorCreateFunc := Value;
  end;

end.
