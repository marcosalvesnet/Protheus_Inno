#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#include "apvt100.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Array a Vendas                                        ³
//³		cCartao,		1                                  ³
//³		SA3->A3_COD,   	2                                  ³
//³		SBI->BI_COD,    3                                  ³
//³		SBI->BI_DESC,   4                                  ³
//³		nQuant,         5                                  ³
//³		SBI->BI_UM,  	6                                  ³
//³		SBI->BI_PRV,    7                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE NUMERO_CARTAO				1
#DEFINE CODIGO_ATENDENTE 			2
#DEFINE CODIGO_PRODUTO  			3
#DEFINE DESCRICAO_PRODUTO  			4
#DEFINE QUANTIDADE_PRODUTO      	5
#DEFINE UNIDADE_MEDIDA_PRODUTO		6
#DEFINE PRECO_UNITARIO_PRODUTO  	7
#DEFINE REGISTRO				 	8
#DEFINE DELETADO					9

Static cHora	
Static cNumTer
Static aCartao

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Inno222  ³Autor  ³ Marcos Alves          ³ Data ³ 08/12/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa que efetua um orcamento no Micro-Terminal          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Innocencio                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IA222()
Local cEmpInno	:=GetPvProfString( "TELNET","EMPRESA" , "", GetAdv97() )
Local cFilInno	:=GetPvProfString( "TELNET","FILIAL" , "", GetAdv97() )
Local lRpc		:=.F.
Private cFlag	:="x"
Private cVerMT	:="3.0"
Private cAvanca		:=GetPvProfString( "TELNET","AVANCA"	 , "A", GetAdv97() )//"A"
Private cRetorna	:=GetPvProfString( "TELNET","RETORNA"	 , "R", GetAdv97() )//"R"
Private cOpcaoSim	:=GetPvProfString( "TELNET","OPCAOSIM"	 , "S", GetAdv97() )//"S"
Private cOpcaoNao	:=GetPvProfString( "TELNET","OPCAONAO"	 , "N", GetAdv97() )//"N"
Private cDelete		:=GetPvProfString( "TELNET","DELETA" 	 , "D", GetAdv97() )//"D"

RpcSetType(3)
If !(lRpc:=RpcSetEnv(cEmpInno, cFilInno))
	conout("[Falha - Microterinal] [iniciado Empresa:"+cEmpInno+"]  [Filial :"+cFilInno+"]")         
    TerIsQuit()
EndIf

TerProtocolo("VT100")
VTConnect() 
cNumTer := TerNumTer()

conout("[Microterinal "+cNumTer+"] [iniciado Empresa:"+cEmpInno+"]  [Filial :"+cFilInno+"]")         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Execucao do rotina do Microterminal                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_IA222Data(cEmpInno,cFilInno)
     
VtDisconnect()
__SetX31Mode(.F.)
RpcClearEnv()

Return NIL

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³IA222Data  ³ Autor ³ Marcos Alves          ³ Data ³ 08/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Identificacao da aplicacao e Data Base          			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA222Data(cEmpInno,cFilInno)
Public dDataBase	:= MsDate()
VTSetSize(2,40)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Data Base                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.
   	VTClear()
	VTClearBuffer()
	dDataBase	:= MsDate()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³"[Doceira Innocencio] [MT:001][Ver.  2.0]"              ³
	//³"[Data Base:         ]    [Emp/Fil:99/01]"              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    //VTKeyboard(CHR(49))
    //VTKeyboard(CHR(50))
    //_Keyboard(CHR(13))
    
	@ 00,00 VTSay "[Doceira Innocencio] [MT:"+cNumTer+"][Ver.  "+cVerMT+"]"
	@ 01,00 VTSay "[Data Base:         ]    [Emp/Fil:"+cEmpInno+"/"+cFilInno+"]"
	@ 01,12 VTGet dDataBase Pict "99/99/99" Valid MTValidData(dDataBase)
	VTRead
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³"[1]Vendas		[2]Recebimento 		[3]Inventario      ³
	//³"Selecione a funcao:[1]                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Se o tecla pressionada for <ESC>
	If VTLastKey() == 27
		Loop
	EndIF
    Exit
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop de Venda                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IA222Venda()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³IA222Venda ³ Autor ³ Marcos Alves          ³ Data ³ 08/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Loop nas rotinas de Vendas                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA222Venda()
Local aItens	:= {}
Local aVendas	:= {}			//Array das vendas
Local nIFood	:=2				// Opcao para tabela ede preco iFood =1
Local lIfood	:=.T.			// Habilita get do Ifood

