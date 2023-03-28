#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³FRTGrvSZ  ³ Autor ³ Marcos Alves          ³ Data ³ 27/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Lista de arquivos para atualizacao no servidor Retaguarda  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Ponto de entreda FRTA020                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FRTGrvSZ(oServer)
Local aFiles	:={}
Local aSE2		:={}
Local aSEV		:={}
Local aSE5		:={}
Local nI
Local nRegSE2 	:=0
Local nRegSE5 	:=0
Local aDocTef	:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravar dados DOC/TEF no SL4 da retaguarda ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
dbSelectArea("SL1")
dbSetOrder(1)	

dbSelectArea("SL4")
DbOrderNickName("L4_SITUA") //L4_FILIAL + L4_SITUA
dbSeek(xFilial("SL4")+"00")
aDocTef:={}

While !SL4->(Eof()).AND.SL4->L4_FILIAL==xFilial("SL4").AND.SL4->L4_SITUA=="00".And.!KillApp()
	//ConOut( "FRTGrvSZ Inno: SL4 Ponto 1" )

	SL1->(dbSeek(xFilial("SL1")+SL4->L4_NUM))

	//Campos do SL4 a serem atualiuzados na retaguarda
	ConOut( "FRTGrvSZ Inno: SL4 Ponto 2 - SL4->L4_FILIAL:"+SL4->L4_FILIAL )
	ConOut( "FRTGrvSZ Inno: SL4 Ponto 3 - SL1->L1_NUMORIG:"+SL1->L1_NUMORIG )
	ConOut( "FRTGrvSZ Inno: SL4 Ponto 4 - SL4->L4_DOCTEF:"+SL4->L4_DOCTEF )
	ConOut( "FRTGrvSZ Inno: SL4 Ponto 5 - SL4->L4_AUTORIZ:"+SL4->L4_AUTORIZ)
	aDocTef:={SL4->L4_FILIAL+SL1->L1_NUMORIG, SL4->L4_DOCTEF,SL4->L4_AUTORIZ,SL4->L4_FORMAID,SL1->L1_DOC, SL1->L1_SERIE,SL4->L4_INSTITU}

	lRet := oServer:CallProc("U_IA010GrvSL4", aDocTef)

    If lRet 
		SL4->(Reclock("SL4",.F.))
		SL4->L4_SITUA	:= "OK"
		SL4->( dbCommit() )
		SL4->( MsUnlock() )
		ConOut( "FRTGrvSZ Inno: SL4 - DOCTEF - OK" )
    Else
		SL4->(Reclock("SL4",.F.))
		SL4->L4_SITUA	:= "ER"
		SL4->( dbCommit() )
		SL4->( MsUnlock() )
		ConOut( "FRTGrvSZ Inno: SL4 - DOCTEF - ERRO" )
    EndIf
	SL4->(dbSkip())
End	

Return {}

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza SL4 na retaguarda								  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IA010GrvSL4(aDocTef) //	aDocTef:={SL4->L4_FILIAL+SL1->L1_NUMORIG, SL4->L4_DOCTEF,SL4->L4_AUTORIZ,SL4->L4_FORMAID,SL1->L1_DOC, SL1->L1_SERIE}
Local lRet	:=.T.		
ConOut( "FRTGrvSZ Inno: Gravando DOCTEF na retaguarda Ponto 1" )

SL4->(dbSetOrder(1))   //L4_FILIAL+L4_NUM+L4_ORIGEM
If !(lSeekSL4:=SL4->(dbSeek(aDocTef[1])))
	ConOut( "FRTGrvSZ Inno: Gravando DOCTEF na retaguarda Ponto 2 - SL4- Nao encontrado" )
	lRet:=.F.
Else
	SE1->(dbSetOrder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO  	)
	If !(lSeekSE1:=SE1->(dbSeek(xFilial("SE1")+aDocTef[6]+aDocTef[5]))) 
		ConOut( "FRTGrvSZ Inno: Gravando DOCTEF na retaguarda Ponto 3 - SE1- Nao encontrado" )
		lRet:=.F.
	EndIf
EndIf	
If !lRet
	Return lRet
