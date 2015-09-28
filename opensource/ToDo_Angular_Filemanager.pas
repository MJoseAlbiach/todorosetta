unit ToDo_Angular_Filemanager;


(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ToDo_Angular_Filemanager
  ========================
  Helper for Angular-FileManager.

  version 0.1 )

  - Helper for Angular-FileManager.

******** This file is under construction ********
*** Please don't use it in production project ***
*)


interface


uses
  Classes,
  TodoZip,
  ToDoAbstract,
  AbstractTodoMvc;



type


  TAngularFileManager= Class(TScriptTodo)
  public

    constructor Create(sy: TComponent); override;
    Destructor Destroy; override;
    function   doProgram(const nom,post: SString): TResulTodo; override;
  end;



implementation

uses
  Variants,
  ToDos,
  SynCommons
  ,SysUtils;

const KKlist ='list';
      KKrename='rename';
      KKcopy='copy';
      KKdelete='delete';
      KKaddforder='addforder';
      KKextract='extract';
      KKsavefile='savefile';
      KKeditfile='editfile';

      (*
const KKERRORrename ='rename ERROR';
      KKERRORcopy ='copy ERROR';
      KKERRORdelete_ ='delete ERROR';
        *)

function normalPath (const enterPath:SString):SString;
var path:SString;
begin
   path:=enterPath;
   DelFirstString(path,'/');
   result:=path;
end;



function ErrorGenerico (const comando:SString): SString;
var  a:Variant;
begin
      a:=_Obj(['sucess',false,'error',comando+' ERROR']);
      result:=_Obj(['result',a]);
end;


Function Xextractpath(const pa: SString): SString;
begin
  result := ExtractFilePath(pa);
end;


function OKoError (ok:Boolean;comando:SString):variant;
var a:Variant;
begin
     a:=null;
      try
      if ok then
      begin
        a:=_Obj(['sucess',true,'error','null']);
      end else
      begin
        a:=_Obj(['sucess',false,'error',comando+' ERROR']);
      end;
      finally
          result:=a;
      end;
end;


function responseVariant (a:variant): SString;
var response:Variant;
begin
      try
       response:=_Obj(['result',a]);
       result:=Sustituir_( response,'"null"','null');;
      except
        result:=ErrorGenerico (KKaddforder);
      end;
end;


(* Rename / Move (URL: fileManagerConfig.renameUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "rename",
    "path": "/public_html/index.php",
    "newPath": "/public_html/index2.php"
}}
JSON Response
{ "result": { "success": true, "error": null } }
*)
function rename(param:Variant): SString;
var path,newPath:SString;
  a:Variant;
begin
      path:=normalPath(param.params.path);
      newPath:=normalPath(param.params.newPath);
      try
      a:=OKoError(RenameFile (path,newpath),KKrename);
      (*
      if RenameFile (path,newpath) then
      begin
        a:=_Obj(['sucess',true,'error','null']);
      end else
      begin
        a:=_Obj(['sucess',false,'error',KKERRORrename]);
      end;
      *)
      result:=responseVariant(a);
      except
        result:=ErrorGenerico (KKrename);
      end;
end;



(* Copy (URL: fileManagerConfig.copyUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "copy",
    "path": "/public_html/index.php",
    "newPath": "/public_html/index-copy.php"
}}
JSON Response
{ "result": { "success": true, "error": null } }
*)
function copyF (param:Variant): SString;
var path,newPath:SString;
  a:Variant;
begin
      path:=normalPath(param.params.path);
      newPath:=normalPath(param.params.newPath);
      try
       a:=OKoError(CopyFile(path,newpath,true),KKcopy);
       (*
      if CopyFile(path,newpath,true) then
      begin
        a:=_Obj(['sucess',true,'error','null']);
      end else
      begin
        a:=_Obj(['sucess',false,'error',KKERRORcopy]);
      end;
      *)
       result:=responseVariant(a);
      except
           result:=ErrorGenerico (KKcopy);
      end;
end;



(* Remove (URL: fileManagerConfig.removeUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "delete",
    "path": "/public_html/index.php",
}}
JSON Response
{ "result": { "success": true, "error": null } }
*)
function deleteF (param:Variant): SString;
var path:SString;
    a,
    response:Variant;