Private cCartao	:= Space(3)		//Numero do Cartao	
Private cAtend	:= Space(6)		//Atendente
Private	cProduto:= Space(6)		//Codigo do produto
Private	nQuant 	:= 1			//Quantidade de produto
Private nValTot	:=0				//Valor total do cartao

While .T.
	nIFood	:=2				// Opcao para tabela ede preco iFood =1
 	lIfood	:=.T.			// Habilita get do Ifood

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Numero do Cartao                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !IA222Cartao(@aVendas,@nIfood)
		Exit
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atendente                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !IA222Atend(nIfood)	
		Loop
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³iFood    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !IA222Ifood(@nIfood)
		Loop
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Produto e quantidade                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	I222Produto(@aVendas,nIfood)	
End
                      
dbCloseAll()
VTAlert("Microterminal finalizado...desligue!!!", "Atencao",.T.)
Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³IA222Cartao³ Autor ³ Marcos Alves          ³ Data ³ 08/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Identificacao do Cartao									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA222Cartao(aVendas,nIfood)
Local cString	:=I222Cabec("1")
Local lRet		:=.T.
dbSelectArea("SZX")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Numero do Carao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.
   	cCartao	:=Space(3)
	aVendas	:={}       
	nValTot	:=0

   	VTClear()
	VTClearBuffer()
    /*
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    "[LOJA - DI      ][MT:00]X[Ter - 08/12/09]"
    "[Cartao:000     ]                        "
    */
	VTClear()
	@ 00,00 VTSay cString
	@ 01,00 VTSay "[Cartao:   ]                            "
	@ 01,8 VTGet cCartao Pict "999" Valid I222CartVld(@nIfood) //Valid Cartao Bloqueado/aberto/cadstro
	VTRead
	// Se o tecla pressionada for <ESC>
	If Empty(cCartao).OR.VTLastKey() == 27
		If VTYesNo('Finalizar Microterminal?','Atencao ',.T.)
	       Return .F.
		Else
			Loop
		EndIf
    EndIf
	
	dbSelectArea("SZZ")
	dbSetOrder(1) //ZZ_FILIAL+ZZ_CARTAO
	SZZ->(dbSeek(xFilial("SZZ")+cCartao+"0")) //ZZ_FILIAL+ZZ_CARTAO
	While SZZ->ZZ_FILIAL+SZZ->ZZ_CARTAO==xFilial("SZZ")+cCartao.AND.SZZ->ZZ_FLAG=="0"
		SZZ->(RecLock("SZZ", .F.))
		//SZZ->ZZ_FLAG:=" "		//Limpar o flag
		SZZ->(MsUnLock())  
		aadd(aVendas,{	SZZ->ZZ_CARTAO,;
						SZZ->ZZ_VEND,;
						SZZ->ZZ_PRODUTO,;
						SZZ->ZZ_DESCRI,;
						SZZ->ZZ_QUANT,;
						SZZ->ZZ_UM,;
						SZZ->ZZ_VLRITEM,;
						SZZ->(recno()),;
						.F.})
		nValTot	+= NoRound(SZZ->ZZ_QUANT*SZZ->ZZ_VLRITEM,2)
		SZZ->(dbSkip())
	End	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Bloquear o uso do cartao                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHora	:=Time()
	U_I222TDCarttao({cCartao},cNumter,nValTot,nIfood)
    Exit
