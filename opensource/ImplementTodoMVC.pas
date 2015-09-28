unit ImplementTodoMVC;

interface

(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ImplementTodoMVC
  ========================
  Implementation of Abstract TodoMVC model classes

  version 0.1 )

  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)



uses
  Classes,
  ToDoAbstract,
  ToDoIt,
  AbstractTodoMvc,
  TodoZip;

type

  TZipFile = Class(TChildTodo, IZipSigleFile)
  strict private
    zip: IZip;
    rootfilezip: SString;
  public
    constructor Create(sy: TComponent); override;
    Destructor Destroy; override;
    function GetFile(const namf: SString; var resulta: TResulTodo):boolean; override;
    procedure SetZipFile(const nazip: SString);
  end;

  TFileSearchModes =(fsmLazy,fsmZips);
  TFileSearchSet = set of TFileSearchModes;


  TFileList = Class(TChildTodo, IChildTodo)
  private
    fMode:TFileSearchSet;
  public

    constructor Create(sy: TComponent); override;
    Destructor Destroy; override;
    procedure SetPath(const pa: SString); override;

    function GetFile(const narel: SString; var resulta: TResulTodo):boolean; override;
    property Mode:TFileSearchSet read fMode write fMode;
  protected
    Procedure GetDirecX(const directorio, masc, search: SString; pila_: Tit);
  private
    ListFileDir: TStringList;
    public_resources: Tit;
  end;

  TBasicTodoServer = Class(TTodoServerCustom)
  protected
    Childs: TList;
  public
    FileManager: IScriptTodo;//TAngularFileManager;
    constructor Create(sy: TComponent); override;
    Destructor Destroy; override;
    function CreateChild(chil: TClassChildTodo): TChildTodo;
    function InjectSingleZip(const zipName: SString): IZipSigleFile;override;
    function GetFilePost(const url, post: SString): TResulTodo; override;
  end;

  TLog = class(TLogAbstract)
    procedure Log(const describe: SString); override;
  end;

implementation

uses
  ToDo_Angular_Filemanager,
  ToDoMiMes,

  ToDoNanoX,
  ToDoS,
  SysUtils;

destructor TZipFile.Destroy;
begin
  zip := nil;
  inherited Destroy;
end;

procedure TZipFile.SetZipFile(const nazip: SString);
begin
  zip := nil;
  zip := ZipInjection(nazip);
  fPath:=nazip;
  rootfilezip := LowerCase(PathNombre(nazip));
end;

constructor TZipFile.Create(sy: TComponent);
begin
  inherited Create(sy);
  zip := Nil; // ZipInjection(nombreTestZip);
end;

//function TZipFile.GetFile(const namf: SString): TResulTodo;
function TZipFile.GetFile(const namf: SString; var resulta: TResulTodo):boolean; 
var
  nom: SString;
begin
  nom := namf;
  try
    if zip=nil then
    begin
      result:=False;
      exit;
    end;
    resulta.Fichero := zip.Extract(rootfilezip + nom);
    if Resulta.Fichero = '' then
    begin
      resulta.Fichero:= zip.Extract(nom, true);
    end;

    result:=Resulta.Fichero <> '';
    if result then
    begin
      resulta.Ruta_ := zip.LastZiped;
      resulta.zip := fpath; //zip file name
    end;
  except
    result := false
  end;
end;

destructor TFileList.Destroy;
begin
  ListFileDir.Free;
  inherited;
end;

constructor TFileList.Create(sy: TComponent);
begin
  inherited Create(sy);
  fMode:=[];
  ListFileDir := TStringList.Create;
  public_resources := nil;

end;

//function TFileList.GetFile(const narel: SString): TResulTodo;
function TFileList.GetFile(const narel: SString; var resulta: TResulTodo):boolean;
var
  x: Tit;
  namf: SString;
begin
  ResetRT(resulta);
  result:=false;
  if public_resources = nil then
  begin
    exit;
  end;
  x := public_resources.FindAt('alias', Upst(PathNomExt(narel)), true);
  if x <> nil then
  begin
    namf := x.Attribute('name');
    resulta.Fichero :=ToDoS.GetFile(namf);
    resulta.Ruta_ := namf;
    result:=Resulta.Fichero <> ''
  end
  else
  begin
    WarningTodo([narel, ' not found']);
  end;
end;



Procedure TFileList.GetDirecX
          (const directorio, masc, search: SString; pila_: Tit);
var
  r: tSearchRec;
  nf,
  find,
  gets,
  msc: SString;
  simple, UPEX: SString;
  x: Tit;
  b: Boolean;