begin
      path:=normalPath(param.params.path);
      try
       a:=OKoError(DeleteFile (path),KKdelete);
       (*
      if DeleteFile (path) then
      begin
        a:=_Obj(['sucess',true,'error','null']);
      end else
      begin
        a:=_Obj(['sucess',false,'error',KKERRORdelete_]);
      end;*)
       result:=responseVariant(a);
      except
          result:=ErrorGenerico (KKdelete);
      end;
end;


(*
Create folder (URL: fileManagerConfig.createFolderUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "addfolder",
    "name": "new-folder",
    "path": "/public_html"
}}
JSON Response
{ "result": { "success": true, "error": null } }
*)
function addforder (param:Variant): SString;
var path:SString;
    a:Variant;
begin
      path:=normalPath(param.params.path);
      try
       a:=OKoError( MakeDir (path)<>0,KKaddforder);

       result:=responseVariant(a);// Sustituir( response,'"null"','null');;
      except
           result:=ErrorGenerico (KKaddforder);
      end;
end;



(*

JSON Request content
{ "params": {
    "mode": "list",
    "onlyFolders": false,
    "path": "/public_html"
}}

JSON Response
{ "result": [
    {
        "name": "joomla",
        "rights": "drwxr-xr-x",
        "size": "4096",
        "date": "2015-04-29 09:04:24",
        "type": "dir"
    }, {
        "name": "magento",
        "rights": "drwxr-xr-x",
        "size": "4096",
        "date": "17:42",
        "type": "dir"
    }
]}
*)
function GetAllFile
         (const mask:SString):Variant;
var search: TSearchrec;
    verz  : SString;
    lista:Variant;
    cuenta:Integer;

    procedure Add_
              (const filename_,filesimple:SString; si:Integer;
               tob:TTipoObjeto);
    var a: Variant;
      dia,mes,ano:word;
      tipo:SString;
       hora,minuto,seg,mile:Word;
    begin
      DecodeDate(now,ano,mes,dia);
      DecodeTime(now,hora,minuto,seg,mile);
       if tob in [Todir,Todisk] then
       begin
         tipo:='dir';
       end else

        begin
         tipo:='file';
        end;
      a:=_Obj(['id',cuenta,
               'time',hora
              ,'day',dia
              ,'month',mes
              ,'zize',0
              ,'group','984'
              ,'user','toni@miteruel.com'
              ,'number',0
              ,'rights','drwxrwxrwx'
              ,'type',tipo
              ,'name',PathNomExt (filename_)
//              ,'fullname',filename_
              ,'date',DateTimeToStr(now)
               ]);


(*
       a:=col.Add;
       a.Name:=filename;
       a.NameSimpl:=filesimple;
       a.Fecha:=FileDateToDateTime(search.Time);
       //fe;
       a.TipoObjeto:=tob;*)
//       a.director:=esdir;
//       end;
       lista.add(a);
//       a.Size:=si;
    end;

    var mascara:String;

begin
  cuenta:=0;
  result:=TDocVariant.New;
  lista:=_Arr([]);
  verz := ConBarra(Xextractpath(mask));
  mascara:=verz+'*.*';
  if FindFirst( mascara, faAnyFile, search)= 0 then
  repeat
    If ((search.Attr and fadirectory)=fadirectory) and (search.Name[1]<>'.') then
     Begin
       Add_(verz+search.Name,search.Name,0,Todir);
     end
     else If search.Name[1]<>'.' then
     Begin
       Add_ (verz+search.Name,search.Name,search.Size,ToFile);
     end;
     inc(cuenta)
  until FindNext(search)<>0;
  sysutils.FindClose (search);
  result.result:=lista;
end;



(*
Extract file (URL: fileManagerConfig.extractUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "extract",
    "destination": "/public_html/extracted-files",
    "path": "/public_html/compressed.zip",
    "sourceFile": "/public_html/compressed.zip"
}}
JSON Response
{ "result": { "success": true, "error": null } }
*)
function ExtractZip (const zip,toPath:SString):Boolean;
begin
   result:=False;
   with ZipInjection(zip) do
   begin
     result:=ExtractFilesTo(toPath)
   end;
