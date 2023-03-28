#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

#define _PICTURE 13
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³I017F1293 ³ Autor ³ Marcos Alves          ³ Data ³ 04/0217  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao F12-93, Efetua Sinal da encomenda no Front Loja     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA017F1293(nHdlECF,nCheck)             
Local lRet	:=.F.
Local oPedido
Local oTalao
Local oCodAtend 
Local oRetira
Local oSinal 

Local oBtnAct
Local oBtnEnd
Local oBtnExc
Local oBtnInc
Local cTitulo:="Sinal de Encomenda"

Local oLbx
Local oGroup1
Local oGroup2
Local oFnt1
Local oTotal

Local aPgtos		:={}
Local oPgtos
 
Private	lEdit		:=.T.
Private oDlgSinal
Private cSeq 		:="001"
Private cTalao 		:=Space(3)
Private cPedido 	:=space(3)
Private cCodAtend 	:=Space(6)
Private cNomAtend 	:=Space(25)
Private aVetor		:={}
Private dRetira 	:=ctod("//")
Private nTotal		:=0

Private nVlrSinal	:=0
Private nVlrPagar	:=0
Private aFormPag	:={}
Private lFlagInc	:=.F.

DEFINE MSDIALOG ODlgSinal FROM 1,1 TO 355,380 TITLE cTitulo PIXEL OF GetWndDefault()

DEFINE FONT oFnt1 NAME "Courier New"     	SIZE 8,16 BOLD      

@ 001,005 GROUP oGroup1 TO 065,185 LABEL " Dados da Encomenda " COLOR CLR_HBLUE OF ODlgSinal PIXEL

@ 015,014 SAY "Talão" SIZE 30,10 OF ODlgSinal PIXEL
@ 012,050 MSGET oTalao 		VAR cTalao 	Picture "999"  	VALID IA017Vld("TALAO") 	SIZE 30,10 OF ODlgSinal PIXEL //RIGHT

@ 015,118 SAY "Pedido" SIZE 30,10 OF ODlgSinal PIXEL
@ 012,146 MSGET oPedido 	VAR cPedido Picture "999" 	VALID IA017Vld("PEDIDO",oPgtos,@aPgtos,oBtnExc,oBtnAct,oBtnInc)	SIZE 30,10 OF ODlgSinal PIXEL //LEFT

@ 033,014 SAY "Sinal" SIZE 30,10 OF ODlgSinal PIXEL
@ 030,050 MSGET oSinal VAR nVlrSinal Picture "@E 9,999.99" WHEN lEdit VALID IA017Vld("SINAL")  SIZE 30,10 OF ODlgSinal PIXEL RIGHT

@ 033,118 SAY "Retirada" SIZE 30,10 OF ODlgSinal PIXEL
@ 030,146 MSGET oRetira VAR dRetira Picture "99/99/99" WHEN lEdit VALID IA017Vld("RETIRADA") SIZE 30,10 OF ODlgSinal PIXEL //LEFT

@ 050,016 SAY "Atendente" SIZE 30,10 OF ODlgSinal PIXEL
@ 048,050 MSGET oCodAtend VAR cCodAtend PICTURE "@!" WHEN lEdit VALID IA017Vld("ATENDENTE") F3 "SA3" PIXEL OF ODlgSinal
@ 048,090 MSGET oNomAtend	VAR cNomAtend		SIZE 92,7 PICTURE "@!" WHEN .F. PIXEL OF ODlgSinal

@ 070,005 GROUP oGroup2 TO 150,185 LABEL " Formas de pagamento " COLOR CLR_HBLUE OF ODlgSinal PIXEL

