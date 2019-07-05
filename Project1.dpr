program Project1;

uses
  Vcl.Forms,
  ExportacaoU in 'ExportacaoU.pas' {ExportacaoFrm},
  uExportacaoCSV in 'uExportacaoCSV.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TExportacaoFrm, ExportacaoFrm);
  Application.Run;
end.
