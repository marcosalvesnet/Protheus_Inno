/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ                 ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ    Template                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//#INCLUDE "PROTHEUS.CH"
//#INCLUDE "FRTDEF.CH"
//#INCLUDE "AUTODEF.CH"
//#INCLUDE "AdvCtrls.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.ch"

Static lProdFRT		//Flag indica se o produto esta sendo digitado na tela de venda do front
Static nValorDesc	//Valor de desconto a ser recurepado no PE F271EI02
Static nPercDesc 	//Percentual de desconto a ser recurepado no PE F271EI02
Static cVndCartao	//Ultimo cartao lido na venda atual
Static aVndItens	//Itens para impressao no ECF
Static aVndPgtos	//Formas de pagamento para tranpostar para o frontoloja
Static aVndReg		//Numero do registro da anterior da reimpressao do cupom fiscal
Static aNewProd		//Estrutura do array aNewProd
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
Static cCartaoAux   //Receber o ultimo carto digitado
Static lFlagVazio	//Flag que aponta que ja tem um cartao vazio digitado
Static aSinal := {}  //Array para para as informa็oes de pagamento de sinal
Static nVlrAcrescimo :=0  //Valor da Entrega
Static  nIFood :=2				// Opcao para tabela ede preco iFood =1

Static cPathSom:=GetSrvProfString("RootPath","")+"\SOM\"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณFR271AProdOK     ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para valida o dado digitado no get do      บฑฑ
ฑฑบ          ณdo produto cria a tela da pre-venda ou valida o produto     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FRTCODB1()  //Ponto de Entrada
	Local cCodProd		:= ParamIxb[1]		//Parametro do Ponto de entrada - codigo do produto
	Local aTmpProd		:= NIL 				//Arra de retorno do ponto de entrada cCodProd=Codigo do produto; Logico = .T. ou .F.; NIL
	Local cPDV			:= "   "
	Local aAreaSL1 		:= SL1->(GetArea())
	Local aAreaSBI 		:= SBI->(GetArea())

	Local cCartao		:=""

	Private cNumTer 	:= xNumCaixa()
	Private cAtend  	:= ""
	Private aFormPag	:={}
	Private lIfood		:=.F.

	Default cVndCartao	:=""	//Ultimo cartao lido na venda atual
	Default aVndItens	:={}	//Itens para impressao no ECF
	Default aVndPgtos	:={}	//Formas de pagamento para tranpostar para o frontoloja
	Default aVndReg		:={}	//Numero do registro da anterior da reimpressao do cupom fiscal

	aSinal				:={}
	nIFood				:=2				// Opcao para tabela ede preco iFood =1

	INNO_CLI			:= SuperGetMV("MV_CLIPAD")		//Codigo do Cliente padrao
	INNO_LOJ			:= cFilAnt						// Loja do cliente
	INNO_SALD			:= 0							// Saldo Disponivel para compra
	//INNO_IMP			:= GetPvProfString("FILIAL_"+cFilAnt, "IMPRESSAO"		, "", GetClientDir()+"INNO.INI")
	INNO_RIMP			:= .F.

	//Iniciliazar a variavel sempre que nao houver leitura de cartao
	If Len(aNewProd)=0
		INNO_CPF	:= Space(18)				// Variavel Static - CGC do cliente
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se o caro digitado e um pedido de concomenda TALAO + PEDIDO
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(Alltrim(cCodProd))==6
		//ณSalva os numeros de talao e pedido no array aSinal para pesquisa na hora da forma de pagamento
		aadd(aSinal,{Subs(Alltrim(cCodProd),1,3),Subs(Alltrim(cCodProd),4,3)})
		cCodProd:="0"+Subs(Alltrim(cCodProd),4,3)
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValidar se o codigo de produto digitado eh um cartao    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	/*
	If Subs(Alltrim(cCodProd),1,1)=="*"
		cCodProd :=Subs(Alltrim(cCodProd),2)
	EndIf
	cCartao:= Strzero(Val(Alltrim(cCodProd)),5)

	

	Strzero(Val(Alltrim(cCodProd)),5)
	*/
	If (Len(Alltrim(cCodProd))==4.And.Subs(Alltrim(cCodProd),1,1)=="0") .OR. ;
		(Len(Alltrim(cCodProd))==5.And.Subs(Alltrim(cCodProd),1,1)=="*") 
		cCartao	:=Subs(Alltrim(cCodProd),2)
		lProdFRT:= .F.	//Flag indica se o produto esta sendo digitado na tela de venda do front
		
		//Define flag para pedido Ifood
		If Subs(Alltrim(cCodProd),1,1)=="*"
			lIfood		:=.T.
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณNumero do registro anterior da reimpressao cupom fiscal ณ
		//ณVariavel publica criada em INNO_002.prw contem o Numero ณ
		//ณdo registro anterior da reimpressao cupom fiscal        ณ
		//ณsera recuperad no P.E. FRTEntreg-INNO_005.PRW           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aVndReg		:=0
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณArmazena o PDV apos a comuntacao                        ณ
		//ณVariavel publica criada em INNO_002.prw                 ณ
		//ณsera recuperad no P.E. FRTEntreg-INNO_005.PRW           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If cCartao=="000"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณTela com a lista das vendas do dia, com as legendas:   			ณ
			//ณVerde	- Vendas finalizadas no microterminql          			ณ
			//ณAmarelo	- Vendas em andamento no microterminal                 	ณ
			//ณVermelha	- Vendas concluida no caixa nao permite reeimpressao 	ณ
			//ณAzul     - Vendas concluida no caixa - Permite reeimpressao      ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !U_IA223LstVnd(@cCartao)

				SBI->(dbSeek(xFilial("SBI")+"00002")) 		//ZZ_FILIAL+ZZ_CARTAO
				Return {"00002"}
			EndIf

		ElseIf Subs(Alltrim(cCodProd),1,1)=="*"
			cCartao:=""
			nRet:=U_INNOA242(Subs(Alltrim(cCodProd),2))
			If nRet==1
				MsgInfo("Arquivo do Pedido Ifood nใo encontrado!!")
			else
				cCartao:="999"
			EndIf	
		EndIf
		dbSelectArea("SZX")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValidar o cartao e Bloquear para uso no microterminal   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If IA223VldCartao(cCartao)
			SZX->(RecLock("SZX",.F.))
			SZX->ZX_MICROT 	:= cNumTer			//Bloqueia o cartao para que o Microterminal nao possa usar
			cAtend			:= SZX->ZX_ATEND	//Vendedor/Atendente fixo (Andorinha)
			SZX->(MsUnLock())

			IF !EMPTY(SZX->ZX_TABELA)
				nIFood	:= If(Alltrim(SZX->ZX_TABELA)=="1",2,1)  //Definido a tabela de pre็o para Ifood
				// Habilitar impressใo para iFood
				If nIFood=1
					INNO_IMP[1]:= "I"
					INNO_IMP[2]:=""
				ENDIF
			ENDIF	

			cCartaoAux:=cCartao
			dbSelectArea("SZZ")
			dbSetOrder(1) 									//ZZ_FILIAL+ZZ_CARTAO
			SZZ->(dbSeek(xFilial("SZZ")+cCartao+"0")) 		//ZZ_FILIAL+ZZ_CARTAO
			aTmpProd:=IA233KitTela(cCartao,ZZ_MICROT,@cPdv) // Tela que apresenta os itens
		EndIf
		If aTmpProd == NIL
			aTmpProd:={"00002"}
		EndIf

	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณNao permitirar a venda diretamente na tela padrao do front
		//ณSempre devera digitar a comanda.						     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MsgInfo("Cartใo Invalido!!")
		aTmpProd:={"00002"}
	EndIf

	RestArea( aAreaSL1 )
	RestArea( aAreaSBI )
	SBI->(dbSeek(xFilial("SBI")+aTmpProd[1])) 		//ZZ_FILIAL+ZZ_CARTAO

Return aTmpProd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
CAIXAฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณFRTKIT           ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para immpressao dos itens na tela do Fronteบฑฑ
ฑฑบ          ณe impressao no ECF                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FRTKIT() //Ponto de Entrada
	Local cCodProd	:=ParamIxb[1]
	Local TmpQuant	:=ParamIxb[2]
	Local aItens	:={}
	Local nTotItens	:=Len(aNewProd)
	Local nI		:=0
	Local cAuxCart	:=""
	
	nVlrAcrescimo:= 0 //Valor da Taxa de entrega

	If !lProdFRT //se o produto foi digitado na tela de venda FRT tem que imprimir
		For nI:=1 to nTotItens
			If aNewProd[nI,11]<>"2"
				// Nao vai enviar o item Taxa de Entrega
				// Voltar o produto 198 - Taxa de entrega como item no cupom
				/*
				If  Alltrim(aNewProd[nI,3])=="00198"
					nVlrAcrescimo:=aNewProd[nI,5]*aNewProd[nI,7]
					Loop
				ENDIF
				*/
				aadd(aItens,{aNewProd[nI,3],aNewProd[nI,5]})
				aNewProd[nI,11]:="2"
				If !aNewProd[nI,1]$cAuxCart			//Armazenar uma string com o numero do cartoes
					cAuxCart+=", "+aNewProd[nI,1]
				EndIf
			EndIf
		Next nI
		If Len(aItens)=0 //Forcar um codifo que nao exista no cadastro para abandonar a area de venda Front
			aadd(aItens,{"XXXXXXXXXXXXX",0})
			aadd(aItens,{"XXXXXXXXXXXXX",0})
			U_IA223InitVar() //Inicializando as variaveis
		ElseIf Len(aItens)=1 //Forcar um codifo que nao exista no cadastro para abandonar a area de venda Front
			aadd(aItens,{"XXXXXXXXXXXXX",0})
		Else
			Conout("["+Dtoc(dDataBase)+" "+Time()+"]"+"INNO_223.PRW 001-Leitura Cartao"+cAuxCart)
		EndIf
	EndIf

