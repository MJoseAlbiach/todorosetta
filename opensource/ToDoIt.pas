unit ToDoIt;

(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ToDoIt
  ========================
   xml abstraction

  version 0.1 )  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)

interface

uses
    Classes,
    TodoString,
    ToDoAbstract;


type

  Tit = class;

  TItEnumerator = class
  private
    FIndex,FLast: Integer;
    FXml: Tit;
  public
    constructor Create(Ax_: Tit);
    function GetCurrent: Tit;
    function MoveNext: Boolean;
    property Current: Tit read GetCurrent;
  end;


  Tit = class
  public
    function CountNodes: INTEGER; virtual;
    Function AtX(ii: INTEGER; const campo: SString; modof: TModeFindXml = [MxoNoCS]): SString; virtual;
    //campo='' --> stcustom
    function It (ii: INTEGER):Tit; virtual; //abstract;
    Function StCustom: SString; virtual;
    procedure SetCustom (const st:SString); virtual;

    Function  IsNode(const sis: SString; upcase: Boolean): Boolean;

    function Analiza (const no: SString; Cached_: Boolean = false;  maxi_: INTEGER = 0): TxStringList; virtual;
    function FindAt(const no, va: SString; indexa: Boolean = false) : Tit; virtual;
    function Find (const NodeName: SString; sub: Boolean = true): Tit; virtual;abstract;

    procedure RenderJson(sss: Tstream; renderTit: Boolean = true); virtual;
    Function  RendermeJson: SString; virtual;
    function GetEnumerator: TItEnumerator;
    function Attribute(const attrName: SString;
      modof: TModeFindXml = [ MxoNoCS]): SString; virtual;
    procedure SetAttribute(const attrName: SString; const value: SString); virtual;
    function Ti (const xmltit: SString): Tit; virtual;
  end;


  Function XCount(a: Tit): INTEGER;

  Function Last(a: Tit): INTEGER;

  Function At (a: Tit; const campo: SString;
  modof: TModeFindXml = [ MxoNoCS]): SString;

  function NodeIt (Xmain: Tit; nos: SString): SString;

implementation

uses  Todos;

{ Tit }

function Tit.FindAt(const no, va: SString; indexa: Boolean): Tit;
var i:integer;
begin
  result:=nil;
  for i := 0 to CountNodes-1 do
  begin
    if Atx(i,no)=va then
    begin
      result:=It(i);
      Break;
    end;
  end;
end;



Function Tit.IsNode(const sis: SString; upcase: Boolean): Boolean;
Begin
  if upcase then
  begin
    result := Upst(StCustom) = Upst(sis)
  end
  else
  begin
    result := StCustom = sis
  end;
end;

function Tit.It(ii: INTEGER): Tit;
begin
  result:=nil
end;

procedure Tit.SetAttribute(const attrName, value: SString);
begin
end;

procedure Tit.SetCustom(const st: SString);
begin

end;

function Tit.StCustom: SString;
begin
  result:=''
end;

function Tit.Ti(const xmltit: SString): Tit;
begin
  result:=nil;
end;

Function XCount(a: Tit): INTEGER;
begin

  if a <> nil then
  begin
    result := a.CountNodes
  end
  else
  begin
    result := 0;
  end;
end;


function Tit.Analiza(const no: SString; Cached_: Boolean;
  maxi_: INTEGER): TxStringList;
begin
  result := nil;
end;

function Tit.CountNodes: INTEGER;
begin
    result := 0
end;


function Tit.Attribute(const attrName: SString; modof: TModeFindXml): SString;
begin
  result:=''
end;



Function Tit.AtX(ii: INTEGER; const campo: SString;
  modof: TModeFindXml = [MxoNoCS]): SString;
VAR
  X: Tit;
begin
   x:=It(ii);
   if X = Nil then
   begin
      result := ''
   end else
   begin
      result := X.Attribute(campo, modof);
   end;
end;
(*
function Tit.AtX(ii: INTEGER; const campo: SString;
  modof: TModeFindXml): SString;
begin
  result := ''
end;
*)

procedure Tit.RenderJson(sss: Tstream; renderTit: Boolean);
begin

end;

Function Tit.RendermeJson: SString;
var
  S: Tstream;
Begin
    try
      S := TMemoryStream.Create; // CreaStream;
      try
        RenderJson(S);
        result := ReadStreamMax(S, 0);
      finally
        Freenil(S);
      end;
    except
      result := '';
    end;
 end;




Function At (a: Tit; const campo: SString;
  modof: TModeFindXml = [ MxoNoCS]): SString;
begin
    TRY
      if a = nil then
      begin
        result := '';
      end
      else
      begin
        result := a.Attribute(campo, modof)
      end;
    except
      WarningTodo(['Atributo ', campo]);
    end;
end;


function NodeIt (Xmain: Tit; nos: SString): SString;
var
  na: SString;
  X: Tit;
var
  ipos: INTEGER;
begin
    result := '';
    if Xmain = Nil then
    begin
      Exit;
    end;
    na := Fetchar('.', nos);
    if (nos = '') then
    begin
      result := Xmain.Attribute(na)
    end
    else
    begin
      X :=Xmain.Find(na);
      if X <> Nil then
      begin
        ipos := CharPos_('.', nos);
        If ipos = 0 then
        begin
          result := X.Attribute(nos)
        end
        else
        begin
          result := NodeIt(X, nos)
        end;
      end;
      // result:=FindNodeAt(Xmain,na,nos)
    end;
 end;




Function Last(a: Tit): INTEGER;
begin
    if a = nil then
    begin
      result := -1;
    end
    else
    begin
        result := a.CountNodes - 1
    end;
 end;



function Tit.GetEnumerator: TItEnumerator;
begin
   result:=TItEnumerator.Create (self);
end;

constructor TItEnumerator.Create(Ax_: Tit);
begin
  inherited Create;
  FIndex := -1;
  flast:=Last(Ax_);
  Fxml:= Ax_;
end;

function TitEnumerator.GetCurrent: Tit;
begin
  Result := Fxml.It(FIndex);
end;

function TitEnumerator.MoveNext: Boolean;
begin
  Result := FIndex <flast;// FXml.Count - 1;
  if Result then
    Inc(FIndex);
end;



end.