End
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³IA222Atend ³ Autor ³ Marcos Alves          ³ Data ³ 08/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Atendente             									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA222Atend(nIFood)
Local cString	:=I222Cabec("1")

dbSelectArea("SA3")	//Cadastro de vendedor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Numero do Carao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.
   	VTClear()
	VTClearBuffer()
	cAtend	:= Space(6)		//Atendente
    /*
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    "[LOJA - DI      ][MT:00]X[Ter - 08/12/09]"
    "[Atendente:00000]            [Cartao:000]"
    */
	@ 00,00 VTSay cString
	@ 01,00 VTSay "[Atendente:      ]          [Cartao:"+cCartao+"]"
	@ 01,11 VTGet cAtend Pict "999999" Valid IA222Vld() //Valid Cartao Bloqueado/aberto/cadstro
	VTRead
	// Se o tecla pressionada for <ESC>
	If VTLastKey() == 27
		//Desbloquear o cartao
		U_I222TDCarttao({cCartao},"",nValTot,nIfood)
		Return .F.
	EndIF               
	If Empty(cAtend)
		Loop
	EndIf	
    Exit
End

Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	³I222Produt³ Autor ³ Marcos Alves          ³ Data ³ 08/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao³Vendas dos produtos    									 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		³ Doceira Innocencio   								  	     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ³        ³      ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I222Produto(aVendas,nIfood)
Local cString	:="["+SA3->A3_COD+" - "+Alltrim(Subs(SA3->A3_NOME,1,18))+"]"
Local nSpace	:=(28-Len(cString))
Local cOpcao	:=""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravar o atendente                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SZX->(RecLock("SZX",.F.))
SZX->ZX_VEND	:=cAtend
SZX->(MsUnLock())  

dbSelectArea("SBI")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Atualizar valor do cartao para ser visualizado em I223LstVnd       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SZX->(RecLock("SZX",.F.))
	SZX->ZX_VLRLIQ	:=nValTot
	SZX->(MsUnLock())  

   	cProduto:=Space(6)
	nQuant	:=0
	
   	VTClear()
	VTClearBuffer()
    /*
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    "[000001 - Maria Aparecida   ][Cartao:000]"
    "[Produto:00000]		 [Total:99,999.99]"
     */
	@ 00,00 VTSay cString+Space(nSpace)+"[Cartao:"+cCartao+"]"
	//@ 01,00 VTSay "[Produto:      ]       [Total:"+Trans(nValTot,"@E 99,999.99")+"]"
	@ 01,00 VTSay "[Produto:      ]   "+If(nIfood<2,"F"," ")+"   [Total:"+Trans(nValTot,"@E 99,999.99")+"]"
	@ 01,9 VTGet cProduto picture "@!"	Valid IA222VldProd() //When .F.
	VTRead
	// Se o tecla pressionada for <ESC>
	If VTLastKey() == 27
		I222ExcItens(@aVendas)
		Loop
	EndIF
    If Empty(cProduto)
		Exit
	EndIf
	VTClear()
	VTClearBuffer() 
	@ 00,00 VTSay "["+Strzero(Len(aVendas)+1,3)+ "/"+Alltrim(Subs(SBI->BI_COD,1,6))+ "-"+Alltrim(Subs(SBI->BI_DESC,1,28))+"]"
	@ 01,00 VTSay "[Quantidade:       ] "+If(nIfood<2,"F"," ")+" [Preco:"+Trans(If(nIFood=1,SBI->BI_PRV2,SBI->BI_PRV),"@E 99,999.99")+"]"
	@ 01,12 VTGet nQuant picture If(SBI->BI_UM=="KG","@E 999.999"," @E 9999999")	
	VTRead
	If VTLastKey() == 27 .OR. nQuant=0
		Loop
	EndIF
	nValTot	+= NoRound(nQuant*If(nIFood=1,SBI->BI_PRV2,SBI->BI_PRV),2)
	//Gravar no Array
	aadd(aVendas,{cCartao,SA3->A3_COD,SBI->BI_COD,SBI->BI_DESC,nQuant,SBI->BI_UM,If(nIFood=1,SBI->BI_PRV2,SBI->BI_PRV),0,.F.})