oPgtos:=TCBrowse():New(80,010, 170, 60,,,,,,,,,,,,,,,, .F.,, .T.,, .F., )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do array aPgtos                                    ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ [1] - Forma de Pagamento                                     ³
//³ [2] - Qtde de Parcelas da forma de pagto                     ³
//³ [3] - Valor total desta forma de pagamento                   ³
//| [4] - Sequencia para controle de múltiplas transaçõies		 |
//³ [5] - Data da primeira parcela                               ³	
//³ [6] - Codigo da Administradora financeira                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPgtos:SetArray(aPgtos)
oPgtos:AddColumn(TCColumn():New("  Forma  "		, {|| If(Len(aPgtos)>=oPgtos:nAt,aPgtos[oPgtos:nAt,3],'')}                          	,,,, "LEFT" , 20, .F., .F.,,,, .F., ) )  //"Forma"
oPgtos:AddColumn(TCColumn():New("  Valor  "		, {|| If(Len(aPgtos)>=oPgtos:nAt,Transform(aPgtos[oPgtos:nAt,2],"@E 9,999.99"),'')} 	,,,, "RIGHT", 40, .F., .F.,,,, .F., ) )  //"Valor"
oPgtos:AddColumn(TCColumn():New("  Doc "		, {|| If(Len(aPgtos)>=oPgtos:nAt,aPgtos[oPgtos:nAt,6],'')}                        	,,,, "RIGHT", 25 , .F., .F.,,,, .F., ) )  //"Parcelas"
oPgtos:AddColumn(TCColumn():New("  Autoriz."	, {|| If(Len(aPgtos)>=oPgtos:nAt,aPgtos[oPgtos:nAt,7],'')}                          	,,,, "LEFT" , 25, .F., .F.,,,, .F., ) )  //"Data"

oPgtos:bLDblClick := {|| .t.}

// Evita erro ao pressionar a tecla <Enter> e o array aPgtos estiver com conteúdo nulo...
If Empty(aPgtos) .Or.!lEdit
	oPgtos:Disable()
Else
	oPgtos:SetFocus()
EndIf
SetKey(VK_F9, {|| lRet:=IA017Fim()})		//Subtotal e formas de pagamentos

@ 155,12 SAY "Falta Pgto." FONT oFnt1 PIXEL OF ODlgSinal SIZE 150,18 COLOR CLR_HRED,CLR_BLACK //FONT oFntCx
@ 155,80 SAY oTotal VAR Transform(nTotal,"@E 9,999.99") FONT oFnt1 PIXEL OF ODlgSinal SIZE 150,18 COLOR  CLR_HRED,CLR_BLACK

DEFINE SBUTTON oBtnInc FROM 165,067 TYPE 4   	ENABLE ACTION (IA017Inclui(oSinal,oPgtos,@aPgtos,oBtnExc,oBtnAct,oBtnInc))		OF ODlgSinal	
DEFINE SBUTTON oBtnExc FROM 165,097 TYPE 3   	ENABLE ACTION (IA017Exclui(),ODlgSinal:End())					OF ODlgSinal	
DEFINE SBUTTON oBtnAct FROM 165,127 TYPE 1 		ENABLE ACTION If( lRet:=IA017Vld("OK"),ODlgSinal:End(),NIL) 	OF ODlgSinal	
DEFINE SBUTTON oBtnEnd FROM 165,157 TYPE 2 		ENABLE ACTION (lRet:=.F.,ODlgSinal:End()) 						OF ODlgSinal	

ACTIVATE MSDIALOG ODlgSinal CENTER ON INIT ( IA017SetKey(oPgtos,@aPgtos), oBtnInc:Disable(),If(lEdit,oBtnExc:Disable(),oBtnExc:Enable())) 

If lRet
	If lGaveta
		If (!Empty(LJGetStation("PORTGAV"))) .And. (LJGetStation("PORTIF") <> LJGetStation("PORTGAV"))
			GavetaAci(nHdlGaveta, LJGetStation("PORTGAV"))
		Else
			IFGaveta(nHdlECF)
		EndIf
	EndIf
	//Grava dados do SINAL 
	IA017Grv(aPgtos) 
	IA017Imp()
EndIf

RETURN NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IA017Vld          ³Autor  ³Marcos Alves   º Data ³Out/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida os campos da tela do SINA                            º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA017Vld(cVld,oPgtos,aPgtos,oBtnExc,oBtnAct,oBtnInc) 

Local lRet		:=.T.
Local cMsg		:=""
Local cNumSZT 	:=""
Local cBaixaSZT	:=""

