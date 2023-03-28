#include 'protheus.ch'
#include 'parmtype.ch'

User function IA400Grv(aNewProd, nVlrDescTot,nPercDesc)
Local lRet		:= .T.
Local cDOC		:= GetPvProfString("FILIAL_"+cFilAnt, "DOC"		, "", GetClientDir()+"INNO.INI")
Local cSerie	:= GetPvProfString("FILIAL_"+cFilAnt, "SERIE"	, "", GetClientDir()+"INNO.INI")
Local cPDV		:= GetPvProfString("FILIAL_"+cFilAnt, "PDV"		, "", GetClientDir()+"INNO.INI")
Local cEst		:= GetPvProfString("FILIAL_"+cFilAnt, "ESTACAO"	, "", GetClientDir()+"INNO.INI")
Local cNumMov	:= GetPvProfString("FILIAL_"+cFilAnt, "NUMMOV"	, "", GetClientDir()+"INNO.INI")
Local cSerSat	:= GetPvProfString("FILIAL_"+cFilAnt, "SERSAT"	, "", GetClientDir()+"INNO.INI")
Local cKey		:= GetPvProfString("FILIAL_"+cFilAnt, "KEYNF"	, "", GetClientDir()+"INNO.INI")
Local cKeyNf	:= ""
Local cNum		:= CriaVar("L1_NUM")
Local cLocal	:= ""
Local aAreaSBI 	:= SBI->(GetArea())
Local aAreaSF4 	:= SF4->(GetArea())
Local aSL1		:= {}
Local aSL2		:= {}
Local aSL4		:= {}
Local cNroPCli		:= ""
Local nVlrBruto		:= 0
Local nVlrTotal		:= 0
Local nDinheiro		:= 0
Local nCredito		:= 0
Local nCartao		:= 0
Local nConvenio		:= 0
Local nVales		:= 0
local nValorDebi	:= 0 
Local nOutros		:= 0 
Local nEntrada		:=0
Local nParcelas		:= 1
//Local nDescItem		:= nVlrDescTot/Len(aNewProd)

cKeyNF:= "3519021111111111111159"+cSerSat+cKey

SF4->(DBSetOrder(1))
SBI->(DBSetOrder(1))
//======================================== SL2 ==========================================
//Estrutura do Array aNewProd
// 1-NUmero do cartao
// 2-Atendente
// 3-Codigo do Produto
// 4-Descricao do produto
// 5-Quantidade
// 6-Unidade de Medida
// 7-Preco unitario
// 8-Numero do registro no SZZ (quando salvo)
// 9-Flag para indicar se o registro esta deletado			
// 10- Numero do Item
// 11-Flag Indica se produto ja foi impresso no ECF
For nI:=1 To Len(aNewProd)
	SBI->(dbSeek(xFilial("SBI")+aNewProd[nI,3])) 	
	SF4->(dbSeek(xFilial("SF4")+SBI->BI_TS)) 		
	
	aSL2 := {	{"L2_FILIAL"	,	xFilial("SL2")	}, ;
				{"L2_NUM"		,	cNum			}, ;
				{"L2_PRODUTO"	,	aNewProd[nI,3]	}, ;
				{"L2_ITEM"		,	StrZero(aNewProd[nI,10],2)	}, ;
				{"L2_DESCRI"	,	aNewProd[nI,4]	}, ;
				{"L2_QUANT"		,	aNewProd[nI,5]	}, ;
				{"L2_VRUNIT"	,	aNewProd[nI,7]	}, ;
				{"L2_VLRITEM"	,	aNewProd[nI,5] * aNewProd[nI,7]	}, ;
				{"L2_LOCAL"		,	SBI->BI_LOCPAD	}, ;
				{"L2_UM"		,	SBI->BI_UM		}, ;
				{"L2_DESC"		,	0				}, ;
				{"L2_DESCPRO"	,	0				}, ;
				{"L2_TES"		,	SBI->BI_TS		}, ;
				{"L2_CF"		,	SF4->F4_CF		}, ;
				{"L2_VENDIDO"	,	"S"				}, ;
				{"L2_DOC"		,	cDoc			}, ;
				{"L2_SERIE"		,	cSerie			}, ;
				{"L2_PDV"		,	cPDV			}, ;
				{"L2_VALIPI"	,	0				}, ;
				{"L2_VALICM"	,	0				}, ;
				{"L2_BASEICM"	,	0				}, ;
				{"L2_TABELA"	,	"1"				}, ; //???????????
				{"L2_ITEMSD1"	,	"000000"		}, ; //???????????
				{"L2_EMISSAO"	,	dDataBase		}, ;
				{"L2_PRCTAB"	,	aNewProd[nI,7]	}, ;
				{"L2_GRADE"		,	"N"				}, ;
				{"L2_VEND"		,	aNewProd[nI,2]	}, ;
				{"L2_SITUA"		,	"04"			}, ;
				{"L2_SITTRIB"	,	"N1"			}, ;
				{"L2_VDMOST"	,	"N"				}, ;
				{"L2_CODBAR"	,	SBI->BI_CODBAR	}, ;
				{"L2_ORIGEM"	,	"0"				}, ;
				{"L2_POSIPI"	,	SBI->BI_POSIPI	}}
	FR271BGeraSL("SL2", aSL2, .T.)
	nVlrBruto += ( aNewProd[nI,5] * aNewProd[nI,7] ) //Quantidade * valor Unitario
	nVlrTotal += ( aNewProd[nI,5] * aNewProd[nI,7] ) //Quantidade * valor Unitario
	nEntrada += ( aNewProd[nI,5] * aNewProd[nI,7] ) //Quantidade * valor Unitario
	
