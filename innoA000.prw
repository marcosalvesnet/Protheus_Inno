#Include "ap5mail.ch"
#Include "Protheus.ch"
#INCLUDE "COLORS.CH"


#define X3_USADO_EMUSO "€€€€€€€€€€€€€€ "
#define X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"
#define X3_USADO_NAOALTERA "€€€€€€€€€€€€€€° "		//Nao permite alteracao do campo
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³UpdInno   ³ Autor ³Marcos Alves           ³ Data ³ 28/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Programa de atualizacao do dicionario de dados:             ³±±
±±³          ³SX2		                                                  ³±±
±±³          ³	-SZZ	                                                  ³±±
±±³          ³SIX		                                                  ³±±
±±³          ³	-SZZ 	                                                  ³±±
±±³          ³SX3		                                                  ³±±
±±³          ³	-SZX                                                      ³±±
±±³          ³	-SZZ	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Atualizacao do Inno                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UPDInno()

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil
PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd 

Set Dele On

lHistorico 	:= MsgYesNo("Deseja efetuar a atualizacao dos Dicionarios ? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup dos dicionarios e da Base de Dados antes da atualizacao para eventuais falhas de atualizacao e Ligue o servidor Licenças!", "Atenção !")
lEmpenho	:= .F.
lAtuMnu		:= .F.

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Atualizacao da Base de dados Pacote 1 - Fev/2017"

//ACTIVATE WINDOW oMainWnd ON INIT If(lHistorico,(Processa({|lEnd| InnoProc(@lEnd)},"Processando","Aguarde , processando preparacao dos arquivos",.T.), oMainWnd:End() ), oMainWnd:End() )
ACTIVATE WINDOW oMainWnd ON INIT If(lHistorico,(Processa({|lEnd| IA000Proc(@lEnd)},"Processando","Aguarde , processando preparacao dos arquivos",.T.), oMainWnd:End() ), oMainWnd:End() )

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³InnoProc  ³ Autor ³Marcos Alves           ³ Data ³ 28/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao dos arquivos            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA000Proc(lEnd)

Local cTexto    := ''
Local cFile     :=""
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo   := "DM"
Local nRecno    := 0
Local nI        := 0
Local nX		:= 0
Local aRecnoSM0 := {}     
Local lOpen     := .F. 

ProcRegua(3)
IncProc("Verificando se os dicionarios estao liberados....")

If !MyOpenSm0Ex()
	Return Nil
EndIf

dbSelectArea("SM0")
dbGotop()
While !Eof()
	Aadd(aRecnoSM0,SM0->(RECNO()))
	dbSkip()
EndDo
/*	
For nI := 1 To Len(aRecnoSM0)
	SM0->(dbGoto(aRecnoSM0[nI]))
	RpcSetType(2) 
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	RpcClearEnv()
	If !( lOpen := MyOpenSm0Ex() )
		Exit 
	EndIf 
Next nI
*/
lOpen:=.T. //COMANTAR QUANDO PRECISAR DAS DUAS LOJAS

If lOpen
	cTexto :=""
	For nI := 1 To Len(aRecnoSM0) //NI:= 1 TO QUANDO PRECISAR DAS DUAS LOJAS 
		SM0->(dbGoto(aRecnoSM0[nI]))
		RpcSetType(2) 
		RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)

		cTexto += Replicate("-",128)+CHR(13)+CHR(10)
		cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
		set date brit
		//cTexto:=I000SL4Parc(cTexto) //- Parcela no SL4

		//cTexto:=I000Cielo3(cTexto)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os dicionario de indices³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//IncProc("Analisando Dicionario de Indices...SXB")
		//cTexto += AtuSXBInno()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza os dicionario de indices³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//IncProc("Analisando Dicionario de Indices...SIX")
		cTexto += AtuSIXInno()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o dicionario de arquivos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//IncProc("Analisando Dicionario de Arquivos...")
		//cTexto += AtuSX2Inno()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o dicionario de dados   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//IncProc("Analisando Dicionario de Dados...SX3")
		//cTexto += AtuSX3Inno()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o dicionario de dados   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//IncProc("Analisando Dicionario de Dados...SX5")
		//cTexto += AtuSX5Inno()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o dicionario de dados   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//IncProc("Analisando Dicionario de Dados...SX6")
		//cTexto += AtuSX6Inno()

		ProcRegua(Len(aArqUpd))
		__SetX31Mode(.F.)
		For nX := 1 To Len(aArqUpd)
			IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]"+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
			If Select(aArqUpd[nx])>0
				dbSelecTArea(aArqUpd[nx])
				dbCloseArea()
			EndIf
			X31UpdTable(aArqUpd[nx])
			If __GetX31Error()
				Alert(__GetX31Trace())
				Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
				cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
			EndIf
		Next nX		
	
		//dbSelectArea("SZZ")
		SM0->(dbSkip())
		nRecno := SM0->(Recno())
		SM0->(dbSkip(-1))
		RpcClearEnv()
		OpenSm0Excl()
		SM0->(DbGoTo(nRecno)) 
	Next nI 
	cPath:=GetSrvProfString("RootPath","")+"\DATA\"

	cTexto := "Log da atualizacao do Dicionário Inno"+CHR(13)+CHR(10)+cTexto
	__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
	DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
	DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida com sucesso!" From 3,0 to 340,417 PIXEL
	@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont
	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	ACTIVATE MSDIALOG oDlg CENTER

Endif

    
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AtuSIXInno³ Autor ³Marcos Alves           ³ Data ³ 28/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SIX                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSIXInno()

Local cTexto := ''
Local lSIX	 := .F.
Local lNew	 := .F.
Local aSIX   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cAlias := ''

aEstrut:= {}
aadd(aEstrut,"INDICE")
aadd(aEstrut,"ORDEM")
aadd(aEstrut,"CHAVE")
aadd(aEstrut,"DESCRICAO")
aadd(aEstrut,"DESCSPA")
aadd(aEstrut,"DESCENG")
aadd(aEstrut,"PROPRI")
aadd(aEstrut,"F3")
aadd(aEstrut,"NICKNAME")
aadd(aEstrut,"SHOWPESQ")

Aadd(aSIX,{"SZZ","3","ZZ_FILIAL+DTOS(ZZ_DATA)","Data","Data","Data","N","","" ,"S"})

Aadd(aSIX,{"SZS","4","ZS_FILIAL+ZS_DOCTEF" ,"DOCTEF" ,"DOCTEF" ,"DOCTEF" ,"N","","ZS_DOCTEF" ,"S"})
Aadd(aSIX,{"SZS","5","ZS_FILIAL+ZS_AUTORIZ","AUTORIZ","AUTORIZ","AUTORIZ","N","","ZS_AUTORIZ" ,"S"})

Aadd(aSIX,{"SL4","A","L4_FILIAL+L4_DOCTEF" ,"DOCTEF" ,"DOCTEF" ,"DOCTEF" ,"N","","L4_DOCTEF"  ,"S"})
Aadd(aSIX,{"SL4","B","L4_FILIAL+L4_AUTORIZ","AUTORIZ","AUTORIZ","AUTORIZ","N","","L4_AUTORIZ" ,"S"})

ProcRegua(Len(aSIX))

dbSelectArea("SIX")
dbSetOrder(1)

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !dbSeek(aSIX[i,1]+aSIX[i,2])
			lNew:= .T.
		Else
			lNew:= .F.
		EndIf

		lSIX := .T.
		If !(aSIX[i,1]$cAlias)
			cAlias += aSIX[i,1]+"/"
		EndIf

		RecLock("SIX",lNew)
		For j:=1 To Len(aSIX[i])
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
			EndIf
		Next j
		dbCommit()
		MsUnLock()
		IncProc("Atualizando Indices...")
	EndIf
Next i

If lSIX
	cTexto += "Tabela de Indices foi alterada. Favor reindexar a tabela: "+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AtuSX3Inno³ Autor ³Marcos Alves           ³ Data ³ 28/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao do SX3                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSX3Inno()

Local aSX3   := {}
Local i      := 0
Local j      := 0
Local lSX3	 := .F.
Local cTexto := ''
Local cAlias := ''
Local aSX3Stru:={}
Private aEstrut:= {}

dbSelectArea("SX3")
dbSetOrder(2)


aSX3Stru:=SX3->(dbStruct())
For nI:=1 to Len(aSX3Stru)
    aadd(aEstrut,aSX3Stru[nI,1])
Next nI

/* / Modelo SX3	- Protheus 11
Aadd(aSX3,{})
Aadd(aSX3[1],{"SA1"})                             // 	X3_ARQUIVO
Aadd(aSX3[1],{"01"})                              // 	X3_ORDEM
Aadd(aSX3[1],{"A1_FILIAL"})                       // 	X3_CAMPO
Aadd(aSX3[1],{"C"})                               // 	X3_TIPO
Aadd(aSX3[1],{2})	                              // 	X3_TAMANHO
Aadd(aSX3[1],{0})   	                          // 	X3_DECIMAL
Aadd(aSX3[1],{"Filial"})                          // 	X3_TITULO
Aadd(aSX3[1],{""})                                // 	X3_TITSPA
Aadd(aSX3[1],{"Branch"})                          // 	X3_TITENG
Aadd(aSX3[1],{"Filial do Sistema"})               // 	X3_DESCRIC
Aadd(aSX3[1],{"Sucursal del Sistema"})            // 	X3_DESCSPA
Aadd(aSX3[1],{"System Branch"})                   // 	X3_DESCENG
Aadd(aSX3[1],{""})                                // 	X3_PICTURE
Aadd(aSX3[1],{""})                                // 	X3_VALID
Aadd(aSX3[1],{"€€€€€€€€€€€€€€€"})                 // 	X3_USADO
Aadd(aSX3[1],{""})                                // 	X3_RELACAO
Aadd(aSX3[1],{""})                                // 	X3_F3
Aadd(aSX3[1],{1})                                 // 	X3_NIVEL
Aadd(aSX3[1],{"€€"})                              // 	X3_RESERV
Aadd(aSX3[1],{" "})                               // 	X3_CHECK
Aadd(aSX3[1],{" "})                               // 	X3_TRIGGER
Aadd(aSX3[1],{" "})                               // 	X3_PROPRI
Aadd(aSX3[1],{"N"})                               // 	X3_BROWSE
Aadd(aSX3[1],{" "})                               // 	X3_VISUAL
Aadd(aSX3[1],{" "})                               // 	X3_CONTEXT
Aadd(aSX3[1],{" "})                               // 	X3_OBRIGAT
Aadd(aSX3[1],{""})                                // 	X3_VLDUSER
Aadd(aSX3[1],{""})                                // 	X3_CBOX
Aadd(aSX3[1],{""})                                // 	X3_CBOXSPA
Aadd(aSX3[1],{""})                                // 	X3_CBOXENG
Aadd(aSX3[1],{""})                                // 	X3_PICTVAR
Aadd(aSX3[1],{""})                                // 	X3_WHEN
Aadd(aSX3[1],{""})                                // 	X3_INIBRW
Aadd(aSX3[1],{"033"})                             // 	X3_GRPSXG
Aadd(aSX3[1],{"1"})                               // 	X3_FOLDER
Aadd(aSX3[1],{"S"})                               // 	X3_PYME
Aadd(aSX3[1],{""})                                // 	X3_CONDSQL
Aadd(aSX3[1],{""})                                // 	X3_CHKSQL
Aadd(aSX3[1],{"N"})                               // 	X3_IDXSRV
Aadd(aSX3[1],{"N"})                               // 	X3_ORTOGRA
Aadd(aSX3[1],{"N"})                               // 	X3_IDXFLD
Aadd(aSX3[1],{""})                                // 	X3_TELA
Aadd(aSX3[1],{""})                                // 	X3_AGRUP
Aadd(aSX3[1],{" "})                               // 	X3_POSLGT

Aadd(aSX3,{"SZV","01","ZV_FILIAL"	,"C"	,02,0 	,"Filial"	,"" ,""  ,"Filial do Sistema"          ,""    ,"" ,"@!"				,"","€€€€€€€€€€€€€€€",""                             ,"",1,"€€"," "," "," ","N"," "," "," ","",""                  ,"","","","","",""," ","S","","","N","N","N"})
Aadd(aSX3,{"SZV","05","ZV_ITENS"	,"N" 	,4,0  	,"Itens"	,""  ,"" ,"Itens na lista     "        ,""    ,"" ,"@E 9999"      	,"","€€€€€€€€€€€€€€°",""                             ,"",1,"˜À"," ","S"," ","S","V","R"," ","",""                  ,"","","","","",""," "," ","",""," "," "," "})

Aadd(aSX3,{"SZU","01","ZU_FILIAL"  ,"C",02,0 ,"Filial"       ,"" ,""  ,"Filial do Sistema"          ,""    ,"" ,"@!"				,"","€€€€€€€€€€€€€€€","","",1,"€€"," "," "," ","N"," "," "," ","","","","","","","",""," ","S","","" ,"N","N","N"})
Aadd(aSX3,{"SZU","02","ZU_CODTAB"  ,"C",03,0 ,"Codigo"       ,"" ,""  ,"Codigo da lista"            ,""    ,"" ,"@X"				,"","ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ","","",1,"Ç¿" ," "," ","U","N"," "," "," ","","","","","","","",""," ","S","","" ,"N","N","N"})
Aadd(aSX3,{"SZU","03","ZU_ITEM"		,"C",3,0  ,"Item"         ,"",""   ,"Item do Orcamento"          ,""   ,""  ,""               ,""                                 ,"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†","",""    ,1,"êÄ" ," "," ","U","S","A"," "," ","","","","","","","",""," ","S","","" ,"N","N","N"})
Aadd(aSX3,{"SZU","04","ZU_CODPRO"  ,"C",15,0,"Produto"       ,"" ,""  ,"Codigo do Produto"          ,""    ,"" ,"@!"              ,"ExistCpo('SB1') .And. SeleOpc(3)","ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†","","SB1" ,1,"ÉÄ" ," ","S","U","S"," "," "," ","","","","","","","",""," ","S","","" ,"N","N","N"})
Aadd(aSX3,{"SZU","05","ZU_DESCRI"  ,"C",30,0,"Descricao"     ,"" ,""  ,"Descricao do produto       ",""    ,"" ,"@X"              ,"","€€€€€€€€€€€€€€ ","IF(!INCLUI,Posicione('SB1',1,xFilial('SB1')+SZU->ZU_CODPRO,'B1_DESC'),'')" ,"",1,"’À"," "," ","U","S","V","V"," ","Texto()","","","","","","","","","S","N","N","N"})
Aadd(aSX3,{"SZU","09","ZU_GRUPOLST","C",15,0  ,"Grupo Lista" ,"",""   ,"Grupo da lista Inventario"  ,""   ,""  ,""               ,""  ,"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†","","SZUSX5",1,"êÄ"," "," ","U","S","A","R"," ","","","","","","","",""," ","S","","" ,"N","N","N"})
Aadd(aSX3,{"SZU","13","ZU_FLAG"	    ,"C",1,0  ,"Flag"         ,"",""   ,"Flag de inventario"         ,""   ,""  ,""               ,""                                 ,"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ†","",""    ,1,"êÄ" ," "," ","U","S","A"," "," ","","","","","","","",""," ","S","","" ,"N","N","N"})
*/