SA3->(dbSetOrder(1))
SZT->(dbSetOrder(1))
SZS->(dbSetOrder(1))

If cVld=="TALAO"
	If Empty(cTalao) .or. Val(cTalao)<=0
		cMsg:="Numero do Talao invalido!!"
	ElseIf Len(AllTrim(cTalao))<>3
		cMsg:="Numero do Talao deve conter 3 digitos"
	EndIf
ElseIf cVld=="PEDIDO"
	If Empty(cPedido).or. Val(cPedido)<=0
		cMsg:="Numero do Pedido invalido!!"
	ElseIf Len(AllTrim(cPedido))<>3
		cMsg:="Numero do Pedido deve conter 3 digitos"
	Else
		If SZT->(dbSeek(xFilial("SZT")+cTalao+cPedido))
			dRetira		:= SZT->ZT_ENTREGA
			cCodAtend	:= SZT->ZT_ATENDE
			While !SZT->(Eof()).AND. (xFilial("SZT")+cTalao+cPedido==SZT->ZT_FILIAL+SZT->ZT_TALAO+SZT->ZT_PEDIDO)
				nVlrSinal	+= SZT->ZT_SINAL
				cSeq		:= SZT->ZT_SEQ
				cNumSZT		:= If(Empty(cNumSZT),SZT->ZT_NUM,cNumSZT)
				cBaixaSZT	:= dToc(SZT->ZT_BAIXA) 
				SZT->(dbSkip())
			End
			cNomAtend	:= Posicione("SA3",1,xFilial("SA3")+cCodAtend,"A3_NOME")
			aPgtos:={}
			SZS->(dbSeek(xFilial("SZS")+cTalao+cPedido))        
			While !SZS->(Eof()).and. (xFilial("SZS")+cTalao+cPedido)==(SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO)
				AAdd(aPgtos,	{SZS->ZS_DATA	,;			// 01-Data
								SZS->ZS_VALOR	,;			// 02-Valor
								AllTRim(SZS->ZS_FORMA),;	// 03-Forma
								SZS->ZS_ADMINIS	,;			// 04-Administradora
								" ",;						// 05-Num Cartao
								SZS->ZS_DOCTEF,;			// 06-Agencia
								SZS->ZS_AUTORIZ,;			// 07-Conta
								" ",;						// 08-RG
								" ",;						// 09-Telefone
								.F.,;						// 10-Terceiro
								  1,;						// 11-Moeda
								"1",;						// 12-Digitos do cartao para TEFMULT
								0 } )						// 13-Conceito de acrescimo financeiro separado
				SZS->(dbSkip())
			End
			lEdit	:=.F.
			If Empty(cNumSZT)
				oBtnExc:Enable()
				oBtnInc:Enable()
			Else
				cMsg:="Pedido Entregue em: "+cBaixaSZT
			EndIf				
			oBtnAct:Disable()
		Else
			nVlrSinal	:= SZT->ZT_SINAL
			dRetira		:= SZT->ZT_ENTREGA
			cCodAtend	:= SZT->ZT_ATENDE
			cNomAtend	:= Posicione("SA3",1,xFilial("SA3")+cCodAtend,"A3_NOME")
			aPgtos:={}
			lEdit	:=.T.
			oBtnExc:Disable()
			oBtnAct:Enable()
		EndIf	
		oPgtos:SetArray(aPgtos)
		oPgtos:Refresh()			
		oDlgSinal:Refresh()			
	EndIf
ElseIf cVld=="RETIRADA"
	If Empty(dRetira) .or. dRetira<dDatabase
		cMsg:="Data invalida!!"
	EndIf
ElseIf cVld=="SINAL"
	If nVlrSinal<=0
		cMsg:="Valor invalido!!"
	Else
		nVlrPagar:=nVlrSinal
	EndIf	
ElseIf cVld=="OK"
	If nVlrPagar<>0
		cMsg:="Falta definir formas de pagamento!!"
	EndIf	
