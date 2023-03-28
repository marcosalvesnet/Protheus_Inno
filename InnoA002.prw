#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CHKEXEC  ³ Autor ³ Marcos Alves          ³ Data ³02/02/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava o Numero do PDV na entrada da rotina de Atendimento  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CHKEXEC(cFuncion)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Progr.   ³ Data     BOPS   Descricao								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos    ³02/02/08³Criacao 									          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
43ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SIGAFRT()

Local cFunction		:=ParamIxb
Local lRet			:=.T.

Local cPathSx 		:= Alltrim(GetPvProfString(GetEnvServer(),"rootpath","",GetADV97())) + "\SYSTEM\"	// Retorna o StartPath

//26/03/15 - Selecao do do cliente/Funcionario para a Venda F10
Public INNO_CLI		//Codigo do Cliente padrao
Public INNO_LOJ		// Loja do cliente 
Public INNO_SALD	// Saldo Disponivel para compra
Public INNO_Parc	// Contador de parcela TEF
Public INNO_V03
Public INNO_V06		//Armazena o PDV apos a comuntacao 
Public INNO_PDV
Public INNO_ECF
Public INNO_IMP
Public INNO_RIMP	//Reimpressão R$
Public INNO_HDL
Public INNO_APGTOS
Public INNO_CPF
Public INNO_TI
Public INNO_TI2
Public INNO_SAT		

Public INNO_HDF
Public INNO_HDE

Public INNO_AIF // PATH E NOME DO ARQUIVO Nome do arquivo Ifood
Public INNO_CIF // Atualiza cadastro Ifood


DEFAULT INNO_HDF 	:=-1
DEFAULT INNO_HDE	:=-1

DEFAULT INNO_CLI	:= SuperGetMV("MV_CLIPAD")		//Codigo do Cliente padrao
DEFAULT INNO_LOJ	:= cFilAnt						// Loja do cliente 
DEFAULT INNO_SALD	:= 0							// Saldo Disponivel para compra
DEFAULT INNO_Parc	:= {}							// Contador de parcela TEF
DEFAULT INNO_V03	:=  GetPvProfString("FILIAL_"+cFilAnt, "IMPRESSAO"		, "", GetClientDir()+"INNO.INI")
DEFAULT INNO_V06	:= ""	//Armazena o PDV apos a comuntacao 
DEFAULT INNO_PDV	:= GetPvProfString("FILIAL_"+cFilAnt, "PDV"		, "", GetClientDir()+"INNO.INI")
DEFAULT INNO_ECF	:= LjGetStation("PDV")
DEFAULT INNO_IMP	:= {GetPvProfString("FILIAL_"+cFilAnt, "IMPRESSAO"		, "", GetClientDir()+"INNO.INI"),""}  // I = Impressora de cupom ; E=Emulador de impressora
DEFAULT INNO_RIMP	:= .F. //Reimpressão R$
DEFAULT INNO_HDL	:= -1
DEFAULT INNO_APGTOS	:= {}
DEFAULT INNO_CPF	:= ""
DEFAULT INNO_SAT	:= GetPvProfString("FILIAL_"+cFilAnt, "innosat"		, "", GetClientDir()+"INNO.INI")


INNO_CIF   	:= GetPvProfString("INNO", "IFOODCARGA","1", GetRemoteIniName()) // Local dos arquivos pedido iFood - Sintaxe: GetPvProfString(cSecao, cChave, cPadrao, cServerIni) 
INNO_AIF 	:= {"",""} //Path e Nome do Arquivo do pedido Ifood

If INNO_HDL = -1
	ConOut("Carregando INNODPH.DLL")
	INNO_HDL := ExecInDLLOpen("INNODPH.DLL")
	If INNO_HDL = -1
		MsgInfo("Erro na abertura INNODPH.DLL, Verifique se o arquivo INNODPH.DLL esta em "+cPathServer)
	EndIf
EndIf

If nHdlECF<> -1 
	INNO_HDF:=nHdlECF
	
	cImpressora	:= "EMULADOR NAO FISCAL"
	cPorta		:= "COM1"
	For nI := 1 to 10
		nHdlECF:= INFAbrir(cImpressora, cPorta,0,9000)
		ConOut("Abrindo Impressora............: "+cImpressora+" Tentativa..: "+Str(nI,3))
		If nHdlECF<>NIL .AND. nHdlECF<>-1
			Exit
		EndIf	
	    Sleep( 2000 ) // Para o processamento por 5 segundo
	Next nI
	INNO_HDE:=nHdlECF
	
	nHdlECF:=INNO_HDF
EndIf
//Iniciazar as variaveis Static de inicio de vendas
U_IA223InitVar()

Return lRet

User Function SIGALOJ()
Public INNO_HDL

DEFAULT INNO_HDL := -1

If INNO_HDL = -1
	ConOut("Carregando INNODPH.DLL")
	INNO_HDL := ExecInDLLOpen("INNODPH.DLL")
	If INNO_HDL = -1
		MsgInfo("Erro na abertura INNODPH.DLL, Verifique se o arquivo INNODPH.DLL esta em \BIN\SMARTCLIENT")
	EndIf
EndIf
Return Nil
