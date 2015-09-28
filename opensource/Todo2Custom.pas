unit Todo2Custom;

interface
(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....

  Todo2Custom
  ========================
   basic configuration of  todo2

  version 0.1 )

  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)


uses ToDoAbstract;

var
  NombreZipTodo :String= 'todomvc-master.zip';
  MainPathTodo:SString='';
  PortTodo:SString='8082';


Function HelpTodo2Line:String;
Procedure PreviusMainProgram;


implementation


uses
  ToDoS,
  ToDoMiMes,
  Classes;

const

  Todo2_Help =// ' --help' + EOL+
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


Function HelpTodo2Line:String;
begin
  result:=Todo2_Help
end;


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
          PortTodo:=s;
        end else

        if na='--path' then
        begin
          MainPathTodo:=s;
        end else
        begin
          if i=1 then
          begin
             NombreZipTodo:=na;
          end;
        end;
      end;
    except

    end;
 end;





Procedure PreviusMainProgram;
var s:TStringList;
    nazip:SString;
begin

 MainPathTodo:=ActualDos;
 if MainPathTodo='' then
 begin
   MainPathTodo:=ExePath
 end;
 s:=PrintParametros;
 try
  if ParamCount=0 then
  begin
    Writeln(HelpTodo2Line);
  end;
  nazip:=NombreZipTodo;
  if not Exists(nazip) then
  begin
    nazip:=ConBarra(MainPathTodo)+PathNomExt(NombreZipTodo);
  end;
  if not ExtensionIsZip(nazip) then
  begin
    nazip:=nazip+'.zip';
  end;

  if ExtensionIsZip(nazip) then
  begin
    NombreZipTodo:=  nazip;
  end;


 finally
   Freenil(s);
 end;
end;



end.