End
U_I222Grv(aVendas,nValTot,,nIfood)

//Gravacao dos registros	

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTValidData ºAutor  ³Marcos Alve         º Data ³08/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validar se a data foi digitada                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTValidData(dData)
Local lRet := .T.
If Empty(dData)
   	lRet	:= .F.
    VTAlert("Data Invalida", "Atencao",.T.,2000)
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VTInnoAlert ºAutor  ³Marcos Alve         º Data ³08/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibir Msg no Microterminal                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VTInnoAlert(cMsg,cCaption,lCenter,nSleep,nBeep,lRestore)
Local i
Local nLen
Local aScr
Local cLine
Local aMsg := {}
Local nMaxCol := VTMaxCol()
Local nPadc
Local nRow1
Local nRow2                                        
Local lTerminal := (VTMaxRow()==1)                
Local nSec
Local nKey:=0

DEFAULT lRestore :=.T.

If nBeep#NIL
   VTBeep(nBeep)
EndIf

//Inicializa ambiente
VTInitialize()
If  ! lTerminal
	//centraliza msg
	VTSetCenter()
	
	nRow1 := __aVTAlert[1]
	nRow2 := __aVTAlert[2]
	nPadc := __aVTAlert[3]
	
	lCenter := If(lCenter == NIL,.F.,lCenter)
Else                  
   nRow1 := 0
   nRow2 := VtMaxRow()
	nPadc := VtMaxCol()-1
	lCenter:=.f.
EndIf
cMsg := If(cMsg == NIL,"",cMsg)
cCaption := If(cCaption == NIL,Left(cVersao,8),cCaption)
cCaption := Padc(Padc(cCaption,nPadc),nMaxCol)

aScr := VTSave()
If  lTerminal 
   cMsg:= Strtran(cMsg,chr(13)," ")
   cMsg:= Strtran(cMsg,chr(10),"")   
   cMsg:= '['+Alltrim(cCaption)+'] '+cMsg
   lCenter:= .f.
Else
	Aadd(aMsg,cCaption)
	//Aadd(aMsg,"") // foi o sandro que tirou para ver como vai ficar
EndIf	

nLen := MlCount(cMsg,nPadc+1)
//lCenter := If(nLen == 1,.T.,lCenter)
For i := 1 To nLen
	cLine := MemoLine(cMsg,nPadc+1,i)
	If lCenter
		cLine := AllTrim(cLine)
		cLine := Padc(cLine,nPadc+1)
	EndIf
	cLine := Padc(cLine,nMaxCol+1)
	Aadd(aMsg,cLine)
Next

VTClear()
If nSleep#NIL
   VTKeyboard(chr(13))
EndIf
VTaChoice(nRow1,0,nRow2,VTMaxCol()+1,aMsg,,,,.T.,.T.)
If nSleep#NIL     
	nSec:= Seconds()+(nSleep/1000)
  	If nSec > 86399
     	Sleep(nSleep)
   Else
	   While nSec > Seconds().and.(nKey:=VtInkey(.01))=0
			Sleep(10)
	 	end  
	EndIf
EndIf
If lRestore
	VTRestore(,,,,aScr)
EndIf	
Return VTInkey()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222Cabec   ³Autor  ³Marcos Alve         º Data ³09/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I222Cabec(cCabec,nLin)
Local cString	:=""
Local cLoja		:=Alltrim(Subs(SM0->M0_FILIAL,1,9))
Local aSemana	:={"Dom", "Seg", "Ter","Qua",; //Descricoes do dia da semana
				  "Qui"  , "Sex", "Sab"}
Local cSemana	:=aSemana[Dow(dDataBase)]					//Identifica qual o dia da semana
Local nSpace	:=4+(9-Len(cLoja))

