object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 317
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 8
    Width = 107
    Height = 13
    Caption = 'Server Port Listening :'
  end
  object Edit1: TEdit
    Left = 145
    Top = 8
    Width = 56
    Height = 21
    MaxLength = 5
    NumbersOnly = True
    TabOrder = 0
    Text = '2666'
  end
  object Button1: TButton
    Left = 126
    Top = 177
    Width = 91
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 35
    Width = 209
    Height = 136
    Caption = ' EndPoint / Device '
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 22
      Width = 27
      Height = 13
      Caption = 'Port :'
    end
    object Label4: TLabel
      Left = 16
      Top = 49
      Width = 20
      Height = 13
      Caption = 'SN :'
    end
    object Label5: TLabel
      Left = 16
      Top = 76
      Width = 59
      Height = 13
      Caption = 'Secret Key :'
    end
    object Label6: TLabel
      Left = 16
      Top = 103
      Width = 27
      Height = 13
      Caption = 'Tipe :'
    end
    object Edit4: TEdit
      Left = 129
      Top = 19
      Width = 64
      Height = 21
      Alignment = taRightJustify
      MaxLength = 5
      NumbersOnly = True
      TabOrder = 0
      Text = '2666'
    end
    object Edit5: TEdit
      Left = 129
      Top = 46
      Width = 64
      Height = 21
      Alignment = taRightJustify
      MaxLength = 8
      TabOrder = 1
      Text = 'FD000001'
    end
    object Edit6: TEdit
      Left = 129
      Top = 73
      Width = 64
      Height = 21
      Alignment = taRightJustify
      MaxLength = 8
      NumbersOnly = True
      TabOrder = 2
      Text = '9999'
    end
    object ComboBox1: TComboBox
      Left = 81
      Top = 100
      Width = 112
      Height = 21
      ItemIndex = 0
      TabOrder = 3
      Text = '---- Pilih ----'
      Items.Strings = (
        '---- Pilih ----'
        'FixD Relay 8 Sw'
        'FixD Relay 16 Sw'
        'FixD Relay 24 Sw')
    end
  end
  object Panel1: TPanel
    Left = 223
    Top = 248
    Width = 233
    Height = 61
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 3
    object Label2: TLabel
      Left = 16
      Top = 12
      Width = 56
      Height = 13
      Caption = 'Send CMD :'
    end
    object Edit2: TEdit
      Left = 16
      Top = 31
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit2'
    end
    object Button2: TButton
      Left = 143
      Top = 31
      Width = 75
      Height = 21
      Caption = 'Send CMD'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 248
    Top = 8
    Width = 201
    Height = 217
    Caption = ' Relay Controls '
    TabOrder = 4
    object Button3: TButton
      Left = 24
      Top = 27
      Width = 75
      Height = 25
      Caption = 'No.1 - ON'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 24
      Top = 58
      Width = 75
      Height = 25
      Caption = 'No.12 - ON'
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 105
      Top = 27
      Width = 75
      Height = 25
      Caption = 'No.1 - OFF'
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 105
      Top = 58
      Width = 75
      Height = 25
      Caption = 'No.12 - OFF'
      TabOrder = 3
      OnClick = Button6Click
    end
    object Button8: TButton
      Left = 24
      Top = 89
      Width = 156
      Height = 25
      Caption = 'All On'
      TabOrder = 4
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 24
      Top = 120
      Width = 156
      Height = 25
      Caption = 'All Off'
      TabOrder = 5
      OnClick = Button9Click
    end
    object Button7: TButton
      Left = 24
      Top = 169
      Width = 75
      Height = 25
      Caption = 'Get Status'
      TabOrder = 6
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 232
    Width = 209
    Height = 77
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 5
    object Button10: TButton
      Left = 16
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Change Secret'
      TabOrder = 0
    end
    object Button11: TButton
      Left = 112
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Change Wifi'
      TabOrder = 1
    end
    object Button12: TButton
      Left = 16
      Top = 43
      Width = 75
      Height = 25
      Caption = 'Reboot'
      TabOrder = 2
    end
  end
end