Return aItens

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223VldCartao    ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o cartao digitado, apresenta msg na tela            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223VldCartao(cCartao)
	Local aTela
	Local cMsg	:=""
	Local lRet	:=.T.

	If !Empty(cCartao)
		SZX->(dbSetOrder(1))
		If  !SZX->(dbSeek(xFilial("SZX")+cCartao))
			cMsg	:="Cartao Invalido !"
			lRet	:=.F.
		ElseIf (nPos:= Ascan( aNewProd,{|X| X[1]==cCartao}))<>0 .OR.cCartaoAux==cCartao
			cMsg	:="Cartao jแ foi lido"
			lRet	:=.F.
		ElseIf !Empty(SZX->ZX_MICROT).And. SZX->ZX_MICROT <> cNumTer //**
			cMsg	:="Cartao aberto no MT - " + SZX->ZX_MICROT
			lRet	:=.F.
		ElseIf SZX->ZX_BLOQ == "1"
			cMsg	:="Cartao bloqueado !"
			lRet	:=.F.
		ElseIf Empty(SZX->ZX_MICROT).OR.SZX->ZX_MICROT==cNumTer
			dbSelectArea("SZZ")
			dbSetOrder(1) //ZZ_FILIAL+ZZ_CARTAO
			If !SZZ->(dbSeek(xFilial("SZZ")+cCartao+"0")).AND.Len(aNewProd)<>0  //ZZ_FILIAL+ZZ_CARTAO
				cMsg	:="Cartใo vazio !"
				lRet	:=.T.
			EndIf
		EndIf
		If !Empty(cMsg)
			IA223MsgCartao(cMsg,cCartao)
			cCartao	:= Space(3)
		EndIf
	EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223MsgCartao    ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณApresentar mensagens de validacao do cartoa                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223MsgCartao(cMsg,cCartao)
	Local oDlgErro
	Local oFntErro

	Tone(3000,1)
	DEFINE FONT oFntErro NAME "Arial" SIZE 6,14 BOLD
	DEFINE DIALOG oDlgErro FROM 0,0 TO 5, Len( cMsg ) + 8 ;
	STYLE nOr( DS_MODALFRAME, WS_POPUP ) TITLE "Aten็ใo"
	oDlgErro:SetFont(oFntErro)
	@  2,00 SAY xPadc(cMsg, oDlgErro:nRight - oDlgErro:nLeft) OF oDlgErro PIXEL
	@ 12,00 SAY xPadc(AllTrim(cCartao), oDlgErro:nRight - oDlgErro:nLeft) OF oDlgErro PIXEL
	@ 24,45 BUTTON "OK" SIZE 40,12 ACTION (oDlgErro:End()) OF oDlgErro PIXEL
	ACTIVATE MSDIALOG oDlgErro CENTERED

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA233KitTela      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณTela da Pre-venda                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA233KitTela(cCartao,cNumTer,cPdv)
	Local oDlgInno
	Local oDoc
	Local oHora 						// Objeto com o relogio exibido na tela
	Local oTimer						// Objeto de evento (de tempos em tempos o evento e ativado) do TIME do relogio.
	Local oPDV
	Local oTemp3
	Local oTemp4
	Local oTemp5
	Local oQuant
	Local oUnidade
	Local oTmpQuant
	Local oVlrUnit
	Local oVlrItem
	Local oTotItens
	Local oVlrTotal
	Local oFotoProd
	Local oDesconto
	Local oProduto
	Local oCodProd
	Local oCupom
	Local oLogoEmp
	Local oImpAuto
	Local oTemp1
	Local oTemp2											// Variaveis Para Utilizar Fundo Sem Transparencia
	Local oNomeCli		:= NIL
	Local cNomeCli		:= Posicione("SA1",1,xFilial("SA1")+INNO_CLI+INNO_LOJ,"A1_NOME")
	Local cCodProd 		:= Space(TAMSX3("BI_COD")[1]) //TAMSX3("BI_COD")[1]
	Local cCaixa		:= ""
	Local cProduto 		:= ""
	Local cUnidade 		:= ""
	Local cCupom 		:= ""
	Local cSimbCor  	:= AllTrim(SuperGetMV("MV_SIMB1"))
	Local cHora			:= ""					// Variavel com o conteudo do relogio
	Local cDoc 			:= ""
	Local nQuant 		:= 0
	Local nVlrUnit 		:= 0					// Variavel com o conteudo do valor unitario
	Local nVlrItem 		:= 0					// Variavel com o conteudo do valor do item
	Local nTotItens 	:= 0 					// Variavel com o conteudo do total dos itens
	Local nVlrTotal 	:= 0					// Variavel com o conteudo do valor total
	Local nVlrBruto		:= 0
	Local nVlrPercIT 	:= 0
	Local cMensagem  	:= "                Protheus - Innocencio"	// "   Protheus Front Loja"
	Local aCupom		:= {"","","","","","","","","","","","","","","","","",""}
	Local aKeyAux 		:= {}
	Local nMoedaCor  	:= 1
	Local uRet			:=NIL
	Local lF7			:= .F.				//Flag da tecla de funcao F7 Altera quantidade habilitada
	Local lF8			:= .F.				//Flag da tecla de funcao F8 Cancela iten - habilitada
	Local nPos			:=0
	Local nI			:=0
	Local lProdNew		:=.F.
	Local aCartao		:={}
	Local oCliente		:=NIL
	Local cCodCli		:=SuperGetMV("MV_CLIPAD")
	Local lCupomFocus	:=.F.
	Local lDin	:= .F.
	Local lVale	:= .F.
	
	Private oMedia 
	Private oFntCupom
	Private oFntInf
	Private oFntGet
	Private oFntQuant
	Private oFntTotal

	cDoc		:= Space(TamSX3("L1_DOC")[1])
	cHora		:= Left(Time(),5)
	cProduto	:= Space(TamSX3("BI_DESC")[1])
	nQuant		:= 1
	cUnidade	:= "UN"
	nVlrUnit	:= 0
	nVlrItem	:= 0
	nTotItens	:= Len(aNewProd)
	nVlrTotal	:= 0
	nVlrBruto	:= 0

	Default cPDV		:= "    "

	IFPegPDV(nHdlECF, @cPDV)
	SetKey(K_CTRL_F, {|| IA223Tab(oDlgInno)})	// Comuta para Tabela de Pre็o do iFood

	//COLOR CLR_WHITE,CLR_GRAY
	
	DEFINE MSDIALOG oDlgInno FROM 0,0 TO 458,795 PIXEL OF GetWndDefault() STYLE nOr(WS_VISIBLE, WS_POPUP) COLOR CLR_WHITE,CLR_BLUE //CLR_RED
	//COLOR CLR_WHITE,If(INNO_CLI<>"000001",_CLR_MAGENTA,_CLR_HRED)
	//COLOR CLR_WHITE,CLR_MAGENTA
	oMedia := TMediaPlayer():New()
	oMedia:lCanGotFocus:=.F.

	DEFINE FONT oFntCupom	NAME "Courier New"	   	SIZE 6,20 BOLD  	// Cupom Fiscal
	DEFINE FONT oFntInf		NAME "Arial" 			SIZE 8,16 BOLD		// Doc., Data, Hora, Loja, PDV
	DEFINE FONT oFntGet		NAME "Arial" 			SIZE 14,38			// Produto, Preco
	DEFINE FONT oFntQuant	NAME "Arial" 			SIZE 10,25			// Quant.
	DEFINE FONT oFntTotal	NAME "Arial" 			SIZE 19,60 BOLD		// Valor Total

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem da Tela ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// Espaco Reservado ao Logotipo da Empresa

	@ 169, 3 REPOSITORY oLogoEmp SIZE 70,70 PIXEL BORDER ADJUST OF oDlgInno
	ShowBitMap(oLogoEmp,"LOGOFRONT")

	@ 221, 78 MSGET oCodProd VAR cCodProd FONT oFntGet PIXEL SIZE 84,17 COLOR CLR_WHITE,CLR_BLACK ;
	PICTURE PesqPict("SBI","BI_COD",15) F3 "INNOFR" NOBORDER
	oCodProd:cSx1Hlp:="L2_PRODUTO" //IA223PesqProd

	// Foto do Produto
	@ 00, 3 REPOSITORY oFotoProd SIZE 158,167 PIXEL ADJUST BORDER OF oDlgInno

	oFotoProd:SetColor(GetSysColor(15),GetSysColor(15))
	oFotoProd:lStretch := .T.
	oFotoProd:lVisible := .T.
	ShowBitMap(oFotoProd,"LOJAWIN")


	@ 1, 165 LISTBOX oCupom VAR cCupom SIZE 234,164 PIXEL FONT oFntCupom	ITEMS aCupom OF oDlgInno COLOR CLR_BLUE,CLR_BLACK
	oCupom:bGotFocus 	:= {|| IA223Foto(oCupom,oFotoProd,1,@lCupomFocus,oCodProd),;
	SetKey(VK_F8	,{|| IA223F8CancItens(@oDlgInno,@oVlrTotal,@nVlrTotal,@nVlrBruto,;
	@oCupom,cCodProd,oCodProd,@uRet,@cPDV,@lF8,;
	@cCupom,@nTotItens)})}

	oCupom:bLostFocus	:= {|| If(lCupomFocus,IA223Foto(oCupom,oFotoProd,3,@lCupomFocus,oCodProd),),;
	oCupom:Select(Len(oCupom:aItems)),;
	oCupom:Refresh(),;
	oCodProd:SetFocus(),;
	SetKey(VK_F8, {||})}
	oCupom:bChange		:= {|| If(lCupomFocus,IA223Foto(oCupom,oFotoProd,2,@lCupomFocus,oCodProd),)} //
	oCupom:bRClicked  	:= {|| IA223Foto(oCupom,oFotoProd,6)}

	//Versao
	@ 168, 78 TO 215, 160 LABEL "v 1.7" PIXEL
	If ValType(INNO_V03)=="A".AND.INNO_V03[4]=="9" //p12
		@ 172, 151 BITMAP oImpAuto RESOURCE "print02"	PIXEL SIZE 16,16 NOBORDER OF oDlgInno
	EndIf
	@ 173,  82 SAY "Documento:"		PIXEL SIZE 30,8		// "Documento:"
	@ 181,  82 SAY "Data:" 			PIXEL SIZE 18,8		// "Data:"
	@ 189,  82 SAY "Hora:"			PIXEL SIZE 15,8		// "Hora:"
	@ 197,  82 SAY "Filial:"		PIXEL SIZE 22,8		// "Filial:"
	@ 197, 120 SAY "PDV:"			PIXEL SIZE 13,8		// "PDV:"
	@ 205,  82 SAY "Usuแrio:"		PIXEL SIZE 30,8		// "Usuแrio:"
	@ 173, 115 SAY oDoc VAR cDoc	PIXEL SIZE 35,8 FONT oFntInf

	@ 181, 100 SAY DToC(dDataBase)	PIXEL SIZE 50,8 FONT oFntInf
	@ 189, 100 SAY oHora VAR cHora	PIXEL SIZE 50,8 FONT oFntInf
	@ 197, 107 SAY cFilAnt			PIXEL SIZE 12,8 FONT oFntInf
	@ 197, 134 SAY oPDV VAR cPDV	PIXEL SIZE 25,8 FONT oFntInf
	//@ 197, 138 SAY "X"	    		PIXEL SIZE 13,8		// "PDV:"

	cCaixa := AllTrim(cUserName)+" - "+xNumCaixa()
	@ 205, 107 SAY cCaixa			PIXEL SIZE 52,8

	// Total Parcial
	@ 168, 165 TO 215, 397 LABEL "Total Parcial" PIXEL	// "Total Parcial"
	@ 173, 169 SAY "Numero de Itens:" PIXEL SIZE 42,8		// "Numero de Itens:"
	@ 173, 215 SAY oTotItens VAR nTotItens FONT oFntInf   PIXEL SIZE 20,33
	@ 173, 340 SAY "Desconto:" PIXEL SIZE 32,8		// "Desconto:"
	@ 173, 360 SAY oDesconto VAR nVlrPercIT FONT oFntInf  PIXEL RIGHT SIZE 32,8 PICTURE "@R 99.99%"
	@ 180, 167 SAY oTemp5 VAR cSimbCor FONT oFntInf PIXEL SIZE 15,33 COLOR CLR_WHITE,CLR_BLACK
	oTemp5:lTransparent := .F.
	@ 180, 182 SAY oVlrTotal VAR Transform(nVlrTotal,"@E 999,999,999.99");
	FONT oFntTotal PIXEL RIGHT SIZE 214,33 COLOR CLR_WHITE,CLR_BLACK
	oVlrTotal:lTransparent := .F.

	// Cliente
	@ 216,165 TO 240, 397 LABEL "Cliente" PIXEL	// "Quantidade x Preco"
	@ 221, 235 SAY oNomeCli VAR cNomeCli FONT oFntGet PIXEL SIZE 159,18 COLOR CLR_WHITE,CLR_BLACK
	oNomeCli:lTransparent := .F.
	@ 222,  166 MSGET oCliente   VAR cCodCli  FONT oFntGet F3 "FCL" VALID ExistCpo("SA1",cCodCli+INNO_LOJ).AND.IA223ConsSld(cCodCli,oDlgInno,oCliente,oNomeCli,@cNomeCli,oCodProd) PIXEL SIZE 49,15 COLOR CLR_WHITE,CLR_BLACK ;
	PICTURE PesqPictQt("L1_CLIENTE",7) NOBORDER
	oCliente:Disable()

	oCodProd:bLostFocus := {|| IA223GetProd(@cCartao,@oCupom,;
	@oQuant,@nQuant,;
	@oUnidade,@cUnidade,;
	@oVlrUnit,@nVlrUnit,;
	@oProduto,@cProduto,;
	@oTotItens,@nTotItens,;
	@oVlrTotal,@nVlrTotal,@nVlrBruto,;
	@oVlrItem,@nVlrItem,;
	@oDlgInno,@uRet,@cPDV,;
	@cCodProd,@oCodProd,;
	@lF7,@lF8,@lProdNew,oFotoProd,oCliente)}

	oCupom:SetArray(	{ 	"", "", "", "", ;
	"", "", "", "", ;
	"", "", "", "", ;
	"", "", "", "", ;
	"", "" }	)
	If ExistBlock("FRTCLICHE")
		aFRTCliche := ExecBlock("FRTCLICHE", .F., .F.,74)
		AEval(aFRTCliche, {|x| oCupom:Add(Left(x,74))})
	EndIf
	oCupom:Add("--------------------------------------------------------------------------")
	oCupom:Add("Data :"+DToC(dDatabase)+Space(46)+"Hora :"+Time())
	oCupom:Add("--------------------------------------------------------------------------")
	oCupom:Add(PADC("CARTรO DE CONSUMO",74))
	If lIfood
		oCupom:Add(PADC("PEDIDO IFOOD",74))
		oCupom:Add("PEDIDO  :"+SZZ->ZZ_PEDIDO+Space(42)+"MICROTERMINAL :"+cNumTer)
	else
		oCupom:Add(PADC("CARTรO DE CONSUMO",74))
		oCupom:Add("CARTรO  :"+If(Len(aNewProd)=0,cCartao,aNewProd[1,1])+Space(43)+"MICROTERMINAL :"+cNumTer)
	EndIf
	oCupom:Add("--------------------------------------------------------------------------")
	oCupom:Add("ITEM   CำDIGO           DESCRIวใO         QTD   UNIT.    ATEND.    VALOR  ")		// "ITEM   CำDIGO           DESCRIวใO       "
	oCupom:Add("--- ------------- --------------------- ------- ------ ---------- --------")
	oCupom:GoBottom()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Teclas de Atalho ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	//ACTIVATE MSDIALOG oDlgInno 	ON INIT 	(oDlgInno:nClrPane:=CLR_HRED,;
	//ACTIVATE MSDIALOG oDlgInno 	ON INIT 	(oDlgInno:nClrPane:=CLR_GREEN,;
	//ACTIVATE MSDIALOG oDlgInno 	ON INIT 	(oDlgInno:nClrPane:=If(niFood==1,CLR_HBLUE, If(INNO_IMP[1]== "I",CLR_HBLUE,CLR_HRED)),;
	//ACTIVATE MSDIALOG oDlgInno 	ON INIT 	(oDlgInno:nClrPane:=If(INNO_IMP[1]== "I",CLR_HBLUE,CLR_HRED),;
	//ACTIVATE MSDIALOG oDlgInno 	ON INIT 	(oDlgInno:nClrPane:=CLR_RED,;
	ACTIVATE MSDIALOG oDlgInno 	ON INIT 	(oDlgInno:nClrPane:=If(niFood==1,CLR_HRED, If(INNO_IMP[1]== "I",CLR_HBLUE,CLR_RED)),;
	IA223CargaTela(cCartao,@oCupom,;
	@oQuant,@nQuant,;
	@oUnidade,@cUnidade,;
	@oVlrUnit,@nVlrUnit,;
	@oProduto,@cProduto,;
	@oTotItens,@nTotItens,;
	@oVlrTotal,@nVlrTotal,@nVlrBruto,;
	@oVlrItem,@nVlrItem,;
	@oDlgInno,@uRet,@cPDV,;
	@cCodProd,@oCodProd,@lF7,NIL,oCliente),;
	oCodProd:SetFocus())
	SetKey(VK_F9 , {|| })		// Finaliza Venda
	SetKey(VK_F12, {|| })		// Carrega orcamento da lista
	SetKey(VK_F2, {|| })		// Carrega orcamento da lista

	If uRet==NIL   //Abandonando a tela de Orcamento ESC
		cAuxCart	:=""
		nTotItens	:=Len(aNewProd)
		aVndItens	:={}
		nDel		:=0	//Numero de registro excluido
		aCartao		:={}
		cCartaoAux  :=""	//Receber o ultimo carto digitado

		While nTotItens>nDel.AND.(nPos:=Ascan(aNewProd,{|X| ValType(X)=="A".And.x[11]<>"2"}))>0
			//Selecionando os cartoes para Desbloquear
			If cAuxCart<>aNewProd[nPos,1]
				aadd(aCartao,aNewProd[nPos,1])
				cAuxCart:=aNewProd[nPos,1] //Numero do cartao
			EndIf
			aDel(aNewProd,nPos)
			nDel++
			Loop
		End
		//Desbloquear os cartoes
		If Len(aCartao)=0.AND.!Empty(cCartao)
			aadd(aCartao,cCartao)
		EndIf
		U_I222TDCarttao(aCartao,"", ,nIfood)
		aSize(aNewProd,nTotItens-nDel)
		If cCartao=="000" //Excluir os registro do SZZ do cartao 000
			SZZ->(dbSeek(xFilial("SZZ")+cCartao+"0")) //ZZ_FILIAL+ZZ_CARTAO
			While SZZ->(!Eof()).And.SZZ->ZZ_FILIAL+SZZ->ZZ_CARTAO==xFilial("SZZ")+cCartao.AND.SZZ->ZZ_FLAG=="0"
				SZZ->(RecLock("SZZ", .F.))
				SZZ->(dbDelete())
				SZZ->(MsUnlock())
				SZZ->(dbSkip())
			End
		EndIf
		U_IA223InitVar() //Inicializando as variaveis
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVariavel Static cVndCartao contem  Numero do cartao     ณ
		//ณsera recuperad no P.E. FRTEntreg                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cVndCartao:=cCartao
		If Ascan( aNewProd,{|x| Empty(x[8]).OR.X[9]==.T.})<>0 //Verificar se o caixa digitou novos produtos OU cancelou item no cartao
			aNewProd:=aClone(U_I222Grv(aNewProd,nVlrTotal,.T.,nIfood)) //INNO_222.PRW
		EndIf
		//================================== FORMAS DE FINALIZACAO
		lSat:=.F.
		cImp:=""
		//ReImpressao ou CPF no cupom, ou Pagamento de Cartao - Registrar como SAT
		If INNO_RIMP.OR.!Empty(INNO_CPF).OR.Ascan( INNO_APGTOS,{|x| Alltrim(X[3])$INNO_SAT})<>0  //INNO_SAT="CC#CD#VA"
			lSat:=.T.
		EndIf
		If INNO_RIMP.OR.!Empty(INNO_CPF).OR.(!Empty(SA1->A1_COND).AND.Alltrim(SA1->A1_COND)=="002".AND.Ascan( INNO_APGTOS,{|x| "VALE INNOCENCI"$Alltrim(X[4])})<>0) //" VALE INNOCENCI"
			cImp:="I"
		EndIf	
		U_IA200Imp(cImp)

		If lSAT
			U_IA999SndKey("{f9}")		// CRTL+A - Forma de pagamento Dinheiro
			lDin	:= .F. // R$ chama a funcao somente 1 vez
			lVale	:= .F. // VA chama a funcao somente 1 vez
			For nI:=1 to Len(INNO_APGTOS)
				If !lDin.and. Alltrim(INNO_APGTOS[nI,3])=="R$"
					U_IA999SndKey("^a")		// CRTL+A - Forma de pagamento Dinheiro
					lDin := .T.
				ElseIf	Alltrim(INNO_APGTOS[nI,3])=="CC"
					If At("IFOOD",Alltrim(INNO_APGTOS[nI,4]))<>0
						U_IA999SndKey("^h")		// CRTL+H - Forma de pagamento IFOOD
					Else
						U_IA999SndKey("^c")		// CRTL+C - Forma de pagamento CARTAO CREDITO
					EndIf	
				ElseIf	Alltrim(INNO_APGTOS[nI,3])=="CD"
					U_IA999SndKey("^d")		// CRTL+D - Forma de pagamento CARTAO DEBITO
				ElseIf	!lVale .AND. Alltrim(INNO_APGTOS[nI,3])=="VA"
					U_IA999SndKey("^e")		// CRTL+E - Forma de pagamento VOUCHER
					lVale := .T.
				ElseIf	Alltrim(INNO_APGTOS[nI,3])=="CO"
					U_IA999SndKey("^f")		// CRTL+F - Forma de pagamento VALE INNOCENCIO
				ElseIf	Alltrim(INNO_APGTOS[nI,3])=="RA"
					U_IA999SndKey("^g")		// CRTL+G - Forma de pagamento SINAL ENCOMENDA
				ElseIf	Alltrim(INNO_APGTOS[nI,3])=="DC"
					U_IA999SndKey("^i")		// CRTL+P - Forma de pagamento PIX
				EndIf
			Next nI
			U_IA999SndKey('{F9}') //F9 - Finaliza a venda primeira camada
			INNO_Parc := {0,0,0}	// Contador de parcela TEF CC, CD, VA
		Else
			ConOut("Gravacao pela IA400GRV")
			Processa( { || U_IA400Grv(aNewProd, nValorDesc,nPercDesc)}, "Aguarde...","Processando Venda")
		EndIf
	EndIf

