#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

#define _PICTURE 13
#define VK_F3              114        //  0x72
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³InnoF1297 ³ Autor ³ Marcos Alves          ³ Data ³ 26/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Lancamento de despesas Compras, Vales, servicos			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA008F1297(nHdlECF,nOpcX)
Local nOpcA     	:= 0
Local oBtnEnd		:=NIL
Local aCampos		:={}									//Array com os campos da getdados "SEV"
Local cBanco		:= xNumCaixa()
Local cAgencia		:=""
Local cConta		:=""
Local oServer		:= NIL

Private aRet		:= {}

Private oNum		:=NIL
Private oTipo		:=NIL
Private oFornece	:=NIL
Private oValor		:=NIL
Private oHist		:=NIL
Private oGet      	:=NIL
Private oBtnAct 	:=NIL
Private oBtnExc 	:=NIL
Private aHeader 	:= {}
Private aCols   	:= {}
Private nUsado  	:= 0
Private aRotina 	:= {}
Private	lAltera		:=.F.
Private lF050Auto	:=.F.			//Variavel para validacoes das rotinas do financeiro
Private lWhen		:=.T.
Private nRegSE2		:=0
Private oFonte
Private nTotNat		:=0
Private oDlg   		:=NIL
Private oTotNat		:=NIL
DEFAULT nOpcX		:=1

//Conexao com servidor para gravar os dados diretamente na retaguarda
Processa( { || aRet:=U_IA201SrvRPC( {'SA1','SL1','SL2','SL4','SE1','SE2','SE5'})}, "Aguarde...","Conectando com o servidor")

If !aRet[1]
	MsgInfo("Conexão com Servidor nao disponivel, verifique rede")
	Return NIL
Else
	oServer:=aRet[2]
EndIf

//cBanco			:= "C08"	//Teste
CarregaSA6(@cBanco,@cAgencia,@cConta,.T.,,.T.)
nUsado:=0

aAdd( aRotina, {"Incluir"    ,'U_IA008F1297',0,3})

nOpcX		:=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Iniciacao das variaveis de Memoria do SE2               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
M->E2_FILIAL	:=xFilial("SE2")
M->E2_PREFIXO	:=If(cFilAnt="01","CXI","CXB")
M->E2_NUM		:=CRIAVAR("E2_NUM")
M->E2_TIPO		:=CRIAVAR("E2_TIPO")
M->E2_FORNECE	:=CRIAVAR("E2_FORNECE")
M->E2_NATUREZ	:=CRIAVAR("E2_NATUREZ")
M->E2_PARCELA	:="1"
M->E2_LOJA		:=CRIAVAR("E2_LOJA")
M->E2_NOMFOR	:=CRIAVAR("E2_NOMFOR")
M->E2_VALOR		:=0
M->E2_DIRF 		:="2"
M->E2_INSS 		:=0
M->E2_ISS 		:=0
M->E2_IRRF 		:=0
M->E2_MOEDA		:=1
M->E2_PIS		:=0
M->E2_COFINS	:=0
M->E2_CSLL		:=0
M->E2_VLCRUZ	:=0
M->E2_EMISSAO	:=dDataBase
M->E2_APLVLMN	:="2"
M->E2_DESDOBR	:="N"
M->E2_TXMOEDA	:=0
//M->E2_HIST		:="Despesa do Caixa"
M->E2_HIST		:=CRIAVAR("E2_HIST")
M->E2_EMISSAO	:=dDataBase
M->E2_VENCTO	:=dDataBase
M->E2_VENCORI	:=dDataBase
M->E2_VENCREA	:=DataValida(dDataBase) 										
M->E2_EMIS1		:=dDataBase
M->E2_MULTNAT	:="2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos para o aCols das Multiplas Naturezas             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aCampos,"EV_NATUREZ")
aadd(aCampos,"EV_VALOR")

dbSelectArea("SX3")
dbSetOrder(2)
For nC:=1 to Len(aCampos)
	dbSeek(aCampos[nC])
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()) ,;
	               X3_CAMPO    ,;
	               X3_PICTURE  ,;
	               X3_TAMANHO  ,;
	               X3_DECIMAL  ,;
	               X3_VALID    ,;
	               X3_USADO    ,;
	               X3_TIPO     ,;
	               X3_F3	  ,;
	               X3_CONTEXT  })

Next nC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incluir Funcao Inno para validar se a Natureza ja foi digitadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader[1][6]:="U_IA008NatVld().AND."+Alltrim(aHeader[1][6])		//X3_VALID EV_NATUREZ
aHeader[2][6]:="U_IA008ValVld()"									//X3_VALID EV_VALOR
aHeader[1][9]:="SEDINN"									//X3_VALID EV_VALOR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao da linha do aCols                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aCols,Array(Len(aHeader)+1))
aCOLS[1][1] := Space(TamSX3("EV_NATUREZ")[1])
aCOLS[1][2] := 0
aCOLS[1][3] := .F.

dbSelectArea("SEV")
dbSetOrder(1)

DEFINE MSDIALOG oDlg TITLE "Despesas do Caixa" From 8,0 To 29,49 OF oMainWnd
DEFINE FONT oFonte	NAME "Arial" 			SIZE 8,16 BOLD		// Doc., Data, Hora, Loja, PDV

@ 10, 2 TO 65,190 LABEL "" OF oDlg PIXEL
@ 133, 2 TO 143,190 LABEL "" OF oDlg PIXEL

@ 20, 006 SAY "No. Titulo  "  	SIZE 70,7 PIXEL OF oDlg
@ 20, 100 SAY "Tipo        "  	SIZE 70,7 PIXEL OF oDlg
@ 36, 006 SAY "Fornecedor  " 	SIZE 70,7 PIXEL OF oDlg
@ 36, 100 SAY "Vlr.Titulo  " 	SIZE 70,7 PIXEL OF oDlg
@ 52, 006 SAY "Histórico   " 	SIZE 70,7 PIXEL OF oDlg

