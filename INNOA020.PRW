#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "ERROR.CH"
#INCLUDE "INNO_020.CH"
#DEFINE NTRIM(n)		( LTrim(Str(n)) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ INNO_020 ³ Autor ³ Marcos Alves          ³ Data ³27/03/15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Thread "OnStart" de Conexao RPC com o Server               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ INNO_020                                                   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static oServer
Static lEndThread
Static aCargaOK

User Function INNO_020(cLocalEmp, cLocalFil, _cEstacao, _cVendas, _cConexoes)
Local nHdl
Local lWait			:= .F.
Local nTries		:= 0
Local nI			:= 0                                 
Local nVendas		:= 0	// Quantidade de vendas antes do reset do RPC, vindo do mp8srv.ini (Param4)
Local nConexoes		:= 0	// Quantidade de conexoes antes do reset do RPC, vindo do mp8srv.ini (Param5)
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Deve possuir o nome do fonte + Ambiente do Server + ³
//³ID da Thread pois e' um por server, independente do ³
//³Environment que o acesse.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cResetRPC 	:= Upper( "U_INNO_020" + GetEnvServer() + "_" + StrZero(ThreadID(),10) )		// Nome da variavel global

Default _cVendas	:= 0	// Quantidade de vendas antes do reset do RPC, vindo do mp8srv.ini (Param4)
Default _cConexoes	:= 0	// Quantidade de conexoes antes do reset do RPC, vindo do mp8srv.ini (Param5)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se os novos parametros do mp8srv.ini estao preenchidas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType( _cVendas ) == "C" .AND. !Empty( Trim( _cVendas ) )
	nVendas	:= Val( _cVendas )
EndIf

If ValType( _cConexoes ) == "C" .AND. !Empty( Trim( _cConexoes ) )	
	nConexoes := Val( _cConexoes )
Endif	


nHdl := MSFCreate("FRT020.LCK")
IF nHdl < 0                           
	ConOut("******************************************")
	ConOut("File system with problems, file FRT020.LCK")   
	ConOut("******************************************")
	UserException("Impossible create on FRT020.LCK")
Endif
FClose(nHdl)
                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Apaga semaforos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FErase("STOPFRT.LCK")
FErase("FRT020.LCK")
FErase("FRTCS.LCK")

While !KillApp() .And. !File('STOPFRT.LCK')
	If lWait
		// "Front Loja: Aguardando 180 segundos para reestabelecer a conexao..."
		ConOut(STR0035+Chr(13)+Chr(10))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Espera aproximadamente 180 Segundos, contudo avaliando se foi solicitado ³
		//³a paralisação dos servicos (Jobs).                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
		While !KillApp() .and. !File('STOPFRT.LCK') .And. nTries <= ( 180+Randomize(0,60) ) .AND. ( GetGlbValue( cResetRPC ) <> "S" ) 
			Sleep(1000)
			SysRefresh()
			nTries ++
		End
		If KillApp()
			Exit
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³"Zera" a global antes de executar o job novamente.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PutGlbValue(cResetRPC,"N")
	ConOut(STR0036)	//"Front Loja: Subindo Thread de sincronizacao"
	StartJob("U_MyIFrt020",GetEnvServer(),.f.,cLocalEmp,cLocalFil,_cEstacao, nVendas, nConexoes, cResetRPC )
	//U_MyIFrt020("01", "01", "001")

	// Esperar 30 segundos
	// Se der CTRL+BREAK, sai imediatamente
	For nI := 1 to 30 
		If KillApp()
			Exit
		EndIf
		Sleep(1000)
	Next nI
	
	nHdl := MSFCreate("FRT020.LCK")
	
	While !KillApp() .and. nHdl < 0  .And. !File('STOPFRT.LCK')
		// Esperar 60 segundos
		// Se der CTRL+BREAK, sai imediatamente  
		For nI := 1 to 60
			If KillApp()
				Exit
			EndIf
			Sleep(1000)
		Next nI
		
	   nHdl := MSFCreate("FRT020.LCK")
	End 
	                               
	IF nHdl >= 0
	   FClose(nHdl)
	Endif
	lWait := .T.
End 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sinalize que todos os servicos (Jobs) foram baixados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MSFCreate("FRTCS.LCK")  
PutGlbValue( cResetRPC, "" )
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ MyFrt020 ³ Autor ³ Microsiga             ³ Data ³08/05/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Job da subida das vendas                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FuncTion MyIFrt020(cLocalEmp, cLocalFil, _cEstacao, nVendas, nConexoes, cResetRPC)
Local bErro := {|x| FRTA020MyErro(x)}
Local nHdl  := MSFCreate("FRT020.LCK")                                
Local nX
Default nVendas		:= 0	// Quantidade de vendas antes do reset do RPC, vindo do mp8srv.ini (Param4)
Default nConexoes	:= 0	// Quantidade de conexoes antes do reset do RPC, vindo do mp8srv.ini (Param5)

If nHdl < 0
   ConOut("*******************************************")
   ConOut(STR0037)	//"Foi impossivel locar  o semaforo FRT020.LCK"
   ConOut(STR0038)	//"O PDV Esta sem sincronizacao "
   ConOut("*******************************************")
   UserException("Impossible lock in FRT020.LCK")
Endif

lEndThread := .F.

RpcMyErro()
ErrorBlock(bErro)

MakeDir("\SEMAFORO")