Next nI

//=========================================== SL4 ===========================
// Estrutura do Array - INNO_APGTOS =>aPgtos
	// 01-Data
	// 02-Valor
	// 03-Forma
	// 04-Administradora
	// 05-Num Cartao
	// 06-Agencia
	// 07-Conta
	// 08-RG
	// 09-Telefone
	// 10-Terceiro
	// 11-Moeda
	// 12-Digitos do cartao para TEFMULT
	// 13-Conceito de acrescimo financeiro separado
		
For nI:=1 To Len(INNO_APGTOS)
	aSL4 := {	{"L4_FILIAL"	,	xFilial("SL4")		}, ;
				{"L4_NUM"		,	cNum				}, ;
				{"L4_DATA"		,	INNO_APGTOS[nI,1]	}, ;
				{"L4_VALOR"		,	INNO_APGTOS[nI,2]	}, ;
				{"L4_FORMA"		,	INNO_APGTOS[nI,3]	}, ;
				{"L4_ADMINIS"	,	INNO_APGTOS[nI,4]	}, ;
				{"L4_TERCEIR"	,	.F.					}, ;
				{"L4_MOEDA"		,	0					}}
	
	FR271BGeraSL("SL4", aSL4, .T.)
	If INNO_APGTOS[nI,3] == "R$" 
		nDinheiro+=INNO_APGTOS[nI,2]
	ElseIf INNO_APGTOS[nI,3] == "CC" 
		nCartao+=INNO_APGTOS[nI,2]
		nCredito+=INNO_APGTOS[nI,2]
	ElseIf INNO_APGTOS[nI,3] == "CD" 
		nCartao+=INNO_APGTOS[nI,2]
		nValorDebi+=INNO_APGTOS[nI,2]
	ElseIf INNO_APGTOS[nI,3] == "VA" 
		nCartao+=INNO_APGTOS[nI,2]
		nVales+=INNO_APGTOS[nI,2]
	ElseIf INNO_APGTOS[nI,3] == "CO" 
		nConvenio+=INNO_APGTOS[nI,2]
	Else
		nOutros+=INNO_APGTOS[nI,2]
	EndIf
Next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no Cliente escolhido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+INNO_CLI+INNO_LOJ)
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no Vendedor escolhido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial("SA3")+aNewProd[1,2]) //Vendedor do primeiro item vendido