@ 135, 006 SAY "Ratear     "  	SIZE 70,7 PIXEL OF oDlg FONT oFonte
@ 135, 157 SAY oTotNat VAR nTotNat SIZE 70,7 PIXEL OF oDlg FONT oFonte PICTURE "@E 99,999.99" //COLOR CLR_WHITE,CLR_BLACK

@ 19, 040 MSGET oNum 		VAR M->E2_NUM 		SIZE 040,7 PICTURE "@!"						WHEN lWhen VALID !Empty(M->E2_NUM).AND.FA050Num() F3 "SE2INN"  PIXEL OF oDlg 
@ 19, 130 MSGET oTipo 		VAR M->E2_TIPO		SIZE 010,7 PICTURE "@!"						WHEN lWhen VALID FA050Tipo() .and. FA050Num() .and. FA050Natur() F3 "ZZ"  PIXEL OF oDlg 
@ 35, 040 MSGET oFornece	VAR	M->E2_FORNECE	SIZE 040,7 PICTURE "@!"						WHEN lWhen VALID ExistCpo("SA2",M->E2_FORNECE,,,,.F.) .AND.IA008Fornec().and. fa050num() .And. FA050NATUR().and. FreeForUse("SE2",M->E2_NUM+M->E2_FORNECE) F3 "SA2" PIXEL OF oDlg
@ 35, 130 MSGET oValor		VAR M->E2_VALOR		SIZE 050,7 PICTURE "@E 999,999,999,999.99 "	WHEN lWhen VALID positivo().and.naovazio().and.FA050Nat2().and.fa050valor().AND.IA008Naturez(oBtnAct)  PIXEL OF oDlg
@ 51, 040 MSGET oHist		VAR M->E2_HIST		SIZE 135,7 PICTURE "@!"						WHEN lWhen  PIXEL OF oDlg

oGet	:= MSGetDados():New(70,2,130,190,nOpcX,"U_IA008LinOk","U_IA008TudOk",NIL,.T.,)
oGet:oBrowse:bAdd		:= { || IA008Add()}
oGet:oBrowse:bDelete 	:= { || If(lWhen,IA008DEl(),.F.) }	    // Permite a deletar Linhas
oGet:lF3Header = .T.

DEFINE SBUTTON oBtnExc FROM 145,095 TYPE 3 ENABLE ACTION ( IA008Exc(oSErver),oDlg:End()) OF oDlg
DEFINE SBUTTON oBtnAct FROM 145,130 TYPE 1 ENABLE ACTION ( nOpcA:=IA008Inc(aCampos,cBanco,cAgencia,cConta,nHdlECF, oServer),oDlg:End()) OF oDlg
DEFINE SBUTTON oBtnEnd FROM 145,165 TYPE 2 ENABLE ACTION (MsgInfo("Oi"),oDlg:End()) OF oDlg

oBtnExc:Disable()

ACTIVATE MSDIALOG oDlg CENTER 

// Desconecta 
oServer:CallProc( 'DbCloseAll' )
oServer:Disconnect()


Return nOpcA

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA008LinOk³ Autor ³ Marcos Alves	     ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Validcao da linha do aCols da Naturezas                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA008LinOk(oLin,nTipo)                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA008LinOk(oLin,nTipo)
Local lRet 		:= .T.
Local nTotVal	:=0

default nTipo	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificacao se a linha esta deletada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !aCols[n][nUsado+1]
   If Empty(aCols[n][1])
      MsgInfo("Nao sera permitido linhas sem o Natureza informada.")
      lRet := .F.
   EndIf		
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA008TudOk³ Autor ³ Marcos Alves	     ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Validcao de todas as linhas doaCols da Naturezas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA008TudOk(oGet)                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA008TudOk()
Local lRet		 := .T.
Local nTotVal	:=0
If (lRet:=U_IA008LinOk(NIL,1))
    AEval(aCols,{|X| nTotVal+=If(!X[nUsado+1],X[2],0)})
	If nTotVal<M->E2_VALOR
		MsgInfo("Falta distribuir R$ "+Trans( (M->E2_VALOR-nTotVal),"@E 99,999.99" ))
		oGet:oBrowse:SetFocus()
		lRet:= .F.
	ElseIf nTotVal>M->E2_VALOR
		MsgInfo("Distribuicao superior ao valor total R$ "+Trans( (M->E2_VALOR-nTotVal),"@E 99,999.99" ))
		oGet:oBrowse:SetFocus()
		lRet:= .F.
    EndIf
EndIf    
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA008Naturez³ Autor ³ Marcos Alves    ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Validacao do campo valor e inicializa a Natureza do Fornece-³±±
±±³           ³dor                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA008Naturez(oBtnAct)                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA008Naturez(oBtnAct)
Local lRet 		:= .T.
Local aArea     := GetArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o fornecedor tem natureza cadastrada e gera linha no aCols³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+M->E2_FORNECE))
M->E2_LOJA		:=SA2->A2_LOJA
M->E2_NOMFOR	:=SA2->A2_NREDUZ 											

aCOLS[1][1] 	:= SA2->A2_NATUREZ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o fornecedor tem Natureza, gera uma linha no aCols 				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotNat:=M->E2_VALOR
If !Empty(SA2->A2_NATUREZ)
	aCOLS[1][2] := M->E2_VALOR
	aCOLS[1][3] := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o fornecedor tem Natureza, seta o historico com descricao da natu- ³
	//³reza, gera uma linha no aCols e coloca o foco no botao OK             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SED->(dbSeek(xFilial("SED")+SA2->A2_NATUREZ))
	M->E2_HIST:=SED->ED_DESCRIC
	oGet:oBrowse:Refresh()
	oHist:Refresh()
	oBtnAct:SetFocus()
	nTotNat:=0
EndIf
oTotNat:cCaption:=Transform(nTotNat,"@E 99,999.99") 
oTotNat:Refresh()
oHist:SetFocus()

