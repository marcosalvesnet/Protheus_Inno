#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#include "apvt100.ch"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//�  Array a Vendas                                        �
//�		cCartao,		1                                  �
//�		SA3->A3_COD,   	2                                  �
//�		SBI->BI_COD,    3                                  �
//�		SBI->BI_DESC,   4                                  �
//�		nQuant,         5                                  �
//�		SBI->BI_UM,  	6                                  �
//�		SBI->BI_PRV,    7                                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴커굇
굇쿑un뇙o    � Inno222  쿌utor  � Marcos Alves          � Data � 08/12/09  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴캑굇
굇쿏escri뇙o � Programa que efetua um orcamento no Micro-Terminal          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿢so       � Innocencio                                                  낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      낢�
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    낢�
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿐xecucao do rotina do Microterminal                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
U_IA222Data(cEmpInno,cFilInno)
     
VtDisconnect()
__SetX31Mode(.F.)
RpcClearEnv()

Return NIL

/*
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un놹o	 쿔A222Data  � Autor � Marcos Alves          � Data � 08/12/09 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o 쿔dentificacao da aplicacao e Data Base          			  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � Doceira Innocencio   								  	  낢�
굇쳐컴컴컴컴컵컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌nalista  � Data   � Bops 쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �        �      �                                 			  낢�
굇읕컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
User Function IA222Data(cEmpInno,cFilInno)
Public dDataBase	:= MsDate()
VTSetSize(2,40)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏ata Base                                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
While .T.
   	VTClear()
	VTClearBuffer()
	dDataBase	:= MsDate()
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//�"[Doceira Innocencio] [MT:001][Ver.  2.0]"              �
	//�"[Data Base:         ]    [Emp/Fil:99/01]"              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    //VTKeyboard(CHR(49))
    //VTKeyboard(CHR(50))
    //_Keyboard(CHR(13))
    
	@ 00,00 VTSay "[Doceira Innocencio] [MT:"+cNumTer+"][Ver.  "+cVerMT+"]"
	@ 01,00 VTSay "[Data Base:         ]    [Emp/Fil:"+cEmpInno+"/"+cFilInno+"]"
	@ 01,12 VTGet dDataBase Pict "99/99/99" Valid MTValidData(dDataBase)
	VTRead
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//�"[1]Vendas		[2]Recebimento 		[3]Inventario      �
	//�"Selecione a funcao:[1]                                 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	// Se o tecla pressionada for <ESC>
	If VTLastKey() == 27
		Loop
	EndIF
    Exit
End
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿗oop de Venda                                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
IA222Venda()

Return

/*
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un놹o	 쿔A222Venda � Autor � Marcos Alves          � Data � 08/12/09 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o 쿗oop nas rotinas de Vendas                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � Doceira Innocencio   								  	  낢�
굇쳐컴컴컴컴컵컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌nalista  � Data   � Bops 쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �        �      �                                 			  낢�
굇읕컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿙umero do Cartao                                        �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !IA222Cartao(@aVendas,@nIfood)
		Exit
	EndIf	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿌tendente                                               �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !IA222Atend(nIfood)	
		Loop
	EndIf	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿶Food    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !IA222Ifood(@nIfood)
		Loop
	EndIf	

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿛roduto e quantidade                                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	I222Produto(@aVendas,nIfood)	
End
                      
dbCloseAll()
VTAlert("Microterminal finalizado...desligue!!!", "Atencao",.T.)
Return Nil

/*
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un놹o	 쿔A222Cartao� Autor � Marcos Alves          � Data � 08/12/09 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o 쿔dentificacao do Cartao									  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � Doceira Innocencio   								  	  낢�
굇쳐컴컴컴컴컵컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌nalista  � Data   � Bops 쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �        �      �                                 			  낢�
굇읕컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function IA222Cartao(aVendas,nIfood)
Local cString	:=I222Cabec("1")
Local lRet		:=.T.
dbSelectArea("SZX")
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿙umero do Carao                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿍loquear o uso do cartao                                �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	cHora	:=Time()
	U_I222TDCarttao({cCartao},cNumter,nValTot,nIfood)
    Exit
End
Return lRet

/*
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un놹o	 쿔A222Atend � Autor � Marcos Alves          � Data � 08/12/09 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o 쿌tendente             									  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � Doceira Innocencio   								  	  낢�
굇쳐컴컴컴컴컵컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌nalista  � Data   � Bops 쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �        �      �                                 			  낢�
굇읕컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function IA222Atend(nIFood)
Local cString	:=I222Cabec("1")

dbSelectArea("SA3")	//Cadastro de vendedor
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿙umero do Carao                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴쩡컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿑un놹o	쿔222Produt� Autor � Marcos Alves          � Data � 08/12/09 낢�
굇쳐컴컴컴컴탠컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri놹o쿣endas dos produtos    									 낢�
굇쳐컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� Uso		� Doceira Innocencio   								  	     낢�
굇쳐컴컴컴컴탠컴컴컴컫컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿌nalista � Data   � Bops 쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴탠컴컴컴컵컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇�         �        �      �                                            낢�
굇읕컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function I222Produto(aVendas,nIfood)
Local cString	:="["+SA3->A3_COD+" - "+Alltrim(Subs(SA3->A3_NOME,1,18))+"]"
Local nSpace	:=(28-Len(cString))
Local cOpcao	:=""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Gravar o atendente                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
SZX->(RecLock("SZX",.F.))
SZX->ZX_VEND	:=cAtend
SZX->(MsUnLock())  

dbSelectArea("SBI")
dbSetOrder(1)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//�                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
While .T.
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	//쿌tualizar valor do cartao para ser visualizado em I223LstVnd       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿘TValidData 튍utor  쿘arcos Alve         � Data �08/12/09   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     쿣alidar se a data foi digitada                              볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function MTValidData(dData)
Local lRet := .T.
If Empty(dData)
   	lRet	:= .F.
    VTAlert("Data Invalida", "Atencao",.T.,2000)
EndIf
Return lRet

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿣TInnoAlert 튍utor  쿘arcos Alve         � Data �08/12/09   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     쿐xibir Msg no Microterminal                                 볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴錮袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔222Cabec   쿌utor  쿘arcos Alve         � Data �09/12/09   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴鳩袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴袴袴袴佶袴袴袴佶袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔222CartVld      쿌utor  쿘arcos Alves   � Data �09/12/09   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴賈袴袴袴賈袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴袴袴袴佶袴袴袴佶袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔A222AVld     쿌utor  쿘arcos Alves   � Data �09/12/09   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴賈袴袴袴賈袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     �                                                            볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿔222VldPrd튍utor  쿑ernando Salvatori  � Data �  22/08/02   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Faz as validacoes do codigo do produto e seu retorno       볍�
굇�          � para continuidade do processamento.                        볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � LJTER01                                                    볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

Static Function IA222VldProd(cOpcao)
Local lRet	:=.T.
Local aTela
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿛esquisa por Codigo do Produto�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
VTSave SCREEN TO aTela
If !Empty(cProduto)       
	dbSelectArea( "SBI" )
	dbSetOrder( 1 )
	If !dbSeek( xFilial("SBI")+cProduto )
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//쿛esquisa por Codigo de Barra  �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		dbSetOrder( 5 )
		If !dbSeek( xFilial("SBI")+cProduto )
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//쿛esquisa por Codigo de Barra no Cad de Codigo de Barra  �
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔222ExcItens튍utor  쿘arcos Alve         � Data �27/01/10   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     쿣isialuzar/exclui os itens do array de vendas               볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔222EofTop  튍utor  쿘arcos Alve         � Data �27/01/10   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     쿏efinir numero do item no array                             볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔222ExcReg  튍utor  쿘arcos Alve         � Data �27/01/10   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     쿐xclusao de itens do array de vendas                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔222Grv     튍utor  쿘arcos Alve         � Data �27/01/10   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     쿐xclusao de itens do array de vendas                        볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Gravar somente os novos registros                      �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Deletar os registro da base que forma excluido no array�
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    If aVendas[nI,DELETADO].AND.!Empty(aVendas[nI,REGISTRO])
		SZZ->(dbGoto(aVendas[nI,REGISTRO]))
		SZZ->(RecLock("SZZ", .F.))
		SZZ->(dbDelete())
		SZZ->(MsUnlock())
    ElseIf !aVendas[nI,DELETADO].AND.Empty(aVendas[nI,REGISTRO])
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Gravar somente os novos registros                      �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿏esbloquear os uso do cartoes                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
U_I222TDCarttao({cCartao},"",nValTot,nIfood)

Return aVendas

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴袴袴袴箇袴袴袴佶袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴敲굇
굇튡rograma  쿔222TDCarttao  튍utor  쿘arcos Alve      � Data �04/11/10   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴菰袴袴袴賈袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴묽�
굇튒esc.     쿏esbloquear e Bloqueia o Cartao                             볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un놹o	 쿔A222Atend � Autor � Marcos Alves         Data � 06/05/2020 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri놹o 쿏efinir tabela de pre�o para Ifood             									  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso		 � Doceira Innocencio   								  	  낢�
굇쳐컴컴컴컴컵컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌nalista  � Data   � Bops 쿘anutencao Efetuada                         낢�
굇쳐컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�          �        �      �                                 			  낢�
굇읕컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