While !KillApp() .And. !lEndThread .And. !File('ISTOPFRT.LCK')
	BEGIN SEQUENCE
		nHdl := MSFCREATE("\SEMAFORO\F"+cLocalEmp+cLocalFil+_cEstacao+".LCK")
	   	IF nHdl >= 0                                    
	      	FClose(nHdl)                  
			MyIFRTA020( cLocalEmp,cLocalFil,_cEstacao,nVendas,nConexoes,cResetRPC )
		EndIf
		
	END SEQUENCE
	oServer := NIL

    For nX := 1 to 5
       If KillApp()
	      Exit
	   EndIf
	   Sleep(1000)
    Next nX
End       

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³FRTA020MyE³ Autor ³ Microsiga             ³ Data ³08/05/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Bloco de tratamento do erro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRTA020MyErro(oErro)
Local cBuffer	:= ""

If KillApp() .Or. lEndThread
	Return
Endif

cBuffer := MemoRead("INNO_020.LOG")
MemoWrite("INNO_020.LOG", DToC(dDataBase)+"  "+Time()+Chr(10)+;
	U_IErrorMessage(oErro)+Chr(10)+Repl("*",40)+Chr(10)+Chr(10)+cBuffer)
If oErro:GenCode == EG_JOB
	If !("RpcSetEnv" $ U_IErrorMessage(oErro))
		ConOut(Chr(13)+Chr(10)+U_IErrorMessage(oErro)+Chr(13)+Chr(10))
	EndIf
	RESET ENVIRONMENT
Else
	ConOut(U_IErrorMessage(oErro))
	If ( oErro:GenCode == EG_ZERODIV )
		return (0)
	ElseIf (oErro:GenCode == EG_NOALIAS)
		If !xChkfile(e:Operation)
			ConOut("Alias Does Not Exist "+e:Operation)
		EndIf                                                                            
		Return
	EndIf
EndIf

__QUIT()             

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ErrorMessa³ Autor ³ Microsiga             ³ Data ³08/05/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Montagem da Mensagem de Erro                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IErrorMessage(e)

// start error message
Local cMessage := If( Empty( e:osCode ), If( e:severity > ES_WARNING, "Error ", "Warning " ),; 
						"(DOS Error " + NTRIM(e:osCode) + ") " )

// add subsystem name if available
cMessage += If( ValType( e:subsystem ) == "C", e:subsystem, "???" )

// add subsystem's error code if available
cMessage += If( ValType( e:subCode ) == "N", "/" + NTRIM( e:subCode ), "/???" )

// add error description if available
If ( ValType(e:description) == "C" )
	cMessage += "  " + e:description
Endif

// add either filename or operation
cMessage += If( !Empty( e:filename ), ": " + e:filename, If( !Empty( e:operation ), ": " + e:operation, "" ) )
Return( cMessage )
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ MyFRTA020³ Autor ³ Cesar Eduardo Valadao ³ Data ³16/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Thread "OnStart" de Conexao RPC com o Server               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MyIFRTA020(cLocalEmp, cLocalFil, _cEstacao, nVendas, nConexoes, cResetRPC)
Local cRPCServer	:= ""
Local nRPCPort		:= 0
Local cRPCEnv		:= ""
Local cRPCEmp		:= ""
Local cRPCFilial	:= ""
Local nRPCInterv	:= 0
Local aAux			:= {}
Local aRet			:= {}
Local lRet			
Local nRet
Local cRet			:= ""
Local nTempo := 0                                                             
Local nHdl  
Local i
Local lReset		:= .F.	// Valida se farah o reset do RPC

Default nVendas		:= 0	// Quantidade de vendas antes do reset do RPC, vindo do mp8srv.ini (Param4)
Default nConexoes	:= 0	// Quantidade de conexoes antes do reset do RPC, vindo do mp8srv.ini (Param5)

If nVendas > 0 .AND. nConexoes > 0                          
	lReset := .T.
Endif


Private cEstacao	:=""
Private aFiles		:= {}

nHdl := MSFCREATE("\SEMAFORO\F"+cLocalEmp+cLocalFil+_cEstacao+".LCK")

IF nHdl < 0                       
	Return( .F. )
EndIf

aCargaOK := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exemplo do AP6SRV.INI        ³
//³                              ³
//³ [OnStart]                    ³
//³ Jobs=APFrontLoja             ³
//³                              ³
//³ [APFrontLoja]                ³
//³ Main=INNO_020                 ³
//³ Environment=<cAmbiente>      ³
//³ nParms=<nNumerodeParametros> ³
//³ Parm1=<cEmpresa>             ³
//³ Parm2=<cFilial>              ³
//³ Parm3=<cEstacao>             ³
//³ Parm4=<cVendas>              ³
//³ Parm5=<cConexoes>            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ValType(cLocalEmp) == "U" .Or. ValType(cLocalFil) == "U" .Or. ValType(_cEstacao) == "U"
	lEndThread := .T.
EndIf   

If !lEndThread .And. (Empty(Left(cLocalEmp,2)) .Or. Empty(Left(cLocalFil,2)) .Or. Empty(Left(_cEstacao,3)))
	lEndThread := .T.
EndIf

If lEndThread
	// "Front Loja: Erro na inicializacao do Ambiente Local "
	// "            Verifique a secao [OnStart] do AP6SRV.INI."
	ConOut(STR0001+GetEnvServer()+".")
	ConOut(STR0002)
	FClose(nHdl)
	Return(NIL)
EndIf

cLocalEmp := Left(cLocalEmp,2)
cLocalFil := Left(cLocalFil,2)
cEstacao  := Left(_cEstacao,3)

// "Front Loja: Thread (INNO_020) iniciada...")
// "            Empresa - " ### "  Filial - " ### "  Estacao - " ###
ConOut(STR0003)
ConOut(STR0004 + cLocalEmp + STR0005 + cLocalFil + STR0006 + cEstacao)

