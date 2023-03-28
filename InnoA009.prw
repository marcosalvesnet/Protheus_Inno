#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
//#INCLUDE "FRTA271D.CH"

#define _PICTURE 13

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³InnoF1205 ³ Autor ³ Marcos Alves          ³ Data ³ 28/02/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Efetua Sangria/Entrada de Troco no Front Loja			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IA009F1295(nHdlECF,nCheck)             

Local oDlgSangr, oCheck, oBtnAct, oBtnEnd, oGroup1, oGroup2, oGroup3
Local oCodOrigem, oCodDestin
Local oMoeda
Local cCodOrigem := xNumCaixa()
Local cCodDestin := Space(Len(cCodOrigem))
Local cMoedaCorr := GetMv("MV_MOEDA1")
Local cCampo     := ""
Local oDinheir, oCheques, oCartao, oVlrDebi, oFinanc, oConveni, oVales, oOutros
Local nDinheir  := 0
Local nCheques  := 0
Local nCartao   := 0
Local nVlrDebi  := 0
Local nFinanc   := 0
Local nConveni  := 0
Local nVales    := 0
Local nOutros   := 0        
Local nAltura   := 0
Local nAltura2  := 0
Local nX
Local nPosCampo := 0
Local aRet      := {} // Retorno do Ponto de Entrada
Local aMoedas   := {}
Local aSimbs    := {}
Local lRet      := .F.
Local cCaixaSup := Space(15)
Local lTouch := ( LJGetStation("TIPTELA") == "2" )
Local oKeyAlpha
Local oKeyNum
Local nKeyALeft
Local nKeyATop
Local nKeyNLeft
Local nKeyNTop
Local oKeyboard
Local cTitulo	:=If(nCheck=1,"Sangria de Caixa","Entrada de Troco")
Private nMoedaCorr := 1   // Moeda Corrente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Permissao "Sangria/Entrada de Troco" - #5 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !LjProfile(5, @cCaixaSup)
    //"Usuario sem permissao para realizar Sangria / Entrada de Troco. Atencao" 				
	MsgStop("Usuário" + AllTrim(cUserName) + "sem permissao para realizar Sangria","Atencao")
	Return(NIL)
EndIf

nCheck := if(nCheck ==NIl,0,nCheck)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se Troco o caixa destino sempre eh o operador atual³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nCheck = 2
	cCodDestin := xNumCaixa()
	cCodOrigem := Substr(GetMv("MV_CXLOJA"),1,3)
Else
	cCodDestin := Substr(GetMv("MV_CXLOJA"),1,3)
	cCodOrigem := xNumCaixa()
EndIf

If lGaveta
	If (!Empty(LJGetStation("PORTGAV"))) .And. (LJGetStation("PORTIF") <> LJGetStation("PORTGAV"))
		GavetaAci(nHdlGaveta, LJGetStation("PORTGAV"))
	Else
		IFGaveta(nHdlECF)
	EndIf
EndIf

SX5->(dbSetOrder(1)) // Primeiro indice para validacao do caixa digitado
SA6->(dbSetOrder(1)) // Primeiro indice para obtencao da Agencia/Conta para geracao do SE5

nKeyALeft := 4
nKeyATop  := 120 + nAltura
nKeyNLeft := 4
nKeyNTop  := 120 + nAltura


DEFINE MSDIALOG ODlgSangr FROM 1,1 TO 230,330 TITLE cTitulo PIXEL OF GetWndDefault()

@ 005,004 GROUP oGroup1 TO 043,057 LABEL "Tipo" COLOR CLR_HBLUE OF oDlgSangr PIXEL

@ 013,007 RADIO oCheck VAR nCheck 3D SIZE 47,10 PROMPT "Sangria","Troco" ON CHANGE IA009Enab(nCheck,@cCodOrigem,@cCodDestin,oCodOrigem,oCodDestin) OF ODlgSangr PIXEL