RestArea(aArea)   
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA008Grava ³ Autor ³ Marcos Alves    ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Gravacao do titulo a pagar e das multiplas naturezas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	      ³ Doceira Innocencio (DBF/TOP)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA008Grava(cAlias,aCampos)                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA008Grava(cAlias,aCampos,cBanco,cAgencia,cConta,cSitua,lShow,oServer)
Local lRet 			:= .T.
Local nC 			:= 0
Local aGrvSe2		:={}
Local aHeaderAux	:={}
Local aColsAux		:={}
Local aBaixa		:={}
Local nI			:= 0
Local nX			:= 0

Private aRetorno := {}

Default lShow		:=.T.		// Variavel para inibir as funcoes de video qdo executado do PE FRTGrvSZ (FRT020)

M->E2_MULTNAT	:=If(Len(aCols)>1,"1","2")
M->E2_HIST		:=If(Empty(M->E2_HIST),"Despesa do Caixa",M->E2_HIST)
If lShow
	//ProcRegua(2)
	//IncProc("Gravando Titulo [SE2]....")
Else
    Conout("")
    Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 1/3  [Gravacao Titulo                [SE2]")
    Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 1/3  [FILIAL  :"+M->E2_FILIAL+"]")
    Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 1/3  [PREFIXO :"+M->E2_PREFIXO+"]")
    Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 1/3  [NUM     :"+M->E2_NUM+"]")
    Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 1/3  [FORNECE :"+M->E2_FORNECE+"]")
EndIf
If !Empty(aCols[1][1])
	M->E2_NATUREZ	:=aCols[1][1]	//Iniciar a variavel para gravacao no SE2
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Array de gravacao dos campos.                                         ³
//³Atencao: A ordem dos campos deve obedecer a sequencia de validacao    ³
//³Ex. Nao trocar a seq. E2_LOJA por E2_FORNECE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aGrvSe2	:=	{		{ "E2_FILIAL"	, M->E2_FILIAL													, Nil },;
					{ "E2_PREFIXO"	, M->E2_PREFIXO												, Nil },;
					{ "E2_NUM"		, M->E2_NUM													, Nil },;
					{ "E2_TIPO"		, M->E2_TIPO												, Nil },;
					{ "E2_NATUREZ"	, M->E2_NATUREZ												, Nil },;
					{ "E2_FORNECE"	, M->E2_FORNECE			 									, Nil },;
					{ "E2_LOJA"   	, M->E2_LOJA												, Nil },;
					{ "E2_NOMFOR"	, M->E2_NOMFOR												, Nil },;
					{ "E2_EMISSAO"	, M->E2_EMISSAO 											, Nil },;
					{ "E2_VENCTO"	, M->E2_VENCTO 												, Nil },;
					{ "E2_VENCORI"	, M->E2_VENCORI												, Nil },;
					{ "E2_VENCREA"	, M->E2_VENCREA												, Nil },;
					{ "E2_VALOR"  	, M->E2_VALOR												, Nil },;
					{ "E2_EMIS1"  	, M->E2_EMISSAO												, Nil },;
					{ "E2_MOEDA"	, M->E2_MOEDA												, Nil },;
					{ "E2_VLCRUZ" 	, M->E2_VLCRUZ												, Nil },;
					{ "E2_HIST"   	, M->E2_HIST												, Nil },;
					{ "E2_PARCELA"	, M->E2_PARCELA												, Nil },; 			
					{ "E2_MULTNAT" 	, M->E2_MULTNAT										  		, Nil },;
					{ "E2_ORIGEM" 	, "IA008F1297"												, Nil },;
					{ "E2_IRRF" 	, 0													  		, Nil },;
					{ "E2_SITUA" 	, cSitua											  		, Nil }	}

//============================================Multiplas Naturezas
If Len(aCols)>1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adicionar os demais campos da tabela SEV, pois eh utilizada na funcao ³
	//³GrvSevSez                                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCampos,"EV_PERC")
	aadd(aCampos,"EV_RATEICC") 
	aadd(aCampos,"EV_SITUA") 
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nC:=1 to Len(aCampos)
		dbSeek(aCampos[nC])
		nUsado++
		AADD(aHeaderAux,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO    ,;
		               X3_PICTURE  ,;
		               X3_TAMANHO  ,;
		               X3_DECIMAL  ,;
		               X3_VALID    ,;
		               X3_USADO    ,;
		               X3_TIPO     ,;
		               X3_F3	  ,;
		               X3_CONTEXT  })
	Next nC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualizar o aColsAux com os dados o aCols                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nC:=1 to Len(aCols)
		aAdd( aColsAux,Array(Len(aHeaderAux)+1))
		aColsAux[nC][1] := aCols[nC][1]								//EV_NATUREZ
		aColsAux[nC][2] := aCols[nC][2]								//EV_VALOR
		aColsAux[nC][3] := NoRound((aCols[nC][2]/M->E2_VALOR)*100,2)	// Formula do % do rateio EV_PERC
		aColsAux[nC][4] := "2"								
		aColsAux[nC][5] := cSitua										//Atualizar o campo EV_SITUA, para ser enviado a Retaguarda
		aColsAux[nC][6] := aCols[nC][3]								//Informacao se a linha esta deletada
	Next nC
EndIf	
//============================================ Baixa do titulo gerado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Baixa automatica do Titulo											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//lRet:=IA008BxTit(cBanco,cAgencia,cConta,.F.,.F.,lShow)
	
DbSelectArea("SE2")

