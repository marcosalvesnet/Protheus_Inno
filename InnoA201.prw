#Include "Protheus.ch"

User Function InnoSndFec(cPathFile,cString)
Local nVz		:=0
Local cError	:=""
Local lSendOk 	:=.F.
Local cCaixa	:=xNumCaixa()
Local cAccount 	:=GetMV( "MV_RELACNT" )
Local cPassword :=GetMV( "MV_RELPSW"  )
Local cServer 	:=GetMV( "MV_RELSERV" )
Local cFrom 	:=GetMV( "MV_RELACNT" )
Local cData		:=Subs(Right(cPathFile,16),1,2)+"/"+Subs(Right(cPathFile,16),3,2)+"/"+Subs(Right(cPathFile,16),5,4)
Local cPath 	:= "\FECHAMENTO\"+Alltrim(SM0->M0_FILIAL)+"\"		// Caminho para 
Local cFile		:=Alltrim(SM0->M0_FILIAL)+"_"+cCaixa+"_"+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Strzero(Year(dDataBase),4)+".TXT"

Local cAssunto	:= Left(Right(cPathFile,33),29)+" - "+cUserName
Local cDest		:=GetPvProfString( "MAIL" , "Destinatarios" , "" , GetAdv97() )
//Local cDest		:="marcos@doceirainnocencio.com.br;marcos.alves@doceirainnocencio.com.br"
Local cMensagem	:=	subs(cString,1,600)

ProcRegua(3)
While !lSendOk.And.nVz<=3
	cError	:=""
	IncProc()
	lSendOk := ACSendMail(cAccount,cPassword,cServer,cFrom,cDest+Chr(59),cAssunto,cMensagem,cPathFile ,.F.,@cError)
	ConOut(dtoc(Date())+" "+Time()+" Fechamento Caixa ["+cFile+"]") //
	ConOut(dtoc(Date())+" "+Time()+" Envio por e-mail para - "+cDest+"["+If(lSendOk,"OK",cError)+"]") //
    //
	//If !lSendOk
    //   	If !MsgYesNo("Erro no envio do e-mail, nova tentativa?")
    //   		Exit
	//	EndIf       		
	//EndIf
	nVz++
End	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjRpcConsultaºAutor³ Vendas Clientes   º Data ³  06/05/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a conecao RPC com o servidor para consultar o saldo     º±±
±±º          ³em estoque.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA201ConsRPC( cCliente, cLojaCli)
Local aRetorno 	:= {}
Local oServer
Local aTabelas	:={'SA1','SL1','SL2','SL4','SE1'}

Private aRet		:= {}

ConOut("IA201ConsRPC -"+dtoc(dDataBase)+"-"+Time()+". Tentando estabelecer comunicacao com o Server ") // "Tentando estabelecer comunicacao com o Server "

//Conexao com servidor para gravar os dados diretamente na retaguarda
Processa( { || aRet:=U_IA201SrvRPC( aTabelas)}, "Aguarde...","Conectando com o servidor")

If !aRet[1]
	MsgInfo("Conexão com Servidor nao disponivel, verifique rede")
Else
	oServer:=aRet[2]
	aRetorno := oServer:CallProc("U_IA201SldRPC", cCliente,cLojaCli )
	oServer:CallProc( 'DbCloseAll' )
	oServer:Disconnect()
EndIf

