#INCLUDE "PROTHEUS.CH"
#Include "AP5Mail.ch"

User Function IA999MsgWait(cCaption,cTitle,nInterval,nAction)
Local oDlg, oBtn, oBtn1, oBtn2, oTimer, oBmp, oFont
Local nLine := 0
Local nTam := 0
Local lRet := .F.
Local nAt
Local cTemp
Local nLargJan
Local nLargSay

DEFAULT cCaption 	:= "Aviso"
DEFAULT cTitle 		:= "Innocencio"
DEFAULT nInterval 	:= 5000
DEFAULT nAction 	:= 1

cTemp 	:= cCaption
cCaption:=""
While !Empty(cTemp).AND.nLine<=13
	nLine += 1
	nAt := At(Chr(13),cTemp)
	If nAt > 0
		cLine := Subs(cTemp,1,nAt-1)
		If Subs(cTemp,nAt+1,1) == Chr(10)
			nAt += 1
		EndIf
		cTemp := Subs(cTemp,nAt+1)
	Else
		cLine := Trim(cTemp)
		cTemp := ""
	EndIf
	nTam := If(Len(cLine) > nTam,Len(cLine),nTam)
	cCaption+=cLine+Chr(13)+chr(10)
End

nTam := If(nTam <= 10,30,nTam)
nTam := If(nTam < Len(Trim(cTitle)),Len(Trim(cTitle))+2,nTam)
nLargJan := (nTam*6)+150
nLargSay := Round(3.10*nTam,0)+40

//DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, 13
DEFINE FONT oFont NAME "Courier New"	  	SIZE 7,19 BOLD

DEFINE MSDIALOG oDlg ;
	FROM 0,0 TO (140+(nLine*10)),nLargJan  ;
	TITLE cTitle STYLE DS_MODALFRAME FONT oFont PIXEL

DEFINE TIMER oTimer INTERVAL nInterval ACTION (lRet := (nAction == 1),oDlg:End()) OF oDlg

@00,00 BITMAP oBmp RESNAME "LOGIN1" oF oDlg SIZE 48,488 NOBORDER WHEN .F. PIXEL

@06,50 SAY cCaption PIXEL SIZE nLargSay,nLine*10
     
@ -150, -150 BUTTON oBtn PROMPT 'ZE' OF oDlg
oBtn:SetFocus()

//DEFINE SBUTTON oBtn2 FROM ((oDlg:nBottom/2)-30),((oDlg:nRight/2)-38) TYPE 2 ENABLE PIXEL ;
//ACTION (lRet := .F.,oDlg:End())
     
DEFINE SBUTTON oBtn1 FROM ((oDlg:nBottom/2)-30),((oDlg:nRight/2)-40) TYPE 1 ENABLE PIXEL ;
ACTION (lRet := .T.,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oTimer:Activate(),	oBtn1:SetFocus())
return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I999Serie        ³Autor  ³Marcos Alves   º Data ³Nov/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ No fonte LOJXFUNA.PRX, funcao LJGetStation, retorna        º±±
±±º          ³ o resultado da funcao do parametro MV_LJSERIE="U_I999Serie"º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA999Serie()
Local cSerie		:="XXX"

If cModulo=="FRT" //Incluido em 07/03/2015 para testar NCC no modul LOJ
	If INNO_V03[1]=="E"
		cSerie:=INNO_SEML 	//Numero de Serie do PDV - Emulator//I9A =I=Innocencio;9=Emulador 99;A=sequencia A..Z - "A9A"= A=Andorinha;9=Emulador 99;A sequencial
	Else
		cSerie:=INNO_SECF	//Numero de serie do ECF  I2A =I=Innocencio;2=ECF 99;A=sequencia A..Z - "A9A"= A=Andorinha;9=Emulador 99;A sequencial
	EndIf
EndIf
Return cSerie 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ InnoGetSenha ³ Autor ³ Marcos Alves      ³ Data ³ 19/03/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta dialogo para o usuario informar a senha              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Emissao de mais de um relatorio de fechamento              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function I999GetSenha()
Local oDlgSenha
Local oGetSenha
Local oGetUsu
Local aRet := {}
Local cUsu := Space(15)
Local cSen := Space(6)

// Autoriza‡„o
DEFINE DIALOG oDlgSenha Of GetWndDefault() TITLE "Autorização" FROM 12, 30 TO 20,55

@ .5,1 SAY "Usuário" 
@ 1.1,1 MSGET oGetUsu VAR cUsu WHEN aConfig()[4]

@ 2,1 SAY "Senha"
@ 2.6,1 MSGET oGetSenha VAR cSen PASSWORD