ProcRegua(Len(aSX3))

dbSelectArea("SX3")
dbSetOrder(2)

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			lSX3	:= .T.
			If !(aSX3[i,1]$cAlias)
				cAlias += aSX3[i,1]+"/"
			EndIf
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			AADD(aArqUpd,aSX3[i,1])
			IncProc("Atualizando Dicionario de Dados...")
		EndIf
	EndIf
Next i
//APDUpdField("SL2",2,"L2_QUANT"	,"X3_F3","SZWSX5")
APDUpdField("SX3",2,"L2_QUANT"	,"X3_DECIMAL",3)
AADD(aArqUpd,"SL2")

/*
cTexto := ""
If  SL1->(FieldPos("L1_CGCCLI"))<>0
	APDUpdField("SX3",2,"L1_CGCCLI","X3_CAMPO","L1_CPFCLI")
	AADD(aArqUpd,"SL1")
	cTexto := 'Alterado campo L1_CGCCLI para L1_CPFCLI customização NFP'+cAlias+CHR(13)+CHR(10)
EndIf	
APDUpdField("SX3",2,"ZX_BLOQ"	,"X3_BROWSE","S")
APDUpdField("SX3",2,"ZX_MICROT"	,"X3_BROWSE","S")
APDUpdField("SX3",2,"ZX_MICROT"	,"X3_TAMANHO",3)
APDUpdField("SX3",2,"ZX_ORCAM"	,"X3_BROWSE","N")
cTexto += 'Alterado campo ZX_BLOQ+ZX_MICROT para apacecer no browse '+cAlias+CHR(13)+CHR(10)
If lSX3
	cTexto += 'Foi incluido no SX3 a estrutura da seguinte tabela: '+cAlias+CHR(13)+CHR(10)
EndIf

//Caso este campo exista no SX3 sera solicitado o CPF dentro do fronte lojas anulando o onto de entrada 
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("L1_CGCCLI ")
	cTexto += 'Excluido campo L1_CGCCLI'+cAlias+CHR(13)+CHR(10)
	SX3->(Reclock("SX3",.F.))
	SX3->(dbDelete())
	SX3->( MsUnlock())
EndIf
*/

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MyOpenSM0Ex()
                  
Local nLoop := 0 
Local lOpen := .F.

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. ) 
	If !Empty( Select( "SM0" ) ) 
		lOpen := .T. 
		dbSetIndex("SIGAMAT.IND") 
		Exit	
	EndIf
	Sleep( 500 ) 
Next nLoop 

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 ) 
EndIf                                 

Return( lOpen ) 

Static function TesteInno(x)
Return x[nI]

	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuSX6InnoºAutor  ³Marcos Alves        º Data ³  03/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste de Dicionario SX6									      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Innocencio                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Nao foi utilizado no pacote Natal 2010
*/
Static Function AtuSX6Inno()
Local aArea		:= GetArea()
Local cTexto	:=""

dbSelectArea("SX6")
dbSetOrder(1)