If cCabec=="1"
    /*
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    "[LOJA - DI      ][MT:00]X[Ter - 08/12/09]"
    */
	cString:="["+cLoja+"]"+Space(nSpace)+"[MT:"+cNumTer+"]"+cFlag+"["+cSemana+" - "+dtoc(dDataBase)+"]"
EndIf
Return cString


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222CartVld      ³Autor  ³Marcos Alves   º Data ³09/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I222CartVld(nIfood)
Local aTela
Local cMsg	:=""
Local lRet	:=.T.
If !Empty(cCartao)
	lRet	:=.F.
	VTSave SCREEN TO aTela
	SZX->(dbSetOrder(1))
	If  !SZX->(dbSeek(xFilial("SZX")+cCartao)).OR.(cCartao=="000") //Cartao 000 nao pode ser utilizado no microterminal
		cMsg	:="Cartao "+cCartao+" Invalido !"
	ElseIf !Empty(SZX->ZX_MICROT).And.(SZX->ZX_MICROT <> cNumTer)
		cMsg	:="Cartao "+cCartao+" aberto no MT - " + SZX->ZX_MICROT
	ElseIf SZX->ZX_BLOQ == "1" 	
		cMsg	:="Cartao "+cCartao+" bloqueado !"
	Else
		lRet	:=.T.
		If !Empty(SZX->ZX_TABELA)
			nIFood	:= If(Alltrim(SZX->ZX_TABELA)=="1",2,1)
			Conout("Tabela...do carto:"+Alltrim(SZX->ZX_CARTAO)+":"+Alltrim(SZX->ZX_TABELA))
			lIfood	:= .F.
		ENDIF	
	EndIf
	If !lRet
		VTAlert(cMsg, "Atencao",.T.,2000)
		VTClear()
		VTRestore Screen FROM aTela
		cCartao	:= Space(3)
	EndIf	
EndIf
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IA222AVld     ³Autor  ³Marcos Alves   º Data ³09/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA222Vld()
Local aTela
Local cMsg	:=""
Local lRet	:=.F.
VTSave SCREEN TO aTela
cAtend:=Strzero(Val(cAtend),6)
SA3->(dbSetOrder(1))
If  !SA3->(dbSeek(xFilial("SA3")+cAtend))
	cMsg	:="Atendente nao cadastrado"
Else
	lRet	:=.T.
EndIf

If !lRet
	VTAlert(cMsg, "Atencao",.T.,2000)
	VTClear()
	VTRestore Screen FROM aTela
	cAtend	:= Space(6)
EndIf	
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222VldPrdºAutor  ³Fernando Salvatori  º Data ³  22/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz as validacoes do codigo do produto e seu retorno       º±±
±±º          ³ para continuidade do processamento.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LJTER01                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IA222VldProd(cOpcao)
Local lRet	:=.T.
Local aTela
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa por Codigo do Produto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
VTSave SCREEN TO aTela
If !Empty(cProduto)       
	dbSelectArea( "SBI" )
	dbSetOrder( 1 )
	If !dbSeek( xFilial("SBI")+cProduto )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa por Codigo de Barra  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSetOrder( 5 )
		If !dbSeek( xFilial("SBI")+cProduto )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pesquisa por Codigo de Barra no Cad de Codigo de Barra  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SLK" )
			dbSetOrder( 1 )
			If !dbSeek( xFilial("SLK")+cProduto )
				lRet	:=.F.
				cMsg	:="Produto nao cadastrado"
				cProduto:= Space(6)
			Else
				cProduto := SLK->LK_CODIGO
			EndIf
		Else
			If SBI->BI_MSBLQL="1"
				lRet	:=.F.
				cMsg	:="Produto bloqueado!!"
			Else
				cProduto := SBI->BI_COD
			EndIf
		EndIf
	Else
		cProduto := SBI->BI_COD
	EndIf
EndIf
If !lRet
	VTAlert(cMsg, "Atencao",.T.,2000)
	VTClear()
	VTRestore Screen FROM aTela
	cProduto:= Space(6)
