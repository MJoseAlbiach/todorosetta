unit ToDo_Mormot_Server;

interface
{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}


(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Multi-Informática Teruel S.L      '

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ToDo_Mormot_Server
  ========================
  Using SynCrtSock unit as http engine in ToDoRosetta

  version 0.1 )- Initial version.

**** under construction **** Please don't use it in production project ****

*)


uses

  Classes,
  SynCrtSock,
  ToDoAbstract,
  AbstractTodoMvc,
  ImplementTodoMVC
  ;


type


// putting together synopse THttpServer and TodoServer
  TServerMormot = class  //(TObjects)
  public
    todo:TBasicTodoServer;

    constructor Create(const port,Path,zip: String);
    destructor Destroy; override;

    protected
      fServer: THttpServer;
//      function  Processo(const Ctxt: THttpServerRequest): cardinal;
      function Processo( Ctxt: THttpServerRequest):cardinal;
      procedure ConfigureToDo(const mainPath,zipname:String);
  end;



implementation

uses
  ToDoS;



procedure TServerMormot.ConfigureToDo(const mainPath,zipname:String);
begin
  todo.InjectSingleZip (zipName);//?= result


  todo.InjectSingleZip ( Conbarra(mainPath)+'simple-todos-react-master.zip');
  todo.InjectSingleZip ( Conbarra(mainPath)+'meteor-devel.zip');
//?  todo.InjectSingleZip ( Conbarra(mainPath)+'polymer-gmail-master.zip');
//?  todo.InjectSingleZip ( Conbarra(mainPath)+'polymer-master.zip');
//  todo.InjectSingleZip ( Conbarra(mainPath)+'ZhiHuDaily-React-Native-master.zip');
  todo.InjectSingleZip ( Conbarra(mainPath)+'react-native-master.zip');
 // todo.InjectSingleZip ( Conbarra(mainPath)+'angular-master.zip');
  todo.InjectSingleZip ( Conbarra(mainPath)+'angular-filemanager-master.zip');




  With TFileList(todo.CreateChild(TFileList)) do
  begin
 //   mode:=[fsmZips];
    SetPath(mainPath);
  end;
  todo.TodoFiles__ := mainPath;
end;


{ TTodoServer }




//{$WARN SYMBOL_PLATFORM OFF}
function TServerMormot.Processo( Ctxt: THttpServerRequest):cardinal;
//cardinal;
//TOnHttpServerRequest = function(Ctxt: THttpServerRequest): cardinal of object;
var res:TResulTodo;
begin
      res:=todo.GetFilePost(Ctxt.URL,Ctxt.InContent);
      Ctxt.OutContent := res.Fichero;
      Ctxt.OutContentType :=res.Mime;
      if res.Fichero='' then
      begin
        result := 404;
      end else
      begin
        result := 200;
      end;
end;


constructor TServerMormot.Create(const port,Path,zip: String);
begin
  todo:=TBasicTodoServer.Create(Nil);
  ConfigureToDo(Path,zip);
  fServer := THttpServer.Create(port);
  fServer.OnRequest := Processo;
end;


destructor TServerMormot.Destroy;
begin
  todo.Free;
  fServer.Free;
  inherited;
end;


end.

//angularjs-cart-master
//AngularJSFeedReader-master
//angular-invoicing-master
//angular-kickstart-master

//promisees-gh-pages