EndIf
//------------SL4-----------------------------
lRet:=.F.
While !SL4->(Eof()).And. aDocTef[1]==SL4->L4_FILIAL+SL4->L4_NUM
	If Alltrim(SL4->L4_FORMAID)==Alltrim(aDocTef[4]) //SL4->L4_FORMAID - Frente caixa
		SL4->(Reclock("SL4",.F.))
		SL4->L4_DOCTEF	:= aDocTef[2]
		SL4->L4_AUTORIZ	:= aDocTef[3]
		SL4->L4_DATATEF	:= DTOS(SL4->L4_DATA) // ATUALIZA INDICE PARA SER UTILIZADO NA CONSILIACAO DE CARTOES
		SL4->L4_INSTITU	:= aDocTef[7]
		SL4->L4_SITUA	:= "TX"
		SL4->( dbCommit() )
		SL4->( MsUnlock() )
		ConOut( "FRTGrvSZ Inno: Gravando DOCTEF na retaguarda Ponto 4" )
		lRet:=.T.
		Exit
	EndIf
	SL4->(dbSkip())	
End
//--------SE1---------------------------------
If lRet
	cParcela:=CHR(64+Val(SL4->L4_FORMAID))
	cTipo	:=Subs(SL4->L4_FORMA,1,TAMSX3("E1_TIPO")[1])
	If SE1->(dbSeek(xFilial("SE1")+aDocTef[6]+aDocTef[5]+cParcela+cTipo)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO  	)
		ConOut( "FRTGrvSZ Inno: Gravando DOCTEF na retaguarda Ponto 5" )
		SE1->(Reclock("SE1",.F.))
		SE1->E1_DOCTEF	:=aDocTef[2]
		SE1->E1_NSUTEF	:=aDocTef[3]
		SE1->( dbCommit() )
		SE1->( MsUnlock() )
	EndIf
EndIf
ConOut( "FRTGrvSZ Inno: Gravando DOCTEF na retaguarda Ponto 6" )
Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 12/03/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³	Grava despesas na retaguarda - funcao chamada pela  														  ³±±
±±³          ³ frente de loja e executada via RPC na retaguarda                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function I010GrvDesp(aGrvSe2, aColsAux,aHeaderAux,aBaixa)
Local aDados	:= {}
Local aSE2		:= {}
Local aSEV		:= {}
Local aSE5		:= {}
Local nRet		:= 0
Local cNumTit	:= aGrvSe2[3,2]
Local cFilialMsg:= Alltrim(SM0->M0_FILIAL)

Private lMsErroAuto	:= .F.
Conout("[I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+" DESPESA :"+cNumTit+ " [SE2 1/2]   ]")

