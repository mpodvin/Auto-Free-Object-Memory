unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function LoadFile(const AFileName:string):TStringList;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses  MK.AutoFree;
{$R *.dfm}

function TForm1.LoadFile(const AFileName: string): TStringList;
var
  SFile:TStringList;
begin
  AutoFree(SFile, TStringList.Create);
  // load file or something else
  SFile.LoadFromFile(AFileName);
  Result := TransferPtr(SFile);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  List:TList;
  SList:TStringList;
  SFile:TStringList;
  Bytes, TmpBytes:PByte;
  TmpList,TmpList2:TList;
  i:Integer;
begin
  List := TList.Create;
  AutoFree(List);
  for i := 0 to 99 do List.Add(Pointer(i));
  ShowMessage(IntToStr(List.Count));

  AutoFree(SList, TStringList.Create);
  for i := 0 to 99 do SList.Add(IntToStr(i));
  ShowMessage(IntToStr(SList.Count));

  GetMem(Bytes, 1024*Sizeof(Byte));
  AutoFreeMem(Bytes);

  AutoFree(SFile, LoadFile('..\..\Unit2.pas'));
  ShowMessage(IntToStr(SFile.Count));

  for i := 1 to 10 do
  begin
    TmpList := TList.Create;
    AutoFree(TmpList);
  end;
  for i := 1 to 10 do
  begin
    GetMem(TmpBytes, 1024*Sizeof(Byte));
    AutoFreeMem(TmpBytes);
  end;
  for i := 1 to 10 do
  begin
    AutoFree(TmpList2, TList.Create);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  SList1,SList2,SList3:TStringList;
begin
(*
  SList1 := nil;
  SList2 := nil;
  SList3 := nil;
  try
    SList1 := TStringList.Create;
    SList2 := TStringList.Create;
    SList3 := TStringList.Create;
    //use it!
    //...
  finally
    SList1.Free;
    SList2.Free;
    SList3.Free;
  end;
*)// replaced by :
  AutoFree(SList1, TStringList.Create);
  AutoFree(SList2, TStringList.Create);
  AutoFree(SList3, TStringList.Create);
  //use it!
  //...
end;



end.