DEFINE SBUTTON FROM 45,65 TYPE 1 ACTION oDlgSenha:End() ENABLE OF oDlgSenha

ACTIVATE MSDIALOG oDlgSenha CENTERED

AAdd( aRet, PadR( cUsu, 15 ) )
AAdd( aRet, PadR( cSen, 06 ) )

	// Posiciona na senha digitada

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InnoSndKey2      ³Autor  ³Marcos Alves   º Data ³16/02/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia comando para o buffer do teclado (todos)        	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA999SndKey(cKey)
/*
SendKeys routine for 32-bit Delphi.

Written by Ken Henderson

Copyright (c) 1995 Ken Henderson     email:khen@compuserve.com

This unit includes two routines that simulate popular Visual Basic
routines: Sendkeys and AppActivate.  SendKeys takes a PChar
as its first parameter and a boolean as its second, like so:

SendKeys('KeyString', Wait);

where KeyString is a string of key names and modifiers that you want
to send to the current input focus and Wait is a boolean variable or value
that indicates whether SendKeys should wait for each key message to be
processed before proceeding.  See the table below for more information.

AppActivate also takes a PChar as its only parameter, like so:

AppActivate('WindowName');

where WindowName is the name of the window that you want to make the
current input focus.

SendKeys supports the Visual Basic SendKeys syntax, as documented below.

Supported modifiers:

+ = Shift
^ = Control exemplo: '^a' CTRL + A
% = Alt

Surround sequences of characters or key names with parentheses in order to
modify them as a group.  For example, '+abc' shifts only 'a', while '+(abc)' shifts
all three characters.

Supported special characters

~ = Enter
( = Begin modifier group (see above)
) = End modifier group (see above)
{ = Begin key name text (see below)
} = End key name text (see below)

Supported characters:

Any character that can be typed is supported.  Surround the modifier keys
listed above with braces in order to send as normal text.

Supported key names (surround these with braces):

BKSP, BS, BACKSPACE
BREAK
CAPSLOCK
CLEAR
DEL
DELETE
DOWN
END
ENTER
ESC
ESCAPE
F1
F2
F3
F4
F5
F6
F7
F8
F9
F10
F11
F12
F13
F14
F15
F16
HELP
HOME
INS
LEFT
NUMLOCK
PGDN
PGUP
PRTSC
RIGHT
SCROLLLOCK
TAB
UP

Follow the keyname with a space and a number to send the specified key a
given number of times (e.g., {left 6}).
*/

ExeDLLRun2(INNO_HDL, 1, cKey)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FR271FFuncoes  ³ Autor ³ Marcos Alves    ³ Data ³02/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ F12- Funcao Innocencio                                     ³±±
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
User Function I999PegDoc(nFlag)
Local cDOC		:= GetPvProfString("FILIAL_"+cFilAnt, "DOC"		, "", GetClientDir()+"INNO.INI")

Default nFlag := NIL

If nFlag==1
	WritePProString("FILIAL_"+cFilAnt, "DOC"	, StrZero(Val(cDoc)+1,6,0)	, GetClientDir()+"INNO.INI")
EndIf

Return cDoc