ElseIf cVld=="ATENDENTE"
	If Empty(cCodAtend).or.!SA3->(dbSeek(xFilial("SA3")+cCodAtend))
		cMsg:="Atendente NAO encontrado!!"
	Else	
		cNomAtend:=SA3->A3_NOME
	EndIf	
EndIf
If !Empty(cMsg)
	MsgInfo(cMsg)
	lRet:=.F.
EndIf	

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I017SetKey       ³Autor  ³Marcos Alves   º Data ³Out/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Habilita/desabilita teclas de funcao das formas de pagamentoº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA017SetKey(oPgtos,aPgtos,lEnable)
Local lRet		:=.T.
Local nPosSimb 	:= 0
Local bKey 		:= NIL
Local aSetKey	:= {}

Default lEnable :=.T.

aFormPag	:= IA017FormPag() ///Estrutura de formas de pagamentos, substituindo MonFormPag     

//Dinheiro   - CTRL + A
nPosSimb 	:= Ascan( aFormPag,{|x| Trim(x[2]) == "R$"})
bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nPosSimb][2]+"', '"+aFormPag[nPosSimb][1]+"'), IA017Tot(oPgtos,@aPgtos)}"),{|| })
SetKey(1,    bKey)// CTRL+A - Dinheiro

//Demais Formas -    - CTRL + C..D...E...F
For nI := 1 To Len(aFormPag)-2
	If (nPos:=At("CARTAO CREDITO",Alltrim(aFormPag[nI][5])))<>0
		bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"'), IA017Tot(oPgtos,@aPgtos)}"),{|| })
		SetKey(3,    bKey)// CTRL + C
	ElseIf (nPos:=At("CARTAO DEBITO",Alltrim(aFormPag[nI][5])))<>0
		bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"'), IA017Tot(oPgtos,@aPgtos)}"),{|| })
		SetKey(4,    bKey)// CTRL + D
	ElseIf (nPos:=At("VOUCHER",Alltrim(aFormPag[nI][5])))<>0
		bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"'), IA017Tot(oPgtos,@aPgtos)}"),{|| })
		SetKey(22,    bKey)// CTRL + V
	ElseIf (nPos:=At("PIX",Alltrim(aFormPag[nI][5])))<>0
		bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"'), IA017Tot(oPgtos,@aPgtos)}"),{|| })
		SetKey(16,    bKey)// CTRL + V
	EndIf
Next nI

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I223FormPag      ³Autor  ³Marcos Alves   º Data ³Out/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta array com as formas de pagamento cadastradas na       º±±
±±º          ³tabela 24.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA017FormPag()
Local aItens := {} 

DbSelectArea("SAE")
DbSeek(xFilial())
While !Eof() .AND. xFilial("SAE") == AE_FILIAL
	SX5->(DbSeek(xFilial("SX5")+"24"+SAE->AE_TIPO))
	aAdd(aItens, {Alltrim(AE_DESC),AE_TIPO,Alltrim(X5Descri()),AE_GRPFRT,SAE->AE_COD + " - " + SAE->AE_DESC})
	DbSkip()
End
DbSelectArea( "SX5" )
If DbSeek(xFilial()+"24CH")
	AAdd(aItens, {AllTrim(X5Descri()), "CH", AllTrim(X5Descri()),"   " })
Endif
If DbSeek(xFilial()+"24"+SuperGetMV("MV_SIMB1"))
	AAdd(aItens, {AllTrim(X5Descri()), SuperGetMV("MV_SIMB1"), AllTrim(X5Descri()),"   " })
Endif

Return(aItens)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I017Tot          ³Autor  ³Marcos Alves   º Data ³14/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Apresenta o valor total para a forma de pagamento			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA017Tot(oPgtos,aPgtos)
Local lRet	:=.T.
nTotal:=0