Return uRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223CargaTela    ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os itens do cartao na tela da pre-venda             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223CargaTela(cCartao,oCupom,;
	oQuant,nQuant,;
	oUnidade,cUnidade,;
	oVlrUnit,nVlrUnit,;
	oProduto,cProduto,;
	oTotItens,nTotItens,;
	oVlrTotal,nVlrTotal,nVlrBruto,;
	oVlrItem, nVlrItem,;
	oDlgInno,uRet,cPDV,;
	cCodProd,oCodProd,lF7,;
	nInic,oCliente)
	Local nReg		:=0
	Local lRet		:= .T.
	Local cAuxCart	:=cCartao
	Local nPos		:=1
	Default nInic:=1

	dbSelectArea("SZZ")
	dbSetOrder(1) //ZZ_FILIAL+ZZ_CARTAO
	If (nPos:= Ascan( aNewProd,{|X| X[1]==cCartao}))==0
		dbSelectArea("SZZ")
		dbSetOrder(1) //ZZ_FILIAL+ZZ_CARTAO
		SZZ->(dbSeek(xFilial("SZZ")+cCartao+"0")) //ZZ_FILIAL+ZZ_CARTAO
		While SZZ->ZZ_FILIAL+SZZ->ZZ_CARTAO==xFilial("SZZ")+cCartao.AND.SZZ->ZZ_FLAG=="0"
			//Atualizando o Array de vendas do Cartao
			aadd(aNewProd,{	SZZ->ZZ_CARTAO		,;		// 1-NUmero do cartao
			SZZ->ZZ_VEND		,;		// 2-Atendente
			SZZ->ZZ_PRODUTO		,;		// 3-Codigo do Produto
			SZZ->ZZ_DESCRI		,;		// 4-Descricao do produto
			SZZ->ZZ_QUANT		,;		// 5-Quantidade
			SZZ->ZZ_UM			,;		// 6-Unidade de Medida
			SZZ->ZZ_VLRITEM		,;		// 7-Preco unitario
			SZZ->(recno())		,;		// 8-Numero do registro no SZZ (quando salvo)
			.F.					,;		// 9-Flag para indicar se o registro esta deletado
			++nTotItens			,;		// 10- Numero do Item
			"0"})						// 11-Flag Indica se produto ja foi impresso no ECF
			SZZ->(dbSkip())
		End
	EndIf
	nTotItens:=Len(aNewProd)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณITEM   CำDIGO           DESCRIวใO         QTD   UNIT.    ATEND.    VALOR   "ณ
	//ณ"--- ------------- --------------------- ------- ------ ---------- --------"ณ
	//ณ"001 9999999999999 AAAAAAAAAAAAAAAAAAAAA 999.999 999,99 BBBBBBBBBB 99999,99"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nPos:=If(nInic-1<1,1,nInic-1)
	cAuxCart:=If(Len(aNewProd)>0,aNewProd[nPos,1],cCartao)
	For nI:= nInic to nTotItens

		If aNewProd[nI,11]<>"1"  //0=Gravado no aNewProd;1=Impresso na tela Pre-venda ;2=Impresso no ECF
			If aNewProd[nI,1]<>cAuxCart
				cAuxCart:=aNewProd[nI,1]
				oCupom:Add("----------------------------- Cartใo "+cAuxCart+" ---------------------------------")
			EndIf
			oCupom:Add(StrZero(aNewProd[nI,10],3)+" "+;			//Numero do Item
			Left(aNewProd[nI,3],13)+" "+;				//Codigo do Produto
			Left(aNewProd[nI,4],21)+" "+;				//Descricao
			Trans(aNewProd[nI,5],If(aNewProd[nI,6]=="KG","@E 999.999","@E 9999999"))+" "+;		//Quantidade
			Trans(aNewProd[nI,7],"@E 999.99")+" "+;	//Valor Unitario
			Left(Posicione("SA3",1,xFilial("SA3")+aNewProd[nI,2],"A3_NOME"),10)+" "+;	//Atendente
			Trans(Round(aNewProd[nI,5]*aNewProd[nI,7],2),"@E 9,999.99") )			//Valor total
			nVlrTotal+= Round(aNewProd[nI,5]*aNewProd[nI,7],2)
			oCupom:GoBottom()
			nQuant			:=aNewProd[nI,5]
			cUnidade		:=aNewProd[nI,6]
			nVlrUnit		:=aNewProd[nI,7]
			cProduto		:=Left(aNewProd[nI,4],21)
			nVlrItem		:=Round(aNewProd[nI,5]*aNewProd[nI,7],2)
			cCodProd		:=aNewProd[nI,3]
			aNewProd[nI,11]	:=If(aNewProd[nI,11]=="0","1",aNewProd[nI,11]) //1=Ja foi apresentado na tela
		EndIf
	Next nI

	oCupom:Refresh()
	oTotItens:Refresh()
	oVlrTotal:Refresh()
	
	SetKey(VK_F9, {|| IA223F9Pgto(cCartao,@oDlgInno,@oVlrTotal,@nVlrTotal,@nVlrBruto,@oCupom,cCodProd,oCodProd,@uRet,@cPDV)})		//Subtotal e formas de pagamentos
	SetKey(VK_F10, {|| IA223AltCli(oDlgInno,oCliente)})									//Alterar o cliente
	SetKey(VK_F11, {|| Ia223F11Grv(cCartao,@oDlgInno,@nVlrTotal)})		//Grava o orcamanto

	cCodProd := Space(TAMSX3("BI_COD")[1]) //TAMSX3("BI_COD")[1]
	nQuant:=1

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223F9Pgto       ณAutor  ณMarcos Alves   บ Data ณ14/08/2010 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF9 - Subtotal e formas de pagamento                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223F9Pgto(cCartao,oDlgInno,oVlrTotal,nVlrTotal,nVlrBruto,oCupom,cCodProd,oCodProd,uRet,cPDV)
	Local oFimVenda
	Local oPgtos
	Local lRet			:=.F.
	Local aPgtos		:={}
	Local lEnable		:=.T.
	Local nOpc			:=NIL
	Local nVlrMercAux	:=0
	Local nPerc			:=0
	//**
	Local cSimbCor  	:= AllTrim(SuperGetMV("MV_SIMB1"))
	Local oTemp4
	Local oVlrPagar

	Private nVlrPagar	:= nVlrTotal	//Valor a pagar substraindo os valore ja digitado nas parcelas
	Private aPosCli		:= {}			// Posicao do Cliente

	Private oVlrPago
	Private nVlrPago	:=0

	//MsgInfo("Fa็a a leitura dos Itens para o Cliente!!!!")

	nValorDesc			:=0	//Variavel Static para ser recuperada pelo PE F271EI02
	nPercDesc			:=0

	nVlrBruto			:= nVlrTotal

	SetKey(VK_F9, {|| lRet:=IA223F9FimVnd(cCartao,oDlgInno,cCodProd,@uRet,oFimVenda,@cPDV,aPgtos,nVlrTotal,@nVlrBruto)})		// F9 - Finalizar a venda
	SetKey(VK_F6, {|| lRet:=IA223DescTot(oVlrTotal,@nVlrTotal,@nValorDesc,oCupom)})														// F6 - Desconto no total da venda
	oCupom:Add("                                        ----------------------------------")
	oCupom:Add("                                        S U B T O T A L      "+Trans(nVlrTotal,PesqPict("SL2", "L2_VLRITEM", 13,1)))  //"     S U B T O T A L      "
	oCupom:Refresh()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRecuprando a forma de pagamento da venda  ณ
	//ณpara reimpressao                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If INNO_RIMP //reImpressao no SAT verifica se teve desconto
		nPercDesc	:= SL1->L1_DESCNF
		nValorDesc 	:= SL1->L1_DESCONT
		If nValorDesc>0
			nVlrTotal-=nValorDesc
			nVlrPagar-=nValorDesc
			oCupom:Add("                                        ----------------------------------")
			oCupom:Add(PadL("Desconto no total do cupom",74))	// "Desconto no total do cupom"
			oCupom:Add(PadL("Valor / Percentual",74))	// "Valor / Percentual"
			oCupom:GoBottom()
			oCupom:Add(PadL(Trans(nValorDesc,PesqPict("SL1","L1_VLRTOT",10,1))+" / "+Trans(nPercDesc,"@E 99.99")+"%",74))
			oCupom:Add("                                        ----------------------------------")
			oCupom:GoBottom()
			oVlrTotal:Refresh()
		EndIf
	ENDIF
	
	aParcelas:={}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ 25/03/15 - Verificar saldo disponivel do cliente para processeguir com a venda ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SA1->A1_COD="000001".OR.(SA1->A1_LC>0.AND.INNO_SALD>0)
		If SA1->A1_DESC>0
			//SetKey(VK_F6, {||})	  	// Desativar F6 - Desconto no total da venda
			nValorDesc	:=0
			nPercDesc	:=SA1->A1_DESC
			nValorDesc 	:= Fr271IAtuValor( nPerc, nPercDesc, nVlrTotal, nValorDesc)
			If nValorDesc>0
				nVlrTotal-=nValorDesc
				nVlrPagar-=nValorDesc
				oCupom:Add("                                        ----------------------------------")
				oCupom:Add(PadL("Desconto no total do cupom",74))	// "Desconto no total do cupom"
				oCupom:Add(PadL("Valor / Percentual",74))	// "Valor / Percentual"
				oCupom:GoBottom()
				oCupom:Add(PadL(Trans(nValorDesc,PesqPict("SL1","L1_VLRTOT",10,1))+" / "+Trans(nPercDesc,"@E 99.99")+"%",74))
				oCupom:Add("                                        ----------------------------------")
				oCupom:GoBottom()
				oVlrTotal:Refresh()
			EndIf
		EndIf
		If SA1->A1_COD<>"000001".AND.INNO_SALD<nVlrTotal
			Aviso( "Aten็ใo", " Saldo Disponivel:"+Transform(INNO_SALD,PesqPict("SA1", "A1_LC",10,1))+chr(10)+chr(13)+"Total da Compra: "+Transform(nVlrTotal,PesqPict("SA1", "A1_LC",10,1)), { "Ok" }, 2,"Saldo Insuficiente.")
			SetKey(VK_F9, {|| IA223F9Pgto(cCartao,@oDlgInno,@oVlrTotal,@nVlrTotal,@nVlrBruto,@oCupom,cCodProd,oCodProd,@uRet,@cPDV)})		//Subtotal e formas de pagamentos
			Return .T.
		EndIf
	Endif
	If cCartao=="000"
		SL1->(DbGoto(aVndReg))
		SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
		While SL4->(!Eof()).and.xFilial("SL4")==SL4->L4_FILIAL.AND.SL4->L4_NUM==SL1->L1_NUM
			AAdd(aPgtos,	{SL4->L4_DATA	,;			// 01-Data
			SL4->L4_VALOR	,;			// 02-Valor
			AllTRim(SL4->L4_FORMA),;	// 03-Forma
			SL4->L4_ADMINIS	,;			// 04-Administradora
			" ",;						// 05-Num Cartao
			" ",;						// 06-Agencia
			" ",;						// 07-Conta
			If (!Empty(SL4->L4_DOC),SL4->L4_DOC,""),;						// 08-RG
			" ",;						// 09-Telefone
			.F.,;						// 10-Terceiro
			1,;							// 11-Moeda
			"1",;						// 12-Digitos do cartao para TEFMULT
			0 } )						// 13-Conceito de acrescimo financeiro separado

			SL4->(dbSkip())
		End
		lEnable		:= Len(aPgtos)=0
	EndIf
	//Verifica se tem pagamento de sinal ---------------------------------------------------
	If Len(aSinal)<>0
		aPgtos:={}
		SZT->(dbSetOrder(1))
		For nZ:=1 to Len(aSinal)
			If SZT->(dbSeek(xFilial("SZT")+aSinal[nZ,1]+aSinal[nZ,2])).AND.Empty(SZT->ZT_NUM)
				SZS->(dbSeek(xFilial("SZS")+aSinal[nZ,1]+aSinal[nZ,2]))
				While !SZS->(Eof()).and. (xFilial("SZS")+aSinal[nZ,1]+aSinal[nZ,2])==(SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO)
					AAdd(aPgtos,	{SZS->ZS_DATA	,;			// 01-Data
					SZS->ZS_VALOR	,;			// 02-Valor
					AllTRim(SZS->ZS_FORMA),;	// 03-Forma
					SZS->ZS_ADMINIS	,;			// 04-Administradora
					" ",;						// 05-Num Cartao
					"",;						// 06-Agencia
					"",;						// 07-Conta
					" ",;						// 08-RG
					" ",;						// 09-Telefone
					.F.,;						// 10-Terceiro
					1,;						// 11-Moeda
					"1",;						// 12-Digitos do cartao para TEFMULT
					0 } )						// 13-Conceito de acrescimo financeiro separado
					nVlrPagar-=SZS->ZS_VALOR
					SZS->(dbSkip())
				End
			EndIf
		Next nZ
		If Len(aPgtos)<>0
			MsgInfo("Identificado SINAL ENCOMENDA para este(s) pedido(s)")
		EndIf
	EndIf
	//Verifica se e iFood
	If lIfood
		aPgtos:={}
		//nPos:= Ascan( aFormPag,{|x| Trim(x[1]) =="IFOOD"})
		cAdm:="030 - IFOOD         "

		AAdd(aPgtos,	{dDataBase	,;			// 01-Data
						nVlrPagar	,;			// 02-Valor
						"CC"		,;			// 03-Forma
						cAdm		,;			// 04-Administradora
						" "			,;			// 05-Num Cartao
						" "			,;			// 06-Agencia
						" "			,;			// 07-Conta
						""			,;			// 08-RG
						" "			,;			// 09-Telefone
						.F.			,;			// 10-Terceiro
						1			,;			// 11-Moeda
						"1"			,;			// 12-Digitos do cartao para TEFMULT
						0 } 		)			// 13-Conceito de acrescimo financeiro separado
	EndIf
	
	//Fim da verificacao de pagamento de SINAL

	DEFINE MSDIALOG oFimVenda FROM 00,0 TO 305,320 PIXEL OF GetWndDefault() STYLE nOr(WS_VISIBLE, WS_POPUP) //COLOR CLR_WHITE,CLR_BLACK

	//oFimVenda:nClrPane:=CLR_HRED

	//----------------Resta pagar
	@ 135,  3 TO 163, 78 LABEL "Resta" PIXEL	// "Pago"

	@ 142,05 SAY oVlrPagar VAR Transform(nVlrPagar,"@E 9,999.99") ;
	FONT oFntGet PIXEL RIGHT SIZE 68,18 COLOR CLR_WHITE,CLR_HRED //CLR_BLACK
	oVlrPagar:lTransparent := .F.

	@ 142,  05 SAY oTemp4 VAR cSimbCor FONT oFntInf PIXEL SIZE 15,18 COLOR CLR_WHITE,CLR_HRED
	oTemp4:lTransparent := .F.

	//----------------Pagamento Efetuado
	@ 135,  85 TO 163, 160 LABEL "Pago" PIXEL	// "Pago"
	@ 142,87 SAY oVlrPago VAR Transform(nVlrPago,"@E 9,999.99");
	FONT oFntGet PIXEL RIGHT SIZE 68,18 COLOR CLR_WHITE,CLR_BLACK
	oVlrPago:lTransparent := .F.

	@ 142,  87 SAY oTemp4 VAR cSimbCor FONT oFntInf PIXEL SIZE 15,18 COLOR CLR_WHITE,CLR_BLACK
	oTemp4:lTransparent := .F.

	oPgtos:=TCBrowse():New(3, 3, 157, 130,,,,,,,,,{|nRow,nCol,nFlags|IA223F9Get(nRow,nCol,nFlags,oPgtos),oPgtos:Refresh()},,,,,,, .F.,, .T.,, .F., )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Estrutura do array aPgtos                                    ณ
	//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
	//ณ [1] - Forma de Pagamento                                     ณ
	//ณ [2] - Qtde de Parcelas da forma de pagto                     ณ
	//ณ [3] - Valor total desta forma de pagamento                   ณ
	//| [4] - Sequencia para controle de m๚ltiplas transa็๕ies		 |
	//ณ [5] - Data da primeira parcela                               ณ
	//ณ [6] - Codigo da Administradora financeira                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPgtos:SetArray(aPgtos)
	oPgtos:AddColumn(TCColumn():New("Data"		, {|| If(Len(aPgtos)>=oPgtos:nAt,aPgtos[oPgtos:nAt,1],'')} ,,,, "LEFT" , 25, .F., .F.,,,, .F., ) )  //"Data"
	oPgtos:AddColumn(TCColumn():New("Forma"		, {|| If(Len(aPgtos)>=oPgtos:nAt,aPgtos[oPgtos:nAt,3],'')} ,,,, "LEFT" , 20, .F., .F.,,,, .F., ) )  //"Forma"
	oPgtos:AddColumn(TCColumn():New("Valor"		, {|| If(Len(aPgtos)>=oPgtos:nAt,Transform(aPgtos[oPgtos:nAt,2],PesqPict("SL1","L1_VLRTOT",15)),'')} ,,,, "RIGHT", 50, .F., .F.,,,, .F., ) )  //"Valor"
	oPgtos:AddColumn(TCColumn():New("Parcelas"	, {|| If(Len(aPgtos)>=oPgtos:nAt,aPgtos[oPgtos:nAt,12],'')} ,,,, "RIGHT", If(lUsaTef .AND. lTefMult,25,55) , .F., .F.,,,, .F., ) )  //"Parcelas"

	oPgtos:bLDblClick := {|| .t.}

	//oPgtos:nClrPane:= CLR_HRED
	//oPgtos:nClrText := CLR_HRED

	// Evita erro ao pressionar a tecla <Enter> e o array aPgtos estiver com conte๚do nulo...
	If Empty(aPgtos).Or.!lEnable
		oPgtos:Disable()
	Else
		oPgtos:SetFocus()
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFeita a insercao de um objeto habilitado para permitir os Ctrl'sณ
	//ณno final da venda. Solucao temporaria para P10 deve ser         ณ
	//ณtratada a causa pela Tecnologia.                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE SBUTTON FROM 1000, 1000 oButtonz TYPE 1 ENABLE OF oFimVenda
	ACTIVATE MSDIALOG oFimVenda ON INIT ( If(lEnable,IA223SetKey(oPgtos,aPgtos),.T.))

	If lRet
		INNO_APGTOS:=aClone(aPgtos)
		oDlgInno:End()  // Coloca 2 F9 no Buffer do teclado para a tela padrao.
	Else   // Saindo da tela de pagamento atraves do ESC
		SetKey(VK_F9, {|| IA223F9Pgto(cCartao,@oDlgInno,oVlrTotal,@nVlrTotal,@nVlrBruto,oCupom,cCodProd,oCodProd,@uRet,@cPDV)}) //Restaura a tecla F9 para formas de pagamento
		SetKey(VK_F6, {|| }) 	//Desativa a tecla de desconto
		IA223SetKey(,,.F.)		//Desabilitar as teclas de formas de pagamento
		oCodProd:SetFocus()
		nVlrTotal+=nValorDesc
		nVlrPagar+=nValorDesc
		If nValorDesc>0
			aSize(oCupom:aItems,Len(oCupom:aItems)-5)
			oCupom:SetArray(oCupom:aItems)
		EndIf
		oCupom:GoBottom()
		oVlrTotal:Refresh()
		nValorDesc:=0
		nPercDesc :=0
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223F9Get     ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณGet da forma de pagamento (nao usada)                       บฑฑ
ฑฑบ          ณReavaliar o fonte                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223F9Get(nRow,nCol,nFlags,oPgtos)
	Local lRet	:=.T.

	//lEditCell(@aMoedas,oPgtos,PesqPict("SL1","L1_TROCO1",TamSx3("L1_TROCO1")[1],oLBBaixa:nAT),3)
	//lEditCell(aCampos,oBrowse,cPict,nCol,cF3,lReadOnly,bValid,aItems)
	aCampos:={}
	aadd(aCampos,{"M->CELL01",0})

	lEditCell(aCampos,oPgtos,"@!",3)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223FPgto        ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณTela das formas de pagamento                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IA223FPgto(oPgtos,aPgtos,cForma,cDesc)
	Local oFormPag
	Local oData
	Local oNumParc
	Local oValor
	Local oFont
	Local oCart															//Objeto que armazena o ID cartao
	Local oDifCart                           // Identifica se o cliente utiliza o mesmo carใo para todas as parcelas de uma determinada ADM
	Local nLinha		:= 35											// Controle de posicionamento dos objetos na tela
	Local nColuna		:= 0
	Local lVisuSint 	:= If(SL4->(FieldPos("L4_FORMAID"))>0,.T.,.F.)	//Indica se a interface utilizarแ a forma de visualiza็ใo sintetizada ou a antiga, evitando problemas com a metodologia anterior
	Local cDescParcelas := ""
	Local nFormaId  	:= 1
	Local nPos			:= 1
	Local cAdm			:= ""
	Local nValor		:=nVlrPagar
	Local dData			:=dDatabase
	Local nOpc			:=2

	//Variavei da funcao
	Local lUsaTef		:=.f.
	Local lTefMult		:=.f.
	Local aMoeda		:={}
	Local lUsaAdm		:=.t.
	Local lRecebe		:=.f.
	Local cFormaId		:="1"
	Local nNumParc		:=1
	Local nTXJuros		:=0
	Local nIntervalo	:=30
	Local cMoedaVen		:=NIL
	Local nPosMoeda		:=1
	Local cSimbMoeda	:=NIL
	Local lDifCart		:=.F.
	Local aMultMoeda	:={}
	Local nPos			:=0
	Local lValor		:= .T.
	Local aParcelas		:= {}
	LOcal CodAdm		:= "   "

	If Type("oVlrPago")="U"
		oVlrPago:="" 	//Valor total pago na tela de venda
	EndIf

	//Evitar execucao recursiva atraves das chamadas de teclas CTRL+ A, C, D
	If ProcName(3)=="U_IA223FPGTO"
		Return .T.
	EndIf

	If nVlrPagar=0
		HELP(' ',1,'FRT032') //Nao pode incluir novas formas de pagamentos.
		Return(.T.)
	EndIf

	//15/03/15 - Nao permitir a forma de pagamento CO vale innocencio se nao tiver no cadastro de cliente
	If cForma=="CO"   // CTRl + I
		If Empty(SA1->A1_COND)
			MsgInfo("Forma de pagamento Invalida!")
			Return(.T.)
		Else
			cCondicao:= Alltrim(SA1->A1_COND)
			DbSelectArea("SE4")
			DbSetOrder(1)
			DbSeek(xFilial("SE4") + cCondicao)

			nPos := Ascan( aFormPag,{|x| At("VALE INNOCENCIO",AllTrim(x[1]))})
			CodAdm:= Subs(aFormPag[nPos,5],1,3)

			DbSelectArea("SAE")
			DbSetOrder(1)
			DbSeek(xFilial("SAE") + CodAdm)

			aParcelas 	:= Condicao( nVlrPagar, cCondicao)
			dData		:= aParcelas[1,1]
			nValor		:= aParcelas[1,2]
			nNumParc	:= 1
			lValor		:= .F.
		EndIf
	EndIf
	/****
	//Verifica se algun cartao ja foi impresso aNewProds[?,1]
	//aNewpro[?,11] - 0=Gravado no aNewProd;1=Impresso na tela Pre-venda ;2=Impresso no ECF/ INNO_PDV = Varial publica (INNO_002) contem o numero do Emulador
	If (nPos:=Ascan(aNewProd,{|X| X[11]=="2"}))>0.AND.cVndPDV==INNO_PDV.AND.cForma<>"R$"
	MsgInfo("Forma de pagamento invalida!!, cartใo "+aNewProd[nPos,1]+" no "+INNO_PDV)
	Return(.T.)
	EndIf
	*******************/
	If(lUsaTef .AND. lTefMult)			// Tamanho da Dialog
		nColuna := 20
	Endif
	cDescParcelas  	:= If(cForma="VA","Quantidade de Vales","Parcelas")

	If cForma=="R$"
		uRet :=  IA223FTroco(	GetWndDefault()	, .T., 0, @nValor,0, 0)
		If ValType(uRet) == "L"
			If !uRet
				nValor:=0
			EndIf
		Else
			nTroco	:= uRet
			nOpc	:=1
		EndIf
	Else
		DEFINE MSDIALOG oFormPag FROM 1,1 TO 240+nColuna,260 TITLE "Forma de Pagamento" PIXEL OF GetWndDefault()	// "Forma de Pagamento"
		DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -9 BOLD
		@ 07, 10 SAY cForma +  Iif( lUsaAdm, " - " + cDesc, " " ) SIZE 110,10 FONT oFont COLOR CLR_BLUE,CLR_WHITE OF oFormPag PIXEL
		@ 20, 10 SAY "Data" SIZE 50,10 OF oFormPag PIXEL	//"Data"
		@ 20, 70 MSGET oData VAR dData	SIZE 50,10 OF oFormPag PIXEL WHEN  .F. Valid dData >= dDataBase .AND. !Empty(dData)
		oData:cSx1Hlp:="L4_DATA"

		If Alltrim(cForma)$"CC;CD" .AND. lVisuSint .AND. lUsaTef .AND. lTefMult
			@ nLinha, 10  Say "ID Cartใo" SIZE 55,15 OF oFormPag PIXEL	//"ID Cartใo"
			@ nLinha, 70  MSGET oCart VAR cFormaId RIGHT SIZE 15,10 PICTURE PesqPict("SL4","L4_FORMAID") OF oFormPag PIXEL
			//;   		     VALID Fr271IIDValid(cForma,@cFormaId, @aPgtos)
			nLinha += 15
		EndIf

		If !IsMoney(cForma)
			@ nLinha, 10 SAY cDescParcelas	SIZE 55,15 OF oFormPag PIXEL
			@ nLinha, 70 MSGET oNumParc		VAR nNumParc	PICTURE "@E 999" SIZE 50,10 OF oFormPag PIXEL WHEN .F. VALID nNumParc > 0
			nLinha += 15
			oNumParc:cSx1Hlp:="L1_PARCELA"
		EndIf
		@ nLinha, 10 SAY "Valor" SIZE 50,10 OF oFormPag PIXEL	// "Valor"
		@ nLinha, 70 MSGET oValor		VAR nValor	   	PICTURE "999999999.99" SIZE 50,10 OF oFormPag PIXEL ;
		VALID (nValor >=0.AND.nValor <=nVlrPagar) WHEN lValor

		nLinha += 15
		oValor:cSx1Hlp:="L4_VALOR"
		// Determina se irแ ter que digitar os dํgitos do cartใo para m๚ltiplas transa็๕es TEF
		If !lVisuSint .AND. lUsaTef .AND. lTefMult
			@ nLinha, 10 CHECKBOX oDifCart VAR lDifCart PROMPT "Parcelar com diferentes cart๕es da ADM" ; //"Parcelar com diferentes cart๕es da ADM"
			SIZE 120,07 OF oDifCart PIXEL WHEN (nNumParc>1 .AND. cForma $ "CC;CD" )
			nLinha += 15
		EndIf

		DEFINE SBUTTON FROM nLinha+5,63 TYPE 1 ENABLE ACTION ( nOpc:=1,oFormPag:End()) OF oFormPag
		DEFINE SBUTTON FROM nLinha+5,93 TYPE 2 ENABLE ACTION ( oFormPag:End()) OF oFormPag

		ACTIVATE MSDIALOG oFormPag CENTER
	EndIf

	If nOpc==1
		nVlrPagar-=nValor
		If !IsMoney(cForma).OR.cForma=="CH"
			nPos:= Ascan( aFormPag,{|x| Trim(x[1]) ==cDesc})
			cAdm:=aFormPag[nPos,5]
		EndIf
		AAdd(aPgtos,	{dData		,;			// 01-Data
		nValor		,;			// 02-Valor
		cForma		,;			// 03-Forma
		cAdm		,;			// 04-Administradora
		" ",;					// 05-Num Cartao
		" ",;					// 06-Agencia
		" ",;					// 07-Conta
		" ",;					// 08-RG
		" ",;					// 09-Telefone
		.F.,;					// 10-Terceiro
		1,;					// 11-Moeda
		"1",;					// 12-Digitos do cartao para TEFMULT
		0 } )					// 13-Conceito de acrescimo financeiro separado
	EndIf
	If Valtype(oPgtos)=="O"
		oPgtos:SetArray(aPgtos)
		If !Empty(aPgtos)
			oPgtos:Enable()
			oPgtos:SetFocus()
		Else
			oPgtos:Disable()
			oPgtos:SetFocus()
		EndIf
		oPgtos:Refresh()
	EndIf
	If Valtype(oVlrPago)=="O"
		nVlrPago	:=0
		AEval(aPgtos, {|x| nVlrPago+=X[2]})
		oVlrPago:Refresh()
	EndIf
