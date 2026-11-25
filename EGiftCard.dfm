object frmEGiftCard: TfrmEGiftCard
  Left = 0
  Top = 0
  Caption = 'EGiftCard'
  ClientHeight = 234
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object lblTerminalID: TLabel
    Left = 8
    Top = 32
    Width = 54
    Height = 13
    Caption = 'Terminal ID'
  end
  object lblTransactionID: TLabel
    Left = 8
    Top = 59
    Width = 70
    Height = 13
    Caption = 'Transaction ID'
  end
  object lblAmount: TLabel
    Left = 8
    Top = 86
    Width = 46
    Height = 13
    Caption = 'Amount $'
  end
  object lblRetailerID: TLabel
    Left = 8
    Top = 5
    Width = 51
    Height = 13
    Caption = 'Retailer ID'
  end
  object Label1: TLabel
    Left = 84
    Top = 32
    Width = 51
    Height = 13
    Caption = 'Retailer ID'
  end
  object edtTerminalID: TEdit
    Left = 152
    Top = 29
    Width = 53
    Height = 21
    NumbersOnly = True
    TabOrder = 1
    Text = '01'
  end
  object edtTransactionID: TEdit
    Left = 84
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'abc123'
  end
  object edtAmount: TEdit
    Left = 84
    Top = 83
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 3
    Text = '100'
  end
  object mResponse: TMemo
    Left = 8
    Top = 150
    Width = 197
    Height = 75
    TabStop = False
    Lines.Strings = (
      'Result Text: OK'
      'Txn error: 0'
      'Barcode: 9014123456789'
      'PIN: 1234'
      'Balance: $0.00')
    TabOrder = 5
  end
  object btnSend: TButton
    Left = 64
    Top = 110
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 4
    OnClick = btnSendClick
  end
  object edtRetailerID: TEdit
    Left = 84
    Top = 2
    Width = 121
    Height = 21
    NumbersOnly = True
    TabOrder = 0
    Text = '121313'
  end
end
