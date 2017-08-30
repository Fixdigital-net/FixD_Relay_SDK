object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 333
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ComboBox1: TComboBox
    Left = 24
    Top = 8
    Width = 137
    Height = 21
    TabOrder = 0
    TextHint = 'Select Comport'
  end
  object Button1: TButton
    Left = 175
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Refresh COM'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 64
    Width = 353
    Height = 233
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object Button3: TButton
    Left = 408
    Top = 62
    Width = 75
    Height = 25
    Caption = '1: ON '
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 489
    Top = 62
    Width = 75
    Height = 25
    Caption = '1: OFF'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 489
    Top = 102
    Width = 75
    Height = 25
    Caption = '12: OFF'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 408
    Top = 102
    Width = 75
    Height = 25
    Caption = '12: ON'
    TabOrder = 7
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 440
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Button7'
    TabOrder = 8
    OnClick = Button7Click
  end
end
