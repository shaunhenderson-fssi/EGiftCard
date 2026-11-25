unit EGiftCard;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  System.DateUtils,
  Xml.XMLIntf, Xml.XMLDoc, IdHTTP, IdSSLOpenSSL,
  uXMLDocHelper;

const
  ENDPOINT_URL = 'https://webapp-qa.ezipay.net.nz:52713/';
  APITYPE = 'SALE';
  APIMODE = 'DIGITAL';
  USERNAME = 'yf?e41k^sa^F';
  PASSWORD = '8TQc5OXucie@';
  PRODUCT_ID = '9421009560110'; //egiftcard product ID

type
  TfrmEGiftCard = class(TForm)
    btnSend: TButton;
    edtAmount: TEdit;
    edtTerminalID: TEdit;
    edtTransactionID: TEdit;
    lblAmount: TLabel;
    lblTerminalID: TLabel;
    lblTransactionID: TLabel;
    mResponse: TMemo;
    edtRetailerID: TEdit;
    lblRetailerID: TLabel;
    Label1: TLabel;

    procedure btnSendClick(Sender: TObject);
    function CreateXMLRequest: TXMLDocument;
    function SendXMLRequest(XML: TXMLDocument; const URL: string): string;
    procedure ParseXMLResponse(const XMLResponse: string);
    
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  frmEGiftCard: TfrmEGiftCard;

implementation

{$R *.dfm}

procedure TfrmEGiftCard.btnSendClick(Sender: TObject);
var
  XMLRequest: TXMLDocument;
  XMLResponse: string;
begin
  XMLRequest := CreateXMLRequest;
  if XMLRequest.Active then
  begin
    XMLResponse := SendXMLRequest(XMLRequest, ENDPOINT_URL);
    ParseXMLResponse(XMLResponse);
  end;
end;

function TfrmEGiftCard.CreateXMLRequest: TXMLDocument;
var
  RootNode, AuthNode: IXMLNode;
begin
  Result := TXMLDocument.Create(Self);
  Result.Active := True;

  if edtTerminalID.Text = '' then
  begin
    ShowMessage('Error: Terminal ID is empty');
    Result.Active := False;
    Exit;
  end;

  if edtTransactionID.Text = '' then
  begin
    ShowMessage('Error: Transaction ID is empty');
    Result.Active := False;
    Exit;
  end;

  // Add root element
  RootNode := Result.AddChild('REQUEST');
  RootNode.Attributes['TYPE'] := APITYPE; //'SALE'
  RootNode.Attributes['MODE'] := APIMODE; //'DIGITAL'

  // Add AUTHORIZATION
  AuthNode := RootNode.AddChild('AUTHORIZATION');
  AuthNode.AddChild('USERNAME').Text := USERNAME;
  AuthNode.AddChild('PASSWORD').Text := PASSWORD;

  // Add other elements
  RootNode.AddChild('RETAILERID').Text := edtRetailerID.Text;
  RootNode.AddChild('TERMINALID').Text := edtRetailerID.Text + edtTerminalID.Text;
  RootNode.AddChild('PRODUCTID').Text := PRODUCT_ID;
  RootNode.AddChild('TXID').Text := edtTransactionID.Text;
  RootNode.AddChild('LOCALDATETIME').Text := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
  RootNode.AddChild('CURRENCY').Text := 'NZD';
  RootNode.AddChild('AMOUNT').Text := (strToInt(edtAmount.Text) * 100).ToString; //cents

  // Add RECEIPT
  AuthNode := RootNode.AddChild('RECEIPT');
  AuthNode.AddChild('LANGUAGE').Text := 'NZD';
  AuthNode.AddChild('CHARSPERLINE').Text := '32';
  AuthNode.AddChild('TYPE').Text := 'FULLTEXT';
end;

function TfrmEGiftCard.SendXMLRequest(XML: TXMLDocument; const URL: string): string;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  RequestStream, ResponseStream: TStringStream;
begin
  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  RequestStream := TStringStream.Create(XML.XML.Text, TEncoding.UTF8);
  ResponseStream := TStringStream.Create;
  try
    HTTP.IOHandler := SSLHandler;
    HTTP.Request.ContentType := 'application/xml';
    HTTP.Post(URL, RequestStream, ResponseStream);
    Result := ResponseStream.DataString;
  finally
    HTTP.Free;
    SSLHandler.Free;
    RequestStream.Free;
    ResponseStream.Free;
  end;
end;

procedure TfrmEGiftCard.ParseXMLResponse(const XMLResponse: string);
var
  XMLDoc: TXMLDocument;
  RootNode, BalanceNode, PinCredentialsNode: IXMLNode;
begin
  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromXML(XMLResponse);
    XMLDoc.Active := True;
    mResponse.Lines.Clear;

    RootNode := XMLDoc.DocumentElement;
    if Assigned(RootNode) and (RootNode.NodeName = 'RESPONSE') then
    begin
      // Extract basic fields with null checks
      if Assigned(RootNode.ChildNodes.FindNode('RESULTTEXT')) then
        mResponse.Lines.Add('Result Text: ' + RootNode.ChildNodes['RESULTTEXT'].Text);

      if Assigned(RootNode.ChildNodes.FindNode('TXNERROR')) then
        mResponse.Lines.Add('Txn Error: ' + RootNode.ChildNodes['TXNERROR'].Text);

      // Access nested PINCREDENTIALS node
      PinCredentialsNode := RootNode.ChildNodes.FindNode('PINCREDENTIALS');
      if Assigned(PinCredentialsNode) then
      begin
        if Assigned(PinCredentialsNode.ChildNodes.FindNode('PIN')) then
          mResponse.Lines.Add('PIN: ' + PinCredentialsNode.ChildNodes['PIN'].Text);

        if Assigned(PinCredentialsNode.ChildNodes.FindNode('SERIAL')) then
          mResponse.Lines.Add('Serial: ' + PinCredentialsNode.ChildNodes['SERIAL'].Text);

        if Assigned(PinCredentialsNode.ChildNodes.FindNode('SCODE')) then
          mResponse.Lines.Add('SCode: ' + PinCredentialsNode.ChildNodes['SCODE'].Text);
      end;

      // Access BALANCE node
      BalanceNode := RootNode.ChildNodes.FindNode('BALANCE');
      if Assigned(BalanceNode) and Assigned(BalanceNode.ChildNodes.FindNode('CURRENCY')) then
      begin
        BalanceNode := BalanceNode.ChildNodes['CURRENCY'];
        if Assigned(BalanceNode.ChildNodes.FindNode('BALANCE')) then
          mResponse.Lines.Add('Balance: $' + (StrToInt(BalanceNode.ChildNodes['BALANCE'].Text) / 100).ToString); // Convert cents to dollars
      end;
    end;
  finally
    XMLDoc := nil; // Release memory
  end;
end;

initialization

finalization

end.