Return( .T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223FTroco       ณAutor  ณMarcos Alves   บ Data ณAbr/2012   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณCalcula troco                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223FTroco( oDlgRapid	, lDinheiro	, nDinMoedaCor	, nDinheiro	,;
	nVales		, nTroco)
	Local nValor := 0.00
	Local nPagar := 0.00
	Local lRet := .F.
	Local nVlrPag := 0
	Local oFonte
	Local oDlgTroco
	Local oButton2
	Local oButton1
	Local oPago
	Local oPagar
	Local oSay
	Local oSay_2
	Local uRet
	Local lValget :=.F.
	Local lTouch	:= If( LJGetStation("TIPTELA") == "2", .T., .F. )
	Local bVK_7 := SetKey(VK_F7)

	SetKey(VK_F7, {|| IA223TEditVal(@lValget,oPagar)})

	If cPaisLoc <> "BRA" .AND. Type("nDinMoedaCor") == "N"
		nDinheiro  := nDinMoedaCor
	EndIf

	//Verifico se  dinheiro ou vale
	If lDinheiro
		nPagar:= nDinheiro
	Else
		nPagar:= nVales
	EndIf

	If lUsaDisplay
		DisplayEnv(StatDisplay(), "1C"  + Upper( "Confira o valor pago e" ) )         //"Confira o valor pago e"
		DisplayEnv(StatDisplay(), "2C"  + Upper( "PRESSIONE <ENTER>  P/ FECHAR A VENDA" ) )  //"PRESSIONE <ENTER>  P/ FECHAR A VENDA"
	EndIf

	// Troco ao Consumidor
	DEFINE MSDIALOG oDlgTroco FROM  47,130 TO 300,400 TITLE "Troco ao Consumidor" PIXEL OF oDlgRapid
	DEFINE FONT oFonte	NAME "TIMES NEW ROMAN" SIZE 12.5,20 Bold

	@ 05, 04 TO 31,130 LABEL "Valor pago pelo cliente" OF oDlgTroco	PIXEL //"Valor pago pelo cliente"
	@ 13, 07 MSGET oPago VAR nVlrPag PICTURE PesqPict("SL1","L1_VLRTOT") SIZE 120,14 FONT oFonte PIXEL;
	OF oDlgTroco  VALID IA223UpTroco( @nVlrPag, @nDinheiro, @nPagar, @oPagar,@nValor, @oSay)

	// Valor a Pagar
	@ 43, 04 TO 69,130 LABEL "Valor a Pagar" OF oDlgTroco PIXEL
	@ 52, 07 MSGET oPagar VAR nPagar PICTURE PesqPict("SL1","L1_VLRTOT") SIZE 120,14 FONT oFonte PIXEL OF oDlgTroco COLOR CLR_HBLUE WHEN lValget VALID IA233TVldVal(	oPagar,@nPagar,oSay,@nValor,nDinheiro,nVlrPag)
	//FONT oFonte RIGHT

	//@ 43, 04 TO 69,130 LABEL "Valor a Pagar" OF oDlgTroco PIXEL
	//@ 52, 07 SAY oSay_2 PROMPT nPagar PICTURE PesqPict("SL1","L1_VLRTOT") PIXEL OF oDlgTroco SIZE 120,14;
	//COLOR CLR_HBLUE FONT oFonte RIGHT

	// Troco ao Consumidor
	@ 81, 04 TO 107,130 LABEL "Troco ao Consumidor" OF oDlgTroco PIXEL
	@ 90, 07 SAY oSay PROMPT nValor PICTURE PesqPict("SL1","L1_VLRTOT")PIXEL OF oDlgTroco SIZE 120,14;
	COLOR CLR_HRED FONT oFonte RIGHT

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Botoes para confirmacao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE SBUTTON FROM 112, 65 oButton2 TYPE 1 ENABLE OF oDlgTroco ;
	ACTION (lRet := .T.,oDlgTroco:End()) PIXEL

	DEFINE SBUTTON FROM 112, 101 oButton1 TYPE 2 ENABLE OF oDlgTroco ;
	ACTION (lRet := .F.,oDlgTroco:End()) PIXEL

	ACTIVATE MSDIALOG oDlgTroco CENTERED

	if nValor >= 0 .AND. lRet
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ 06/03/15 -
		//ณ Abrir a gaveta apos digitar o valor em dinheiro			     ณ
		//ณ Neste local para quando nao tem calculo do valor de troco pois no get perde um enter
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nVlrPag = nPagar //.AND.LjProfile(13) .AND. !Empty(LJGetStation('GAVETA'))
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Comutar para a impressora fiscal para impressao do fechamentoณ
			//ณ diario                                                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IFGaveta(nHdlECF)
			Conout(dToC(dDataBase)+" "+time()+"- Abriu gaveta - Nao Calculou troco")
		EndIf
		If ExistBlock("LJGetTrc")
			nValor := ExecBlock("LJGetTrc",.F.,.F.,{nValor,lDinheiro})
		EndIf
		lRet := LjEnvSup(nValor,nDinheiro)
		If nVlrPag > 0
			nPago := nVlrPag					// Carrega a Var nPago com o valor pago
		Else
			nPago := 0							// Carrega a Var nPago com o valor pago
		EndIf
		uRet := nValor
	Else
		uRet := .F.
	EndIf

	SetKey(VK_F7 , If(bVK_7 == NIL,{|| },bVK_7))		// Resuara a funcionalida do F7
	nDinheiro:=nPagar
Return uRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223SetKey       ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณHabilita/desabilita teclas de funcao das formas de pagamentoบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223SetKey(oPgtos,aPgtos,lEnable)
	Local lRet		:=.T.
	Local nPosSimb 	:= 0
	Local bKey 		:= NIL
	Local aSetKey	:= {}

	Default lEnable :=.T.

	aFormPag	:= IA223FormPag() ///Estrutura de formas de pagamentos, substituindo MonFormPag

	//Dinheiro   - CTRL + A
	nPosSimb 	:= Ascan( aFormPag,{|x| Trim(x[2]) == "R$"})
	bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nPosSimb][2]+"', '"+aFormPag[nPosSimb][1]+"')}"),{|| })
	SetKey(1,    bKey)// CTRL+A - Dinheiro

	//Cheque   - CTRL + B
	nPosSimb 	:= Ascan( aFormPag,{|x| Trim(x[2]) == "CH"})
	bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nPosSimb][2]+"', '"+aFormPag[nPosSimb][1]+"')}"),{|| })
	SetKey(2,    bKey)// CTRL+A - Cheque

	//Demais Formas -    - CTRL + C..D...E...F
	For nI := 1 To Len(aFormPag)-2
		If (nPos:=At("CARTAO CREDITO",Alltrim(aFormPag[nI][5])))<>0
			bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"')}"),{|| })
			SetKey(3,    bKey)// CTRL + C
		ElseIf (nPos:=At("CARTAO DEBITO",Alltrim(aFormPag[nI][5])))<>0
			bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"')}"),{|| })
			SetKey(4,    bKey)// CTRL + D
		ElseIf (nPos:=At("VOUCHER",Alltrim(aFormPag[nI][5])))<>0
			bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"')}"),{|| })
			SetKey(22,    bKey)// CTRL + V

		ElseIf (nPos:=At("VALE INNOCENCIO",Alltrim(aFormPag[nI][5])))<>0
			bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"')}"),{|| })
			SetKey(9,    bKey)// CTRL + I
		ElseIf (nPos:=At("SINAL ENCOMENDA",Alltrim(aFormPag[nI][5])))<>0
			bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"')}"),{|| })
			SetKey(5,    bKey)// CTRL + E
		ElseIf (nPos:=At("IFOOD",Alltrim(aFormPag[nI][5])))<>0
			bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"')}"),{|| })
			SetKey(6,    bKey)// CTRL + F
		ElseIf (nPos:=At("PIX",Alltrim(aFormPag[nI][5])))<>0
			bKey 		:= If(lEnable,&("{|| U_IA223FPgto(oPgtos,@aPgtos, '"+aFormPag[nI][2]+"', '"+aFormPag[nI][1]+"')}"),{|| })
			SetKey(16,    bKey)// CTRL + P - PIX

		EndIf
	Next nI

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223LstVnd       ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณTela com a lista das vendas do dia, com as legendas:        บฑฑ
ฑฑบ          ณAmarelo	- Vendas em andamento no microterminal            บฑฑ
ฑฑบ          ณVerde	- Vendas finalizadas no microterminal                 บฑฑ
ฑฑบ          ณVermelha	- Vendas concluida no caixa nao permite reeimp.   บฑฑ
ฑฑบ          ณAzul     - Vendas concluida no caixa - Permite reeimpressao บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IA223LstVnd(cCartao)
	Local lRet			:=.F.
	Local cTitulo 		:= "Vendas do dia"
	Local aTit 			:= {" ","Cartใo","DOC-TEF","Doc","Autoriz.","Atendente","Hora","Forma","Valor","Enviado"} 	//Titulo das colunas
	Local nLin			:=0
	Local oDlg,oButton1
	Local oLbx
	Local nFlag			:=0
	Local Forma			:="Dinheiro"
	Local oTimer
	Local aVendas		:= {}
	Local aCores		:= {}
	Local oClientes, oFntVnd
	Local nClientes:=0
	Local oNEnviadas
	Local oDocTef
	Local nEnviadas:=0
	Local nDocTef:=0
	Local oNDocTef
	Local nNDocTef:=0
	Local oTotVnd
	Local nTotVnd:=0
	
	aadd(aCores,LoadBitmap( GetResources(), "BR_VERDE" 		)) 	//1-Verde para os cartoes fechados no Microterminais
	aadd(aCores,LoadBitmap( GetResources(), "BR_AMARELO" 	))	//2-Amarelo caroes que estao vendodo no microterminal
	aadd(aCores,LoadBitmap( GetResources(), "BR_VERMELHO" 	))	//3-Vermelho venda fechado no caixa
	aadd(aCores,LoadBitmap( GetResources(), "BR_AZUL" 	  	))	//4-Azul possivel reimpressใo no ECF
	aadd(aCores,LoadBitmap( GetResources(), "BR_PINK" 	  	))	//5-Pink - Sinal de encomenda

	//Tecla de funcao para reimopressao
	SetKey(VK_F12, {|| lRet:=IA223ImpVnd(@cCartao,oDlg,oLbx:nAt,aVendas)})
	SetKey(VK_F2,  {|| lRet:=IA223IncTef(@cCartao,oDlg,oLbx:nAt,aVendas)})
	//Ordenando os registro pelo mais recente
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 245,650 PIXEL
	DEFINE TIMER oTimer INTERVAL 5000 ACTION IA223Timer(oTimer,oLbx,@aVendas,oClientes,@nClientes, oNEnviadas,@nEnviadas,oDocTef,@nDocTef,oNDocTef,@nNDocTef,oTotVnd,@nTotVnd) OF oDlg
	DEFINE FONT oFntVnd NAME "Courier New"     	SIZE 8,16 BOLD

	oLbx := TwBrowse():New(0,1,325,100,,aTit,,oDlg,,,,,,,NIL,,,,,.F.,,.T.,,.F.,,,)
	oLbx:SetArray(aVendas)
	oLbx:AddColumn(TCColumn():New(" "			, {|| If(Len(aVendas)>=oLbx:nAt,aCores[aVendas[oLbx:nAt,1]],"")} ,,,, "LEFT" , 05, .T., .F.,,,, .F., ) )  //"Flag"
	oLbx:AddColumn(TCColumn():New("Cartใo"		, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,2],'')} ,,,, "LEFT" , 30, .F., .F.,,,, .F., ) )  //"Cartao"
	//oLbx:AddColumn(TCColumn():New("Orcamento"	, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,3],'')} ,,,, "LEFT" , 30, .F., .F.,,,, .F., ) )  //"Cartao"
	oLbx:AddColumn(TCColumn():New("DOC - SAT  "	, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,3],'')} ,,,, "LEFT" , 30, .F., .F.,,,, .F., ) )  //"Cartao"
	oLbx:AddColumn(TCColumn():New("Doc"     	, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,4],'')} ,,,, "LEFT" , 30, .F., .F.,,,, .F., ) )  //"Numero"
	oLbx:AddColumn(TCColumn():New("Autoriz."	, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,5],'')} ,,,, "LEFT" , 30, .F., .F.,,,, .F., ) )  //"Numero"
	oLbx:AddColumn(TCColumn():New("Atendente"	, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,6],'')} ,,,, "LEFT" , 40, .F., .F.,,,, .F., ) )  //"Atendente"
	oLbx:AddColumn(TCColumn():New("Hora"		, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,7],'')} ,,,, "LEFT" , 15, .F., .F.,,,, .F., ) )  //"Hora"
	oLbx:AddColumn(TCColumn():New("Forma"		, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,8],'')} ,,,,	 "LEFT"	, 60, .F., .F.,,,, .F., ) )  //"Forma"
	oLbx:AddColumn(TCColumn():New("Valor"		, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,9],'')} ,,,, "LEFT" , 25, .F., .F.,,,, .F., ) )  //"Valor"
	oLbx:AddColumn(TCColumn():New("Enviado"		, {|| If(Len(aVendas)>=oLbx:nAt,aVendas[oLbx:nAt,10],'')} ,,,, "LEFT" , 10, .F., .F.,,,, .F., ) )  //"Enviado"

	oLbx:bLDblClick := {|| IA223LstItens(oLbx:nAt,aVendas,oTimer) } // Posi็ใo x,y em rela็ใo a Dialog

	@ 105,10 SAY "Vendas" FONT oFntVnd PIXEL OF oDlg SIZE 150,18 COLOR CLR_GREEN,CLR_BLACK //FONT oFntCx
	@ 105,40 SAY oClientes VAR Transform(nClientes,"@E 999,999") FONT oFntVnd PIXEL OF oDlg  SIZE 150,18 COLOR  CLR_GREEN,CLR_BLACK

	@ 115,10 SAY "Nao Enviadas" FONT oFntVnd PIXEL OF oDlg SIZE 150,18 COLOR CLR_HRED,CLR_BLACK //FONT oFntCx
	@ 115,40 SAY oNEnviadas VAR Transform(nEnviadas,"@E 999,999") FONT oFntVnd PIXEL OF oDlg  SIZE 150,18 COLOR  CLR_HRED,CLR_BLACK

	@ 105,90 SAY "Nใo TEF" FONT oFntVnd PIXEL OF oDlg SIZE 150,18 COLOR CLR_BLUE,CLR_BLACK //FONT oFntCx
	@ 105,120 SAY oDocTef VAR Transform(nDocTef,"@E 999,999") FONT oFntVnd PIXEL OF oDlg  SIZE 150,18 COLOR  CLR_HRED,CLR_BLACK

	@ 115,90 SAY "TEF nใo Env" FONT oFntVnd PIXEL OF oDlg SIZE 150,18 COLOR CLR_BLUE,CLR_BLACK //FONT oFntCx
	@ 115,120 SAY oNDocTef VAR Transform(nNDocTef,"@E 999,999") FONT oFntVnd PIXEL OF oDlg  SIZE 150,18 COLOR  CLR_HRED,CLR_BLACK

	@ 105,190 SAY oTotVnd VAR Transform(nTotVnd,"@E 99,999.99") FONT oFntVnd PIXEL OF oDlg  SIZE 150,18 COLOR  CLR_GREEN,CLR_BLACK

	DEFINE SBUTTON FROM 105, 245 oButton1 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTER ON INIT  (IA223Timer(oTimer,oLbx,aVendas,oClientes,@nClientes, oNEnviadas,@nEnviadas,oDocTef,@nDocTef,oNDocTef,@nNDocTef,oTotVnd,@nTotVnd),oTimer:Activate()) //ON INIT ( SetKey(VK_F12, {|| KitF12Inno(oDlgInno,cCodProd,@uRet)})

	SetKey(VK_F2, {|| })		// Grava documento do TEF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223LstItens     ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณTela apresenta os itens do cartใo selecionado.              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223LstItens(nLin,aVendas,oTimer)
	Local lRet			:=.T.
	Local cTitulo 		:= "Venda do Cartใo"
	Local aTit 			:= {"Item","Produto","Descri็ใo","Un","Unitแrio","Quantidade","Valor","Atendente"} 	//Titulo das colunas
	Local aTam 			:= {5,20,70,5,20,15,40,30} 		//Tamanho das colunas
	Local oDlg,oButton1,oFntCartao
	Local oLbx
	Local aItens		:={}
	Local oLegenda
	Local aLegenda		:={"BR_VERDE","BR_AMARELO","BR_VERMELHO","BR_AZUL","BR_PINK"}  //Classificacoes das legendas - Verde para os cartoes fechados no Microterminais,Amarelo caroes que estao vendodo no microterminal, Vermelho venda fechado no caixa

	If Empty(aVendas)
		Return lRet
	EndIf

	oTimer:Deactivate()	//Desativar o temporizador de atualizacao da tela

	If aVendas[nLin,1]==3.OR.aVendas[nLin,1]==4
		SL1->(DbGoto(aVendas[nLin,11]))
		dbSelectArea("SL2")
		dbSetOrder(1)
		//Recuperando os itens da venda selecionados.
		SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
		While SL2->(!Eof()).AND.(xFilial("SL2")==SL2->L2_FILIAL).AND.(SL2->L2_NUM==SL1->L1_NUM)
			aadd(aItens,{	SL2->L2_ITEM,;
			SL2->L2_PRODUTO,;
			SL2->L2_DESCRI,;
			SL2->L2_UM,;
			Transform(SL2->L2_VRUNIT,"@E 99,999.99"),;
			SL2->L2_QUANT,;
			Transform(Round(SL2->L2_VLRITEM,2),"@E 99,999.99"),;
			Posicione("SA3",1,xFilial("SA3")+SL2->L2_VEND,"A3_NOME")})
			SL2->(dbSkip())
		End
	ElseIf aVendas[nLin,1]==1
		SZZ->(dbSeek(xFilial("SZZ")+aVendas[nLin,2]+"0"))
		//Recuperando os itens da venda selecionados.
		While SZZ->(!Eof()).AND.(xFilial("SZZ")==SZZ->ZZ_FILIAL).AND.(SZZ->ZZ_CARTAO==aVendas[nLin,2]).AND.SZZ->ZZ_FLAG=="0"
			aadd(aItens,{	SZZ->ZZ_ITEM,;
			SZZ->ZZ_PRODUTO,;
			SZZ->ZZ_DESCRI,;
			SZZ->ZZ_UM,;
			Transform(SZZ->ZZ_VLRITEM,"@E 99,999.99"),;
			SZZ->ZZ_QUANT,;
			Transform(Round(SZZ->ZZ_VLRITEM*SZZ->ZZ_QUANT,2),"@E 99,999.99"),;
			Posicione("SA3",1,xFilial("SA3")+SZZ->ZZ_VEND,"A3_NOME")})
			SZZ->(dbSkip())
		End
	ElseIf aVendas[nLin,1]==2
		SZX->(dbSeek(xFilial("SZX")+aVendas[nLin,2]))
		MsgInfo("Cartใo aberto no microterminal:"+SZX->ZX_MICROT+" com "+aVendas[nLin,6])
		Return lRet
	EndIf

	If Len(aItens)>0
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 300,565 PIXEL
		DEFINE FONT oFntCartao	NAME "Courier New"	   	SIZE 10,20 BOLD  	// Codigo do cartao
		//@ 06,06 TO 20,100 LABEL "Exemplo de Campos" OF oDlg PIXEL
		@ 06,06 TO 30,60 LABEL "Cartใo" OF oDlg PIXEL
		@ 15, 20 SAY   aVendas[nLin,2] SIZE 45,8 PIXEL OF oDlg FONT oFntCartao

		@ 06,160 TO 30,215 LABEL "Total" OF oDlg PIXEL
		@ 15, 160 SAY   aVendas[nLin,9] SIZE 45,8 PIXEL OF oDlg FONT oFntCartao

		oLegenda:=TBtnBmp2():New( 25, 15, 25, 25, aLegenda[aVendas[nLin,1]],,,, {|| .T.}, oDlg,, {|| .T.})

		oLbx := TwBrowse():New(35,1,280,90,,aTit,,oDlg,,,,,,,NIL,,,,,.F.,,.T.,,.F.,,,)
		oLbx:SetArray(aItens)
		oLbx:aColSizes := aTam
		oLbx:bLine := {|| {aItens[oLbx:nAt,1],;
		aItens[oLbx:nAt,2],;
		aItens[oLbx:nAt,3],;
		aItens[oLbx:nAt,4],;
		aItens[oLbx:nAt,5],;
		aItens[oLbx:nAt,6],;
		aItens[oLbx:nAt,7],;
		aItens[oLbx:nAt,8]}}
		DEFINE SBUTTON FROM 130, 235 oButton1 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()

		ACTIVATE MSDIALOG oDlg CENTER
	Else
		MsgInfo("Itens da venda nใo encontrada...")
	EndIf
	oTimer:Activate()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223Timer        ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณTimer de atualizacao da tela de lista dos cartoes           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223Timer(oTimer,oLbx,aVendas,oClientes,nClientes, oNEnviadas,nEnviadas,oDocTef,nDocTef,oNDocTef,nNDocTef,oTotVnd,nTotVnd)
	Local lRet		:=.T.
	Local aAreaSL1 	:={}
	Local nFlag		:=1
	Local cDocTef	:=""
	Local cAutoriz	:=""
	
	oTimer:Deactivate()
	aVendas:={}
	nClientes:=0 //Numero de vendas do dia
	nEnviadas:=0  //Vendas nใo enviadas para a retaguarda
	nDocTef:=0  //Vendas nใo digitadas DOC Tef
	nNDocTef:=0
	nTotVnd :=0

	dbSelectArea("SL4")
	dbSetOrder(1)

	dbSelectArea("SL1")
	aAreaSL1 := GetArea()
	dbSetOrder(7)
	dbSeek(xFilial("SL1")+DtoS(dDataBase))
	//Alimentando array com as vendas dos dia (SL1)
	While !SL1->(Eof()).And.(SL1->L1_FILIAL==xFilial("SL1")).And.(SL1->L1_EMISSAO==dDatabase)
		SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
		cL4Parc:=""
		cSL4Er:=""
		While !SL4->(Eof()).AND.xFilial("SL4")+SL1->L1_NUM==SL4->L4_FILIAL+SL4->L4_NUM
			cL4Parc+=AllTrim(SL4->L4_FORMA)+"-"
			If AllTrim(SL4->L4_FORMA)$"CD#CC#VA"
				If Empty(SL4->L4_DOCTEF).OR.Empty(SL4->L4_AUTORIZ)
					nDocTef++
				EndIf
				If SL4->L4_SITUA<>"OK"
					nNDocTef++
					If SL4->L4_SITUA="ER" .AND.Empty(cSL4Er) 
						cSL4Er:="ER"
					EndIf
				EndIf
			EndIf
			SL4->(DbSkip())
		End
		cL4Parc:=LEFT(cL4Parc,Len(cL4Parc)-1)
		nFlag:=If(Alltrim(SL1->L1_PDV)==INNO_PDV,4,3)		//INNO_PDV - Variavel publica definida em INNO_002.PRW
		aAdd(aVendas,{nFlag,;
		SL1->L1_NROPCLI,;
		SL1->L1_DOC,;
		SL1->L1_DOCTEF,;
		SL1->L1_AUTORIZ,;
		SL1->L1_VEND,;
		Transform(SL1->L1_HORA,"99:99"),;
		cL4Parc,;
		Transform(SL1->L1_VLRLIQ,"@E 99,999.99"),;
		"",;
		SL1->(Recno())})
		aVendas[Len(aVendas),6]:=Subs(Posicione("SA3",1,xFilial("SA3")+aVendas[Len(aVendas),6],"A3_NOME"),1,15)
		nClientes++
		nTotVnd+=SL1->L1_VLRLIQ
		If SL1->L1_SITUA="TX"
			aVendas[Len(aVendas),10]:="Sim"
		ElseIf SL1->L1_SITUA="00"
			aVendas[Len(aVendas),10]:="Nใo"
			nEnviadas++ //Vendas nใo enviadas para a retaguarda
		Else
			aVendas[Len(aVendas),10]:="Canc"
		EndIf
		If !Empty(cSL4Er)
			aVendas[Len(aVendas),10]:="Erro"
		EndIf
		SL1->(dbSkip())
	End

	dbSelectArea("SZX")
	SZX->(dbGotop())
	//Alimentando array com as vendas dos dia (SL1)
	While !SZX->(Eof())
		If Empty(SZX->ZX_MICROT).AND.!Empty(SZX->ZX_VLRLIQ)
			nFlag:=1
		ElseIf !Empty(SZX->ZX_MICROT).AND.!Empty(SZX->ZX_VLRLIQ)
			nFlag:=2
		Else
			SZX->(dbSkip())
			Loop
		EndIf
		aAdd(aVendas,{nFlag,;
		SZX->ZX_CARTAO,;
		"",;
		"",;
		"",;
		SZX->ZX_VEND,;
		Transform(SZX->ZX_HORA,"99:99"),;
		"",;
		Transform(SZX->ZX_VLRLIQ,"@E 99,999.99"),;
		"Pend",;
		SZX->(Recno())})
		aVendas[Len(aVendas),6]:=Subs(Posicione("SA3",1,xFilial("SA3")+aVendas[Len(aVendas),6],"A3_NOME"),1,15)
		SZX->(dbSkip())
	End
	// Carrega sinal de encomenda para a tela 0000 digitar DOCTEF ---------------------------------------------------------------------------
	dbSelectArea("SZT")
	dbSetOrder(2)
	dbSeek(xFilial("SZT")+DtoS(dDataBase))
	//Alimentando array com as vendas dos dia (SL1)
	While !SZT->(Eof()).And.(SZT->ZT_FILIAL==xFilial("SZT")).And.(SZT->ZT_DATA==dDatabase)
		If !Empty(SZT->ZT_NUM)
			SZT->(dbSkip())
			Loop
		EndIf
		SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))
		cL4Parc		:=""
		cDocTef		:=""
		cAutoriz	:=""
		While !SZS->(Eof()).AND.xFilial("SZT")+SZT->ZT_TALAO+SZT->ZT_PEDIDO==SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO
			cL4Parc+=AllTrim(SZS->ZS_FORMA)+"-"
			cDocTef		:=If(Empty(cDocTef),SZS->ZS_DOCTEF,cDocTef)
			cAutoriz	:=If(Empty(cAutoriz),SZS->ZS_AUTORIZ,cAutoriz)
			If AllTrim(SZS->ZS_FORMA)$"CD#CC#VA"
				If Empty(SZS->ZS_DOCTEF).OR.Empty(SZS->ZS_AUTORIZ)
					nDocTef++
				EndIf
				/*
				If SZS->ZS_<>"OK"
				nNDocTef++
				EndIf
				*/
			EndIf
			SZS->(DbSkip())
		End
		cL4Parc:=LEFT(cL4Parc,Len(cL4Parc)-1)
		nFlag:=5
		aAdd(aVendas,{nFlag,;
		SZT->ZT_TALAO+"/"+SZT->ZT_PEDIDO,;
		"",;
		cDocTef,;
		cAutoriz,;
		SZT->ZT_ATENDE,;
		Transform(SZT->ZT_HORA,"99:99"),;
		cL4Parc,;
		Transform(SZT->ZT_SINAL,"@E 99,999.99"),;
		"",;
		SZT->(Recno())})
		aVendas[Len(aVendas),6]:=Subs(Posicione("SA3",1,xFilial("SA3")+aVendas[Len(aVendas),6],"A3_NOME"),1,15)
		//nClientes++
		SZT->(dbSkip())
	End
	aVendas := aSort(aVendas,,,{|x,y| x[7] > y[7] }) //Hora
	
	nTotVnd:=(nTotVnd/nClientes) //Ticket Medio

	oLbx:SetArray(aVendas)
	oLbx:Refresh()
	oClientes:Refresh()
	oNEnviadas:Refresh()
	oDocTef:Refresh()
	oNDocTef:Refresh()
	oNDocTef:Refresh()
	oTotVnd:Refresh()
	oTimer:Activate()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223ImpVnd       ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณAtraves da tecla de funcao F12, faz a Re-impressao do cartao   บฑฑ