RPCSetType(3)  // Nao comer licenca
PREPARE ENVIRONMENT EMPRESA cLocalEmp FILIAL cLocalFil TABLES "SLI", "SL1", "SLG", "SFI" MODULO "FRT"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Arquivos a Gerar Carga ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFiles := FRTArquivos()
RPCOpenTables({"SLI", "SL1", "SL2", "SL4", "SE5", "SA1"})
RPCOpenTables(aFiles)

dbSelectArea("SLG")
If dbSeek(xFilial()+cEstacao)
	aAux		:= LjGetStation({"RPCSRV", "RPCPORT", "RPCENV", "RPCEMP", "RPCFIL", "RPCINT"})
	cRPCServer	:= aAux[1]
	nRPCPort	:= Val(aAux[2])
	cRPCEnv		:= aAux[3]
	cRPCEmp		:= aAux[4]
	cRPCFilial	:= aAux[5]
	nRPCInterv	:= If(aAux[6]==0, 5000, aAux[6]*1000)
	If Empty(cRPCServer) .Or. Empty(nRPCPort) .Or. Empty(cRPCEnv) .Or. Empty(cRPCEmp) .Or. Empty(cRPCFilial)
		// "Front Loja: Erro na configuracao dos parametros de comunicacao RPC."
		// "            Verifique os parametros na configuracao da Estacao " ###
		ConOut(STR0007)
		ConOut(STR0008+cEstacao+".")
		lEndThread := .T.
	EndIf
Else
	// "Front Loja: Erro na localizacao da Estacao."
	// "            Verifique na configuracao da Estacao se existe a Estacao "
	ConOut(STR0009)
	ConOut(STR0010+cEstacao+".")
	lEndThread := .T.
EndIf

If !lEndThread
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a Ultima Atualizacao da Carga. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FRTGeraSLI("    ", "CRG", "", "ABANDONA")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Arquivo Com Carga Esta Zerado.           ³
	//³ Caso Tenha Ocorrido Algum Problema Com o Arquivo Basta ³
	//³ Exclui-lo Que o Mesmo Identifica e Corrige o Problema. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FRTChkBase()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Elimina Travamento Durante Queda de Rede na Carga. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FRTGeraSLI("    ", "LCK", "", "SOBREPOE")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Elimina a Finalizacao do TwoTier na Inicializacao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FRTGeraSLI("    ", "END", "", "SOBREPOE")

