/*
+---------------------------------------------------------------------------+
| Funcao	 : FRTABRCX  | Autor : Marcos Alves          | Data : 03/03/09  |
+---------------------------------------------------------------------------+
|Descricao : Esse ponto de entrada é chamado durante a abertura do caixa,   |
|somente quando é executada uma troca de usuário ou quando o mesmo usuário  |
|fecha e abre o caixa.                                                      |
| É utilizado para a impressão de um Relatório Gerencial de Abertura de     |
|Caixa. Caso a String de retorno não seja vazia (""), cada linha da String  |
| separada por Chr(10) será impressa. Se a impressão não for possível,      |
|a abertura do caixa será abortada.                                         |
|Programa Fonte.PRW                                                         |
|Sintaxe                                                                    |
|FRTABRCX - Impressão de Relatório Gerencial ( < UPAR> ) --> URET           |
+---------------------------------------------------------------------------+
| Uso		 : Innocencio 			 								  	    |
+---------------------------------------------------------------------------+
*/
User Function FRTABRCX()
Local oDlgCx
Local cString	:=""
Local cCupom	:=""
Local nValor	:=GetNewPar("MV_INNOFTI",0)		//Fundo de troco Inicial 
Local cCaixa	:=xNumCaixa()					//Codigo do caixa
Local cNatureza := "TROCO"
Local cHistor   := "FUNDO TROCO INICIAL CAIXA "+cCaixa //Descricao do campo SE5_HISTOR
Local cMoeda	:="TC"
Local cCxOrigem := Substr(GetMv("MV_CXLOJA"),1,3)
Local lTroco	:=.F.
Local lEnable	:=.T.
Local cCupom	:="" //Numero do documento 


//Tela de lancamento das moedas                                  
cString:=I011Moedas(@cCupom,@nValor)

//Gravacao do movimento bancario P/R
If !Empty(cString)
	U_IA011GrvSE5(cCxOrigem,cNatureza,cHistor,cMoeda,"P",nValor,cCupom)
	U_IA011GrvSE5(cCaixa,cNatureza,cHistor,cMoeda,"R",nValor,cCupom)
EndIf	

Return cString // Retornar o Cupom a ser impresso.


/*
+---------------------------------------------------------------------------+
| Funcao	 : I011Moedas| Autor : Marcos Alves          | Data : 28/08/21  |
+---------------------------------------------------------------------------+
|Descricao : Tela de lancamento das moedas                                  |
+---------------------------------------------------------------------------+
| Uso		 : FRTABRCX  			 								  	    |
+---------------------------------------------------------------------------+
*/
Static Function I011Moedas(cCupom,nValor)

Local dDataInno	:=dDataBase-1							// Data do fechamento de caixa 
Local cCaixa	:=xNumCaixa()							//Codigo do caixa
Local ODlgCx
Local oScroll
Local oData 
Local oGrupoCx1
Local oGrupoCx2
Local oCaixa
Local oNome
Local cNome		:=cUserName

Local oFntCx
Local oFntCx2
Local oFntRel

Local lRetVld	:=.F.
Local lRet		:=.F.

Local oScroll
Local cString	:=""

Local lEnable	:=.F.

Local oBtnAct, oBtnImp, oBtnEnd
Local aCedulas:={}										// Variavel do Tipo do fechamento Completo/Resumido
Private oTotDinFlag, cTotDinFlag :="" 

Private oTotDin
Private nTotDin		:=0
Private nTotDinAux	:=0

lEnable:=IA011Rest(aCedulas,dDataInno,cCaixa)

DEFINE MSDIALOG ODlgCx FROM 1,1 TO 450,410 TITLE "Fundo de Troco Inicial" PIXEL OF GetWndDefault()

DEFINE FONT oFntCx	NAME "Courier New"	   	SIZE 7,19 BOLD
DEFINE FONT oFntCx2 NAME "Courier New"     	SIZE 8,16 BOLD      
DEFINE FONT oFntRel	NAME "Courier New"	   	SIZE 7,16 BOLD  	// Relatorio Fechamento L,A

