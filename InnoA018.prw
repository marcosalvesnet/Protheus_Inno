#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un嘺o	 矷017F1293 � Autor � Marcos Alves          � Data �28/05/2020潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri嘺o � Funcao F12-92, Relatorio de Delivery                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Doceira Innocencio   								  	  潮�
北媚哪哪哪哪呐哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北矨nalista  � Data   � Bops 矼anutencao Efetuada                         潮�
北媚哪哪哪哪呐哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北滥哪哪哪哪牧哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function IA018F1292(nHdlECF,nCheck)             
Local lRet	:=.F.
IA018Imp()
RETURN NIL
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un嘺o	 矲1293Imp  � Autor � Marcos Alves          � Data �12/10/2017潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escricao � Impressoa do Relatorio de Delivery                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � F1292Inno                                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪履哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北矰ata      | Analista | Descricao                                       |北
北媚哪哪哪哪呐哪哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�          |          |                                                 |北 
北滥哪哪哪哪牧哪哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Processamento das Vendas (SL1)  							 �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
SL1->(dbSeek(xFilial("SL1")+dToS(dDataInno)))
//ProcRegua(SL1->(Reccount()))
While !SL1->(Eof()).And. SL1->L1_FILIAL+dToS(SL1->L1_EMISSAO)==xFilial()+dToS(dDataInno)
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Filtra o caixa ativo, caso nao for geral										 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
    If (!Empty(cCaixa).And.Alltrim(SL1->L1_OPERADO)<>cCaixa) 
		SL1->(dbSkip())
		Loop
    EndIf
	If SL1->L1_SITUA=="99"			//Exluido por reimpress鉶		 
		SL1->(dbSkip())
		Loop
	Else 												//Avaliar L1_SITUA="03" - Quando ocorre. 
		If SL1->L1_SITUA=="03"							//Exluido por reimpress鉶		 
			SL1->(dbSkip())
			Loop
		End
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Processamento dos itens										 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Contabilizacao de vendas delivery
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
U_IA999MsgWait(cString,"Impress鉶 de comprovante", 10000)
//U_IA999MsgWait(cString,"Impress鉶 de comprovante", 90000)

CursorWait()
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//矯omunta Impressora Fiscal                                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
//Primeira Impressao do comprovante (Via do cliente)
If (nRet == 0 .OR. nRet == 7)
	If (nRet := IFRelGer(nHdlECF, cString))=0 
		lRet:=.T.
	EndIf
EndIf
CursorArrow()

Return lRet