If !lEndThread
	While !KillApp() .And. !lEndThread .And. !File('STOPFRT.LCK')
		If ValType(oServer) != "O"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tenta Criar Conexao RPC ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// "Front Loja: Estabelecendo conexao RPC com o Servidor ("
			ConOut(STR0011+cRPCServer+")...")
			Conout(STR0069+cRPCEnv+STR0070+cRPCEmp+STR0071+cRPCFilial)	// "            Ambiente: " ### " Empresa: " ### " Filial: "
			CREATE RPCCONN oServer ON SERVER cRPCServer ;
				PORT nRPCPort ;
				ENVIRONMENT cRPCEnv ;
				EMPRESA cRPCEmp ;
				FILIAL cRPCFilial ;
				TABLES "SLI", "SL1", "SL2", "SL4", "SE5", "SFI" ;
				MODULO "FRT"
				//MODULO "LOJA"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ A Clausula MODULO, e Para Indicar Que o RPC do Front eh ³
				//³ Equivalente a Uma Licenca do SIGALOJA.                  ³
				//³ Deu Erro na Compilacao? Fale Com o Ramalho!!!           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ValType(oServer) == "O"
				// "Front Loja: Conexao estabelecida com o Servidor ("
				ConOut(STR0014+cRPCServer+").")
				oServer:CallProc("RPCOpenTables", aFiles)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Informar ao Servidor Que a Estacao Esta Conectada, Criando um Semaforo. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRet := oServer:CallProc("FRTSemaforo", "CON", cEstacao)
				If ValType(lRet) == "L"
					While !KillApp() .And. !lEndThread .And. (ValType(lRet)=="L") .And. !lRet
						// "Front Loja: Verifique se nao existe uma outra estacao "
						// "            conectada ou aguarde a reconexao..."
						ConOut(STR0034+AllTrim(cEstacao))
						ConOut(STR0047)
						Sleep(15000)
						// Nao Foi Possivel Travar o Registro. Tentar Novamente Depois de 15 Segundos...
						lRet := oServer:CallProc("FRTSemaforo", "CON", cEstacao)
					End
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ O FRTA020 Cria Um Semaforo Local Sinalizando que Esta Conectado a Retaguarda. ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !FRTSemaforo("CON", cEstacao)
						// "Front Loja: Ja existe um Job FRTA020 sendo executado nesta estacao..."
						ConOut(STR0048)
					EndIf
				EndIf
			Else
				// "Front Loja: Nao foi possivel estabelecer conexao com o Servidor ("
				ConOut(STR0015+cRPCServer+")." )
				// "            Aguardando 60 segundos para tentar estabelecer uma nova conexao..."
				ConOut(STR0072)

				// Esperar 60 segundos
				// Se der CTRL+BREAK, sai imediatamente
				nTempo := ( 60+Randomize(0,120) )
				For i := 1 to nTempo
					If KillApp()
						Exit
					EndIf
					Sleep(1000)
				Next

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Nao Travar no Encerramento do Job ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SLI")
				dbSeek(xFilial())
				If KillApp() .Or. (!EOF() .And. Empty(LI_ESTACAO) .And. Empty(LI_TIPO) .And. Upper(Left(LI_MSG,9)) = "ENDTHREAD")
					FRTGeraSL("SLI", {{"LI_MSG", ""}})
					lEndThread := .T.
				EndIf
			EndIf
		Else
			dbSelectArea("SLI")
			dbSeek(xFilial())
			While LI_FILIAL == xFilial() .And. !EOF() .And. !KillApp()
				If Empty(LI_ESTACAO) .And. Empty(LI_TIPO) .And. Upper(Left(LI_MSG,9)) = "ENDTHREAD"
					FRTGeraSL("SLI", {{"LI_MSG", ""}})
					lEndThread := .T.
					Exit
				ElseIf  Empty(LI_ESTACAO) .And. LI_TIPO == "LCK" .And. Left(LI_MSG,3) == "END"
					If FRTLockOK()											// Lock
						If Len(aCargaOK) > 0
							// Atualiza o Status de Recebendo Carga no FRTMonitor
							oServer:CallProc("FRTGeraSLI", cEstacao, "CRG", "RECEBENDO", "SOBREPOE")
							FRTBaixa()
							oServer:CallProc("FRTGeraSLI", cEstacao, "CRG", "", "SOBREPOE")
							FRTGeraSLI("    ", "LCK", "", "SOBREPOE")
						EndIf
					EndIf
					nVendas--     
				ElseIf  Empty(LI_ESTACAO) .And. LI_TIPO == "CAN" .And. !Empty(LI_MSG)
					oServer:CallProc("RPCOpenTables", {"SE1", "SE5", "SEF", "SE3", "SD2", "SF2", "SB2", "SF4", "SF1", "SD1"})
					nRet := oServer:CallProc("FRTExclusa", Subst(LI_MSG,1,TamSX3("L1_NUMORIG")[1]))
					If ValType(nRet)=="N" .And. (nRet == 0 .Or. nRet == 2)	// Se Cancelou ou Nao Existe...
						FRTGeraSL("SLI", {{"LI_MSG", ""}})
					Endif
					nVendas--
				ElseIf  Empty(LI_ESTACAO) .And. LI_TIPO == "050" .And. !Empty(Left(LI_MSG,17))
					dbSelectArea("SE5")
					dbGoto(Val(Left(SLI->LI_MSG,17)))
					If E5_SITUA == "00"                 
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Monta o SE5 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
						aSE5 := Array(FCount())
						For i := 1 To FCount()
							aSE5[i] := {FieldName(i), FieldGet(i)}
						Next
						aRet := oServer:CallProc("GeraE5", aSE5)
						If ValType(aRet)=="A"
							cOK  := aRet[1]
							If Left(cOK,2)=="OK"
								lRet := oServer:CallProc("ConfE5", aRet[2])
								If ValType(lRet)=="L"
									aSE5 := {{"E5_SITUA","OK"}}						// "TX" - Foi Processado no Server
									FRTGeraSL("SE5", aSE5, .F.)
									FRTGeraSL("SLI", {{"LI_MSG", ""}})
								EndIf
							EndIf
						EndIf
					EndIf
					nVendas--
				ElseIf !Empty(LI_ESTACAO) .And. LI_TIPO == "OPE"
					If FRTSemaStat("OPE", cEstacao)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Informar ao Servidor Que o Caixa Esta Aberto. ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						oServer:CallProc("FRTGeraSLI", cEstacao, "OPE", LI_MSG, "SOBREPOE", .T., LI_USUARIO, LI_DATA, LI_HORA)
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Informar ao Servidor Que o Caixa Esta Fechado. ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						oServer:CallProc("FRTGeraSLI", cEstacao, "OPE", LI_MSG, "SOBREPOE", .T., LI_USUARIO, CToD(""), "")
					EndIf
				ElseIf !Empty(LI_ESTACAO) .And. LI_TIPO == "CON"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informar ao Servidor o Status desta Estacao. ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oServer:CallProc("FRTGeraSLI", cEstacao, "CON", LI_MSG, "SOBREPOE")   
				ElseIf !Empty(LI_ESTACAO) .And. LI_TIPO == "COM" .And. Left(SLI->LI_MSG,4)=="SEND"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualizacao total no Check-Out ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					// Atualiza o Status de Recebendo Carga no FRTMonitor
					oServer:CallProc("FRTGeraSLI", cEstacao, "CRG", "RECEBENDO", "SOBREPOE")
                    // "Front Loja: Iniciando processo de atualizacao das tabelas no Check-Out..."
					ConOut(STR0042)
					FRTAtuCRG()
					// "Front Loja: Processo de atualizacao das tabelas no Check-Out finalizado."
					ConOut(STR0043)
					oServer:CallProc("FRTGeraSLI", cEstacao, "CRG", "", "SOBREPOE")
					nVendas--
				ElseIf !Empty(LI_ESTACAO) .And. LI_TIPO == "PSS" .And. Left(SLI->LI_MSG,8)=="CARREGAR"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualizar o SIGAPSS.SPF ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					FRTGrvSPF()
					nVendas--
				ElseIf  Empty(LI_ESTACAO) .And. LI_TIPO == "SA1" .And. !Empty(Left(LI_MSG,17))
					dbSelectArea("SA1")
					dbGoto(Val(Left(SLI->LI_MSG,17)))
					If A1_SITUA == "00"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Monta o SA1 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
						aSA1 := Array(FCount())
						For i := 1 To FCount()
							aSA1[i] := {FieldName(i), FieldGet(i)}
						Next
						aRet := oServer:CallProc("GeraA1", aSA1)
						If ValType(aRet)=="A"
							cOK  := aRet[1]
							If Left(cOK,2)=="OK"
								lRet := oServer:CallProc("ConfA1", aRet[2])
								If ValType(lRet)=="L"
									cCod  := aSA1[AScan(aSA1,{|x|x[1]=="A1_COD"})][2]
									cLoja := aSA1[AScan(aSA1,{|x|x[1]=="A1_LOJA"})][2]
									// Se o Codigo gravado na Retaguarda foi diferente da base local, faz a correcao.
									If aRet[3] <> cCod
										SL1->(dbSetOrder(6))
										While SL1->(dbSeek(xFilial("SL1")+cCod+cLoja))
											FRTGeraSL("SL1", {{"L1_CLIENTE", aRet[3]}}, .F.)
										End
									EndIf
									aSA1 := {{"A1_SITUA","OK"}}						// "TX" - Foi Processado no Server
									FRTGeraSL("SA1", aSA1, .F.)
									FRTGeraSL("SLI", {{"LI_MSG", ""}})
								EndIf
							EndIf
						EndIf
					EndIf
					nVendas--										
				EndIf
				dbSelectArea("SLI")
				dbSkip()
                
				If lReset
					If nVendas <= 0
					    PutGlbValue(cResetRPC,"S")
						Exit
					EndIf
				Endif	
			End
            
			If lReset
				If nVendas <= 0 .OR. KillApp() .OR. lEndThread                           
					PutGlbValue(cResetRPC,"S")
					Exit
				EndIf
			Endif
			
			FRTRecebe()
			FRTEnviar(@nVendas)
			U_IFRTGravaFI()
			//FRTGravaSZ()
			U_FRTGrvSZ(oServer)

        	If lReset
				If nVendas <= 0 .OR. KillApp() .OR. lEndThread                           
					PutGlbValue(cResetRPC,"S")
					Exit
				EndIf
			Endif	
			
			nConexoes--
			
			If lReset
				If nConexoes <= 0 .OR. KillApp() .OR. lEndThread                           
					PutGlbValue(cResetRPC,"S")
				   Exit
				EndIf					
			Endif	
		EndIf
		Sleep(nRPCInterv)
	End
