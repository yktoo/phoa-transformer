unit udOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DKLang;

type
  TdOptions = class(TForm)
    cbLanguage: TComboBox;
    ButtonOK: TButton;
    Button2: TButton;
    dklcMain: TDKLanguageController;
    lLanguage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  end;

var
  dOptions: TdOptions;

implementation
{$R *.dfm}

  procedure TdOptions.FormCreate(Sender: TObject);
  var i: Integer;
  begin
    for i := 0 to LangManager.LanguageCount-1 do begin
      cbLanguage.Items.Add(LangManager.LanguageNames[i]);
      if LangManager.LanguageID = LangManager.LanguageIDs[i] then cbLanguage.ItemIndex := i;
    end;
    // !!! does not work !!!
    // cbLanguage.ItemIndex := LangManager.IndexOfLanguageID(LangManager.LanguageID);
  end;

  procedure TdOptions.ButtonOKClick(Sender: TObject);
  begin
    LangManager.LanguageID := LangManager.LanguageIDs[cbLanguage.ItemIndex];
  end;

end.
