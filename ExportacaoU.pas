unit ExportacaoU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, Vcl.ExtCtrls;

type
  TModoExportacao = (meTodos, meEspecifico);

  TExportacaoFrm = class(TForm)
    FDQuery1: TFDQuery;
    BtnExportar: TButton;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    RgpModoExportacao: TRadioGroup;
    EdtMes: TEdit;
    procedure BtnExportarClick(Sender: TObject);
    procedure RgpModoExportacaoClick(Sender: TObject);
  private
    procedure Exportar(psCaminho: string);
    function PegarCaminhoExportacao: string;
    procedure FiltrarDataSet(pbFiltrar: boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportacaoFrm: TExportacaoFrm;

implementation

uses
  uExportacaoCSV, StrUtils;

{$R *.dfm}

function TExportacaoFrm.PegarCaminhoExportacao: string;
begin
  with TSaveDialog.Create(Self) do
  begin
    DefaultExt := 'csv';
    if Execute then
      Result := FileName;
    Free;
  end;
end;

procedure TExportacaoFrm.RgpModoExportacaoClick(Sender: TObject);
begin
  EdtMes.Enabled := RgpModoExportacao.ItemIndex = Ord(meEspecifico);
end;

procedure TExportacaoFrm.Exportar(psCaminho: string);
var
  oExportacao: TExportacaoCSV;
begin
  oExportacao := TExportacaoCSV.Create;
  try
    oExportacao.Query := FDQuery1;
    //Se quiser exportar todos os campos da query, basta deixar essa propriedade sem preencher
    oExportacao.CamposExportacao := 'DATAMOVIMENTACAO;VALOR;IDUSUARIO';

    ShowMessage(IfThen(oExportacao.Exportar(psCaminho),
      'Exportado com sucesso!',
      'Falha ao exportar.'));
  finally
    FreeAndNil(oExportacao);
  end;
end;

procedure TExportacaoFrm.FiltrarDataSet(pbFiltrar: boolean);
begin
  FDQuery1.Filtered := False;

  if not pbFiltrar then
    Exit;

  FDQuery1.Filter := Format('DATE_PART(%s, DATAMOVIMENTACAO) = %s', [QuotedStr('MONTH'), EdtMes.Text]);
  FDQuery1.Filtered := True;
end;

procedure TExportacaoFrm.BtnExportarClick(Sender: TObject);
begin
  if RgpModoExportacao.ItemIndex = Ord(meEspecifico) then
    FiltrarDataSet(True);

  //poderia validar se o caminho é válido,
  //porém não é necessário, pois o except da exportação já cuida disso
  Exportar(PegarCaminhoExportacao);
  FiltrarDataSet(False);
end;

end.