AADD(aBaixa,{"E2_PREFIXO" , M->E2_PREFIXO          	,Nil})    
AADD(aBaixa,{"E2_NUM"     , M->E2_NUM              	,Nil})
AADD(aBaixa,{"E2_PARCELA" , M->E2_PARCELA          	,Nil})
AADD(aBaixa,{"E2_TIPO"    , M->E2_TIPO            	,Nil})
AADD(aBaixa,{"E2_FORNECE" , M->E2_FORNECE          	,Nil})
AADD(aBaixa,{"E2_LOJA"    , M->E2_LOJA          	,Nil})
AADD(aBaixa,{"AUTBANCO"   , cBanco	   		     	,Nil})                  
AADD(aBaixa,{"AUTAGENCIA" , cAgencia        	   	,Nil})                  
AADD(aBaixa,{"AUTCONTA"   , cConta             		,Nil})                  
AADD(aBaixa,{"AUTHIST"    , M->E2_HIST				,Nil})	//"Baixa Automatica"
AADD(aBaixa,{"AUTDTBAIXA" , M->E2_EMISSAO         	,Nil})                  
AADD(aBaixa,{"AUTDTDEB"   , M->E2_EMISSAO         	,Nil})                  
AADD(aBaixa,{"AUTDESCONT" , 0            	     	,Nil})
AADD(aBaixa,{"AUTMULTA"   , 0               	  	,Nil})
AADD(aBaixa,{"AUTJUROS"   , 0                 		,Nil})
AADD(aBaixa,{"AUTVLRPG"   , 0                 		,Nil})
AADD(aBaixa,{"AUTVLRME"   , 0                 		,Nil})                  

Processa( { || aRetorno := oServer:CallProc("U_I010GrvDesp",aGrvSe2, aColsAux,aHeaderAux,aBaixa)}, "Aguarde...","Gravando despesa na Retaguarda")

If aRetorno[1]==0
	//Gravar SE2
	SE2->(RecLock("SE2",.T.))
	nFields:=SE2->(FCount())
	For nI:= 1 to nFields
		If (nPos:= Ascan( aRetorno[2],{|X| X[1]==SE2->(FIELD(nI))}))<>0
			SE2->(FieldPut(nI,aRetorno[2,nPos,2]))
		EndIf
	Next nI
	SE2->(MsUnLock())
	SE2->(DbCommitAll())
	// Gravar SEV
	If Len(aRetorno[3])>0
		For nX:= 1 to Len(aRetorno[3])
			SEV->(RecLock("SEV",.T.))
			nFields:=SEV->(FCount())
			For nI:= 1 to nFields
				If (nPos:= Ascan( aRetorno[3,nX],{|X| X[1]==SEV->(FIELD(nI))}))<>0
					SEV->(FieldPut(nI,aRetorno[3,nX,nPos,2]))
				EndIf
			Next nI
			SEV->(MsUnLock())
		Next nX
		SEV->(DbCommitAll())
	EndIf
	
	SE5->(RecLock("SE5",.T.))
	nFields:=SE5->(FCount())
	For nI:= 1 to nFields
		If (nPos:= Ascan( aRetorno[4],{|X| X[1]==SE5->(FIELD(nI))}))<>0
			SE5->(FieldPut(nI,aRetorno[4,nPos,2]))
		EndIf
	Next nI
	SE5->(MsUnLock())
	SE5->(DbCommitAll())
Else
	lRet := .F.
EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³F1297FornecInno ³ Autor ³ Marcos Alves    ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Validar se o titulo no fornecedor                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³F1297FornecInno(oGet)                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA008Fornec()
Local lRet 		:= .T.
Local aArea     := GetArea()
Local cChaveSe2 := "'" + xFilial("SE2") +"'+ m->e2_prefixo + m->e2_num + m->e2_parcela +" +;
							" m->e2_tipo + m->e2_fornece + m->e2_loja"
SA2->(dbSetOrder(1))
If (lRet:= SA2->(dbSeek(xFilial("SA2")+M->E2_FORNECE)))
	M->E2_LOJA		:=SA2->A2_LOJA             
	M->E2_NOMFOR	:=SA2->A2_NREDUZ 											
	If ! Empty(m->e2_num) .and. !Empty(m->e2_tipo) .And. !Empty(m->e2_fornece) .And. !Empty(m->e2_loja)
		dbSelectArea("SE2")
		dbSetOrder(1)
		dbSeek(&cChaveSe2)
		If Found()
			Help(" ",1,"FA050NUM")
			lRet:= .F.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se numera‡„o j  havia sido utilizada - PA ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet.AND.m->e2_tipo $ MVPAGANT
			DbSelectArea("SE5")
			DbSetOrder(7)
			If DbSeek(xFilial("SE5")+m->e2_prefixo+m->e2_num+m->e2_parcela+m->e2_tipo+m->e2_fornece+m->e2_loja)
				Help(" ",1,"PA_EXISTIU")
				lRet :=.F.
			Endif		
			DbSelectArea("SE2")
		Endif
		If lRet.AND.m->e2_tipo $ MVABATIM
			DbSetOrder(6)
			If ! dbSeek(xFilial("SE2") + m->e2_fornece + m->e2_loja + m->e2_prefixo +;
				m->e2_num + m->e2_parcela)
				Help(" ",1,"FA040TIT")
		        lRet:=	.F.
			EndIf
		EndIf
	End
EndIf
RestArea(aArea)   
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³F1297NatVldInno ³ Autor ³ Marcos Alves    ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Validar se a natureza ja foi digitada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³F1297NatVldInno                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA008NatVld()
Local lRet	:=.T.
If Len(aCols)>1
	For nI:=1 to Len(aCols)
		If !aCols[nI][nUsado+1]
			If M->EV_NATUREZ==aCols[nI][1]
				lRet:=.F.
			    Exit
			EndIf
        EndIf
	Next nI	    
	If !lRet
		MsgInfo("Natureza já digitada na linha "+Alltrim(Str(nI)) )
	EndIf		
EndIf
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Consulta padrao (SXB) XB_ALIAS=SE2INN, chamada no campo:                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IA008F3() 
Local aVetor := {}
Local oDlg
Local oLbx
Local cTitulo := "Titulos incluidos"
Local aCabec := {"E2_NUM","E2_TIPO","E2_FORNECE","E2_NOMFOR","E2_VALOR"}

If ReadVar()<>"M->E2_NUM"
	Return .T.
EndIf
dbSelectArea("SE2")
dbSetOrder(5)
dbSeek(xFilial("SE2")+DTOS(dDataBase))

// Carrega o vetor conforme a condicao.
While !Eof() .And. E2_FILIAL == xFilial("SE2").AND.E2_EMISSAO==dDataBase
   aAdd( aVetor, { E2_NUM, E2_TIPO, E2_FORNECE, E2_NOMFOR, E2_VALOR,SE2->(Recno())} )
	dbSkip()