@ 005,004 GROUP oGrupoCx1 TO 043,200 LABEL "Caixa Origem" COLOR CLR_HBLUE OF oDlgCx PIXEL
@ 013,014 SAY "Data" SIZE 50,10 OF oDlgCx PIXEL 
@ 012,030 MSGET oData VAR dDataInno SIZE 32,10 OF oDlgCx PIXEL VALID !Empty(dDataInno) WHEN lEnable

@ 030,015 SAY "Caixa" SIZE 50,10 OF oDlgCx PIXEL
@ 030,070 SAY oNome VAR cNome SIZE 50,10 OF oDlgCx PIXEL
@ 027,030 MSGET oCaixa VAR cCaixa F3 "23" SIZE 35,10 PICTURE "@!" OF oDlgCx PIXEL VALID lRetVld:=IA11VldCX(aCedulas,dDataInno,cCaixa,@lEnable) WHEN lEnable

@ 044,004 GROUP oGrupoCx2 TO 205,200 LABEL "Numerários - Dinheiro" COLOR CLR_HBLUE OF oDlgCx PIXEL

@ 055,008 SCROLLBOX oScroll VERTICAL SIZE 135,178 OF oGrupoCx2 BORDER      // @ L,C   ; SIZE L,C

nLin:=5
@ nLin,010 SAY "   Cédula              Qtd                Valor " SIZE 150,18 PIXEL OF oScroll //COLOR CLR_WHITE,CLR_BLACK //FONT oFntCx
nLin+=8

