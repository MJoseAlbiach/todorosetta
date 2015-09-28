unit TodoString;
{$i incToDo.pas}


(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  TodoString
  ========================
   Ansi TStringList commons for diferent delphi versions

  version 0.1 )  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)


interface

uses
Classes,
ToDoAbstract;

type
{$IFDEF DelphiDx}
  TxStringList = class(TStringList)
{$ELSE DelphiDx}
{$IFDEF mistring}
  TxStringList = class(MiStringList.TMiStringList)
{$ELSE mistring}
  TxStringList = class(TStringList)
{$ENDIF mistring}
{$ENDIF DelphiDx}
    procedure SetAttribute(const attrName: SString; const value: SString);
    function IndexObject(const s: SString): TObject;
    procedure FastIndexOrInclude_(const s: SString);
    procedure AddObjects(aObject: TObject);
    function MatchValue(const nam: SString; const tomatch: SString;
      modof: TModeFindXml): Boolean;

  end;

{$IFDEF veryfast}

type

  TFastMatchStringLis = class(TStrings)
  private
    FList: PStringItemList;
    FCount: integer;
    FCapacity: integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: Boolean;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
  public
    property List: PStringItemList read FList;
    property DCount: integer read FCount;

  end;
{$ENDIF veryfast}

  TStringsHelper = class helper for TStringList
  public
    function FastValue(const nam: SString; mas: Boolean = true): SString;
  end;

var
  KfastAtIndex_: Boolean = false;

procedure GetTitValues(const s: SString; var tit: SString; var valor: SString);

implementation

{$IFDEF minimal}
uses sysutils;
{$ELSE minimal}
 uses todoFaster;
{$ENDIF minimal}

procedure GetTitValues(const s: SString; var tit: SString; var valor: SString);
var
  po: integer;
begin
  po := Pos('=', s);
  if po > 0 then
  begin
    tit := copY(s, 1, po - 1);
    valor := copY(s, po + 1, length(s));
  end
  else
  begin
    tit := s;
    valor := '';
  end;

end;

procedure TxStringList.SetAttribute(const attrName: SString;
  const value: SString);
var
  i: integer;

begin
  i := IndexOfName(attrName);
  if (value <> '') then
  begin
    if i < 0 then
    begin
      InsertItem(Count, attrName + '=' + value, nil)
    end
    // AddSt(attrName + NameValueSeparator + value)
    else
    begin
      Put(i, attrName + '=' + value);
    end;
    (* if i < 0 then
      i := Add('');
      Put(i, AttrName + NameValueSeparator + Value); *)
  end
  else
  begin
    if i >= 0 then
    begin
      Delete(i);
    end;
  end;
end;

function TxStringList.IndexObject(const s: SString): TObject;
var
  os: SString;
  i, le: integer;

begin
  le := length(s);
  result := Nil;
  for i := 0 to GetCount - 1 do
  begin

{$IFDEF veryfast}
    os := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    os := Get(i);
{$ENDIF veryfast}
    if StrLComp(SPChar(s), SPChar(os), le) = 0 then
      if length(os) = le then
      begin
        result := Objects[i];
        Exit;
      end;
  end;

end;


procedure TxStringList.FastIndexOrInclude_(const s: SString);
var
  cu, i: integer;

begin
  cu := GetCount;
  for i := 0 to cu - 1 do
  begin
{$IFDEF veryfast}
    if TFastMatchStringLis(self).List^[i].FString = s then
{$ELSE veryfast}
    if Strings[i] = s then
{$ENDIF veryfast}
    begin
      Exit;

    end;
  end;
  InsertItem(cu, s, nil);
end;

procedure TxStringList.AddObjects(aObject: TObject);
begin
  InsertItem(Count, '', aObject);
end;

function TxStringList.MatchValue(const nam: SString; const tomatch: SString;
  modof: TModeFindXml): Boolean;
var
  i: integer;
  s: SString;
  lem, le: integer;
  atp, pena: SPChar;
begin
  result := false;
  le := length(nam);
  pena := SPChar(nam);
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    s := Get(i);
{$ENDIF veryfast}
    if StrLComp(SPChar(s), pena, le) = 0 then
    begin
      if s[le + 1] = '=' then
      begin
        lem := length(s) - le - 1;
        if lem = length(tomatch) then
        begin
          atp := SPChar(s);
          inc(atp, le + 1);
          result := StrLComp(SPChar(tomatch), atp, lem) = 0
        end
        else
        begin
          result := false;
        end;
        Exit;
      end;
    end;
  end;
  if MxoBlanco in modof then
  begin
    result := true;
  end;

  // if mas then
  if MxoNoCS in modof then

    if not KfastAtIndex_ then
    begin
      i := inherited IndexOfName(nam);
      if i >= 0 then
      begin
        result := copY(Get(i), le + 2, MaxInt) = tomatch;
      end;

    end;
end;

function TStringsHelper.FastValue(const nam: SString;
  mas: Boolean = true): SString;
var
  i: integer;
  s: SString;
  le: integer;
  pena: SPChar;
begin
  le := length(nam);
  pena := SPChar(nam);
  for i := 0 to GetCount - 1 do
  begin
{$IFDEF veryfast}
    s := TFastMatchStringLis(self).List^[i].FString;
{$ELSE veryfast}
    s := Get(i);
{$ENDIF veryfast}
    if StrLComp(SPChar(s), pena, le) = 0 then
    // if length(s)>le then como minimo debe ser #0
    begin

      if s[le + 1] = '=' then

      begin
        result := copY(s, le + 2, MaxInt);
        Exit;
      end;
    end;

  end;

  result := '';
{$IFDEF DelphiDx}
  if mas then

  // if not KfastAtIndex_ then
  begin
    i := inherited IndexOfName(nam);
    if i >= 0 then
      result := copY(Get(i), le + 2, MaxInt);
  end;
{$ENDIF DelphiDx}
end;

end.