End

// Se não houver dados no vetor, avisar usuário e abandonar rotina.
If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe dados a consultar", {"Ok"} )
   Return .T.
Endif

// Monta a tela para usuário visualizar consulta.
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

   // Primeira opção para montar o listbox.
   @ 10,10 LISTBOX oLbx FIELDS HEADER ;
   "Titulo","Tipo","Codigo","Fornecedor","Valor" ;
   SIZE 230,95 OF oDlg PIXEL	
	oLbx:blDblClick := { || IA008LClick(oLbx:nAt,aVetor,oDlg)}
	oLbx:SetArray( aVetor )
   	oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;
                      aVetor[oLbx:nAt,2],;
                      aVetor[oLbx:nAt,3],;
                      aVetor[oLbx:nAt,4],;
                      Transform(aVetor[oLbx:nAt,5],"@E 99,999.99")}}
	                    
DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA008LClick(nOp,aVetor,oDlg)
Local lRet	:=.T.

oBtnExc:Enable()
nRegSE2	:=aVetor[nOp][6]
lWhen 	:=.F.

SE2->(dbGoto(nRegSE2))
M->E2_NUM 		:=SE2->E2_NUM
M->E2_TIPO		:=SE2->E2_TIPO
M->E2_FORNECE	:=SE2->E2_FORNECE
M->E2_VALOR		:=SE2->E2_VALOR
M->E2_HIST		:=SE2->E2_HIST

dbSelectArea("SEV")
dbSetOrder(1)
aCols:={}
If (DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
	// Carrega o vetor conforme a condicao.
	While !Eof() .And. EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA ==;
						SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
	   aAdd( aCols, { EV_NATUREZ, EV_VALOR,.F. } )
		dbSkip()
	End

Else
	AADD(aCols,{SE2->E2_NATUREZ,SE2->E2_VALOR,.F.})
EndIf
oNum:Refresh()
oTipo:Refresh()
oFornece:Refresh()
oValor:Refresh()
oGet:oBrowse:Refresh()
oBtnAct:SetFocus()
oDlg:End()

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA008Exc(oServer)
Local lRet	:= .T.

If !lWhen.AND.MsgNoYes("Deseja excluir o titulo ?")
	Begin Transaction
	   U_IA008ProcEx(oServer)
	End Transaction
EndIf
Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IA008ProcEx(oServer)
Local nRet	:= -9
Local aSE5	:= {}
Local aSE2	:= {}

SE2->(dbGoto(nRegSE2))

SE5->(dbSetOrder(7))
SE5->(dbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"01"))

// Cancelar a Baixa do Titulo
AADD( aSE5,{"E2_PREFIXO" , SE2->E2_PREFIXO   	,Nil})    
AADD( aSE5,{"E2_NUM"     , SE2->E2_NUM			,Nil})
AADD( aSE5,{"E2_PARCELA" , SE2->E2_PARCELA		,Nil})
AADD( aSE5,{"E2_TIPO"    , SE2->E2_TIPO			,Nil})
AADD( aSE5,{"E2_FORNECE" , SE2->E2_FORNECE		,Nil})
AADD( aSE5,{"E2_LOJA"    , SE2->E2_LOJA			,Nil})
AADD( aSE5,{"AUTBANCO"   , SE5->E5_BANCO      	,Nil})                  
AADD( aSE5,{"AUTAGENCIA" , SE5->E5_AGENCIA    	,Nil})                  
AADD( aSE5,{"AUTCONTA"   , SE5->E5_CONTA      	,Nil})                  
AADD( aSE5,{"AUTHIST"    , SE2->E2_HIST			,Nil})	//"Baixa Automatica"
AADD( aSE5,{"AUTDTBAIXA" , SE2->E2_BAIXA     	,Nil})                  
AADD( aSE5,{"AUTDTDEB"   , SE2->E2_BAIXA     	,Nil})                  
AADD( aSE5,{"AUTDESCONT" , 0                 	,Nil})
AADD( aSE5,{"AUTMULTA"   , 0                 	,Nil})
AADD( aSE5,{"AUTJUROS"   , 0                 	,Nil})
AADD( aSE5,{"AUTVLRPG"   , 0                 	,Nil})
AADD( aSE5,{"AUTVLRME"   , 0                 	,Nil})                  

AADD( aSE2,{"E2_PREFIXO" , SE2->E2_PREFIXO   	,Nil})    
AADD( aSE2,{"E2_NUM"	 , SE2->E2_NUM		   	,Nil})    
AADD( aSE2,{"E2_PARCELA" , SE2->E2_PARCELA	   	,Nil})    
AADD( aSE2,{"E2_TIPO"	 , SE2->E2_TIPO		   	,Nil})    
AADD( aSE2,{"E2_FORNECE" , SE2->E2_FORNECE	   	,Nil})    
AADD( aSE2,{"E2_LOJA"	 , SE2->E2_LOJA		   	,Nil})    
                                 

Processa( { || nRet := oServer:CallProc("U_I010ExcDesp",aSE5, aSE2)}, "Aguarde...","Excluindo despesa na Retaguarda")

