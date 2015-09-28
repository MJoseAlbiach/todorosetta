program todo2XE7;
{$APPTYPE CONSOLE}
(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  todo2
  ========================
  http server for todoMVC project

  version 0.1 ) - Initial version.

  ******** This file is under construction ********
  *** Please don't use it in production project ***
*)

{ %TogetherDiagram 'ModelSupport_todo2\default.txaPackage' }

uses

  Todo_Mormot_Zip,
  ToDo_Mormot_Server in 'ToDo_Mormot_Server.pas',
  Todo2Custom in 'Todo2Custom.pas';

Procedure MainProgram;

begin
  with TServerMormot.Create(PortTodo, MainPathTodo, NombreZipTodo) do
    try
      writeln('Server running on http://localhost:' + PortTodo +
        '/todo/index.html' + 'Press [Enter] to quit');
      readln;
    finally
      Free;
    end;
end;

begin
  PreviusMainProgram;
  MainProgram;

end.

  uses ToDoTodoMwc, SynCrtSock, AbstractTodoMvc, Todo_zip_xe, ToDoS;

type

  TTestServer = class
  protected
    fServer: THttpServer;
    todo: TTodoServer;
    function Process(Ctxt: THttpServerRequest): cardinal;
  public
    constructor Create(const Path: String);
    destructor Destroy; override;
  end;

constructor TTestServer.Create(const Path: String);
begin
  todo := TTodoServer.Create(Nil);
  fServer := THttpServer.Create('888');
  fServer.OnRequest := Process;
end;

destructor TTestServer.Destroy;
begin
  todo.Free;
  fServer.Free;
  inherited;
end;

{$WARN SYMBOL_PLATFORM OFF}

function TTestServer.Process(Ctxt: THttpServerRequest): cardinal;
var
  re: TResulTodo;
begin
  re := todo.GetFilePost(Ctxt.URL, Ctxt.InContent);
  Ctxt.OutContent := re;
  Ctxt.OutContentType := re.Mime; // MimeType (Ctxt.URL);
  if re = '' then
  begin
    result := 404;
  end
  else
  begin
    result := 200;
  end;
end;

begin
  with TTestServer.Create(ExePath_) do
    try
      write('Server running on http://localhost:888/todo/index.html' +
        'Press [Enter] to quit');
      readln;
    finally
      Free;
    end;

end.