ฑฑบ          ณselecionado.                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223ImpVnd(cCartao,oDlg,nLin,aVendas)
	Local aSL1 			:= {}
	Local lRet			:=.F.
	Local aVendasAux	:= {}
	Private nValTot		:= Val(aVendas[nLin,9]) //Variavel a ser utilizada na funcao U_I222Grv() (INNO_222.PRW)

	If nLin>0
		lRet:=.T.
		If aVendas[nLin,1]==1			//Orcamento concluido
			cCartao:=aVendas[nLin,2]
		ElseIf aVendas[nLin,1]==2     	// Orcamento em andamento no Microterminal
			SZX->(dbSeek(xFilial("SZX")+aVendas[nLin,2]))
			If SZX->ZX_MICROT<>cNumTer  //***
				MsgInfo("Cartใo aberto no microterminal:"+SZX->ZX_MICROT+" com "+aVendas[nLin,6])
				lRet:=.F.
			Else
				cCartao:=aVendas[nLin,2]
			EndIf
		ElseIf aVendas[nLin,1]==3     	//Venda fechada no PDV 0002
			MsgInfo("Opera็ใo invalida!!")
			lRet:=.F.
		ElseIf aVendas[nLin,1]==4		//Venda fechada em dinheiro no PDV 0099
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVariavel publica criada em INNO_002.prw contem o Numero ณ
			//ณRegistro SL1 anterior da reempressa sera recuperado no  ณ
			//ณP.E. FRTEntreg-INNO_005.PRW                             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aVndReg:=aVendas[nLin,11]
			SL1->(DbGoto(aVndReg))
			If MsgNoYes("Confirma reeimpressใo?")
				If IA223VldCartao("000") 	//Testar se o cadastro do cartao 000 esta OK
					//Limpar registro de outras vendas
					SZZ->(dbSeek(xFilial("SZZ")+"000"+"0")) //ZZ_FILIAL+ZZ_CARTAO
					While SZZ->ZZ_FILIAL+SZZ->ZZ_CARTAO==xFilial("SZZ")+cCartao.AND.SZZ->ZZ_FLAG=="0"
						SZZ->(RecLock("SZZ", .F.))
						SZZ->(dbDelete())
						SZZ->(MsUnlock())
						SZZ->(dbSkip())
					End
					dbSelectArea("SL2")
					dbSetOrder(1)
					//Recuperando os itens da venda selecionados.
					aVendasAux	:= {}
					SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
					While SL2->(!Eof()).AND.(xFilial("SL2")==SL2->L2_FILIAL).AND.(SL2->L2_NUM==SL1->L1_NUM)
						aadd(aVendasAux,{	"000",;
						SL2->L2_VEND,;
						SL2->L2_PRODUTO,;
						SL2->L2_DESCRI,;
						SL2->L2_QUANT,;
						SL2->L2_UM,;
						SL2->L2_VRUNIT,;
						"",;
						.F.})

						SL2->(dbSkip())
					End
					//Gravacao dos itens da venda (SZZ) no cartao 000
					aVendasAux:=aClone(U_I222Grv(aVendasAux,nValTot,,nIFood)) //INNO_222.PRW)
					INNO_RIMP:=.T. //reImpressao no SAT
					/*
					// Restaurar o Sinal de Encomenda
					SZT->(dbSetOrder(1)) 									//ZT_FILIAL+ZT_TALA+ZT_PEDIDO
					SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
					While SL4->(!Eof()).and.xFilial("SL4")==SL4->L4_FILIAL.AND.SL4->L4_NUM==SL1->L1_NUM
						If !Empty(SL4->L4_DOC)	
							If SZT->(dbSeek(xFilial("SZT")+SL4->L4_DOC)).AND.SZT->ZT_NUM==SL1->L1_NUM
								SZT->(RecLock("SZT",.F.))
								SZT->ZT_NUM		:= ""
								SZT->ZT_BAIXA	:= cTod("")
								SZT->ZT_STATUS	:= ""
								SZT->(MsUnlock())

								SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))
								SZS->(RecLock("SZS",.F.))
								SZS->ZS_BAIXA	:= cTod("")
								SZS->(MsUnlock())
							EndIf
						EndIf
						SL4->(dbSkip())
					End
					*/
					U_IA999SndKey('{F9}') //F9 - Entra na forma de pagamentos
					U_IA999SndKey('{F9}') //F9 - Entra na forma de pagamentos
				Else
					lRet:=.F.
				EndIf
			Else
				lRet:=.F.
			EndIf
		EndIf
	EndIf
	SetKey(VK_F12, {|| })		//Desabilita a funcao de reimpressao
	oDlg:End()

Return lRet   //Volta para FR271AProdOK - INNO_223.PRW (60)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223F9FimVnd     ณAutor  ณMarcos Alves   บ Data ณ14/08/2010 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF9 - Concluir pagamentos e definicao da impressora          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223F9FimVnd(cCartao,oDlgInno,cCodProd,uRet,oFimVenda,cPDV,aPgtos,nVlrTotal)
	Local lRet	:=.T.
	Local cImp	:="F"
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณArray das formas de pagamento                           ณ
	//ณVariavel publica criada em INNO_002.prw sera recuperad  ณ
	//ณno P.E. F271EI02 FRTA271E.PRW                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aVndPgtos		:={}

	If !FR271HVlPar(@nVlrTotal	, @aPgtos	, 1	,2,1)
		//Verifica se o valor total das parcelas nao ficou inferior ao total da venda
		// "A soma do valor das parcelas estแ menor que o valor total da venda.", "Aten็ใo"
		HELP(' ',1,'FRT039')
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Restaura os SetKey's do Fechamento da Venda ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//Ativando a tecla de final de venda novamente, pois foi desativada na entrada da funcao.
		Return(.F.)
	EndIf
	// desativar a tecla F9 para impedir a execu็ใo no get do CPF - Alterado 05/01/14
	SetKey(VK_F9 , {|| })		// Finaliza Venda
	//Armazena as formas de pagamento para ser recuperado no ponto de entrada F271EI02 FRTA271E.PRW
	aVndPgtos:=aClone(aPgtos)

	//If !INNO_RIMP . //F9 - Entra na forma de pagamentos
	If Empty(INNO_CPF).and.SA1->A1_COD==SuperGetMv("MV_CLIPAD") //CPF ja foi digitado no primeiro cartao.
		U_IA223TelaCPF()					//Tela para digitar o CPF
	EndIf
	//EndIf

	If aNewProd[1,11]<>"2" 			//Impressora definida na primeira venda
		If Ascan( aVndPgtos,{|x| AllTrim(x[3])$"CC#CD#VA"})=0.AND.cCartao<>"000".AND.Empty(INNO_CPF)
			cImp	:="E"
		EndIf
	EndIf

	oFimVenda:End()
	uRet:={aNewProd[1,3],1} //Retorno do primeiro produto e quantidade =1, nao serแ utilizado, somente para satisfazer o PE

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223FormPag      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณMonta array com as formas de pagamento cadastradas na       บฑฑ
ฑฑบ          ณtabela 24.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223FormPag()
	Local aItens := {}

	DbSelectArea("SAE")
	DbSeek(xFilial())
	While !Eof() .AND. xFilial("SAE") == AE_FILIAL
		SX5->(DbSeek(xFilial("SX5")+"24"+SAE->AE_TIPO))
		aAdd(aItens, {Alltrim(AE_DESC),Alltrim(AE_TIPO),Alltrim(X5Descri()),AE_GRPFRT,SAE->AE_COD + " - " + SAE->AE_DESC})
		DbSkip()
	End
	DbSelectArea( "SX5" )
	/*
	If DbSeek(xFilial()+"24CR")
	AAdd(aItens, {AllTrim(X5Descri()), "CR", AllTrim(X5Descri()),"   " })
	Endif
	*/
	If DbSeek(xFilial()+"24CH")
		AAdd(aItens, {AllTrim(X5Descri()), "CH", AllTrim(X5Descri()),"   " })
	Endif
	If DbSeek(xFilial()+"24"+SuperGetMV("MV_SIMB1"))
		AAdd(aItens, {AllTrim(X5Descri()), SuperGetMV("MV_SIMB1"), AllTrim(X5Descri()),"   " })
	Endif