If nRet==0 //OK
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Excluir o registro de Multiplas Naturezas                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEV")
	dbSetOrder(1)
	If (DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
			// Carrega o vetor conforme a condicao.
		While !Eof() .And. EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA ==;
							SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
			RecLock("SEV", .F.)
			SEV->(dbDelete())
			SEV->(MsUnLock())
			SEV->(dbSkip())
		End
	EndIf
	// Excluir registro SE2
	RecLock("SE2", .F.)
	SE2->(dbDelete())
	SE2->(MsUnLock())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Excluir o registro da movimentacao bancaria SE5                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SE5->(Reclock("SE5",.F.,.T.))
	SE5->(dbDelete())
	SE5->(MsUnlock())

	lRet := .T.
Else
   MsgInfo( "Falha na exclusão da despesa")
	lRet := .f.
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Static Function F1297InicInno(aCampos)
Static Function IA008Inic(aCampos)
Local nC

nUsado:=0
lWhen 	:=.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Iniciacao das variaveis de Memoria do SE2               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
M->E2_FILIAL	:=xFilial("SE2")
M->E2_PREFIXO	:=If(cFilAnt="01","CXI","CXB")
M->E2_NUM		:=CRIAVAR("E2_NUM")
M->E2_TIPO		:=CRIAVAR("E2_TIPO")
M->E2_FORNECE	:=CRIAVAR("E2_FORNECE")
M->E2_NATUREZ	:=CRIAVAR("E2_NATUREZ")
M->E2_NOMFOR	:=CRIAVAR("E2_NOMFOR")
M->E2_PARCELA	:="1"
M->E2_LOJA		:=CRIAVAR("E2_LOJA")
M->E2_VALOR		:=0
M->E2_DIRF 		:="2"
M->E2_INSS 		:=0
M->E2_ISS 		:=0
M->E2_IRRF 		:=0
M->E2_MOEDA		:=1
M->E2_PIS		:=0
M->E2_COFINS	:=0
M->E2_CSLL		:=0
M->E2_VLCRUZ	:=0
M->E2_EMISSAO	:=dDataBase
M->E2_APLVLMN	:="2"
M->E2_DESDOBR	:="N"
M->E2_TXMOEDA	:=0
M->E2_HIST		:=CRIAVAR("E2_HIST")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos para o aCols das Multiplas Naturezas             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos:={}
aadd(aCampos,"EV_NATUREZ")
aadd(aCampos,"EV_VALOR")

aHeader:={}
dbSelectArea("SX3")
dbSetOrder(2)
For nC:=1 to Len(aCampos)
	dbSeek(aCampos[nC])
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()) ,;
	               X3_CAMPO    ,;
	               X3_PICTURE  ,;
	               X3_TAMANHO  ,;
	               X3_DECIMAL  ,;
	               X3_VALID    ,;
	               X3_USADO    ,;
	               X3_TIPO     ,;
	               X3_F3  ,;
	               X3_CONTEXT  })
Next nC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incluir Funcao Inno para validar se a Natureza ja foi digitadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader[1][6]:="U_IA008NatVld().AND."+Alltrim(aHeader[1][6])
aHeader[2][6]:="U_IA008ValVld()"									//X3_VALID EV_VALOR
aHeader[1][9]:="SEDINN"									//X3_VALID EV_VALOR
//oGet	:= MSGetDados():New(60,2,130,190,1,"U_F1297LinOkInno","U_F1297TudOkInno",NIL,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao da linha do aCols                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols:={}
aAdd( aCols,Array(Len(aHeader)+1))
aCOLS[1][1] := Space(TamSX3("EV_NATUREZ")[1])
aCOLS[1][2] := 0
aCOLS[1][3] := .F.
n:=1
If Valtype(oBtnExc)<>"U"
	oBtnExc:Disable()
	oNum:Refresh()
	oTipo:Refresh()
	oFornece:Refresh()
	oValor:Refresh()
	oGet:oBrowse:Refresh()
	oNum:SetFocus()
EndIf	

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA008Inc(aCampos,cBanco,cAgencia,cConta,nHdlECF, oServer)