Return (aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³            ºAutor³                    º Data ³  25/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA201SldRPC( cCliente,cLojaCli )
Local aRet   := {}
Local aQuant := {}

ConOut("IA201SldRPC -"+dtoc(dDataBase)+"-"+Time()+".Consulta Saldo do cliente :"+cCliente+"/"+cLojaCli ) 

aadd(aRet, Posicione("SA1",1,xFilial("SA1")+cCliente+cLojaCli,"A1_LC"))
aadd(aRet, Posicione("SA1",1,xFilial("SA1")+cCliente+cLojaCli,"A1_SALDUP"))

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³I201CalcCedulas ³ Autor ³ Marcos Alves    ³ Data ³ 30/03/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Calcar o valor total de dinheiro baseado no numero de       ³±±
±±³           ³Cedula                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function I201CalcCedulas(aCedulas)
Local ODlgCx

Local oFntCx
Local oFntCx2
Local lRetVld	:=.F.
Local lRet		:=.F.
Local oBmp 
Local nI		:=0
Local oTotal
Local nTotal 	:=0

If Len(aCedulas)<11
	aCedulas := {}
	aadd(aCedulas,{0.05,0,0})
	aadd(aCedulas,{0.10,0,0})
	aadd(aCedulas,{0.25,0,0})
	aadd(aCedulas,{0.50,0,0})
	aadd(aCedulas,{1.00,0,0})
	aadd(aCedulas,{2.00,0,0})
	aadd(aCedulas,{5.00,0,0})
	aadd(aCedulas,{10.00,0,0})
	aadd(aCedulas,{20.00,0,0})
	aadd(aCedulas,{50.00,0,0})
	aadd(aCedulas,{100.00,0,0})
EndIf	
AEval(aCedulas, {|X| nTotal+=X[3]})

DEFINE MSDIALOG ODlgCx FROM 1,1 TO 425,250 TITLE "Calculo de valores" PIXEL OF GetWndDefault()

DEFINE FONT oFntCx	NAME "Courier New"	   	SIZE 7,19 BOLD
DEFINE FONT oFntCx2 NAME "Courier New"     	SIZE 8,16 BOLD      
DEFINE FONT oFntCx3	NAME "Arial" 			SIZE 15,38			

@ 005, 004 TO 195, 120 LABEL  PIXEL OF oDlgCx

nLin:=10
@ nLin,010 SAY "   Cédula              Qtd                Valor " PIXEL SIZE 150,18 //COLOR CLR_WHITE,CLR_BLACK //FONT oFntCx

nLin+=8
@ nLin,010 MSGET aCedulas[1,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[1,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[1,3]:=aCedulas[1,1]*aCedulas[1,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[1,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 
	
nLin+=15
@ nLin,010 MSGET aCedulas[2,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[2,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[2,3]:=aCedulas[2,1]*aCedulas[2,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[2,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[3,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[3,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[3,3]:=aCedulas[3,1]*aCedulas[3,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[3,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[4,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[4,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[4,3]:=aCedulas[4,1]*aCedulas[4,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[4,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[5,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[5,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[5,3]:=aCedulas[5,1]*aCedulas[5,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[5,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[6,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[6,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[6,3]:=aCedulas[6,1]*aCedulas[6,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[6,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[7,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[7,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[7,3]:=aCedulas[7,1]*aCedulas[7,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[7,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[8,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[8,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[8,3]:=aCedulas[8,1]*aCedulas[8,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[8,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[9,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[9,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[9,3]:=aCedulas[9,1]*aCedulas[9,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[9,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[10,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[10,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[10,3]:=aCedulas[10,1]*aCedulas[10,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[10,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,010 MSGET aCedulas[11,1] Picture "@E 999.99" SIZE 10,10 OF ODlgCx  PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[11,2] Picture "@E 999" SIZE 10,10 OF ODlgCx  PIXEL RIGHT VALID {|| aCedulas[11,3]:=aCedulas[11,1]*aCedulas[11,2],nTotal:=0,AEval(aCedulas, {|X| nTotal+=X[3]}),oTotal:refresh(),.T.}
@ nLin,075 MSGET aCedulas[11,3] Picture "@E 9,999.99" SIZE 20,10 OF ODlgCx PIXEL RIGHT WHEN .F. 

nLin+=15
@ nLin,015 SAY "Total" FONT oFntCx2 PIXEL SIZE 150,18 //COLOR CLR_WHITE,CLR_BLACK //FONT oFntCx
@ nLin,067 SAY oTotal VAR Transform(nTotal,"@E 999,999.99") FONT oFntCx2 PIXEL SIZE 150,18 //COLOR CLR_WHITE,CLR_BLACK //FONT oFntCx

DEFINE SBUTTON oBtnAct FROM 200,50 TYPE 1 ENABLE ACTION (lRet:=.T.,oDlgCx:End()) OF oDlgCx
DEFINE SBUTTON oBtnEnd FROM 200,90 TYPE 2 ENABLE ACTION (lRet:=.F.,oDlgCx:End()) OF oDlgCx	

ACTIVATE MSDIALOG oDlgCx CENTER //ON INIT (oDinheiro:SetFocus())

If !lRet
	nTotal:=0
EndIf	

Return nTotal


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³I223ImpRecibo    ³Autor  ³Marcos Alves   º Data ³18/03/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impessao do vale de compra dos Funcionarios				  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function I201ImpCedulas(aCedulas,dData,cCaixa)
Local cString :=""
Local nPos:=0
Local nTotal:=0

AEval(aCedulas, {|X| nTotal+=X[3]})

ProcRegua(3)
cString+="================================================"+Chr(13)+Chr(10)
cString+="..............Calculo das Cedulas..............."+Chr(13)+Chr(10)
cString+="                                                "	+Chr(13)+Chr(10)
cString+="Data...........:"+dtoc(dData)+"       Hora....:"+Time()+Chr(13)+Chr(10)
cString+="Caixa..........:"+cCaixa+Chr(13)+Chr(10)
cString+="================================================"+Chr(13)+Chr(10)
cString+="     [Cedula]     [Qtd]     [ Valor  ]        "+Chr(13)+Chr(10)  
cString+="     --------     -----     ----------        "+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[1,1],"@E 999.99")+"]     ["+Transform(aCedulas[1,2],"@E 999")+"]     ["+Transform(aCedulas[1,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[2,1],"@E 999.99")+"]     ["+Transform(aCedulas[2,2],"@E 999")+"]     ["+Transform(aCedulas[2,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[3,1],"@E 999.99")+"]     ["+Transform(aCedulas[3,2],"@E 999")+"]     ["+Transform(aCedulas[3,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[4,1],"@E 999.99")+"]     ["+Transform(aCedulas[4,2],"@E 999")+"]     ["+Transform(aCedulas[4,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[5,1],"@E 999.99")+"]     ["+Transform(aCedulas[5,2],"@E 999")+"]     ["+Transform(aCedulas[5,3],"@E 9,999.99")+"]   "+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[6,1],"@E 999.99")+"]     ["+Transform(aCedulas[6,2],"@E 999")+"]     ["+Transform(aCedulas[6,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[7,1],"@E 999.99")+"]     ["+Transform(aCedulas[7,2],"@E 999")+"]     ["+Transform(aCedulas[7,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[8,1],"@E 999.99")+"]     ["+Transform(aCedulas[8,2],"@E 999")+"]     ["+Transform(aCedulas[8,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[9,1],"@E 999.99")+"]     ["+Transform(aCedulas[9,2],"@E 999")+"]     ["+Transform(aCedulas[9,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[10,1],"@E 999.99")+"]     ["+Transform(aCedulas[10,2],"@E 999")+"]     ["+Transform(aCedulas[10,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="     ["+Transform(aCedulas[11,1],"@E 999.99")+"]     ["+Transform(aCedulas[11,2],"@E 999")+"]     ["+Transform(aCedulas[11,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="                            ----------"+Chr(13)+Chr(10)
cString+="                      Total "+"["+Transform(nTotal,"@E 9,999.99")+"]"+Chr(13)+Chr(10)
nPos:=(44-Len("Contado por:"))/2
cString+="                                                "+Chr(13)+Chr(10)
cString+="------------------------------------------------"+Chr(13)+Chr(10)
cString+=space(nPos)+"Contado por:"+Chr(13)+Chr(10)
IncProc()

U_F1299Inno("F")  
nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
IncProc()

If (nRet == 0 .OR. nRet == 7)
	If (nRet := IFRelGer(nHdlECF, cString)) <> 0 
		// "Não foi possível realizar a Abertura do Caixa. Erro na impressão do comprovante.", "Atenção"
		HELP(' ',1,'FRT021')
	EndIf
EndIf

IncProc()
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I201EstRPC   ºAutor³ Vendas Clientes   º Data ³  31/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o saldo em estoque da retaguarda dos itens do array º±±
±±º          ³.                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function I201EstRPC( cRPCServer , nRPCPort , cRPCEnv  , cRPCEmp , ;
                        cRPCFilial , aProd)

Local aRetorno := aProd
Local oServer

ConOut("I201EstRPC -"+dtoc(dDataBase)+"-"+Time()+"Filial:"+cRPCFilial+" . Tentando estabelecer comunicacao com o Server ") // "Tentando estabelecer comunicacao com o Server "

oServer := TRPC():New( cRPCEnv )
If oServer:Connect( cRpcServer, nRPCPort )
	oServer:CallProc("RPCSetType", 3 )
	oServer:CallProc("RPCSetEnv", cRPCEmp, cRPCFilial,,,,, {'SA1','SL1','SL2','SL4','SE1','SB2'})

	ConOut("I201EstRPC-"+dtoc(dDataBase)+"-"+Time()+". Conexao estabelecida com o servidor "+cRPCServer+ " / "+"Filial:"+cRPCFilial) // "Conexao estabelecida com o servidor " / " Loja "
	aRetorno := oServer:CallProc("U_I201SaldoRpc", aProd )

	oServer:CallProc( 'DbCloseAll' )
	oServer:Disconnect()
Else
	ConOut("I201EstRPC-"+dtoc(dDataBase)+"-"+Time()+". Nao foi possivel estabelecer conexao com o servidor "+cRPCServer+ " /" +"Filial:"+cRPCFilial) // "Nao foi possivel estabelecer conexao com o servidor" / " Loja "
EndIf

Return (aRetorno)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³            ºAutor³                    º Data ³  25/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function I201SaldoRpc( aProd )
Local aRet 	:= aProd
Local nI	:=0
Local cLocPad:=""

ConOut("I201SaldoRpc-"+dtoc(dDataBase)+"-"+Time()+". Consulta Saldo do Estoque" ) 

For nI:=1 to Len(aRet)
	//ConOut("I201SaldoRpc- Pesquisando SBZ:"+xFilial("SBZ")+aRet[nI,1] ) 
	//ConOut("I201SaldoRpc- Pesquisando SB2:"+xFilial("SB2")+aRet[nI,1]+SBZ->BZ_LOCPAD ) 

	cLocPad:=Posicione("SBZ",1,xFilial("SBZ")+aRet[nI,1],"BZ_LOCPAD")
	Posicione("SB2",1,xFilial("SB2")+aRet[nI,1]+cLocPad,"B2_COD")
	aRet[nI,4]:=SaldoSB2()
Next nI

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LjRpcConsultaºAutor³ Vendas Clientes   º Data ³  06/05/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a conecao RPC com o servidor para consultar o saldo     º±±
±±º          ³em estoque.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA201SrvRPC( aTabelas)
Local aRetorno := {}
Local oServer
Local cRPCServer	:= AllTrim(SLG->LG_RPCSRV)
Local nRPCPort		:= Val(AllTrim(SLG->LG_RPCPORT))	
Local cRPCEnv		:= AllTrim(SLG->LG_RPCENV)
Local cRPCEmp 		:= SLG->LG_RPCEMP
Local cRPCFilial	:= SLG->LG_RPCFIL
Local oServer		:= NIL
Local lShow			:= .T.
Local lRet			:= .T.

Default aTabelas	:={'SA1','SL1','SL2','SL4','SE1'}

oServer := TRPC():New( cRPCEnv )
If oServer:Connect( cRpcServer, nRPCPort )
	oServer:CallProc("RPCSetType", 3 )
	oServer:CallProc("RPCSetEnv", cRPCEmp, cRPCFilial,,,,, aTabelas)
	ConOut("IA201SrvRPC -"+dtoc(dDataBase)+"-"+Time()+". Conexao estabelecida com o servidor "+cRPCServer+ " / "+" Filial " + cRPCFilial) // "Conexao estabelecida com o servidor " / " Loja "
Else
	lRet := .F.
	If lShow
		MsgInfo("IA201SrvRPC - Nao foi possivel estabelecer conexao com o servidor "+cRPCServer+ " /  Filial " + cRPCFilial+" verifique conexão de rede")
	Else		
		ConOut("IA201SrvRPC - "+dtoc(dDataBase)+"-"+Time()+". Nao foi possivel estabelecer conexao com o servidor "+cRPCServer+ " / Filial " + cRPCFilial) // "Nao foi possivel estabelecer conexao com o servidor" / " Loja "
	EndIf		
EndIf

Return {lRet,oServer}