Return(aItens)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223GetProd      ณAutor  ณMarcos Alves   บ Data ณ19/09/10   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณInserir novos produtos no orcamanto no caixa                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223GetProd(cCartao,oCupom,;
	oQuant,nQuant,;
	oUnidade,cUnidade,;
	oVlrUnit,nVlrUnit,;
	oProduto,cProduto,;
	oTotItens,nTotItens,;
	oVlrTotal,nVlrTotal,nVlrBruto,;
	oVlrItem, nVlrItem,;
	oDlgInno,uRet,cPDV,;
	cCodProd,oCodProd,;
	lF7,lF8,lProdNew,oFotoProd,oCliente)
	Local aAreaSL1 	:= SL1->(GetArea())
	Local nTamSX3 	:= Len(SA3->A3_COD)
	Local cVendPad	:= If(!Empty(cAtend),cAtend,Left(PadR(SuperGetMV("MV_VENDPAD"),nTamSX3),nTamSX3))
	Local nInic		:=1	//Numero de itens ja digitados e/ou capturados dos cartoes
	Local cAuxCart	:=cCartao
	Local nPos		:=0
	Local nPos2		:=TAMSX3("BI_COD")[1]  //Tamanho da variavel do codigo do produto
	Local cQuant	:=""
	Local nPos3		:=0

	If Empty(cCodProd).AND.!lF7 //ENTER no Produto
		//IA223F11Grv(cCartao,@oDlgInno,@nVlrTotal)
		//oCupom:SetFocus()
		Return .T.
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se tem o sinal de * (vezez)                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuant:=""
	If (nPos:=At("*",Alltrim(cCodProd)))<>0
		cQuant:=subs(Alltrim(cCodProd),1,nPos-1)
		If (nPos3:=At(",",cQuant))<>0
			cQuant:=Stuff(cQuant,nPos3,1,".")
		EndIf
		nQuant	:=Val(cQuant)
		cCodProd:=Left(subs(Alltrim(cCodProd),nPos+1)+Space(nPos2),nPos2)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se o caro digitado e um pedido de concomenda TALAO + PEDIDO
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(Alltrim(cCodProd))==6
		//ณSalva os numeros de talao e pedido no array aSinal para pesquisa na hora da forma de pagamento
		aadd(aSinal,{Subs(Alltrim(cCodProd),1,3),Subs(Alltrim(cCodProd),4,3)})
		cCodProd:="0"+Subs(Alltrim(cCodProd),4,3)
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValidar se o codigo de produto digitado eh um cartao    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(Alltrim(cCodProd))==4.And.Subs(cCodProd,1,1)=="0"
		cCartao	:=Subs(Alltrim(cCodProd),2)
		If cCartao=="000"
			If !U_IA223LstVnd(@cCartao)  //Tela com lista das vendas do dia
				Return NIL
			EndIf
		EndIf
		dbSelectArea("SZX")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValidar o cartao e Bloquear para uso no microterminal   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If IA223VldCartao(cCartao)
			SZX->(RecLock("SZX",.F.))
			SZX->ZX_MICROT := cNumTer //***
			SZX->(MsUnLock())

			//lProdNew:= .F.		//Flag - caixa digitou novos produtos
			cCartaoAux:=cCartao
			nInic:=If(Len(aNewProd)=0,1,Len(aNewProd))
			//Carga de tela com o novo cartใo
			IA223CargaTela(cCartao,@oCupom,;
			@oQuant,@nQuant,;
			@oUnidade,@cUnidade,;
			@oVlrUnit,@nVlrUnit,;
			@oProduto,@cProduto,;
			@oTotItens,@nTotItens,;
			@oVlrTotal,@nVlrTotal,@nVlrBruto,;
			@oVlrItem,@nVlrItem,;
			@oDlgInno,@uRet,@cPDV,;
			@cCodProd,@oCodProd,@lF7,nInic,oCliente)
		Else
			//Resgata o Numero do cartao anterior
			cCartao:=cAuxCart
		EndIf
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRetorna o produto digitado                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If IA223VldProd(@cCodProd,oFotoProd)
			If !lProdNew.AND.Len(aNewProd)>0
				oCupom:Add("----------------------------- final cartใo "+aNewProd[Len(aNewProd),1]+" ---------------------------")
				cAtend 		:= SZX->ZX_ATEND	//Vendedor/Atendente fixo (Andorinha)
				cVendPad	:= If(!Empty(cAtend),cAtend,Left(PadR(SuperGetMV("MV_VENDPAD"),nTamSX3),nTamSX3))
			EndIf
			nInic:=Len(aNewProd)+1
			aadd(aNewProd,{cCartao	   					,;							// 1-NUmero do cartao
			cVendPad					,;							// 2-Atendente
			SBI->BI_COD					,;							// 3-Codigo do Produto
			SBI->BI_DESC				,;							// 4-Descricao do produto
			nQuant						,;							// 5-Quantidade
			SBI->BI_UM					,;							// 6-Unidade de Medida
			If(nIfood=1,SBI->BI_PRV2,SBI->BI_PRV),;					// 7-Preco unitario
			""							,;							// 8-Numero do registro no SZZ (quando salvo)
			.F.							,;							// 9-Flag para indicar se o registro esta deletado
			++nTotItens					,;							// 10- Numero do Item
			"0"})													// 11-Flag Indica se produto ja foi impresso no ECF
			//Carga de tela com o novo cartใo
			IA223CargaTela(cCartao,@oCupom,;
			@oQuant,@nQuant,;
			@oUnidade,@cUnidade,;
			@oVlrUnit,@nVlrUnit,;
			@oProduto,@cProduto,;
			@oTotItens,@nTotItens,;
			@oVlrTotal,@nVlrTotal,@nVlrBruto,;
			@oVlrItem,@nVlrItem,;
			@oDlgInno,@uRet,@cPDV,;
			@cCodProd,@oCodProd,@lF7,nInic,oCliente)
			//Gravacao dos itens da venda (SZZ) no cartao 000 INNO_222.PRW)
			lProdNew:= .T.		//Flag - caixa digitou novos produtos
			nQuant:=1
		EndIf
	EndIf
	cCodProd:=Space(13)
	If !lF7.AND.!lF8
		oCodProd:SetFocus()
	EndIf

	RestArea( aAreaSL1 )
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223VldProd      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Faz as validacoes do codigo do produto e seu retorno       บฑฑ
ฑฑบ          ณ para continuidade do processamento.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223VldProd(cCodProd,oFotoProd)
	Local lRet	:=.F.
	Local cSom :=  Strzero(Val(cCodProd),5)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPesquisa por Codigo do Produtoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(cCodProd)
		dbSelectArea( "SBI" )
		dbSetOrder( 1 )
		If !dbSeek( xFilial("SBI")+cCodProd)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPesquisa por Codigo de Barra  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			dbSetOrder( 5 )
			If !dbSeek( xFilial("SBI")+cCodProd)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณPesquisa por Codigo de Barra no Cad de Codigo de Barra  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
				cCodProd:= SBI->BI_COD
				lRet	:=.T.
			EndIf
		Else
			cCodProd := SBI->BI_COD
			lRet	 :=.T.
		EndIf
		If !ExistCPO("SBI", cCodProd,1)
			cCodProd:= Space(6)
			lRet	:=.F.
		EndIf
	EndIf

	If lRet
		cFotoProd := If(Empty(SBI->BI_BITMAP).OR.!oFotoProd:ExistBmp(AllTrim(SBI->BI_BITMAP)), "LOJAWIN", AllTrim(SBI->BI_BITMAP))
		If oFotoProd:cBMPFile <> cFotoProd
			ShowBitMap(oFotoProd, cFotoProd)
		EndIf
		oMedia:lCanGotFocus:=.F.
		If file(cPathSom + cSom +".MP3")
			oMedia:openFile(cPathSom+cSom+".MP3") 
		EndIf
    EndIf		
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223EditQtd      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF7 - Altera a Quantidade do Item - Habilita o Get           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223EditQtd(oQuant,nQuant,lF7)
	lF7:= .T.
	//oQuant:Enable()
	oQuant:nTop  := 240
	oQuant:nLeft := 10
	oQuant:SetFocus()
	oQuant:Refresh()

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223GetQuant     ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF7 - Altera a Quantidade do Item - Get                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223GetQuant(lF7,oCodProd,oQuant)
	Local lRet	:=.T.
	lF7:=.F.
	//oQuant:Disable()
	oCodProd:SetFocus()
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223DescTot      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF6 - Desconto no total da Venda                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223DescTot(oVlrTotal,nVlrTotal,nValorDesc,oCupom)
	Local oDlgDescTot						// Objeto da janela do desconto
	Local oValorDesc						// Objeto do get do valor do desconto
	Local oPercDesc							// Objeto do get do percentual do desconto
	Local oBtn1								// Objeto do botao OK
	Local oBtn2								// Objeto do botao Cancelar
	Local nPerc			:= 0 				// Valor do Desconto sem a funcao Round()
	Local oKeyb								// Objeto do Teclado Virtual
	Local nOpcao		:= 1				// Opcao de tipo de desconto

	//Excluir as variavais
	Local nOpc			:=0
	Local nTotDedIcms	:=0
	Local nVlrBruto		:=nVlrTotal
	Local nMoedaCor		:=1

	Local cTipoDesc     := SuperGetMV("MV_LJTIPOD",.F.,"0")    // Tipo do Desconto
	Local lTipoDesc   	:= IIf(cTipoDesc == "0",.F.,.T.)		// Verifica se existe o parametro
	Local nVlrEntrega	:=0 //Valor da entrega
	Local nPos			:=0 // Indice do array que esta o valor da entrega

	Default nOpc 		:= 1
	Default nTotDedIcms	:=0
	// Tirar o valor da Taxa de entrega no valor de desconto
	If (nPos:= Ascan( aNewProd,{|X| Alltrim(X[3])=="00198"}))<>0 
		nVlrEntrega:=aNewProd[nPos,5]*aNewProd[nPos,7]
	ENDIF
	
	DEFINE MSDIALOG oDlgDescTot FROM  47,130 TO 160,370 TITLE "Desconto no total do cupom" PIXEL	// "Desconto no total do cupom"

	@ 06, 04 BITMAP RESOURCE "DISCOUNT" OF oDlgDescTot PIXEL SIZE 32,32 ADJUST When .F. NOBORDER
	@ 04, 40 TO 28, 120 LABEL "Valor / Percentual" OF oDlgDescTot PIXEL	// "Valor / Percentual"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta o get do valor do desconto e define o valid para chamar a mesmaณ
	//ณ funcao da venda assitida para verificar a permissao de desconto do   ณ
	//ณ usuario                                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ 13, 45 MSGET oValorDesc VAR nValorDesc SIZE 40, 10 OF oDlgDescTot Picture PesqPict("SL1","L1_VLRTOT",10,nMoedaCor) RIGHT PIXEL ;
	VALID (If(nValorDesc<0,HELP(' ',1,'FRT023'),),.T.) .AND.;
	(nValorDesc >= 0 .AND. nValorDesc < nVlrBruto) .AND. ;
	IA223ValDesc( 2, nPercDesc, nValorDesc ) .AND. If(nValorDesc= 0,oPercDesc:SetFocus(),.T. )
	oValorDesc:cSx1Hlp:="L1_DESCONT"

	oValorDesc:bLostFocus := {|| nPercDesc := Round( 100 - ( ( ( (nVlrTotal-nVlrEntrega) - nValorDesc) / ((nVlrBruto -nVlrEntrega)- nTotDedIcms) ) * 100 ),2 ), oPercDesc:Refresh(),;
	nPerc 		:= 100 -   (( (nVlrTotal-nVlrEntrega) - nValorDesc) / ((nVlrBruto-nVlrEntrega)- nTotDedIcms)) * 100, oBtn1:SetFocus() }

	@ 13, 90 MSGET oPercDesc  VAR nPercDesc  SIZE 16, 10 OF oDlgDescTot PICTURE "@E 99.99" PIXEL ;
	VALID ( If( nPercDesc < 0, HELP(' ',1,'FRT023'),),.T.) .AND.;
	( nPercDesc  >= 0 ) .AND.;
	IA223ValDesc( 1, nPercDesc, nValorDesc )

	oPercDesc:cSx1Hlp:="NDESPERTOT"

	oPercDesc:bLostFocus := {|| nValorDesc := Fr271IAtuValor( nPerc, nPercDesc, (nVlrTotal-nVlrEntrega), nValorDesc), oValorDesc:Refresh() }

	DEFINE SBUTTON oBtn1 FROM 38, 50 TYPE 1 ENABLE OF oDlgDescTot PIXEL ACTION ( nOpc := 1,oDlgDescTot:End() )
	DEFINE SBUTTON oBtn2 FROM 38, 85 TYPE 2 ENABLE OF oDlgDescTot PIXEL ACTION ( nOpc := 0,oDlgDescTot:End() )

	ACTIVATE MSDIALOG oDlgDescTot VALID IIf(lTipoDesc.AND.nOpc=1, IA223ValDesc(Val(cTipoDesc),nPercDesc,nValorDesc) , .T.) CENTERED

	If nOpc==1.AND.(nValorDesc>0.OR.nPercDesc>0)
		nVlrTotal-=nValorDesc
		nVlrPagar-=nValorDesc
		oCupom:Add("                                        ----------------------------------")
		oCupom:Add(PadL("Desconto no total do cupom",74))	// "Desconto no total do cupom"
		oCupom:Add(PadL("Valor / Percentual",74))	// "Valor / Percentual"
		oCupom:GoBottom()
		oCupom:Add(PadL(Trans(nValorDesc,PesqPict("SL1","L1_VLRTOT",10,nMoedaCor))+" / "+Trans(nPercDesc,"@E 99.99")+"%",74))
		oCupom:Add("                                        ----------------------------------")
		oCupom:GoBottom()
		oVlrTotal:Refresh()
	EndIf