//R$ 0,05
@ nLin,010 MSGET  aCedulas[1,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[1,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(1,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[1,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll 	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[1,4] RESOURCE aCedulas[1,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 0,10
nLin+=15
@ nLin,010 MSGET  aCedulas[2,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll  	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[2,2] Picture "@E 999" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT VALID IA011VCedulas(2,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[2,3] Picture "@E 9,999.99"	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[2,4] RESOURCE aCedulas[2,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 0,25
nLin+=15
@ nLin,010 MSGET  aCedulas[3,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[3,2] Picture "@E 999" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT VALID IA011VCedulas(3,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[3,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[3,4] RESOURCE aCedulas[3,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 0,50
nLin+=15
@ nLin,010 MSGET  aCedulas[4,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[4,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(4,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[4,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[4,4] RESOURCE aCedulas[4,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 1,00
nLin+=15
@ nLin,010 MSGET  aCedulas[5,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[5,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(5,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[5,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[5,4] RESOURCE aCedulas[5,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 2,00
nLin+=15
@ nLin,010 MSGET  aCedulas[6,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[6,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(6,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[6,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[6,4] RESOURCE aCedulas[6,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 5,00
nLin+=15
@ nLin,010 MSGET  aCedulas[7,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[7,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(7,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[7,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[7,4] RESOURCE aCedulas[7,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 10,00
nLin+=15
@ nLin,010 MSGET  aCedulas[8,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[8,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(8,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[8,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[8,4] RESOURCE aCedulas[8,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 20,00
nLin+=15
@ nLin,010 MSGET  aCedulas[9,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[9,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(9,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[9,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[9,4] RESOURCE aCedulas[9,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 50,00
nLin+=15
@ nLin,010 MSGET  aCedulas[10,1] Picture "@E 999.99" 	SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[10,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(10,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[10,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[10,4] RESOURCE aCedulas[10,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//R$ 100,00
nLin+=15
@ nLin,010 MSGET  aCedulas[11,1] Picture "@E 999.99" 	SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET  aCedulas[11,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID IA011VCedulas(11,aCedulas) WHEN lEnable
@ nLin,075 MSGET  aCedulas[11,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 
@ nLin,120 BITMAP aCedulas[11,4] RESOURCE aCedulas[11,5] PIXEL SIZE 16,16 NOBORDER OF oScroll

//nLin:=123
nLin:=193
@ nLin,018 SAY "Total" FONT oFntCx2 PIXEL OF  oGrupoCx2  SIZE 150,18 COLOR CLR_GREEN,CLR_BLACK //FONT oFntCx
@ nLin,075 SAY oTotDin VAR Transform(nTotDin,"@E 999,999.99") FONT oFntCx2 PIXEL OF  oGrupoCx2  SIZE 150,18 COLOR  CLR_GREEN,CLR_BLACK
@ nLin,128 BITMAP oTotDinFlag RESOURCE cTotDinFlag PIXEL SIZE 16,16 NOBORDER OF  oGrupoCx2

oTotDinFlag:SetBmp(If(lEnable,"",If(nTotDin==nTotDinAux,"OK","PCOFXCANCEL")))
For nI:= 1 to Len(aCedulas)
	aCedulas[nI,4]:SetBmp(If(lEnable,"",If(aCedulas[nI,6]==aCedulas[nI,3],"OK","PCOFXCANCEL")))
Next nI

//------- Final folder Dinheiro -------
DEFINE SBUTTON oBtnAct FROM 210,145 TYPE 1 	ENABLE  ACTION (Processa( { || cString:=IA011Save(dDataInno,aCedulas,cCaixa,@cCupom)}, "Aguarde...","Gravando dados"),lRet:=.F.,oDlgCx:End()) OF oDlgCx //Grava SE5, SA6 e imprime
DEFINE SBUTTON oBtnEnd FROM 210,175 TYPE 2  ENABLE	ACTION (lRet:=.F.,oDlgCx:End()) OF oDlgCx	

ACTIVATE MSDIALOG oDlgCx CENTERED  ON INIT (If(lEnable,oBtnAct:Enable(),oBtnAct:Disable()) ,oData:SetFocus())
nValor:=nTotDIn

Return cString

/*
+---------------------------------------------------------------------------+
| Funcao	 : IA011Save | Autor : Marcos Alves          | Data : 28/08/21  |
+---------------------------------------------------------------------------+
|Descricao : Grava cedulas em  SA6 e prepara cString para impressao         |
+---------------------------------------------------------------------------+
| Uso		 : FRTABRCX  			 								  	    |
+---------------------------------------------------------------------------+
*/

Static Function IA011Save(dDataInno,aCedulas,cCaixa,cCupom)
Local cString:=""

cString+=DtoS(dDataBase)+"|"
For nI:= 1 to Len(aCedulas)
	cString+=Str(aCedulas[nI,2],3)+"|"
Next nI

SA6->(dbSeek(xFilial("SA6")+cCaixa))
Reclock("SA6",.F.)
SA6->A6_MENSAGE	:= cString 
SA6->(dbCommit())
SA6->(MsUnLock())

//Prepara cString para Impressao
cString:=IA011Cx01(aCedulas,cCaixa,@cCupom)

Return cString

/*
+---------------------------------------------------------------------------+
| Funcao	 : IA011Cx01| Autor : Marcos Alves          | Data : 28/08/21  |
+---------------------------------------------------------------------------+
|Descricao : Prepara cString para Impressao                                 |
+---------------------------------------------------------------------------+
| Uso		 : FRTABRCX  			 								  	    |
+---------------------------------------------------------------------------+
*/
Static Function IA011Cx01(aCedulas,cCaixa,cCupom)
Local aSemana	:={"Domingo", "Segunda", "Terca","Quarta","Quinta"  , "Sexta", "Sabado"} 	//Descricoes do dia da semana
Local cSemana	:=aSemana[Dow(dDataBase)]													//Identifica qual o dia da semana
Local nI		:=0
Local nX		:=0
Local cPath 	:= "\FECHAMENTO\"+Alltrim(SM0->M0_FILIAL)+"\"		// Caminho para 
Local cFile		:=Alltrim(SM0->M0_FILIAL)+"_"+cCaixa+"_"+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+".TXT"
Local nHdl		:=-1
Local cString	:=""
Local nReg		:=0
Local lRet		:=.F.
Local aCupom	:={}
Local cLinha	:=""
Local cString	:=""
Local nTotDin	:= 0

Private aString	:={}	
																	// Array com as linhas do layout do cupom
cCupom:=U_I999PegDoc(1) //Pega o numero do Documento e incrementa 1

AEval(aCedulas, {|X| nTotDin+=X[3]})

aadd(aString,{"A1","========================================= "+cCupom	,{}})
aadd(aString,{"A2","...............Fundo de Troco Inicial .....v.1.0"	,{}})
aadd(aString,{"A3","Loja...........:AAA BBB                         "	,{SM0->M0_CODFIL+" ",SM0->M0_FILIAL},{}})
aadd(aString,{"A4","Data AAA       :BBB            Hora....:CCC     "	,{cSemana,dToc(dDataBase),Time()},{}})
aadd(aString,{"A5","Caixa..........:AAA                             "	,{cCaixa+"-"+cUserName},{}})
aadd(aString,{"A6","================================================"	,{}})
aadd(aString,{"A7","[Cedula]............[Qtd].............[ Valor  ]"   ,{}})
aadd(aString,{"A8","------------------------------------------------"   ,{}})
aadd(aString,{"A9","["+Transform(aCedulas[1,1],"@E 999.99")+"]............["+Transform(aCedulas[1,2],"@E 999")+"].............["+Transform(aCedulas[1,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B1","["+Transform(aCedulas[2,1],"@E 999.99")+"]............["+Transform(aCedulas[2,2],"@E 999")+"].............["+Transform(aCedulas[2,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B2","["+Transform(aCedulas[3,1],"@E 999.99")+"]............["+Transform(aCedulas[3,2],"@E 999")+"].............["+Transform(aCedulas[3,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B3","["+Transform(aCedulas[4,1],"@E 999.99")+"]............["+Transform(aCedulas[4,2],"@E 999")+"].............["+Transform(aCedulas[4,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B4","["+Transform(aCedulas[5,1],"@E 999.99")+"]............["+Transform(aCedulas[5,2],"@E 999")+"].............["+Transform(aCedulas[5,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B5","["+Transform(aCedulas[6,1],"@E 999.99")+"]............["+Transform(aCedulas[6,2],"@E 999")+"].............["+Transform(aCedulas[6,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B7","["+Transform(aCedulas[7,1],"@E 999.99")+"]............["+Transform(aCedulas[7,2],"@E 999")+"].............["+Transform(aCedulas[7,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B7","["+Transform(aCedulas[8,1],"@E 999.99")+"]............["+Transform(aCedulas[8,2],"@E 999")+"].............["+Transform(aCedulas[8,3],"@E 9,999.99")+"]"  ,{}})
aadd(aString,{"B8","["+Transform(aCedulas[9,1],"@E 999.99")+"]............["+Transform(aCedulas[9,2],"@E 999")+"].............["+Transform(aCedulas[9,3],"@E 9,999.99")+"]"   ,{}})
aadd(aString,{"B9","["+Transform(aCedulas[10,1],"@E 999.99")+"]............["+Transform(aCedulas[10,2],"@E 999")+"].............["+Transform(aCedulas[10,3],"@E 9,999.99")+"]",{}})
aadd(aString,{"C1","["+Transform(aCedulas[11,1],"@E 999.99")+"]............["+Transform(aCedulas[11,2],"@E 999")+"].............["+Transform(aCedulas[11,3],"@E 9,999.99")+"]",{}})
aadd(aString,{"C2","......................................----------",{}})
aadd(aString,{"C3","........................Total Cedulas "+"["+Transform(nTotDin,"@E 9,999.99")+"]",{}})
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","        -----------------------------           "  ,{}})
aadd(aString,{"  ","                 Assinatura                     "	,{}})
aadd(aString,{"  ","                    Caixa                       "	,{}})

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
	cString+=cLinha+Chr(13)+Chr(10)
	aadd(aCupom,cLinha)
Next nI
//Mensagem de impressao.
U_IA999MsgWait(cString,"Impressão de comprovante", 10000)
Return cString


/*
+---------------------------------------------------------------------------+
| Funcao	 : IA011GrvSE5 | Autor : Marcos Alves        | Data : 28/08/21  |
+---------------------------------------------------------------------------+
|Descricao :Grava o Registro no SE5 conforme os parametros recebidos       |
+---------------------------------------------------------------------------+
| Uso		 : FRTABRCX  			 								  	    |
+---------------------------------------------------------------------------+
*/
User Function IA011GrvSE5(cCaixa,cNatureza,cHistor, cMoeda,cRecPag,nValor,cCupom,cTipoDoc)
Local cAgencia  := ""
Local cConta    := ""
Local nDecs1    := MsDecimais(1)

Default cTipoDoc:="TC"

SA6->(dbSeek(xFilial("SA6")+cCaixa))
Reclock("SE5",.T.)
SE5->E5_FILIAL	:= xFilial("SE5")
SE5->E5_DATA	:= dDataBase
SE5->E5_BANCO	:= SA6->A6_COD
SE5->E5_AGENCIA	:= SA6->A6_AGENCIA
SE5->E5_CONTA	:= SA6->A6_NUMCON
SE5->E5_RECPAG	:= cRecPag
SE5->E5_HISTOR	:= cHistor
SE5->E5_TIPODOC	:= cTipoDoc
SE5->E5_MOEDA	:= cMoeda	//If(nCheck=1, aNum[1], "TC")
SE5->E5_VALOR	:= nValor	//aNum[2]
SE5->E5_DTDIGIT	:= dDataBase
//SE5->E5_BENEF	:= cNomEmp
SE5->E5_DTDISPO	:= SE5->E5_DATA
SE5->E5_NATUREZ	:= cNatureza
SE5->E5_SITUA	:= "00" // Criar esse campo para instalacao do Front Loja
SE5->E5_DOCUMEN	:= cCupom
SE5->(dbCommit())
SE5->(MsUnLock())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta geração deve ser efetuada somente qdo chamada do Front Loja             ³
//³pois a tabela SLI tem como única função subir os movimentos para a retaguarda|
//³                                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(Upper(FunName())) == "FRTA271"
	FR271BGerSLI("    ", "050", Str(SE5->(Recno()),17,0), "NOVO")
EndIf

Return NIL

/*
+---------------------------------------------------------------------------+
| Funcao	 : IA011Rest | Autor : Marcos Alves          | Data : 28/08/21  |
+---------------------------------------------------------------------------+
|Descricao : Restaura os valores das moedas do fundo de troco inicial       |
+---------------------------------------------------------------------------+
| Uso		 : FRTABRCX  			 								  	    |
+---------------------------------------------------------------------------+
*/
Static Function IA011Rest(aCedulas,dDataInno,cCaixa)
Local lEnable	:=.F.

aCedulas   	:= {}
nTotDinAux 	:= 0
nTotDin		:= 0

aadd(aCedulas,{0.05  ,0,0,"","",0 })
aadd(aCedulas,{0.10  ,0,0,"","",0 })
aadd(aCedulas,{0.25  ,0,0,"","",0 })
aadd(aCedulas,{0.50  ,0,0,"","",0 })
aadd(aCedulas,{1.00  ,0,0,"","",0 })
aadd(aCedulas,{2.00  ,0,0,"","",0 })
aadd(aCedulas,{5.00  ,0,0,"","",0 })
aadd(aCedulas,{10.00 ,0,0,"","",0 })
aadd(aCedulas,{20.00 ,0,0,"","",0 })
aadd(aCedulas,{50.00 ,0,0,"","",0 })
aadd(aCedulas,{100.00,0,0,"","",0 })

//Verifica se o caixa ja salvou os valores de fundo de troco inicial
SA6->(dbSeek(xFilial("SA6")+cCaixa))
If !Empty(SA6->A6_MENSAGE).and.Subs(SA6->A6_MENSAGE,1,8)==dToS(dDataBase)
	cString:=SA6->A6_MENSAGE
	For nI:=1 to Len(aCedulas)
		cString:=Subs(cString,At("|",cString)+1)
		aCedulas[nI,2]:=Val(Subs(cString,1,3))
		aCedulas[nI,3]:=Val(Subs(cString,1,3))*aCedulas[nI,1]
	Next nI
	lEnable:=.F.
Else
	lEnable:=.T.
EndIf

AEval(aCedulas, {|X| nTotDin+=X[3]})

IA11VldCX(aCedulas,dDataInno,cCaixa)

Return lEnable



/*
+---------------------------------------------------------------------------+
| Funcao	 : IA011VCedulas | Autor : Marcos Alves      | Data : 28/08/21  |
+---------------------------------------------------------------------------+
|Descricao : Valida se o valor digitado e igual valor caixa dia anteerior   |
|coloca ok ou X                                                             |
+---------------------------------------------------------------------------+
| Uso		 : FRTABRCX  			 								  	    |
+---------------------------------------------------------------------------+
*/
Static Function IA011VCedulas(nOp,aCedulas)

aCedulas[nOp,3]:=aCedulas[nOp,1]*aCedulas[nOP,2]
nTotDin:=0
AEval(aCedulas, {|X| nTotDin+=X[3]})
oTotDin:refresh()
If aCedulas[nOp,6]==aCedulas[nOp,3]
	aCedulas[nOp,4]:SetBmp("OK")
else
	aCedulas[nOp,4]:SetBmp("PCOFXCANCEL")
EndIf	
oTotDinFlag:SetBmp(If(nTotDin==nTotDinAux,"OK","PCOFXCANCEL"))

Return .T.


/*
+---------------------------------------------------------------------------+
| Funcao	 : IA11VldCX | Autor : Marcos Alves          | Data : 28/08/21  |
+---------------------------------------------------------------------------+
|Descricao : Valida dados do Data e caixa, buscando valores para compracao  |
+---------------------------------------------------------------------------+
| Uso		 : FRTABRCX  			 								  	    |
+---------------------------------------------------------------------------+
*/
Static Function IA11VldCX(aCedulas,dDataInno,cCaixa,lEnable)
Local lRet := .F.
nTotDinAux := 0

If Empty(dDataInno).OR. Empty(cCaixa)
	MsgInfo("Data ou Caixa","Dados Invalidos")
Else
	//Identifica o numero de vezez que fez a impressao do fechamento
	dbSelectArea("SZY")
	dbSetOrder(1)
	If SZY->(dbSeek(xFilial("SZY")+DToS(dDataInno)+cCaixa))
		//Recupera o valoer em dinheiro do fechamento do dia anterior
		aCedulas[1,6]:=SZY->ZY_DIN005
		aCedulas[2,6]:=SZY->ZY_DIN010
		aCedulas[3,6]:=SZY->ZY_DIN025
		aCedulas[4,6]:=SZY->ZY_DIN050
		aCedulas[5,6]:=SZY->ZY_DIN1
		aCedulas[6,6]:=SZY->ZY_DIN2
		aCedulas[7,6]:=SZY->ZY_DIN5
		aCedulas[8,6]:=SZY->ZY_DIN10
		aCedulas[9,6]:=SZY->ZY_DIN20
		aCedulas[10,6]:=SZY->ZY_DIN50
		aCedulas[11,6]:=SZY->ZY_DIN100

		AEval(aCedulas, {|X| nTotDinAux+=X[6]})
	Else
		MsgInfo("Data/Caixa não encontrado!")
	EndIf	
	lRet:=.T.
EndIf
Return lRet