EndIf
// Informando ao Remote que o Job Ja Terminou.
FRTGeraSLI(Space(4), Space(3), "OK", "SOBREPOE")
If ValType(oServer) == "O"
	// "Front Loja: Finalizando conexao com o Servidor ("
	ConOut(STR0017+cRPCServer+")...")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha Conexao RPC ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RESET ENVIRONMENT IN SERVER oServer
	CLOSE RPCCONN oServer
EndIf
// "Front Loja: Finalizando Thread (FRTA020)..."
ConOut(STR0016)
RESET ENVIRONMENT
MS_QUIT()
FClose(nHdl)
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³FRTEnviar ³ Autor ³ Cesar Eduardo Valadao ³ Data ³16/08/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Enviar "pacote" de orcamento ao Server de Retaguarda		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FRTA020()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Progr.   ³ Data     BOPS   Descricao								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos R. ³12/12/05³088093³- Altera a serie e o status da tabela SLG e ³±±
±±³          ³        ³      ³  SL6 da retaguarda.                        ³±±
±±³Marcos R. ³04/01/06³091100³- Alteracao na gravacao do status da tabela ³±±
±±³          ³        ³      ³  SL6 da retaguarda.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRTEnviar(nVendas)
Local 	lLocalizado	:=.F.
Local 	aSL1		:= {} 
Local 	aSL2 		:= {}
Local 	aSL4 		:= {}
Local 	aAux		:= {}
Local 	aSE5		:= {}
Local 	cConf 		:= ""
Local 	cCOO 		:= ""
Local 	i                         
Local 	lMvLjSrAut	:= SuperGetMV("MV_LJSRAUT",,.F.)	//Indica se utiliza controle de serie automatica

Private x
DEFAULT nVendas    := 0 