end;


function ExtractFile (param:Variant): SString;
var path:SString;
begin
   path:=normalPath(param.params.path);
   try
     result:=responseVariant(
               OKoError( ExtractZip (path,param.destination),KKextract)
             );
   except
     result:=ErrorGenerico (KKextract);
   end;
end;


(*
Edit file (URL: fileManagerConfig.editUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "savefile",
    "content": "<?php echo random(); ?>",
    "path": "/public_html/index.php",
}}
JSON Response
{ "result": { "success": true, "error": null } }
*)
function saveFile (param:Variant): SString;  ///todo
var contenido,
    path:SString;
    a:Variant;
begin
   path:=normalPath(param.params.path);
   try
        contenido:=param.params.content;
//     contenido:=param['content'];
     a:= OKoError(SaveStringData(path,contenido), KKsavefile);
     result:=responseVariant(a);
   except
     result:=ErrorGenerico (KKsavefile);
   end;
end;



(*
Get content of a file (URL: fileManagerConfig.getContentUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "editfile",
    "path": "/public_html/index.php"
}}
JSON Response
{ "result": "<?php echo random(); ?>" }
*)
function EditFile (param:Variant): SString;  ///todo
var path:SString;
begin
      path:=normalPath(param.params.path);
      try
       result:=_Obj(['result',ToDos.GetFile(path)]);
      except
           result:=ErrorGenerico (KKeditfile);
      end;
end;



(*
Set permissions (URL: fileManagerConfig.permissionsUrl, Method: POST)

JSON Request content
{ "params": {
    "mode": "changepermissions",
    "path": "/public_html/index.php",
    "perms": "653",
    "permsCode": "rw-r-x-wx",
    "recursive": false
}}

JSON Response
{ "result": { "success": true, "error": null } }
*)
function SetPremision(param:Variant): SString;  ///todo: Not Implemented
var path:SString;
    a:Variant;
begin
      path:=normalPath(param.params.path);
      try
       a:=null;//OKoError( MakeDir (path)<>0,KKaddforder);
       result:=responseVariant(a);// Sustituir( response,'"null"','null');;
      except
           result:=ErrorGenerico (KKaddforder);
      end;
end;



(*
Compress file (URL: fileManagerConfig.compressUrl, Method: POST)

JSON Request content

{ "params": {
    "mode": "compress",
    "path": "/public_html/compressed.zip",
    "destination": "/public_html/backups"
}}
JSON Response

{ "result": { "success": true, "error": null } }
*)
function CompressFile(param:Variant): SString;  ///todo: Not implmented
var path:SString;
    a:Variant;
begin
      path:=normalPath(param.params.path);
      try
       a:=null;//OKoError( MakeDir (path)<>0,KKaddforder);

       result:=responseVariant(a);// Sustituir( response,'"null"','null');;
      except
           result:=ErrorGenerico (KKaddforder);
      end;
end;


(*
  main program
*)
constructor TAngularFileManager.Create(sy: TComponent);
begin
  inherited;
  fPath:=ExePath;
  fProgUrl:='/bridges/php/handler.php';
end;

destructor TAngularFileManager.Destroy;
begin
  fPath:='';
  inherited;
end;

function TAngularFileManager.doProgram(const nom,post: SString): TResulTodo;
var   mode :SString;
      param: Variant;
begin
    param:=_JSon(post);//String2Json(post);
    mode:=param.params.mode;
    if (mode=KKaddforder) then
    begin
     result:=addforder(param)
    end else
    if (mode=KKdelete) then
    begin
     result:=deleteF(param)
    end else
    if (mode=KKcopy) then
    begin
     result:=copyF(param)
    end else
    if (mode=KKrename) then
    begin
     result:=rename(param)
    end else
    if (mode=KKextract) then
    begin
     result:=ExtractFile(param)
    end else
    if (mode=KKsavefile) then
    begin
     result:=saveFile(param)
    end else
    if (mode=KKeditfile) then
    begin
     result:=EditFile(param)
    end else




    if (mode=KKlist ) then
    begin
      result.Fichero :=GetAllFile(fPath)// ejemplo        (const mask:SString):Variant;
    end else
    begin
      result.Fichero:=GetAllFile( fPath)// ejemplo        (const mask:SString):Variant;
    end;