AEval(aPgtos,{|X| nTotal+=X[2]})
nTotal:=nVlrSinal-nTotal

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IA017Exclui       ³Autor  ³Marcos Alves   º Data ³14/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Excluir registros do sinal 								  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA017Exclui()
Local lRet	:=.T.
Local cMsg	:="Sinal do Pedido:"+SZT->ZT_PEDIDO+" excluido com sucesso"
If MsgNoYes("Confirma EXCLUSÃO do sinal de encomenda?")
	If !IA017PswSup()
		MsgStop("Usuario sem permissao para realizar Esta operacao")
		Return(NIL)
	EndIf
	SZS->(dbSetOrder(1))
	SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))        
	While !SZS->(Eof()).and. (xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO)==(SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO)
		SZS->(RecLock("SZS", .F.))
		SZS->(dbDelete())
		SZS->(MsUnlock())
		SZS->(dbSkip())
	End
	SZT->(RecLock("SZT",.F.))
	SZT->(dbDelete())
	SZT->(MsUnlock())
	MsgStop(cMsg)
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IA017Grv()			Autor  ³Marcos Alves   º Data ³14/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava registro nas tabelas SZT e SZS                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA017Grv(aPgtos)
Local lRet		:=.T.
Local cCaixa	:=xNumCaixa()																//Codigo do caixa

SZT->(dbSetOrder(1))
SZS->(dbSetOrder(1))

If SZT->(dbSeek(xFilial("SZT")+cTalao+cPedido))
	While xFilial("SZT")+cTalao+cPedido==SZT->ZT_FILIAL+SZT->ZT_TALAO+SZT->ZT_PEDIDO
		If cSeq==SZT->ZT_SEQ
			Return lRet
        EndIf
		SZT->(dbSkip())
	End
  //.AND.!lFlagInc 		
EndIf	
SZT->(RecLock("SZT",.T.))
SZT->ZT_FILIAL	:= xFilial("SZT")
SZT->ZT_SEQ		:= cSeq
SZT->ZT_TALAO	:= cTalao
SZT->ZT_PEDIDO	:= cPedido
SZT->ZT_DATA	:= dDataBase
SZT->ZT_HORA	:= Time()
SZT->ZT_SINAL	:= nVlrSinal
SZT->ZT_ENTREGA	:= dRetira
SZT->ZT_ATENDE	:= cCodAtend
SZT->ZT_CAIXA	:= cCaixa
SZT->ZT_SITUA	:= "00"
SZT->(MsUnLock())  
For nI:=1 to Len(aPgtos)
	SZS->(RecLock("SZS",.T.))
	SZS->ZS_FILIAL	:= xFilial("SZS")
	SZS->ZS_SEQ		:= cSeq
	SZS->ZS_TALAO	:= cTalao
	SZS->ZS_PEDIDO	:= cPedido
	SZS->ZS_DATA	:= aPgtos[nI,1]
	SZS->ZS_FORMA	:= aPgtos[nI,3]
	SZS->ZS_ADMINIS	:= aPgtos[nI,4]
	SZS->ZS_VALOR	:= aPgtos[nI,2]
	SZS->ZS_SITUA	:= "00"
	SZS->(MsUnLock())  
	If aPgtos[nI,3]=="R$"
		U_IA011GrvSE5(cCaixa,"RECEBIMENT","SINAL ENCOMENDA:"+cTalao+"/"+cPedido,"01","R",aPgtos[nI,2],cTalao+cPedido)
	EndIf
Next nI

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³F1293Imp  ³ Autor ³ Marcos Alves          ³ Data ³12/10/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressoa do comprovante de sinal da encomanda             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ F1293Inno                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data      | Analista | Descricao                                       |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          |          |                                                 |±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA017Imp()
Local aSemana	:={"Domingo", "Segunda", "Terca","Quarta","Quinta"  , "Sexta", "Sabado"} 	//Descricoes do dia da semana
Local cSemana	:=aSemana[Dow(dDataBase)]													//Identifica qual o dia da semana
Local cCaixa	:=xNumCaixa()																//Codigo do caixa
Local nI		:=0
Local nX		:=0
Local cPath 	:= "\FECHAMENTO\"+Alltrim(SM0->M0_FILIAL)+"\"		// Caminho para 
Local cFile		:=Alltrim(SM0->M0_FILIAL)+"_"+cCaixa+"_"+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+".TXT"
Local nHdl		:=-1
Local cString	:=""
Local cCupom	:=U_I999PegDoc(1) //Pega o numero do Documento e incrementa 1
Local nReg		:=0
Local lRet		:=.F.
Local aCupom	:= {}
Local nTotal	:=0
Private aString	:={}																		// Array com as linhas do layout do cupom

