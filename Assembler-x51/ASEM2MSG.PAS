(******************************************)
(*     ASEM-51 Filter for Borland-IDE     *)
(*              Version 1.1               *)
(*        W.W. Heinz, 15. 12. 1998        *)
(******************************************)

PROGRAM asem2msg;

(* This program allows to integrate ASEM-51 into a Borland IDE for DOS. *)
(* It is a filter for the ASEM-51 error messages that converts the ASEM *)
(* console output to the Borland IDE format. ASEM2MSG works with the    *)
(* IDE of Turbo C++ 1.0 thru 3.0 as well as with Turbo-Pascal 7.0.      *)
(* ASEM2MSG.PAS can be compiled with Turbo-Pascal 4.0 thru 7.01.        *)

VAR auf,zu,komma,lnr,cnr: WORD;
    status: INTEGER;
    line,filename,scratch: STRING;

BEGIN
  filename:='';
  write('BI#PIP#OK'#0);                       (* header string *)
  while NOT EOF do
  begin
    readln(line);                             (* read from standard input *)
    auf:=POS('(',line);                       (* open parentheses *)
    zu:=POS(')',line);                        (* close parentheses *)
    if (auf>0) AND (zu>0) AND (auf<zu) then
    begin
      (* ASEM-51 assembly error message: *)
      scratch:=COPY(line,1,auf-1);            (* file name *)
      if scratch<>filename then
      begin
        filename:=scratch;
        write(#0,filename,#0);                (* new file name *)
      end;
      scratch:=COPY(line,auf+1,zu-auf-1);
      komma:=POS(',',scratch);
      if komma=0 then                         (* error position format *)
      begin
        (* line number only: *)
        VAL(scratch,lnr,status);
        cnr:=1;
      end
      else
      begin
        (* both line and column number: *)
        VAL(COPY(scratch,1,komma-1),lnr,status);
        if status=0 then
          VAL(COPY(scratch,komma+1,length(scratch)-komma),cnr,status);
      end;
      if status=0 then
      begin
        (* legal ASEM-51 error message: *)
        scratch:=COPY(line,zu+3,132);         (* error message *)
        write(#1,CHR(LO(lnr)),CHR(HI(lnr)),
                 CHR(LO(cnr)),CHR(HI(cnr)),scratch,#0);
      end;
    end
    else
      if POS('@@@@@',line)>0 then
      begin
        (* ASEM-51 runtime error message: *)
        if filename='' then write(#0#0);      (* dummy file name *)
        scratch:='FATAL ERROR!  '+COPY(line,7,length(line)-12);
        if length(scratch)>132 then scratch[0]:=CHR(132);
        write(#1#0#0#0#0,scratch,#0);
      end;
  end;
  write(#127);                                (* end string *)
END.