oCheck:Disable()
/*
If ! nCheck == 0
	oCheck:Disable()
Else
	nCheck := 1
EndIf
*/
@ 005,061 GROUP oGroup2 TO 043,162 LABEL "Origem/Destino" COLOR CLR_HBLUE OF oDlgSangr PIXEL

@ 012,065 SAY "Do Caixa" SIZE 50,10 OF ODlgSangr PIXEL
@ 012,120 MSGET oCodOrigem VAR cCodOrigem F3 "23" WHEN nCheck == 2 SIZE 30,10 OF ODlgSangr PIXEL ;
VALID SX5->(dbSeek(xFilial("SX5")+"23"+cCodOrigem)) .and. SA6->(dbSeek(xFilial("SA6")+cCodOrigem) .And. cCodOrigem <> xNumCaixa())
oCodOrigem:cSx1Hlp:=""

@ 027,065 SAY "Para o Caixa" SIZE 50,10 OF ODlgSangr PIXEL
@ 027,120 MSGET oCodDestin VAR cCodDestin F3 "23" WHEN nCheck == 1 SIZE 30,10 OF ODlgSangr PIXEL ;
VALID SX5->(dbSeek(xFilial("SX5")+"23"+cCodDestin)) .and. SA6->(dbSeek(xFilial("SA6")+cCodDestin) .And. cCodDestin <> xNumCaixa())
oCodDestin:cSx1Hlp:=""

@ 046,004 GROUP oGroup3 TO 90,162 LABEL "Numerários" COLOR CLR_HBLUE OF oDlgSangr PIXEL

@ 055,014 SAY "Dinheiro" SIZE 60,10 OF ODlgSangr PIXEL
@ 055,074 MSGET oDinheir VAR nDinheir Picture PesqPict("SL1","L1_DINHEIR",_PICTURE,nMoedaCorr) SIZE 70,10 OF ODlgSangr PIXEL RIGHT
oDinheir:cSx1Hlp:="L1_DINHEIR" 

If nCheck == 1
	@ 070,014 SAY "Cheques" SIZE 60,10 OF ODlgSangr PIXEL
	@ 070,074 MSGET oCheques VAR nCheques Picture PesqPict("SL1","L1_CHEQUES",_PICTURE,nMoedaCorr) WHEN nCheck == 1 SIZE 70,10 OF ODlgSangr PIXEL RIGHT
	oCheques:cSx1Hlp:="L1_CHEQUES"
EndIf
/*
@ 085,014 SAY STR0011 SIZE 60,10 OF ODlgSangr PIXEL
@ 085,074 MSGET oCartao VAR nCartao Picture PesqPict("SL1","L1_CARTAO",_PICTURE,nMoedaCorr) WHEN nCheck == 1 SIZE 70,10 OF ODlgSangr PIXEL RIGHT
oCartao:cSx1Hlp:="L1_CARTAO"

@ 100,014 SAY STR0012 SIZE 60,10 OF ODlgSangr PIXEL
@ 100,074 MSGET oVlrDebi VAR nVlrDebi Picture PesqPict("SL1","L1_VLRDEBI",_PICTURE,nMoedaCorr) WHEN nCheck == 1 SIZE 70,10 OF ODlgSangr PIXEL RIGHT
oVlrDebi:cSx1Hlp:="L1_VLRDEBI"

@ 115,014 SAY STR0013 SIZE 60,10 OF ODlgSangr PIXEL
@ 115,074 MSGET oFinanc VAR nFinanc Picture PesqPict("SL1","L1_FINANC",_PICTURE,nMoedaCorr) WHEN nCheck == 1 SIZE 70,10 OF ODlgSangr PIXEL RIGHT
oFinanc:cSx1Hlp:="L1_FINANC"

@ 130,014 SAY STR0014 SIZE 60,10 OF ODlgSangr PIXEL
@ 130,074 MSGET oConveni VAR nConveni Picture PesqPict("SL1","L1_CONVENI",_PICTURE,nMoedaCorr) WHEN nCheck == 1 SIZE 70,10 OF ODlgSangr PIXEL RIGHT
oConveni:cSx1Hlp:="L1_CONVENI"


@ 145,014 SAY STR0015 SIZE 60,10 OF ODlgSangr PIXEL
@ 145,074 MSGET oVales VAR nVales Picture PesqPict("SL1","L1_VALES",_PICTURE,nMoedaCorr) WHEN nCheck == 1 SIZE 70,10 OF ODlgSangr PIXEL RIGHT
oVales:cSx1Hlp:="L1_VALES"

@ 160,014 SAY STR0016 SIZE 60,10 OF ODlgSangr PIXEL
@ 160,074 MSGET oOutros VAR nOutros Picture PesqPict("SL1","L1_OUTROS",_PICTURE,nMoedaCorr) WHEN nCheck == 1 SIZE 70,10 OF ODlgSangr PIXEL RIGHT
oOutros:cSx1Hlp:="L1_OUTROS"
*/
DEFINE SBUTTON oBtnAct FROM 95,105 TYPE 1 ENABLE ACTION ;
					IA009Conf(	nCheck		,cCaixaSup	,cCodOrigem	,cCodDestin,;
								nDinheir	,nCheques	,nCartao	,nVlrDebi,;
								nFinanc		,nConveni	,nVales		,nOutros,;
								aSimbs		,ODlgSangr) OF ODlgSangr