If !( dbSeek( xFilial( "SX6" ) + "MV_RELAUTH") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_RELAUTH"
	Replace X6_TIPO   	With "L"
	Replace X6_CONTEUD  With ".T."
	Replace X6_CONTENG  With ".T."
	Replace X6_CONTSPA  With ".T."
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With ".T."
	Replace X6_CONTENG  With ".T."
	Replace X6_CONTSPA  With ".T."
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_RELAUTH =.T.'+CHR(13)+CHR(10)
EndIf



If !( dbSeek( xFilial( "SX6" ) + "MV_RELACNT") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_RELACNT"
	Replace X6_TIPO   	With "C"
	Replace X6_CONTEUD  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTENG  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTSPA  With "relatorio@doceirainnocencio.com.br"
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTENG  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTSPA  With "relatorio@doceirainnocencio.com.br"
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
EndIf

If !( dbSeek( xFilial( "SX6" ) + "MV_RELPSW") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_RELPSW"
	Replace X6_TIPO   	With "C"
	Replace X6_CONTEUD  With "inno123456"
	Replace X6_CONTENG  With "inno123456"                                                                                                                                                                                                                                               "
	Replace X6_CONTSPA  With "inno123456"
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With "inno123456"
	Replace X6_CONTENG  With "inno123456"                                                                                                                                                                                                                                               "
	Replace X6_CONTSPA  With "inno123456"
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
EndIf

If !( dbSeek( xFilial( "SX6" ) + "MV_RELSERV") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_RELSERV"
	Replace X6_TIPO   	With "C"
	Replace X6_CONTEUD  With "smtp.doceirainnocencio.com.br:587"
	Replace X6_CONTENG  With "smtp.doceirainnocencio.com.br:587"                                                                                                                                                                                                                        "
	Replace X6_CONTSPA  With "smtp.doceirainnocencio.com.br:587"
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With "smtp.doceirainnocencio.com.br:587"
	Replace X6_CONTENG  With "smtp.doceirainnocencio.com.br:587"                                                                                                                                                                                                                        "
	Replace X6_CONTSPA  With "smtp.doceirainnocencio.com.br:587"
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
EndIf

If !( dbSeek( xFilial( "SX6" ) + "MV_RELACNT") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_RELACNT"
	Replace X6_TIPO   	With "C"
	Replace X6_CONTEUD  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTENG  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTSPA  With "relatorio@doceirainnocencio.com.br"
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTENG  With "relatorio@doceirainnocencio.com.br"
	Replace X6_CONTSPA  With "relatorio@doceirainnocencio.com.br"
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
EndIf

If !( dbSeek( xFilial( "SX6" ) + "MV_FISCTRB") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_FISCTRB"
	Replace X6_TIPO   	With "C"
	Replace X6_CONTEUD  With "2"
	Replace X6_CONTENG  With "2"
	Replace X6_CONTSPA  With "2"
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With "2"
	Replace X6_CONTENG  With "2"
	Replace X6_CONTSPA  With "2"
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_RELACNT=relatorio@doceirainnocencio.com.br'+CHR(13)+CHR(10)
EndIf

If !( dbSeek( xFilial( "SX6" ) + "MV_FISCTRB") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_FISCTRB"
	Replace X6_TIPO   	With "C"
	Replace X6_CONTEUD  With "1"
	Replace X6_CONTENG  With "1"
	Replace X6_CONTSPA  With "1"
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_FISCTRB=1'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With "1"
	Replace X6_CONTENG  With "1"
	Replace X6_CONTSPA  With "1"
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_FISCTRB=1'+CHR(13)+CHR(10)
EndIf

If !( dbSeek( xFilial( "SX6" ) + "MV_MSGTRIB") )
	RecLock("SX6",.T.)
	Replace X6_FIL   	With xFilial( "SX6" )
	Replace X6_VAR    	With "MV_MSGTRIB"
	Replace X6_TIPO   	With "C"
	Replace X6_CONTEUD  With "2"
	Replace X6_CONTENG  With "2"
	Replace X6_CONTSPA  With "2"
	Replace	X6_PROPRI  	With "N"
	Replace X6_PYME    	With "S"
	MsUnlock()
	cTexto := 'Foi incluido no SX6 a MV_MSGTRIB=2'+CHR(13)+CHR(10)
Else
	RecLock("SX6",.F.)
	Replace X6_CONTEUD  With "2"
	Replace X6_CONTENG  With "2"
	Replace X6_CONTSPA  With "2"
	MsUnlock()
	cTexto := 'Foi alterado no SX6 a MV_FISCTRB=1'+CHR(13)+CHR(10)
EndIf



RestArea( aArea )
Return cTexto

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSx5   ³ Autor ³ Marcos Alves        ³ Data ³ 09/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria tabela ZZ                        					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Innocencio                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AtuSX5Inno()
Local aAreaSx5 := SX5->(GetArea())
Local cTexto 	:= '"
Local nX
Local cTabela	:="ZZ"

If !SX5->(MsSeek(xFilial("SX5")+cTabela+"CF"))
	Reclock("SX5",.T.)
	SX5->X5_FILIAL := xFilial("SX5")
	SX5->X5_TABELA := "ZZ"
	SX5->X5_CHAVE  := "CF"
	SX5->X5_DESCRI := "CUPOM FISCAL "
	SX5->X5_DESCSPA:= "CUPOM FISCAL "
	SX5->X5_DESCENG:= "CUPOM FISCAL "
	SX5->( MsUnlock() )
	cTexto := 'Foi incluido no SX5 a Tabela ZZ - CHAVE CF'+CHR(13)+CHR(10)

EndIf	

/*
//Local aDescri	:=	{"GRUPO LISTA","GRUPO LISTA","GRUPO LISTA"}
*
Local aTabela	:=	{	{ "01    ", "DOCE"				,"DOCES"		,"DOCES"	 	},;
						{ "02    ", "SOBREMESAS"		,"SOBREMESAS"	,"SOBREMESAS" 	},;
						{ "03    ", "SALGADOS"			,"SALGADOS"		,"SALGADOS" 	},;
						{ "04    ", "BOLOS"				,"BOLOS"		,"BOLOS"		},;
						{ "05    ", "SORVETES"			,"SORVETES"		,"SORVETES"		}}

Local aTabela	:=	{	{ "01    ", "DOCE"				,"DOCES"		,"DOCES"	 	},;
						{ "02    ", "SOBREMESAS"		,"SOBREMESAS"	,"SOBREMESAS" 	},;
						{ "03    ", "SALGADOS"			,"SALGADOS"		,"SALGADOS" 	},;
						{ "04    ", "BOLOS"				,"BOLOS"		,"BOLOS"		},;
						{ "05    ", "SORVETES"			,"SORVETES"		,"SORVETES"		}}

Estrutura da tabela a ser garavada
aTabela[n][1] = Codigo
aTabela[n][2] = Descricao Portugues
aTabela[n][3] = Descricao Espanhol
aTabela[n][4] = Descricao Ingles

aDescri[nI] = Descricao da tabela principal em Portugues
aDescri[2] = Descricao da tabela principal em Espanhol
aDescri[3] = Descricao da tabela principal em Ingles
*/
/*
Excluir (SX5 e SA6)) caixa nao utiliados, diferente da lista abaixo
C01	CAIXA GERAL DA LOJA                                                                                                                                                                                                         
C04 WANIA                                                                                                                                                                                                                       
C16 MARCOS                                                                                                                                                                                                                      
C42 CAIXA DI MANHA                                                                                                                                                                                                              
C43 SUPERVISOR AC                                                                                                                                                                                                               
C63 CAIXA DI MANHA                                                                                                                                                                                                              
C64 CAIXA DI TARDE                                                                                                                                                                                                              
C65 CAIXA DI NOITE                                                                                                                                                                                                              
C66 CAIXA AC MANHA                                                                                                                                                                                                              
C67 CAIXA AC TARDE                                                                                                                                                                                                              
C68 CAIXA AC NOITE                                                                                                                                         
// Grava a tabela principal, se nao encontra-la
If !SX5->(MsSeek(xFilial("SX5")+"00"+cTabela))
	Reclock("SX5",.T.)
	SX5->X5_FILIAL := xFilial("SX5")
	SX5->X5_TABELA := "00"
	SX5->X5_CHAVE  := cTabela
	SX5->X5_DESCRI := aDescri[1]
	SX5->X5_DESCSPA:= aDescri[2]
	SX5->X5_DESCENG:= aDescri[3]
	SX5->( MsUnlock() )
EndIf	

For nX := 1 To Len(aTabela)
	If !SX5->(MsSeek(xFilial("SX5")+cTabela+aTabela[nX][1]))
		Reclock("SX5",.T.)
		SX5->X5_FILIAL := xFilial("SX5")
		SX5->X5_TABELA := cTabela
		SX5->X5_CHAVE  := aTabela[nX][1]
		SX5->X5_DESCRI := aTabela[nX][2]
		SX5->X5_DESCSPA:= aTabela[nX][3]
		SX5->X5_DESCENG:= aTabela[nX][4]
		SX5->( MsUnlock() )
	Endif
Next
// Restaura ambiente
SX5->(RestArea(aAreaSx5))
*/

Return 	cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³		    ºAutor  ³Microsiga           º Data ³  09/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Innocencio                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSXBInno()
Local aCampos 	:= {} 	// Array para receber a Nova Estrutura da SXB
Local nX	 	:= 0			// Variavel auxiliar utilizada no For-Next 
Local cTexto 	:= ''
Local cTabela	:="SZWSX5"

SXB->( DbSetorder(1) )

If !SXB->(dbSeek( cTabela))
	//******************************************************************************************************************
	// Consutla SXB SE2INN (usada no fonte (INNO_008.PRW)
	//******************************************************************************************************************
	aAdd( aCampos, {"SZWSX5","1","01","DB","Bandeiras","Bandeiras","Bandeiras","SX5",""})
	aAdd( aCampos, {"SZWSX5","2","01","01","Codigo","Codigo","Codigo","",""})
	aAdd( aCampos, {"SZWSX5","3","01","01","Novo cadastro","Novo cadastro","Novo cadastro","01",""})
	aAdd( aCampos, {"SZWSX5","4","01","01","Codigo","Codigo","Codigo","SX5->X5_CHAVE",""})
	aAdd( aCampos, {"SZWSX5","4","01","01","Descrição","Descrição","Descrição","SX5->X5_DESCRI",""})
	aAdd( aCampos, {"SZWSX5","5","01","","","","","Left(SX5->X5_DESCRI,15)",""})
	aAdd( aCampos, {"SZWSX5","6","01","","","","","ZW",""})
	For nX := 1 To Len( aCampos )
		SXB->( Reclock("SXB", .T.) )
		SXB->XB_ALIAS   := aCampos[nX, 1]
		SXB->XB_TIPO    := aCampos[nX, 2]
		SXB->XB_SEQ     := aCampos[nX, 3]
		SXB->XB_COLUNA  := aCampos[nX, 4]
		SXB->XB_DESCRI  := aCampos[nX, 5]
		SXB->XB_DESCSPA := aCampos[nX, 6]
		SXB->XB_DESCENG := aCampos[nX, 7]
		SXB->XB_CONTEM  := aCampos[nX, 8]
//		SXB->XB_WCONTEM := aCampos[nX, 9]
		SXB->( MsUnlock() )
	Next nX	
	cTexto 	:= 'Foi incluido no SXB consulta '+cTabela+CHR(13)+CHR(10)
endif

/*
aReg:={}
SXB->(dbSeek("SA2   2") ) //SXB->XB_ALIAS+SXB->XB_TIPO+SXB->XB_SEQ
While !SXB->(Eof()).and.SXB->XB_ALIAS+SXB->XB_TIPO=="SA2   2"
	aadd(aReg,{SXB->XB_SEQ,SXB->(Recno())})
	SXB->(dbSkip())
End
For nI:=1 to Len(aReg)
	SXB->(dbGoto(aReg[nI,2]))
    If aReg[nI,1]=="01"
		RecLock("SXB",.F.)
		SXB->XB_COLUNA  := "02"
		SXB->XB_DESCRI  := "Nome"
		SXB->XB_CONTEM  := ""
		SXB->( MsUnlock() )
    ElseIf aReg[nI,1]=="02"
		RecLock("SXB",.F.)
		SXB->XB_COLUNA  := "01"
		SXB->XB_DESCRI  := "Código"
		SXB->XB_CONTEM  := ""
		SXB->( MsUnlock() )
	EndIf	
Next nI	
*/


Return cTexto

Static Function APDUpdField(cAlias, nOrder    , cIndexKey , cField       , cNewValue     , cTestValue, bBlockValue,cLog)
Local aArea 	:= (cAlias)->(GetArea())
Local lRet 		:= .F.
Local nFieldPos := 0
Local aLog		:={}
Local i			:=0
dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(nOrder))

// verifica se o registro existe no alias
If !(cAlias)->(dbSeek(cIndexKey))
	RestArea(aArea)
	Return lRet	
EndIf

// verificar se o campo existe no alias
nFieldPos := (cAlias)->(FieldPos(cField))

If nFieldPos == 0
	RestArea(aArea)
	Return lRet
EndIf
If bBlockValue == Nil
	// teste por valor
	If cTestValue == Nil
		// se o teste nao existe altera o valor
		RecLock(cAlias, .F.)
	  	(cAlias)->(FieldPut(nFieldPos, cNewValue))
		MsUnlock()
		RestArea(aArea)							
		lRet := .T.
	Else
		// se o teste existe, testa e altera o valor  		
		If AllTrim(Upper(cTestValue)) == AllTrim(Upper((cAlias)->(FieldGet(nFieldPos))))
			RecLock(cAlias, .F.)
			(cAlias)->(FieldPut(nFieldPos, cNewValue))
			MsUnlock()
			RestArea(aArea)							
			lRet := .T.
	  EndIf
	EndIf
Else
	// teste por bloco - nao implementado
    RestArea(aArea)
	Return lRet
EndIf

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³		    ºAutor  ³Microsiga           º Data ³  09/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Innocencio                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSX2Inno()
Local aSX2 	  	:= {}
Local aEstrut	:= {}
Local aSX2Stru	:={}
Local i      	:= 0
Local j      	:= 0
Local cTexto 	:= ''
Local lSX2	 	:= .F.
Local cAlias 	:= ''
Local cPath 	:=NIL
Local cNome		:=NIL

aEstrut:= {}
dbSelectArea("SX2")
dbSetOrder(1)

aSX2Stru:=SX2->(dbStruct())
For nI:=1 to Len(aSX2Stru)
    aadd(aEstrut,aSX2Stru[nI,1])
Next nI
/* Protheus 11
Aadd(aSX2,{"SA1"})							//	X2_CHAVE
Aadd(aSX2,{"\data\"})						//	X2_PATH
Aadd(aSX2,{"SA1010"})						//	X2_ARQUIVO
Aadd(aSX2,{"Clientes"})						//	X2_NOME
Aadd(aSX2,{"Clientes"})						//	X2_NOMESPA
Aadd(aSX2,{"Customers"})					//	X2_NOMEENG
Aadd(aSX2,{""})								//	X2_ROTINA
Aadd(aSX2,{"C"})							//	X2_MODO
Aadd(aSX2,{"E"})							//	X2_MODOUN
Aadd(aSX2,{"E"})							//	X2_MODOEMP
Aadd(aSX2,{0})								//	X2_DELET
Aadd(aSX2,{" "})							//	X2_TTS
Aadd(aSX2,{"A1_FILIAL+A1_COD+A1_LOJA"})		//	X2_UNICO
Aadd(aSX2,{"S"})							//	X2_PYME
Aadd(aSX2,{5})								//	X2_MODULO
Aadd(aSX2,{"A1_COD+A1_LOJA+A1_NOME"})		//	X2_DISPLAY
Aadd(aSX2,{"MATA030"})						//	X2_SYSOBJ
Aadd(aSX2,{""})								//	X2_USROBJ
Aadd(aSX2,{"1"})							//	X2_POSLGT
//            "SA1","\data\","SA1010","Clientes"						,"","","","C","E","E",0," ","","S",5,"A1_COD+A1_LOJA+A1_NOME","MATA030","","1"
Aadd(aSX2,{"SZV","\DATA\","SZV010","Lista de Inventario"			,"","","","E","E","E",0," ","","N",0,"","","","1"})
Aadd(aSX2,{"SZU","\DATA\","SZU010","Produtos lista de Inventario"	,"","","","E","E","E",0," ","","N",0,"","","","1"})
*/

Aadd(aSX2,{"SZT","\DATA\","SZT010","Sinal de encomenda"		     	,"","","","E",0," ","","N",0,""})
Aadd(aSX2,{"SZS","\DATA\","SZS010","Formas de pgto sinal Encomenda"	,"","","","E",0," ","","N",0,""})

ProcRegua(Len(aSX2))
dbSelectArea("SX2")
dbSetOrder(1)
dbGoto(1)

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !dbSeek(aSX2[i,1])
			lSX2	:= .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Dicionario de Arquivos...") // //"Atualizando Dicionario de Arquivos..."
		EndIf
	EndIf	
Next i
Return ('Foi incluido no SXB consulta SEDINN'+CHR(13)+CHR(10))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³InnoProc  ³ Autor ³Marcos Alves           ³ Data ³ 28/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao dos arquivos            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InnoProc2(lEnd)

Local cTexto    := ''
Local cFile     :=""
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo   := "DM"
Local nRecno    := 0
Local nI        := 0
Local nX		:= 0
Local aRecnoSM0 := {}     
Local lOpen     := .F. 
Local cPathSx 	:= Alltrim(GetPvProfString(GetEnvServer(),"rootpath","",GetADV97())) + "\SYSTEM\"	// Retorna o StartPath
// SL1
// SL2
// SL4
// SE1
// SE5
// SEF

If MyOpenSm0Ex()
	
	dbSelectArea("SM0")
	dbGotop()
	cTexto += "Inicio - InnoProc2: "+time()+CHR(13)+CHR(10)
	RpcSetType(2) 
	If !RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	   Return nil
	EndIf   
	cTexto += "Inicio: "+time()+CHR(13)+CHR(10)
	cTexto += Replicate("-",128)+CHR(13)+CHR(10)
	cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
          
	dbSelectArea("SL1")
	dbSetOrder(0)   
	dbgotop()
    nTotreg:=0
    nSl1:=0
    nSl2:=0    
    nSl4:=0    
    nSE1:=0    
    nSE5:=0    
    nSEF:=0    
    nDisplay:=0
    cNumOrig:=""
    //--------------------- Parte 1 -------------------------------------------------------------------------
	ProcRegua(SL1->(Reccount()))
	Conout("Incio.....[InnoProc2] Parte 1:"+time())
	While !SL1->(Eof())
		If 	nDisplay=1000
			Conout("Total Reg.:"+Str(nTotReg)+" / "+time())
			nDisplay:=0
		EndIf	
		nSL1++
		SL1->(RecLock("SL1",.F.))
		SL1->L1_VEND3 :=SL1->L1_NUM
		SL1->(MsUnLock())
		SL1->(dbCommit())
		nDisplay++
		nTotReg++
		dbSelectArea("SL2")
		dbSetorder(1)
		
		dbSeek(SL1->L1_FILIAL+SL1->L1_NUM)
		While !SL2->(Eof()).AND.SL2->L2_FILIAL+SL2->L2_NUM==SL1->L1_FILIAL+SL1->L1_NUM
			If SL1->L1_DOC==SL2->L2_DOC.AND.SL1->L1_EMISSAO==SL2->L2_EMISSAO
				nSL2++
				SL2->(RecLock("SL2",.F.))
				SL2->L2_LOCALIZ		:=SL1->L1_NUMORIG
				SL2->(MsUnLock())
				SL2->(dbCommit())
			EndIf
            SL2->(dbSkip())
		End

		dbSelectArea("SL4")
		dbSetorder(1)
		dbSeek(SL1->L1_FILIAL+SL1->L1_NUM)
		While !SL4->(Eof()).AND.SL4->L4_FILIAL+SL4->L4_NUM==SL1->L1_FILIAL+SL1->L1_NUM
			nSL4++
			SL4->(RecLock("SL4",.F.))
			SL4->L4_OBS	:=SL1->L1_NUMORIG
			SL4->(MsUnLock())
			SL4->(dbCommit())
            SL4->(dbSkip())
		End
        SL1->(dbSkip())
    End
    //--------------------- Parte 2 -------------------------------------------------------------------------
	ProcRegua(SL1->(Reccount()))
	Conout("Incio Parte 2 - SL1:"+time())
	dbSelectArea("SL1")
	dbSetOrder(0)   
	dbgotop()
	While !SL1->(Eof())
		SL1->(RecLock("SL1",.F.))
		SL1->L1_NUM		:=SL1->L1_NUMORIG
		SL1->(dbCommit())
		SL1->(MsUnLock())
		SL1->(dbSkip())                
    End

	Conout("Incio Parte 2 - SL2:"+time())
	dbSelectArea("SL2")
	dbSetOrder(0)   
	dbgotop()
	While !SL2->(Eof())
		SL2->(RecLock("SL2",.F.))
		SL2->L2_NUM		:=Alltrim(SL2->L2_LOCALIZ)
		SL2->(dbCommit())
		SL2->(MsUnLock())
		SL2->(dbSkip())                
    End

	Conout("Incio Parte 2 - SL4:"+time())
	dbSelectArea("SL4")
	dbSetOrder(0)   
	dbgotop()
	While !SL4->(Eof())
		SL4->(RecLock("SL4",.F.))
		SL4->L4_NUM		:=Alltrim(SL4->L4_OBS)
		SL4->(dbCommit())
		SL4->(MsUnLock())
		SL4->(dbSkip())                
    End
	cTexto += "Total Reg.:"+Str(nTotReg)+CHR(13)+CHR(10)
	Conout("Total Reg.:"+Str(nTotReg))
	Conout("Total SL1.:"+Str(nSL2))
	Conout("Total SL1.:"+Str(nSL2))
	dbSelectArea("SL1")
	RpcClearEnv()
	OpenSm0Excl()
	cTexto += "Final   : "+time()+CHR(13)+CHR(10)
EndIf

cPath:=GetSrvProfString("RootPath","")+"\DATA\"

cTexto := "Log da atualizacao do Dicionário Inno"+CHR(13)+CHR(10)+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
DEFINE MSDIALOG oDlg TITLE "Atualizacao concluida com sucesso!" From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont
DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
ACTIVATE MSDIALOG oDlg CENTER

    
Return Nil

//============================================================================================================
User Function UPDCliInno()

cArqEmp := "SigaMat.Emp"
nModulo		:= 44
__cInterNet := Nil
PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd 

Set Dele On

lHistorico 	:= MsgYesNo("Deseja efetuar a atualizacao dos cadastro de clientes ? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup dos dicionarios e da Base de Dados antes da atualizacao para eventuais falhas de atualizacao e Ligue o servidor Licenças!", "Atenção !")
lEmpenho	:= .F.
lAtuMnu		:= .F.

DEFINE WINDOW oMainWnd FROM 0,0 TO 01,30 TITLE "Atualizacao da Base de dados Pacote TOP - Maio/2011"

ACTIVATE WINDOW oMainWnd ;
	ON INIT If(lHistorico,(Processa({|lEnd| InnoCliProc(@lEnd)},"Processando","Aguarde , processando preparacao dos arquivos",.T.), oMainWnd:End() ), oMainWnd:End() )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³InnoCliProc  ³ Autor ³Marcos Alves           ³ Data ³ 28/06/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao de processamento da gravacao dos arquivos            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InnoCliProc(lEnd)

Local cTexto    := ''
Local cFile     :=""
Local cMask     := "Arquivos Texto (*.TXT) |*.txt|"
Local cCodigo   := "DM"
Local nRecno    := 0
Local nI        := 0
Local nX		:= 0
Local aRecnoSM0 := {}     
Local lOpen     := .F. 
Local cPathSx 	:= Alltrim(GetPvProfString(GetEnvServer(),"rootpath","",GetADV97())) + "\SYSTEM\"	// Retorna o StartPath
// SL1

If MyOpenSm0Ex()
	
	dbSelectArea("SM0")
	dbGotop()
	cTexto += "Inicio: "+time()+CHR(13)+CHR(10)
	RpcSetType(2) 
	If !RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	   Return nil
	EndIf   
	cTexto += "Inicio: "+time()+CHR(13)+CHR(10)
	cTexto += Replicate("-",128)+CHR(13)+CHR(10)
	cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)
            
	dbSelectArea("SA1")
	dbSelectArea("SL1")
	dbSetOrder(0)   
    nDisplay:=0
    //--------------------- Parte 1 -------------------------------------------------------------------------
	dbSelectArea("SA1")
	dbSetOrder(3)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera cadastro de clientes a partir do CPF³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !file(cPathSx+"fisico.DBF")
    	MsgInfo("Aquivos "+cPathSx+"fisico.DBF não enontrado...")
    	Return nil
    EndIf		
	nArea:=dbUseArea(.T.,"DBFCDX","FISICO","FIS",.F.,.F.)
    If !file(cPathSx+"fisico.cdx")
		__cInterNet 		:= NIL
		IncProc("Indexando FISICO.DBF")
		__cInterNet 		:= 'AUTOMATICO'
    	dbCreateIndex( "FISICO", "DOC", { || DOC})
    Else
    	dbSetIndex("FISICO")
	EndIf	
	//ProcCliClear()

	dbSelectArea("SA1")
	dbSetOrder(3)

	dbSelectArea("SL1")
	lCgf:=.F.

	__cInterNet 		:= NIL
	IncProc("Indexando SL1_CPFCLI")
	__cInterNet 		:= 'AUTOMATICO'
	dbCreateIndex( "SL1_CPFCLI"	, "L1_CPFCLI"	, { || L1_CPFCLI})
    SL1->(dbSeek("0"))
    Set SoftSeek OFF
	
	nCli1		:=nCli2:=0
	cCPF		:=""
	cCliente	:=SL1->L1_CLIENTE
	nCount		:=0
	__cInterNet 		:= 'AUTOMATICO'
	cCli:="000100"
	While !SL1->(EOF()).AND.!EMPTY(SL1->L1_CPFCLI)
		dbSelectArea("SA1")
		dbSetOrder(3)
        If ++nCount>=100
			__cInterNet 		:= NIL
			Conout("Total de clientes incluidos/Receita.:"+Alltrim(Str(nCli1))+"/"+Alltrim(Str(nCli2)))
			Conout("SL1->RECNO()"+STRZERO(SL1->(RECNO())))
			__cInterNet 		:= 'AUTOMATICO'
			nCount:=0
	    EndIf
		If AllTrim(SL1->L1_CPFCLI)<>cCPF
			cCliente:=SL1->L1_CLIENTE
		EndIf	
		SA1->(dbSetOrder(3))
 		If !(SA1->(dbSeek(xFilial("SA1")+SL1->L1_CPFCLI)))		//Cadastro de cliente
			++nCli1
			cNome		:="Cliente NFP - "+ AllTrim(SL1->L1_CPFCLI)
			cNomeRed	:="Cliente NFP"
			cEnd		:="."
			cMun		:="."
			cEst		:="."
			cBairro		:="."
			cCep		:="."
			cCPF		:=AllTrim(SL1->L1_CPFCLI)
			dNasc		:=cTod("")
 		    If FIS->(dbSeek(subs(SL1->L1_CPFCLI,1,11)))		//
				++nCli2
				cNome		:=FIS->NOME
				cNomeRed	:=Subs(FIS->NOME,1,at(" ",FIS->NOME))
				cEnd		:=FIS->END
				cMun		:=FIS->CIDADE
				cEst		:=FIS->UF
				cBairro		:=FIS->BAIRRO
				cCep		:=FIS->CEP
				cCPF		:=AllTrim(FIS->DOC)
				dNasc		:=cTod(Subs(FIS->NASC,5,2)+"/"+Subs(FIS->NASC,3,2)+"/"+Subs(FIS->NASC,1,2))
 		    EndIf
			dbSelectArea("SA1")
			dbSetOrder(1)
     		cCli:=Soma1(cCli,6)
	        While SA1->(dbSeek(xFilial("SA1")+cCli))
		 		cCli:=Soma1(cCli,6)
            End
			SA1->(RecLock("SA1",.T.))
 		    SA1->A1_COD		:=cCli
 		    SA1->A1_LOJA	:="01"
			SA1->A1_NOME	:=cNome
			SA1->A1_NREDUZ	:=cNomeRed
			SA1->A1_PESSOA	:="F"
			SA1->A1_TIPO	:="F"
			SA1->A1_END		:=cEnd
			SA1->A1_MUN		:=cMun
			SA1->A1_EST		:=cEst
			SA1->A1_BAIRRO	:=cBairro
			SA1->A1_CEP		:=cCep
			SA1->A1_PAIS	:="105"
			SA1->A1_CGC		:=cCPF
			SA1->A1_MOEDALC	:=2
			SA1->A1_DTNASC	:=dNasc
			SA1->A1_TIPCLI	:="1"
			SA1->A1_RECCOFI	:="N"
			SA1->A1_RECCSLL	:="N"
			SA1->A1_RECPIS	:="N"
			SA1->A1_B2B		:="2"
			SA1->A1_MSBLQL	:="2"
			SA1->A1_ABATIMP	:="3"
			SA1->A1_PRICOM	:=SL1->L1_EMISSAO	//Primeira compra
			SA1->A1_ULTCOM	:=SL1->L1_EMISSAO	//Ultima compra
			SA1->A1_MCOMPRA	:=SL1->L1_VLRTOT	//Maior compra
			SA1->A1_NROCOM	:=1
			SA1->(MsUnLock())
			SA1->(dbCommit())
			cCli:=SA1->A1_COD
			cCliente:=SA1->A1_COD
 		Else
			cCPF:=AllTrim(SL1->L1_CPFCLI)
			SA1->(RecLock("SA1",.F.))
			SA1->A1_PRICOM	:=If(SL1->L1_EMISSAO<SA1->A1_PRICOM,SL1->L1_EMISSAO,SA1->A1_PRICOM)	//Primeira compra
			SA1->A1_ULTCOM	:=If(SL1->L1_EMISSAO>SA1->A1_PRICOM,SL1->L1_EMISSAO,SA1->A1_PRICOM)	//Ultima compra
			SA1->A1_MCOMPRA	:=If(SL1->L1_VLRTOT>SA1->A1_MCOMPRA,SL1->L1_VLRTOT,SA1->A1_MCOMPRA)	//Maior compra
			SA1->A1_NROCOM	:=SA1->A1_NROCOM+1
			SA1->A1_LOJA	:="01"
			SA1->(MsUnLock())
			If cCliente<>SA1->A1_COD
				cCliente:=SA1->A1_COD
				If SL1->L1_CLIENTE<>"000001"
					Conout("registro de cliente errado..."+strzero(SL1->(RECNO())))
				EndIf	
			EndIf
 		EndIf
		If cCliente<>SL1->L1_CLIENTE
			SA1->(RecLock("SL1",.F.))
    		SL1->L1_ENDCOB:=SL1->L1_CLIENTE
    		SL1->L1_CLIENTE:=cCliente
    		SL1->L1_LOJA:="01"
			SL1->(MsUnLock())
			//InnoCliTab(cCliente)
		Else
			SA1->(RecLock("SL1",.F.))
	    	SL1->L1_LOJA:="01"
			SL1->(MsUnLock())
		EndIf	
    	SL1->(dbSkip())
	End
	Conout("Total de clientes Incluidos"+Str(nCli1))
	Conout("Total de clientes RECEITA..."+Str(nCli2))
	RpcClearEnv()
	OpenSm0Excl()
EndIf
  
Return Nil

Static Function InnoCliTab(cCliente)
//Atualizacao do SE1
dbSelectArea("SE1")
dbSetorder(1)   //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
dbSeek(SL1->L1_FILIAL+SL1->L1_SERIE+SL1->L1_DOC)
While !SE1->(Eof()).AND.SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM==SL1->L1_FILIAL+SL1->L1_SERIE+SL1->L1_DOC
	SE1->(RecLock("SE1",.F.))
    SE1->E1_VEND5:=cCliente
	SE1->(MsUnLock())
	SE1->(dbSkip())
End

//Atualizacao do SF2
dbSelectArea("SF2")
dbSetorder(1)   //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
dbSeek(SL1->L1_FILIAL+SL1->L1_DOC+SL1->L1_SERIE)
While !SF2->(Eof()).AND.SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE==SL1->L1_FILIAL+SL1->L1_DOC+SL1->L1_SERIE
	SF2->(RecLock("SF2",.F.))
    SF2->F2_VEND5:=cCliente
	SF2->(MsUnLock())
	SF2->(dbSkip())
End

	
//Atualizacao do SD2
dbSelectArea("SD2")
dbSetorder(3)   //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
dbSeek(SL1->L1_FILIAL+SL1->L1_DOC+SL1->L1_SERIE)
While !SD2->(Eof()).AND.SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE==SL1->L1_FILIAL+SL1->L1_DOC+SL1->L1_SERIE
	SD2->(RecLock("SD2",.F.))
    SD2->D2_LOCALIZ:=cCliente
	SD2->(MsUnLock())
	SD2->(dbSkip())
End

//Atualizacao do SE5
dbSelectArea("SE5")
dbSetorder(7)   //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
dbSeek(SL1->L1_FILIAL+SL1->L1_SERIE+SL1->L1_DOC)
While !SE5->(Eof()).AND.SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO==SL1->L1_FILIAL+SL1->L1_SERIE+SL1->L1_DOC
	SE5->(RecLock("SE5",.F.))
	SE5->E5_IDENTEE:=cCliente
	SE5->(MsUnLock())
	SE5->(dbCommit())
	SE5->(dbSkip())
End

dbSelectArea("SEF")
dbSetorder(3)   //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM+EF_SEQUENC
dbSeek(SL1->L1_FILIAL+SL1->L1_SERIE+SL1->L1_DOC)
While !SEF->(Eof()).AND.SEF->EF_FILIAL+SEF->EF_PREFIXO+SEF->EF_TITULO==SL1->L1_FILIAL+SL1->L1_SERIE+SL1->L1_DOC
	SEF->(RecLock("SEF",.F.))
	SEF->EF_HISTD:=cCliente
	SEF->(MsUnLock())
	SEF->(dbCommit())
	SEF->(dbSkip())
End

Return Nil


Static Function ProcCliMove()
//Atualizacao do SE1
Conout("Atualizado cliente SE1 (Inicio:"+Time())
dbSelectArea("SE1")
dbSetorder(0)   //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
dbGotop()
While !SE1->(Eof())
    If !Empty(SE1->E1_VEND5)
		SE1->(RecLock("SE1",.F.))
    	SE1->E1_CLIENTE:=SE1->E1_VEND5
		SE1->(MsUnLock())
	EndIf
	SE1->(dbSkip())
End
Conout("Atualizado cliente SE1 (Final.:"+Time())

//Atualizacao do SF2
Conout("Atualizado cliente SF2 (Inicio:"+Time())
dbSelectArea("SF2")
dbSetorder(0)   //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
dbGotop()
While !SF2->(Eof())
    If !Empty(SF2->F2_VEND5)
		SF2->(RecLock("SF2",.F.))
    	SF2->F2_CLIENTE:=SF2->F2_VEND5
		SF2->(MsUnLock())
	EndIf		
	SF2->(dbSkip())
End
Conout("Atualizado cliente SF2 (Final.:"+Time())

	
//Atualizacao do SD2
Conout("Atualizado cliente SD2 (Inicio:"+Time())
dbSelectArea("SD2")
dbSetorder(0)   //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
dbGotop()
While !SD2->(Eof())
    If !Empty(Sd2->d2_LOCALIZ)
		SD2->(RecLock("SD2",.F.))
	    SD2->D2_CLIENTE:=SD2->D2_LOCALIZ
		SD2->(MsUnLock())
	EndIf		
	SD2->(dbSkip())
End
Conout("Atualizado cliente SD2 (fINAL.:"+Time())

//Atualizacao do SE5
Conout("Atualizado cliente SE5 (Inicio:"+Time())
dbSelectArea("SE5")
dbSetorder(0)   //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
dbGotop()
While !SE5->(Eof())
    If !Empty(SE5->E5_IDENTEE)
		SE5->(RecLock("SE5",.F.))
		SE5->E5_CLIFOR:=SE5->E5_IDENTEE
		SE5->(MsUnLock())
    EndIf
	SE5->(dbSkip())
End
Conout("Atualizado cliente SE5 (Final.:"+Time())

Conout("Atualizado cliente SEF (Inicio:"+Time())
dbSelectArea("SEF")
dbSetorder(0)   //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM+EF_SEQUENC
dbGotop()
While !SEF->(Eof())
    If !Empty(SEF->EF_HISTD)
		SEF->(RecLock("SEF",.F.))
		SEF->EF_CLIENTE:=SEF->EF_HISTD
		SEF->(MsUnLock())
	EndIf	
	SEF->(dbSkip())
End
Conout("Atualizado cliente SEF (Final.:"+Time())

Return NIL

Static Function ProcCliClear()
//Atualizacao do SE1
Conout("ProcCliClear SE1 (Inicio:"+Time())
dbSelectArea("SE1")
dbSetorder(0)   //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
dbGotop()
While !SE1->(Eof())
	SE1->(RecLock("SE1",.F.))
    SE1->E1_VEND5:=""
	SE1->(MsUnLock())
SE1->(dbSkip())
End
Conout("ProcCliClear SE1 (Final.:"+Time())

//Atualizacao do SF2
Conout("ProcCliClear SF2 (Inicio:"+Time())
dbSelectArea("SF2")
dbSetorder(0)   //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
dbGotop()
While !SF2->(Eof())
	SF2->(RecLock("SF2",.F.))
   	SF2->F2_VEND5:=""
	SF2->(MsUnLock())
	SF2->(dbSkip())
End
Conout("ProcCliClear SF2 (Final.:"+Time())

	
//Atualizacao do SD2
Conout("ProcCliClear SD2 (Inicio:"+Time())
dbSelectArea("SD2")
dbSetorder(0)   //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
dbGotop()
While !SD2->(Eof())
	SD2->(RecLock("SD2",.F.))
    SD2->D2_LOCALIZ:=""
	SD2->(MsUnLock())
	SD2->(dbSkip())
End
Conout("ProcCliClear SD2 (fINAL.:"+Time())

//Atualizacao do SE5
Conout("ProcCliClear SE5 (Inicio:"+Time())
dbSelectArea("SE5")
dbSetorder(0)   //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
dbGotop()
While !SE5->(Eof())
	SE5->(RecLock("SE5",.F.))
	SE5->E5_IDENTEE:=""
	SE5->(MsUnLock())
	SE5->(dbSkip())
End
Conout("ProcCliClear SE5 (Final.:"+Time())

Conout("ProcCliClear SEF (Inicio:"+Time())
dbSelectArea("SEF")
dbSetorder(0)   //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_NUM+EF_SEQUENC
dbGotop()
While !SEF->(Eof())
	SEF->(RecLock("SEF",.F.))
	SEF->EF_HISTD:=""
	SEF->(MsUnLock())
	SEF->(dbSkip())
End
Conout("ProcCliClear SEF (Final.:"+Time())

Conout("ProcCliClear SA1 (Inicio:"+Time())
SA1->(dbGotop())
While !SA1->(EOF())
	SA1->(RecLock("SA1",.F.))
	SA1->A1_NROCOM:=0 
	SA1->(MsUnLock())
	SA1->(dbSkip())
End
Conout("ProcCliClear SA1 (Final.:"+Time())

Return NIL


Static Function Tela01()
Local oDlgInno  
Local oFntCupom	
Local oFntInf
Local oFntGet
Local oFntQuant
Local oFntTotal
lOCAL oLogoEmp 
Local oDoc
Local cDoc:="001"


//DEFINE MSDIALOG oDlgInno FROM 0,0 TO 458,795 PIXEL OF GetWndDefault() COLOR CLR_WHITE,CLR_HRED 
DEFINE MSDIALOG oDlgInno FROM 0,0 TO 458,795 PIXEL COLOR CLR_WHITE,CLR_HRED 
	//COLOR CLR_WHITE,If(INNO_CLI<>"000001",_CLR_MAGENTA,_CLR_HRED)
	//COLOR CLR_WHITE,CLR_MAGENTA
    //Versao
	//@ 168, 78 TO 215, 160 LABEL "v 1.7" PIXEL

	@ 173,  82 SAY "Documento:"		PIXEL SIZE 30,8		// "Documento:"
	@ 181,  82 SAY "Data:" 			PIXEL SIZE 18,8		// "Data:"
	@ 189,  82 SAY "Hora:"			PIXEL SIZE 15,8		// "Hora:"
	@ 197,  82 SAY "Filial:"		PIXEL SIZE 22,8		// "Filial:"
	@ 197, 120 SAY "PDV:"			PIXEL SIZE 13,8		// "PDV:"
	@ 205,  82 SAY "Usuário:"		PIXEL SIZE 30,8		// "Usuário:"
	@ 173, 115 SAY oDoc VAR cDoc	PIXEL SIZE 35,8 FONT oFntInf


ACTIVATE MSDIALOG oDlgInno 

Final()
Return Nil

User Function LeEmail()
Local nx
Local aAllusers := FWSFALLUSERS()
For nx := 1 To Len(aAllusers)
    conout(aAllusers[nx][4] + " -" + aAllusers[nx][5])
Next
Return	



Static Function ItstMail()

Local cError   := ""
Local cUser
Local nAt

Local cServidor:="smtp.doceirainnocencio.com.br:587"
Local cConta:="relatorio@doceirainnocencio.com.br"
Local cPsw:="inno123456"
Local cPara	:="marcos@doceirainnocencio.com.br"
Local cAssunto:= "Teste de e-mail"
Local cMensagem:="Teste de e-mail Mensagem....Mensagem....Mensagem....Mensagem....Mensagem....Mensagem....Mensagem...."
Local lResult :=.f.
Local cLog:=""
CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cPsw RESULT lResult

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Servidor de EMAIL necessita de Autenticacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	lResult := MailAuth(cConta, cPsw)
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	if !lResult
		nAt 	:= At("@",cConta)
		cUser 	:= If(nAt>0,Subs(cConta,1,nAt-1),cConta)
		lResult := MailAuth(cUser, cPsw)
	endif


If lResult
	SEND MAIL FROM cConta ;
	TO      	cPara;
	SUBJECT 	 cAssunto;
	BODY    	 cMensagem;
	RESULT lResult
	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		cLog := "Não foi possível enviar o e-mail para:" + cPara
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	cLog := "Não foi possível conectar com o servidor SMTP!" +" "+ "Mensagem de Erro:"+cError	
EndIf

Return(lResult)   

//============================================================================

User Function I999SendMail(cAccount,cPassword,cServer,cFrom,cEmail       ,cAssunto,cMensagem,cAttach     ,lMsg,cLog)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³I000SA5   ³ Autor ³Marcos Alves           ³ Data ³ 25/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Popula a tabela SA5 (PRODUTO X FORNECEDOR) em funcao dos    ³±±
±±³          ³registro de compras (SD1)                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I000SA5()
Local dDataSD1:=dToS(cTod("01/01/2019"))

dbSelectArea("SD1")
dbSetorder(3)  //D1_FILIAL+DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA                                                                                                   

SD1->(dbSeek(xFilial("SD1")+dDataSD1,.T.)) //Posiciona na data mais proximas da determinada.
While !SD1->(Eof())
	If !(SA5->(dbSeek(xFilial("SA5")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD )))
		SA5->(Reclock("SA5",.T.))
		SA5->A5_FILIAL	:= xFilial("SA5")
		SA5->A5_FORNECE	:= SD1->D1_FORNECE
		SA5->A5_LOJA	:= SD1->D1_LOJA
		SA5->A5_PRODUTO	:= SD1->D1_COD
		SA5->A5_NOMPROD	:= Posicione('SB1',1,xFilial('SB1')+SD1->D1_COD,'B1_DESC')
		SA5->A5_NOMEFOR	:= Posicione('SA2',1,xFilial('SA2')+SD1->D1_FORNECE+SD1->D1_LOJA,'A2_NOME')
		SA5->A5_STATUS	:= "I"
		SA5->( MsUnlock())
	EndIf
	SD1->(dbSkip())
End
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³I000SA5   ³ Autor ³Marcos Alves           ³ Data ³ 25/04/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Popula a tabela SA5 (PRODUTO X FORNECEDOR) em funcao dos    ³±±
±±³          ³registro de compras (SD1)                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I000SE2(cTexto)
Local dDataSD1:=dToS(cTod("01/01/2019"))
Local cFilInno:="02"

dbSelectArea("SE5")
dbSetorder(7)  //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ                                                                                      

dbSelectArea("SE2")
dbSetorder(5)  //E2_FILIAL+DTOS(E2_EMISSAO)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO                                                                                       
SE2->(dbSeek(cFilInno+dDataSD1,.T.)) //Posiciona na data mais proximas da determinada.
While !SE2->(Eof())
	nRegSE2		:=SE2->(RECNO())
	If SE2->E2_SALDO<>0
		cNum		:=SE2->E2_NUM
		cTipo		:=SE2->E2_TIPO
		cPrefixo	:=SE2->E2_PREFIXO
		cParcela	:=SE2->E2_PARCELA
		cFornece	:=SE2->E2_FORNECE       
		cLoja		:=SE2->E2_LOJA
		cNat		:=SE2->E2_NATUREZ
		nValor		:=SE2->E2_VALOR
		SE2->(dbSetorder(6)) //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO                                                                                               
		If SE2->(dbSeek(cFilInno+cFornece+cLoja+"CXB"+cNum,.F.)) 
			If SE2->(RECNO())<>nRegSE2.AND.(ABS(SE2->E2_VALOR-nValor)<0.10).AND.SE2->E2_SALDO=0
				nRegCXB:=SE2->(RECNO())
				dbSelectArea("SE5")
				If SE5->(dbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,.F.)) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ                                                                                      
					cTexto += 'Alterado SE5->'+ STR(SE5->(RECNO()))+E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+CHR(13)+CHR(10)
					SE5->(Reclock("SE5",.F.))
					SE5->E5_PREFIXO	:= cPrefixo
					SE5->E5_PARCELA	:= cParcela
					SE5->E5_TIPO	:= cTipo
					SE5->E5_NATUREZ	:= cNat
					SE5->(MsUnlock())
				EndIf
				SE2->(dbGoto(nRegSE2))
				SE2->(Reclock("SE2",.F.))
				SE2->(dbDelete())
				SE2->( MsUnlock())
				SE2->(dbGoto(nRegCXB))
				cTexto += 'Deletado  SE2->'+ STR(SE2->(RECNO()))+SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+CHR(13)+CHR(10)

				dbSelectArea("SE2")
				SE2->(Reclock("SE2",.F.))
				SE2->E2_PREFIXO	:= cPrefixo
				SE2->E2_PARCELA	:= cParcela
				SE2->E2_TIPO	:= cTipo
				SE2->E2_NATUREZ	:= cNat
				SE2->E2_ORIGEM	:= "MATA100"
				SE2->E2_HIST	:= "[*]"+SE2->E2_HIST
				SE2->(MsUnlock())
				cTexto += 'Alterado SE2->'+ STR(SE2->(RECNO()))+E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+CHR(13)+CHR(10)
			EndIf
		EndIf
	EndIf
	dbSetorder(5)  //E2_FILIAL+DTOS(E2_EMISSAO)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO                                                                                       
	SE2->(dbGoto(nRegSE2))
	SE2->(dbSkip())
End

Return cTexto
//===========================================================================================================================================
//===========================================================================================================================================
Static function I000Cielo(cTexto)
Local aCliente		:={}
Local cArq			:="cielo.csv"
Local cOrigem		:=GetPvProfString( "INNO","EXCEL", "C:\", GetRemoteIniName()) //Local onde fica os arquivos do Excel

Private aForma		:={}
Private cTemp      := GetTempPath() //pega caminho do temp do client
Private nLinTit    := 0
Private aArquivos  := {}
Private aRet       := {}

If SM0->M0_CODIGO<>"02"
	Return cTexto+=" Não Processada ...Filial: "+SM0->M0_CODIGO
EndIf	

aadd(aCliente,{'Mastercard'			,'820001'})
aadd(aCliente,{'Visa'				,'820002'})
aadd(aCliente,{'Alelo'				,'820003'})
aadd(aCliente,{'Elo'				,'820004'})
aadd(aCliente,{'Hipercard'			,'820005'})
aadd(aCliente,{'American Express'	,'820006'})
aadd(aCliente,{'Credsystem'			,'820007'})

aadd(aForma,{"Débito à vista"	,"CD","0403002000"}) //Naturaze - Faturamento Cartão Debito
aadd(aForma,{"Crédito à vista"	,"CC","0403001000"}) //Naturaze - Faturamento Cartão Credito
aadd(aForma,{"Voucher"			,"VA","0403003000"})  //Naturaze - Faturamento Cartão Voucher

aCielo:=I000Carga(cOrigem+cArq)
//1- Data de venda	
//2 - NSU /	_DOCTEF
//3 - Código da autorização	/ _NSUTEF OU L4_AUTORIZ
//4 - Número do cartão	
//5 - Código da venda	
//6 - Bandeira	
//7 - Forma de pagamento	
//8 - Data de pagamento	
//9 - Valor bruto	
//10 - Taxa	
//11 - Valor líquido    
cHist:=DTOC(dDataBase)+" - "+time()
cTexto += "Executado em:"+cHist+CHR(13)+CHR(10)
For nI:=2 to Len(aCielo)
	cNat	:="0403000000"
	cTipo	:=""
	cDOC	:=""
	cSerie	:=""
	cVal  := StrTran( aCielo[nI,9], "R$", "  " )
	cVal  := StrTran(cVal, ",", "." )

    cDocTef	:=Subs(Alltrim(aCielo[nI,2])+Space(20),1,TAMSX3("L4_DOCTEF")[1])
	dbSelectArea("SL4")
	SL4->(dbSetorder(2)) //L4_FILIAL+L4_DATATEF+L4_DOCTEF                                                                                                                                  
	If SL4->(dbSeek(xFilial("SL4")+dToS(cToD(aCielo[nI,1]))+aCielo[nI,2],.F.))
		nRegSL4	:= SL4->(RECNO())
		cSL4Num	:= SL4->L4_NUM
		cDocTef	:= SL4->L4_DOCTEF
		cAutoriz:= SL4->L4_AUTORIZ
		If SL4->L4_VALOR<>VAL(cVal)
			SL4->(dbSetorder(1)) //L4_FILIAL+L4_NUM+L4_ORIGEM                                                                                                                                      
			If SL4->(dbSeek(xFilial("SL4")+cSL4Num,.F.))
				lSL4OK:=.F.
				While !SL4->(Eof()).And.SL4->L4_FILIAL==xFilial("SL4").And. SL4->L4_NUM==cSL4Num
					If SL4->L4_VALOR==VAL(cVal)
						SL4->(Reclock("SL4",.F.))
						SL4->L4_DOCTEF	:= cDocTef
						SL4->L4_AUTORIZ	:= cAutoriz
						SL4->L4_NUMCART	:= SL4->L4_DOCTEF
						SL4->L4_RG		:= '1'
						SL4->(MsUnlock())
						lSL4OK:=.T.
				        nRegSL4Aux:= SL4->(RECNO())
						Exit
	                EndIf
					SL4->(dbSkip())
				End 
				If lSl4OK
					SL4->(dbgoto(nRegSL4))
					SL4->(Reclock("SL4",.F.))
					SL4->L4_DOCTEF	:= ""
					SL4->L4_AUTORIZ	:= ""
					SL4->L4_NUMCART	:= SL4->L4_DOCTEF
					SL4->L4_RG		:= '2'
					SL4->(MsUnlock())
					SL4->(dbgoto(nRegSL4Aux))
				EndIf
			EndIf
			//SL4->(dbSetorder(2)) //L4_FILIAL+L4_DATATEF+L4_DOCTEF                                                                                                                                  
		EndIf		
		SL4->(Reclock("SL4",.F.))
		SL4->L4_OBS	:= cHist
		SL4->(MsUnlock())

		dbSelectArea("SL1")
		SL1->(dbSetorder(1)) //L1_FILIAL+L1_NUM                                                                                                                                                
		If SL1->(dbSeek(xFilial("SL1")+SL4->L4_NUM,.F.))
			cDOC	:= SL1->L1_DOC
			cSerie	:= SL1->L1_SERIE
        EndIf
		cParcela:=SL4->L4_PARCTEF // APOS A EXECUCAO DO I000SL4PARC....
		cTipo	:=Subs(SL4->L4_FORMA,1,TAMSX3("E1_TIPO")[1])
		dbSelectArea("SE1")
		SE1->(dbSetorder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                                                  
		If SE1->(dbSeek(xFilial("SE1")+cSerie+cDoc+cParcela+cTipo,.F.))
			cCli:=Upper(aCielo[nI,6]) //Importar SA1 8XYYYY - Onde 8-clientes de cartao; x-filial;Y - sequencia de clientes
			nPos:= Ascan( aCliente,{|X| Upper(X[1])==cCli})
			If nPos<>0
				cCli:=aCliente[nPos,2]
    		EndIf
			cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCli+"02","A1_NOME")
			cForma:=Upper(aCielo[nI,7])
			If (nPos:= Ascan( aForma,{|X| Upper(X[1])==cForma}))<>0
				cNat	:=aForma[nPos,3]
				cTipo	:=aForma[nPos,2]
			EndIf
			cVal  := StrTran( aCielo[nI,11], "R$", "  " )
			cVal  := StrTran(cVal, ",", "." )

			cCart := repli("*",TAMSX3("E1_NUMCART")[1])+aCielo[nI,4]
			cCart := Right(cCart,TAMSX3("E1_NUMCART")[1])
			dbSelectArea("SE1")
			SE1->(Reclock("SE1",.F.))
			SE1->E1_DOCTEF	:= If(Empty(SE1->E1_DOCTEF),aCielo[nI,2],SE1->E1_DOCTEF)
			SE1->E1_NSUTEF	:= If(Empty(SE1->E1_NSUTEF),aCielo[nI,3],SE1->E1_NSUTEF)
			SE1->E1_VLCRUZ	:= Val(cVal)
			SE1->E1_SALDO	:= If(!empty(SE1->E1_SALDO),Val(cVal),SE1->E1_SALDO)
			//SE1->E1_VLRREAL	:= Val(aCielo[nI,9])
			SE1->E1_VALOR	:= Val(cVal)
			SE1->E1_VENCREA	:= cToD(aCielo[nI,8])
			SE1->E1_VENCTO	:= cToD(aCielo[nI,8])
			SE1->E1_TIPO	:= If(!Empty(cTipo),cTipo,SE1->E1_TIPO)
			SE1->E1_NATUREZ	:= cNat
            SE1->E1_NOMCLI	:= cNomeCli
		    SE1->E1_CLIENTE	:= cCli
		    SE1->E1_LOJA	:= "02"
			SE1->E1_NUMCART	:= cCart
			SE1->E1_HIST	:= cHist
			SE1->(MsUnlock())
			cTexto += 'Cielo ->Linha:['+STR(nI,5)+"] Recno SE1->"+Str(SE1->(Recno()),8)+" Data:"+aCielo[nI,1]+" - NSU:"+aCielo[nI,2]+" [OK]"+CHR(13)+CHR(10)
		EndIf
    Else
		cTexto += 'Cielo ->Linha:['+STR(nI,5)+"] Recno SL4->"+Str(SL4->(Recno()),8)+" Data:"+aCielo[nI,1]+" - NSU:"+aCielo[nI,2]+" [Error]"+CHR(13)+CHR(10)
    EndIf
Next nI

Return cTexto

/*
	If SE1->(dbSeek(xFilial("SE1")+dToS(cToD(aCielo[nI,1]))+aCielo[nI,3],.F.))
		If SE1->E1_VALOR==aCielo[nI,1]
			cCli:=Upper(aCielo[nI,6])
			nPos:= Ascan( aCliente,{|X| Upper(X[1])==cCli})
			If nPos<>0
				cCli:=aCliente[nPos,2]
    		EndIf
			cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCli+"02","A1_NOME")
			cForma:=Upper(aCielo[nI,7])
			If (nPos:= Ascan( aForma,{|X| Upper(X[1])==cForma}))<>0
				cNat	:=aForma[nPos,3]

*/




Static Function I000SL4Parc(cTexto) //- Parcela no SL4
Local dDataInic	:= CTOD('01/01/19')
Local aParc		:= {0,0,0}
Local cForma	:= ""
Local cParcela 	:= ""
Local c1DUP 	:= SuperGetMV("MV_1DUP") 						// Sequência das parcelas "1" = 1..9;A..Z;a..z    e   "A" = A..Z
Local dData		:= CTOD('')
Local cFilial	:= SM0->M0_CODIGO

dbSelectArea("SL1")
SL1->(dbSetorder(4)) //L1_FILIAL+DtoS(L1_EMISSAO)

SL1->(dbSeek(xFilial("SL1")+DTOS(dDataInic),.T.))
dDataInic:=SL1->L1_EMISSAO //Paga a Primeira data da mais proxima solicitada
While !SL1->(Eof()).And.SL1->L1_FILIAL==cFilial.And.DtoS(SL1->L1_EMISSAO)>=DTOS(dDataInic)
	If SL1->L1_EMISSAO<> dData	
		Conout("Filial: "+SL1->L1_FILIAL+ " Data :"+Dtoc(SL1->L1_EMISSAO)+" - "+Time()+" >"+SL1->L1_FILIAL+DtoS(SL1->L1_EMISSAO) +" >= "+xFilial("SL1")+DTOS(dDataInic))
		dData:=SL1->L1_EMISSAO
        EndIf
	//cTexto += 'Orcamento ->:['+SL1->L1_NUM+"] Data:"+DTOC(SL1->L1_EMISSAO)+" Recno SL1->"+Str(SL1->(Recno()),8)+CHR(13)+CHR(10)
	SL4->(dbSetorder(1)) //L4_FILIAL+L4_NUM+L4_ORIGEM                                                                                                                                      
	If SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM,.F.))
		aParc:={0,0,0,0}		
		While !SL4->(Eof()).And.SL4->L4_FILIAL+SL4->L4_NUM==xFilial("SL4")+SL1->L1_NUM
		    cForma:=Alltrim(SL4->L4_FORMA)
			cParcela:="" 
			Do Case
				Case cForma == "CC"
					aParc[1]++
					cParcela:= LJParcela(aParc[1], c1DUP)
				Case cForma == "CD"
					aParc[2]++
					cParcela:= LJParcela(aParc[2], c1DUP)
				Case cForma == "VA"
					aParc[3]++
					cParcela:= LJParcela(aParc[3], c1DUP)
				Case cForma == "CO"
					aParc[4]++
					cParcela:= LJParcela(aParc[4], c1DUP)
			EndCase
			SL4->(Reclock("SL4",.F.))
			SL4->L4_PARCTEF	:= cParcela 
			SL4->L4_DATATEF:=DTOS(SL4->L4_DATA)
			SL4->(MsUnlock())
			//cTexto += '.............['+SL4->L4_NUM+"] FORMA:"+SL4->L4_FORMA+" Parcela: "+SL4->L4_PARCTEF+" Valor: "+str(SL4->L4_VALOR,9,2)+CHR(13)+CHR(10)
			SL4->(dbSkip())
		End	
	EndIf
	SL1->(dbSkip())
End	
	
Return cTexto



//===========================================================================================================================================
//===========================================================================================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡„o ³Cria Estrutura do arquivo de trabalho   					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data	 ³  														  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I000TmpSL4(dDataInic, dDataFim,cFl)
//Local cAlias		:= GetNextAlias()
Local cAlias		:= "TmpSL4"
Local cQuery

cQuery := "SELECT "
cQuery += "SL4.L4_DATA AS DATA,"
cQuery += "SL1.L1_HORA AS HORA,"
cQuery += "SL4.L4_DOCTEF AS DOCTEF,"
cQuery += "SL4.L4_AUTORIZ AS AUTORIZ,"
cQuery += "SL4.L4_FORMA AS FORMA,"
cQuery += "SL4.L4_VALOR AS VALOR,"
cQuery += "SL1.L1_VLRLIQ AS TOTAL,"
cQuery += "SL4.L4_PARCTEF AS PARCELA,"
cQuery += "SL1.L1_NUM AS NUMERO,"
cQuery += "SL1.L1_OPERADO AS CAIXA, "
cQuery += "SL1.L1_PDV AS PDV,"
cQuery += "SL1.L1_DOC AS CUPOM,"
cQuery += "SL1.L1_SERIE AS SERIE,"
cQuery += "SL4.L4_DOC AS SINAL,"
cQuery += "'       ' AS CLIENTE,"
cQuery += "SL4.L4_NUMCART AS CARTAO,"
cQuery += "'0' AS FLAG,"
cQuery += "'                                         ' AS OBSERV, "
cQuery += "CAST(SL4.R_E_C_N_O_ AS VarChar(10)) AS REGISTRO "
//cQuery += "SL4.R_E_C_N_O_ AS XREG "
cQuery += "FROM "+RetSQLName("SL1")+" SL1 LEFT JOIN "+RetSQLName("SL4")+ " AS SL4 on SL1.L1_FILIAL=SL4.L4_FILIAL AND SL1.L1_NUM = SL4.L4_NUM "
cQuery += "WHERE SL1.L1_EMISSAO>='"+DTOS(dDataInic)+"' AND SL1.L1_EMISSAO<='"+DTOS(dDataFim)+"' AND SL1.L1_FILIAL='"+cFl+"' AND SL1.D_E_L_E_T_<>'*' "
cQuery += "ORDER BY NUMERO"
	
cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )
TCSetField(cAlias, "DATA"	 , "D")
TCSetField(cAlias, "VALOR"	 , "N",10,2)
TCSetField(cAlias, "TOTAL"	 , "N",10,2)
//TCSetField(cAlias, "XREG", "C")


Return cAlias

//===========================================================================================================================================
//===========================================================================================================================================
Static function I000Cielo3(cTexto)
Local cArq			:="cielo.csv"
Local cOrigem		:=GetPvProfString( "INNO","EXCEL", "C:\", GetRemoteIniName()) //Local onde fica os arquivos do Excel
Local dDataInic		:= CTOD('19/05/19')
Local cCart			:= ""
Local cValB 		:= ""
Local cValL 		:= ""
Local aCliente		:= {}
Local aArq	       := {}

Private cTemp      := GetTempPath() //pega caminho do temp do client
Private nLinTit    := 0
Private aRet       := {}
Private nInic	   := 1  // Linha de inicio de pesquisa do array aCielo

If  SM0->M0_CODFIL<>'02'
	Return cTexto += 'Loja não Processada ->:['+SM0->M0_CODFIL+CHR(13)+CHR(10)
EndIf 

aadd(aCliente,{'Mastercard'			,'820001'})
aadd(aCliente,{'Visa'				,'820002'})
aadd(aCliente,{'Alelo'				,'820003'})
aadd(aCliente,{'Elo'				,'820004'})
aadd(aCliente,{'Hipercard'			,'820005'})
aadd(aCliente,{'American Express'	,'820006'})
aadd(aCliente,{'Credsystem'			,'820007'})

aArq:=I000Carga(cOrigem+cArq) //TRB1 - Cielo.csv e TRB2 - Prothes SL1 + SL4

cHist:=DTOC(dDataBase)+" - "+time()
cTexto += "Executado em:"+cHist+CHR(13)+CHR(10)

//--------------------------
dbSelectArea("TRB1")
TRB1->(dbSetOrder(1))

dbSelectArea("TRB2")
TRB2->(dbSetOrder(1))
TRB2->(dbGotop())
While !TRB2->(Eof())
	//cTexto += 'Orcamento ->:['+SL1->L1_NUM+"] Data:"+DTOC(SL1->L1_EMISSAO)+" Recno SL1->"+Str(SL1->(Recno()),8)+CHR(13)+CHR(10)
	If Alltrim(TRB2->FORMA)=="R$"
		TRB2->(dbSkip())
		Loop
	EndIf	
	cDocTef	:= TRB2->DOCTEF
	cAutoriz:= TRB2->AUTORIZ
	cParcela:= Subs(TRB2->PARCELA,1,TAMSX3("E1_PARCELA")[1]) // APOS A EXECUCAO DO I000SL4PARC....
	cTipo	:= Subs(TRB2->FORMA,1,TAMSX3("E1_TIPO")[1])
	cDOC	:= TRB2->CUPOM
	cSerie	:= TRB2->SERIE

	lDocTef	:= .F.
	lVal	:= .F.
	lData	:= .F.
	lAutoriz:= .F.
	lForma	:= .F.

	lGrava:=.F.
	cFlag:= "1"

	cErro:=""
	TRB1->(dbSetOrder(1))
	If TRB1->(dbSeek(TRB2->DOCTEF,.F.))
		lDocTef	:= .T.
    EndIf
    
	If !lDocTef // SE NAO ENCONTRAR PELO DOCTEF, PESQUISE PELA AUTORIZACAO
		TRB1->(dbSetOrder(2))
		If TRB1->(dbSeek(TRB2->AUTORIZ,.F.))
			lAutoriz:=.T.
		EndIf
	EndIf
	
	If lDocTef .Or.lAutoriz
		If TRB1->FLAG$"A#B#C#D#E"
			TRB2->(Reclock("TRB2",.F.))
			TRB2->FLAG  	:= "9"
			TRB2->OBSERV	:= "Error : Duplicado "+If(lDocTef,"DOCTEF","AUTORIZACAO")
			TRB2->CLIENTE	:= cCli
			TRB2->(MsUnlock())
			TRB2->(dbSkip())
			Loop
		EndIf	
		If TRB2->VALOR == TRB1->VBRUTO
			lVal:=.T.
		Else
			cErro+="Valor - "
		EndIf

		If DTOS(TRB2->DATA) == DTOS(TRB1->DATAVEND)
			lData:=.T.
		Else
			cErro+="Data - "
		EndIf

		If Alltrim(TRB2->FORMA)== Alltrim(TRB1->FORMA)
			lForma:=.T.
		Else
			cErro+="Forma - "
		EndIf
		
		If lDocTef
			If TRB2->AUTORIZ == TRB1->AUTORIZ
				lAutoriz:=.T.
			Else
				cErro+="Autorizacao - "
			EndIf
    	EndIf
		If !lDocTef
			cErro+="DOCTEF - "
		EndIf
    Else
		cErro+="Nao Encontrado no arquivo da Cielo - Ticket Restaurante?"    	
		cFlag:= "8"
    EndIf
	If lDocTef .And. lVal .and. lData .And. lAutoriz .And. lForma
		lGrava:=.T.
		cErro:="Nenhum"
		cFlag:= "A"
    ElseIf lDocTef .And. lVal .and. lData .And. lForma //Erro de Autorizacao
		cFlag:= "B"
		//cErro:="Autorizacao - Protheus:"+TRB2->AUTORIZ+ " Cielo :"+TRB1->AUTORIZ
        lGrava:=.T.
    ElseIf lAutoriz .And. lVal .and. lData .And. lForma //Erro de DOCTEF
		cFlag:= "C"
		//cErro:="Autorizacao - Protheus:"+TRB2->AUTORIZ+ " Cielo :"+TRB1->AUTORIZ
        lGrava:=.T.
	ElseIf lDocTef .And. lData .And. lAutoriz .And. lForma //Erro de Valor
		If Abs(TRB2->VALOR - TRB1->VBRUTO)<1 //Permitr se o valor for < R$ 1,00
			cFlag:= "D"
			//cErro:="Valor - Protheus:"+str(TRB2->VALOR,9,2)+ " Cielo :"+STR(TRB1->VBRUTO,9,2)
			lGrava:=.T.
		EndIf	
	Else 
		If lDocTef
			If I000Err2() //Erro de gravacao sistema quando 2 parcelas gravava DOCTEF e AUTORIZ somente na primeira
				Loop
			EndIf
		EndIf
	EndIf
	cCli:=Alltrim(Upper(TRB1->BANDEIRA)) //Importar SA1 8XYYYY - Onde 8-clientes de cartao; x-filial;Y - sequencia de clientes
	nP:= Ascan( aCliente,{|X| Alltrim(Upper(X[1]))==cCli})
	If nP<>0
		cCli:=aCliente[nP,2]
	EndIf
	TRB2->(Reclock("TRB2",.F.))
	TRB2->CARTAO  	:= TRB1->CARTAO
    /*
	If !lAutoriz
		TRB2->AUTORIZ 	:= TRB1->AUTORIZ
	EndIf	
    */
	TRB2->FLAG  	:= cFlag
	TRB2->OBSERV	:= "Error :"+cErro
	TRB2->CLIENTE	:= cCli
	TRB2->(MsUnlock())
    // --------------- Marcar arquivo da cielo -------------
 	If lDocTef .or. lAutoriz
		TRB1->(Reclock("TRB1",.F.))
		If cFlag$"A#B#C#D#E"
			TRB1->HORA  	:= TRB2->HORA
		EndIf	
		TRB1->FLAG  	:= cFlag
		TRB1->OBSERV	:= "Error :"+cErro
		TRB1->(MsUnlock())
	EndIf
	TRB2->(dbSkip())
End	
//----------------------------------------------- processamento das inconsistencias --------------------------
/*
dbSelectArea("TRB2")
TRB2->(dbSetOrder(1))
TRB2->(dbGotop())
While !TRB2->(Eof())
	//cTexto += 'Orcamento ->:['+SL1->L1_NUM+"] Data:"+DTOC(SL1->L1_EMISSAO)+" Recno SL1->"+Str(SL1->(Recno()),8)+CHR(13)+CHR(10)
	If !Alltrim(TRB2->FLAG)$"0#1#9"
		TRB2->(dbSkip())
		Loop
	EndIf	
	If Alltrim(TRB2->FORMA)=="R$"
		TRB2->(dbSkip())
		Loop
	EndIf	
	
	nVal	:= TRB2->VALOR
	cForma 	:= Alltrim(TRB2->FORMA)	

	lVal	:= .F.
	lData	:= .F.
	lAutoriz:= .F.
	lForma	:= .F.

	lGrava:=.F.
	cFlag:= "1"
	cErro:=""

	dbSelectArea("TRB1")
	TRB1->(dbSetOrder(3))
	TRB1->(dbGotop())
	While !TRB1->(Eof()).and. Val(TRB1->FLAG)<=1
		If !Alltrim(TRB1->FLAG)$"0#1"
			TRB1->(dbSkip())
			Loop
		EndIf	
		If TRB2->VALOR == TRB1->VBRUTO
			lVal:=.T.
		EndIf
		If DTOS(TRB2->DATA) == DTOS(TRB1->DATAVEND)
			lData:=.T.
		EndIf
		If Alltrim(TRB2->FORMA)== Alltrim(TRB1->FORMA)
			lForma:=.T.
		EndIf
        If lVal .And. lData .And. lForma
			cFlag:= "E"
			cErro:=" 2o. Processamento"
			lGrava:=.T.
			Exit
        Else
			TRB1->(dbSkip())
        EndIf
    End

	If lGrava
		cCli:=Alltrim(Upper(TRB1->BANDEIRA)) //Importar SA1 8XYYYY - Onde 8-clientes de cartao; x-filial;Y - sequencia de clientes
		nP:= Ascan( aCliente,{|X| Alltrim(Upper(X[1]))==cCli})
		If nP<>0
			cCli:=aCliente[nP,2]
		EndIf

		TRB2->(Reclock("TRB2",.F.))
		TRB2->CARTAO  	:= TRB1->CARTAO
		TRB2->DOCTEF 	:= TRB1->DOCTEF
		TRB2->AUTORIZ 	:= TRB1->AUTORIZ
		TRB2->FLAG  	:= cFlag
		TRB2->OBSERV	:= Alltrim(TRB2->OBSERV)+" Error :"+cErro
		TRB2->CLIENTE	:= cCli
		TRB2->(MsUnlock())
	    // --------------- Marcar arquivo da cielo -------------
		TRB1->(Reclock("TRB1",.F.))
		TRB1->FLAG  	:= cFlag
		TRB1->OBSERV	:= Alltrim(TRB2->OBSERV)+" Error :"+cErro
		TRB1->(MsUnlock())
	EndIf
	TRB2->(dbSkip())
End	
*/

cTexto += 'Arquivo Cielo......>:'+aArq[1]+CHR(13)+CHR(10)
cTexto += 'Arquivo Protheus..->:'+aArq[2]+CHR(13)+CHR(10)

//Rotina para ajuste SL4

//Rotina para ajuste SE1

Return cTexto


//===========================================================================================================================================
//===========================================================================================================================================
Static Function I000Carga(cArq)
Local cLinha  := ""
Local nLin    := 1 
Local nTotLin := 0
Local aDados  := {}
Local cFile   := cArq
Local nHandle := 0
Local cTRB1   := ""
Local cTRB2   := ""
Local aCliente:={}
Local aForma  :={}

//abre o arquivo csv gerado na temp
nHandle := Ft_Fuse(cFile)
If nHandle == -1
   Return aDados
EndIf
Ft_FGoTop()                                                         
nLinTot := FT_FLastRec()-1
ProcRegua(nLinTot)
//Pula as linhas de cabeçalho
While nLinTit > 0 .AND. !Ft_FEof()
   Ft_FSkip()
   nLinTit--
EndDo

//percorre todas linhas do arquivo csv
Do While !Ft_FEof()
   //exibe a linha a ser lida
   IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
   nLin++
   //le a linha
   cLinha := Ft_FReadLn()
   //verifica se a linha está em branco, se estiver pula
   If Empty(AllTrim(StrTran(cLinha,';','')))
      Ft_FSkip()
      Loop
   EndIf
   //transforma as aspas duplas em aspas simples
   cLinha := StrTran(cLinha,'"',"'")
   cLinha := '{"'+cLinha+'"}' 
   //adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array 
   cLinha := StrTran(cLinha,';','","')
   aAdd(aDados, &cLinha)
   
   //passa para a próxima linha
   FT_FSkip()
   //
EndDo

//libera o arquivo CSV
FT_FUse()             

//Exclui o arquivo csv
/*
If File(cFile)
   FErase(cFile)
EndIf
*/

//-------------------------------- Carrega os dados Cielos
//1- Data de venda	
//2 - NSU /	_DOCTEF
//3 - Código da autorização	/ _NSUTEF OU L4_AUTORIZ
//4 - Número do cartão	
//5 - Código da venda	
//6 - Bandeira	
//7 - Forma de pagamento	
//8 - Data de pagamento	
//9 - Valor bruto	
//10 - Taxa	
//11 - Valor líquido    

aadd(aCliente,{'Mastercard'			,'820001'})
aadd(aCliente,{'Visa'				,'820002'})
aadd(aCliente,{'Alelo'				,'820003'})
aadd(aCliente,{'Elo'				,'820004'})
aadd(aCliente,{'Hipercard'			,'820005'})
aadd(aCliente,{'American Express'	,'820006'})
aadd(aCliente,{'Credsystem'			,'820007'})

aadd(aForma,{"Débito à vista"	,"CD","0403002000"}) //Naturaze - Faturamento Cartão Debito
aadd(aForma,{"Crédito à vista"	,"CC","0403001000"}) //Naturaze - Faturamento Cartão Credito
aadd(aForma,{"Voucher"			,"VA","0403003000"})  //Naturaze - Faturamento Cartão Voucher

nPos	:= 0
cLin	:= ""
nLin	:= Ascan( aDados,{|X| nPos:=At("Período:",X[1])})
//Data Inicio
cLin	:= aDados[nLin,1]
cLin	:= AllTrim(subs(cLin,nPos+8))
cDat1	:= Subs(Alltrim(subs(aDados[nLin,1],nPos+8)),1,10)

//Data Final
nPos:=At("à",cLin)
cLin	:= AllTrim(subs(cLin,nPos+1))
cDat2	:= cLin

nPos	:= 0
cLin	:= ""
nLin	:= 0
nInic:=Ascan( aDados,{|X| Upper(X[1])=="DATA DE VENDA"})+1

cTRB1:=I000TmpArq() //Criação do Arquivos Temporario TRB

dbSelectArea("TRB1")
TRB1->(dbSetorder(1)) //

For nI:=nInic to Len(aDados)
	TRB1->(Reclock("TRB1",.T.))
	//1- Data de venda	
	//2 - NSU /	_DOCTEF
	//3 - Código da autorização	/ _NSUTEF OU L4_AUTORIZ
	//4 - Número do cartão	
	//5 - Código da venda	
	//6 - Bandeira	
	//7 - Forma de pagamento	
	//8 - Data de pagamento	
	//9 - Valor bruto	
	//10 - Taxa	
	//11 - Valor líquido    
	cCart 	:= repli("*",TAMSX3("E1_NUMCART")[1])+aDados[nI,4]
	cCart 	:= Right(cCart,TAMSX3("E1_NUMCART")[1])

	cValB  := StrTran( aDados[nI,9], "R$", "  " )
	cValB  := StrTran(cValB, ",", "." )
	
	cValL  := StrTran( aDados[nI,11], "R$", "  " )
	cValL  := StrTran(cValL, ",", "." )

	cForma:=Upper(aDados[nI,7])
	If (nP:= Ascan( aForma,{|X| Upper(X[1])==cForma}))<>0
		cNat	:= aForma[nP,3]
		cTipo	:= aForma[nP,2]
	EndIf
	TRB1->DATAVEND	:=  CToD(aDados[nI,1])
	TRB1->DOCTEF	:=  aDados[nI,2]
	TRB1->AUTORIZ	:=  aDados[nI,3]
	TRB1->CARTAO	:=  cCart
	TRB1->CODVENDA	:=  aDados[nI,5]
	TRB1->BANDEIRA	:=  aDados[nI,6] 
	TRB1->FORMA		:=  cTipo
	TRB1->NATUREZ	:=  cNat
	TRB1->DATAPAG	:=  CTOD(aDados[nI,8])
	TRB1->VBRUTO	:=  Val(cValB)
	TRB1->TAXA		:=  aDados[nI,10]
	TRB1->VLIQ		:=  Val(cValL)
	TRB1->FLAG		:=  "0"
	TRB1->(MsUnlock())
Next nI

//---------------------------------------- Carrega dados Query ------------------
dDataInic	:=cToD(cDat1)
dDataFim	:=cToD(cDat2)

I000TmpSL4(dDataInic, dDataFim,"02") // Leitura da query

//cTRB2   := Left(CriaTrab(Nil, .F. ),7)+"A"
cTRB2   := CriaTrab(Nil, .F. )

//COPY TO &cAlias"TMPSL4" VIA "DBFCDXADS" 
COPY TO &cTRB2 VIA "DBFCDXADS" 

dbUseArea(.T.,,cTRB2,"TRB2",.F.,.F.)
IndRegua("TRB2",cTRB2,"NUMERO",,,"Selecionando Registros...")  //

DbClearIndex()
DbSetIndex(cTRB2 + OrdBagExt())

//cPathSx 	:= Alltrim(GetPvProfString(GetEnvServer(),"rootpath","",GetADV97())) + "\SYSTEM\"	// Retorna o StartPath
//CpyS2T( cDirDocs+"\"+cArquivo+".DBF" , cPath, .T. ) 

Return {cTRB1,cTRB2}


//===========================================================================================================================================
//===========================================================================================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡„o ³Cria Estrutura do arquivo de trabalho   					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data	 ³  														  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I000TmpArq()
Local aTMPStru1 := {} // Carga da CIELO
Local aTMPStru2 := {} // Carga SL1+SL4

//1- Data de venda	
//2 - NSU /	_DOCTEF
//3 - Código da autorização	/ _NSUTEF OU L4_AUTORIZ
//4 - Número do cartão	
//5 - Código da venda	
//6 - Bandeira	
//7 - Forma de pagamento	
//8 - Data de pagamento	
//9 - Valor bruto	
//10 - Taxa	
//11 - Valor líquido    

aadd(aTMPStru1,{"DATAVEND  ","D",8,0})
aadd(aTMPStru1,{"HORA      ","C",05,0})
aadd(aTMPStru1,{"DOCTEF    ","C",06,0})
aadd(aTMPStru1,{"AUTORIZ   ","C",06,0})
aadd(aTMPStru1,{"CARTAO    ","C",19,0})
aadd(aTMPStru1,{"CODVENDA  ","C",20,0})
aadd(aTMPStru1,{"BANDEIRA  ","C",30,0})
aadd(aTMPStru1,{"FORMA     ","C",30,0})
aadd(aTMPStru1,{"DATAPAG   ","D",8,0})
aadd(aTMPStru1,{"VBRUTO    ","N",18,2})
aadd(aTMPStru1,{"TAXA      ","C",18,0})
aadd(aTMPStru1,{"VLIQ      ","N",18,2})
aadd(aTMPStru1,{"NATUREZ   ","C",10,0})
aadd(aTMPStru1,{"FLAG      ","C",01,0})
aadd(aTMPStru1,{"OBSERV    ","C",40,0})

cArqRec1 := CriaTrab(aTMPStru1, .T. )
cArqRec2 := Left(CriaTrab(Nil, .F. ),7)+"A"
cArqRec3 := Left(CriaTrab(Nil, .F. ),7)+"B"
dbUseArea(.T.,,cArqRec1,"TRB1",.F.,.F.)
IndRegua("TRB1",cArqRec1,"DOCTEF" ,,,"Selecionando Registros...")  //"Selecionando Registros..."
IndRegua("TRB1",cArqRec2,"AUTORIZ",,,"Selecionando Registros...")  //"Selecionando Registros..."
IndRegua("TRB1",cArqRec3,"FLAG"   ,,,"Selecionando Registros...")  //"Selecionando Registros..."
DbClearIndex()
DbSetIndex(cArqRec1 + OrdBagExt())
DbSetIndex(cArqRec2 + OrdBagExt())
DbSetIndex(cArqRec3 + OrdBagExt())

Return cArqRec1

//===========================================================================================================================================
//===========================================================================================================================================
Static Function I000Err2()
Local cNumero	:= TRB2->NUMERO
Local nReg	 	:= TRB2->(RECNO())
Local cDocTef	:= TRB2->DOCTEF
Local cAutoriz	:= TRB2->AUTORIZ
Local lRet		:= .F.

While !TRB2->(Eof()).And.TRB2->NUMERO==cNumero
	
	lDocTef	:= .F.
	lVal	:= .F.
	lData	:= .F.
	lAutoriz:= .F.
	lForma	:= .F.

	TRB1->(dbSetOrder(1))
	If TRB1->(dbSeek(TRB2->DOCTEF,.F.))
		lDocTef	:= .T.
    EndIf
    
	If !lDocTef // SE NAO ENCONTRAR PELO DOCTEF, PESQUISE PELA AUTORIZACAO
		TRB1->(dbSetOrder(2))
		If TRB1->(dbSeek(TRB2->AUTORIZ,.F.))
			lAutoriz:=.T.
		EndIf
	EndIf
	
	If lDocTef .Or.lAutoriz
		If TRB2->VALOR == TRB1->VBRUTO
			lVal:=.T.
		EndIf

		If DTOS(TRB2->DATA) == DTOS(TRB1->DATAVEND)
			lData:=.T.
		EndIf

		If Alltrim(TRB2->FORMA) == Alltrim(TRB1->FORMA)
			lForma:=.T.
		EndIf

		If lDocTef .and.(TRB2->AUTORIZ == TRB1->AUTORIZ)
			lAutoriz:=.T.
		EndIf
    EndIf

	lGrava:=.F.
	If lDocTef .And. lVal .and. lData .And. lAutoriz .And. lForma
		lGrava:=.T.
	ElseIf lDocTef .And. lVal .and. lData .And. lForma
		lGrava:=.T.
	ElseIf lAutoriz .And. lVal .and. lData .And. lForma
		lGrava:=.T.
	EndIf
    If lGrava
		nRegAux:=TRB2->(RECNO())
		TRB2->(Reclock("TRB2",.F.))
		TRB2->DOCTEF := If(lDocTef,cDocTef,TRB1->DOCREF)
		TRB2->AUTORIZ:= If(lAutoriz,cAutoriz,TRB1->AUTORIZ)
		TRB2->(MsUnlock())
		
		TRB2->(dbGoto(nRegSL4))
		TRB2->(Reclock("TRB2",.F.))
		TRB2->DOCTEF	:= ""
		TRB2->AUTORIZ	:= ""
		TRB2->(MsUnlock())
		lRet:=.T.
		Exit
	EndIf	
    TRB2->(dbSkip())
End    
TRB2->(dbGoto(nReg))
Return lRet
