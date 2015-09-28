{$ifdef CPU64}
{$DEFINE PUREPASCAL}
{$endif CPU64}

{$DEFINE indy10}


//delphi 2006
{$IFDEF ver180}{$DEFINE delphi2006}{$DEFINE indy10}{$ENDIF ver180}
//delphi 2007
{$IFDEF ver190}{$DEFINE delphi2006}{$DEFINE indy10}{$ENDIF ver190}


(* not sure compatibility
{$IFDEF ver200}{$DEFINE delphi2006}{$DEFINE indy10}{$ENDIF ver200}
.....
{$IFDEF ver250}{$DEFINE delphi2006}{$DEFINE indy10}{$ENDIF ver250}
*)

// xe5
{$IFDEF ver260}{$define DelphiDx}{$ENDIF ver260}
// xe7
{$IFDEF ver280}{$define DelphiDx}{$ENDIF ver280}
// xe8
{$IFDEF ver290}{$define DelphiDx}{$ENDIF ver290}
// xe10
{$IFDEF ver300}{$define DelphiDx}{$ENDIF ver300}


{$IFDEF DelphiDx}
 {$DEFINE xe5}
{$ENDIF DelphiDx}



{$IFNDEF xe5}
{$DEFINE dependencias}
{$DEFINE dependenciasDb}
{$DEFINE dependenciasDbIB}
{$DEFINE dependenciasVcl}
{$ENDIF xe5}

{$define veryfast}

{$IFDEF DelphiDx}
{$UNDEF veryfast}
{$DEFINE PUREPASCAL}
{$ENDIF DelphiDx}

{$ifdef FPC}
{$undef dependencias}
{$undef veryfast}
{$define lazarus}
{$DEFINE PUREPASCAL}
{$endif FPC}


{$DEFINE mimormot}

{$Define minimal}
{$Define dependeWinForms}

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