If lWhen.AND.U_IA008TudOk()
	/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Coloca o Ponteiro do Mouse em Estado de Espera			   	   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
	CursorWait()
	oGet:oBrowse:Refresh()
	Begin Transaction
	   lRet:=U_IA008Grava("SE2",aCampos,cBanco,cAgencia,cConta,"00",.T. ,oServer)
	End Transaction
	If !lRet
		MsgInfo("Falha na gravação, despesa não registrada!!")
	Else	
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Impressao do comprovante                                      ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
		//Processa({|lEnd| F1297ImpInno(nHdlECF)},"Processando...","Imprimindo o comprovante",.F.)
		IA008Imp(nHdlECF)
		/*/
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Restaura o Cursor do Mouse                				   	   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
	EndIf	
	CursorArrow()
EndIf
Return 2

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³F1297BxTitInno³ Autor ³ Marcos Alves       ³ Data ³15/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Baixa Automatica do Titulo                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Prefixo do Titulo                                   ³±±
±±³          ³ExpC2 - Parcela do Titulo                                   ³±±
±±³          ³ExpC3 - Tipo do Titulo                                      ³±±
±±³          ³ExpC4 - No. do Titulo                                       ³±± 
±±³          ³ExpC5 - Proprietario do Veiculo (Fornecedor)                ³±±
±±³          ³ExpC6 - Loja do Proprietario do Veiculo                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/
Static Function IA008BxTit(cBanco,cAgencia,cConta,lExibeLanc,lOnline,lShow)
Local   aBaixa			:= {}
Local   lRet        	:= .T.

Private lMsHelpAuto		:= .T.
Private lMsErroAuto		:= .F.

DbSelectArea("SE2")

If !lShow
	Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 3/3  [Gravacao Movimentacao Bancario [SE5]")
	Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 3/3  [BANCO   :"+cBanco+"]")
	Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 3/3  [AGENCIA :"+cAgencia+"]")
	Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 3/3  [CONTA   :"+cBanco+"]")
EndIf
AADD(aBaixa,{"E2_PREFIXO" , M->E2_PREFIXO          	,Nil})    
AADD(aBaixa,{"E2_NUM"     , M->E2_NUM              	,Nil})
AADD(aBaixa,{"E2_PARCELA" , M->E2_PARCELA          	,Nil})
AADD(aBaixa,{"E2_TIPO"    , M->E2_TIPO            	,Nil})
AADD(aBaixa,{"E2_FORNECE" , M->E2_FORNECE          	,Nil})
AADD(aBaixa,{"E2_LOJA"    , M->E2_LOJA          	,Nil})
AADD(aBaixa,{"AUTBANCO"   , cBanco	   		     	,Nil})                  
AADD(aBaixa,{"AUTAGENCIA" , cAgencia        	   	,Nil})                  
AADD(aBaixa,{"AUTCONTA"   , cConta             		,Nil})                  
AADD(aBaixa,{"AUTHIST"    , M->E2_HIST				,Nil})	//"Baixa Automatica"
AADD(aBaixa,{"AUTDTBAIXA" , M->E2_EMISSAO         	,Nil})                  
AADD(aBaixa,{"AUTDTDEB"   , M->E2_EMISSAO         	,Nil})                  
AADD(aBaixa,{"AUTDESCONT" , 0            	     	,Nil})
AADD(aBaixa,{"AUTMULTA"   , 0               	  	,Nil})
AADD(aBaixa,{"AUTJUROS"   , 0                 		,Nil})
AADD(aBaixa,{"AUTVLRPG"   , 0                 		,Nil})
AADD(aBaixa,{"AUTVLRME"   , 0                 		,Nil})                  

//AADD(aBaixa,{"AUTMOTBX"   , 0                 	,Nil})                  
//AADD(aBaixa,{"AUTCHEQUE"  , 0                 	,Nil})                  
//AADD(aBaixa,{"AUTOUTGAS"  , 0                 	,Nil})                  
//AADD(aBaixa,{"AUTTXMOEDA" , 0                 	,Nil})                  
//AADD(aBaixa,{"AUTVLRME"   , 0                 	,Nil})                  
//AADD(aBaixa,{"AUTBENEF"   , 0                 	,Nil})                  

//Processo de gravação autoimatica esta nO FINA080(193) - MSArrayXDB(xAutoCab,nil,4)
MSExecAuto({| a,b,c,d,e,f | FINA080(a,b,c,d,e,f)} ,aBaixa,3,,,lExibeLanc,lOnline)//3 para baixar ou 5 para cancelar a baixa.

//-- Se houve problemas apresenta o motivo do erro.
If lMsErroAuto
    If lShow
		MostraErro()
	Else
	    Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 3/3  [Error - verifique: ..\system\sc????.log]")
	EndIf
	lRet := .F.
Else
	If !lShow
		Conout("["+dtoc(dDatabase)+" "+Time()+"] IA008F1297 3/3  [Gravacao Movimentacao Bancario [SE5] OK")
	EndIf	
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³F12972ExBxInno³ Autor ³ Marcos Alves       ³ Data ³19/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Exclui a Baixa Automatica do Titulo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Prefixo do Titulo                                   ³±±
±±³          ³ExpC2 - Parcela do Titulo                                   ³±±
±±³          ³ExpC3 - Tipo do Titulo                                      ³±±
±±³          ³ExpC4 - No. do Titulo                                       ³±± 
±±³          ³ExpC5 - Proprietario do Veiculo (Fornecedor)                ³±±
±±³          ³ExpC6 - Loja do Proprietario do Veiculo                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±/*/
Static Function IA008ExBx(lShow)
Local lRet		:=.T.
Local aBaixa	:= {}
Local lRet      := .T.

Private lMsHelpAuto		:= .T.
Private lMsErroAuto		:= .F.

DbSelectArea("SE2")
AADD(aBaixa,{"E2_PREFIXO" , SE2->E2_PREFIXO   	,Nil})    
AADD(aBaixa,{"E2_NUM"     , SE2->E2_NUM			,Nil})
AADD(aBaixa,{"E2_PARCELA" , SE2->E2_PARCELA		,Nil})
AADD(aBaixa,{"E2_TIPO"    , SE2->E2_TIPO		,Nil})
AADD(aBaixa,{"E2_FORNECE" , SE2->E2_FORNECE		,Nil})
AADD(aBaixa,{"E2_LOJA"    , SE2->E2_LOJA		,Nil})
AADD(aBaixa,{"AUTBANCO"   , SE5->E5_BANCO      	,Nil})                  
AADD(aBaixa,{"AUTAGENCIA" , SE5->E5_AGENCIA    	,Nil})                  
AADD(aBaixa,{"AUTCONTA"   , SE5->E5_CONTA      	,Nil})                  
AADD(aBaixa,{"AUTHIST"    , SE2->E2_HIST		,Nil})	//"Baixa Automatica"
AADD(aBaixa,{"AUTDTBAIXA" , SE2->E2_BAIXA     	,Nil})                  
AADD(aBaixa,{"AUTDTDEB"   , SE2->E2_BAIXA     	,Nil})                  
AADD(aBaixa,{"AUTDESCONT" , 0                 	,Nil})
AADD(aBaixa,{"AUTMULTA"   , 0                 	,Nil})
AADD(aBaixa,{"AUTJUROS"   , 0                 	,Nil})
AADD(aBaixa,{"AUTVLRPG"   , 0                 	,Nil})
AADD(aBaixa,{"AUTVLRME"   , 0                 	,Nil})                  
                                                
MSExecAuto({| a,b,c,d,e,f | FINA080(a,b,c,d,e,f)} ,aBaixa,5,,,,)//3 para baixar ou 5 para cancelar a baixa.
//-- Se houve problemas apresenta o motivo do erro.
If lMsErroAuto
    If lShow
		MostraErro()
	EndIf	
	lRet := .F.
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Excluir o registro da movimentacao bancaria SE5                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SE5->(Reclock("SE5",.F.,.T.))
	SE5->(dbDelete())
	SE5->(MsUnlock())
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³F12972GravaInno ³ Autor ³ Marcos Alves    ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Gravacao do titulo a pagar e das multiplas naturezas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³F12972GravaInno(cAlias,aCampos)                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA008ExTit(lShow)
Local lRet 			:= .T.
Local nC 			:= 0
Local aGrvSe2		:={}
Local aHeaderAux	:={}
Local aColsAux		:={}

Private lMsErroAuto := .F.		// Utilizada na funcao MsExecAuto