begin
  msc := Trim(masc);
  if msc = '' then
  begin
    msc := '*.*';
  end;
  find := DirecNombre(directorio, msc);

  server.Log(directorio);
  begin
    if FindFirst(find, faanyfile, r) = 0 then
    begin

      repeat
        nf := DirecNombre(directorio, r.name);

        if r.name[1] <> '.' then
        begin
          if ((r.Attr and fadirectory) = 0) then
          Begin
            b := search = '';
            if not b then
            begin
              gets :=ToDoS.GetFile(nf);
              b := System.Pos(search, gets) > 0
            end;
            if b then
            begin

              simple := Upst(PathNombre(nf));
              x := pila_.Ti('RG');
              x.SetAttribute('name', nf);
              x.SetAttribute('tipo', 'file');
              x.SetAttribute('simple', simple);
              // x.SetAttribute('alias', Upst(r.name));

              UPEX := PathExt(nf);

              if UPEX = 'ZIP' then
              if fsmZips in fmode then
              
              begin
                server.InjectSingleZip(nf);
//                x.SetAttribute('zip', '1');
                // ?       x.SetAttribute('alias', Upst(r.name));
              end;
            end;
          end
        end;

      until FindNext(r) <> 0;
    end;
    SysUtils.FindClose(r);
    if FindFirst(find, faanyfile, r) = 0 then
    begin

      repeat
        nf := DirecNombre(directorio, r.name);

        if r.name[1] <> '.' then
        begin
          if ((r.Attr and fadirectory) = fadirectory) then
          begin
            x := pila_.Ti('RG');
            x.SetAttribute('name', nf);
            x.SetAttribute('tipo', 'dir');
            if fsmLazy in fmode then
            begin
              GetDirecX(nf, masc, search, pila_);
            end
          end
        end;

      until FindNext(r) <> 0;

    end;
    SysUtils.FindClose(r);
  end;
end;

procedure TFileList.SetPath(const pa: SString); // virtual;
begin
  fPath := pa;
  freeNil(public_resources);
  public_resources := TXml.Create('public_resources');
  GetDirecX(pa, '*.*', '', public_resources);
end;

function TBasicTodoServer.InjectSingleZip(const zipName: SString): IZipSigleFile;
begin
  if exists(zipName) then
  begin
   result := TZipFile(CreateChild(TZipFile));
   result.SetZipFile(zipName);
  end else
  begin
    result:=nil;
    Log('Not Found:'+zipName);
  end;


end;

(*
  url: url path (with params if possible)
  post: Posted content in POST request types.
  result: The file related or decompressed.
*)
function TBasicTodoServer.GetFilePost(const url, post: SString): TResulTodo;
var
  mas,ruta,nom: SString;
  chil: Pointer;
begin
  ResetRT(result);
  nom := url;

  while zipping do
  begin
    Sleep(100)
  end;
  zipping := true;
  try
    DelFirstString(nom, TodoURL);
    for chil in Childs do
    begin
      if TChildTodo(chil).ProgUrl = nom then
      begin
        result := TScriptTodo(chil).doProgram(nom, post);
        if result.Fichero <> '' then
        begin
       //   break;
        end;
        exit;
      end;
    end;
    if result.Fichero= '' then
    begin
      nom := Unix2Dos(nom);
      if nom = '' then
      begin
        nom := defaultIndex;
      end
      ELSE if nom[Length(nom)] = '\' then
      begin
        nom := nom + defaultIndex;
      end;
      ruta:= Ospath(TodoFiles__, nom);
      result.Fichero :=ToDoS.GetFile(ruta);
      result.Ruta_:=ruta;
      if result.Fichero = '' then
      begin
        for chil in Childs do
        begin
  //        result :=
          if TChildTodo(chil).GetFile(nom,result) then
//          if result.Fichero <> '' then
          begin
            break;
          end;
        end;
      end;
    end;

    mas:= result.zip;
    //?if result.Fichero ='' then
    begin

    Log(StToLog(result.Fichero <> '', url, result.Ruta_));
    if mas<>'' then
    begin
       Log(' zip:'+mas);
    end;
    end;
    result.Mime := MimeType(url);
    if result.Mime='' then
    begin
           result.Mime := MimeType(url);
    end;
  finally
    zipping := False;
  end;
end;


function TBasicTodoServer.CreateChild(chil: TClassChildTodo): TChildTodo;
begin
  result := chil.Create(Self);
  Childs.Add(result)
end;

constructor TBasicTodoServer.Create(sy: TComponent);
begin
  inherited Create(sy);
  Logs := InjectionLog(TLog);
  Childs := TList.Create;
  FileManager := TAngularFileManager(CreateChild(TAngularFileManager));
end;

destructor TBasicTodoServer.Destroy;
begin
  freeNil(Childs);
  inherited;
end;

{ TLog }

procedure TLog.Log(const describe: SString);
begin
  Writeln(describe);
end;

end.
