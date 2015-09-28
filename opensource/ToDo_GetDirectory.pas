unit ToDo_GetDirectory;

(*
  This file is part of ToDoRosetta framework.
  Copyright (C) 2015 Antonio Alcázar Ruiz. Multi-Informática Teruel S.L

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at http://www.mozilla.org/MPL
  .....


  ToDo_GetDirectory
  ========================
   get directory tree in xml structure

  version 0.1 )  - Initial version.

******** This file is under construction ********
*** Please don't use it in production project ***
*)


interface

uses
  ToDoIt,
  ToDoAbstract;

Procedure GetDirecX(const directorio, masc, search: SString; pila_: Tit);

implementation

uses SysUtils,
  ToDos;

Procedure GetDirecX(const directorio, masc, search: SString; pila_: Tit);
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
              gets := GetFile(nf);
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
              begin
                x.SetAttribute('zip', '1');
                // ?       x.SetAttribute('alias', Upst(r.name));
              end;
            end;
          end
        end;

      until FindNext(r) <> 0;
    end;
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
            GetDirecX(nf, masc, search, pila_);
          end
        end;

      until FindNext(r) <> 0;

    end;
    SysUtils.FindClose(r);
  end;
end;

end
