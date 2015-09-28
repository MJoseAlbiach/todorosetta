program todo2;

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

{$APPTYPE CONSOLE}

{%TogetherDiagram 'ModelSupport_todo2\default.txaPackage'}

uses
  Todo_Mormot_Zip,
  ToDo_Mormot_Server in 'ToDo_Mormot_Server.pas',
  Todo2Custom in 'Todo2Custom.pas';

Procedure MainProgram;
begin
  with TServerMormot.Create(PortTodo,MainPathTodo, NombreZipTodo) do
  try
    writeln ('Server running on http://localhost:'+PortTodo+'/todo/index.html'+
      'Press [Enter] to quit');
    readln;
  finally
    Free;
  end;
end;


begin
  PreviusMainProgram;
  MainProgram;
end.




CustomerManagerStandard-master  
