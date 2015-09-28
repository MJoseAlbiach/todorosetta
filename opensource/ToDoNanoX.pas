unit ToDoNanoX;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ToDoNanoX
  ========================
   very simple xml implementation

  version 0.1 )  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)

interface

uses
  TodoString,
  Classes,
  ToDoAbstract,
  ToDoIt;

type

  TAttributesXml = class(TxStringList)
  public
    procedure SaveParamters (sss: Tstream);
  end;


  TXml = class;

  TItx = class(Tit)
  protected
    FStCustom: SString;
    FParentNode: TItx;
    /// <summary>
    /// list of XML attributes
    /// </summary>
    FAttributes: TAttributesXml;

  protected
    Function StCustom: SString; override;
    Function IsCustom(const sis: SString; upcase: Boolean): Boolean; virtual;
    procedure Render(sss: Tstream); Virtual;
    Function Renderme: SString;

  public
    constructor CreateX; virtual;
    function AttributeParsed: TAttributesXml; virtual;
    function NodeChildFast(const NoName: SString; upcase: Boolean = false): TIt;
    procedure SetAttribute(const attrName: SString;
      const value: SString); override;

    property Count: INTEGER read CountNodes;
    property ParentNode: TItx read FParentNode write FParentNode;
    Property child[Index: INTEGER]: Tit read It; default;
    property Attributes: TAttributesXml read AttributeParsed;
  end;

  /// <summary>
  /// TXml render engine.
  /// </summary>

  TipoDom = (Afnormal_, Afauto_, Afnoauto_, Afauto2__, AfData_);

  TXml = class(TItx)
  protected
    pAuto: TipoDom;

  public
    function CountNodes: INTEGER; override;
  public
    /// <summary>
    /// list of sub-htmltag nodes
    /// </summary>
    FNodes_: TxStringList;


    constructor Create(const lt: SString = ''; ow: TXml = Nil); virtual;
    destructor Destroy; override;

    function Find(const NodeName: SString; sub: Boolean): Tit; override;

    function Attribute(const attrName: SString;
      modof: TModeFindXml = [ MxoNoCS]): SString; override;

    function It(ii: INTEGER): Tit; Override;
    Function StCustom: SString; override;

  public
    function Ti(const xmltit: SString): Tit; override;
    procedure Render(sss: Tstream); override;

    Property Auto: TipoDom read pAuto write pAuto;

    procedure AddX(o: TItx);
    procedure DoneNodes;


    property FNodeName_: SString read FStCustom;

    Function AtX(ii: INTEGER; const campo: SString;
      modof: TModeFindXml = [MxoNoCS]): SString; override;

    procedure RenderJson(sss: Tstream; renderTit: Boolean = true); override;
    Function RendermeJson: SString; override;

    property ToXML: SString read Renderme;

  end;



const
  KABRETAGChar: SChar = '<';
  KABRETAG: SString = '<';
  Spacetag: SChar = ' ';



implementation

Uses
  SysUtils,
  ToDos;

const
  AbretagFin: SString = '</';
  AbretagFinCierra: SString = '</>';
  Cierratag_: SString = '>';
  CierratagChar: SChar = '>';
  CierratagFin: SString = '/>';

function TItx.NodeChildFast(const NoName: SString; upcase: Boolean = false): TIt;
var  it:TIt;
begin
    for it in self do
    begin
      if it <> nil then
      begin
          if it.IsNode(NoName, upcase) then //
          begin
            result := it;
            Exit;
          end;
      end;
    end;
    result := nil
 end;

 
