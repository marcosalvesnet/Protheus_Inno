/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ F1299Inno      ³ Autor ³ Marcos Alves    ³ Data ³02/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ F12 - Comuta a porta de impressao ECF x Emulador			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FR271FFuncoes()                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Progr.   ³ Data        Descricao								      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos    ³02/02/08³Criacao 									          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA200F1299(cTipo,cPdv,lVldSenha)
Local cImpressora	:= ""
Local cPorta		:= ""

Default lVldSenha	:=.F.
Default cPDV		:= ""
Default cTipo		:="F"

If MsgNoYes("Todas as vendas deverao ser impressas ?" )
 	INNO_IMP[1]:= "I"
Else
 	INNO_IMP[1]:= "E"
EndIf	
INNO_IMP[2]:=""

//U_IA200Imp()

Return .T.             

User Function IA200Imp(cImp)
Local cPorta	:= AllTrim(SLG->LG_PORTIF)
Local nI		:= 0

DEFAULT cImp := ""
// Para nao abrir a impressora em toda as vendas, verifica se a impressora eh diferente da que esta aberta
If INNO_IMP[2]<>"1" .AND. (INNO_IMP[1]=="I".OR. cImp=="I") 
	INFFechar("0",cPorta)
	//INFFechar()
    //Sleep(2000 ) // Para o processamento por 5 segundo
	nHdlECF 	:= -1
	cImpressora	:= AllTrim(SLG->LG_IMPFISC) //"BEMATECH MP4200 V01.00.00"
	cPorta		:= AllTrim(SLG->LG_PORTIF)
	For nI := 1 to 10
		nHdlECF:= INFAbrir(cImpressora, cPorta,0,9000)
		ConOut("Abrindo Impressora............: "+cImpressora+" Tentativa..: "+Str(nI,3))
		If nHdlECF<>NIL .AND. nHdlECF<>-1 .AND. cPorta<>NIL
			Exit
		EndIf	
	    Sleep( 2000 ) // Para o processamento por 1 segundo
  	Next nI
	INNO_IMP[2]	:= "1"
ElseIf INNO_IMP[2]<>"2" .AND. (INNO_IMP[1]=="E".OR. cImp=="E")
	INFFechar("0",cPorta)
	//INFFechar()
    //Sleep( 2000 ) // Para o processamento por 5 segundo
	nHdlECF 	:= -1
	cImpressora	:= "EMULADOR NAO FISCAL"
	cPorta		:= "COM1"
	For nI := 1 to 10
		nHdlECF:= INFAbrir(cImpressora, cPorta,0,9000)
		ConOut("Abrindo Impressora............: "+cImpressora+" Tentativa..: "+Str(nI,3))
		If nHdlECF<>NIL .AND. nHdlECF<>-1
			Exit
		EndIf	
	    Sleep( 2000 ) // Para o processamento por 5 segundo
  	Next nI
	INNO_IMP[2]	:= "2"
EndIf

Return NIL
