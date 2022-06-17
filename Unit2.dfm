object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 24
    Top = 72
    Width = 593
    Height = 209
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 40
    Top = 24
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 1
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=postgres'
      'User_Name=postgres'
      'Password=kainushi'
      'DriverID=PG')
    Connected = True
    Left = 320
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 472
    Top = 8
  end
  object FDTable1: TFDTable
    Active = True
    Connection = FDConnection1
    TableName = 'nametable'
    Left = 184
    Top = 8
  end
end
