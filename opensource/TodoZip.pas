unit TodoZip;

(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  TodoZip
  ========================
   Zip abstraction

  version 0.1 )  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)

interface

uses
  Classes,
  ToDoAbstract;

type

  TZipInfo = (ziItemName, ziSize);

  IZip = Interface(IMix)
    ['{60577BA3-F413-49B9-8D8E-CE4DD03800DB}']
    function CountFiles: INTEGER;
    function ExistFile(const na: SString): Boolean;
    function ExtractFilesTo(const paths: SString): Boolean ;
    function ExtractS(const na: SString; otherPath: Boolean = False): TStream;
    function Extract (const na: SString; otherPath: Boolean = False;
      const log: ILog = nil): SString;
    function Info (id: INTEGER; zi: TZipInfo = ziItemName): SString;

    function Open(const ZipFileName: SString): Boolean;
    function LastZiped: SString;
  end;

  TZipAbstract = Class(TMix, IZip)
    constructor CreateInfo(aowner: TComponent; p: pointer);

    function CountFiles: INTEGER; virtual; abstract;
    function Info(id: INTEGER; zi: TZipInfo = ziItemName): SString;
      virtual; abstract;

    function ExistFile(const na: SString): Boolean; virtual;
    function ExtractFilesTo(const paths: SString): Boolean ; virtual;

    function ExtractS(const na: SString; otherPath: Boolean = False): TStream; virtual;
    function Extract (const na: SString; otherPath: Boolean = False;
      const log: ILog = nil): SString; virtual;

    function Open(const zipName: SString): Boolean; virtual; // abstract;
    function SaveZipFile(const dato, na, nazip: SString): Boolean;
    function LastZiped: SString;

  protected
    LastName: SString;
  public

    zipName: SString;

  end;

var
  BYTESLEIDOSZIX_: INTEGER = 0;

var
  ClassZipInyect: TClass = Nil;

function ZipInjection(const zname: SString): IZip;

implementation

uses ToDoS;

function TZipAbstract.Open(const zipName: SString): Boolean;
begin
  Result := False; // ExistFile(ZipFileName)
end;

function TZipAbstract.SaveZipFile(const dato, na, nazip: SString): Boolean;
begin

end;

function TZipAbstract.Extract (const na: SString; otherPath: Boolean = False;
  const log: ILog = nil): SString;
var
  ToStream: TStream;

begin
  Result := '';

  try
    ToStream := ExtractS(na, otherPath);
    if ToStream <> nil then
    begin
      try
        Result := ReadStreamMax(ToStream);
        INC(BYTESLEIDOSZIX_, ToStream.Size);

      finally
        ToStream.Free;
      end;

    end;
  except
    Result := '';
  end;
end;

function TZipAbstract.ExtractFilesTo(const paths: SString): Boolean;
begin
  result:=False;
end;

function TZipAbstract.ExtractS(const na: SString; otherPath: Boolean = False): TStream;
begin
  Result := nil;
end;

function TZipAbstract.LastZiped: SString;
begin
  Result := LastName
end;

constructor TZipAbstract.CreateInfo(aowner: TComponent; p: pointer);
begin
  TZipAbstract.Create(aowner);
  Open(SPChar(p))
end;

function TZipAbstract.ExistFile(const na: SString): Boolean;
var
  i: INTEGER;
  item, mina: SString;

begin
  Result := False;
  mina := UpSt(na);
  ReplaceChars(mina, '\', '/');
  try
    for i := 0 to CountFiles - 1 do
    begin
      item := Info(i);
      if UpSt(item) = mina then
      begin
        Result := true;
        break;
      end;
    end;
  except
    Result := False;
  end;
end;

function ZipInjection(const zname: SString): IZip;
var
  z: TZipAbstract;
begin
  try
    if ClassZipInyect = nil then
    begin
      Result := nil;
      exit;
    end;
    z := TZipAbstract(TComponentClass(ClassZipInyect).Create(nil));
    z.Open(zname);
    z.DoReferentCount;
    Result := z;
  except
    Result := nil;
  end;
  // DestroyInterface
end;

end.