Function TXml.AtX(ii: INTEGER; const campo: SString;
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



Function TXml.StCustom: SString;
Begin
    result := FStCustom
 end;


procedure TXml.DoneNodes;
var
  n: INTEGER;
  o: TIt;
begin
  if self = nil then
  begin
    Exit;
  end;
  try
    if FNodes_ <> nil then
    begin
      for n := FNodes_.Count - 1 downto 0 do
      begin
        o := It(n);
        if o <> Nil then
        begin
            o.free;
        end;
      end;
      if FNodes_ <> Nil then
      begin
        FNodes_.free;
        FNodes_ := Nil;
      end;
    end;
  except

  end;
end;


procedure TXml.AddX(o: TItx);
begin
  if FNodes_ = nil then
  begin
    FNodes_ := TxStringList.Create;
  end;
  FNodes_.AddObjects(o);
end;

constructor TXml.Create(const lt: SString = ''; ow: TXml = Nil);
begin
  inherited Create;
  FStCustom := lt;
  FAttributes := Nil;
  FParentNode := ow;
  FNodes_ := Nil;
  Auto := Afnormal_;
  if ow <> Nil then
  begin
    ow.AddX(self);
  end
end;

var
  AntiBlock_: INTEGER = 0;

destructor TXml.Destroy;
begin
    if AntiBlock_ < 30 then
    begin
      if FNodes_ <> nil then
      begin
        DoneNodes;
      end;
    end;
  Freenil(FAttributes);
  FStCustom := '';
  inherited Destroy;
  // ?  dec(AntiBlock);
end;

function TXml.CountNodes: INTEGER;
begin
    if FNodes_ = Nil then
    begin
      result := 0
    end
    else
    begin
      result := FNodes_.Count
    end
end;


function TXml.Attribute(const attrName: SString;
  modof: TModeFindXml = [ MxoNoCS]): SString;
begin
  if Assigned(FAttributes) then
  begin
    result := FAttributes.FastValue (attrName, MxoNoCS in modof);
  end
  else
  begin
    result := '';
  end;
end;

function TItx.AttributeParsed: TAttributesXml;
begin
  if not Assigned(FAttributes) then
  begin
    FAttributes := TAttributesXml.Create;
  end;
  result := FAttributes;
end;


// http://www.json.org/
procedure TXml.RenderJson(sss: Tstream; renderTit: Boolean = true);
var
  nax, vax: SString;
  Tags: SString;
  cu, le, n, i: INTEGER;
  sy: TIt;
  ats: TAttributesXml;
  coma: Boolean;

  procedure W(const S: SString);
  begin
    le := length(S);
    if le > 0 then
    BEGIN
      sss.Write(S[1], le)
    end
  end;

  procedure WpL(const S: Spchar; le: INTEGER);
  begin
    sss.Write(S^, le)
  end;

  procedure Wc(const S: Char);
  begin
    sss.Write(S, 1)
  end;

Begin
    cu := Count;
    if cu > 1 then
    begin
      Wc('[');
      renderTit := false;
    end
    else
    begin
      Wc('{');
    end;

    coma := false;
    if renderTit then

      IF FAttributes <> Nil then
      begin
        coma := true;
        ats := Attributes;
        for i := 0 to ats.Count - 1 do
        begin
          if i > 0 then
          begin
            Wc(',');
          end;
          GetTitValues(ats[i], nax, vax);
          begin
            sss.Write(nax[1], length(nax));
            WpL(':"', 2);
            sss.Write(vax[1], length(vax));
            Wc('"');
          end;
        end;
      end;

    if Assigned(FNodes_) then
    begin
      if coma then
      begin
        Wc(',');
      end;

      for n := 0 to cu - 1 do
      begin
        sy := It(n);
        if n > 0 then
        begin
          W(',');
        end;
        if sy <> Nil then
        begin
          if renderTit then
          begin
            Tags := sy.StCustom;
            if (Tags <> '') then
            begin
              W(Tags + ':');
              // Rendertit:=False;
            end;
          end;
          sy.RenderJson(sss);
        end;
      end;
    end;
    if cu > 1 then
    begin
      Wc(']');
    end
    else
    begin
      Wc('}');
    end;
 end;


procedure TItx.SetAttribute(const attrName: SString; const value: SString);
begin
  if not Assigned(FAttributes) then
  begin
    if value = '' then
    begin
      Exit;
    end;
    FAttributes := TAttributesXml.Create;
  end;
  FAttributes.SetAttribute(attrName, value);
end;

procedure TXml.Render(sss: Tstream);
var
  Tag: SString;
  le, n: INTEGER;
  sy: Tit;
  eolpen: Boolean;

  procedure W(const S: SString);
  begin
      le := length(S);
      if le > 0 then
      BEGIN
        sss.Write(S[1], le)
      end
  end;



Begin
    eolpen := false;
    Tag := FStCustom;


    if Tag <> '' then
    begin
      if Auto = AfData_ then
      begin
        Tag := '![' + Tag + '[' + EOL;
        W(EOL + KABRETAG + Tag);
      end
      else
      begin
        sss.Write(KABRETAGChar, 1);
        W(Tag);
      end;
      IF FAttributes <> Nil then
      begin
        sss.Write(Spacetag, 1);
        FAttributes.SaveParamters(sss);
      end;

      case Auto of
        Afauto_:
          begin
            W(CierratagFin);
          end;
        AfData_:
          begin
          end;
      else
        begin
          sss.Write(CierratagChar, 1);
        end;
      end;
    end;

    if Assigned(FNodes_) then
    begin
      for n := 0 to FNodes_.Count - 1 do
      begin
        W(FNodes_[n]);
        sy :=It(n);

        if sy <> Nil then
        begin
          if eolpen then
          begin
            eolpen := false;
          end;
          TXml(sy).Render(sss);

        end;
      end;

    end;
    if Tag <> '' then
    begin
      case Auto of
        Afauto2__:
          begin
            W(AbretagFinCierra);
          end;
        Afnormal_:
          begin
            W(AbretagFin); // + Tag + Cierratag);
            W(Tag);
            sss.Write(CierratagChar, 1);
          end;
        AfData_:
          begin
            W(EOL + ']]' + Cierratag_ + EOL);
          end;
      end;
    end;

 end;


function TXml.Ti(const xmltit: SString): Tit;
begin
  result := TXml.Create(xmltit, self)
end;

procedure TAttributesXml.SaveParamters (sss: Tstream);
var
  ipos, i: INTEGER;
  os, S: SString;
  cc: SChar;
Begin
  begin
    begin
      cc := ' '
    end;
    for i := 0 to Count - 1 do
    begin
      if i > 0 then
      begin
        sss.Write(cc, 1)
      end;

      S := Get(i);
      ipos := CharPos_(KSIGUAL, S);
      If ipos = 0 then
      begin

        os := S + '=""';
      end
      else
      begin
        os := Copy(S, 1, ipos) + '"' + Copy(S, ipos + 1, MaxInt) + '"';
        // ?trcado
      end;

      sss.Write(os[1], length(os))
    end;
  end;
end;

function TXml.Find(const NodeName: SString; sub: Boolean): Tit;
var
  X: TIt;
begin
  result := NodeChildFast(NodeName);
  if result = Nil then
    if sub then
    begin
      for x in self do
      begin
        if X.CountNodes>0 then
        begin
            result := X.Find(NodeName, sub);
            if result <> Nil then
              Exit;
        end;
      end;
      if StCustom = NodeName then
      begin
        result := self;
      end
      else
      begin
        result := nil;
      end;
    end;
end;

Function TItx.StCustom: SString;
Begin
  result := ''
end;

Function TItx.IsCustom(const sis: SString; upcase: Boolean): Boolean;
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

procedure TItx.Render(sss: Tstream);
Begin
end;

Function TItx.Renderme: SString;
var
  S: Tstream;
Begin
  try
    S := TMemoryStream.Create; // CreaStream;
    try
      Render(S);
      result := ReadStreamMax(S, 0);
    finally
      Freenil(S);
    end;
  except
    result := '';
  end;
end;


function TXml.It(ii: INTEGER): Tit;
begin
  if (FNodes_ = nil) then
  begin
      result := Nil;
  end
  else if (ii < 0) or (ii >= FNodes_.Count) then
  begin
    result := Nil;
  end
  else
  begin
    result := TXml(FNodes_.Objects[ii]);
  end;
end;

constructor TItx.CreateX();
begin
  inherited Create;
  FAttributes := Nil;
  FParentNode := Nil;
end;


Function TXml.RendermeJson: SString;
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


end.