//====================== Gravação do SE2 ===================================
MsExecAuto({ | a,b,c | Fina050(a,b,c) },aGrvSe2,,3)
If lMsErroAuto
   Conout("I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " DESPESA :"+cNumTit+" [SE2 1/2] [Error - verifique: ..\system\sc????.log]")
   nRet:= -1
Else
	Conout("[I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " DESPESA :"+cNumTit+ " [SE2 2/2] OK]")
	//====================== Gravação multiplas Naturezas SEV ====================
	If !Empty(aColsAux)
		RegToMemory("SE2", .F., .F. )
		Conout("[I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " DESPESA :"+cNumTit+ " [SEV 1/2] ]")
		GrvSevSez(	"SE2",;				//Alias
				aColsAux,;				//aCols do SEV
				aHeaderAux,;			//aHeader do SEV
				NIL,;					//nVlTit - Valor do titulo
				NIL,;					//nImpostos - Valor do posto
				NIL,;					//lRatImpostos
				"I008F1297",;			//cOrigem
				.F.,;					//lContabiliza
				NIL,;					//nHdlPrv
				0,;						//nTotal
				NIL,;					//cArquivo
				NIL)					//lDesdobr
		Conout("[I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " DESPESA :"+cNumTit+ " [SEV 2/2] OK]")
	EndIf
	//====================== Gravação monimentacao bancaria e baixa titulo SE2 e SE5 ======
	Conout("[I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " DESPESA :"+cNumTit+ " [SE5 1/2] ]")
	MSExecAuto({| a,b,c,d,e,f | FINA080(a,b,c,d,e,f)} ,aBaixa,3,,,.F.,.F.)//3 para baixar ou 5 para cancelar a baixa.
	If lMsErroAuto
		Conout("[I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " DESPESA :"+cNumTit+ " [SE5 2/2] [Error - verifique: ..\system\sc????.log]")
	   	Conout("["+dtoc(dDatabase)+" "+Time()+"] I010GrvDesp 3/3  [Error - verifique: ..\system\sc????.log]")
	   	nRet:= -3
		RecLock("SE2", .F.)
		SE2->(dbDelete())
		SE2->(MsUnLock())
	Else
		RecLock("SE2", .F.)
		SE2->E2_SITUA:="OK"
		SE2->(MsUnLock())

		RecLock("SE5", .F.)
		SE5->E5_SITUA:="OK"
		SE5->(MsUnLock())

		Conout("[I010GrvDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " DESPESA :"+cNumTit+" [SE5 2/2] OK]")
		//Salvando os dados do registro gravado no Array para devolver a frente de loja
		Aeval(SE2->(DbStruct()), { |e,i| Aadd(aSE2,{ e[1], SE2->(FieldGet(i)) } ) } )
		Aeval(SE5->(DbStruct()), { |e,i| Aadd(aSE5,{ e[1], SE5->(FieldGet(i)) } ) } )
		dbSelectArea("SEV")
		dbSetOrder(1)
		If (DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
				// Carrega o vetor conforme a condicao.
			While !Eof() .And. EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA ==;
								SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
				AAdd(aSEV, {} )
				Aeval(SEV->(DbStruct()), { |e,i| Aadd(aSEV[Len(aSEV)], {e[1], SEV->(FieldGet(i))} ) } )
				RecLock("SEV", .F.)
				SEV->EV_SITUA:="OK"
				SEV->(MsUnLock())
				SEV->(dbSkip())
			End
		EndIf
	EndIf	
EndIf

Return {nRet, aSE2, aSEV, aSE5}



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 12/03/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³	Exclusao despesas na retaguarda - funcao chamada pela  														  ³±±
±±³          ³ frente de loja e executada via RPC na retaguarda                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function I010ExcDesp(aSE5, aSE2)
Local nRet	:= 0
Local cFilialMsg:= Alltrim(SM0->M0_FILIAL)
Local cNumTit	:= aSE2[2,2]
Private lMsErroAuto	:= .F.

SE2->(DbSelectArea("SE2"))
SE2->(DbSetorder(1))

Conout("I010ExcDesp:"+xFilial("SE2")+aSE2[1,2]+aSE2[2,2]+aSE2[3,2]+aSE2[4,2]+aSE2[5,2]+aSE2[6,2])

If SE2->(DbSeek(xFilial("SE2")+aSE2[1,2]+aSE2[2,2]+aSE2[3,2]+aSE2[4,2]+aSE2[5,2]+aSE2[6,2]))
	//Cancelando a Baixa do titulo
	MSExecAuto({| a,b,c,d,e,f | FINA080(a,b,c,d,e,f)} ,aSE5,5,,,,)//3 para baixar ou 5 para cancelar a baixa.
	If lMsErroAuto
	   Conout("I010ExcDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " Excluir DESPESA :"+cNumTit+" [SE5 1/2] [Error - verifique: ..\system\sc????.log]")
	   nRet:= -2
	Else
	   Conout("I010ExcDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " Excluir DESPESA :"+cNumTit+" [SE5 1/2] OK]")
	EndIf
	If nRet==0
		//Excluir Titulo
		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aSE2,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
		If lMsErroAuto
		   Conout("I010ExcDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " Excluir DESPESA :"+cNumTit+" [SE2 2/2] [Error - verifique: ..\system\sc????.log]")
		   nRet:= -3
		Else
		   Conout("I010ExcDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " Excluir DESPESA :"+cNumTit+" [SE2 2/2] OK]")
		EndIf
	EndIf
Else
   Conout("I010ExcDesp:"+dtoc(dDatabase)+"-"+Time()+"] "+cFilialMsg+ " Excluir DESPESA :"+cNumTit+" [SE5 1/2] [Error 1]")
   nRet:= -1
EndIf	
Return nRet