/*/                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ACSendMail³ Autor ³ Gustavo Henrique     ³ Data ³ 22/01/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP                 ³±±
±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±±
±±³          ³ ExpC3 : Servidor de SMTP                                     ³±±
±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±±
±±³          ³         de conexao com o servidor SMTP.                      ³±±
±±³          ³ ExpC5 : Conta de destino do e-mail.                          ³±±
±±³          ³ ExpC6 : Assunto do e-mail.                                   ³±±
±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.               	    |±±
±±³          | ExpC8 : Patch com o arquivo que serah enviado                |±±
±±³          | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
±±³          | ExpC10 : Parâmetro por referência, armazena o erro de envio  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                 

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function I999Mail(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,cAttach,lMsg,cLog)

Local cEmailTo := ""
Local cEmailCc := ""
Local lResult  := .F.
Local cError   := ""
Local cUser
Local nAt

Default lMsg := .T.                                                                                      
Default cLog := ""

// Verifica se serao utilizados os valores padrao.
cAccount	:= Iif( cAccount  == NIL, GetMV( "MV_RELACNT" ), cAccount  )
cPassword	:= Iif( cPassword == NIL, GetMV( "MV_RELPSW"  ), cPassword )
cServer		:= Iif( cServer   == NIL, GetMV( "MV_RELSERV" ), cServer   )
cAttach 	:= Iif( cAttach == NIL, "", cAttach )
cFrom		:= Iif( cFrom == NIL, Iif( Empty(GetMV( "MV_RELFROM" )), GetMV( "MV_RELACNT" ), GetMV( "MV_RELFROM" ) ), cFrom )  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEmailTo := SubStr(cEmail,1,At(Chr(59),cEmail)-1)
cEmailCc := SubStr(cEmail,At(Chr(59),cEmail)+1,Len(cEmail))

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Servidor de EMAIL necessita de Autenticacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if lResult .and. GetMv("MV_RELAUTH")
	//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	lResult := MailAuth(cAccount, cPassword)
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	if !lResult
		nAt 	:= At("@",cAccount)
		cUser 	:= If(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
		lResult := MailAuth(cUser, cPassword)
	endif
endif

If lResult
	SEND MAIL FROM cFrom ;
	TO      	cEmailTo;
	CC     		cEmailCc;
	SUBJECT 	 cAssunto;
	BODY    	 cMensagem;
	ATTACHMENT  cAttach  ;
	RESULT lResult
	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		If lMsg
			Help(" ",1,"ATENCAO",,"Não foi possível enviar o e-mail para:" + cEmailTo +" ."+ "Verifique se o e-mail está cadastrado corretamente!",4,5)
		EndIf
		cLog := "Não foi possível enviar o e-mail para:" + cEmailTo 	
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	If lMsg		
		Help(" ",1,"ATENCAO",,"Não foi possível conectar com o servidor SMTP!" +" "+ "Mensagem de Erro:"+cError,4,5)
	EndIf
	cLog := "Não foi possível conectar com o servidor SMTP!" +" "+ "Mensagem de Erro:"+cError	
EndIf

Return(lResult)   


User Function IA999aVld(cCodProd)
Local lRet :=.T.
Local aSB1Area:=GetArea("SB1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa por Codigo do Produto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cCodProd)       
	SB1->(dbSetOrder( 1 ))
	If !SB1->(dbSeek( xFilial("SB1")+cCodProd))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa por Codigo de Barra  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(dbSetOrder( 5 ))
		If !SB1->(dbSeek( xFilial("SB1")+cCodProd))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pesquisa por Codigo de Barra no Cad de Codigo de Barra  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SLK" )
			dbSetOrder( 1 )
			If !dbSeek( xFilial("SLK")+cCodProd)
				lRet	:=.F.
				cMsg	:="Produto nao cadastrado"
				cCodProd:= Space(6)
			Else
				cCodProd := SLK->LK_CODIGO
			EndIf
		Else
			cCodProd:= SB1->B1_COD
			lRet	:=.T.
		EndIf
	Else
		cCodProd := SB1->B1_COD
		lRet	 :=.T.
	EndIf
	If !ExistCPO("SB1", cCodProd,1)
		cCodProd:= Space(6)
		lRet	:=.F.
     EndIf
EndIf

If lRet			
	M->C7_PRODUTO:=cCodProd
	lRet:=A093PROD().And.A120COD().And.MaFisRef("IT_PRODUTO","MT120",M->C7_PRODUTO).And.A120Tabela() .And. A120Produto(M->C7_PRODUTO)     
EndIf	

Return lRet


User Function IA999bVld(cCodProd)
Local lRet :=.T.
Local aSB1Area:=GetArea("SB1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa por Codigo do Produto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cCodProd)       
	SB1->(dbSetOrder( 1 ))
	If !SB1->(dbSeek( xFilial("SB1")+cCodProd))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa por Codigo de Barra  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SB1->(dbSetOrder( 5 ))
		If !SB1->(dbSeek( xFilial("SB1")+cCodProd))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pesquisa por Codigo de Barra no Cad de Codigo de Barra  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SLK" )
			dbSetOrder( 1 )
			If !dbSeek( xFilial("SLK")+cCodProd)
				lRet	:=.F.
				cMsg	:="Produto nao cadastrado"
				cCodProd:= Space(6)
			Else
				cCodProd := SLK->LK_CODIGO
			EndIf
		Else
			cCodProd:= SB1->B1_COD
			lRet	:=.T.
		EndIf
	Else
		cCodProd := SB1->B1_COD
		lRet	 :=.T.
	EndIf
	If !ExistCPO("SB1", cCodProd,1)
		cCodProd:= Space(6)
		lRet	:=.F.
     EndIf
EndIf

If lRet			
	M->D1_COD:=cCodProd
	lRet:=Vazio().or.(A093Prod().And.MaFisRef("IT_PRODUTO","MT100",M->D1_COD))                                                            
EndIf
     
Return lRet