lF050Auto :=.F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Array de gravacao dos campos.                                         ³
//³Atencao: A ordem dos campos deve obedecer a sequencia de validacao    ³
//³Ex. Nao trocar a seq. E2_LOJA por E2_FORNECE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aGrvSe2	:=	{		{ "E2_FILIAL"	, SE2->E2_FILIAL												, Nil },;
					{ "E2_PREFIXO"	, SE2->E2_PREFIXO												, Nil },;
					{ "E2_NUM"		, SE2->E2_NUM												, Nil },;
					{ "E2_TIPO"		, SE2->E2_TIPO												, Nil },;
					{ "E2_NATUREZ"	, SE2->E2_NATUREZ											, Nil },;
					{ "E2_FORNECE"	, SE2->E2_FORNECE			 								, Nil },;
					{ "E2_LOJA"   	, SE2->E2_LOJA												, Nil },;
					{ "E2_NOMFOR"	, SE2->E2_NOMFOR 											, Nil },;
					{ "E2_EMISSAO"	, SE2->E2_EMISSAO 												, Nil },;
					{ "E2_VENCTO"	, SE2->E2_VENCTO 												, Nil },;
					{ "E2_VENCORI"	, SE2->E2_VENCORI 												, Nil },;
					{ "E2_VENCREA"	, SE2->E2_VENCREA			 									, Nil },;
					{ "E2_VALOR"  	, SE2->E2_VALOR												, Nil },;
					{ "E2_EMIS1"  	, SE2->E2_EMIS1													, Nil },;
					{ "E2_MOEDA"	, SE2->E2_MOEDA												, Nil },;
					{ "E2_VLCRUZ" 	, SE2->E2_VLCRUZ												, Nil },;
					{ "E2_HIST"   	, SE2->E2_HIST												, Nil },;
					{ "E2_PARCELA"	, SE2->E2_PARCELA												, Nil },; 			
					{ "E2_ORIGEM" 	, "IA008F1297"												, Nil },;
					{ "E2_IRRF" 	, 0													  		, Nil }}

MsExecAuto({ | a,b,c | Fina050(a,b,c) },aGrvSe2,,5) //Opcao 5 Exclui
If lMsErroAuto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atencao: Se gerar error verificar o arquivos ..\system\sc????.log     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lShow
		Help(" ", 1, "ERROGERACP")
	EndIf
	lRet:=.F.
Else
EndIf
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA008DEl()
Local lRet		:=.T.
Local nVal		:= aCols[n][2] //Valor do rateio da natureza

aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])]
//AlwaysTrue()
If !aCols[n,Len(Acols[n])]
	nTotNat-=nVal
Else
	nTotNat+=nVal
EndIf
oTotNat:cCaption:=Transform(nTotNat,"@E 99,999.99") 
oTotNat:Refresh()
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IA008ValVld(nTipo)
Local lRet		:=.T.
Local nVal		:= GetMemvar("EV_VALOR") //Valor do rateio da natureza

default nTipo	:= 0

If aCols[n,2]<>nVal
	nTotNat+=aCols[n,2]
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificacao se a linha esta deletada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !aCols[n][ nUsado+1 ].AND.( ( nTotNat-nVal ) < 0 .OR. nVal=0 )
	MsgInfo("Valor inválido.")
    lRet := .F.
Else
	nTotNat-=nVal
	oTotNat:cCaption:=Transform(nTotNat,"@E 99,999.99") 
	oTotNat:Refresh()
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA008Add()
Local nTotVal	:=0

AEval(aCols,{|X| nTotVal+=If(!x[nUsado+1],X[2],0)})
If nTotVal=M->E2_VALOR
   MsgInfo("Valor distribuido igual ao valor total, não será permitido incluir novas linhas")
Else
	oGet:lChgField:=.F.
	oGet:AddLine()
EndIf		
Return NIL

Static Function IA008Imp(nHdlECF)
Local lRet		:=.T.
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
Local cLinha	:="------------------------------------------------"
Local cTipo		:="["+Upper(AllTrim(Posicione("SX5",1,xFilial("SX5")+"ZZ"+M->E2_TIPO,"X5_DESCRI")))+"]"
Local nIni		:=(Len(cLinha)-Len(cTipo))/2
Private aString	:={}																		// Array com as linhas do layout do cupom

cLinha:=Stuff(cLinha,nIni,Len(cTipo),cTipo)

aadd(aString,{"A1","========================================= "+cCupom	,{}})
aadd(aString,{"A2","...........Despesas do Caixa...............v.1.0"	,{}})
aadd(aString,{"A3","Loja...........:AAA BBB                         "	,{SM0->M0_CODFIL+" ",SM0->M0_FILIAL},{}})
aadd(aString,{"A4","Data AAA       :BBB            Hora....:CCC     "	,{cSemana,dToc(dDataBase),Time()},{}})
aadd(aString,{"A5","Caixa..........:AAA                             "	,{cCaixa+"-"+cUserName},{}})
aadd(aString,{"A6","================================================"	,{}})
aadd(aString,{"A7",cLinha												,{}})
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","No. Titulo.....:AAA                             "	,{M->E2_NUM},{"@!"}}) 
aadd(aString,{"  ","Fornecedor.....:AAA                             "	,{M->E2_FORNECE+" - "+Alltrim(M->E2_NOMFOR)},{"@!"}}) 
aadd(aString,{"  ","Historico......:AAA                 			"	,{M->E2_HIST},{"@!"}}) 
aadd(aString,{"  ","Valor..........:AAA                  			"	,{M->E2_VALOR},{"@E 999,999.99"}}) 
aadd(aString,{"  ","                                                "  ,{}})
//If M->E2_TIPO=="RC "
aadd(aString,{"  ","        -----------------------------           "  ,{}})
aadd(aString,{"  ","                 Assinatura                     "	,{}})

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
//Gravacao do cupom no arquivos C:\P10\Frente\Protheus_Data\FECHAMENTO\MATRIZ\matriz_c08_31052009.txt
U_IA999MsgWait(cString,"Impressão de comprovante", 10000)
CursorWait()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Comunta Impressora Fiscal                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
If (nRet == 0 .OR. nRet == 7)
	If (nRet := IFRelGer(nHdlECF, cString))=0 
		lRet:=.T.
	EndIf
EndIf
CursorArrow()

Return lRet
