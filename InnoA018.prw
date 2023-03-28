#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³I017F1293 ³ Autor ³ Marcos Alves          ³ Data ³28/05/2020³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao F12-92, Relatorio de Delivery                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA018F1292(nHdlECF,nCheck)             
Local lRet	:=.F.
IA018Imp()
RETURN NIL
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³F1293Imp  ³ Autor ³ Marcos Alves          ³ Data ³12/10/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressoa do Relatorio de Delivery                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ F1292Inno                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data      | Analista | Descricao                                       |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          |          |                                                 |±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IA018Imp()
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
Local nTotal	:=0
Local aDelivery :={}
Local nVlrDiaria	:= Val(SupergetMV("MV_INNOTX", ,"0"))
Private aString	:={}																		// Array com as linhas do layout do cupom

aadd(aString,{"A1","================================================",{}})
aadd(aString,{"A2",".............Relatorio de Delivery..............",{}})
aadd(aString,{"A3","Loja...........:AAA BBB                         "	,{SM0->M0_CODFIL+" ",SM0->M0_FILIAL},{}})
aadd(aString,{"A4","Data AAA       :BBB            Hora....:CCC     "	,{cSemana,dToc(dDataBase),Time()},{}})
aadd(aString,{"A5","Caixa..........:AAA                             "	,{cCaixa+"-"+cUserName},{}})
aadd(aString,{"A6","================================================"	,{}})
//aadd(aString,{"A7","Seq Numero Hora  Entregador    Valor      Taxa  "	,{}})
aadd(aString,{"A7","Seq Pedido Hora  Entregador    Valor      Taxa  "	,{}})
aadd(aString,{"A8","--- ------ ----- ----------- ----------- -------"   ,{}})

dDataInno:=dDataBase
//dDataInno:=ctod("28/05/20")

SL2->(dbSetOrder(1))
SL1->(dbSetOrder(7))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento das Vendas (SL1)  							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SL1->(dbSeek(xFilial("SL1")+dToS(dDataInno)))
//ProcRegua(SL1->(Reccount()))
While !SL1->(Eof()).And. SL1->L1_FILIAL+dToS(SL1->L1_EMISSAO)==xFilial()+dToS(dDataInno)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If (!Empty(cCaixa).And.Alltrim(SL1->L1_OPERADO)<>cCaixa) 
		SL1->(dbSkip())
		Loop
    EndIf
	If SL1->L1_SITUA=="99"			//Exluido por reimpressão		 
		SL1->(dbSkip())
		Loop
	Else 												//Avaliar L1_SITUA="03" - Quando ocorre. 
		If SL1->L1_SITUA=="03"							//Exluido por reimpressão		 
			SL1->(dbSkip())
			Loop
		End
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento dos itens										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SL2->(dbSetOrder(1))
	SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
	While !SL2->(Eof()).And. SL2->L2_FILIAL+SL1->L1_NUM==xFilial("SL2")+SL2->L2_NUM
		If SL1->L1_SITUA<>"07".AND.SL2->(Deleted())					//Itens da venda Cancelados
			SL2->(dbSkip())
			Loop
		EndIf    
	    If SL2->(Deleted()) 								//processar cupons Cancelados)
			SL2->(dbSkip())
			Loop
	    EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabilizacao de vendas delivery
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Alltrim(SL2->L2_PRODUTO)=="00198"
			If SL2->L2_TABELA="1"
				aadd(aDelivery,{Subs(SL1->L1_NROPCLI,1,6), subs(SL1->L1_HORA,1,5),"INNOCENCIO",SL1->L1_VLRTOT, SL2->L2_VLRITEM})
			else
				//aadd(aDelivery,{SL1->L1_NUM, subs(SL1->L1_HORA,1,5),"IFOOD"     ,SL1->L1_VLRTOT, SL2->L2_VLRITEM})
			ENDIF
		ENDIF
		SL2->(dbSkip())
	End
	SL1->(dbSkip())
End
IncProc() 		//Processou o SL1

aDelivery 	:= aSort(aDelivery,,,{|x,y| x[3]+x[1] < y[3]+Y[1] })
nTotVenda	:=0
nTotEntrega	:=0
For nI:=1 to Len(aDelivery)
	aadd(aString,{" ","AAA BBB    CCC   DDD         EEE         FFF    "   ,{Str(nI,3), aDelivery[nI,1],aDelivery[nI,2],aDelivery[nI,3],aDelivery[nI,4],aDelivery[nI,5]},{"@E 999","@!","@!","@!","@E 9999,999.99","@E 9999.99"}})
	nTotVenda	+=aDelivery[nI,4]
	nTotEntrega	+=aDelivery[nI,5]
Next nI	
aadd(aString,{"  ","                             ----------- -------"   ,{}})
aadd(aString,{"  ","                             AAA         BBB    "  ,{nTotVenda, nTotEntrega},{"@E 9999,999.99","@E 9999.99"}})

aadd(aString,{"  ","                                         -------"   ,{}})
aadd(aString,{"  ","Valor Diaria...........................: AAA     "   ,{nVlrDiaria},{"@E 9999.99"}})
aadd(aString,{"  ","                                         -------"   ,{}})
aadd(aString,{"  ","Total a pagar..........................: AAA    "  ,{nTotEntrega+nVlrDiaria},{"@E 9999.99"}})

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
//U_IA999MsgWait(cString,"Impressão de comprovante", 90000)

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
CursorArrow()

Return lRet