Return ( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223TelaCPF      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณApresenta tela para digitar CPF do cliente				  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IA223TelaCPF()
	Local lCont		:= .F.					// Continua apos digitar CGC
	Local oDlg								// Objeto da Tela
	Local oCNPJInno                         // Campo para digitar o CGC
	Local oFontText							// Fonte do texto

	INNO_CPF	:= Space(18)				// Variavel Static - CGC do cliente
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAbre tela para digitarณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE FONT oFontText NAME "Courier New" SIZE 09,20

	//"INFORME O CPF / CNPJ PARA IMPRESSรO"
	DEFINE MSDIALOG oDlg TITLE "INFORME O CPF / CNPJ PARA IMPRESSรO" FROM 323,412 TO 420,738 PIXEL STYLE DS_MODALFRAME STATUS
	//;	COLOR CLR_BLACK,CLR_YELLOW

	//"Digite abaixo:"
	@ 005, 004 TO 30, 160 LABEL "Digite abaixo:" PIXEL OF oDlg
	@ 013,007 MSGET oCNPJInno VAR INNO_CPF SIZE 150,10 FONT oFontText OF oDlg PIXEL

	DEFINE SBUTTON FROM 35, 104 TYPE 1 ENABLE OF oDlg ACTION (lCont := .T. , IIF(IA223VldCPF(),oDlg:End(),NIL))
	DEFINE SBUTTON FROM 35, 134 TYPE 2 ENABLE OF oDlg ACTION (lCont := .F. , oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTERED

	INNO_CPF := If(lCont,Alltrim(INNO_CPF),"")

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223TelaCPF      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณValida o CGC digitado se existe.                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223VldCPF()
	Local lRet 			:= .F.				// Retorno da funcao
	Local cVerCgc 		:= INNO_CPF				// CGC do cliente
	Local cSupervisor	:=""				//Variavel utilizada na funcao de senha

	DEFAULT INNO_CPF 	:= ""

	If !Empty(INNO_CPF)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRetira caracteres que nao sao usadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cVerCgc := StrTran(cVerCgc,".","")
		cVerCgc := StrTran(cVerCgc,"-","")
		cVerCgc := StrTran(cVerCgc,"/","")
		cVerCgc := Alltrim(cVerCgc)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida se o CGC digitado eh validoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If CGC(cVerCgc)
			lRet := .T.
			INNO_CPF := cVerCgc
		EndIf
		SA3->(dbSetOrder(3)) //A3_FILIAL+A3_CGC
		If SA3->(dbSeek(xFilial("SA3")+cVerCgc))
			MsgInfo("Venda para funcionแrios...serแ solicitado senha Superior")
			lAutoriza := LJProFile(8,@cSupervisor)
			If !lAutoriza
				lRet:=.F.
			EndIf
		EndIf

	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe estiver em branco, valida a insercaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lRet := .T.
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223F8CancItens  ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณCancela itens da prevenda                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223F8CancItens(oDlgInno,oVlrTotal,nVlrTotal,nVlrBruto,oCupom,cCodProd,oCodProd,uRet,cPDV,lF8,cCupom,nTotItens)
	Local nLin			:= oCupom:nAt
	Local nItem			:=Val(Subs(oCupom:aItems[nLin],1,3))
	Local cSupervisor  	:= Space(15)

	If nItem>0.AND.AT("CANCELADO      0,00",oCupom:aItems[nLin])=0
		If LJProfile(7, @cSupervisor)						// Verifica Permissao
			//If MsgNoYes("Confirma cancelamento do item?")
			aNewProd[nItem,9]:=.T.	//
			nVlrTotal -= (aNewProd[nItem,5]*aNewProd[nItem,7])
			oCupom:aItems[nLin]:=Stuff(oCupom:aItems[nLin],56,19,"CANCELADO      0,00")
			oCupom:SetArray(oCupom:aItems)
			//oCupom:Select( If(nLin+1>Len(oCupom:aItems),nLin,nLin+1))
			oCupom:Select(nLin)
			oCupom:Refresh()

		EndIf
	EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223InitVar      ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณIniailiza as variaveis static                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IA223InitVar()

	nValorDesc		:=0		//Valor de desconto a ser recurepado no PE F271EI02
	nPercDesc		:=0		//Percentual de desconto a ser recurepado no PE F271EI02
	INNO_CPF		:=""	// CNPJ do cliente
	cVndCartao		:=""	//Ultimo cartao lido na venda atual
	aVndItens		:={}	//Itens para impressao no ECF
	aVndPgtos		:={}	//Formas de pagamento para tranpostar para o frontoloja
	aVndReg			:={}	//Numero do registro da anterior da reimpressao do cupom fiscal
	aNewProd		:={} 	//Array com os itens lido dos caroes e novos produtos durante a venda
	cCartaoAux   	:=""	//Receber o ultimo carto digitado
	lFlagVazio		:=.F.	//Flag que aponta que ja tem um cartao vazio digitado
	//nIfood			:= 2    // Defini a tabela de preco 1=ifood
	// 26/03/15 - Selecionar cliente padrao ao final da venda
	If SA1->A1_COD<>INNO_CLI
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Posiciona o cadastro de clientes ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea( "SA1" )
		DbSetOrder( 1 )
		DbSeek( xFilial( "SA1" ) + INNO_CLI + INNO_LOJ )
	EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณFRTKIT           ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
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
User Function FRTEntreg() //Ponto de Entrada
	Local lRet			:=.T. 		// Retorno da funcao
	Local cCartao		:="" //Numero do cartao, habilitada no INNO_223.PRW
	Local cVend			:=""
	Local aAreaSL1 		:= GetArea()
	Local lDeletaSL1	:=.T.
	Local lDeletaSL2	:=.T.
	Local lDeletaSL4	:=.T.
	Local nI
	// 11/03/2015 - Aletacao para pegar o codigo do cliente selecionado pelo F10
	Local aRegSZZ		:={}
	Local nRegSZT		:= 0
	// 23/04/2015 - Selecionando o cliente e Depois abandonando nao reposiciona o cadastro.
	If SA1->A1_COD<>INNO_CLI
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Posiciona o cadastro de clientes ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea( "SA1" )
		DbSetOrder( 1 )
		DbSeek( xFilial( "SA1" ) + INNO_CLI + INNO_LOJ )
	EndIf

	For nI:=1 to Len(aNewProd)
		SZZ->(DbGoto(aNewProd[nI,8]))
		SZZ->(RecLock("SZZ",.F.))
		//Identificando o Cliente
		/*
		If !Empty(INNO_CPF)
		dbSelectArea("SA1")
		dbSetOrder(3)
		If (SA1->(dbSeek(xFilial("SA1")+Alltrim(INNO_CPF))))		//Cadastro de cliente
		cCliente:=SA1->A1_COD
		cCliLoja:=SA1->A1_LOJA
		EndIf
		EndIf
		*/
		//Atualizando a informacao do vendedor
		If SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM+STRZERO(VAL(SZZ->ZZ_ITEM),2)+SZZ->ZZ_PRODUTO))
			cVend:=SZZ->ZZ_VEND
			SL2->(RecLock("SL2",.F.))
			SL2->L2_VEND:= cVend
			SL2->L2_TABELA:= SZZ->ZZ_TABELA // Atualizar a informa็ใo da tabela utilizada ifood?
			SL2->L2_LOCALIZ:= SZZ->ZZ_PEDIDO // Numero do Pedido do Ifood
			SL2->(MsUnLock())
		EndIf
		SZZ->ZZ_NUMERO	:= SL1->L1_NUM
		SZZ->ZZ_FLAG	:= "1"
		SZZ->(MsUnLock())

		If cCartao<>aNewProd[nI,1]
			cCartao:=aNewProd[nI,1]
			dbSelectArea("SL2")
			SZX->(dbSetOrder(1))

			//Desbloquear o carใo para proxima venda
			dbSelectArea("SZX")
			SZX->(dbSetOrder(1))
			SZX->(dbSeek(xFilial("SZX")+cCartao))
			SZX->(RecLock("SZX",.F.))
			SZX->ZX_MICROT := ""
			SZX->ZX_DATA	:= cTod("")
			SZX->ZX_HORA	:= ""
			SZX->ZX_VLRLIQ	:= 0
			SZX->ZX_TABELA	:= ""			
			//SZX->ZX_VEND	:= "" //Cadastro de vendedores nos cartoes
			SZX->(MsUnLock())
			//Salvando o Numero do cartao e vendedor no Orcamento
			SL1->(RecLock("SL1", .F.))
			SL1->L1_NROPCLI := Alltrim(SL1->L1_NROPCLI)+Alltrim(cCartao)
			SL1->L1_VEND	:= cVend
			SL1->L1_CLIENTE	:= INNO_CLI
			SL1->L1_LOJA	:= INNO_LOJ
			//SL1->L1_SITUA	:= "XX"
			SL1->L1_NUMERO	:= SZZ->ZZ_PEDIDO
			SL1->L1_LOJA	:= INNO_LOJ
			SL1->( dbCommit() )
			SL1->( msUnlock() )
		EndIf
	Next nI
	//02/11/2015 - Alterado local pois estava executando para todos os produtos excluido (necessita somente uma vez)
	If cCartao=="000" //Excluir o registro do SL1 da venda anterior ao da reimpressใo
		aAreaSL1 	:=  SL1->(GetArea())
		SL1->(DbGoto(aVndReg)) // Variavel aVndReg definida NA funcao INNO_223.prw
		//"07" - Solicitado o Cancelamento na retaguarda
		aSL1 := {{"L1_SITUA",	"99"}}				// "99" - Excluir registro pois foi reeimpresso.
		FR271BGeraSL("SL1", aSL1)
		//Gera registro na tabela SLI com o comando de cancelar na retaguarda, L1_NUMORIG ->Numero do orcamento na retaguarda
		FR271BGerSLI("    ", "CAN", SL1->L1_NUMORIG, "NOVO")
		//Excluir os registos das tabelas SL1. SL2, SL4
		FR271BCancela(lDeletaSL1, lDeletaSL2, lDeletaSL4)
		RestArea(aAreaSL1)
	EndIf

	If Len(aNewProd)=0.AND.!Empty(INNO_CPF) //Atualizacao somente quando venda direta pela tela do Front
		//Salvando o Numero do cartao e vendedor no Orcamento
		SL1->(RecLock("SL1", .F.))
		SL1->L1_CGCCLI	:= INNO_CPF
		SL1->L1_CLIENTE	:= INNO_CLI
		SL1->L1_LOJA	:= INNO_LOJ

		SL1->( msUnlock() )
	EndIf
	
	//Se existir mais de 1 parcela como R$, apaga a parcela gerada no SL4 e regera o SL4. Por causa da contabilizacao do sinalde encomenda 
	nDin:=0

	AEval( INNO_APGTOS,{|X| nDin+=If(Alltrim(X[3]) == "R$",1,0)})
	//Excutar, somente se for reimpressao que passa pela roina do P12 padrao
	If INNO_RIMP .AND. nDin>1
		//Apaga o registro gerado pela P12
		SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
		While SL4->(!Eof()).and.xFilial("SL4")==SL4->L4_FILIAL.AND.SL4->L4_NUM==SL1->L1_NUM
			If Alltrim( SL4->L4_FORMA ) == "R$"
				SL4->(RecLock("SL4", .F.))
				SL4->(dbDelete())
				SL4->(MsUnlock())
			EndIf	
			SL4->(dbSkip())
		End
		For nI:=1 To Len(INNO_APGTOS)
			If INNO_APGTOS[nI,3]=="R$"
				aSL4 := {	{"L4_FILIAL"	,	xFilial("SL4")		}, ;
							{"L4_NUM"		,	SL1->L1_NUM			}, ;
							{"L4_DATA"		,	INNO_APGTOS[nI,1]	}, ;
							{"L4_VALOR"		,	INNO_APGTOS[nI,2]	}, ;
							{"L4_FORMA"		,	INNO_APGTOS[nI,3]	}, ;
							{"L4_DOC"		,	INNO_APGTOS[nI,8]	}, ;
							{"L4_ADMINIS"	,	INNO_APGTOS[nI,4]	}, ;
							{"L4_TERCEIR"	,	.F.					}, ;
							{"L4_MOEDA"		,	0					}}
				
				FR271BGeraSL("SL4", aSL4, .T.)
			EndIf
		Next nI
	EndIf	

	//Se existir mais de 1 parcela como VA, apaga a parcela gerada no SL4 e regera o SL4 
	nVA:=0
	AEval( INNO_APGTOS,{|X| nVA+=If(Alltrim(X[3]) == "VA",1,0)})
	If nVA>1
		//Apaga o registro gerado pela P12
		SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
		While SL4->(!Eof()).and.xFilial("SL4")==SL4->L4_FILIAL.AND.SL4->L4_NUM==SL1->L1_NUM
			If Alltrim( SL4->L4_FORMA ) == "VA"
				SL4->(RecLock("SL4", .F.))
				SL4->(dbDelete())
				SL4->(MsUnlock())
			EndIf	
			SL4->(dbSkip())
		End
		For nI:=1 To Len(INNO_APGTOS)
			If INNO_APGTOS[nI,3]=="VA"
				aSL4 := {	{"L4_FILIAL"	,	xFilial("SL4")		}, ;
							{"L4_NUM"		,	SL1->L1_NUM			}, ;
							{"L4_DATA"		,	INNO_APGTOS[nI,1]	}, ;
							{"L4_VALOR"		,	INNO_APGTOS[nI,2]	}, ;
							{"L4_FORMA"		,	INNO_APGTOS[nI,3]	}, ;
							{"L4_DOC"		,	INNO_APGTOS[nI,8]	}, ;
							{"L4_ADMINIS"	,	INNO_APGTOS[nI,4]	}, ;
							{"L4_TERCEIR"	,	.F.					}, ;
							{"L4_MOEDA"		,	0					}}
				
				FR271BGeraSL("SL4", aSL4, .T.)
			EndIf
		Next nI
	EndIf	

	//Baixa os valores de recebimento de SINAL da encomenda
	nRegSZT:=0
	For nZ:=1 to Len(aSinal)
		If SZT->(dbSeek(xFilial("SZT")+aSinal[nZ,1]+aSinal[nZ,2])).AND.Empty(SZT->ZT_NUM)
			nRegSZT:=SZT->(Recno())
			While !SZT->(Eof()).AND. (xFilial("SZT")+aSinal[nZ,1]+aSinal[nZ,2]==SZT->ZT_FILIAL+SZT->ZT_TALAO+SZT->ZT_PEDIDO)
				SZT->(RecLock("SZT",.F.))
				SZT->ZT_NUM		:= SL1->L1_NUM
				SZT->ZT_BAIXA	:= dDataBase
				SZT->ZT_STATUS	:= "R"
				SZT->(MsUnlock())
				SZT->(dbSkip())
			End
			SZT->(DbGoto(nRegSZT))
			SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))
			While !SZS->(Eof()).and. (xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO)==(SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO)
				SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
				While SL4->(!Eof()).and.xFilial("SL4")==SL4->L4_FILIAL.AND.SL4->L4_NUM==SL1->L1_NUM
					If SL4->L4_FORMA==SZS->ZS_FORMA.And.Subs(SL4->L4_ADMINIS,1,3)==Subs(SZS->ZS_ADMINIS,1,3).And.SL4->L4_VALOR==SZS->ZS_VALOR.And.SL4->L4_DATA==SZS->ZS_DATA
						SL4->(RecLock("SL4", .F.))
						SL4->L4_DOCTEF	:=SZS->ZS_DOCTEF
						SL4->L4_AUTORIZ	:=SZS->ZS_AUTORIZ
						SL4->L4_DOC		:=SZS->ZS_TALAO+SZS->ZS_PEDIDO
						SL4->L4_INSTITU	:=SZS->ZS_PARCELA
						SL4->(MsUnlock())
					EndIf
					SL4->(dbSkip())
				End
				SZS->(RecLock("SZS",.F.))
				SZS->ZS_BAIXA	:= dDataBase
				SZS->(MsUnlock())
				SZS->(dbSkip())
			End
		EndIf
	Next nZ

	If (SA1->A1_DESC)>0.OR.	(!Empty(SA1->A1_COND).AND.Alltrim(SA1->A1_COND)=="002".AND.At("VALE INNOCENCI", Alltrim(SL4->L4_ADMINIS))<>0) //" VALE INNOCENCI"
		SA1->(RecLock("SA1",.F.))
		SA1->A1_SALDUP:=SA1->A1_SALDUP+SL1->L1_VLRLIQ
		SA1->A1_ULTCOM:=dDataBase
		SA1->(MsUnLock())
		//Impessao do vale de compra dos Funcionarios
		Processa( { ||IA223ImpRecibo()}, "Aguarde...","...Imprimindo o Recibo.")
	EndIf

	U_IA223InitVar()
	//INNO_V03[4]:=If(INNO_V03[4]=="1","0",INNO_V03[4]) //P12

	//Desconecta a impressora ao final de toda venda
	INNO_IMP[1]:="E"
	INNO_IMP[2]:=""
	INFFechar("0",LjGetStation("PORTIF"))

	//Renomear o arquivo do pedido Ifood para nao processar novamente
	If File(INNO_AIF[1]+INNO_AIF[2])
		FRENAME(  INNO_AIF[1]+INNO_AIF[2],   INNO_AIF[1]+"IFOOD_PEDIDO_"+dTos(ddataBase)+"_"+Right(INNO_AIF[2],8)) 
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223F11Grv       ณAutor  ณMarcos Alves   บ Data ณOut/2010   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF11 - Gravacao dos itens do cartao                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223F11Grv(cCartao,oDlgInno,nVlrTotal)
	Local lRet	:=.T.

	If Ascan( aNewProd,{|x| Empty(x[8]).OR.X[9]==.T.})<>0 //Verificar se o caixa digitou novos produtos OU cancelou item no cartao
		aNewProd:=aClone(U_I222Grv(aNewProd,nVlrTotal,.T.,nIfood)) //INNO_222.PRW
	EndIf
	//Desbloquear o cartao
	SZX->(dbSeek(xFilial("SZX")+cCartao))
	SZX->(RecLock("SZX",.F.))
	SZX->ZX_MICROT := ""
	SZX->(MsUnLock())

	U_IA223InitVar()
	oDlgInno:End()
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223EditVld      ณAutor  ณMarcos Alves   บ Data ณAbr/2012   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF7 - Edita o campo valor tela de troco                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223TEditVal(lValget,oPagar)
	lValget :=.T.
	oPagar:SetFocus()
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223EditVld      ณAutor  ณMarcos Alves   บ Data ณAbr/2012   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณF7 - Edita o campo valor tela de troco                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA233TVldVal(oPagar,nPagar,oSay,nValor,nDinheiro,nVlrPag)
	Local lRet:=.T.
	If nPagar>nDinheiro
		nPagar:=nDinheiro
		MsgInfo("Valor invalido!!")
		lRet:=.F.
		nValor:=nVlrPag-nPagar
		oSay:refresh()
		oPagar:Refresh()
	Else
		If nPagar<>nDinheiro
			nValor:=nVlrPag-nPagar
			oSay:refresh()
		EndIf
	EndIf

	Return lRet

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFuno    ณLjAtuTrocoณ Autor ณ Vendas Clientes       ณ Data ณ 20/03/98 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescrio ณ Atualiza o valor do troco ao consumidor                    ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณSintaxe   ณ LjatuTroco                                                 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณRetorno   ณ ExpL1 - Operaฦo OK ou Nao                                 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ Uso      ณ Loja220                                                    ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	Static Function IA223UpTroco( nVlrPag, ; 		// Valor que o cliente pagou
	nDinheiro,; 	//Valor total ca compra
	nPagar, ;		// valor da parcela
	oPagar, ;		// Objeto do
	nValor,;		//Troco do cliente
	oSay)
	Local lRet	:= .T.
	nPagar	:= nDinheiro
	nValor 	:= 0

	If nVlrPag == 0
		nVlrPag := nPagar
	ElseIf (Val(Str(nVlrPag)) <= Val(Str(nDinheiro))) .AND. (nVlrPag <> 0)
		nPagar	:=nVlrPag
	Else
		nValor := nVlrPag - nPagar
	EndIf
	oSay:Refresh()
	oPagar:Refresh()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ 06/03/15 -
	//ณ Abrir a gaveta apos digitar o valor em dinheiro			     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nVlrPag <> nPagar //.AND.LjProfile(13) .AND. !Empty(LJGetStation('GAVETA'))
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Comutar para a impressora fiscal para impressao do fechamentoณ
		//ณ diario                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//U_F1299Inno("F")
		IFGaveta(nHdlECF)
		Conout(dToC(dDataBase)+" "+time()+"- Abriu gaveta - Calculou troco")
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ                 ณAutor  ณMarcos Alves   บ Data ณ Nov/13    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IA223PesqProd()
	Local lRet			:=.F.
	Local cTitulo 		:= "Consulta de Produto"
	Local aTit 			:= {"Codigo","Descri็ao","Pre็o","Estoque"} 	//Titulo das colunas
	Local aProd			:= {}
	Local cPesqProd		:=Space(40)
	Local oDlg
	Local oLbx
	Local oGetPesq
	Local oPesqEst		:=NIL
	Local lPesqEst		:=.F.

	//Ordenando os registro pelo mais recente
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 290,430 PIXEL

	@ 3, 3 TO 25, 160 LABEL "Descri็ใo do produto" PIXEL	// "Descri็ใo do produto"
	@10,08 MSGET oGetPesq VAR cPesqProd PICTURE "@!" SIZE 150,10 PIXEL OF oDlg //
	//oGetPesq:bLostFocus := {|| If(!Empty(oGetPesq:cText),IA223PesqStr(oGetPesq,oLbx,@aProd,@lPesqEst),),oLbx:Refresh()}

	@ 3,165 TO 25, 210 LABEL "Consulta" PIXEL	// "Descri็ใo do produto"
	@ 10, 170 CHECKBOX oPesqEst VAR lPesqEst PROMPT "Estoque" ;
	SIZE 30,07 OF oDlg PIXEL //WHEN (nNumParc>1 .AND. cForma $ "CC;CD" )
	oPesqEst:bLostFocus := {|| If(!Empty(oGetPesq:cText),IA223PesqStr(oGetPesq,oLbx,@aProd,@lPesqEst),),oLbx:Refresh()}

	oLbx := TwBrowse():New(30,5,200,100,,aTit,,oDlg,,,,,,,NIL,,,,,.F.,,.T.,,.F.,,,)
	oLbx:SetArray(aProd)
	oLbx:AddColumn(TCColumn():New("Codigo"		, {|| If(Len(aProd)>=oLbx:nAt,aProd[oLbx:nAt,1],''			)} 	,,,, "LEFT" , 30, .F., .F.,,,, .F., ) )  //"Codigo"
	oLbx:AddColumn(TCColumn():New("Descri็ใo"	, {|| If(Len(aProd)>=oLbx:nAt,aProd[oLbx:nAt,2],''			)} ,,,,  "LEFT" , 80, .F., .F.,,,, .F., ) )  //"Descricao"
	oLbx:AddColumn(TCColumn():New(" Pre็o  "	, {|| If(Len(aProd)>=oLbx:nAt,aProd[oLbx:nAt,3],''			)} ,,,,	  "RIGHT" , 15, .F., .F.,,,, .F., ) )  //"Preco"
	oLbx:AddColumn(TCColumn():New("Estoque"		, {|| If(Len(aProd)>=oLbx:nAt,aProd[oLbx:nAt,4],''			)} ,,,,	  "RIGHT" , 10, .F., .F.,,,, .F., ) )  //"Estoque"

	oLbx:bLDblClick := {|| If( Len(aProd)>0,SBI->(dbGoto(aProd[oLbx:nAt,5])),), lRet:=.T.,oDlg:end() } // Posi็ใo x,y em rela็ใo a Dialog

	ACTIVATE MSDIALOG oDlg CENTER ON INIT  (oGetPesq:SetFocus())

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ                 ณAutor  ณMarcos Alves   บ Data ณ13/11/2013 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ															  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223PesqStr(oGetPesq,oLbx,aProd,lPesqEst)
	Local lRet		:=.T.
	Local aAreaSB1 	:={}
	Local cPesqAux	:=Alltrim(oGetPesq:cText)
	Local aPesqAux	:={}
	Local nPos		:=0
	Local nI		:=0
	Local lLoop		:=.F.
	cPesqProd	:=Alltrim(oGetPesq:cText)
	aProd		:={}
	// Separando as palavras digitas, divididas por espaco
	While (nPos:=At(" ",cPesqAux))<>0
		aadd(aPesqAux,Subs(cPesqAux,1,nPos-1))		//DOCE
		cPesqAux:=Subs(cPesqAux,nPos+1)        //BRANCO
	End
	aadd(aPesqAux,cPesqAux)		//DOCE

	dbSelectArea("SBI")
	aAreaSBI := GetArea()
	SBI->(dbSetOrder(1))
	SBI->(dbGotop())

	//Alimentando array com os produtos com a palavra pesquisada
	While !SBI->(Eof()).AND.Val(SBI->BI_COD)<1000
		If	SBI->BI_MSBLQL="1"
			SBI->(dbSkip())
			Loop
		EndIf
		lLoop:=.F.
		For nI:=1 to Len(aPesqAux)
			If	At(aPesqAux[nI],SBI->BI_DESC)=0
				lLoop:=.T.
				Exit
			EndIf
		Next nI
		If lLoop
			SBI->(dbSkip())
			Loop
		EndIf
		aAdd(aProd,{	SBI->BI_COD,;
		SBI->BI_DESC,;
		Transform(SBI->BI_PRV,"@E 99,999.99"),;
		"XXXXX",;
		SBI->(RECNO())})
		SBI->(dbSkip())
	End

	If !Empty(aProd)
		If lPesqEst
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณChama a fun็ใo para conexใo com retaguarda             ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			LjMsgRun( "Aguarde ... Consultando Estoque servidor..."+AllTrim(SLG->LG_RPCSRV),,; // "Aguarde ... Consutando loja "
			{|| aProd := U_I201EstRPC( AllTrim(SLG->LG_RPCSRV), Val(AllTrim(SLG->LG_RPCPORT)), AllTrim(SLG->LG_RPCENV),;
			SLG->LG_RPCEMP, SLG->LG_RPCFIL, aProd) } )
		Else

		EndIf
		aProd := aSort(aProd,,,{|x,y| x[2] < y[2] })
		oLbx:SetArray(aProd)
		oLbx:Refresh()
	Else
		MsgInfo("Produto nao encontrado")
		oGetPesq:SetFocus()
		oGetPesq:Refresh()
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบFuncao    ณIA223ImpRecibo    ณAutor  ณMarcos Alves   บ Data ณ18/03/2015 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณImpessao do vale de compra dos Funcionarios				  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223ImpRecibo()
	Local cString :=""
	Local aAreaSL2 		:= SL2->(GetArea())
	Local cNomeCli:=Alltrim(SA1->A1_NOME)
	Local cNomeVnd:=Alltrim(Subs(Posicione("SA3",1,xFilial("SA3")+SL1->L1_VEND,"A3_NOME"),1,20))
	Local nPos:=0
	Local dVenc:=SL4->L4_DATA
	Local cCaixa	:=xNumCaixa()																//Codigo do caixa

	ProcRegua(3)
	cString+="================================================"+Chr(13)+Chr(10)
	cString+="...........Vale Compra Funcionario.........v.1.0"+Chr(13)+Chr(10)
	cString+="Loja...........:"+SM0->M0_CODFIL+" "+SM0->M0_FILIAL+" "+Chr(13)+Chr(10)
	cString+="Data           :"+dToc(dDataBase)+"           Hora:"+Time()+Chr(13)+Chr(10)
	cString+="Caixa..........:"+cCaixa+"-"+cUserName+Chr(13)+Chr(10)
	cString+="================================================"	+Chr(13)+Chr(10)
	cString+="---------[VALE DE COMPRA "+SL1->L1_DOC+"/"+SL1->L1_SERIE+"]---------"+Chr(13)+Chr(10)
	cString+="EU, "+Subs(SA1->A1_NOME,1,25)+" CPF "+Subs(SA1->A1_CGC,1,3)+"."+Subs(SA1->A1_CGC,4,3)+"."+Subs(SA1->A1_CGC,7,3)+"-"+Subs(SA1->A1_CGC,10,2)+Chr(13)+Chr(10)
	cString+="AUTORIZO A  DESCONTAR DE MEU SALARIO EM:"+dToc(SL4->L4_DATA)+Chr(13)+Chr(10)
	cString+="A IMPORTANCIA DE: "+Transform(SL1->L1_VLRLIQ,"@E 999.99")+Chr(13)+Chr(10)
	cString+="REFERENTE A COMPRA DO(OS) PRODUTO(OS):"+Chr(13)+Chr(10)

	dbSelectArea("SL2")
	dbSetOrder(1)
	//Recuperando os itens da venda selecionados.
	SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
	While SL2->(!Eof()).AND.(xFilial("SL2")==SL2->L2_FILIAL).AND.(SL2->L2_NUM==SL1->L1_NUM)
		//------------------------------------------------
		//XXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXX,XXX
		cString+=Subs(SL2->L2_PRODUTO,1,5)+" "+Subs(SL2->L2_DESCRI,1,30)+" "+ Transform(SL2->L2_QUANT,"@E 999.999")+Chr(13)+Chr(10)
		SL2->(dbSkip())
	End
	IncProc()
	nPos:=(44-Len("Atendente - "+cNomeVnd))/2
	cString+="                                                "+Chr(13)+Chr(10)
	cString+="------------------------------------------------"+Chr(13)+Chr(10)
	cString+=space(nPos)+"Atendente - "+cNomeVnd+Chr(13)+Chr(10)

	nPos:=(44-Len("Comprador - "+cNomeCli))/2
	cString+="                                                "+Chr(13)+Chr(10)
	cString+="------------------------------------------------"+Chr(13)+Chr(10)
	cString+=space(nPos)+"Comprador - "+cNomeCli+Chr(13)+Chr(10)

	//U_F1299Inno("F")
	nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
	IncProc()

	If (nRet == 0 .OR. nRet == 7)
		If (nRet := IFRelGer(nHdlECF, cString)) <> 0
			// "Nใo foi possํvel realizar a Abertura do Caixa. Erro na impressใo do comprovante.", "Aten็ใo"
			HELP(' ',1,'FRT021')
		EndIf
	EndIf
	IncProc()

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณI17AltCli ณ Autor ณ Marcos Alves          ณ Data ณ24/04/15  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Alteracao do Cliente	(F10)                                 ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223AltCli(oDlgInno,oCliente)
	Local cCliFrt 		:= INNO_CLI
	Local cLojFrt 		:= INNO_LOJ
	Local cNomeCli 		:= Subst(Posicione("SA1",1,xFilial("SA1")+INNO_CLI+INNO_LOJ,"A1_NOME"),1,30)
	Local lRet          := .T.						// Define se prossegue a operacao

	oCliente:Enable()
	oCliente:SetFocus()
	oCliente:Refresh()

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบFuncao    ณFRT010CL		   ณAutor  ณMarcos Alves   บ Data ณ25/03/2015 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada utilizado no FRTA271E, validar o cliente   บฑฑ
ฑฑบDesc.     ณselecionado no F10 - definir cliente para venda             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223ConsSld(cCodCli,oDlgInno,oCliente,oNomeCli,cNomeCli,oCodProd)
	Local lRet		:=.T.
	Local nLC		:= 0
	Local nSalDup	:= 0
	Private aPosCli	:= {}

	If cCodCli<>INNO_CLI
		INNO_SALD=0
	EndIf

	cNomeCli:=Posicione("SA1",1,xFilial("SA1")+cCodCli+INNO_LOJ,"A1_NOME")
	oNomeCli:Refresh()
	oDlgInno:Refresh()
	INNO_CLI:=cCodCli

	//oCliente:Disable()
	//oCodProd:SetFocus()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ 25/03/15 - Verificar saldo disponivel do cliente  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SA1->A1_LC>0.AND.INNO_SALD=0
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ 28/03/15 - Verificar se esta na data para receber o benefcioณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If SA1->A1_VENCLC>dDataBase.OR.Empty(SA1->A1_VENCLC)
			Aviso( "Atencao!", " O cliente s๓ poder้ usufruir do beneficio a partir de: "+dToC(SA1->A1_VENCLC), { "Ok" }, 2,"Fora do perํodo do Beneficio")
			Return .F.
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ 26/03/15 - Verificar se tem venda a serem enviada para retaguardaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SL1")
		dbSetOrder(9)
		If dbSeek(xFilial()+"00")
			While L1_FILIAL+L1_SITUA == xFilial()+"00" .And. !EOF()
				// Caso o Cliente ainda nao tenha sido gravado na Retaguarda, tenta o proximo SL1.
				If SL1->L1_CLIENTE==INNO_CLI.AND.SL1->L1_LOJA==INNO_LOJ
					Aviso( "Atencao!", " Existe(m) venda(s) pendente(s) para a ser transmitida para a DI."+chr(10)+chr(13)+" a verificacao do saldo s๓ sera possivel ap๓s esta(s) transmissใo";
					+chr(10)+chr(13)+"Verifique a conexใo de rede e tente mais tarde", { "Ok" }, 2,"Vendas pendente de transmissใo")
					Return .F.
				EndIf
				SL1->(dbSkip())
			End
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChama a fun็ใo para conexใo com as lojas               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		LjMsgRun( "Aguarde ... Consultando saldo disponivel no servidor..."+AllTrim(SLG->LG_RPCSRV),,; // "Aguarde ... Consutando loja "
		{|| aPosCli := U_IA201ConsRPC(SA1->A1_COD, SA1->A1_LOJA) } )
		If Len(aPosCli)>0
			nLC			:=aPosCli[1]
			nSalDup		:=aPosCli[2]
			INNO_SALD	:=nLC-nSalDup
			Aviso( "Atencao!","Total em compras pendentes :"+Transform(nSalDup,PesqPict("SA1", "A1_LC",10,1)) + Chr(13)+chr(10)+ "Saldo disponivel....................: "+Transform(INNO_SALD,PesqPict("SA1", "A1_LC",10,1)), { "Ok" }, 2,"Saldo Disponivel:")
		Else
			Aviso( "Atencao!", " Nใo foi possivel efetuar a consulta do saldo disponivel. Verifique a conexao de rede ou tente mais tarde.", { "Ok" }, 2,"Falha na consulta do Saldo")
			Return .F.
		EndIf
		If INNO_SALD<=0
			lRet:=.F.
		EndIf
		If lRet
			oDlgInno:nClrPane:=CLR_MAGENTA //8388736	//CLR_MAGENTA   - COLORS.CH
		EndIf
	EndIf
	If SA1->A1_LC=0
		oDlgInno:nClrPane:=CLR_RED	//CLR_MAGENTA   - COLORS.CH
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออัอออออออัอออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณIA223IncTef       ณAutor  ณMarcos Alves   บ Data ณSet/2017   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออฯอออออออฯอออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณInserir o numero do documento e numero da autorizacao cupom บฑฑ
ฑฑบ          ณMaquineta cartao                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223IncTef(cCartao,oDlg,nLin,aVendas)
	Local nOpc			:=0
	Local dData
	Local cForma
	Local cAdmin
	Local cHora
	Local nValor
	Local cDoc
	Local cTicket
	Local cAut
	Local oDocTef

	If aVendas[nLin,1]<>5
		SL1->(DbGoto(aVendas[nLin,11]))
		SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
		While !SL4->(eOF()).AND.xFilial("SL4")+SL1->L1_NUM==SL4->L4_FILIAL+SL4->L4_NUM

			If !(AllTrim(SL4->L4_FORMA)$"CD#CC#VA")
				SL4->(DbSkip())
				Loop
			EndIf
			dData	:=dDataBase
			cAdmin	:=ALLTRIM(SL4->L4_ADMINIS) 
			cForma	:=ALLTRIM(SL4->L4_FORMA)
			cHora	:=SL1->L1_HORA