aadd(aString,{"A1","========================================= "+cCupom	,{}})
aadd(aString,{"A2","...............Sinal da encomenda...........:"+cSeq	,{}})
aadd(aString,{"A3","Loja...........:AAA BBB                         "	,{SM0->M0_CODFIL+" ",SM0->M0_FILIAL},{}})
aadd(aString,{"A4","Data AAA       :BBB            Hora....:CCC     "	,{cSemana,dToc(dDataBase),Time()},{}})
aadd(aString,{"A5","Caixa..........:AAA                             "	,{cCaixa+"-"+cUserName},{}})
aadd(aString,{"A6","================================================"	,{}})
aadd(aString,{"A7","------------------[Via da Loja]-----------------"	,{}})
aadd(aString,{"  ","Talao:..:AAA                   Pedido..:     BBB"	,{SZT->ZT_TALAO,SZT->ZT_PEDIDO},{"@!","@!"}}) 
aadd(aString,{"  ","Sinal...:AAA           Data Retirada.:BBB       "	,{SZT->ZT_SINAL,SZT->ZT_ENTREGA },{"@E 999,999.99","99/99/00"}}) 
aadd(aString,{"A8","--------------[Forma de pagamento]--------------"	,{}})
cForma:=""
nTotal:=0

SZS->(dbSetOrder(1))
SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))        
While !SZS->(Eof()).and. (xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO)==(SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO)
	If SZS->ZS_SEQ==cSeq 
		nTotal+=SZS->ZS_VALOR
		If Alltrim(SZS->ZS_FORMA)=="R$"
			cForma	:="000 - DINHEIRO"
		Else
			cForma	:=SZS->ZS_ADMINIS
		EndIf		
		cForma:=Subs(Alltrim(cForma)+Repli(".",36),1,36)+": AAA"
		aadd(aString,{"  ",cForma	,{SZS->ZS_VALOR},{"@E 999,999.99"}}) 
	EndIf	
	SZS->(dbSkip())
End
cAtende:=Subs(Alltrim(SZT->ZT_ATENDE)+"-"+Posicione("SA3",1,xFilial("SA3")+SZT->ZT_ATENDE,"A3_NOME"),1,32)
aadd(aString,{"  ","....................................: ----------"	,{}})
aadd(aString,{"  ","Sinal da encomenda..................: AAA        "	,{nTotal},{"@E 999,999.99"}}) 
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","Este  documento  refere-se ao pagamento de SINAL"  ,{}})
aadd(aString,{"  ","do pedido de encomenda, supra citado.           "  ,{}})
aadd(aString,{"  ","Necessario apresentção na retirada dos produtos."  ,{}})
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","Atendente,                                      "  ,{}})
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","       --------------------------------         "  ,{}})
aadd(aString,{"  ","       AAA                                      "  ,{cAtende},{"@!"}})
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
U_IA999MsgWait(cString,"Impressão de comprovante", 10000)

CursorWait()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Comunta Impressora Fiscal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
//Primeira Impressao do comprovante (Via do cliente)
If (nRet == 0 .OR. nRet == 7)
	If (nRet := IFRelGer(nHdlECF, cString))=0 
		lRet:=.T.
	EndIf
EndIf
//Segunda Impressao do comprovante (Via do Cliente)
cString:=Stuff(cString,At("--[Via da Loja]-",cString),Len("--[Via da Loja]-"),"[Via do cliente]")
nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
If (nRet == 0 .OR. nRet == 7)
	If (nRet := IFRelGer(nHdlECF, cString))=0 
		lRet:=.T.
	EndIf
EndIf
CursorArrow()

Return lRet


//Solicita a senha Master
Static Function IA017PswSup()