dbSelectArea("SL1")
dbSetOrder(9)
If dbSeek(xFilial()+"00")
    nVendas--    
	SA1->(dbSetOrder(1))
	While L1_FILIAL+L1_SITUA == xFilial()+"00" .And. !EOF()
		// Caso o Cliente ainda nao tenha sido gravado na Retaguarda, tenta o proximo SL1.
		If SA1->(dbSeek(xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA)) .And. SA1->A1_SITUA=="00"
			dbSkip()
		Else
			Exit
		EndIf
	End
	If EOF() .Or. L1_FILIAL <> xFilial()
		Return(NIL)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o SL1 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSL1 := Array(FCount())
	For i := 1 To FCount()
		aSL1[i] := {FieldName(i), FieldGet(i)}
	Next
	If L1_OPERACA != "C"
		aSL1[AScan(aSL1,{|x|x[1]=="L1_NUMORIG"})][2] := L1_NUM
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o SL2 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SL2")
	dbSetOrder(1)
	dbSeek(xFilial()+SL1->L1_NUM)
	aSL2 := {Array(FCount())}
	For i := 1 To FCount()
		aSL2[1][i] := FieldName(i)
	Next
	While L2_FILIAL+L2_NUM == xFilial()+SL1->L1_NUM .And. !EOF()
		AAdd(aSL2, Array(FCount()))
		For i := 1 To FCount()
			aSL2[Len(aSL2)][i] := FieldGet(i)
		Next
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o SL4 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SL4")
	dbSetOrder(1)
	dbSeek(xFilial()+SL1->L1_NUM)
	aSL4 := {Array(FCount())}
	For i := 1 To FCount()
		aSL4[1][i] := FieldName(i)
	Next
	While L4_FILIAL+L4_NUM == xFilial()+SL1->L1_NUM .And. !EOF()
		AAdd(aSL4, Array(FCount()))
		For i := 1 To FCount()
			aSL4[Len(aSL4)][i] := FieldGet(i)
		Next
		dbSkip()
	End

	If ExistBlock("FRTEnviar")
		aRet := { aSL1, aSL2, aSL4 }
		aRet := ExecBlock("FRTEnviar",.F.,.F.,aRet)
		aSL1 := aRet[1]
		aSL2 := aRet[2]
		aSL4 := aRet[3]
	Endif

	// "Front Loja: Gravando o Orcamento "
	ConOut( STR0020 + SL1->L1_NUM + "..." )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Foi adicionado este RecLock devido a um problema encontrado 			³
	//³ no cancelamento do cupom.												³
	//³ Quando esta sendo incluido uma venda, e assim que o pacote foi enviado,	³
	//³ nao tiver dado tempo para a gravacao na retaguarda, o cancelamento		³
	//³ nao e feito na retaguarda, causando problemas de sincronizacao de base.	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea( "SL1" )

	If RecLock( "SL1", .F. )
		cNum := oServer:CallProc( "GeraL1L2L4", aSL1, aSL2, aSL4, cEstacao )

		If ValType( cNum ) == "C"
			If Left( cNum, 2 ) == "OK"
				cConf := Substr( cNum, 4, 6 )

				If !Empty( cConf )
					cNum  := oServer:CallProc( "ConfL1L2L4", Substr( cNum, 4, 6 ), cEstacao )

					If ValType( cNum )=="C"
						If cConf <> cNum
							// "Front Loja: Erro ao confirmar a gravacao do Orcamento "
							ConOut( STR0053 + SL1->L1_NUM + "." )
						Else
							aSL1 := { { "L1_NUMORIG", cNum }, ;
										{ "L1_SITUA", "TX" } } // "TX" - Foi Enviado ao Server
							aEval( aSL1, { |x| FieldPut( FieldPos( x[1] ), x[2] ) } )

							// "Front Loja: Orcamento " ### " gravado com sucesso."
							ConOut( STR0021 + SL1->L1_NUM + STR0022 )
						EndIf
					EndIf
				EndIf
			Else
				If Left( cNum, 2 ) == "BX"
					aSL1 := { { "L1_SITUA", "DU" } } // "DU" - Orcamento duplicado na Retaguarda
					aEval( aSL1, { |x| FieldPut( FieldPos( x[1] ), x[2] ) } )

					// "Front Loja: O Orcamento " ### " ja foi gravado na Retaguarda."
					// "            Verifique o L1_SITUA='DU' na estacao."
					ConOut( STR0054 + SL1->L1_NUM + STR0055 )
					ConOut( STR0056 )
				EndIf
			EndIf
		Else
			// "Front Loja: Nao foi possivel gravar o Orcamento " ### " na Retaguarda."
			ConOut( STR0057 + SL1->L1_NUM + STR0058 )
		EndIf
		
		DbCommit()
		MsUnLock()
	Else
		// "Front Loja: Erro ao confirmar a gravacao do Orcamento "
		ConOut( STR0053 + SL1->L1_NUM + "." )
	EndIf
EndIf

cCOO := LjGetStation("COO")
If !Empty(cCOO)
	oServer:CallProc("FRTGrvCOO", cEstacao, cCOO)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se utiliza controle automatico de serie onde quando       ³
//³o numero do ECF Zerar o sistema incrementa a serie automaticamente.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMvLjSrAut
	
	If Select("SL6") > 0
	
		dbSelectArea("SLG")
		dbSetOrder(1)
		
		If MsSeek(xFilial()+cEstacao)
			oServer:CallProc("FRTGrvSR", cEstacao, SLG->LG_SERIE)
		EndIf
		
	EndIf
	
EndIf    

dbSelectArea("SLI")
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³FRTRecebe ³ Autor ³ Cesar Eduardo Valadao ³ Data ³19/09/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Receber "pacote" de base atualizada ("CARGA")              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FRTA020()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRTRecebe()
Local i
Local aAux

If ValType(aCargaOK) == "U"
   Return(.T.)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se Ja Verificou a Carga, Esperar Baixar. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCargaOK) != 0
	Return(.T.)
EndIf

SLI->(dbSeek(xFilial()+"    CRG"))
aCargaOK := oServer:CallProc("FRTChkCarga", Val(cEstacao), SLI->LI_MSG)
If ValType(aCargaOK)=="A" .And. Len(aCargaOK) > 0
	// "Front Loja: Aguardando finalizacao da venda para atualizar a base..."
	ConOut(STR0023)
	FRTGeraSLI("    ", "LCK", "END", "ABANDONA")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se existe SLIs para serem baixados pelo Check-Out. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAux := oServer:CallProc("FRTChkSLI", cEstacao)

If ValType(aAux)=="A" .And. Len(aAux) > 0
	For i := 1 To Len(aAux)
		FRTGeraSLI(cEstacao, aAux[i][1], aAux[i][2], "SOBREPOE", .T., aAux[i][3], aAux[i][4], aAux[i][5])
	Next
EndIf
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ FRTBaixa ³ Autor ³ Cesar Eduardo Valadao ³ Data ³19/09/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza a base recebida.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FRTA020()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRTBaixa
Local i, z, j, cArquivo, aCarga, aCampos, aAlterados, cChave, cPSSSX5:=""
Local aAux, nContinue, nRetry, cCarga, nAt, cCargaAtual, nRet

