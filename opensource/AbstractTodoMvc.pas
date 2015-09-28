unit AbstractTodoMvc;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  AbstractTodoMvc
  ========================
   Abstraction model for ToDoTodoMVC

  version 0.1 )

  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)

Uses
  Classes,
  ToDoAbstract;

type

  TResulTodo = Record
    Fichero: SString;
    Ruta_: SString;
    Mime: SString;
    zip : SString;
    class operator Implicit(const aValue: TResulTodo): SString;
    class operator Implicit(const aValue: SString): TResulTodo;
  end;


  (*
    only one zip file. the library to test is a zipfile
    rootfilezips : is the general root in the zip file
  *)

  IChildTodo = Interface(ITodoInterface)
//    function GetFile(const namf: SString): TResulTodo;
    function GetFile(const namf: SString; var resulta: TResulTodo):boolean;
    procedure SetPath(const pa: SString);
  end;

  IScriptTodo = interface(IChildTodo)
    function doProgram(const nom, post: SString): TResulTodo;
  end;

  IZipSigleFile = interface(IChildTodo)
    ['{7B9D252B-3C19-42EF-978B-7C268BE7BAF8}']
    procedure SetZipFile(const nazip: SString);
  end;

  ITodoServer = Interface;


  TChildTodo = Class(TInterfacedComponent)
  protected
    server: ITodoServer;

  public
    constructor Create(sy: TComponent); override;
    function GetFile(const namf: SString; var resulta: TResulTodo):boolean; virtual;

    function ProgUrl: SString; virtual;
    procedure SetPath(const pa: SString); virtual;
  protected
    fPath: SString;
  end;

  TClassChildTodo = class of TChildTodo;

  ITodoServer = Interface(ITodoInterface)
    ['{20E5957A-305D-4D27-8D17-E3E23D342413}']
    function GetFilePost(const narel, post: SString): TResulTodo;
    function InjectSingleZip(const zipName: SString): IZipSigleFile;
    procedure Log(const stLog: SString);
  end;


  TTodoServerCustom = Class(TInterfacedComponent, ITodoServer)
  private
    fLogs: ILog;
  protected
    fTodoFiles_: SString;
    fTodoURL: SString;
    defaultIndex: SString;
    zipping: Boolean;
  public
    property Logs: ILog read fLogs write fLogs;
  public
    constructor Create(sy: TComponent); override;
    property TodoURL: SString read fTodoURL write fTodoURL;
    function InjectSingleZip(const zipName: SString): IZipSigleFile; virtual;

    function NewZip(clase: TClassChildTodo): IZipSigleFile;
    function GetFilePost(const url, post: SString): TResulTodo;
      virtual; Abstract;
    procedure Log(const stLog: SString); virtual;
    property TodoFiles__: SString read fTodoFiles_ write fTodoFiles_;
  end;

  TScriptTodo = Class(TChildTodo, IScriptTodo)
  public
    fProgUrl: SString;
    function doProgram(const nom, post: SString): TResulTodo; virtual; Abstract;
    function ProgUrl: SString; override;
  end;

function StToLog(okfile: Boolean; const url, fisicfile: SString): SString;

procedure ResetRT(var rt: TResulTodo);

implementation

uses
  sysutils,
  //ToDo_GetDirectory,
  ToDoS,
  ToDoNanoX;

function StToLog(okfile: Boolean; const url, fisicfile: SString): SString;
begin
  if okfile then
  begin
    result := 'Ok ' + url + ' in ' + fisicfile;
  end
  else
  begin
    result := 'fail ' + url + ' in ' + fisicfile;
  end;
end;

{ TChildTodo }


function TChildTodo.GetFile(const namf: SString; var resulta: TResulTodo):boolean;
begin
  resetrt(resulta);
  result := false;
end;

function TChildTodo.ProgUrl: SString;
begin
  result := ''
end;

procedure TChildTodo.SetPath(const pa: SString);
begin
  fPath := pa
end;

constructor TChildTodo.Create(sy: TComponent);
begin
  inherited Create(sy);
  fPath := '';
  if Supports(sy, ITodoServer) then
  begin
    server := sy as ITodoServer;
  end;
end;

function TTodoServerCustom.InjectSingleZip(
  const zipName: SString): IZipSigleFile;
begin
  result:=nil
end;

procedure TTodoServerCustom.Log(const stLog: SString);
begin
  if Logs <> nil then
  begin
    Logs.Log(stLog);
  end;
end;

function TTodoServerCustom.NewZip(clase: TClassChildTodo): IZipSigleFile;
var
  z: TChildTodo;
begin
  result := nil;
  try
    if clase = nil then
    begin
      result := nil;
      exit;
    end;
    z := TChildTodo(clase.Create(Self));
    if Supports(z, IZipSigleFile) then
    begin
      result := z as IZipSigleFile;
    end;
  except
    result := nil;
  end;
end;

constructor TTodoServerCustom.Create(sy: TComponent);
begin
  inherited Create(sy);
  zipping := False;
  fTodoURL := '/todo';
  defaultIndex := 'index.html';

end;

class operator TResulTodo.Implicit(const aValue: TResulTodo): SString;
begin
  result := aValue.Fichero
end;

class operator TResulTodo.Implicit(const aValue: SString): TResulTodo;
begin
  result.Fichero := aValue;
end;

procedure ResetRT(var rt: TResulTodo);
begin
  rt.Fichero := '';
  rt.Ruta_ := '';
  rt.Mime := '';
  rt.zip:='';
end;

{ TScriptTodo }

function TScriptTodo.ProgUrl: SString;
begin
  result:=fProgUrl
end;

end.

// const  TODOMVC_MASTER='todomvc-master';