DEFINE SBUTTON oBtnEnd FROM 95,135 TYPE 2 ENABLE ACTION ODlgSangr:End() OF ODlgSangr	

ACTIVATE MSDIALOG ODlgSangr CENTER ON INIT (oDinheir:SetFocus())

RETURN NIL
             
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³Fr271D050C³ Autor ³ Cleber Martinez       ³ Data ³ 06/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Confirma a gravacao dos valores informados (Botao OK)   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpL1 := IA009Conf(ExpN1, ExpC2, ExpC3, ExpC4,         ³±±
±±³			 ³ 					  ExpN5, ExpN6, ExpN7, ExpN8,             ³±±
±±³			 ³ 					  ExpN9, ExpN10, ExpN11, ExpN12,          ³±±
±±³  		 ³ 					  ExpA13, ExpO14)			              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 - Indica se eh Troco ou Sangria                      ³±±
±±³          ³ ExpC2 - Codigo do Caixa logado                             ³±±
±±³          ³ ExpC3 - Codigo do caixa (De)                               ³±±
±±³          ³ ExpC4 - Codigo do caixa (Ate)                              ³±±
±±³          ³ ExpN5 - Valor em dinheiro                                  ³±±
±±³          ³ ExpN6 - Valor em cheques                                   ³±±
±±³          ³ ExpN7 - Valor em cartao                                    ³±±
±±³          ³ ExpN8 - Valor em debitos 	                              ³±±
±±³          ³ ExpN9 - Valor financiado                                   ³±±
±±³          ³ ExpN10 - Valor em Convenios                                ³±±
±±³          ³ ExpN11 - Valor em Vales                                    ³±±
±±³          ³ ExpN12 - Outros valores                                    ³±±
±±³          ³ ExpA13 - array de Simbolos de Moeda                        ³±±
±±³          ³ ExpO14 - Objeto dialog                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Front Loja			   								  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA009Conf(nCheck,cCaixaSup	,cCodOrigem	,cCodDestin,;
						nDinheir	,nCheques	,nCartao	,nVlrDebi,;
						nFinanc		,nConveni	,nVales		,nOutros,;
						aSimbs		,ODlgSangr)

Local lVldPE	:= .T.	//retorno da validacao executada no PE
Local lRet		:= .F.	//retorno da funcao

LjMsgRun("Gravando dados...",,{|| lRet := IA009SE5(nCheck,cCodOrigem,cCodDestin,nDinheir,nCheques,nCartao,nVlrDebi,nFinanc,nConveni,nVales,nOutros,aSimbs)})
	
ODlgSangr:End()	
                    
