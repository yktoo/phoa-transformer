[Setup]
  MinVersion             = 4.0,4.0
  AppName                = PhoA Transformer
  AppVersion             = 1.0
  AppVerName             = PhoA Transformer v1.0
  AppCopyright           = Copyright ©2001-2004 M. Virovets, portions D. Kann
  AppPublisher           = SourceForge
  AppPublisherURL        = http://sourceforge.net/projects/phoatrans
  AppSupportURL          = http://sourceforge.net/projects/phoatrans
  AppUpdatesURL          = http://sourceforge.net/projects/phoatrans
  AllowNoIcons           = yes
  DisableStartupPrompt   = yes
  DefaultDirName         = {pf}\PhoATransformer
  DefaultGroupName       = PhoA Transformer
  OutputDir              = .
  OutputBaseFilename     = phoatrans-setup-1.0
  VersionInfoVersion     = 1.0
  VersionInfoTextVersion = 1.0
  ; -- Compression
  SolidCompression       = yes
  Compression            = lzma

[Languages]
  Name: "en"; MessagesFile: compiler:Default.isl;           LicenseFile: License.txt
  Name: "ru"; MessagesFile: compiler:Languages\Russian.isl; LicenseFile: License.txt

[Tasks]
  Name: desktopicon;        Description: {cm:CreateDesktopIcon};     GroupDescription: {cm:AdditionalIcons};
  Name: desktopicon\common; Description: {cm:IconsAllUsers};         GroupDescription: {cm:AdditionalIcons}; Flags: exclusive
  Name: desktopicon\user;   Description: {cm:IconsCurUser};          GroupDescription: {cm:AdditionalIcons}; Flags: exclusive unchecked
  Name: quicklaunchicon;    Description: {cm:CreateQuickLaunchIcon}; GroupDescription: {cm:AdditionalIcons};

[Components]
;English entries
  Name: main;         Languages: en; Description: "Main Files";                     Types: full compact custom; Flags: fixed
  Name: help;         Languages: en; Description: "Help Files";                     Types: full
  Name: help\ru;      Languages: en; Description: "Russian";                        Types: full
  Name: templates;    Languages: en; Description: "XSLT Templates";                 Types: full
  Name: templates\en; Languages: en; Description: "English";                        Types: full
  Name: templates\ru; Languages: en; Description: "Russian";                        Types: full
  Name: langs;        Languages: en; Description: "Additional interface languages"; Types: full
  Name: langs\ru;     Languages: en; Description: "Russian";                        Types: full
;Russian entries
  Name: main;         Languages: ru; Description: "Основные файлы";                  Types: full compact custom; Flags: fixed
  Name: help;         Languages: ru; Description: "Файлы Справочной системы";        Types: full
  Name: help\ru;      Languages: ru; Description: "Русский язык";                    Types: full
  Name: templates;    Languages: ru; Description: "Шаблоны XSLT";                    Types: full
  Name: templates\en; Languages: ru; Description: "Английский язык";                 Types: full
  Name: templates\ru; Languages: ru; Description: "Русский язык";                    Types: full
  Name: langs;        Languages: ru; Description: "Дополнительные языки интерфейса"; Types: full
  Name: langs\ru;     Languages: ru; Description: "Русский";                         Types: full

[Files]
;Application files
  Source: "..\PhoaTransform.exe";              DestDir: "{app}";               Components: main
;Help files
  Source: "..\..\help\PhoaTransform.chm";      DestDir: "{app}";               Components: help\ru
;Additional language files
  Source: "..\language\Russian.lng";           DestDir: "{app}\Language";      Components: langs\ru
;English Templates
  Source: "..\..\templates\enu\Labels.xsl";    DestDir: "{app}\Templates\enu"; Components: templates\en
  Source: "..\..\templates\enu\metadata.xml";  DestDir: "{app}\Templates\enu"; Components: templates\en
  Source: "..\..\templates\enu\Preview.xsl";   DestDir: "{app}\Templates\enu"; Components: templates\en
  Source: "..\..\templates\enu\TextTable.xsl"; DestDir: "{app}\Templates\enu"; Components: templates\en
;Russian Templates
  Source: "..\..\templates\rus\Labels.xsl";    DestDir: "{app}\Templates\rus"; Components: templates\ru
  Source: "..\..\templates\rus\metadata.xml";  DestDir: "{app}\Templates\rus"; Components: templates\ru
  Source: "..\..\templates\rus\Preview.xsl";   DestDir: "{app}\Templates\rus"; Components: templates\ru
  Source: "..\..\templates\rus\TextTable.xsl"; DestDir: "{app}\Templates\rus"; Components: templates\ru

[INI]
  Filename: "{app}\phoatrans.url"; Section: "InternetShortcut"; Key: "URL"; String: "http://sourceforge.net/projects/phoatrans"

[Icons]
;English entries
  Name: "{group}\PhoA Transformer help (Russian)";            Languages: en; Filename: "{app}\PhoaTransform.chm"; Components: help\ru;
;Russian entries
  Name: "{group}\Справка по PhoA Transformer (Русский язык)"; Languages: ru; Filename: "{app}\PhoaTransform.chm"; Components: help\ru;
;Common entries
  Name: "{group}\{cm:UninstallProgram,PhoA Transformer}";     Filename: "{uninstallexe}";          Components: main;
  Name: "{group}\{cm:ProgramOnTheWeb,PhoA Transformer}";      Filename: "{app}\phoatrans.url";     Components: main;
  Name: "{group}\PhoA Transformer";                           Filename: "{app}\PhoaTransform.exe"; Components: main;
  Name: "{commondesktop}\PhoA Transformer";                   Filename: "{app}\PhoaTransform.exe"; Components: main; Tasks: desktopicon\common
  Name: "{userdesktop}\PhoA Transformer";                     Filename: "{app}\PhoaTransform.exe"; Components: main; Tasks: desktopicon\user
  Name: "{code:QuickLaunch|{pf}}\PhoA Transformer";           Filename: "{app}\PhoaTransform.exe"; Components: main; Tasks: quicklaunchicon

[Run]
  Filename: "{app}\PhoaTransform.exe"; Description: {cm:LaunchProgram,PhoA Transformer}; Flags: nowait postinstall skipifsilent

[UninstallDelete]
  Type: files;      Name: "{app}\phoatrans.url"
  Type: files;      Name: "{app}\PhoaTransform.ini"
  Type: dirifempty; Name: "{app}"

[Messages]
BeveledLabel=- InnoSetup - www.jrsoftware.org

[CustomMessages]
; English
en.IconsAllUsers=For all users
en.IconsCurUser=For the current user only
; Russian
ru.IconsAllUsers=Для всех пользователей
ru.IconsCurUser=Только для текущего пользователя

[Code]

  function QuickLaunch(Default: String): String;
  begin
    Result := ExpandConstant('{userappdata}')+'\Microsoft\Internet Explorer\Quick Launch';
  end;

