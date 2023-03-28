#INCLUDE "PROTHEUS.CH"
#Include "FILEIO.ch" 
#define _PICTURE 13
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
User Function FRTFuncoes()
Local aParam	:= ParamIXB
Local aFuncoes	:= {}
Local cAuxImp	:= INNO_IMP[1]

INNO_IMP[1]:= "I"
INNO_IMP[2]:=""
U_IA200Imp()

//aFuncoes[2]:={"04", "Reimprimir SAT"		, "FR271FImpSAT()"					, {||.T.}	}
aadd(aFuncoes, aParam[1]) //Cancelamento 
aadd(aFuncoes, {"04", "Reimprimir SAT"		, "FR271FImpSAT()"				, {||.T.}	})
aadd(aFuncoes, {"--", ""					, ""							, {||.T.}	})
aadd(aFuncoes, {"92", "Relatorio Delivery"	, "U_IA018F1292(@nHdlECF,3)"	, {||.T.}	})
aadd(aFuncoes, {"93", "Sinal Encomenda"   	, "U_IA017F1293(@nHdlECF,3)"	, {||.T.}	})
aadd(aFuncoes, {"95", "Entrada Troco"		, 'U_IA009F1295(@nHdlECF,2)'	, {||.T.}	})
aadd(aFuncoes, {"96", "Sangria"				, 'U_IA009F1295(@nHdlECF,1)'	, {||.T.}	})
aadd(aFuncoes, {"97", "Despesas "			, "U_IA008F1297(@nHdlECF,1)"	, {||.T.}	})
aadd(aFuncoes, {"98", "Relatorio Fechamento", "U_IA007F1298(@nHdlECF)"		, {||.T.}	})
aadd(aFuncoes, {"99", "Innocêncio"			, "U_IA200F1299('I',@cPdv,.T.)"	, {||.T.}	})

INNO_IMP[1]	:= cAuxImp

Return aFuncoes


/*
Este Ponto de Entrada é executado antes da gravação da tabela SL4, e permite a alteração das informações que estão no array antes de serem gravadas na tabela.

SL4 - Array com a informação da SL4

nI - Posicao do array que vai ser gravado o pagamento 

Retorno - aSL4 - Retorna o array para a gravação na tabela SL4
*/
User Function FRTGRSL4()

Local aSL4 		:= PARAMIXB[1] //Array com a informação da SL4
Local nI 		:= PARAMIXB[2] //Posição do array que vai ser gravado o pagamento 
Local c1DUP 	:= SuperGetMV("MV_1DUP") 						// Sequência das parcelas "1" = 1..9;A..Z;a..z    e   "A" = A..Z
Local cForma	:=""
lOCAL cParcela 	:= ""
Local nPos		:= Ascan( aSL4,{|X| X[1]=="L4_FORMA"})

cForma:= Alltrim(aSL4[nPos,2])
Do Case
	Case cForma == "VA"
		INNO_Parc[3]++
		cParcela	:= LJParcela(INNO_Parc[3], c1DUP)
	Case cForma == "CC"
		INNO_Parc[1]++
		cParcela	:= LJParcela(INNO_Parc[1], c1DUP)
	Case cForma == "CD"
		INNO_Parc[2]++
		cParcela	:= LJParcela(INNO_Parc[2], c1DUP)
EndCase
If (nPos:= Ascan( aSL4,{|X| X[1]=="L4_PARCTEF"}))<>0
	aSL4[nPos,2]:=cParcela
Else	
	AADD(aSL4,{"L4_PARCTEF",cParcela})
EndIf
//Alteração do telefone do terceiro do cheque
//aSL4[nI][9] := '11999998888'

Return aSL4

//===============================================================================================================
/*
Descrição:
Retorna para quais formas será exibido a tela de troco no Front Loja.

FRTTROCO ( [ ExpL1 ], [ ExpN2 ], [ ExpA3 ] ) --> lRet

Parâmetros:
Nome			Tipo			Descrição			Default			Obrigatório			Referência	
ExpL1			Lógico			Indica se a forma de pagamento é dinheiro										
ExpN2			Array of Record			Valor pago na forma "Vales" .										
ExpA3			Array of Record			aPgtos - Array contendo as descrições das formas de pagamentos.										
Retorno
lRet(logico)
Caso .T. mostrara a tela de troco após ter pressionado o segundo (F9).
Observações
*/
User Function FRTtroco() //POnto de Entrada