//nVlrBruto := nVlrBruto-nVlrDescTot // Subtrair o valor do Desconto
nVlrTotal := nVlrTotal-nVlrDescTot // Subtrair o valor do Desconto

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Encerramento do Cupom - Finaliza o SL1 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSL1 := {	{"L1_FILIAL"	,	xFilial("SL1")	}, ;
			{"L1_NUM"		,	cNum			}, ;
			{"L1_VEND"		,	SA3->A3_COD		}, ;
			{"L1_COMIS"		,	SA3->A3_COMIS	}, ;
			{"L1_CLIENTE"	,	SA1->A1_COD		}, ;
			{"L1_TIPOCLI"	, 	SA1->A1_TIPO	}, ;
			{"L1_LOJA"		,	SA1->A1_LOJA	}, ;
			{"L1_TIPO"		,	"V"				}, ;
			{"L1_VLRTOT"	,	nVlrTotal		}, ;
			{"L1_DESCONT"	,	nVlrDescTot		}, ;
			{"L1_VLRLIQ"	,	nVlrTotal		}, ;
			{"L1_DTLIM"		,	dDataBase		}, ;
			{"L1_DOC"		,	cDoc			}, ;
			{"L1_SERIE"		,	cSerie			}, ;
			{"L1_PDV"		,	cPDV			}, ;
			{"L1_EMISNF"	,	dDataBase		}, ;
			{"L1_VALBRUT"	,	nVlrBruto		}, ;
			{"L1_VALMERC"	,	nVlrBruto		}, ;
			{"L1_TIPO"		,	"V"				}, ;
			{"L1_DESCNF"	,	nPercDesc		}, ;
			{"L1_OPERADO"	,	xNumCaixa()		}, ;
			{"L1_DINHEIR"	,	nDinheiro		}, ;
			{"L1_CARTAO"	,	nCartao			}, ;
			{"L1_CONVENI"	,	nConvenio		}, ;
			{"L1_VALES"		,	nVales			}, ;
			{"L1_VLRDEBI"	,	nValorDebi		}, ;
			{"L1_OUTROS"	,	nOutros			}, ;
			{"L1_ENTRADA"	,	nVlrTotal		}, ;
			{"L1_PARCELA"	,	nParcelas		}, ;
			{"L1_TXDESC"	,	0				}, ;
			{"L1_CONDPG"	,	""				}, ;
			{"L1_INTERV"	,   0				}, ;
	        {"L1_CREDITO"	,   nCredito		}, ;
	        {"L1_CONFVEN"	, "SSSSSSSSNSSS"	}, ;
			{"L1_IMPRIME"	,	"1S"			}, ;
			{"L1_VALICM"	,	0				}, ; //?????
			{"L1_VALIPI"	,	0				}, ; 
			{"L1_FORMPG"	,	INNO_APGTOS[1,3] }, ; 
			{"L1_CONDPG"	,	"CN"			 }, ; 
			{"L1_EMISSAO"	,	dDataBase		 }, ; 
			{"L1_NUMCFIS"	,	cDoc			 }, ; 
			{"L1_HORA"		,	TIME()			 }, ; 
			{"L1_ESPECIE"	,	"SATCE"			 }, ; 
			{"L1_ESTACAO"	,	cEst			 }, ; 
			{"L1_NUMMOV"	,	cNumMov			 }, ; 
			{"L1_TPORC"		,	"E"				 }, ; 
			{"L1_KEYNFCE"	,	cKeyNF			 }, ; 
			{"L1_SERSAT"	,	cSerSAT			 }, ; 
			{"L1_SITUA"	,	"00"}}						
	FR271BGeraSL("SL1", aSL1, .T.)
//Grava o proximo numero de documento
WritePProString("FILIAL_"+cFilAnt, "DOC"	, StrZero(Val(cDoc)+1,6,0)	, GetClientDir()+"INNO.INI")
WritePProString("FILIAL_"+cFilAnt, "NUMMOV"	, Soma1(cNumMov,2)			, GetClientDir()+"INNO.INI")
WritePProString("FILIAL_"+cFilAnt, "KEYNF"	, Soma1(cKey,13)			, GetClientDir()+"INNO.INI")

If ( __lSX8 )
	ConfirmSX8()
EndIf

/*
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada no final da venda atuliza dados (SL1/SL2): บฑฑ
ฑฑบ          ณ- Vendedor                                                  บฑฑ
ฑฑบ          ณ- Desbloquei o cartao                                       บฑฑ
ฑฑบ          ณ- CPf                                                       บฑฑ
ฑฑบ          ณ- Exclui venda em caso de reeimpressao                      บฑฑ
ฑฑบ          ณ- Inicializa as variaveis Static para proxima venda         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
U_FRTEntreg()

	
RestArea( aAreaSBI )
Return lRet