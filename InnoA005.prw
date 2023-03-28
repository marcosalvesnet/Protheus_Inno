/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FR271BCancela  ³ Autor ³ Marcos Alves    ³ Data ³25/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ P.E. (FRTA271F) executado apos o cancelamento de cupom     ³±±
±±³          ³ - Restaura os itens digitados no cartao                    ³±±
±±³          ³ - Mensagem no console do servidor                          ³±±
±±³          ³ - Msnsagen para o usuário cartoes resturados               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Innocecio 												  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//User Function FR271BCancela
User Function FRTCancela
Local nVar1		:=ParamIxb[1]
Local cVar2		:=ParamIxb[2]
Local lRet		:=.T.
Local cNum		:= SL1->L1_NUM
Local cDoc		:= SL1->L1_DOC
Local cCartao	:= ""
Local aCartao	:={}
Local nI		:= 0
Local nPos		:= 0 
Local aAreaSZZ 	:= SZZ->(GetArea())
Local aAreaSZX 	:= SZX->(GetArea())

dbSelectArea("SZZ")
dbSetOrder(2) //ZZ_FILIAL+ZZ_NUMERO
If (SZZ->(dbSeek(xFilial("SZZ")+cNum))) //ZZ_FILIAL+ZZ_	NUMERO
	While SZZ->ZZ_FILIAL+SZZ->ZZ_NUMERO==xFilial("SZZ")+cNum
		//Restaurando a venda
		If (nPos:=Ascan( aCartao,{|x| X[1]==SZZ->ZZ_CARTAO}))<>0
			aCartao[nPos,2]+=SZZ->ZZ_VLRITEM
		Else
			aadd(aCartao,{SZZ->ZZ_CARTAO,SZZ->ZZ_VLRITEM})
		EndIf
		SZZ->(RecLock("SZZ", .F.))
	    SZZ->ZZ_FLAG:="0"
	    //SZZ->ZZ_NUMERO:="XXXXXX" //Mexe o Indice
		SZZ->(MsUnlock())
		SZZ->(dbSkip())
	End	
EndIf
cCartao:=""
dbSelectArea("SZX")
For nI:=1 to Len(aCartao)
	SZX->(dbSeek(xFilial("SZX")+aCartao[nI,1]))
	SZX->(RecLock("SZX", .F.))
	SZX->ZX_VLRLIQ:=aCartao[nI,2]
	SZX->(MsUnlock())
	cCartao+=aCartao[nI,1]
Next nI	 

U_IA223InitVar() //Inicializar as variaveis
If !Empty(cCartao)
	Conout("["+Dtoc(dDataBase)+" "+Time()+"]"+"INNO_005.PRW 001 - Cancelamento Cupom/Orc.:"+cDOC+"/"+cNum+" Restaurado cartao"+cCartao)
	MsgInfo("Restaurado cartão(ões): "+cCartao)
Else	//Cupom aberto
	Conout("["+Dtoc(dDataBase)+" "+Time()+"]"+"INNO_005.PRW 001 - Cancelamento Cupom/Orc.:"+cDOC+"/"+cNum+" Restaurado cartao XXX")
EndIf
RestArea( aAreaSZZ )
RestArea( aAreaSZX )

Return lRet