EndIf	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222ExcItensºAutor  ³Marcos Alve         º Data ³27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visialuzar/exclui os itens do array de vendas               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I222ExcItens(aVendas)
Local lRet		:=.T.
Local nItem		:=I222EofTop(aVendas)
Local cOpcao 	:= ""
Local lFirst	:=.T.

While nItem<>0
	cOpcao:=""
   	VTClear()
	VTClearBuffer()
	
	@ 00,00 VTSay "["+Strzero(nItem,3)+ "/"+Alltrim(Subs(aVendas[nItem,CODIGO_PRODUTO],1,6))+ "-"+Alltrim(Subs(aVendas[nItem,DESCRICAO_PRODUTO],1,31))+"]"
	@ 01,00 VTSay "[Quantidade:"+Trans(aVendas[nItem,QUANTIDADE_PRODUTO],If(aVendas[nItem,UNIDADE_MEDIDA_PRODUTO]=="KG","@E 999.999","@E 999999"))+"]   [Preco:"+Trans(aVendas[nItem,PRECO_UNITARIO_PRODUTO],"@E 99,999.99")+"]"
	While lFirst.OR.(!(VTLastKey() == 27).And.!(Alltrim(Upper(cOpcao))$(cAvanca+cRetorna+cDelete)))
		cOpcao := Upper(Chr(VTInkey(0)))
		lFirst:=.F.
	End
	If cOpcao==cAvanca
		nItem:=I222EofTop(aVendas,nItem,"1") //1 - Avancar
	ElseIf cOpcao==cRetorna
		nItem:=I222EofTop(aVendas,nItem,"2") //2 - Retornar
	ElseIf cOpcao==cDelete
		I222ExcReg(@aVendas,@nItem) 		//Excluir item do array
	Else
		Exit
	EndIf
    //nItem:=If(nItem<1.Or.nItem>Len(aVendas),1,nItem)
End

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222EofTop  ºAutor  ³Marcos Alve         º Data ³27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Definir numero do item no array                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function I222EofTop(aVendas,nItem,cTipo)

Default nItem:=0
While .T.
	nItem:=If(cTipo="2",--nItem,++nItem)
	If (nItem>Len(aVendas)).OR.(nItem<1).OR.(!aVendas[nItem,DELETADO])
		Exit
	EndIf
End
If nItem>Len(aVendas)
	If cTipo<>NIL
		VTClear()                                
		VTAlert("Final dos Registros...","Atencao",.T.,1000)
		VTClear()
	EndIf	
	nItem:=0
    For nI:= Len(aVendas) to 1 Step -1
    	If !aVendas[nI,DELETADO]
		    nItem:=nI
   	    	    Exit
            EndIf
        Next nI
EndIf    
If nItem<1
	If cTipo<>NIL
		VTClear()                                
		VTAlert("Inicio dos Registros...","Atencao",.T.,1000)
		VTClear()
	EndIf	
	nItem:=0
    For nI:= 1 to Len(aVendas)
    	If !aVendas[nI,DELETADO]
		    nItem:=nI
   	   	    Exit
        EndIf
    Next nI
EndIf
Return nItem

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222ExcReg  ºAutor  ³Marcos Alve         º Data ³27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclusao de itens do array de vendas                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function I222ExcReg(aVendas,nItem)

If !VTYesNo('Confirma a exclusao','Atencao ',.T.)
       Return .F.
EndIf
nValTot	-= NoRound(aVendas[nItem,PRECO_UNITARIO_PRODUTO]*aVendas[nItem,QUANTIDADE_PRODUTO],2)
aVendas[nItem,DELETADO]:=.T.
nItem	:=I222EofTop(aVendas,nItem)

Return .T.
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222Grv     ºAutor  ³Marcos Alve         º Data ³27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclusao de itens do array de vendas                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function I222Grv(aVendas,nValTot,lLock,nIfood)
Local cAtend	:=""
Local cAuxCart	:=""