Local oGetSup										// Objeto Get com o nome do superior que informou a senha
Local OGetSenha										// Objeto Get com a senha do superior
Local oDlgSenha										// Objeto da caixa de dialogo da senha do supervisor
Local lRet		  := .F.							// Variavel que controla o retorno
Local cSenhaSup	  := Space(6)						// Senha digitada do supervisor
Local cBitMap	  := "LOGIN"						// Bitmap utilizado na caixa de dialogo
Local cCaixaAtu	  := cUserName					    // Caixa atual
Local aArea		  := GetArea()					    // Salva a area, para ser restaurada ao final da funcao
Local aPermissao  := {}							    // Array com as permissoes
Local cTitle	  := ""							    // Titulo da janela de autorizacao do supervisor
Local lDesc 	  := .F.							// Valida se houve desconto
Local lVerProfile := .F.							// Controla se verifica profile para desconto 
Local nSA6Recno	  := SA6->( Recno() )				// Variavel com o registro do SA6
Local cFormDesc   := SuperGetMV( "MV_LJFORMD",.F.,"1" )  // Caso nao exista o parametro assume "1" como DEFAULT
Local nOpcA		  := 0 								// Botao confirmar
Local nX		  := 0								// Variavel contadora para Loop
Local cCaixaSup  := Space(25)						// Caixa superior

DEFINE DIALOG oDlgSenha TITLE cTitle FROM 20, 20 TO 225,310 PIXEL 

@ 0, 0 BITMAP oBmp1 RESNAME cBitMap oF oDlgSenha SIZE 50,140 NOBORDER WHEN .F. PIXEL

@ 05,55 SAY "Caixa Atual"	PIXEL						                   // Caixa Atual
@ 15,55 MSGET cCaixaAtu WHEN .F. PIXEL SIZE 80,08

@ 30,55 SAY "Caixa Superior" PIXEL							               // Caixa Superior
@ 40,55 MSGET oGetSup VAR cCaixaSup WHEN .F. PIXEL SIZE 80,08

@ 55,55 SAY "Senha Superior" PIXEL                                          // Senha Superior
@ 65,55 MSGET oGetSenha VAR cSenhaSup PASSWORD PIXEL SIZE 40,08 VALID IA017SenhaSup(cSenhaSup,@cCaixaSup)

DEFINE SBUTTON FROM 85,75  TYPE 1 ACTION ( If(lRet:=IA017SenhaSup(cSenhaSup,@cCaixaSup),oDlgSenha:End(),)) ENABLE OF oDlgSenha
DEFINE SBUTTON FROM 85,105 TYPE 2 ACTION { || lRet := .F., oDlgSenha:End() } ENABLE OF oDlgSenha

ACTIVATE MSDIALOG oDlgSenha CENTERED 


Return lRet

//Solicita a senha Master
Static Function IA017SenhaSup(cSenhaSup,cCaixaSup)
Local lRet	:=.F.

PswOrder(3)
PswSeek(cSenhaSup)

If !aConfig()[4]
	aReg      := PswRet()
	cCaixaSup := If(len(aReg)>0,aReg[1][2],cCaixaSup)
Endif

lRet:=Alltrim(Upper(cCaixaSup))=="MASTER"   
If !lRet
	MsgInfo("Senha Invalida!!!")
EndIf	

Return lRet


//Finaliza a tela atraves da Tecla F9
Static Function IA017Fim()
Local lRet :=If( lRet:=IA017Vld("OK"),oDlgSinal:End(),NIL)

Return lRet



Static Function IA017Inclui(oSinal,oPgtos,aPgtos,oBtnExc,oBtnAct,oBtnInc)

nVlrSinal	:= 0
cSeq		:= Soma1(cSeq)
cCodAtend	:= Space(6)
cNomAtend	:= Space(25)
aVetor		:={}
nTotal		:=0
aPgtos:={}
lEdit	 :=.T.
lFlagInc :=.T.
oPgtos:SetArray(aPgtos)
oPgtos:Refresh()			
oDlgSinal:Refresh()			

oBtnExc:Disable()
oBtnAct:Enable()
oSinal:SetFocus()

Return NIl
