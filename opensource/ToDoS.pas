unit ToDoS;

interface

(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ToDoS
  ========================
   Very used functions in ToDoRosetta framework

  version 0.1 )

  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)


uses ToDoAbstract, Classes;

const
  EOL = #13#10;
  KSIGUAL = '=';
  StrHTML_ = 'HTML';


//*** usefull string & integer functions ***
  //upper case
  Function Upst(const s: Sstring): Sstring;
  // Integer to string
  function StIntS(value: Integer): Sstring;
  // min integer
  function Min(a, b: LongInt): LongInt; inline;
  // char position
  function CharPos_(ch: SChar; const str: Sstring): Integer;
  //
  Function  FirstString(const s: Sstring; const chIs: Sstring;
    Var resulta: Sstring): Boolean;
//


// **** replace, del string chars ****
  Function Sustituir_(const cad, sts, por: Sstring): Sstring;
  procedure ReplaceChars(var st: Sstring; ch1, ch2: SChar);
  function FindReplacechar(const ss: Sstring; const find, replace: SChar): Sstring;
  Procedure DelFirstChar(var s: Sstring; chIs: SChar);
  function  DelFirstString(var s: Sstring; const chIs: Sstring): Boolean;
  // fetch
  function FetchVal(var s1: Sstring): Sstring;
  function Fetchar(sDelim: SChar; var s1: Sstring): Sstring;
//


// file , stream
  function ReadStreamMax(ss: Tstream; maxLen: Integer = 0): Sstring;
  function GetStreamFile(const pathName: Sstring): TFileStream;
  function GetFile(const pathName: Sstring; maxi: Integer = 0): Sstring;
//


// paths funcions
  function NombreSinPath(const na: Sstring): Sstring;
  Function sinPunto(const n: Sstring): Sstring;
  Function DirecNombre(const d: Sstring; const nn: Sstring): Sstring;
  Function SinBarra(const s: Sstring): Sstring;
  Function ConBarra(const name: Sstring): Sstring;
  Function PathNombre(const d: Sstring): Sstring;
  Function PathExt(const d: Sstring): Sstring;
  Function PathAs(const d: Sstring): Sstring;
  Function PathNomExt(const d: Sstring): Sstring;
  function ExePath : Sstring;
  function ExeFile_: Sstring;
  Function DirApp(const na: Sstring): Sstring;
  Function DirecNombres(const d: Sstring; const nn: Sstring): Sstring;
  function Unix2Dos(const path: Sstring): Sstring;
  Function Ospath(const pa, name: Sstring): Sstring;
  function ExtensionName(const nom: Sstring): Sstring;
//


// exist file, dir, make
  Function Exists(const name: SString): Boolean;
  Function ExistFile(const nam: Sstring): Boolean;
  Function ExisteDir(const d: Sstring): Boolean;
  FUnction MakeDir(const nombre: Sstring): Integer;
//

// injection
  function InjectionLog(ClassInyected: TMiInterfaceClass): ILog;
//


procedure WarningTodo(const valores: array of const);
Procedure Freenil(var oo);
Function ActualDos: SString;
function SaveStringData(const name, data: SString):Boolean;

Function Sospath(const na: SString): SString;
function DostoUnix(const path: SString): SString;

implementation

uses SysUtils;

const
  Barrax = '\';

function StIntS(value: Integer): Sstring;
begin
  result := IntToStr(value);
end;

function CharPos_(ch: SChar; const str: Sstring): Integer;
begin
  result := Pos(ch, str)
end;

Procedure DelFirstChar(var s: Sstring; chIs: SChar);
begin
  if (s <> '') and (s[1] = chIs) then
  begin
    Delete(s, 1, 1);
  end;
end;

function Fetchar(sDelim: SChar; var s1: Sstring): Sstring;
var
  iPos: Integer;