For i := 1 To Len(aCargaOK)
	nRetry      := 0
	nContinue   :=-1
	cArquivo    := aCargaOK[i][1]
	// "Front Loja: Iniciando Carga " ### " do arquivo " ### "..."
	ConOut(STR0039+aCargaOK[i][2]+STR0059+cArquivo+"...")
	While nContinue != 0
	    ConOut("1. FRTA020 - Chama FRTTXCarga " + cEstacao + " " + aCargaOK[i][2] + " " + aCargaOK[i][1] + " " + ;
	           Str(nContinue))
		aAux := oServer:CallProc("FRTTXCarga", Val(cEstacao), aCargaOK[i][2], aCargaOK[i][1], If(nContinue==-1,0,nContinue))
		If ValType(aAux) == "A"
			aCarga      := aAux[1][1]
			aCampos     := aCarga[2]
			aAlterados  := aCarga[3]
			nContinue   := aAux[2]
			cCargaAtual := aAux[3]
			If Len(aAux) == 4
				cPSSSX5 := aAux[4]
			EndIf
			dbSelectArea(cArquivo)
			dbSetOrder(1)
			For j := 1 To Len(aAlterados)
				cChave := aAlterados[j][2]
				If dbSeek(cChave)
					RecLock(cArquivo)
				Else
					RecLock(cArquivo, .T.)
				EndIf
				If aAlterados[j][1]
					dbDelete()
				Else
					For z := 3 To Len(aAlterados[j])
						nField := AScan(aCampos, {|x| x[1] == aAlterados[j][z][1]})
						If (aCampos[nField][2] == "LG_COO")
							If (aAlterados[j][z][2] > SLG->LG_COO)
								&(cArquivo+"->"+aCampos[nField][2]) := aAlterados[j][z][2]
							EndIf
						Else
							&(cArquivo+"->"+aCampos[nField][2]) := aAlterados[j][z][2]
						EndIf
					Next
				EndIf
				dbCommit()
				MsUnLock()
			Next
			If nContinue == 0
				lOk := .T.
				If cPSSSX5 == "CARREGAR"
					// Atualizar o SIGAADV.PSS em pacotes.
					FRTGeraSLI(cEstacao, "PSS", "CARREGAR", "SOBREPOE")
				EndIf
				If lOk
					dbSelectArea("SLI")
					dbSeek(xFilial("SLI")+"    CRG")
					cCarga := SLI->LI_MSG
					nAt := At(cArquivo,cCarga)
					If nAt > 0
						cCarga := Stuff(cCarga, nAt+3, 6, cCargaAtual)
					Else
						cCarga := AllTrim(cCarga)+cArquivo+cCargaAtual
					EndIf
					FRTGeraSLI("    ", "CRG", cCarga, "SOBREPOE")
					If cPaisLoc != "BRA" .And. cArquivo == "SM2" 
					   FRTGeraSLI("    ", "SM2", "ATUALIZA", "SOBREPOE")
					EndIf
					nRet := oServer:CallProc("FRTCargaOK", Val(cEstacao), cArquivo+cCargaAtual)
					If ValType(nRet) == "N" .And. nRet == 0
						// "Front Loja: Carga " ### " do arquivo " ### " atualizada."
						ConOut(STR0024+aCargaOK[i][2]+STR0059+cArquivo+STR0025)
					EndIf
				EndIf
			EndIf
		Else
			If ValType(aAux) == "N"
				If (aAux >= 2 .And. aAux <= 4) .Or. (aAux >= 11 .And. aAux <= 13)
					// "Front Loja: Ocorreu algum problema na abertura dos arquivos de Carga das"
					// "            Estacoes no Servidor. Erro: "
					ConOut(STR0026)
					ConOut(STR0027+Str(aAux,2,0))
				EndIf
			EndIf		
			If nContinue != 0 .And. ++nRetry > 10
				nContinue := 0
				// "Front Loja: Nao foi possivel efetuar a Carga " ### " do arquivo " ### "."
				ConOut(STR0028+aCargaOK[i][2]+STR0059+cArquivo+".")
				Exit
			EndIf
			Sleep(1000)
		EndIf
	End
Next
aCargaOK := {}
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FRTLockOK    ³Autor ³ Cesar Eduardo Valadao³Data³06/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica se as estacoes jah estao esperando atualizacao    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRTLockOK
Local nRecno:=Recno(), lRet:=.F.
If dbSeek(xFilial("SLI")+cEstacao+" CON")
	lRet := Left(SLI->LI_MSG,1) != "V"
Else
	// Caso nao exista o registro, pode atualizar
	lRet := .T.		