Default lLock	:= .F.
Default cHora	:=Time()
Default cNumTer := "CX"+Alltrim(INNO_PDV)  //**
Default aCartao	:={}

dbSelectArea("SZZ")
dbSetOrder(1) //ZZ_FILIAL+ZZ_CARTAO+ZZ_FLAG

For nI:=1 to Len(aVendas)
	cCartao					:=aVendas[nI,NUMERO_CARTAO]
    If Empty(aVendas[nI,REGISTRO])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar somente os novos registros                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SZZ->(RecLock("SZZ", .T.))
		SZZ->ZZ_FILIAL  :=xFilial("SZZ")
		SZZ->ZZ_CARTAO  :=aVendas[nI,NUMERO_CARTAO]
		SZZ->ZZ_ITEM 	:=StrZero(nI,TamSx3("ZZ_ITEM")[1])
		SZZ->ZZ_PRODUTO	:=aVendas[nI,CODIGO_PRODUTO]
		SZZ->ZZ_DESCRI	:=aVendas[nI,DESCRICAO_PRODUTO]
		SZZ->ZZ_UM		:=aVendas[nI,UNIDADE_MEDIDA_PRODUTO]
		SZZ->ZZ_VLRITEM	:=aVendas[nI,PRECO_UNITARIO_PRODUTO]
		SZZ->ZZ_QUANT  	:=aVendas[nI,QUANTIDADE_PRODUTO]
		SZZ->ZZ_VEND  	:=aVendas[nI,CODIGO_ATENDENTE]
		SZZ->ZZ_DATA	:=dDataBase
		SZZ->ZZ_HORA	:=cHora
		SZZ->ZZ_MICROT	:=cNumTer
		SZZ->ZZ_FLAG  	:="0"
		SZZ->ZZ_TABELA 	:=If(nIfood<2,"2","1")
		SZZ->(dbCommitAll())
		SZZ->(MsUnlock())
		cAtend					:=aVendas[nI,CODIGO_ATENDENTE]
		aVendas[nI,REGISTRO]	:=SZZ->(Recno())
	EndIf	
    If aVendas[nI,DELETADO].AND.!Empty(aVendas[nI,REGISTRO])
		SZZ->(dbGoto(aVendas[nI,REGISTRO]))
		SZZ->(RecLock("SZZ", .F.))
		SZZ->(dbDelete())
		SZZ->(MsUnlock())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deletar os registro da base que forma excluido no array³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If aVendas[nI,DELETADO].AND.!Empty(aVendas[nI,REGISTRO])
		SZZ->(dbGoto(aVendas[nI,REGISTRO]))
		SZZ->(RecLock("SZZ", .F.))
		SZZ->(dbDelete())
		SZZ->(MsUnlock())
    ElseIf !aVendas[nI,DELETADO].AND.Empty(aVendas[nI,REGISTRO])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar somente os novos registros                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SZZ->(RecLock("SZZ", .T.))
		SZZ->ZZ_FILIAL  :=xFilial("SZZ")
		SZZ->ZZ_CARTAO  :=aVendas[nI,NUMERO_CARTAO]
		SZZ->ZZ_ITEM 	:=StrZero(nI,TamSx3("ZZ_ITEM")[1])
		SZZ->ZZ_PRODUTO	:=aVendas[nI,CODIGO_PRODUTO]
		SZZ->ZZ_DESCRI	:=aVendas[nI,DESCRICAO_PRODUTO]
		SZZ->ZZ_UM		:=aVendas[nI,UNIDADE_MEDIDA_PRODUTO]
		SZZ->ZZ_VLRITEM	:=aVendas[nI,PRECO_UNITARIO_PRODUTO]
		SZZ->ZZ_QUANT  	:=aVendas[nI,QUANTIDADE_PRODUTO]
		SZZ->ZZ_VEND  	:=aVendas[nI,CODIGO_ATENDENTE]
		SZZ->ZZ_DATA	:=dDataBase
		SZZ->ZZ_HORA	:=cHora
		SZZ->ZZ_MICROT	:=cNumTer
		SZZ->ZZ_FLAG  	:="0"
		SZX->ZX_TABELA 	:=If(nIfood<2,"2","1")
		SZZ->(dbCommitAll())
		SZZ->(MsUnlock())
		cAtend					:=aVendas[nI,CODIGO_ATENDENTE]
		aVendas[nI,REGISTRO]	:=SZZ->(Recno())
	EndIf	
	
	If cAuxCart<>cCartao
		aadd(aCartao,cCartao)
		cAuxCart:=cCartao
	EndIf	
