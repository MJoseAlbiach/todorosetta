unit ToDoAbstract;

{$I inctodo.pas}
//{$IFDEF FPC}
//{define Delphi}
//{$ENDIF}

(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ToDoAbstract
  ========================
   Abstract types and base class and interfaces for ToDoRosetta

  version 0.1 )

  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)


interface

uses
{$IFNDEF android}
{$IFDEF DelphiDx}
  AlStringList,
{$ENDIF DelphiDx}
{$ENDIF android}
  Classes;

type

  TBytex = array of Byte;

const

  MaxByte = 255;

type
  ArrayChars = array [0 .. MaxByte] of Char;

  TByteSet = set of Byte;
  PtLint = ^integer;

  PtWord = ^Word;
  Inte = SmallInt;
  PtInt = ^Inte;

type
  PtrInt = integer;
  TTipoObjeto = (Tonone, Todisk, Todir, ToFile, ToObject, Toindef);
  IntFecha = Word;
  PtrByte = ^Byte;

type

{$IFDEF android}
  TRTLCriticalSection = integer;
  SPChar = PChar; // ^SChar; //PAnsiChar;
{$ELSE android}
  PWChar = ^WIdeChar; // ^SChar; //PAnsiChar;
  SPChar = PAnsiChar; // ^SChar; //PAnsiChar;
{$ENDIF android}
{$IFDEF DelphiDx}
{$IFNDEF android}

type
  TStringList = TALStringList;
  TStrings = TALStrings;
  SString = AnsiString;
  SChar = AnsiChar;


type
  PtrsStrsS = ^shortString;

{$ELSE android}

type
  SString = String;

  SChar = Char;

  PtrsStr = ^String;
{$ENDIF android}
{$ELSE delphidx}

type
  SString = AnsiString;
  SChar = Char;
  PtrsStr = ^shortString;
  TStringDynArray = array of SString;

{$ENDIF DelphiDx}

type

  ITodoInterface = interface
    ['{C4A46235-088E-48C2-AF6E-A5508AA88522}']
    function Componente: TComponent;
  end;

  TInterfacedComponent = class(TComponent, ITodoInterface) // IInvokable)
  private
    FRefCount: integer;
    FRefenced: Boolean;
  protected
    function _AddRef: integer; stdcall;
    function _Release: integer; stdcall;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
    function Componente: TComponent;
    function DoReferentCount: Boolean;
    property Refenced: Boolean read FRefenced;
  private

    procedure TestDisconnectCo;
  end;

  ILog = interface(ITodoInterface)
    procedure Log(const describe: SString);
  end;

  TLogAbstract = class(TInterfacedComponent, ILog)
    procedure Log(const describe: SString); virtual; abstract;
  end;

  TMiInterfaceClass = class of TInterfacedComponent;

  IMix = interface(ITodoInterface)
    ['{194F3958-6CC6-4CCE-952B-01491D1FA007}']
    function getObj: TObject;
    procedure setObj(v: TObject);
  end;

  TLazys = (lazyDefault, lazyClass, lazyNo, lazyYes);
  TLazy = set of TLazys;



  TMix = class(TInterfacedComponent, IMix)
  protected
    FObj: TObject;
    FClassInject: TClass;
    lazy: TLazy;
    function getObj: TObject;
    procedure setObj(v: TObject);
  public
    constructor Create(aOwner: TComponent); override;
    constructor CreateInfo_(aOwner: TComponent; p: pointer); virtual;

    destructor Destroy; override;
    procedure DestroyObj;

    property Obj: TObject read getObj write setObj;
    function CreateInyection: TObject; virtual;
  end;



  TModeFindAtt = (MxoUtf, MxoNoCS, MxoTrim, MxoBlanco, MxoError,
    Mxoexcluye, MxoMini);
  TModeFindXml = set of TModeFindAtt;

  Reales = Double;

  Tosversion = (Toswin, Toslinux);

var
  Osver: Tosversion = Toswin;

implementation

uses

{$IFDEF android}
{$ELSE android}
  ActiveX,
  Windows,
{$ENDIF android}
  SysUtils,
  ToDos;


function TInterfacedComponent._AddRef: integer;
begin
  if Refenced then
  begin
{$IFDEF android}
    inc(FRefCount);
    result := FRefCount;
{$ELSE android}
    result := InterlockedIncrement(FRefCount);
{$ENDIF android}
  end
  else
    result := inherited _AddRef;
end;

function TInterfacedComponent._Release: integer;
begin
  if Refenced then
  begin
{$IFDEF android}
    dec(FRefCount);
    result := FRefCount;
{$ELSE android}
    result := InterlockedDecrement(FRefCount);
{$ENDIF android}
    if result = 0 then
    begin
      Destroy;
    end;
  end
  else
  begin
    result := inherited _Release;
  end;
end;

function TInterfacedComponent.Componente: TComponent;
begin
  result := self;
end;

function TInterfacedComponent.DoReferentCount: Boolean;
begin
  FRefenced := True;
  inc(FRefCount)
end;

constructor TInterfacedComponent.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FRefenced := False;
  FRefCount := 0;
end;

procedure TInterfacedComponent.TestDisconnectCo;
begin
{$IFDEF android}
{$ELSE android}
  if FRefCount > 0 then
    CoDisconnectObject(self, 0);
{$ENDIF android}
  FRefCount := 0;
end;

procedure TInterfacedComponent.BeforeDestruction;
begin
  // if   FRefCount <> 0
  // then war
end;

destructor TInterfacedComponent.Destroy;
begin
  TestDisconnectCo;
  inherited Destroy;
end;



constructor TMix.CreateInfo_(aOwner: TComponent; p: pointer);
begin
  TMix.Create(aOwner);
end;

function TMix.CreateInyection: TObject;
begin
  result := nil;
  if FClassInject <> nil then
  begin
    if lazyClass in lazy then
    begin
      result := FClassInject.Create;
    end
    else
    begin
      result := TComponentClass(FClassInject).Create(Owner);
    end;
  end;
end;

function TMix.getObj: TObject;
begin
  if FObj = nil then
  begin
    FObj := CreateInyection()
  end;
  result := FObj;
end;

procedure TMix.setObj(v: TObject);
begin
  FObj := v;
end;

procedure TMix.DestroyObj;
begin
  if not(lazyNo in lazy) then
  begin
    FreeNil(FObj);
  end;
end;

constructor TMix.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FObj := Nil;
  FClassInject := Nil;
  lazy := [];
end;

destructor TMix.Destroy;
begin
  FreeNil(FObj);
  inherited;
end;


end.

todomix