//			nValor	:=SL4->L4_VALOR
			nValor	:= 0
			cDoc	:=SL4->L4_DOCTEF
			cAut	:=SL4->L4_AUTORIZ
			cTicket:=If(cForma=="VA",Subs(SL4->L4_INSTITU,1,1),"N")
			
			DEFINE MSDIALOG oDocTef FROM 1,1 TO 260,200 TITLE "Documento/Autorizacao" PIXEL OF GetWndDefault()	// "Forma de Pagamento"
			DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -9 BOLD
			@ 07, 10 SAY + If(SL4->L4_SITUA=="ER","* ","")+cAdmin SIZE 110,10 FONT oFont COLOR CLR_BLUE,CLR_WHITE OF oDocTef PIXEL
			nLinha:=20
			@ nLinha, 10 SAY "Data" SIZE 30,10 OF oDocTef PIXEL	//"Data"
			@ nLinha, 50 MSGET oData VAR dData	SIZE 30,10 OF oDocTef PIXEL WHEN  .F.
			nLinha += 15

			@ nLinha, 10 SAY "Hora"	SIZE 35,15 OF oDocTef PIXEL
			@ nLinha, 50 MSGET oHora VAR cHora	PICTURE "@E 99:99" RIGHT SIZE 30,10 OF oDocTef PIXEL WHEN .F.
			nLinha += 15

			@ nLinha, 10 SAY "Valor" SIZE 30,10 OF oDocTef PIXEL	// "Valor"
			@ nLinha, 50 MSGET oValor	VAR nValor	   	PICTURE "@E 999999.99"  SIZE 30,10 OF oDocTef PIXEL //WHEN .F.  //PICTURE "@E 999999.99"
			nLinha += 16

			@ nLinha, 10 SAY "Documento" SIZE 30,10 OF oDocTef PIXEL	// "Documento"
			@ nLinha, 50 MSGET oDoc		VAR cDoc	   	PICTURE "@E 999999" SIZE 30,10 OF oDocTef PIXEL
			nLinha += 15

			@ nLinha, 10 SAY "Autorizacao" SIZE 30,10 OF oDocTef PIXEL	// "Autorizacao"
			@ nLinha, 50 MSGET oAut		VAR cAut	   	PICTURE "@!" SIZE 30,10 OF oDocTef PIXEL
			nLinha += 15

			@ nLinha, 10 SAY "Ticket (S/N)?" SIZE 40,10 OF oDocTef PIXEL	// "Autorizacao"
			@ nLinha, 50 MSGET oTicket		VAR cTicket	   	PICTURE "@!" SIZE 10,10 OF oDocTef PIXEL WHEN cForma=="VA" VALID cTicket$"S#N#s#n"
			nLinha += 15

			DEFINE SBUTTON FROM nLinha+5,30 TYPE 1 ENABLE ACTION If(IA223TefVld(1, cDoc, cAut, nValor, cTicket),(nOpc:=1,oDocTef:End()),) OF oDocTef
			DEFINE SBUTTON FROM nLinha+5,60 TYPE 2 ENABLE ACTION ( nOpc:=2,oDocTef:End()) OF oDocTef
			ACTIVATE MSDIALOG oDocTef CENTER 

			If nOpc==1
				SL4->(Reclock("SL4",.F.))
				SL4->L4_DOCTEF	:=cDoc
				SL4->L4_AUTORIZ	:=cAut
				SL4->L4_INSTITU := cTicket
				SL4->L4_SITUA	:= "00"
				SL4->( dbCommit() )
				SL4->( MsUnlock() )
			EndIf
			SL4->(DbSkip())
		End
		If nOpc==1
			aVendas[nLin,4]:=cDoc
			aVendas[nLin,5]:=cAut
			SL1->(Reclock("SL1",.F.))
			SL1->L1_DOCTEF:=cDoc
			SL1->L1_AUTORIZ:=cAut
			//SL1->L1_SITUA	:= "00"
			SL1->( dbCommit() )
			SL1->( MsUnlock() )
		EndIf
	Else  //Sinal de Encomenda
		SZT->(DbGoto(aVendas[nLin,11]))
		SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))
		While !SZS->(eOF()).AND.xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO==SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO
			If !(AllTrim(SZS->ZS_FORMA)$"CD#CC#VA")
				SZS->(DbSkip())
				Loop
			EndIf
			dData	:=dDataBase
			cAdmin	:=ALLTRIM(SZS->ZS_ADMINIS)
			cForma	:=ALLTRIM(SZS->ZS_FORMA)
			cHora	:=SZT->ZT_HORA
			cDoc	:=SZS->ZS_DOCTEF
			cAut	:=SZS->ZS_AUTORIZ
			cTicket:=If(cForma=="VA",Subs(SZS->ZS_PARCELA,1,1),"N")
			nValor	:=0

			//DEFINE MSDIALOG oDocTef FROM 1,1 TO 240,200 TITLE "Documento/Autorizacao" PIXEL OF GetWndDefault()	// "Forma de Pagamento"
			DEFINE MSDIALOG oDocTef FROM 1,1 TO 260,200 TITLE "Documento/Autorizacao" PIXEL OF GetWndDefault()	// "Forma de Pagamento"
			DEFINE FONT oFont NAME "MS Sans Serif" SIZE 0, -9 BOLD
			@ 07, 10 SAY cAdmin SIZE 110,10 FONT oFont COLOR CLR_BLUE,CLR_WHITE OF oDocTef PIXEL
			nLinha:=20
			@ nLinha, 10 SAY "Data" SIZE 30,10 OF oDocTef PIXEL	//"Data"
			@ nLinha, 50 MSGET oData VAR dData	SIZE 30,10 OF oDocTef PIXEL WHEN  .F.
			nLinha += 15

			@ nLinha, 10 SAY "Hora"	SIZE 35,15 OF oDocTef PIXEL
			@ nLinha, 50 MSGET oHora VAR cHora	PICTURE "@E 99:99" RIGHT SIZE 30,10 OF oDocTef PIXEL WHEN .F.
			nLinha += 15

			@ nLinha, 10 SAY "Valor" SIZE 30,10 OF oDocTef PIXEL	// "Valor"
			@ nLinha, 50 MSGET oValor	VAR nValor	   	PICTURE "@E 999999.99"  SIZE 30,10 OF oDocTef PIXEL PICTURE "@E 999999.99"
			nLinha += 17

			@ nLinha, 10 SAY "Documento" SIZE 30,10 OF oDocTef PIXEL	// "Documento"
			@ nLinha, 50 MSGET oDoc		VAR cDoc	   	PICTURE "@E 999999" SIZE 30,10 OF oDocTef PIXEL
			nLinha += 15

			@ nLinha, 10 SAY "Autorizacao" SIZE 30,10 OF oDocTef PIXEL	// "Autorizacao"
			@ nLinha, 50 MSGET oAut		VAR cAut	   	PICTURE "@!" SIZE 30,10 OF oDocTef PIXEL
			nLinha += 15

			@ nLinha, 10 SAY "Ticket (S/N)?" SIZE 40,10 OF oDocTef PIXEL	// "Autorizacao"
			@ nLinha, 50 MSGET oTicket		VAR cTicket	   	PICTURE "@!" SIZE 10,10 OF oDocTef PIXEL WHEN cForma=="VA" VALID cTicket$"S#N#s#n"
			nLinha += 15

			DEFINE SBUTTON FROM nLinha+5,30 TYPE 1 ENABLE ACTION If(IA223TefVld(2, cDoc, cAut, nValor, cTicket),(nOpc:=1,oDocTef:End()),) OF oDocTef
			DEFINE SBUTTON FROM nLinha+5,60 TYPE 2 ENABLE ACTION ( nOpc:=2,oDocTef:End()) OF oDocTef
			ACTIVATE MSDIALOG oDocTef CENTER

			If nOpc==1
				SZS->(Reclock("SZS",.F.))
				SZS->ZS_DOCTEF:=cDoc
				SZS->ZS_AUTORIZ:=cAut
				SZS->ZS_PARCELA:=cTicket
				SZS->ZS_SITUA	:= "00"
				SZS->( dbCommit() )
				SZS->( MsUnlock() )
			EndIf
			aVendas[nLin,4]:=cDoc
			aVendas[nLin,5]:=cAut
			SZS->(DbSkip())
		End
	EndIf
Return .F.


Static Function IA223TefVld(nOpc, cDoc, cAut, nValor, cTicket)
Local cMsg	:= ""
Local lRet 	:= .T.
Local aAreaSL4 	:= SL4->(GetArea())
Local aAreaSZS 	:= SZS->(GetArea())

If Empty(cDoc)
	cMsg+="> Documento"+CHR(13)+CHR(10)
Else
	SL4->(DbOrderNickName("L4_DOCTEF")) //L4_FILIAL + L4_DOCTEF
	If SL4->(dbSeek(xFilial("SL4")+cDoc)).and.SL4->(recno())<>aAreaSL4[3]
		cMsg+="> Documento ja cadastro - Venda: " + "Data: "+DTOC(SL4->L4_DATA)+" Numero: "+SL4->L4_NUM+CHR(13)+CHR(10)
	EndIf
	RestArea( aAreaSL4 )

	SZS->(DbOrderNickName("ZS_DOCTEF")) //L4_FILIAL + L4_AUTORIZ
	If SZS->(dbSeek(xFilial("SZS")+cDoc)).and.SZS->(recno())<>aAreaSZS[3]
		cMsg+="> Documento ja cadastro - Sinal: " + "Talao: "+SZS->ZS_TALAO+" Pedido: "+SZS->ZS_PEDIDO+CHR(13)+CHR(10)
	EndIf
	RestArea( aAreaSZS )
EndIf
If Empty(cAut)
	cMsg+="> Autorizacao"+CHR(13)+CHR(10)
Else
	SL4->(DbOrderNickName("L4_AUTORIZ")) //L4_FILIAL + L4_AUTORIZ
	If SL4->(dbSeek(xFilial("SL4")+cAut)).and.SL4->(recno())<>aAreaSL4[3]
		cMsg+="> Autoriza็ใo ja cadastro - Venda: " + "Data: "+DTOC(SL4->L4_DATA)+" Numero: "+SL4->L4_NUM+CHR(13)+CHR(10)
	EndIf
	RestArea( aAreaSL4 )
	
	SZS->(DbOrderNickName("ZS_AUTORIZ")) //L4_FILIAL + L4_AUTORIZ
	If SZS->(dbSeek(xFilial("SZS")+cAut)).and.SZS->(recno())<>aAreaSZS[3]
		cMsg+="> Autorizacao ja cadastro - Sinal: "+"Talao: "+SZS->ZS_TALAO+" Pedido: "+SZS->ZS_PEDIDO+CHR(13)+CHR(10)
	EndIf
	RestArea( aAreaSZS )
EndIf
If nOpc=1
	If SL4->L4_VALOR <> nValor
		cMsg+='> Valor'+CHR(13)+CHR(10)
	EndIf
EndIf

If nOpc=2
	If SZS->ZS_VALOR <> nValor
		cMsg+='> Valor'+CHR(13)+CHR(10)
	EndIf
EndIf

If Empty(cTicket)
	cMsg+="> Ticket nใo definido"+CHR(13)+CHR(10)
EndIf

If !Empty(cMsg)
	lRet:=MsgNoYes("Dados Invalidos : "+CHR(13)+CHR(10)+cMsg+"Continua?" )
EndIf

Return lRet


Static Function IA223Foto(oCupom,oFotoProd,nOp,lCupomFocus,oCodProd)

	Local cCodProd	:=""
	Local nPos		:=oCupom:nAt

	If nOp==1
		oCupom:Add("--------------------------------------------------------------------------")
		oCupom:nAt:=nPos
		lCupomFocus:=.T.
	ElseIf nOp==3
		oCupom:Del(Len(oCupom:aItems))
		nPos:=Len(oCupom:aItems)
		cCodProd:=Subs(oCupom:aItems[nPos],5,5)
		If Val(cCodProd)<>0
			IA223VldProd(cCodProd,@oFotoProd)
		EndIf
		lCupomFocus:=.F.
		oCodProd:SetFocus()
		Return NIL
	EndIf
	If nPos>30.And.lCupomFocus
		If Subs(oCupom:aItems[nPos],5,5)=='-----'
			lCupomFocus:=.F.
			oCupom:Del(nPos)
			oCodProd:SetFocus()
			Return NIL
		EndIf
		cCodProd:=Subs(oCupom:aItems[nPos],5,5)
		If Val(cCodProd)<>0
			IA223VldProd(cCodProd,@oFotoProd)
		EndIf
	EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ IA223ValDescณ Autor ณ Marcos Alves          ณ Data ณ 03/05/2020 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Verifica se o vendedor pode dar desconto, caso contrario pede a ณฑฑ
ฑฑณ          ณ senha do supervisor para liberacao do desconto                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpN1 -  Define de qual Get estah sendo chamada a funcao        ณฑฑ
ฑฑณ          ณ          1 = Porcentagem                                        ณฑฑ
ฑฑณ          ณ          2 = Valor                                              ณฑฑ
ฑฑณ          ณ ExpN2 - Valor do Percentual de Desconto                         ณฑฑ
ฑฑณ          ณ ExpN3 - Valor do Desconto                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Retorno  ณ ExpL1 - Valida ou nao o percentual de desconto                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SigaFrt                                                         ณฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                      	       บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                                 บฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IA223ValDesc( nTipo, nPerDesc, nVlrDesc )
Local lRet       := .F. // Retorno da funcao
Local aDesc      := {}  // array que informa se esta validando Percentual ou Valor

If (nPerDesc >= 0) .OR. (nVlrDesc >= 0)
	If nTipo == 1             //-- Chamado a partir do GET da porcentagem.
		aDesc := { "P", nPerDesc }
	ElseIf nTipo == 2         //-- Chamado a partir do GET do valor.
		aDesc := { "V", nVlrDesc }
	EndIf
    lRet := LJProfile(11, NIL, aDesc, nPerDesc, nVlrDesc)
EndIf

Return (lRet)


User FUNCTION FRTDESCVEN()
Local aRet:={.T.,nValorDesc}

Return aRet

/*
Descri็ใo:
Ponto de entrada chamado para formas de pagamento com m๚ltiplas transa็๕es TEF.

FRTFORMPAG- Pagamento com m๚ltiplas transa็๕es ( [ ExpA1 ], [ ExpC2 ], [ ExpC3 ], [ ExpC4 ], [ ExpN5 ], [ ExpN6 ] ) --> aRetFormPag
Parโmetros:
Nome			Tipo			Descri็ใo			Default			Obrigat๓rio			Refer๊ncia	
ExpA1			Array of Record			1 - Forma de pagamento										
ExpC2			Caracter			Descri็ใo da forma de pagamento										
ExpC3			Caracter			Forma de pagamento										
ExpC4			Caracter			Grupo										
ExpN5			Num้rico			Valor total										
ExpN6			Num้rico			Valor total do desconto										
Retorno
aRetFormPag(array_of_record)
descri็ใo abaixo
Observa็๕es

RETORNO : Array
Posi็๕es da array aRetFormPag
1 - L๓gico - Define se a janela com os valores desejados deve ou nใo ser exibida
2 - Caracter - Forma de pagamento
4 - Date - Data do vencimento da parcela
5 - Num้rico - N๚mero de parcelas
6 - Num้rico - Taxa de juros
7 - Num้rico - N๚mero de intervalos
8 - Num้rico - Valor da parcela
9 - Caracter - ID Cartใo
10- Num้rico - Valor do desconto a ser aplicado no total do cupom fiscal
11- Num้rico - Valor total do cupom fiscal
*/
User Function FRTFORMPAG() //POnto de Entrada
Local aFormPag    := PARAMIXB[1]
Local cDesc       := PARAMIXB[2]
Local cForma      := Alltrim(PARAMIXB[3])
Local cGrupo      := PARAMIXB[4]
Local nVlrTotal   := PARAMIXB[5]
Local _aPgtos     := PARAMIXB[7]
Local aRetFormPag :={} // Retorno do Ponto de Entrada
Local nPos		  := 0
Local nValor 	  := 0
Local dData		  := dDataBase

If cForma=="R$" .OR. cForma=="VA"
	For nI:=1 to Len(INNO_APGTOS)
		If INNO_APGTOS[nI,3]==cForma
			nValor += INNO_APGTOS[nI,2]
			INNO_APGTOS[nI,13]	:= 1
			dData := INNO_APGTOS[nI,1]
		EndIf
	Next nI	
Else		
	nPos:= Ascan( INNO_APGTOS,{|X| Alltrim(X[3]) ==cForma.AND.X[13]==0})
	If nPos<>0
		nValor:=INNO_APGTOS[nPos,2]
		dData := INNO_APGTOS[nPos,1]
		INNO_APGTOS[nPos,13]:=1
	EndIf
EndIf


aRetFormPag := { .F., cForma, cDesc, dData, 1, 0, 30, nValor, StrZero(nPos,1),nValorDesc,nVlrTotal+nVlrAcrescimo }

Return(aRetFormPag)

Static Function IA223Tab(oDlgInno)
nIfood:=If(nIfood=1,2,1)
oDlgInno:nClrPane:=If(niFood==1,CLR_HRED, If(INNO_IMP[1]== "I",CLR_HBLUE,CLR_RED))
oDlgInno:Refresh()

Return .T.



/*
Ponto-de-Entrada: FRTQUANT - Altera็ใo de valor unitแrio e quantidade
Descri็ใo:
O ponto de entrada FRTQUANT ้ chamado ap๓s a realiza็ใo da pesquisa e valida็ใo do produto digitado.
Programa Fonte
Sintaxe
FRTQUANT - Altera็ใo de valor unitแrio e quantidade ( < aPar> ) --> aRet
*/
User Function FRTQUANT()
Local nQuant:=PARAMIXB[1]
//Local nQuant:=0
//Local nVlrUnit:=11
RETURN {nQuant,If(nIfood=1,SBI->BI_PRV2,SBI->BI_PRV)}