Next nI
// Renumerar os Itens para o caso tenha item deletedo
dbSelectArea("SZZ")
dbSetOrder(1) //ZZ_FILIAL+ZZ_CARTAO
SZZ->(dbSeek(xFilial("SZZ")+cCartao+"0")) //ZZ_FILIAL+ZZ_CARTAO
nItemX:=0
While SZZ->ZZ_FILIAL+SZZ->ZZ_CARTAO==xFilial("SZZ")+cCartao.AND.SZZ->ZZ_FLAG=="0"
	If !SZZ->(Deleted()) 		 	
		nItemX++
		SZZ->(RecLock("SZZ", .F.))
		SZZ->ZZ_ITEM:=StrZero(nItemX,TamSx3("ZZ_ITEM")[1])
		SZZ->(MsUnLock())  
	EndIf	
	SZZ->(dbSkip())
End	

//Eliminando as linhas do array com elementos deletados
nDel:=0
While (nPos:=Ascan(aVendas,{|X| ValType(X)=="A".And.x[DELETADO]==.T.}))>0
	aDel(aVendas,nPos)
	nDel++
	Loop
End
aSize(aVendas,Len(aVendas)-nDel) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desbloquear os uso do cartoes                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_I222TDCarttao({cCartao},"",nValTot,nIfood)

Return aVendas

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³I222TDCarttao  ºAutor  ³Marcos Alve      º Data ³04/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Desbloquear e Bloqueia o Cartao                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function I222TDCarttao(aCartao,cMicroT,nValTot,nIfood)
Local nI	

Default aCartao:={}
Default cMicroT:=""
Default nIfood:=1

For nI:=1 to Len(aCartao)
	If SZX->(dbSeek(xFilial("SZX")+aCartao[nI]))
		SZX->(RecLock("SZX",.F.))
		SZX->ZX_MICROT 	:= cMicroT
		SZX->ZX_VLRLIQ	:= If(nValTot=NIL,SZX->ZX_VLRLIQ,nValTot)
		SZX->ZX_DATA	:= dDataBase
		SZX->ZX_HORA	:= cHora
		SZX->ZX_TABELA 	:=If(nIfood<2,"2","1")
		SZX->(MsUnLock())  
	EndIf
Next nI
aCartao:={}

Return Nil	

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³IA222Atend ³ Autor ³ Marcos Alves         Data ³ 06/05/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Definir tabela de preço para Ifood             									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Doceira Innocencio   								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data   ³ Bops ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³        ³      ³                                 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA222Ifood(nIfood)
Local cString	:=I222Cabec("1")

While .T.
   	VTClear()
	VTClearBuffer()
	//nIFood	:=2
    /*
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    "[LOJA - DI      ][MT:00]X[Ter - 08/12/09]"
    "[Atendente:00000]            [Cartao:000]"
    */
	@ 00,00 VTSay cString
	@ 01,00 VTSay "[Ifood? (1=Sim/2=Nao): ]"
	@ 01,22 VTGet nIFood Pict "99" //When lIfood
	VTRead
	// Se o tecla pressionada for <ESC>
	ConOut(nIfood)
	If VTLastKey() == 27
		Return .F.
	EndIF               
	
	If niFood<>1 .And. nIFood<>2 
		Loop
	EndIf	
    Exit
End

Return .T.