begin
  iPos := CharPos_(sDelim, s1);
  If iPos = 0 then
  begin
    result := s1;
    s1 := '';
  end
  else
  begin
    result := Copy(s1, 1, iPos - 1);
    Delete(s1, 1, iPos);
  end;
end;

procedure ReplaceChars(var st: Sstring; ch1, ch2: SChar);
var
  i: word;
Begin
  UniqueString(st);
  for i := 1 to Length(st) do
  Begin
    if st[i] = ch1 then
    begin
      st[i] := ch2;
    end;
  end;
end;

Function PathNomExt(const d: Sstring): Sstring;
begin
  result := ExtractFileName(d);
end;

function NombreSinPath(const na: Sstring): Sstring;
var
  ona: Sstring;
begin
  ona := na;
  ReplaceChars(ona, '/', '\');
  result := PathNomExt(Upst(ona));
end;

function FetchVal(var s1: Sstring): Sstring;
var
  iPos: Integer;
begin
  iPos := CharPos_(KSIGUAL, s1);
  If iPos = 0 then
  begin
    result := s1;
    s1 := '';
  end
  else
  begin
    result := Copy(s1, 1, iPos - 1);
    Delete(s1, 1, iPos);
  end;
end;

function GetStreamFile(const pathName: Sstring): TFileStream;
begin
  result := TFileStream.Create(pathName, fmOpenRead or fmShareDenyNone);
end;

function GetFile(const pathName: Sstring; maxi: Integer): Sstring;
var
  fs: TFileStream;
  sn: Sstring;
  lon: Integer;
begin
  result := '';
  sn := pathName;
  ReplaceChars(sn, '/', '\');

  if not FileExists(sn) then
  begin
    Exit;
  end;
  try
    fs := GetStreamFile(sn);
    try

      // ?   if fs <> Nil then
      begin
        lon := fs.Size;
        if (maxi > 0) and (lon > maxi) then
        begin
          lon := maxi;
        end;
        SetLength(result, lon);
        fs.Position := 0;
        if lon > 0 then
        begin
          fs.Read(result[1], lon);
        end;
      end;

    finally
      Freenil(fs);
    end;
  except

  end;

end;

procedure WarningTodo(const valores: array of const);
begin
  // WarningX(valores);
END;

Procedure Freenil(var oo);
begin
  try
    // FreeOb(TObject(oo));
    if tObject(oo) <> Nil then
    begin
      tObject(oo).free;
{$IFNDEF netnet}
      tObject(oo) := Nil;
{$ELSE netnet}
      oo := Nil;
{$ENDIF netnet}
    end;
  except
    WarningTodo(['freerror']);
  end;
end;

{$IFNDEF netnet}

function ReadStreamMax(ss: Tstream; maxLen: Integer = 0): Sstring;
var
  lon: Integer;
  s: Sstring;
begin
  s := '';
  if ss <> Nil then
  begin
    lon := ss.Size;
    if (MaxLen > 0) and (lon > MaxLen) then
    begin
      lon := MaxLen;
    end;
    SetLength(s, lon);
    ss.Position := 0;
    if lon > 0 then
    begin
      ss.Read(s[1], lon);
    end;
  end;
  result := s;
end;

{$ELSE netnet}

function ReadStreamMax(ss: Tstream; MaxLen: Integer = 0): Sstring;

  function ContainsPreamble(const Buffer, Signature: array of byte): Boolean;
  var
    i: Integer;
  begin
    result := true;
    if Length(Buffer) >= Length(Signature) then
    begin
      for i := 1 to Length(Signature) do
        if Buffer[i - 1] <> Signature[i - 1] then
        begin
          result := False;
          Break;
        end;
    end
    else
      result := False;
  end;

var
  Encoding: System.text.Encoding;
  Size: Integer;
  Buffer, Preamble: array of byte;
begin
  // BeginUpdate;
  Encoding := Nil;
  try
    // Read bytes from stream
    ss.Position := 0;
    Size := ss.Size - ss.Position;
    SetLength(Buffer, Size);
    ss.Read(Buffer, Size);

    Size := 0;
    if Encoding = nil then
    begin
      // Find the appropraite encoding
      if ContainsPreamble(Buffer, System.text.Encoding.Unicode.GetPreamble) then
        Encoding := System.text.Encoding.Unicode
      else if ContainsPreamble(Buffer,
        System.text.Encoding.BigEndianUnicode.GetPreamble) then
        Encoding := System.text.Encoding.BigEndianUnicode
      else if ContainsPreamble(Buffer, System.text.Encoding.UTF8.GetPreamble)
      then
        Encoding := System.text.Encoding.UTF8
      else
        Encoding := System.text.Encoding.Default;
      Size := Length(Encoding.GetPreamble);
    end
    else
    begin
      // Use specified encoding, ignore preamble bytes if present
      Preamble := Encoding.GetPreamble;
      if ContainsPreamble(Buffer, Preamble) then
        Size := Length(Preamble);
    end;
    result := Encoding.GetString(Buffer, Size, Length(Buffer) - Size);
  finally
    // EndUpdate;
  end;
end;

{$ENDIF  netnet}

Function Upst(const s: Sstring): Sstring;
Begin
  result := UpperCase(s);
end;

function FindReplacechar(const ss: Sstring; const find, replace: SChar)
  : Sstring;
var
  i: Integer;
  uni: Boolean;
begin
  result := ss;
  uni := true;

  for i := 1 to Length(result) do
  Begin
    if result[i] = find then
    begin
      if uni then
      begin
        UniqueString(result);
        uni := False;
      end;
      result[i] := replace;
    end;
  end;

end;


// paths

Function SinBarra(const s: Sstring): Sstring;
var
  l: Integer;
  co: Boolean;
begin
  l := Length(s);
  co := False;
  While (l > 0) and ((s[l] = '\') or (s[l] = '/')) do
  begin
    Dec(l);
    co := true;
  end;
  if co then
  begin
    result := Copy(s, 1, l);
  end
  else
  begin
    result := s
  end;
end;

Function ConBarra(const name: Sstring): Sstring;
Begin
  if name <> '' then
  begin
    if name[Length(name)] = Barrax then
    begin
      result := name
    end
    else
    begin
      result := SinBarra(name) + Barrax
    end;
  end
  else
  begin
    result := '';
  end;

end;

Function DirecNombre(const d: Sstring; const nn: Sstring): Sstring;
Begin
  result := ConBarra(d) + nn;
end;

Function PathNombre(const d: Sstring): Sstring;
var
  nom, ext: Sstring;
begin
  nom := ExtractFileName(d);
  ext := ExtractFileExt(d);
  if ext = '' then
  begin
    result := nom
  end
  else
  begin
    result := Copy(nom, 1, Length(nom) - Length(ext));
  end;
end;

Function sinPunto(const n: Sstring): Sstring;
Begin
  if (n <> '') and (n[1] = '.') then
  begin
    result := Copy(n, 2, Length(n) - 1)
  end
  else
  begin
    result := n;
  end;
end;

Function PathExt(const d: Sstring): Sstring;
begin
  result := sinPunto(ExtractFileExt(d));
end;

Function FirstString(const s: Sstring; const chIs: Sstring;
  Var resulta: Sstring): Boolean;
begin
  result := False;
  if (s <> '') and (Pos(chIs, s) = 1) then
  begin
    result := true;
    resulta := Copy(s, Length(chIs) + 1, Length(s));
    // resulta :=CopyFin(s, Length(chIs) + 1)
  end
  else
  begin
    resulta := s;
  end;
end;

function DelFirstString(var s: Sstring; const chIs: Sstring): Boolean;
var
  o: Sstring;
begin
  o := s;
  result := FirstString(o, chIs, s)
end;

Function Sustituir_(const cad, sts, por: Sstring): Sstring;
Var
  i: Integer;
  sc: Sstring;
BEgin
  sc := cad;
  i := Pos(sts, sc);
  if i > 0 then
  Begin
    Delete(sc, i, Length(sts));
    Insert(por, sc, i);
  end;
  result := sc;
end;

// dir

Function ExistFile(const nam: Sstring): Boolean;
var
  sr: tSearchRec;
begin
  result := FindFirst(nam, faanyfile, sr) = 0;
  FindClose(sr);
end;

Function PathAs(const d: Sstring): Sstring;
begin
  result := ConBarra(d) + '*.*';
end;

Function ExisteDir(const d: Sstring): Boolean;
begin
  result := ExistFile(PathAs(d));
end;

FUnction MakeDir(const nombre: Sstring): Integer;
var
  su,
  d: Sstring;
  ok: Integer;
begin
  result := 0;
  If not ExisteDir(nombre) then
  begin
    d := SinBarra(nombre);
    su := ExtractFilePath(d);
    ok := 0;
    if Length(su) < Length(d) then
    begin
      ok := MakeDir(su);
    end;
    if ok = 0 then
    begin
      Mkdir(d);
      result := Ioresult;
    end
    else
    begin
      result := ok;
    end;
  end;
end;

function ExeFile_: Sstring;
begin
  result := ParamStr(0);
end;

function ExePath: Sstring;
begin
  result := ExtractFilePath(ExeFile_);
end;

Function DirecNombres(const d: Sstring; const nn: Sstring): Sstring;
var
  n // ,da
    : Sstring;
Begin
  n := nn;
  if Pos(d, n) = 1 then
  begin
    Delete(n, 1, Length(d));
  end;
  if Length(n) > 0 then
  begin
    if n[1] = '\' then
    begin
      result := SinBarra(d) + n;
      Exit;
      // Delete(n, 1, 1);
    end;
  end;
  result := ConBarra(d) + n;
end;

Function DirApp(const na: Sstring): Sstring;
Begin
  result := DirecNombres(ExePath, na);
end;

function Unix2Dos(const path: Sstring): Sstring;
begin
  result := FindReplacechar(path, '/', '\');
end;

Function Ospath(const pa, name: Sstring): Sstring;
begin
  result := DirecNombres(pa, name);
end;

function ExtensionName(const nom: Sstring): Sstring;
var
  na: Sstring;
begin
  na := ExtractFileExt(nom);
  DelFirstChar(na, '.');
  result := Upst(na);
  // result := UpSt(DeleteFirst(na, '.'));
end;

Function Exists(const name: SString): Boolean;
begin
  result := FileExists(name); // SYsUtils.exi
end;


// injection
function InjectionLog(ClassInyected: TMiInterfaceClass): ILog;
var
  z: TInterfacedComponent;
begin
  try
    if ClassInyected = nil then
    begin
      result := nil;
      Exit;
    end;
    z := TInterfacedComponent(ClassInyected.Create(nil));

    result := TLogAbstract(z)
  except
    result := nil;
  end;
  // DestroyInterface
end;

function Min(a, b: LongInt): LongInt; inline;
Begin
  if a < b then
  begin
    result := a
  end
  else
  begin
    result := b;
  end;
end;


Function ActualDos: SString;
Begin
  GetDir(0, result);
end;




function SaveStringData(const name, data: SString):Boolean;
var
  fs: TFileStream;
Begin
  result:=False;
  fs := TFileStream.Create(Sospath(name), fmCreate);
  try
    fs.Write(data[1], Length(data));
    result:=True;
//    WriteStStream(fs, data);
  finally
    Freenil(fs);
  end;
end;


function DostoUnix(const path: SString): SString;
begin
  result := FindReplacechar(path, '\', '/');
end;


Function Sospath(const na: SString): SString;
begin
  case Osver of
    Toswin:
      result := FindReplacechar(na, '/', '\');
  else
    result := DostoUnix(na);
  end;
end;


end.