Return .F.


/*
ponto de Entrada

Localização:	Venda Assistida (LOJA701) / Frente de Lojas (FRTA271)
Eventos:	Este ponto de entrada permite omitir a tela de CPF/CNPJ e/ou incluir o retorno automático das
informações ( em substituição a tela padrão do sistema )
Programa Fonte:	LOJXFUND
Função:	LJRETCLI
Parâmetros	nenhum
Retorno:
aRetCli[1]	caracter	Código do Cliente	Sim
aRetCli[2]	caracter	Loja do Cliente	Sim
aRetCli[3]	caracter	CPF/CNPJ	Não
aRetCli[4]	lógico	Tela Customizada ou omitida?
Se retorno .T., o protheus não mostra
a tela padrão.
Caso .F., mesmo retornando as informações
a tela será mostrada 	Não
aRetCli[5]	caracter	Nome do Cliente	Não
aRetCli[6]	caracter	Endereço do cliente	Não
aRetCli[7]	caracter	Placa do Carro ( somente se usa Template de Combustíveis )	Não
aRetCli[8]	caracter	Quilometragem ( somente se usa Template de Combustíveis )	Não
Fontes do Pacote:

LOJXFUND.PRW  25/10/2016 18:14:09
Pacote:	CH TVZDC3.zip

*/
User Function LjRetCli() //POnto de Entrada
	Local aRet := {"","",INNO_CPF,.T.,"","","",""}

	//[1] - Código do cliente
	//[2] - Loja do cliente
	//[3] - CPF/CNPJ
	//[4] - Logico, tela customizada no PE (se .T. não mostra a tela padrão, se .F. mostra a tela padrão)
	//[5] - Nome do cliente
	//[6] - Endereco do cliente
	//[7] - Se usar Template de Combustiveis deve mostrar a placa do carro
	//[8] - Se usar Template de Combustiveis deve mostrar a kilometragem do carro
	/*
	aRet[1] := "2 "
	aRet[2] := "01"
	aRet[3] := "52840975483"
	aRet[4] := .T.
	aRet[5] := "CLIENTE 2 "
	aRet[6] := "RUA XXXX,78 "
	aRet[7] := "ABC-1234"
	aRet[8] := "5000 Km"
	*/
Return aRet

/*
Ponto de Entrada: FrtGeraCar
Descrição:
Esse ponto de entrada é chamado durante a geração da Carga.

Observações: Para substituir o conteúdo de um campo na Carga do SBI, deve-se utilizar esse ponto de entrada para a manipulação. 
Por exemplo, se existir um campo de descrição resumida, com 23 caracteres, e se queira que esse conteúdo entre no lugar da descrição no SBI:

Programa Fonte
.PRW
Sintaxe
FRTGeraCar - Geração de carga ( ) --> aRet

Retorno
aRet(vetor)
Array com campos e conteúdos a serem substituídos.
*/

User Function _FrtGeraCar()
ConOut( "FrtGeraCar() =======================================: "+SB1->B1_COD+ "  "+SB1->B1_ORIGEM)
Return( {{ "BI_ORIGEM", "SB1->B1_ORIGEM"}})


/*
 

Descrição:
Ponto de entrada - Tecla de atalho acessível a partir da opção CTRL+T
Eventos
*/
User Function FRTCTRLT()
Local cImpressora	:=LjGetStation("IMPFISC")
Local cPorta		:= LjGetStation("PORTIF")

INNO_IMP[1]:= If(INNO_IMP[1]=="E","I","E")
INNO_IMP[2]:=""

If INNO_IMP[1]=="E"
	//nRet:=IFFechar(nHdlECF,cPorta)
	nRet:=INFFechar("0",cPorta)
EndIf

Return .T.             


User Function FRTFUNCSAI()
Local cImpressora	:=LjGetStation("IMPFISC")
Local cPorta		:= LjGetStation("PORTIF")

INNO_IMP[1]:="E"
INNO_IMP[2]:=""
nRet:=INFFechar("0",cPorta)

Return .T.             