Return (lRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³Fr271D050E³ Autor ³ Edney Soares de Souza ³ Data ³ 26/09/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ativa/Desativa os campos conforme a escolha do Radio Btn	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Fr271D050				   								  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IA009Enab(nCheck,cCodOrigem,cCodDestin,oCodOrigem,oCodDestin)
If nCheck == 1
	cCodOrigem := xNumCaixa()
	oCodOrigem:Refresh()
	oCodDestin:SetFocus()
Else
	cCodDestin := xNumCaixa()
	oCodDestin:Refresh()
	oCodOrigem:SetFocus()
EndIf
Return NIL

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³Fr271D050S³ Autor ³ Edney Soares de Souza ³ Data ³ 26/09/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera o SE5 Conforme os campos digitados na tela			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fr271D050			   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data      | Analista | Bops  | Descricao                               |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³18/11/2005| Marcos R.|088079 | Detalhamento da Sangria no CUPOM        |±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IA009SE5(nCheck,cCodOrigem,cCodDestin,nDinheir,nCheques,nCartao,nVlrDebi,nFinanc,nConveni,nVales,nOutros,aSimbs,lMensa)

Local aNumerarios, nNum
Local nTotal 	:= nDinheir+nCheques+nCartao+nVlrDebi+nFinanc+nConveni+nVales+nOutros
Local cSimb 	:= GetMV("MV_SIMB"+LTrim(Str(nMoedaCorr)))
Local nRet		:= 0   
Local lSup      := SuperGetMV("MV_FORMSUP", ,.F.)                      
Local cFormSup	:= '' // Contem a descricao das formas de Suprimentos que saira no cupom
Local cMsg		:=""
Local nRet		:= -1
Local cCupom	:= ""
Local cNatureza := If(nCheck == 1,"SANGRIA","TROCO")  //"Sangria","Troco"
Local cHistor   := If(nCheck == 1,"SANGRIA DO CAIXA ","TROCO PARA O CAIXA ")+xNumCaixa() //"SANGRIA DO CAIXA ","TROCO PARA O CAIXA "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estaremos utilizando esta função de outros programas             ³
//³portanto em determinadas ocasiões não deverei exibir mensagens   ³
//³parando o processo. Atualmente teremos no fonte LOJA340 e LOJA350³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotal == 0 .And. lMensa
	MsgStop("Valor nao informado, nenhuma movimentação será gerada.","Atencao")  //"Nenhum valor foi informado, nenhuma movimentação será gerada." ### "Atenção"
	Return (.F.)
EndIf
//"Confirma gravação da(s) movimentação(ões) referente(s) a quantia de: "
If nCheck=1
	cMsg:="Confirma Sangria das quantia(s):"+Chr(13)
Else	
	cMsg:="Confirma Entrada de Troco da quantia: "+Chr(13)
EndIf
If nDinheir<>0
	cMsg+="R$ "+Transform(nDinheir,PesqPict("SL1","L1_DINHEIR",_PICTURE,nMoedaCorr))+Chr(13)
EndIf
If nCheques<>0
	cMsg+="CH "+Transform(nCheques,PesqPict("SL1","L1_DINHEIR",_PICTURE,nMoedaCorr))
EndIf

If !MsgYesNo(cMsg)
	Return (.F.)
EndIf

aNumerarios := {{cSimb,nDinheir},;
				{"CH",nCheques},;
				{"CC",nCartao},;
				{"CD",nVlrDebi},;
				{"FI",nFinanc},;
				{"CO",nConveni},;
				{"VA",nVales},;
				{"OU",nOutros}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao o comprovante de Sangria/Reforco                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCupom:=U_I999PegDoc(1) //Pega o numero do Documento e incrementa 1
For nNum := 1 to If(nCheck==1,Len(aNumerarios),1)
	If !aNumerarios[nNum,2] == 0
		cMoeda:=If(nCheck=1, aNumerarios[nNum,1], "TC")			
		U_IA011GrvSE5(cCodOrigem,cNatureza,cHistor,cMoeda,"P",aNumerarios[nNum,2],cCupom)
		U_IA011GrvSE5(cCodDestin,cNatureza,cHistor,cMoeda,"R",aNumerarios[nNum,2],cCupom)
	EndIf
Next nNum
lRet:=IA009Imp(nCheck,cCodOrigem,cCodDestin,nDinheir,nCheques,cCupom)

Return(lRet)

//Documentar
Static Function IA009Imp(nCheck,cCodOrigem,cCodDestin,nDinheir,nCheques,cCupom)
Local aSemana	:={"Domingo", "Segunda", "Terca","Quarta","Quinta"  , "Sexta", "Sabado"} 	//Descricoes do dia da semana
Local cSemana	:=aSemana[Dow(dDataBase)]													//Identifica qual o dia da semana
Local cCaixa	:=xNumCaixa()																//Codigo do caixa
Local nI		:=0
Local nX		:=0
Local cPath 	:= "\FECHAMENTO\"+Alltrim(SM0->M0_FILIAL)+"\"		// Caminho para 
Local cFile		:=Alltrim(SM0->M0_FILIAL)+"_"+cCaixa+"_"+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+".TXT"
Local nHdl		:=-1
Local cString	:=""
Local nReg		:=0
Local lRet		:=.F.
Local aCupom	:= {}
Private aString	:={}																		// Array com as linhas do layout do cupom

aadd(aString,{"A1","========================================= "+cCupom	,{}})
If nCheck=1
	aadd(aString,{"A2","...........Sangria de caixa................v.2.0"	,{}})
Else
	aadd(aString,{"A2","...............Entrada de Troco............v.2.0"	,{}})
EndIf
aadd(aString,{"A3","Loja...........:AAA BBB                         "	,{SM0->M0_CODFIL+" ",SM0->M0_FILIAL},{}})
aadd(aString,{"A4","Data AAA       :BBB            Hora....:CCC     "	,{cSemana,dToc(dDataBase),Time()},{}})
aadd(aString,{"A5","Caixa..........:AAA                             "	,{cCaixa+"-"+cUserName},{}})
aadd(aString,{"A6","================================================"	,{}})
aadd(aString,{"A7","-----------------[Numerarios]-------------------"	,{}})
aadd(aString,{"  ","                                                "  ,{}})
If nDinheir<>0
	nReg++
	aadd(aString,{"  ","Dinheiro...................:AAA                 "	,{nDinheir},{"@E 999,999.99"}}) 
EndIf
If nCheques<>0
	nReg++
	aadd(aString,{"  ","Cheques....................:AAA                 "	,{nCheques},{"@E 999,999.99"}}) 
EndIf
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","        -----------------------------           "  ,{}})
aadd(aString,{"  ","                 Assinatura                     "	,{}})
If nCheck=1
	aadd(aString,{"  ","                  Superior                      "	,{}})
Else
	aadd(aString,{"  ","                    Caixa                       "	,{}})
EndIf
For nI:=1 to Len(aString)
	cLinha:=aString[nI,2]
	If Len(aString[nI,3])>0
		For nX:=1 to Len(aString[nI,3])
		    cInfo:=aString[nI,3,nX]
	     	If Len(aString[nI,4])>0
		        cInfo:=Transform(cInfo,aString[nI,4,nX])
		    EndIf    
			cPesq:=Repli(chr(64+nX),3) //"AAA..BBB...CCC....DDDD...
            cLinha:=Stuff(cLinha,At(cPesq,cLinha),Len(cInfo),cInfo)
		Next nX
	EndIf	
	aadd(aCupom,cLinha)
	cString+=cLinha+Chr(13)+Chr(10)
Next nI

CursorWait()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Comunta Impressora Fiscal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//U_F1299Inno("F")  
nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
If (nRet == 0 .OR. nRet == 7)
	If (nRet := IFRelGer(nHdlECF, cString))=0 
		lRet:=.T.
	EndIf
EndIf
If nCheck=1
	//Duplicado - impressao para acompanhar o dinheiro sangrado
	nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
	If (nRet == 0 .OR. nRet == 7)
		If (nRet := IFRelGer(nHdlECF, cString))=0 
			lRet:=.T.
		EndIf
	EndIf
EndIf
CursorArrow()

Return lRet