EndIf
dbGoto(nRecno)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FRTA020Sta³ Autor ³ Cesar Eduardo Valadao ³ Data ³05/06/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inicia a Thread FRTA020.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FRTA020Sta()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function StaINNO_020
// Function, Environment, Wait Thread, Par1, Par2, Parn, ...
// "Iniciada a Thread FRTA020.", "Atenção"
MsgStop(STR0031, STR0032)
StartJob("INNO_020", GetEnvServer(), .F., cEmpAnt, cFilAnt, cEstacao)
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³FRTA020End³ Autor ³ Cesar Eduardo Valadao ³ Data ³05/06/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicia a Thread FRTA020.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FRTA020End()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EndINNO_020
// "Finalizada a Thread FRTA020.", "Atenção"
MsgStop(STR0033, STR0032)
FRTGeraSLI("    ", "   ", "ENDTHREAD", "SOBREPOE")
Return(NIL)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ FRTAtuCRG³ Autor ³ Cesar Eduardo Valadao ³ Data ³05/06/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Realiza a atualizacao de todas as tabelas no Check-Out.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRTAtuCRG
Local lLockOk := .F.
Local i, aFiles
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o Check-Out estiver no ar, aguarda ele fechar as tabelas... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FRTSemaStat("OPE", LI_ESTACAO)
	lLockOk := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Enviar comando para o Check-Out Parar a operacao e fechar as tabelas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// "Front Loja: Enviando solicitacao para o Check-Out fechar as tabelas..."
	ConOut(STR0044)
	FRTGeraSLI(cEstacao, "COM", "CLOSE FILES", "SOBREPOE")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aguardar o fechamento dos arquivos no Check-Out. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While .T.
		SLI->(dbSeek(xFilial("SLI")+PadR(cEstacao,4)+"COM"))
		If Left(SLI->LI_MSG,8)=="CLOSE OK"
			Exit
		EndIf
	End
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechar, Abrir Exclusivo, Zap, Fechar, Abrir Compartilhado... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFiles := FRTArquivos()
For i := 1 To Len(aFiles)
	#IFNDEF TOP
		&(aFiles[i]+"->(dbCloseArea())")						// Fecho
		If ChkFile(aFiles[i], .T.)								// Abro exclusivo
			dbSelectArea(aFiles[i])
			Zap													// Limpo
		Else
			// "Front Loja: Nao foi possivel a abertura exclusiva do arquivo "
			ConOut(STR0045+aFiles[i]+"...")
		EndIf
		&(aFiles[i]+"->(dbCloseArea())")						// Fecho
		If !ChkFile(aFiles[i])									// Abro compartilhado
			// "Front Loja: Nao foi possivel a reabertura do arquivo "
			ConOut(STR0046+aFiles[i]+"...")
		EndIf
	#ELSE
		TCSQLEXEC("DELETE FROM "+RetSqlName(aFiles[i]))
	#ENDIF
Next
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zerar a Protocolo de Carga "CRG" e Recebe-las ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FRTGeraSLI("    ", "CRG", "", "SOBREPOE")
aCargaOK := oServer:CallProc("FRTChkCarga", Val(cEstacao), SLI->LI_MSG)
If Len(aCargaOK) > 0
	FRTBaixa()
	FRTGeraSLI("    ", "LCK", "", "SOBREPOE")
EndIf
If lLockOk
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Enviar comando para o Check-Out Retornar a operacao. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FRTGeraSLI(cEstacao, "COM", "OPEN FILES", "SOBREPOE")
Else
	FRTGeraSLI(cEstacao, "COM", "", "SOBREPOE")
EndIf
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ FRTGrvSPF³ Autor ³ Cesar Eduardo Valadao ³ Data ³23/09/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza as senhas do usuario (SIGAPSS.SPF)                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FRTGrvSPF
Local lLockOk := .F.
// "Front Loja: Iniciando a atualizacao das Senhas..."
ConOut(STR0049)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o Check-Out estiver no ar, aguarda ele fechar o SIGAPSS.SPF ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If FRTSemaStat("OPE", LI_ESTACAO)
	lLockOk := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Enviar comando para o Check-Out Parar a operacao e fechar as tabelas. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// "Front Loja: Enviando solicitacao para o Check-Out fechar o arquivo de senhas..."
	ConOut(STR0068)
	FRTGeraSLI(cEstacao, "PSS", "CLOSE SPF", "SOBREPOE")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aguardar o fechamento do SIGAPSS.SPF no Check-Out. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While .T.
		SLI->(dbSeek(xFilial("SLI")+PadR(cEstacao,4)+"PSS"))
		If Left(SLI->LI_MSG,10)=="SPF CLOSED"
			Exit
		EndIf
	End
EndIf
If PSWGetSinc(oServer)
	aRet := oServer:CallProc("FRTTXSX5")
	If ValType(aRet) == "A"
		FRTRXSX5(aRet)
		FRTGeraSLI(cEstacao, "PSS", "", "SOBREPOE")
		// "Front Loja: Atualizacao das Senhas finalizada."
		ConOut(STR0050)
	Else
		// "Front Loja: Erro ao finalizar a atualizacao do arquivo de Senhas."
		ConOut(STR0052)
		Return(NIL)
	EndIf
Else
	// "Front Loja: Erro ao finalizar a atualizacao do arquivo de Senhas."
	ConOut(STR0052)
	Return(NIL)
EndIf
If lLockOk
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Enviar comando para o Check-Out Retornar a operacao. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FRTGeraSLI(cEstacao, "PSS", "SPF OK", "SOBREPOE")
Else
	FRTGeraSLI(cEstacao, "PSS", "", "SOBREPOE")
EndIf
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FRTGravaFIºAutor  ³ Cesar E. Valadao    º Data ³  16/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava os campos do Server Local.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Front Loja                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data/Bops/Ver ³Manutencao Efetuada                      	   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLuiz Couto³07/09/05³8.11  ³- Implementacao continua: padronizacao de    º±±
±±º          ³        ³      ³fontes.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IFRTGravaFI()

Local i		:= 0				//Variavel de apoio
Local aSFI	:= {}				//Array com os campos do SFI
Local aRet	:= {}				//Retorno do RPC GeraSFI
Local lRet	:= .T.				//Retorno do RPC ConfSFI

DbSelectArea( "SFI" )
DbSetOrder( 2 )

If MsSeek( xFilial() + "00" )
	aSFI := Array( FCount() )

	For i := 1 To FCount()
		aSFI[i] := { FieldName( i ), FieldGet( i ) }
	Next

	aRet := oServer:CallProc( "GeraSFI", aSFI )

	If ValType( aRet ) == "A"
		If Left( aRet[1], 2 ) == "OK"
			lRet := oServer:CallProc( "ConfSFI", aRet[2] )

			If ValType( lRet ) == "L"
				aSFI := { { "FI_SITUA", "TX" } }					// "TX" - Foi Enviado ao Server
				FRTGeraSL( "SFI", aSFI, .F. )
			EndIf
		EndIf
	EndIf
EndIf

Return ( NIL )
