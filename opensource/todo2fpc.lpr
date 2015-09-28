program todo2fpc;

//{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  ToDoMiMes,
  ToDoAbstract,
  ToDoS ,
  Todo_Mormot_Zip,
  ToDo_Mormot_Server in 'ToDo_Mormot_Server.pas';





(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  todo2
  ========================
   http server for todoMVC project

  version 0.1 )

  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)

{$APPTYPE CONSOLE}





var

  nombreTestZip :String= 'todomvc-master.zip';
  MainPath:SString='';

  Port:SString='8082';


function PrintParametros:TStringList;
var
  na,s:SString;
  i: Integer;
Begin
    result:=TStringList.Create;
    try
      For i := 0 to ParamCount do
      Begin
        s:=ParamStr(i);
        result.add(s);
        Writeln (i,' ',s);
        na:=FetchVal(s);
        if na='--port' then
        begin
          Port:=s;
        end else

        if na='--path' then
        begin
          MainPath:=s;
        end else
        begin
          if i=1 then
          begin
             nombreTestZip:=na;
          end;
        end;
      end;
    except

    end;
 end;




const

  sHelp =// ' --help' + EOL+
          ' ' +  EOL +
          'Simple HTTP server for todoMVC ' +  EOL +
          '-----------------------------------------------------------------------------' +  EOL +
          'Usage: httpserver angular-filemanager-master  --path=e:\todo\ --port=80' + EOL +
          '-----------------------------------------------------------------------------' +  EOL +
          ' the first param is de main zip project' +  EOL +

//          ' --help                    Print help and exit' +  EOL +
          ' --port                    port. Default=8082 ' +  EOL +
          ' --path                    path of libraries ' +  EOL +
          '-----------------------------------------------------------------------------';





Procedure MainProgram;
var s:TStringList;
    nazip:SString;
begin

 MainPath:=ActualDos;
 if MainPath='' then
 begin
   MainPath:=ExePath
 end;
 s:=PrintParametros;
 try
  if ParamCount=0 then
  begin
    Writeln(sHelp);
  end;
  nazip:=nombreTestZip;
  if not Exists(nazip) then
  begin
    nazip:=ConBarra(MainPath)+PathNomExt(nombreTestZip);
  end;
  if not ExtensionIsZip(nazip) then
  begin
    nazip:=nazip+'.zip';
  end;


  with TServerMormot.Create(port,MainPath,
      nazip) do
  try
    writeln ('Server running on http://localhost:'+port+'/todo/index.html'+
      'Press [Enter] to quit');
    readln;
  finally
    Free;
  end;
 finally
   FreeNil(s);
 end;
end;


begin
  MainProgram;
end.


uses

  Classes,
  ToDoAbstract,

  ToDoS,
  Todo_Mormot_Zip,
  ToDo_Mormot_Server in 'ToDo_Mormot_Server.pas';

