#INCLUDE "PROTHEUS.CH"
#Include "FILEIO.ch" 
#define _PICTURE 13
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FR271FFuncoes  � Autor � Marcos Alves    � Data �02/02/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o � F12- Funcao Innocencio                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FR271FFuncoes()                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � FrontLoja												  ���
�������������������������������������������������������������������������Ĵ��
��� Progr.   � Data        Descricao								      ���
�������������������������������������������������������������������������Ĵ��
���Marcos    �02/02/08�Criacao 									          ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
aadd(aFuncoes, {"99", "Innoc�ncio"			, "U_IA200F1299('I',@cPdv,.T.)"	, {||.T.}	})

INNO_IMP[1]	:= cAuxImp

Return aFuncoes


/*
Este Ponto de Entrada � executado antes da grava��o da tabela SL4, e permite a altera��o das informa��es que est�o no array antes de serem gravadas na tabela.

SL4 - Array com a informa��o da SL4

nI - Posicao do array que vai ser gravado o pagamento 

Retorno - aSL4 - Retorna o array para a grava��o na tabela SL4
*/
User Function FRTGRSL4()

Local aSL4 		:= PARAMIXB[1] //Array com a informa��o da SL4
Local nI 		:= PARAMIXB[2] //Posi��o do array que vai ser gravado o pagamento 
Local c1DUP 	:= SuperGetMV("MV_1DUP") 						// Sequ�ncia das parcelas "1" = 1..9;A..Z;a..z    e   "A" = A..Z
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
//Altera��o do telefone do terceiro do cheque
//aSL4[nI][9] := '11999998888'

Return aSL4

//===============================================================================================================
/*
Descri��o:
Retorna para quais formas ser� exibido a tela de troco no Front Loja.

FRTTROCO ( [ ExpL1 ], [ ExpN2 ], [ ExpA3 ] ) --> lRet

Par�metros:
Nome			Tipo			Descri��o			Default			Obrigat�rio			Refer�ncia	
ExpL1			L�gico			Indica se a forma de pagamento � dinheiro										
ExpN2			Array of Record			Valor pago na forma "Vales" .										
ExpA3			Array of Record			aPgtos - Array contendo as descri��es das formas de pagamentos.										
Retorno
lRet(logico)
Caso .T. mostrara a tela de troco ap�s ter pressionado o segundo (F9).
Observa��es
*/
User Function FRTtroco() //POnto de Entrada

Return .F.


/*
ponto de Entrada

Localiza��o:	Venda Assistida (LOJA701) / Frente de Lojas (FRTA271)
Eventos:	Este ponto de entrada permite omitir a tela de CPF/CNPJ e/ou incluir o retorno autom�tico das
informa��es ( em substitui��o a tela padr�o do sistema )
Programa Fonte:	LOJXFUND
Fun��o:	LJRETCLI
Par�metros	nenhum
Retorno:
aRetCli[1]	caracter	C�digo do Cliente	Sim
aRetCli[2]	caracter	Loja do Cliente	Sim
aRetCli[3]	caracter	CPF/CNPJ	N�o
aRetCli[4]	l�gico	Tela Customizada ou omitida?
Se retorno .T., o protheus n�o mostra
a tela padr�o.
Caso .F., mesmo retornando as informa��es
a tela ser� mostrada 	N�o
aRetCli[5]	caracter	Nome do Cliente	N�o
aRetCli[6]	caracter	Endere�o do cliente	N�o
aRetCli[7]	caracter	Placa do Carro ( somente se usa Template de Combust�veis )	N�o
aRetCli[8]	caracter	Quilometragem ( somente se usa Template de Combust�veis )	N�o
Fontes do Pacote:

LOJXFUND.PRW  25/10/2016 18:14:09
Pacote:	CH TVZDC3.zip

*/
User Function LjRetCli() //POnto de Entrada
	Local aRet := {"","",INNO_CPF,.T.,"","","",""}

	//[1] - C�digo do cliente
	//[2] - Loja do cliente
	//[3] - CPF/CNPJ
	//[4] - Logico, tela customizada no PE (se .T. n�o mostra a tela padr�o, se .F. mostra a tela padr�o)
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
Descri��o:
Esse ponto de entrada � chamado durante a gera��o da Carga.

Observa��es: Para substituir o conte�do de um campo na Carga do SBI, deve-se utilizar esse ponto de entrada para a manipula��o. 
Por exemplo, se existir um campo de descri��o resumida, com 23 caracteres, e se queira que esse conte�do entre no lugar da descri��o no SBI:

Programa Fonte
.PRW
Sintaxe
FRTGeraCar - Gera��o de carga ( ) --> aRet

Retorno
aRet(vetor)
Array com campos e conte�dos a serem substitu�dos.
*/

User Function _FrtGeraCar()
ConOut( "FrtGeraCar() =======================================: "+SB1->B1_COD+ "  "+SB1->B1_ORIGEM)
Return( {{ "BI_ORIGEM", "SB1->B1_ORIGEM"}})


/*
 

Descri��o:
Ponto de entrada - Tecla de atalho acess�vel a partir da op��o CTRL+T
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



