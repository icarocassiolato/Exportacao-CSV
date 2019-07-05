unit uExportacaoCSV;

interface

uses
  FireDAC.Comp.Client, Classes;

type
  TExportacaoCSV = class
  private
    FQuery: TFDQuery;
    FCamposExportacao: string;
    FListaCampos: TStringList;
    FResultado: TStringList;
    function GetQuery: TFDQuery;
    procedure SetQuery(const Value: TFDQuery);
    function PrepararQuery: boolean;
    procedure SetCamposExportacao(const Value: string);
    function MontarLinha: string;
    function PegarTodosCampos: string;
    procedure VerificarCamposExportar;
  public
    constructor Create;
    destructor Destroy; override;
    function Exportar(psCaminhoDestino: string): boolean;
    property Query: TFDQuery read GetQuery write SetQuery;
    property CamposExportacao: string read FCamposExportacao write SetCamposExportacao;
  end;

implementation

uses
  SysUtils, Data.DB;

{ TExportacaoCSV }

{$REGION 'construtores'}
constructor TExportacaoCSV.Create;
begin
  FListaCampos := TStringList.Create;
  FResultado := TStringList.Create;
end;

destructor TExportacaoCSV.Destroy;
begin
  FreeAndNil(FListaCampos);
  FreeAndNil(FResultado);
  inherited;
end;
{$ENDREGION}

{$REGION 'getters/setters'}
function TExportacaoCSV.GetQuery: TFDQuery;
begin
  Result := FQuery;
end;

procedure TExportacaoCSV.SetQuery(const Value: TFDQuery);
begin
  FQuery := Value;
end;

procedure TExportacaoCSV.SetCamposExportacao(const Value: string);
begin
  FCamposExportacao := Value;
  ExtractStrings([';'], [' '], PChar(FCamposExportacao), FListaCampos);
end;
{$ENDREGION}

function TExportacaoCSV.PrepararQuery: boolean;
begin
  if FQuery = nil then
    Exit(False);

  if not FQuery.Active then
    FQuery.Open;

  if FQuery.IsEmpty then
    Exit(False);

  Result := True;
end;

procedure TExportacaoCSV.VerificarCamposExportar;
begin
  if (FListaCampos.Count = 0) or (Trim(FListaCampos.Text) = '*') then
    SetCamposExportacao(PegarTodosCampos);
end;

function TExportacaoCSV.MontarLinha: string;
var
  i: Integer;
begin
  Result := EmptyStr;
  for i := 0 to Pred(FListaCampos.Count) do
    Result := Result + FQuery.FieldByName(FListaCampos[i]).AsString + ';';
end;

function TExportacaoCSV.Exportar(psCaminhoDestino: string): boolean;
begin
  if not PrepararQuery then
    Exit(False);

  VerificarCamposExportar;
  FResultado.Clear;
  FResultado.Add(FCamposExportacao);
  try
    FQuery.First;
    while not FQuery.Eof do
    begin
      FResultado.Add(MontarLinha);
      FQuery.Next;
    end;

    FResultado.SaveToFile(psCaminhoDestino);
    Result := True;
  except
    Result := False;
  end;
end;

function TExportacaoCSV.PegarTodosCampos: string;
var
  fField: TField;
begin
  for fField in FQuery.Fields do
    Result := Result + fField.FieldName + ';';
end;

end.
