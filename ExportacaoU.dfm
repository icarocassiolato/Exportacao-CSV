object ExportacaoFrm: TExportacaoFrm
  Left = 0
  Top = 0
  Caption = 'Exporta'#231#227'o CSV'
  ClientHeight = 149
  ClientWidth = 194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BtnExportar: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Exportar'
    TabOrder = 0
    OnClick = BtnExportarClick
  end
  object RgpModoExportacao: TRadioGroup
    Left = 0
    Top = 64
    Width = 194
    Height = 85
    Align = alBottom
    Caption = 'Modo de exporta'#231#227'o'
    ItemIndex = 0
    Items.Strings = (
      'Todos os registros'
      'M'#234's espec'#237'fico')
    TabOrder = 1
    OnClick = RgpModoExportacaoClick
  end
  object EdtMes: TEdit
    Left = 99
    Top = 117
    Width = 46
    Height = 21
    Enabled = False
    MaxLength = 2
    TabOrder = 2
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT *'
      '  FROM MOVIMENTACAO')
    Left = 96
    Top = 8
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'Database=C:\CARTEIRA.FDB'
      'Password=masterkey'
      'User_Name=sysdba')
    Connected = True
    LoginPrompt = False
    Left = 64
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 160
    Top = 8
  end
end
