program Project2;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form1},
  MK.AutoFree in 'MK.AutoFree.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := true;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
