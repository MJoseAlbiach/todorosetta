unit ToDoMiMes;

interface

uses ToDoAbstract;

function MimeType(const nom: SString): SString;

function ExtensionIsZip (const nom:SString):Boolean;
function ExtensionNameIsText (const nom:SString):Boolean;

implementation

uses ToDoS;




function ExtensionNameIsText (const nom:SString):Boolean;
var ex:String;
begin
  ex:=ExtensionName(nom);
  result:= (ex = StrHTML_)
  //or (ex = 'JS')
   or (ex = 'HTM')

//  or (ex = 'CSS') ;
end;




function ExtensionIsZip (const nom:SString):Boolean;
var ex:String;
begin
  ex:=ExtensionName(nom);
  result:= (ex = 'ZIP')
end;



function ExtensionNameIsImage (const nom:SString):Boolean;
var ex:String;
begin
  ex:=ExtensionName(nom);
  result:= (ex = 'JPG')
   or (ex = 'BMP')
   or (ex = 'PNG')
   or (ex = 'SVG')
  or (ex = 'GIF') ;
end;





function MimeType(const nom: SString): SString;
var
  ex: SString;
begin
  ex := ExtensionName(nom);
  if (ex = '') then
  begin
    result := ''
  end
  else
  if (ex = 'CSS') then
  begin
    result := 'text/css'
  end
  else if (ex = 'SVG') then
  begin
    result := 'image/svg+xml'
    // result:='image/svg-xml'
  end
  else

  if ExtensionNameIsText(nom) then
  begin
    result := 'text/html';
  end
  else if ExtensionNameIsImage(nom) then
  begin
    result := 'image/jpeg';
  end
  else

  
  begin
    result := 'application/binary';
  end;
end;



end.
