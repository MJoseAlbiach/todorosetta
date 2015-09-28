unit Todo_Mormot_Zip;

interface

(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  Todo_Mormot_Zip
  ========================
  Using SynZip units as zip engine in ToDoRosetta

  version 0.1 )

  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)


uses  Classes,
      ToDoAbstract,
      TodoZip,
      SynZip;

type
  TZipSynZip = Class(TZipAbstract)
    function zip: TZipRead;

    constructor Create(aowner: TComponent); override;
    destructor Destroy; override;
   // zip name
    function  Open(const na: SString):Boolean; override;
   // number of files in zip
    function CountFiles: INTEGER; override;
   // exist the file in zip
    function ExistFile(const na: SString): Boolean; override;
    function Extract (const na: SString; otherPath:Boolean=False;const log:ILog=nil): SString; override;
    function ExtractS (const na: SString; otherPath:Boolean=False): TStream; override;
    function Info (id: INTEGER; zi: TZipInfo=ziItemName): SString; override;

    function CreateInyection: TObject; override;
    function ExtractFilesTo(const paths: SString): Boolean; override;
  end;

implementation

uses ToDos;



function TZipSynZip.CountFiles: INTEGER;
var
  z: TZipRead;
begin
  z := zip;
  if z = nil then
  begin
    result := 0;
  end
  else
  begin
    result := z.Count;
  end
end;

constructor TZipSynZip.Create(aowner: TComponent);
begin
  inherited;
  FClassInject:=TZipRead;

end;


function TZipSynZip.CreateInyection: TObject;
begin
    result:=TZipRead.Create (ZipName);
end;



destructor TZipSynZip.Destroy;
begin
  inherited Destroy;
end;


function TZipSynZip.Extract (const na: SString; otherPath:Boolean=False;const log:ILog=nil): SString;
var

  i: INTEGER;
  misola,
  fname,
  mina: SString;
  ok:boolean;
var
  ab: TZipRead;
begin
  ab := Zip;
  LastName:='';

  result := '';
  if ab=nil then
  begin
    exit
  end;
  mina :=Upst(na);// UpSt(FindReplacechar(na, '\', '/'));
  misola:=NombreSinPath(mina);
  try
    for i := 0 to ab.Count - 1 do
    begin
      fname:=Info(i);
//      Item := ab.Items[i];
      ok:=UpSt(fname) = mina;
      if (not ok) and otherpath then
      begin
        ok:= NombreSinPath(fname) = misola;

      end;
      if Ok then
      begin
//        result :=ab.UnZip(i);// TMemoryStream.Create;
        result :=ab.UnZip(fname);// TMemoryStream.Create;
        LastName:=fname;
        if  log<>nil then
        begin
//          log.Log();
        end;
//        ab.ExtractToStream(Item.FileName, result);


        break;
      end;

    end;
  except
    FreeNil(result);
  end;
end;

function TZipSynZip.ExistFile(const na: SString): Boolean;
var
  mina: SString;
var
  z: TZipRead;
begin
  result:=False;
  z := zip;
  if z = nil then
  begin
    result := false;
  end
  else
  begin
    try
    mina := UpSt(FindReplacechar(na, '\', '/'));

    result := z.NameToIndex(mina)>=0;
    except
      result := false;
    end;
  end;
end;


function TZipSynZip.ExtractS(const na: SString; otherPath:Boolean=False): TStream;
begin
  result:=nil;
end;




function TZipSynZip.Info(id: INTEGER; zi: TZipInfo): SString;
var
  z: TZipRead;
  Item:TZipEntry;
begin
  result := '';
  z:=zip;
  try
  if z<>nil then
  begin
    item:=z.Entry[id];

    if item.infoDirectory<>nil then
   begin

     case zi of
       ziSize:      if item.infoLocal<>nil then
                    begin
                      result := StInts(item.infoLocal^.zfullSize)
                       //?result := StInts(item.infoLocal.zfullSize)
                    end;
//      ziItemName
      else
      result := Item.zipName
     end;


   end;
  end;
  except
    result := '';
  end;
end;



function  TZipSynZip.Open(const na: SString):Boolean;
var  z: TZipRead;
begin
  result := False;
  ZipName:=na;
  z:=zip;

  if z<>nil then
  begin
     result:=True                              
  end;


end;


function TZipSynZip.zip: TZipRead;
begin
  result := TZipRead(Obj);
end;


function TZipSynZip.ExtractFilesTo(const paths: SString): Boolean;
var  z: TZipRead;
begin
  z:=zip;
  if z<>nil then
  begin
     result:=z.UnZipAll(paths)>0
  end;
end;


begin
  classZipInyect:=TZipSynZip  // auto injection
end.