end;






(*
const
responsejemplo1=
'{"result":[{"time":"11:13","day":"9","month":"Sep","size":"0","group":"984",'+
'"user":"demofilemanager@zendelsolutions.com","number":"3","rights":"drwxrwxrwx",'+
'"type":"dir","name":"Please create","date":"2015-09-10 19:53:32"},'+
'{"time":"20:09","day":"10","month":"Sep","size":"0","group":"984","user":"demofilemanager@zendelsolutions.com","number":"12","rights":"drwxrwxrwx","type":"dir","name":"assetGallery","date":"2015-09-10 19:53:32"},'+
'{"time":"16:43","day":"7","month":"Sep","size":"0","group":"984","user":"demofilemanager@zendelsolutions.com","number":"6","rights":"drwxrwxrwx","type":"dir","name":"phpClassic","date":"2015-09-10 19:53:32"},'+
'{"time":"08:15","day":"8","month":"Sep","size":"0","group":"984","user":"demofilemanager@zendelsolutions.com","number":"2","rights":"drwxrwxrwx","type":"dir","name":"\u5abd\u6211\u5728\u9019","date":"2015-09-10 19:53:32"},'+
'{"time":"13:15","day":"18","month":"Aug","size":"0","group":"984","user":"demofilemanager@zendelsolutions.com","number":"13","rights":"drwxrwxrwx","type":"dir","name":"\ud55c\uae00","date":"2015-09-10 19:53:32"},'+
'{"time":"11:20","day":"22","month":"May","size":"517","group":"984","user":"demofilemanager@zendelsolutions.com","number":"1","rights":"-rw-r--r--","type":"file","name":"db-schema.sql","date":"2015-09-10 19:53:32"}]}';




//Create folder (URL: fileManagerConfig.createFolderUrl, Method: POST)
function addforder (param:Variant): SString;
//Remove (URL: fileManagerConfig.removeUrl, Method: POST)
function deleteF (param:Variant): SString;
//Copy (URL: fileManagerConfig.copyUrl, Method: POST)
function copyF (param:Variant): SString;

//Rename / Move (URL: fileManagerConfig.renameUrl, Method: POST)
function rename(param:Variant): SString;

function GetAllFile         (const mask:SString):Variant;
*)




(*
Upload file (URL: fileManagerConfig.uploadUrl, Method: POST, Content-Type: multipart/form-data)

Http post request payload

------WebKitFormBoundaryqBnbHc6RKfXVAf9j
Content-Disposition: form-data; name="destination"
/

------WebKitFormBoundaryqBnbHc6RKfXVAf9j
Content-Disposition: form-data; name="file-0"; filename="github.txt"
Content-Type: text/plain
JSON Response

{ "result": { "success": true, "error": null } }
Unlimited file items to upload, each item will be enumerated as file-0, file-1, etc.

For example, you may retrieve the file in PHP using:

$destination = $_POST['destination'];
$_FILES['file-0'] or foreach($_FILES)

Download / Preview file (URL: fileManagerConfig.downloadFileUrl, Method: GET)

Http query params

[fileManagerConfig.downloadFileUrl]?mode=download&preview=true&path=/public_html/image.jpg
Response

-File content
Errors / Exceptions

Any backend error should be with an error 500 HTTP code.

Btw, you can also report errors with a 200 response both using this json structure

{ "result": {
    "success": false,
    "error": "Access denied to remove file"
}}
*)


function UpLoad (param:Variant): SString;  ///todo
var path:SString;
    a:Variant;
begin
      path:=normalPath(param.params.path);
      try
       a:=null;//OKoError( MakeDir (path)<>0,KKaddforder);

       result:=responseVariant(a);// Sustituir( response,'"null"','null');;
      except
           result:=ErrorGenerico (KKaddforder);
      end;
end;


end.

