#INCLUDE "PROTHEUS.CH"
#Include "FILEIO.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ F1298Inno      ³ Autor ³ Marcos Alves    ³ Data ³22/08/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ 98 - Relatorio de fechamento diario						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ F1298Inno(nHdlECF,cPdv)							     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FrontLoja - Innocencio   								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Progr.   ³ Data        Descricao								      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos    ³22/02/08³Criacao 									          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA007F1298(nHdlECF)
Local cTipo		:=INNO_V03									// Flag de identificacao da impressora ativa
Local cPDV		:="0000"									// PDV fiscal
//Local cSemana	:=aSemana[Dow(dDataBase)]					//Identifica qual o dia da semana
Local cSemana	:=""										//Identifica qual o dia da semana
Local cCaixa	:=xNumCaixa()								//Codigo do caixa
Local cNome		:=xNumCaixa()								//Codigo do caixa

Local cPdv99	:=INNO_PDV									 //Numero do PDV - Emulator - Fonte INNO_002 - Inicializa as variaveis publicas
Local cPdv		:=INNO_ECF									// Numero do PDV - fiscal Fonte INNO_002 - Inicializa as variaveis publicas

Local cPath 	:= "\FECHAMENTO\"	// Caminho para 
Local cFile		:=""
Local dDataInno	:=dDataBase								// Data da emissao do fechamento
Local oChkPgto	 										// Objeto do Lista detalhe da forma de pagamento no relatorio
Local lChkPgto	:=.F.									// Checkbox da Forma Lista detalhe da forma de pagamento no relatorio
Local oFechaCR											// Objeto do Tipo do fechamento Completo/Resumido
Local nFechaCR:=2

Local cCaixaSup := Space(15)

Private aString		:={}										// Array com as linhas do layout do fechamento
Private nPosInno	:={}										// Array com as linhas do layout do fechamento

Private oTotDin
Private oTotCart

Private nTotDin		:=0
Private nTotCart	:=0
Private lSenhaRel	:=.F.
Private nFecha		:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para o caixa digitar os valores                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IA007Tela(@cCaixa,@cNome,@dDataInno,oChkPgto,@lChkPgto,oFechaCR,@nFechaCR,@cCaixaSup,cPDV,cPdv99,nHdlECF)		//Tela de digitacao

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA007Corpo ³ Autor ³ Marcos Alves	     ³ Data ³ 08/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Monta a estrutura do fechamento do caixa                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA007Corpo(cPDV,cPdv99,cCaixa,cSemana)                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA007Corpo(cPDV,cPdv99)
Local aAreaSLG		

aString		:={}	// Array com as linhas do layout do fechamento

aadd(aString,{"A1","================================================"	,{}})
aadd(aString,{"A2","v7.0...........Fechamento Diario.............AAA"	,{"001"},{"@E 999"}})
aadd(aString,{"A3","                                                "	,{}})
aadd(aString,{"A4","Data AAA       :BBB          Hora....:CCC     "	,{"","",""},{}})
aadd(aString,{"A5","Caixa..........:AAA                             "	,{""},{}})
aadd(aString,{"A6","================================================"	,{}})

aadd(aString,{"AO","---------------------[Vendas]-------------------"	,{}})
aadd(aString,{"AP","Venda Bruta...........[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"AQ","Descontos.............[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"AR","Cancelamentos.........[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"D5","Outros................[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"AS","Venda Liquida.........[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"AT","-------------[Recebimentos Vendas(A)]-----------"	,{}})
aadd(aString,{"AU","Dinheiro..............[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"AV","Cheque(*).............[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"F1","Cartoes...............[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"FA","Vale Innocencio.......[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"G0","Sinal Encomenda.......[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"IF","Ifood.................[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"PX","Pix...................[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"B6","Outros................[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"AY","Recebimento Vendas....[AAA]:BBB     ......[CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"B5","-------------[Movimentos do caixa]--------------"	,{}})
aadd(aString,{"BC","Recebimentos Vendas...[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"AZ","Entrada de Troco(*)...[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"					}}) 
aadd(aString,{"B9","Receb.Antecipado.(*)..[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"					}}) 
aadd(aString,{"B2","Sangrias(*)...........[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"B7","Despesas(*)...........[AAA]:BBB                 "	,{0,0},{"@E 999","@E 99,999.99"}}) 
aadd(aString,{"B8","Saldo......................:AAA                 "	,{0},{"@E 99,999.99"}}) 
aadd(aString,{"C1","------------[Numerários no Caixa]---------------"	,{}})
aadd(aString,{" ","                             Proces.     Diverg. "	,{}})
aadd(aString,{" ","                            --------- ----------"	,{}})
aadd(aString,{"C2","Dinheiro...................:AAA          BBB   "	,{0,0}	,{"@E 99,999.99","@E 9999.99"}			,{0,0}}) 
aadd(aString,{"C3","Cheque(*).............[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aadd(aString,{"G1","Cartao de credito.....[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aadd(aString,{"G2","Cartao de Debito......[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aadd(aString,{"G3","Voucher...............[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aadd(aString,{"C6","Vale Innocencio.......[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aadd(aString,{"G4","Sinal Encomenda.......[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) // somente SL4 - Vendas
aadd(aString,{"G6","Ifood.................[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) // somente SL4 - Vendas
aadd(aString,{"PI","Pix...................[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) // somente SL4 - Vendas
aadd(aString,{"G5","Outros................[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aadd(aString,{"  ","                            --------- ----------"	,{}})
aadd(aString,{"EJ","...........................:AAA          BBB   "	,{0,0}	,{"@E 99,999.99","@E 9999.99"}			,{0,0}}) 
aadd(aString,{"XB","-----------[Detalhes dos Atendimentos]----------"	,{}})
aadd(aString,{"XD","    Atendente       Atend.     Valor       Part.",{},{}}) 
aadd(aString,{"XE","-------------------- -----  -----------   ------",{},{}}) 
aadd(aString,{"XF","                     -----  -----------   ------",{},{}}) 
aadd(aString,{"XG","                     AAA    BBB           [CCC%]",{0,0,0},{"@E 99999","@E 9999,999.99","@R 999"}}) 
aadd(aString,{"XC","------------[Detalhes das Vendas Hora]----------"	,{}})
aadd(aString,{"XH","Periodo Cli.  Itens    Valor     TM        Part.",{},{}}) 
aadd(aString,{"XI","-------- --- ------  ---------- ------    ------",{},{}}) 
aadd(aString,{"XJ","-------- --- ------- ---------- ------    ------",{},{}}) 
aadd(aString,{"XK","AAh      BBB  CCC    DDD        EEE       [FFF%]",{0,0,0,0,0,0},{"@E 99","@E 999","@E 9999.99","@E 999,999.99","@E 999.99","@R 999"}}) 
aadd(aString,{"XL","--------------[Sangria / Troco]-----------------"	,{}})
aadd(aString,{"XM","    Numerario        Documento     Valor     S/T",{},{}}) 
aadd(aString,{"XN","-------------------- ----------- ----------- ---",{},{}}) 
aadd(aString,{"XO","-------------------[Despesas]-------------------"	,{}})
aadd(aString,{"XP"," Titulo           Fornecedor            Valor   ",{},{}}) 
aadd(aString,{"XQ","--------- -------------------------- -----------",{},{}}) 
aadd(aString,{"FB","---------------[Venda Funcionario]--------------",{},{}})
aadd(aString,{"FC","Codigo Nome       Titulo        F.     Valor    ",{},{}})   
aadd(aString,{"FD","------ ---------- ------------- --  ------------",{},{}})
aadd(aString,{"FF","                                     AAA        ",{0},{"@E 9999,999.99"}}) 
aadd(aString,{"S1","--------------[Sinal de Encomenda]--------------",{},{}})
aadd(aString,{"S2","T.  Ped.Cupom        Numerario         Valor    ",{},{}})   
aadd(aString,{"S3","--- --- ------ ------------------------ --------",{},{}})
aadd(aString,{"  ","                                        --------"	,{}})

aadd(aString,{"SR","  R$      CC      CD      VH     PIX            ",{},{}})
aadd(aString,{"SR","------- ------- ------- ------- -------  -------",{},{}})
aadd(aString,{"SC","AAA     BBB     CCC     DDD     EEE      FFF    ",{0,0,0,0,0,0},{"@E 9999.99","@E 9999.99","@E 999.99","@E 999.99","@E 999.99","@E 999.99"}}) 


aadd(aString,{"Z1","----------------[Vendas Delivery]---------------",{},{}})
aadd(aString,{"Z2","Tipo               Qtd    Valor      Entrega    ",{},{}})   
aadd(aString,{"Z3","----------------- ----- -----------  -----------",{},{}})

aadd(aString,{"P1","----------------[Recebimento PIX]---------------",{},{}})
aadd(aString,{"P2","Hora    Doc       Valor      Tipo (V/S )        ",{},{}})   
aadd(aString,{"P3","-----  -------- -----------  ---------          ",{},{}})
    
aadd(aString,{"S4","---------[Sinal de Encomenda em Aberto]---------",{},{}})
aadd(aString,{"S5","     T. Pedido   Data    Retirar   Valor        ",{},{}})   
aadd(aString,{"S6","     --- ------ -------- -------- -----------   ",{},{}})


aadd(aString,{"A7","------------[Indicadores Geral]-----------------"	,{}})
aadd(aString,{"A8","Clientes ..................:AAA                 "	,{0},{"@E 999999"}							})
aadd(aString,{"D4","Valor......................:AAA                 "	,{0.00},{"@E 99,999.99"}	})
aadd(aString,{"A9","Itens Vendidos.............:AAA                 "	,{0},{"@E 999999"}							})
aadd(aString,{"A0","Media Itens por Vendas.....:AAA                 "	,{0},{"@R 999999.99"}							})
aadd(aString,{"AA","Ticket Medio...............:AAA                 "	,{0},{"@E 999999.99"}						})
aadd(aString,{"H1","Itens orcamentos ..........:AAA                 "	,{0},{"@E 999999"}							})
aadd(aString,{"H2","Itens orcamentos.(*).......:AAA                 "	,{0},{"@E 999999"}							})
aadd(aString,{"AB","--------------[Indicadores AAA  ]---------------"	,{cPDV},{"@E 9999"}						})
aadd(aString,{"AD","Cupom Inicio...............:AAA                 "	,{"999999999"},{}							})
aadd(aString,{"AE","cupom Final................:AAA                 "	,{"000000000"},{}							})
aadd(aString,{"AC","Cupons.....................:AAA           [BBB%]"	,{0,0.00},{"@E 9999999","@R 999"}		})
aadd(aString,{"AF","Valor......................:AAA           [BBB%]"	,{0,0.00},{"@E 99,999.99","@R 999"}	})
aadd(aString,{"D1","Valor N(CRD/NFP)......[AAA]:BBB           [CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"AH","NFP........................:AAA           [BBB%]"	,{0,0.00},{"@E 99,999","@R 999"}	})
aadd(aString,{"AI","--------------[Indicadores "+cPdv99+"]----------------"	,{}})
aadd(aString,{"AK","Inicio.....................:AAA                 "	,{"999999999"},{}				})
aadd(aString,{"AL","Final......................:AAA                 "	,{"000000000"},{}				})
aadd(aString,{"AJ","Cupons.....................:AAA           [BBB%]"	,{0,0.00},{"@E 9999999","@R 999"}		})
aadd(aString,{"AM","Valor......................:AAA           [BBB%]"	,{0,0.00},{"@E 99,999.99","@R 999"}		})
aadd(aString,{"D2","Valor CRD.............[AAA]:BBB           [CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"D6","Reimpressao...........[AAA]:BBB           [CCC%]"	,{0,0,0.00},{"@E 999","@E 99,999.99","@R 999"}}) 
aadd(aString,{"C7","-----------[Transmissao Retaguarda]-------------"	,{}})
aadd(aString,{" ","                               Total   Nao Trans."	,{}})
aadd(aString,{" ","                             --------- ----------"	,{}})
aadd(aString,{"CB","Vendas.....................:AAA       BBB       "	,{0,0},{"@E 999999999","@E 999999999"}}) 
aadd(aString,{"CA","Cancelados.................:AAA       BBB       "	,{0,0},{"@E 999999999","@E 999999999"}}) 
aadd(aString,{"CP","Despesas...................:AAA       BBB       "	,{0,0},{"@E 999999999","@E 999999999"}}) 
aadd(aString,{"C0","Outros.....................:AAA       BBB       "	,{0,0},{"@E 999999999","@E 999999999"}}) 
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","        -----------------------------           "  ,{}})
aadd(aString,{"  ","                 Assinatura                     "	,{}})
aadd(aString,{"  ","                    Caixa                       "	,{}})
aadd(aString,{"  ","                                                "  ,{}})
aadd(aString,{"  ","                                                "  ,{}})

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA007Tela ³ Autor ³ Marcos Alves	     ³ Data ³ 08/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Apresenta tela para o caixa entrar com os valores           ³±±
±±³           ³numerarios                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA007Tela(cCaixa)                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA007Tela(cCaixa,cNome,dDataInno,oChkPgto,lChkPgto,oFechaCR,nFechaCR,cCaixaSup,cPDV,cPdv99,nHdlECF)
Local ODlgCx
Local oScroll

Local oData 

Local oGrupoCx1
Local oGrupoCx2

Local oCaixa
Local oNome
Local cNome		:=cUserName

Local oFntCx
Local oFntCx2
Local oFntRel

Local lRetVld	:=.F.
Local lRet		:=.F.
Local oGetDinh
Local aSemana	:={"Domingo", "Segunda", "Terca","Quarta",; //Descricoes do dia da semana
				  "Quinta"  , "Sexta", "Sabado"}
Local oScroll
//-Getdados dos cartoes
Local aCampos	:={}									//Array com os campos da getdados "SZW"
Local aCupom	:={""}									// Array para conter as linhas do relatorio de fechamento.
Local nRel		:=0
Local oLbxRel 
Local cString	:=""

//Get do Vale Innocencio
Local nQtdVI	:=0 //Numero de transacaoes de vale Innocencio
Local nValVI	:=0	// Valor das transaçoes de Vale Innocencio
// get Sinal de Encomenda  
Local nQtdSE	:=0 //Numero de transacaoes de Sinal de Encomenda  
Local nValSE	:=0	// Valor das transaçoes de Sinal de Encomenda  

// get iFood
Local nQtdIF	:=0 //Numero de transacaoes de Ifood
Local nValIF	:=0	// Valor das transaçoes de iFood

LOcal nQtdPIX 	:=0 //Numero de transacaoes de PIX
Local nValPIX	:=0 // Valor das transaçoes de PIX

Local oBtnAct, oBtnImp, oBtnEnd
Local aCedulas:={}										// Variavel do Tipo do fechamento Completo/Resumido

Private oGet      	:=NIL
Private aCols   	:= {}
Private aHeader 	:= {}
Private nUsado  	:= 0
Private aRotina 	:= {}
Private	lAltera		:=.F.
Private nOpcX		:=1
Private oFld

nTotDin		:=0
nTotCart	:=0
nOpcX		:=1

//Restaura/Inicializa variaveis de digitacao
IA007Restaura(dDataInno,cCaixa,@aCedulas,@nQtdVI,@nValVI,@nQtdSE, @nValSE,@nQtdIF, @nValIF,@nQtdPIX, @nValPIX)

//Ajustes do Msgetdados de cartoes
aAdd( aRotina, {"Incluir"    ,'AxInclui',0,3})

//18/03/15 - Gravar a informacao do caixa, caso nao passe no valide garente a informação

DEFINE MSDIALOG ODlgCx FROM 1,1 TO 500,410 TITLE "Fechamento de Caixa" PIXEL OF GetWndDefault()

DEFINE FONT oFntCx	NAME "Courier New"	   	SIZE 7,19 BOLD
DEFINE FONT oFntCx2 NAME "Courier New"     	SIZE 8,16 BOLD      
DEFINE FONT oFntRel	NAME "Courier New"	   	SIZE 7,16 BOLD  	// Relatorio Fechamento L,A

@ 005,004 GROUP oGrupoCx1 TO 043,200 LABEL "Caixa" COLOR CLR_HBLUE OF oDlgCx PIXEL
@ 013,014 SAY "Data" SIZE 50,10 OF oDlgCx PIXEL 
@ 012,030 MSGET oData VAR dDataInno SIZE 32,10 OF oDlgCx PIXEL VALID !Empty(dDataInno) //WHEN .F.

@ 030,015 SAY "Caixa" SIZE 50,10 OF oDlgCx PIXEL
@ 030,070 SAY oNome VAR cNome SIZE 50,10 OF oDlgCx PIXEL
@ 027,030 MSGET oCaixa VAR cCaixa F3 "23" SIZE 35,10 PICTURE "@!" OF oDlgCx PIXEL VALID lRetVld:=IA007VldCX(oCaixa,cCaixa,oNome,@cNome,dDataInno,@cCaixaSup,@aCedulas,@nQtdVI,@nValVI,@nQtdSE, @nValSE,@nQtdIF, @nValIF,@nQtdPIX, @nValPIX)

@ 013,130 RADIO oFechaCR VAR nFechaCR ITEMS "Resumido","Completo" SIZE 40,8 PIXEL OF oDlgCx //ON CHANGE MsgInfo("Tem certeza?","Wizard")
@ 030,130 CHECKBOX oChkPgto VAR lChkPgto PROMPT "Detalha Forma Pgto" SIZE 60,007 PIXEL OF oDlgCx //    ON CLICK(aEval(aVetor,{|x| x[1]:=lChk}),oLbx:Refresh())

//@ 044,004 GROUP oGrupoCx2 TO 205,200 LABEL "Numerários no Caixa" COLOR CLR_HBLUE OF oDlgCx PIXEL
@ 044,004 GROUP oGrupoCx2 TO 225,200 LABEL "Numerários no Caixa" COLOR CLR_HBLUE OF oDlgCx PIXEL

@ 055,006 FOLDER oFld OF ODlgCx PROMPT "&Dinheiro", "&Cartoes","&Outros","&Relatorio" PIXEL SIZE 185,160 //145   // @ L,C   ; SIZE C,L

//---- Folder Dinheiro oFld:aDialogs[1]
@ 003,003 SCROLLBOX oScroll VERTICAL SIZE 115,178 OF oFld:aDialogs[1] BORDER      // @ L,C   ; SIZE L,C

nLin:=5
@ nLin,010 SAY "   Cédula              Qtd                Valor " SIZE 150,18 PIXEL OF oScroll //COLOR CLR_WHITE,CLR_BLACK //FONT oFntCx
nLin+=8
//R$ 0,05
@ nLin,010 MSGET aCedulas[1,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[1,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[1,3]:=aCedulas[1,1]*aCedulas[1,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[1,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll 	PIXEL RIGHT WHEN .F. 


//R$ 0,10
nLin+=15
@ nLin,010 MSGET aCedulas[2,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll  	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[2,2] Picture "@E 999" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT VALID {|| aCedulas[2,3]:=aCedulas[2,1]*aCedulas[2,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[2,3] Picture "@E 9,999.99"	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 0,25
nLin+=15
@ nLin,010 MSGET aCedulas[3,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[3,2] Picture "@E 999" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT VALID {|| aCedulas[3,3]:=aCedulas[3,1]*aCedulas[3,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[3,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 0,50
nLin+=15
@ nLin,010 MSGET aCedulas[4,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll 	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[4,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[4,3]:=aCedulas[4,1]*aCedulas[4,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[4,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 1,00
nLin+=15
@ nLin,010 MSGET aCedulas[5,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[5,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[5,3]:=aCedulas[5,1]*aCedulas[5,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[5,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 2,00
nLin+=15
@ nLin,010 MSGET aCedulas[6,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[6,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[6,3]:=aCedulas[6,1]*aCedulas[6,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[6,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 5,00
nLin+=15
@ nLin,010 MSGET aCedulas[7,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[7,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[7,3]:=aCedulas[7,1]*aCedulas[7,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[7,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 10,00
nLin+=15
@ nLin,010 MSGET aCedulas[8,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[8,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[8,3]:=aCedulas[8,1]*aCedulas[8,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[8,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 20,00
nLin+=15
@ nLin,010 MSGET aCedulas[9,1] Picture "@E 999.99" 		SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[9,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[9,3]:=aCedulas[9,1]*aCedulas[9,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[9,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 50,00
nLin+=15
@ nLin,010 MSGET aCedulas[10,1] Picture "@E 999.99" 	SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[10,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[10,3]:=aCedulas[10,1]*aCedulas[10,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),.T.}
@ nLin,075 MSGET aCedulas[10,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

//R$ 100,00
nLin+=15
@ nLin,010 MSGET aCedulas[11,1] Picture "@E 999.99" 	SIZE 10,10 OF oScroll	PIXEL RIGHT WHEN .F.
@ nLin,050 MSGET aCedulas[11,2] Picture "@E 999" 		SIZE 10,10 OF oScroll	PIXEL RIGHT VALID {|| aCedulas[11,3]:=aCedulas[11,1]*aCedulas[11,2],nTotDin:=0,AEval(aCedulas, {|X| nTotDin+=X[3]}),oTotDin:refresh(),oFld:aDialogs[2]:SetFocus(),.T.}
@ nLin,075 MSGET aCedulas[11,3] Picture "@E 9,999.99" 	SIZE 20,10 OF oScroll	PIXEL RIGHT WHEN .F. 

nLin:=123
@ nLin,018 SAY "Total" FONT oFntCx2 PIXEL OF oFld:aDialogs[1]  SIZE 150,18 COLOR CLR_GREEN,CLR_BLACK //FONT oFntCx
@ nLin,070 SAY oTotDin VAR Transform(nTotDin,"@E 999,999.99") FONT oFntCx2 PIXEL OF oFld:aDialogs[1] SIZE 150,18 COLOR  CLR_GREEN,CLR_BLACK

//------- Final folder Dinheiro -------

//---- Folder Cartoes oFld:aDialogs[2]
oGet:= MSGetDados():New(3, 3,115,180,nOpcX,"U_IA007LinOk",.T.,NIL,.T.,,,,,,,,,oFld:aDialogs[2])
oGet:oBrowse:bAdd	:= { || IA007Add()}
oGet:oBrowse:bDelete:= { || IA007DEl() }	    // Permite a deletar Linhas
oGet:lF3Header = .T.

nLin:=123
@ nLin,018 SAY "Total" FONT oFntCx2 PIXEL OF oFld:aDialogs[2]  SIZE 150,18 COLOR CLR_HBLUE,CLR_BLACK //FONT oFntCx
@ nLin,120 SAY oTotCart VAR Transform(nTotCart,"@E 999,999.99") FONT oFntCx2 PIXEL OF oFld:aDialogs[2] SIZE 150,18 COLOR CLR_HBLUE,CLR_BLACK //FONT oFntCx

//Final Folder cartoes

//---- Folder Outros oFld:aDialogs[3]
//Get do Vale Innocencio
nLin:=5
@ nLin,010 SAY "Vale Innocencio....." 						SIZE 160,10 OF oFld:aDialogs[3] PIXEL FONT oFntCx COLOR CLR_HBLUE
@ nLin,098 MSGET nQtdVI Picture "@E 999"					SIZE 20,10 OF oFld:aDialogs[3] PIXEL RIGHT 
@ nLin,120 MSGET nValVI	Picture "@E 99,999.99"				SIZE 60,10 OF oFld:aDialogs[3] PIXEL RIGHT 

// get Sinal de Encomenda  
nLin+=15
@ nLin,010 SAY "Sinal Encomenda....." 						SIZE 160,10 OF oFld:aDialogs[3] PIXEL FONT oFntCx COLOR CLR_HBLUE
@ nLin,098 MSGET nQtdSE Picture "@E 999" 					SIZE 020,10 OF oFld:aDialogs[3] PIXEL RIGHT  
@ nLin,120 MSGET nValSE Picture "@E 99,999.99" 				SIZE 060,10 OF oFld:aDialogs[3] PIXEL RIGHT  

// get Ifood
nLin+=15
@ nLin,010 SAY "Ifood..............." 						SIZE 160,10 OF oFld:aDialogs[3] PIXEL FONT oFntCx COLOR CLR_HBLUE
@ nLin,098 MSGET nQtdIF Picture "@E 999"					SIZE 20,10 OF oFld:aDialogs[3] PIXEL RIGHT 
@ nLin,120 MSGET nValIF	Picture "@E 99,999.99"				SIZE 60,10 OF oFld:aDialogs[3] PIXEL RIGHT 

// get PIX
nLin+=15
@ nLin,010 SAY "Pix................." 						SIZE 160,10 OF oFld:aDialogs[3] PIXEL FONT oFntCx COLOR CLR_HBLUE
@ nLin,098 MSGET nQtdPIX 	Picture "@E 999"				SIZE 20,10 OF oFld:aDialogs[3] PIXEL RIGHT WHEN .F.
@ nLin,120 MSGET nValPIX	Picture "@E 99,999.99"			SIZE 60,10 OF oFld:aDialogs[3] PIXEL RIGHT WHEN .F.

//---- Final Folder Outros

//---- Folder Relatorio oFld:aDialogs[4]
@ 03,03 LISTBOX oLbxRel VAR nRel ITEMS aCupom FONT oFntRel  SIZE 180,135 OF oFld:aDialogs[4] PIXEL  //L,C   SIZE C,L

//oFld:aDialogs[4]:Disable()
//-------Final Folder Relatorio
oFld:bSetOption := {|nIndo| IA007FRelatorio(@cCaixaSup,nIndo,oFld:nOption,cPDV,cCaixa,cPdv99,dDataInno,lChkPgto,nFechaCR,aCupom,oLbxRel,aCedulas,oBtnAct,cNome,@nQtdVI, @nValVI,@nQtdSE, @nValSE,@nQtdIF, @nValIF,@nQtdPIX,@nValPIX,oBtnImp,@cString)}

DEFINE SBUTTON oBtnImp FROM 235,115 TYPE 06 ENABLE ONSTOP  "Imprime relatorio" ACTION (Processa( { || IA007ImpRel(aCedulas,nHdlECF,cString,cCaixa, dDataInno,nFechaCR)}, "Aguarde...","Processando relatorio caixa"),lRet:=.T.,oDlgCx:End()) OF oDlgCx
DEFINE SBUTTON oBtnAct FROM 235,145 TYPE 1 	ENABLE  			ACTION (lRet:=.T.,oDlgCx:End()) OF oDlgCx
DEFINE SBUTTON oBtnEnd FROM 235,175 TYPE 2  ENABLE			 	ACTION (lRet:=.F.,oDlgCx:End()) OF oDlgCx	

ACTIVATE MSDIALOG oDlgCx CENTERED ON INIT (oBtnImp:Disable())

//If lRet.and.MsgYesNo("Gravar dados do fechamento?")
Processa( { || IA007Save(dDataInno,aCedulas,cCaixa,nQtdVI, nValVI,nQtdSE, nValSE,nQtdIF, nValIF)}, "Aguarde...","Gravando dados")
//EndIf	

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA007Proc ³ Autor ³ Marcos Alves	     ³ Data ³ 22/08/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Processa o fechamento diario                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA007Proc(nHdlECF,cPDVFech)								   ³±±
±±³ Sintaxe   ³IA007Proc(nHdlECF,cPDVFech)								   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA007Proc(cStringAux,cPDV,cCaixa,cPdv99,dDataInno,lChkPgto,nFechaCR,aCupom,oLbxRel,aCedulas,oBtnAct,cNome,nQtdVI, nValVI,nQtdSE, nValSE,nQtdIF,nValIF,nQtdPIX,nValPIX,oFld )
Local aCheques	:={}											//Cheques recebidos no dia
Local aAtend	:={}											//Movimentacoes dos atendentes do dia	
Local aVendHora	:={}											//Movimentacoes do horario
Local nI,nX		:=0												//Lacos For Next
Local nHdl		:=	-1											// Handle do arquivo TXT do fechamento gerado
Local cPath 	:= "\FECHAMENTO\"	// Caminho para 
Local cFile		:="RF_"+Alltrim(SM0->M0_FILIAL)+"_"+If(Empty(cCaixa),"000",cCaixa)+"_"+Strzero(Day(dDataInno),2)+Strzero(Month(dDataInno),2)+Strzero(Year(dDataInno),4)+".TXT"
Local cString	:=""
Local cLinha	:=""
Local nVz		:=0     
Local cHora		:=""
Local nPos		:=0
Local nPosH		:=0
Local cAdm		:=""
Local cMoedaI	:=""
Local nTot		:=0
Local nTot		:=0
Local cInfo		:=""
Local cPesq		:=""

Local cFileOld	:=""
Local cTime2	:=""
Local cFileTime	:=""
Local aSemana	:={"Domingo", "Segunda", "Terca","Quarta",; //Descricoes do dia da semana
				  "Quinta"  , "Sexta", "Sabado"}
Local cTime		:=Time()
Local aPgtos:={}

Local cCliente 	:= SuperGetMV( "MV_CLIPAD" )
Local cLojaCli 	:= SuperGetMV( "MV_LOJAPAD" ) 
Local cCondicao	:=""
Local aFuncVnd	:={}
Local aDelivery	:={}	//Movimentacoes das entregas
Local aPix		:={}  //Contem as movimentações de recebimento em PIX (Venda/Sinal de encomenda)
Local aSinalAberto :={} //Contem os sinais de encomenda que estao em aberto

Default cStringAux := ""

aadd(aDelivery,{"INNOCENCIO",0,0,0})   
aadd(aDelivery,{"IFOOD",0,0,0})   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Array com a estrutura do fechamento					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IA007Corpo(cPDV,cPdv99)		 //Inicializar aString

//Impressao do Relatorio 
//Valor total em dinheiro
nTotalCedula:=0
AEval(aCedulas, {|X| nTotalCedula+=X[3]})
aString[IA007Pos("C2"),5,1]:=nTotalCedula

//Resurando valor total dos cartoes:
For nI:= 1 to Len(aCols)
	lLock	:=.T.
	If aCols[nI,5]
		Loop
	EndIf	
	If AllTrim(aCols[nI,2])=="1"	//Tipo do Cartao
		aString[IA007Pos("G1"),5,1] +=aCols[nI,3]
		aString[IA007Pos("G1"),5,2]	+=aCols[nI,4]
	ElseIf Alltrim(aCols[nI,2])=="2"	//Tipo do Cartao
		aString[IA007Pos("G2"),5,1] +=aCols[nI,3]
		aString[IA007Pos("G2"),5,2]	+=aCols[nI,4]
	ElseIf Alltrim(aCols[nI,2])=="3"	//Tipo do Cartao
		aString[IA007Pos("G3"),5,1] +=aCols[nI,3]
		aString[IA007Pos("G3"),5,2]	+=aCols[nI,4]
	Else
		aString[IA007Pos("G5"),5,1] +=aCols[nI,3]
		aString[IA007Pos("G5"),5,2]	+=aCols[nI,4]
	EndIf
Next nI	

//Gravacao dos dados digitados
aString[IA007Pos("A4"),3,1]:=aSemana[Dow(dDataInno)]					//Identifica qual o dia da semana
aString[IA007Pos("A4"),3,2]:=dToc(dDataInno)							//Identifica qual o dia do mes
aString[IA007Pos("A4"),3,3]:=Time()										//Identifica qual horario
If !Empty(cCaixa)
	aString[IA007Pos("A5"),3,1]:=cCaixa+"-"+cNome
Else
	aString[IA007Pos("A5"),3,1]:="C00- Geral"
EndIf
//Valores de Vale Innocencio
aString[IA007Pos("C6"),5,1]:=nqTDVI
aString[IA007Pos("C6"),5,2]:=nValVI

//Valores de Sinal de Encomenda
aString[IA007Pos("G4"),5,1]:=nQtdSE
aString[IA007Pos("G4"),5,2]:=nValSE

//Valores de Ifood
aString[IA007Pos("G6"),5,1]:=nQtdIF
aString[IA007Pos("G6"),5,2]:=nValIF

//Valores de PIX
aString[IA007Pos("PI"),5,1]:=nQtdPIX
aString[IA007Pos("PI"),5,2]:=nValPIX


ProcRegua(3)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuracao do ambiente                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Deleted OFF // .F. Processa os registros marcados para Delecao (processar cupons Cancelados)
dbSelectArea("SA3")
dbSelectArea("SL4")
dbSelectArea("SL2")
dbSelectArea("SL1")

SL2->(dbSetOrder(1))
SL1->(dbSetOrder(7))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento das Vendas (SL1)  							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SL1->(dbSeek(xFilial("SL1")+dToS(dDataInno)))
//ProcRegua(SL1->(Reccount()))
While !SL1->(Eof()).And. SL1->L1_FILIAL+dToS(SL1->L1_EMISSAO)==xFilial()+dToS(dDataInno)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If (!Empty(cCaixa).And.Alltrim(SL1->L1_OPERADO)<>cCaixa) 
		SL1->(dbSkip())
		Loop
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contador de L1_SITUA:                                        ³
	//³ TX-Transmitido a retaguarda                                  ³
	//³ "00" - Venda Efetuada com Sucesso (Nao Transmitido)			 ³
	//³ "01" - Abertura do Cupom Nao Impressa                        ³
	//³ "04" - Impresso o Item                                       ³
	//³ "05" - Solicitado o Cancelamento do Item                     ³
	//³ "07" - Solicitado o Cancelamento do Cupom                    ³
	//³ "09" - Encerrado SL1 (Nao gerado SL4)                        ³
	//³ "10" - Encerrado a Venda                                     ³
	//³ "99" - Excluido por reimpressão                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SL1->L1_SITUA=="00".AND. !SL1->(Deleted()) 		 	
		aString[IA007Pos("CB"),3,2]++					//Transmissao - Não transmitido
	ElseIf SL1->L1_SITUA=="07" 		 
    	aString[IA007Pos("AR"),3,1]++					//Vendas - Contador de Cancelados
		aString[IA007Pos("CA"),3,1]++   				//Transmissao - contador de cancelados
	ElseIf SL1->L1_SITUA=="TX" .or.SL1->L1_SITUA=="ER"		 
	ElseIf SL1->L1_SITUA=="99"							//Exluido por reimpressão		 
		aString[IA007Pos("D6"),3,1]++					//Reimpressao  - Contador 
		aString[IA007Pos("D6"),3,2]+=SL1->L1_VLRLIQ		//Vendas - Valor Outros
		SL1->(dbSkip())
		Loop
	Else 												//Avaliar L1_SITUA="03" - Quando ocorre. 
		aString[IA007Pos("D5"),3,1]++					//Vendas - Contador de outros
		aString[IA007Pos("C0"),3,1]++ 					//Transmissao - Outros
		If SL1->L1_SITUA=="03"							//Exluido por reimpressão		 
			SL1->(dbSkip())
			Loop
		End
	EndIf
	aString[IA007Pos("CB"),3,1]++ 						//Transmissao - Total Vendas
    aString[IA007Pos("AP"),3,1]++						//Vendas - Contador de vendas Bruta
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento dos itens										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
	While !SL2->(Eof()).And. SL2->L2_FILIAL+SL1->L1_NUM==xFilial("SL2")+SL2->L2_NUM
		If SL1->L1_SITUA=="07".OR.SL2->L2_SITUA=="05"		//07 Cancelados cupom /05- Cancelamento de Item
		    aString[IA007Pos("AR"),3,2]+=SL2->L2_VLRITEM+SL2->L2_DESCPRO	//Vendas - Valor Cancelados
		ElseIf !(SL1->L1_SITUA$"00#TX#ER") .OR.SL1->L1_SITUA="00".AND.SL1->(Deleted()) //Outros
		    aString[IA007Pos("D5"),3,2]+=SL2->L2_VLRITEM+SL2->L2_DESCPRO	//Vendas - Valor Outros
		ElseIf SL1->L1_SITUA<>"07".AND.SL2->(Deleted())					//Itens da venda Cancelados
			SL2->(dbSkip())
			Loop
		EndIf    
    	aString[IA007Pos("AP"),3,2]+=SL2->L2_VLRITEM+SL2->L2_DESCPRO		//Vandas - Valor de venda Bruta 
		SL2->(dbSkip())
    End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao contabiliza registros deletado, somente quando cancelado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If SL1->(Deleted()) 								//processar cupons Cancelados)
		SL1->(dbSkip())
		Loop
    EndIf
    Set Deleted ON //.T. NAO Processa os registros marcados para Delecao (processar cupons Cancelados)
    aString[IA007Pos("A8"),3,1]++						//{"A8","Vendas(Cupons).............:AAA                 "	,{0},{"@E 999999"}			}
	If SL1->L1_DESCONT>0
	    aString[IA007Pos("AQ"),3,1]++					//{"AQ","Descontos.............[AAA]:BBB     ...[CCC    ]"	,{0,0,0.00},{"@E 999","@E 999,999.99","@R 999.99%"}}) 
	    aString[IA007Pos("AQ"),3,2]+=SL1->L1_DESCONT	//{"AQ","Descontos.............[AAA]:BBB     ...[CCC    ]"	,{0,0,0.00},{"@E 999","@E 999,999.99","@R 999.99%"}}) 
    EndIf
	aString[IA007Pos("D4"),3,1]+=SL1->L1_VLRLIQ			//Indicador Geral - Valor
	If AllTrim(SL1->L1_PDV)==cPDV
		aString[IA007Pos("AD"),3,1] :=If(SL1->L1_DOC<aString[IA007Pos("AD"),3,1],SL1->L1_DOC,aString[IA007Pos("AD"),3,1])//{"AD","Inicio.....................:AAA                 "	,{"999999999"},{}				})
		aString[IA007Pos("AE"),3,1] :=If(SL1->L1_DOC>aString[IA007Pos("AE"),3,1],SL1->L1_DOC,aString[IA007Pos("AE"),3,1])//{"AE","Final......................:AAA                 "	,{"000000000"},{}				})
	    aString[IA007Pos("AC"),3,1]++ 						//{"AC","Cupons.....................:AAA        [BBB   %]"	,{0,0.00},{"@E 999999","@R 999.99%"}		})
	    aString[IA007Pos("AF"),3,1]+=SL1->L1_VLRLIQ			//{"AF","Valor......................:AAA        [BBBBB  ]"	,{0,0.00},{"@E 999,999.99","@R 999.99%"}		})
	    
	    If !Empty(SL1->L1_CGCCLI)				
			aString[IA007Pos("AH"),3,1]++					//{"AH","NFP........................:AAA                 "	,{0},{"@E 999999"}				})
		EndIf
	ElseIf AllTrim(SL1->L1_PDV)==cPdv99		//"9901"
		aString[IA007Pos("AK"),3,1] :=If(SL1->L1_DOC<aString[IA007Pos("AK"),3,1],SL1->L1_DOC,aString[IA007Pos("AK"),3,1])//{"AK","Inicio.....................:AAA                 "	,{"999999999"},{}				})
		aString[IA007Pos("AL"),3,1] :=If(SL1->L1_DOC>aString[IA007Pos("AL"),3,1],SL1->L1_DOC,aString[IA007Pos("AL"),3,1])//{"AL","Final......................:AAA                 "	,{"000000000"},{}				})
	    aString[IA007Pos("AJ"),3,1]++ 					//{"AK","Inicio.....................:AAA                 "	,{"999999999"},{}				})
	    aString[IA007Pos("AM"),3,1]+=SL1->L1_VLRLIQ		//{"AM","Valor......................:AAA        [BBB    ]"	,{0,0.00},{"@E 999,999.99","@R 999.99%"}		})
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contabilizacao de vendas por hora							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHora:=Left(SL1->L1_HORA,2)
	If Len(aVendHora)=0.OR.(nPosH:=AScan(aVendHora, {|X| X[1]==cHora}))=0
    	aadd(aVendHora,{cHora,1,0,SL1->L1_VLRLIQ}) //Primeira Hora
    	nPosH:=1
    Else
    	aVendHora[nPosH,2]++
        aVendHora[nPosH,4]+=SL1->L1_VLRLIQ			//Valor de venda dos itens
    EndIf
	SL2->(dbSetOrder(1))
	SL2->(dbSeek(xFilial("SL2")+SL1->L1_NUM))
	While !SL2->(Eof()).And. SL2->L2_FILIAL+SL1->L1_NUM==xFilial("SL2")+SL2->L2_NUM
	    If SL2->(Deleted()) 								//processar cupons Cancelados)
			SL2->(dbSkip())
			Loop
	    EndIf
        aVendHora[nPosH,3]+=SL2->L2_QUANT		 		//Itens vendidos
	    aString[IA007Pos("A9"),3,1]+=SL2->L2_QUANT 		//{"A9","Itens Vendidos.............:AAA                 "	,{0},{"@E 999999"}				})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabilizacao de vendas por atendente 						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aAtend)=0.OR.(nPos:=AScan(aAtend, {|X| X[2]==SL2->L2_VEND}))=0
	    	aadd(aAtend,{SL2->L2_NUM,SL2->L2_VEND,1,SL2->L2_VLRITEM}) //Identifica o Atendente
        Else
            If aAtend[nPos,1]<>SL2->L2_NUM 			//Logica para incremento da venda
	            aAtend[nPos,1]:=SL2->L2_NUM
    	        aAtend[nPos,3]++
    	    EndIf    
            aAtend[nPos,4]+=SL2->L2_VLRITEM			//Valor de venda dos itens
    	EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabilizacao de vendas delivery
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Alltrim(SL2->L2_PRODUTO)=="00198"
			If SL2->L2_TABELA="1"
				aDelivery[1,2]++
				aDelivery[1,3]+=SL1->L1_VLRTOT
				aDelivery[1,4]+=SL2->L2_VLRITEM
			else
				aDelivery[2,2]++
				aDelivery[2,3]+=SL1->L1_VLRTOT
				aDelivery[2,4]+=SL2->L2_VLRITEM
			ENDIF
		ENDIF
		SL2->(dbSkip())
	End
	If SL1->L1_CLIENTE<>cCliente
		cCondicao:=Posicione("SA1",1,xFilial("SA1")+SL1->L1_CLIENTE,"A1_COND")
		If cCondicao="002"
	    	aadd(aFuncVnd,{SL1->L1_NUM,SL1->L1_CLIENTE,SA1->A1_NOME,SL1->L1_DOC,SL1->L1_SERIE,"", SL1->L1_VLRLIQ}) //Identifica o Atendente
        EndIf
	EndIf
	SL4->(dbSetOrder(1))
	SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
	nVz:=0
	While !SL4->(Eof()).And. SL4->L4_FILIAL+SL4->L4_NUM==xFilial("SL4")+SL1->L1_NUM
   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtro de vendas canceladas									 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If SL4->(Deleted())
			SL4->(dbSkip())
			Loop
	    EndIf
        cAdm:=Subs(Alltrim(SL4->L4_ADMINIS),1,3)
        nVz++
	    aString[IA007Pos("AY"),3,1]++					//{"AY","Recebimento Vendas....[AAA]:BBB     ...[CCC    ]"	,{0,0,0.00},{"@E 999","@E 999,999.99","@R 999.99%"}}) 
	    aString[IA007Pos("AY"),3,2]+=SL4->L4_VALOR		
   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 002- Nao cartao e nao NFP                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(Alltrim(SL4->L4_FORMA)$"CC#CD#VA").AND.Empty(SL1->L1_CGCCLI).AND.AllTrim(SL1->L1_PDV)==cPDV   // No PDV o02 imprimir somente CC+CD+VA ou NFP
			aString[IA007Pos("D1"),3,1] +=If(nVz=1,1,0)
			aString[IA007Pos("D1"),3,2] +=SL4->L4_VALOR
		EndIf
		If (Alltrim(SL4->L4_FORMA)$"CC#CD#VA").AND.AllTrim(SL1->L1_PDV)==cPdv99 //No PDV 99, nao pode ter venda de CC, CD, VA
			aString[IA007Pos("D2"),3,1] +=If(nVz=1,1,0)
			aString[IA007Pos("D2"),3,2] +=SL4->L4_VALOR
		EndIf

		If Alltrim(SL4->L4_FORMA)$"CC#CD#VA".And.Empty(SL4->L4_DOC).and.At("IFOOD",Alltrim(SL4->L4_ADMINIS))==0  // Venda de cartoes
		    aString[IA007Pos("F1"),3,1]++				
	    	aString[IA007Pos("F1"),3,2]+=SL4->L4_VALOR	
        EndIf
		If Alltrim(SL4->L4_FORMA)=="R$".And.Empty(SL4->L4_DOC)
		    aString[IA007Pos("AU"),3,1]++				//{"AU","Dinheiro..............[AAA]:BBB     ...[CCC    ]"	,{0,0,0.00},{"@E 999","@E 999,999.99","@R 999.99%"}}) 
	    	aString[IA007Pos("AU"),3,2]+=SL4->L4_VALOR		
		ElseIf Alltrim(SL4->L4_FORMA)=="CH".And.Empty(SL4->L4_DOC)
		    aString[IA007Pos("AV"),3,1]++				//{"AV","Cheque................[AAA]:BBB     ...[CCC    ]"	,{0,0,0.00},{"@E 999","@E 999,999.99","@R 999.99%"}}) 
	    	aString[IA007Pos("AV"),3,2]+=SL4->L4_VALOR
	    	aadd(aCheques,{Alltrim(SL4->L4_ADMINIS),Alltrim(SL4->L4_AGENCIA),Alltrim(SL4->L4_CONTA),Alltrim(SL4->L4_NUMCART),SL4->L4_VALOR,Alltrim(SL4->L4_TELEFON)})
		ElseIf Alltrim(SL4->L4_FORMA)=="CC".And.Empty(SL4->L4_DOC)
			If At("IFOOD",Alltrim(SL4->L4_ADMINIS))<>0
				aString[IA007Pos("IF"),3,1] ++  					//Quantidade de Ifood
				aString[IA007Pos("IF"),3,2] +=SL4->L4_VALOR			// Valor iFood
				aString[IA007Pos("G6"),3,1] ++  					//Quantidade de Ifood
				aString[IA007Pos("G6"),3,2] +=SL4->L4_VALOR			// Valor iFood
			Else
				aString[IA007Pos("G1"),3,1] ++  					//Quantidade de Cartao de credito.
				aString[IA007Pos("G1"),3,2] +=SL4->L4_VALOR		// Valor Cartao de Credito
			EndIf	
		ElseIf Alltrim(SL4->L4_FORMA)=="CD".And.Empty(SL4->L4_DOC)
			aString[IA007Pos("G2"),3,1] ++  					//Quantidade de Cartao de Debito
			aString[IA007Pos("G2"),3,2] +=SL4->L4_VALOR		// Valor Cartao de Debito
		ElseIf Alltrim(SL4->L4_FORMA)=="VA".And.Empty(SL4->L4_DOC)
			aString[IA007Pos("G3"),3,1] ++  					//Quantidade de Voucher
			aString[IA007Pos("G3"),3,2] +=SL4->L4_VALOR		// Valor Voucher
		ElseIf Alltrim(SL4->L4_FORMA)=="CR".Or.!Empty(SL4->L4_DOC) // No Campo L4_DOC, esta sendo gravdo o TALAO+PEDIDO, quando baixado os valores no SZT.
			aString[IA007Pos("G4"),3,1] ++  					//Quantidade de Sinal Encomenda
			aString[IA007Pos("G4"),3,2] +=SL4->L4_VALOR		// Valor Sinal Encomenda
			aString[IA007Pos("G0"),3,1] ++  					//Quantidade de Sinal Encomenda
			aString[IA007Pos("G0"),3,2] +=SL4->L4_VALOR		// Valor Sinal Encomenda
		ElseIf Alltrim(SL4->L4_FORMA)=="CO".And.Empty(SL4->L4_DOC)
			//"C6" - Vale Innocencio
			aString[IA007Pos("C6"),3,1] ++ 					//Quantidade de Vale innocencio
			aString[IA007Pos("C6"),3,2] +=SL4->L4_VALOR 	//Valor Vale Innocencio
			//"C6" - Vale Innocencio
			//Valores de Vale Innocencio
			aString[IA007Pos("FA"),3,1]++
			aString[IA007Pos("FA"),3,2]+=SL4->L4_VALOR

		ElseIf Alltrim(SL4->L4_FORMA)=="DC".And.Empty(SL4->L4_DOC)
			//"PX" - PIX
			aString[IA007Pos("PX"),3,1] ++ 					//Quantidade de Vale innocencio
			aString[IA007Pos("PX"),3,2] +=SL4->L4_VALOR 	//Valor Vale Innocencio
			//"PI" - Pix 
			//Valores de PIX
			aString[IA007Pos("PI"),3,1]++
			aString[IA007Pos("PI"),3,2]+=SL4->L4_VALOR
			aadd(aPix,{SL1->L1_HORA, SL1->L1_NUM, SL4->L4_VALOR,"Venda"})
		Else
			aString[IA007Pos("G5"),3,1] ++  					//Quantidade Outros
			aString[IA007Pos("G5"),3,2] +=SL4->L4_VALOR		// Valor Outros
        EndIf
		If lChkPgto
			aadd(aPgtos,{SL1->L1_NUM, SL1->L1_HORA, SL4->L4_ADMINIS, SL4->L4_VALOR})
		EndIf
		If (nPosF:=AScan(aFuncVnd, {|X| X[1]==SL4->L4_NUM}))<>0
			aFuncVnd[nPosf,6]:=Subs(SL4->L4_FORMA,1,3)
		EndIf
		SL4->(dbSkip())
	End
	Set Deleted OFF //Processa os registros marcados para Delecao (processar cupons Cancelados)
	SL1->(dbSkip())
End
Set Deleted ON //Processa os registros marcados para Delecao (processar cupons Cancelados)
IncProc() 		//Processou o SL1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valor Fundo de troco Inicial                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValInic:=0
aDespesas:={}
dbSelectArea("SE5")
SE5->(dbSetOrder(1))
SE5->(dbSeek(xFilial("SE5")+DTOS(dDataInno)+If(Empty(cCaixa),"",cCaixa)))
nReg:=SE5->(Recno())
//Havia desabilitado para implementacao de saldo bancario - Voltando para implementacao do iFood
While !SE5->(Eof()).And. SE5->E5_FILIAL==xFilial("SE5").And.SE5->E5_DATA==dDataInno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(cCaixa).And.SE5->E5_BANCO==cCaixa
		If Alltrim(SE5->E5_HISTOR)==("FUNDO TROCO INICIAL CAIXA "+cCaixa).AND.SE5->E5_RECPAG=="R"
			nValInic:=SE5->E5_VALOR
			Exit
	    EndIf   
    Else
		If At("FUNDO TROCO INICIAL CAIXA ", Alltrim(SE5->E5_HISTOR))<>0.AND.SE5->E5_RECPAG=="R"
			nValInic+=SE5->E5_VALOR
		EndIf
    EndIf
	SE5->(dbSkip())
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processamento de Sangria e reforco de caixa						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbGoto(nReg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³XA ---  Detalhe dos recebimentos     ------------------------------ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosInno:=IA007Pos("XN")
//IA007aadd(aString,{"  ","AAA                  BBB         CCC         DDD",{"Dinheiro","FUNDO INICIO",nValInic," T "},{"@!","@!","@E 9999,999.99","@!"}}) 
IA007aadd(aString,{"  ","AAA                  BBB         CCC         DDD",{"Dinheiro","FUNDO INICIO",nValInic," T "},{"@!","@!","@E 9999,999.99","@!"}}) 
While !SE5->(Eof()).And. SE5->E5_FILIAL==xFilial("SE5").And.SE5->E5_DATA==dDataInno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(cCaixa).And.SE5->E5_BANCO<>cCaixa
		Exit
    EndIf
    cMoedaI:=""
    If SE5->(Deleted()) 								//processar cupons Cancelados)
		SE5->(dbSkip())
		Loop
    EndIf
	If Alltrim(SE5->E5_NATUREZ)=="SANGRIA".AND.SE5->E5_RECPAG=="P"
	//If SE5->E5_RECPAG=="P"
		aString[IA007Pos("B2"),3,1]++					//Contador de Sangria
		aString[IA007Pos("B2"),3,2]+=SE5->E5_VALOR		//Valor Sangria Dinheiro
		If Alltrim(SE5->E5_MOEDA)="R$"
			cMoedaI:="Dinheiro"
		    aString[IA007Pos("C2"),3,1]+=SE5->E5_VALOR		//Valor Sangria Dinheiro
		ElseIf Alltrim(SE5->E5_MOEDA)="CH"
			cMoedaI:="Cheque"
		    aString[IA007Pos("C3"),3,1]++
		    aString[IA007Pos("C3"),3,2]+=SE5->E5_VALOR		//Valor Sangria Cheque
		EndIf
		IA007aadd(aString,{"  ","AAA                  BBB         CCC         DDD",{cMoedaI,Subs(SE5->E5_DOCUMENT,1,11),SE5->E5_VALOR," S "},{"@!","@!","@E 9999,999.99","@!"}}) 
	ElseIf Alltrim(SE5->E5_NATUREZ)=="TROCO".AND.SE5->E5_RECPAG=="R".AND.subs(Alltrim(SE5->E5_HISTOR),1,25)<>"FUNDO TROCO INICIAL CAIXA"
	//ElseIf SE5->E5_RECPAG=="R"
		cMoedaI:="Dinheiro"
	    aString[IA007Pos("AZ"),3,1]++					//Contador de Fundo de Troco
	    aString[IA007Pos("AZ"),3,2]+=SE5->E5_VALOR		//Valor Fundo de Troco
		IA007aadd(aString,{"  ","AAA                  BBB         CCC         DDD",{cMoedaI,Subs(SE5->E5_DOCUMENT,1,11),SE5->E5_VALOR," T "},{"@!","@!","@E 9999,999.99","@!"}}) 
	//ElseIf Alltrim(SE5->E5_NATUREZ)=="TROCO".AND.SE5->E5_RECPAG=="R".AND.subs(Alltrim(SE5->E5_HISTOR),1,25)=="FUNDO TROCO INICIAL CAIXA"
	    //aString[IA007Pos("C4"),3,1]+=SE5->E5_VALOR		//Valor Fundo de Troco
    ElseIf 	Alltrim(SE5->E5_TIPODOC)=="BA".AND.SE5->E5_RECPAG=="P" 
	    aString[IA007Pos("B7"),3,1]++					//Contador de Fundo de Troco
	    aString[IA007Pos("B7"),3,2]+=SE5->E5_VALOR		//Valor Fundo de Troco
		If SE5->E5_SITUA=="00" 				
			aString[IA007Pos("CP"),3,2]++				//Transmissao - Contador de Despesas
	    EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Armazenando as despesas para inserir posteriormente no array aString³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    aadd(aDespesas,{SE5->E5_NUMERO,Subs(SE5->E5_BENEF,1,26),SE5->E5_VALOR,SE5->(Recno())})
    EndIf                                                      
	SE5->(dbSkip())
End

// Incio do processamento dos pagamento de sinal
dbGoto(nReg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³XA ---  Detalhe dos recebimentos     ------------------------------ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aadd(aString,{"S3","------ --------- ------------------ ------------",{},{}})
nPosInno:=IA007Pos("S3")
While !SE5->(Eof()).And. SE5->E5_FILIAL==xFilial("SE5").And.SE5->E5_DATA==dDataInno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(cCaixa).And.SE5->E5_BANCO<>cCaixa
		Exit
    EndIf
    cMoedaI:=""
    If SE5->(Deleted()) 								//processar cupons Cancelados)
		SE5->(dbSkip())
		Loop
    EndIf
	If Alltrim(SE5->E5_NATUREZ)=="RECEBIMENT".AND.SE5->E5_RECPAG=="R".AND.subs(Alltrim(SE5->E5_HISTOR),1,13)=="SINAL PEDIDO:"
	   //	cMoedaI:="Dinheiro"
		cPedido:= Strzero(Val(subs(Alltrim(SE5->E5_HISTOR),14,3)),6)
		cMoedaI:=""
		If SE5->E5_MOEDA=='R$'
			cMoedaI:="DINHEIRO"
		    aString[IA007Pos("SC"),3,1]+=SE5->E5_VALOR		//Valor SINAL EM Dinheiro
		    //aString[IA007Pos("C2"),3,1]+=SE5->E5_VALOR		//Valor Sangria Dinheiro
		ElseIf SE5->E5_MOEDA=='CC'
			cMoedaI:="CREDITO"
		    aString[IA007Pos("SC"),3,2]+=SE5->E5_VALOR		//Valor SINAL EM Dinheiro
		    aString[IA007Pos("G1"),3,1]++					//Contador de transacao
		    aString[IA007Pos("G1"),3,2]+=SE5->E5_VALOR		//Valor SINAL CARTAO CREDITO
		ElseIf SE5->E5_MOEDA=='CD'
			cMoedaI:="DEBITO"
		    aString[IA007Pos("SC"),3,3]+=SE5->E5_VALOR		//Valor SINAL EM Dinheiro
		    aString[IA007Pos("G2"),3,1]++					//Contador de transacao CARTAO DEBITO
		    aString[IA007Pos("G2"),3,2]+=SE5->E5_VALOR		//Valor SINAL CARTAO DEBITO
		ElseIf SE5->E5_MOEDA=='CO'
			cMoedaI:="VOUCHER"
		    aString[IA007Pos("SC"),3,4]+=SE5->E5_VALOR		//Valor SINAL EM Dinheiro
		    aString[IA007Pos("G3"),3,1]++					//Contador de transacao VOUCHER
		    aString[IA007Pos("G3"),3,2]+=SE5->E5_VALOR		//Valor SINAL VOUCHER
		ElseIf SE5->E5_MOEDA=='DC'
			cMoedaI:="VOUCHER"
		    aString[IA007Pos("SC"),3,5]+=SE5->E5_VALOR		//Valor SINAL EM PIX
		    aString[IA007Pos("PI"),3,1]++					//Contador de transacao PIX
		    aString[IA007Pos("PI"),3,2]+=SE5->E5_VALOR		//Valor SINAL PIX
		EndIf			
	    aString[IA007Pos("B9"),3,1]++					//Contador Sinal Encomenda
	    aString[IA007Pos("B9"),3,2]+=SE5->E5_VALOR		//Valor Sinal Encomenda
	    aString[IA007Pos("SC"),3,6]+=SE5->E5_VALOR		//Valor Fundo de Troco
		IA007aadd(aString,{"  ","AAA    BBB       CCC                DDD         ",{cPedido,Subs(SE5->E5_DOCUMENT,1,9),cMoedaI,SE5->E5_VALOR},{"@!","@!","@!","@E 9999,999.99"}}) 
    EndIf                                                      
	SE5->(dbSkip())
End
//Sinal de Encomenda Feitos no dia  SZT/SZS --------------------------------------------------------------------------
aSinalAberto:={}
SZS->(dbSetOrder(1))
SZT->(dbSetOrder(2)) //ZT_FILIAL+DToS(ZT_BAIXA)+ZT_TALAO+ZT_PEDIDO
SZT->(dbSeek(xFilial("SZT")+DtoS(dDataInno)))
While !SZT->(Eof()).And.(xFilial("SZT")+DToS(dDataInno)==SZT->ZT_FILIAL+DToS(SZT->ZT_DATA))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cCaixa).And.SZT->ZT_CAIXA<>cCaixa
		SZT->(dbSkip())
		Loop
    EndIf
	SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))        
	While !SZS->(Eof()).and. (xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO)==(SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO)
		If Alltrim(SZS->ZS_FORMA)=='R$'
			cMoedaI:="DINHEIRO"
		    aString[IA007Pos("SC"),3,1]+=SZS->ZS_VALOR		//Valor SINAL EM Dinheiro
		    //aString[IA007Pos("C2"),3,1]+=SE5->E5_VALOR		//Valor Sangria Dinheiro
		ElseIf Alltrim(SZS->ZS_FORMA)=='CC'
			cMoedaI:="CREDITO"
		    aString[IA007Pos("SC"),3,2]+=SZS->ZS_VALOR		//Valor SINAL EM Dinheiro
		    aString[IA007Pos("G1"),3,1]++					//Contador de transacao
		    aString[IA007Pos("G1"),3,2]+=SZS->ZS_VALOR		//Valor SINAL CARTAO CREDITO
		ElseIf Alltrim(SZS->ZS_FORMA)=='CD'
			cMoedaI:="DEBITO"
		    aString[IA007Pos("SC"),3,3]+=SZS->ZS_VALOR		//Valor SINAL EM Dinheiro
		    aString[IA007Pos("G2"),3,1]++					//Contador de transacao CARTAO DEBITO
		    aString[IA007Pos("G2"),3,2]+=SZS->ZS_VALOR		//Valor SINAL CARTAO DEBITO
		ElseIf Alltrim(SZS->ZS_FORMA)=='VA'
			cMoedaI:="VOUCHER"
		    aString[IA007Pos("SC"),3,4]+=SZS->ZS_VALOR		//Valor SINAL EM Dinheiro
		    aString[IA007Pos("G3"),3,1]++					//Contador de transacao VOUCHER
		    aString[IA007Pos("G3"),3,2]+=SZS->ZS_VALOR		//Valor SINAL VOUCHER
		ElseIf Alltrim(SZS->ZS_FORMA)=='DC'
			cMoedaI:="PIX"
		    aString[IA007Pos("SC"),3,5]+=SZS->ZS_VALOR		//Valor SINAL EM PIX
		    aString[IA007Pos("PI"),3,1]++					//Contador de transacao PIX
		    aString[IA007Pos("PI"),3,2]+=SZS->ZS_VALOR		//Valor SINAL VOUCHER
			aadd(aPix,{SZT->ZT_HORA, SZT->ZT_TALAO+SZT->ZT_PEDIDO, SZS->ZS_VALOR,"Sinal"})
		EndIf			
	    aString[IA007Pos("B9"),3,1]++					//Contador Sinal Encomenda
	    aString[IA007Pos("B9"),3,2]+=SZS->ZS_VALOR		//Valor Sinal Encomenda
	    aString[IA007Pos("SC"),3,6]+=SZS->ZS_VALOR		//Valor Fundo de Troco
        If Empty(SZS->ZS_ADMINIS)
        	cAdm:="000 - DINHEIRO         "
        Else
			cAdm:=Subs(SZS->ZS_ADMINIS,1,24)
		EndIf	
		IA007aadd(aString,{"  ","AAA BBB CCC    DDD                      EEE     ",{SZS->ZS_TALAO,SZS->ZS_PEDIDO,Subs(SZT->ZT_DOC,1,6),cAdm,SZS->ZS_VALOR},{"@E 999","@E 999","@E 999999","@!","@E 9,999.99"}}) 
		SZS->(dbSkip())                                              
	End
	SZT->(dbSkip())
End

// Localizar sinal de encomenda Baixados no dia
SZS->(dbSetOrder(1))
SZT->(dbSetOrder(3)) //ZT_FILIAL+DToS(ZT_BAIXA)+ZT_TALAO+ZT_PEDIDO
SZT->(dbSeek(xFilial("SZT")+DtoS(dDataInno)))
While !SZT->(Eof()).And.xFilial("SZT")==SZT->ZT_FILIAL.And.SZT->ZT_BAIXA==dDataInno
	Aadd(aSinalAberto,{SZT->ZT_TALAO, SZT->ZT_PEDIDO, SZT->ZT_DATA, SZT->ZT_ENTREGA, SZT->ZT_SINAL,SZT->ZT_BAIXA})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SZT->(dbSkip())
End


// Localizar sinal de encomenda que esta em aberto
SZS->(dbSetOrder(1))
SZT->(dbSetOrder(3)) //ZT_FILIAL+DToS(ZT_BAIXA)+ZT_TALAO+ZT_PEDIDO
SZT->(dbSeek(xFilial("SZT")+Space(8)))
While !SZT->(Eof()).And.xFilial("SZT")==SZT->ZT_FILIAL.And.Empty(SZT->ZT_BAIXA)
	Aadd(aSinalAberto,{SZT->ZT_TALAO, SZT->ZT_PEDIDO, SZT->ZT_DATA, SZT->ZT_ENTREGA, SZT->ZT_SINAL,SZT->ZT_BAIXA})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SZT->(dbSkip())
End


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordenar os sinais de encomenda pela ordem de entrega 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTot:=0
cFlagSinal:="   "
AEval(aSinalAberto, {|X| nTot+=If(empty(X[6]),X[5],0)})
aSinalAberto:= aSort(aSinalAberto,,,{|x,y| Dtos(x[4])+x[1]+x[2] < dtos(y[4])+y[1]+y[2] })
nPosInno:=IA007Pos("S6")
For nI:=1 to Len(aSinalAberto)
	cFlagSinal:=If(empty(aSinalAberto[nI,6]),"   ","[*]")
	IA007aadd(aString,{"  "," AAA BBB CCC    DDD      EEE       FFF          ",{cFlagSinal,aSinalAberto[nI,1],aSinalAberto[nI,2],aSinalAberto[nI,3],aSinalAberto[nI,4],aSinalAberto[nI,5]},{"@!","@!","@!","@!","@!","@E 99,999.99"}}) 
Next nI
If Len(aSinalAberto)<>0
	IA007aadd(aString,{"  ","                                  -----------   ",{}})
	IA007aadd(aString,{"  ","                                   AAA           ",{nTot},{"@E 999,999.99"}}) 
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordenar para impressao na ordem cronologica                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDespesas:= aSort(aDespesas,,,{|x,y| x[4] > y[4] })
For nI:=1 to Len(aDespesas)
	nPosInno:=IA007Pos("XQ")
	IA007aadd(aString,{"  ","AAA       BBB                        CCC        ",{aDespesas[nI,1],aDespesas[nI,2],aDespesas[nI,3]},{"@!","@!","@E 9999,999.99"}}) 
Next nI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ---   Venda Funcionario------- ----------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosInno:=IA007Pos("FD")
If Len(aFuncVnd)>0                      
    nTot:=0
	aFuncVnd := aSort(aFuncVnd,,,{|x,y| x[2] < y[2] })
	AEval(aFuncVnd, {|X| nTot+=X[7]})
	For nI:=1 to Len(aFuncVnd)
//                                ------ ---------- ------------- --  -----------
        IA007aadd(aString,{"  "  ,"AAA    BBB        CCC       DDD EEE  FFF         "	,{aFuncVnd[nI,2],Subs(aFuncVnd[nI,3],1,10),aFuncVnd[nI,4],aFuncVnd[nI,5],aFuncVnd[nI,6],aFuncVnd[nI,7]},{"@!","@!","@!","@!","@!","@E 9999,999.99"}}) 
	Next nI	
	aString[IA007Pos("FF"),3,1]:=nTot       		//Total do Detalhamento Vale Inncencio
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ---   Detalhamento Recebimento PIX    ---------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosInno:=IA007Pos("P3")
nTot:=0
aPIx := aSort(aPix,,,{|x,y| x[1] < y[1] })
AEval(aPix, {|X| nTot+=X[3]})
For nI:= 1 to Len(aPIX)
	IA007aadd(aString,{"  ","AAA    BBB      CCC          DDD                ",{Subs(aPix[nI,1],1,5),aPix[nI,2],aPix[nI,3],aPix[nI,4]},{"@!","@!","@E 9999,999.99","@!"}})
Next nI	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ---   Itens de vendas cancelados------- ----------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Deleted OFF //Processa os registros marcados para Delecao (processar cupons Cancelados)
nTot:=0
nTotDEl:=0
dbSelectArea("SZZ")
SZZ->(dbSetOrder(3))
SZZ->(dbSeek(xFilial("SZZ")+DTOS(dDataInno)))
While !SZZ->(Eof()).And. SZZ->ZZ_FILIAL==xFilial("SZZ").And.SZZ->ZZ_DATA==dDataInno
	nTot++
	If SZZ->(Deleted())
		nTotDEl++
	EndIf
	SZZ->(dbSkip())	
End
aString[IA007Pos("H1"),3,1]:=nTot       		//Total dos itens cartoes
aString[IA007Pos("H2"),3,1]:=nTotDel       		//Total dos itens cartoes cancelados

Set Deleted ON //Processa os registros marcados para Delecao (processar cupons Cancelados)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contabilizacao dos titulos depesas (SE2)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValInic:=0
dbSelectArea("SE2")
SE5->(dbSetOrder(1))
SE5->(dbSeek(xFilial("SE5")+DTOS(dDataInno)+If(Empty(cCaixa),"",cCaixa)))
nReg:=SE5->(Recno())
While !SE5->(Eof()).And. SE5->E5_FILIAL==xFilial("SE5").And.SE5->E5_DATA==dDataInno
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(cCaixa).And.SE5->E5_BANCO==cCaixa
		If Alltrim(SE5->E5_HISTOR)==("FUNDO TROCO INICIAL CAIXA "+cCaixa).AND.SE5->E5_RECPAG=="R"
			nValInic:=SE5->E5_VALOR
			Exit
	    EndIf   
    Else
		If At("FUNDO TROCO INICIAL CAIXA ", Alltrim(SE5->E5_HISTOR))<>0.AND.SE5->E5_RECPAG=="R"
			nValInic+=SE5->E5_VALOR
		EndIf
    EndIf
	SE5->(dbSkip())
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³"AO" ------------         Vendas                -----------         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//"AP" Venda Bruta 
aString[IA007Pos("AP"),3,1]:=aString[IA007Pos("AP"),3,1] //Contador
aString[IA007Pos("AP"),3,2]:=aString[IA007Pos("AP"),3,2] //Valor 
//"AQ" Descontos
aString[IA007Pos("AQ"),3,1]:=aString[IA007Pos("AQ"),3,1] //Contador
aString[IA007Pos("AQ"),3,2]:=aString[IA007Pos("AQ"),3,2] //Valor 
//"AR" Descontos
aString[IA007Pos("AR"),3,1]:=aString[IA007Pos("AR"),3,1] //Contador
aString[IA007Pos("AR"),3,2]:=aString[IA007Pos("AR"),3,2] //Valor 
//"D5" Outro
aString[IA007Pos("D5"),3,1]:=aString[IA007Pos("D5"),3,1] //Contador
aString[IA007Pos("D5"),3,2]:=aString[IA007Pos("D5"),3,2] //Valor 
//"AS" Venda Liquida
aString[IA007Pos("AS"),3,1]:=aString[IA007Pos("AP"),3,1]-aString[IA007Pos("AR"),3,1]-aString[IA007Pos("D5"),3,1] //Contador
aString[IA007Pos("AS"),3,2]:=aString[IA007Pos("AP"),3,2]-(aString[IA007Pos("AR"),3,2]+aString[IA007Pos("AQ"),3,2]+aString[IA007Pos("D5"),3,2]) //Valor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³"AT" ----------- Recebimento Vendas             -----------         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//"AU" Dinheiro
aString[IA007Pos("AU"),3,1]:=aString[IA007Pos("AU"),3,1] //Contador
aString[IA007Pos("AU"),3,2]:=aString[IA007Pos("AU"),3,2] //Valor 
aString[IA007Pos("AU"),3,3]:=(aString[IA007Pos("AU"),3,2]/aString[IA007Pos("AY"),3,2])*100 //Indice
//"AV" Cheque
aString[IA007Pos("AV"),3,1]:=aString[IA007Pos("AV"),3,1] //Contador
aString[IA007Pos("AV"),3,2]:=aString[IA007Pos("AV"),3,2] //Valor 
aString[IA007Pos("AV"),3,3]:=(aString[IA007Pos("AV"),3,2]/aString[IA007Pos("AY"),3,2])*100 //Indice
//"F1" Cartoes
aString[IA007Pos("F1"),3,1]:=aString[IA007Pos("F1"),3,1] //Contador
aString[IA007Pos("F1"),3,2]:=aString[IA007Pos("F1"),3,2] //Valor 
aString[IA007Pos("F1"),3,3]:=(aString[IA007Pos("F1"),3,2] /aString[IA007Pos("AY"),3,2])*100 //Indice
//"FA" Convenio Innocencio
aString[IA007Pos("FA"),3,1]:=aString[IA007Pos("FA"),3,1] //Contador
aString[IA007Pos("FA"),3,2]:=aString[IA007Pos("FA"),3,2] //Valor 
aString[IA007Pos("FA"),3,3]:=(aString[IA007Pos("FA"),3,2] /aString[IA007Pos("AY"),3,2])*100 //Indice

//"IF" iFood
aString[IA007Pos("IF"),3,1]:=aString[IA007Pos("IF"),3,1] //Contador
aString[IA007Pos("IF"),3,2]:=aString[IA007Pos("IF"),3,2] //Valor 
aString[IA007Pos("IF"),3,3]:=(aString[IA007Pos("IF"),3,2] /aString[IA007Pos("AY"),3,2])*100 //Indice

//"B6" Outros 
aString[IA007Pos("B6"),3,1]:=aString[IA007Pos("B6"),3,1] //Contador
aString[IA007Pos("B6"),3,2]:=aString[IA007Pos("B6"),3,2] //Valor 
aString[IA007Pos("B6"),3,3]:=(aString[IA007Pos("B6"),3,2]/aString[IA007Pos("AY"),3,2])*100 //Indice

//"AY" Recebimento de vendas
aString[IA007Pos("AY"),3,1]:=aString[IA007Pos("AY"),3,1] //Contador
aString[IA007Pos("AY"),3,2]:=aString[IA007Pos("AY"),3,2] //Valor 
aString[IA007Pos("AY"),3,3]:=(aString[IA007Pos("AY"),3,2]/aString[IA007Pos("AY"),3,2])*100 //Indice
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³B5 ------------           Resumo                -----------         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Resumo - "BC" Recebimentos Vendas
aString[IA007Pos("BC"),3,1]:=aString[IA007Pos("AY"),3,1]  //Contador de recebimentos
aString[IA007Pos("BC"),3,2]:=aString[IA007Pos("AY"),3,2]  //Valor recebimento
//Resumo - "B7" Depesas
aString[IA007Pos("B7"),3,1]:=aString[IA007Pos("B7"),3,1]  	//Contador Saidas
aString[IA007Pos("B7"),3,2]:=aString[IA007Pos("B7"),3,2] 	//Valor Saidas
//Resumo - "AZ" Fundo de Troco
aString[IA007Pos("AZ"),3,1]:=aString[IA007Pos("AZ"),3,1]+If( nValInic<>0,1,0) //Contador de Fundo de troco +Valor Fundo Troco Inicial
aString[IA007Pos("AZ"),3,2]:=aString[IA007Pos("AZ"),3,2] +nValInic //Valor de Fundo de troco +Valor Fundo Troco Inicial
//Resumo - "B2" Sangria
aString[IA007Pos("B2"),3,1]:=aString[IA007Pos("B2"),3,1] //Contador de Sangria
aString[IA007Pos("B2"),3,2]:=aString[IA007Pos("B2"),3,2] //Valor de Sangria

////Resumo - B8 Saldo (B8=BC-B7+AZ-B2)
aString[IA007Pos("B8"),3,1]:=(aString[IA007Pos("BC"),3,2]+aString[IA007Pos("AZ"),3,2]+aString[IA007Pos("B9"),3,2])-;  //BC Recebimentos Vendas + AC Entrada de Troco+ B9 "Receb.Antecipado)
							 (aString[IA007Pos("B7"),3,2]+aString[IA007Pos("B2"),3,2]);   							// B7 Despesas+B2 Sangrias
							
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³C1 ------------           caixa                 -----------         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Caixa - "C2" Dinheiro = (AU Recebimento Venda dinheiro)+ (AZ Fundo troco inicial)-(B7 Despesas)+(SR Recebimento Sinal)- C2 sangria
aString[IA007Pos("C2"),3,1]:=((aString[IA007Pos("AU"),3,2]+aString[IA007Pos("AZ"),3,2]+aString[IA007Pos("SC"),3,1])-aString[IA007Pos("B7"),3,2])-aString[IA007Pos("C2"),3,1]
//Caixa - "C3" Cheque
aString[IA007Pos("C3"),3,1]:=aString[IA007Pos("AV"),3,1]-aString[IA007Pos("C3"),3,1]		//Qtd CH subtraido sangria
aString[IA007Pos("C3"),3,2]:=aString[IA007Pos("AV"),3,2]-aString[IA007Pos("C3"),3,2]		//Valor caixa CH subtraido sangria
//Caixa - "C6" Outros
//Nao implementado
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³XA ---  Detalhe dos recebimentos     ------------------------------ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosInno:=IA007Pos("EJ")
If Len(aCheques)>0
	IA007aadd(aString,{"XA","--------[Detalhes Recebimentos Cheques]---------"	,{}})
    //Cheques
    nTot:=aString[IA007Pos("AV"),3,2]
	For nI:=1 to Len(aCheques)
		If nI=1
			IA007aadd(aString,{"","Cheques.............. [AAA]:BBB                 ",{Len(aCheques),nTot},{"@E 999","@E 99,999.99"}}) 
		EndIf	
		IA007aadd(aString,{"  ","    Banco..................:AAA                     "	,{aCheques[nI,1]},{}			})
		IA007aadd(aString,{"  ","    Agencia................:AAA                     "	,{aCheques[nI,2]},{}			})
		IA007aadd(aString,{"  ","    Conta..................:AAA                     "	,{aCheques[nI,3]},{}			})
		IA007aadd(aString,{"  ","    Numero Cheque..........:AAA                     "	,{aCheques[nI,4]},{}			})
		IA007aadd(aString,{"  ","    Valor..................:AAA                     "	,{aCheques[nI,5]},{"@E 99,999.99"}			})
		IA007aadd(aString,{"  ","    Telefone...............:AAA                     "	,{aCheques[nI,6]},{}			})
		IA007aadd(aString,{"  ","                                                "	,{}})
	Next nI	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³XB ---   Detalhe de Atendimento ----------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosInno:=IA007Pos("XE")
If Len(aAtend)>0
    //Atendentes
    nTot:=0
	aAtend := aSort(aAtend,,,{|x,y| x[4] > y[4] })
	AEval(aAtend, {|X| nTot+=X[4]})
	For nI:=1 to Len(aAtend)
        cAtend	:=Posicione( "SA3", 1, xFilial("SA3") + aAtend[nI,2], "A3_NOME" )                      
        nPart	:=(aAtend[nI,4]/nTot)*100
		IA007aadd(aString,{"  "  ,"AAA                    BBB  CCC           [DDD%]"	,{Left(cAtend,20),aAtend[nI,3],aAtend[nI,4],nPart},{"@!","@E 999","@E 9999,999.99","@R 999"}}) 
		aString[IA007Pos("XG"),3,1]+=aAtend[nI,3] 	//Detalhe de atendimento - Contador de vendas
		aString[IA007Pos("XG"),3,3]+=nPart			//Detalhe de atendimento - Contador de Part
	Next nI	
	aString[IA007Pos("XG"),3,2]:=nTot       		//Detalhe de atendimento - valor de vendas
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³XC ---   Detalhe Venda Hora --------------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosInno:=IA007Pos("XI")
If Len(aVendHora)>0
    //Atendentes
    nTot:=0
	AEval(aVendHora, {|X| nTot+=X[4]})
	For nI:=1 to Len(aVendHora)
        cFaixa	:=aVendHora[nI,1]+" - "+Strzero(Val(aVendHora[nI,1])+1,2)		//Faixa de horario inicial
        nTM		:=aVendHora[nI,4]/aVendHora[nI,2]					//Ticket Medio
        nPart	:=(aVendHora[nI,4]/nTot)*100						//Participacao do horario
		IA007aadd(aString,{"  "  ,"AAA      BBB  CCC    DDD        EEE       [FFF%]",{cFaixa,aVendHora[nI,2],aVendHora[nI,3],aVendHora[nI,4],nTM,nPart},{"@!","@E 999","@E 9999.99","@E 999,999.99","@E 999.99","@R 999"}}) 
		aString[IA007Pos("XK"),3,2]+=aVendHora[nI,2]				//Detalhes das Vendas Hora - Contador de vendas
		aString[IA007Pos("XK"),3,3]+=aVendHora[nI,3]				//Detalhes das Vendas Hora - Contador de Itens
		aString[IA007Pos("XK"),3,4]+=aVendHora[nI,4]				//Detalhes das Vendas Hora - Valor
		aString[IA007Pos("XK"),3,6]+=nPart							//Detalhes das Vendas Hora - Contador Part.
	Next nI	
	aString[IA007Pos("XK"),3,1]:=Len(aVendHora)       										//Detalhes das Vendas Hora - Contador de horas
	aString[IA007Pos("XK"),3,5]:=aString[IA007Pos("XK"),3,4]/aString[IA007Pos("XK"),3,2]  	//Detalhes das Vendas Hora - Contador de horas
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³XB ---   Detalhe de Delivery ----------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosInno:=IA007Pos("Z3")
IA007aadd(aString,{"  "  ,"AAA                BBB  CCC          DDD"	,{Left("INNOCENCIO",17),aDelivery[1,2],aDelivery[1,3],aDelivery[1,4]},{"@!","@E 999","@E 9999,999.99","@E 9999,999.99"}}) 
IA007aadd(aString,{"  "  ,"AAA                BBB  CCC          DDD"	,{Left("IFOOD",17)     ,aDelivery[2,2],aDelivery[2,3],aDelivery[2,4]},{"@!","@E 999","@E 9999,999.99","@E 9999,999.99"}}) 
IA007aadd(aString,{"  "  ,"AAA"											,{"----------------- ----- -----------  -----------"},{"@!"}}) 
IA007aadd(aString,{"  "  ,"AAA                BBB  CCC          DDD"	,{"                 "  ,aDelivery[1,2]+aDelivery[2,2],aDelivery[1,3]+aDelivery[2,3],aDelivery[1,4]+aDelivery[2,4]},{"@!","@E 999","@E 9999,999.99","@E 9999,999.99"}}) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³AB ---   Indicadores Geral ---------------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//"A8" Vendas (Cupons)
aString[IA007Pos("A8"),3,1]:=aString[IA007Pos("A8"),3,1] //Contador de Cupons
//"D4" Valor
aString[IA007Pos("D4"),3,1]:=aString[IA007Pos("D4"),3,1] //Valor
//"A9" Itens Vendidos
aString[IA007Pos("A9"),3,1]:=aString[IA007Pos("A9"),3,1] //Contador de Cupons
//"A0" Media de Itens por Venda = A9 Itens vendidos/ A8 Numero de vendas
aString[IA007Pos("A0"),3,1]:=(aString[IA007Pos("A9"),3,1]/aString[IA007Pos("A8"),3,1])
//"AA" Ticket Medio = AM Valor 0002+ AF Valor 9901/ A8 	Vendas (Cupons)
aString[IA007Pos("AA"),3,1]:=((aString[IA007Pos("AM"),3,1]+aString[IA007Pos("AF"),3,1])/aString[IA007Pos("A8"),3,1])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³AB ---   Indicadores 0002 ----------------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//"AD" Cupom Inicio
aString[IA007Pos("AD"),3,1]:=aString[IA007Pos("AD"),3,1] //Contador Cupom
//"AE" Cupom Final
aString[IA007Pos("AE"),3,1]:=aString[IA007Pos("AE"),3,1] //Contador Cupom
//"AC" Cupons
aString[IA007Pos("AC"),3,1]:=aString[IA007Pos("AC"),3,1] //Contador Cupom
aString[IA007Pos("AC"),3,2]:=(aString[IA007Pos("AC"),3,1] / aString[IA007Pos("A8"),3,1])*100 //Indice
//"AF" Valor
aString[IA007Pos("AF"),3,1]:=aString[IA007Pos("AF"),3,1] //Contador Cupom
aString[IA007Pos("AF"),3,2]:=(aString[IA007Pos("AF"),3,1]/aString[IA007Pos("D4"),3,1])*100 //Indice
//"D1" Valor
aString[IA007Pos("D1"),3,1] :=aString[IA007Pos("D1"),3,1]//Contador
aString[IA007Pos("D1"),3,2] :=aString[IA007Pos("D1"),3,2]//Valor 
aString[IA007Pos("D1"),3,3]:=(aString[IA007Pos("D1"),3,2]/aString[IA007Pos("D4"),3,1])*100 //Indice
//"AH" Nota fiscal Paulista
aString[IA007Pos("AH"),3,1]:=aString[IA007Pos("AH"),3,1]
aString[IA007Pos("AH"),3,2]:=(aString[IA007Pos("AH"),3,1]/aString[IA007Pos("A8"),3,1])*100 //Indice
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³AI ---   Indicadores 9901 ----------------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//"AK" Cupom Inicio
aString[IA007Pos("AK"),3,1]:=aString[IA007Pos("AK"),3,1] 
//"AL" Cupom Final
aString[IA007Pos("AL"),3,1]:=aString[IA007Pos("AL"),3,1] 
//"AJ" Cupons
aString[IA007Pos("AJ"),3,1]:=aString[IA007Pos("AJ"),3,1] //Contador Cupom
aString[IA007Pos("AJ"),3,2]:=(aString[IA007Pos("AJ"),3,1]/aString[IA007Pos("A8"),3,1])*100 //Indice
//"AM" Valor
aString[IA007Pos("AM"),3,1]:=aString[IA007Pos("AM"),3,1] //Contador Cupom
aString[IA007Pos("AM"),3,2]:=(aString[IA007Pos("AM"),3,1]/aString[IA007Pos("D4"),3,1])*100 //Indice
//"D2" Valor com Cartao de Credito+Debito
aString[IA007Pos("D2"),3,1] :=aString[IA007Pos("D2"),3,1]//Contador
aString[IA007Pos("D2"),3,2] :=aString[IA007Pos("D2"),3,2]//Valor 
aString[IA007Pos("D2"),3,3]:=(aString[IA007Pos("D2"),3,2]/aString[IA007Pos("D4"),3,1])*100 //Indice
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³"C7" --- Transmissao de retaguarda -------------------------------- ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//"CB" Total Vendas
aString[IA007Pos("CB"),3,1]:=aString[IA007Pos("CB"),3,1] 
aString[IA007Pos("CB"),3,2]:=aString[IA007Pos("CB"),3,2] 
//"CA" Cancelados
aString[IA007Pos("CA"),3,1]:=aString[IA007Pos("CA"),3,1] 
aString[IA007Pos("CA"),3,2]:=aString[IA007Pos("CA"),3,2] 
//"CP" Despesas
aString[IA007Pos("CP"),3,1]:=aString[IA007Pos("B7"),3,1]
aString[IA007Pos("CP"),3,2]:=aString[IA007Pos("CP"),3,2] 

//"C0" Outros
aString[IA007Pos("C0"),3,1]:=aString[IA007Pos("C0"),3,1] 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculos das divergencias digitados e processados                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//{"C2","Dinheiro...................:AAA           BBB   "	,{0,0}	,{"@E 999,999.99","@E 999.99"}			,{0,0}}) 
aString[IA007Pos("C2"),3,2]:=aString[IA007Pos("C2"),5,1]-aString[IA007Pos("C2"),3,1]
aString[IA007Pos("EJ"),3,1]:=aString[IA007Pos("C2"),3,1]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]:=aString[IA007Pos("C2"),3,2]		//Totalizador Divergencia

//{"C3","Cheque(*).............[AAA]:BBB           CCC   "	,{0,0,0},{"@E 999","@E 999,999.99","@E 999.99"},{0,0}}) 
aString[IA007Pos("C3"),3,3]:=aString[IA007Pos("C3"),5,1]-aString[IA007Pos("C3"),3,1]
aString[IA007Pos("C3"),3,4]:=aString[IA007Pos("C3"),5,2]-aString[IA007Pos("C3"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("C3"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("C3"),3,4]		//Totalizador Divergencia

//{"G1","Cartao de credito.....[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("G1"),3,3]:=aString[IA007Pos("G1"),5,1]-aString[IA007Pos("G1"),3,1]
aString[IA007Pos("G1"),3,4]:=aString[IA007Pos("G1"),5,2]-aString[IA007Pos("G1"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("G1"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("G1"),3,4]		//Totalizador Divergencia


//"G2","Cartao de Debito......[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("G2"),3,3]:=aString[IA007Pos("G2"),5,1]-aString[IA007Pos("G2"),3,1]
aString[IA007Pos("G2"),3,4]:=aString[IA007Pos("G2"),5,2]-aString[IA007Pos("G2"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("G2"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("G2"),3,4]		//Totalizador Divergencia

//"G3","Voucher...............[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("G3"),3,3]:=aString[IA007Pos("G3"),5,1]-aString[IA007Pos("G3"),3,1]
aString[IA007Pos("G3"),3,4]:=aString[IA007Pos("G3"),5,2]-aString[IA007Pos("G3"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("G3"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("G3"),3,4]		//Totalizador Divergencia

//"G4","Encomenda.............[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("G4"),3,3]:=aString[IA007Pos("G4"),5,1]-aString[IA007Pos("G4"),3,1]
aString[IA007Pos("G4"),3,4]:=aString[IA007Pos("G4"),5,2]-aString[IA007Pos("G4"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("G4"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("G4"),3,4]		//Totalizador Divergencia

//"C6","Vale Innocencio.......[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("C6"),3,3]:=aString[IA007Pos("C6"),5,1]-aString[IA007Pos("C6"),3,1]
aString[IA007Pos("C6"),3,4]:=aString[IA007Pos("C6"),5,2]-aString[IA007Pos("C6"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("C6"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("C6"),3,4]		//Totalizador Divergencia

//"G6","Ifood............[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("G6"),3,3]:=aString[IA007Pos("G6"),5,1]-aString[IA007Pos("G6"),3,1]
aString[IA007Pos("G6"),3,4]:=aString[IA007Pos("G6"),5,2]-aString[IA007Pos("G6"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("G6"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("G6"),3,4]		//Totalizador Divergencia

//"PI","PIX............[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("PI"),3,3]:=aString[IA007Pos("PI"),5,1]-aString[IA007Pos("PI"),3,1]
aString[IA007Pos("PI"),3,4]:=aString[IA007Pos("PI"),5,2]-aString[IA007Pos("PI"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("PI"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("PI"),3,4]		//Totalizador Divergencia

//"G5","Outros................[AAA]:BBB       CCCDDD   "	,{0,0,0,0},{"@E 999","@E 99,999.99","@E 999","@E 9999.99"},{0,0}}) 
aString[IA007Pos("G5"),3,3]:=aString[IA007Pos("G5"),5,1]-aString[IA007Pos("G5"),3,1]
aString[IA007Pos("G5"),3,4]:=aString[IA007Pos("G5"),5,2]-aString[IA007Pos("G5"),3,2]
aString[IA007Pos("EJ"),3,1]+=aString[IA007Pos("G5"),3,2]		//Totalizador Valor
aString[IA007Pos("EJ"),3,2]+=aString[IA007Pos("G5"),3,4]		//Totalizador Divergencia

//"D6" reimpressao
aString[IA007Pos("D6"),3,1] :=aString[IA007Pos("D6"),3,1]//Contador
aString[IA007Pos("D6"),3,2] :=aString[IA007Pos("D6"),3,2]//Valor 
aString[IA007Pos("D6"),3,3]:=( aString[IA007Pos("D6"),3,1]/(aString[IA007Pos("AJ"),3,1]+aString[IA007Pos("D6"),3,1]))*100 //Indice

nFecha++
aString[IA007Pos("A2"),3,1]:=Strzero(nFecha,3)					//Identifica o numero de vezez que fez a impressao do fechamento
IncProc() 		//Processou o SE5 E SE2
// Final do processamento dos dados 

//================================Montando relatorio para impressao ==================================================================================
aRelComp:={}
nPosInic:=1
nPosFim	:=Len(aString)
For nI:=nPosInic to nPosFim
	cLinha:=aString[nI,2]
	If Len(aString[nI,3])>0
		For nX:=1 to Len(aString[nI,3])
		    cInfo:=aString[nI,3,nX]
	     	If Len(aString[nI,4])>0
		        cInfo:=Transform(cInfo,aString[nI,4,nX])
		    EndIf    
			cPesq:=Repli(chr(64+nX),3) //"AAA..BBB...CCC....DDDD...
            cLinha:=Stuff(cLinha,At(cPesq,cLinha),Len(cInfo),cInfo)
		Next nX
	EndIf	
	aadd(aRelComp,cLinha)
	cString+=cLinha+Chr(13)+Chr(10)
Next nI
If lChkPgto //Impressao do detalhamento das formas de pagamento
	cString+="----------[Detalhes forma pagamento]------------"+Chr(13)+Chr(10)
	cString+="Numero  Hora      Forma Pagamento        Valor  "+Chr(13)+Chr(10)
	cString+="------  -----  --------------------  -----------"+Chr(13)+Chr(10)
	aPgtos:= aSort(aPgtos,,,{|x,y| x[3] < y[3] })
	For nI:=1 to len(aPgtos)
		cString+=aPgtos[nI,1]+"  "+aPgtos[nI,2]+"  "+aPgtos[nI,3]+"   "+Transform(aPgtos[nI,4],"@E 999,999.99")+Chr(13)+Chr(10)
	Next nI
EndIf	
Set Deleted ON //Processa os registros marcados para Delecao (processar cupons Cancelados)
IncProc() 		//Processou o cString
// Mensagem de impressao.

If nFechaCR=2 .and.lSenhaRel
	aCupom := Aclone(aRelComp)
	oLbxRel:SetArray( aCupom )
	oLbxRel:Refresh()
EndIf

//Juntado o Fechamento Completo + Resumido para impressao e envio pelo email
cString+=cStringAux

//cNome:=	Subs(aString[IA007Pos("A5"),3,1],5)
//IA007SendFec(cCaixa,cNome,dDataInno,cString)

Return cString

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA007Soma   ³ Autor ³ Marcos Alves	     ³ Data ³ 08/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Refresh dos valores de caixa                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³IA007Soma(cPos)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function IA007Soma(cPos)
Static Function IA007Soma(cPos)
Local lRet	:=.T.
If cPos$"E6#E7#E4"	//RedCard
	aString[IA007Pos("E5"),5,1]:=aString[IA007Pos("E6"),5,1]+aString[IA007Pos("E7"),5,1]
	aString[IA007Pos("E5"),5,2]:=aString[IA007Pos("E6"),5,2]+aString[IA007Pos("E7"),5,2]
	
	aString[IA007Pos("E3"),5,1]:=aString[IA007Pos("E4"),5,1]
	aString[IA007Pos("E3"),5,2]:=aString[IA007Pos("E4"),5,2]
	
	aString[IA007Pos("E2"),5,1]:=aString[IA007Pos("E3"),5,1]+aString[IA007Pos("E5"),5,1]
	aString[IA007Pos("E2"),5,2]:=aString[IA007Pos("E3"),5,2]+aString[IA007Pos("E5"),5,2]
ElseIf cPos$"EA#EB#ED#EG"	//Visa
	aString[IA007Pos("E9"),5,1]:=aString[IA007Pos("EA"),5,1]+aString[IA007Pos("EB"),5,1]
	aString[IA007Pos("E9"),5,2]:=aString[IA007Pos("EA"),5,2]+aString[IA007Pos("EB"),5,2]
	
	aString[IA007Pos("EC"),5,1]:=aString[IA007Pos("ED"),5,1]
	aString[IA007Pos("EC"),5,2]:=aString[IA007Pos("ED"),5,2]
	
	aString[IA007Pos("EF"),5,1]:=aString[IA007Pos("EG"),5,1]
	aString[IA007Pos("EF"),5,2]:=aString[IA007Pos("EG"),5,2]
	
	aString[IA007Pos("E8"),5,1]:=aString[IA007Pos("E9"),5,1]+aString[IA007Pos("EC"),5,1]+aString[IA007Pos("EF"),5,1]
	aString[IA007Pos("E8"),5,2]:=aString[IA007Pos("E9"),5,2]+aString[IA007Pos("EC"),5,2]+aString[IA007Pos("EF"),5,2]
ElseIf cPos$"EI"	//America
	aString[IA007Pos("EH"),5,1]:=aString[IA007Pos("EI"),5,1]
	aString[IA007Pos("EH"),5,2]:=aString[IA007Pos("EI"),5,2]
EndIf
Return lRet


Static Function IA007Pos(cPesq)
Local nRet:=Ascan(aString,{|X|X[1]==cPesq })
Return nRet

//Static Function IA007aadd(aInno,aArray)
Static Function IA007aadd(aInno,aArray)
nPosInno++
aadd(aString,{"",""	,{}}) //Para inserir vetore multidimencional precisa incluir novo elemento antes do comando aIns()
aIns(aString,nPosInno)	
aString[nPosInno]:=Aclone(aArray)
Return NIl

Static Function IA007VldCX(oCaixa,cCaixa,oNome,cNome,dDataInno,cCaixaSup,aCedulas,nQtdVI,nValVI,nQtdSE, nValSE,nQtdIF,nValIF,nQtdPIX, nValPIX)
Local aArea     	:= GetArea()
Local lRet			:= .T.

SA6->(dbSetOrder(1))
SA6->(dbSeek(xFilial("SA6")+cCaixa))
SX5->(dbSeek(xFilial("SX5")+"23"+cCaixa)) 
cNome:=AllTrim(SX5->(X5_DESCRI))
oCaixa:Refresh()
oNome:Refresh()
IA007Restaura(dDataInno,cCaixa,@aCedulas,@nQtdVI,@nValVI,@nQtdSE, @nValSE,@nQtdIF, @nValIF,@nQtdPIX, @nValPIX)
oGet:Refresh()
oTotDin:Refresh()
oTotCart:Refresh()
/*

If !Empty(cCaixa)
	If SX5->(dbSeek(xFilial("SX5")+"23"+cCaixa)) .and. SA6->(dbSeek(xFilial("SA6")+cCaixa))
		cNome:=AllTrim(SX5->(X5_DESCRI))
	    oCaixa:Refresh()
	    oNome:Refresh()
	Else
        MsgInfo("Caixa não encontrado")
    	lRet:=.F.
	EndIf	
EndIf
IA007Restaura(dDataInno,cCaixa,@aCedulas,@nQtdVI,@nValVI,@nQtdSE, @nValSE)
oGet:Refresh()
oTotDin:Refresh()
oTotCart:Refresh()
*/
RestArea(aArea)   
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA007Add()
Local nTotVal	:=0

oGet:lChgField:=.F.
oGet:AddLine()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡„o    ³IA007LinOk    ³ Autor ³ Marcos Alves	     ³ Data ³ 07/02/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡„o ³Validcao da linha do aCols dos cartoes                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³F1297LinOkInno(oLin,nTipo)                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IA007LinOk(oLin,nTipo)
Local lRet 		:= .T.
Local nTotVal	:=0
Local cBandeira	:= aCols[n][1]
Local cTipo		:= aCols[n][2]
default nTipo	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificacao se a linha esta deletada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !aCols[n][nUsado+1]
	For nI:=1 to Len(aCols)
        If nI<>n
			If !aCols[nI][nUsado+1]
                /* poder inserir das duas maquinestas
				If aCols[nI][1]==cBandeira.AND.aCols[nI][2]==cTipo
				   MsgInfo("Bandeira e Tipo ja incluido na linha "+ Strzero(nI,2))
				   lRet := .F.
				   Exit
				EndIf   
				*/
			EndIf
		EndIf	
	Next nI		   
	If Empty(aCols[n][1])
      MsgInfo("Nao sera permitido linhas sem o Bandeira Informada.")
      lRet := .F.
	ElseIf Empty(aCols[n][2])
      MsgInfo("Nao sera permitido linhas sem o Tipo Informada.")
      lRet := .F.
	ElseIf aCols[n][3]<=0
      MsgInfo("Nao sera permitido linhas sem o Quant. Informada.")
      lRet := .F.
	ElseIf aCols[n][4]<=0
      MsgInfo("Nao sera permitido linhas sem o Valor Informado.")
      lRet := .F.
	EndIf		
Endif
Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³IA007ValVld ³ Autor ³Marcos Alves           ³ Data ³07/02/17³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida o valor digitado e atualiza o total				  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IA007ValVld(nTipo)
Local lRet		:=.T.
Local nVal		:= GetMemvar("ZW_VALOR") //Valor das transacoes de cartoes

default nTipo	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificacao se a linha esta deletada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !aCols[n][ nUsado+1 ].AND. nVal<= 0
	MsgInfo("Valor inválido.")
    lRet := .F.
Else
	nTotCart:=0
    aCols[n,4]:=nVal
	AEval(aCols, {|X| nTotCart+=If(!X[nUsado+1],X[4],0)})
	oTotCart:cCaption:=Transform(nTotCart,"@E 99,999.99") 
	oTotCart:Refresh()
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³															  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA007DEl()
Local lRet		:=.T.
Local nVal		:= aCols[n][4] //Valor do rateio da natureza
Local cBandeira	:= aCols[n][1]
Local cTipo		:= aCols[n][2]

nTotCart:=0
If aCols[n,Len(Acols[n])]
	For nI:=1 to Len(aCols)
		If nI<>n
			If !aCols[nI][nUsado+1]
				If aCols[nI][1]==cBandeira.AND.aCols[nI][2]==cTipo
				   MsgInfo("Bandeira e Tipo ja incluido na linha "+ Strzero(nI,2))
				   lRet := .F.
				   Exit
				EndIf   
			EndIf
		EndIf	
	Next nI		   
EndIf	
If lRet
	aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])]

	AEval(aCols, {|X| nTotCart+=If(!X[nUsado+1],X[4],0)})
	oTotCart:cCaption:=Transform(nTotCart,"@E 99,999.99") 
	oTotCart:Refresh()
	oGet:Refresh()
EndIf	

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³IA007BandVld³ Autor ³Marcos Alves           ³ Data ³08/02/17³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida se a Bandeira digitada esta cadastrada na tabela    ³±±
±±³          ³SX5 e faz a inclusao                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IA007BandVld(nTipo)
Local lRet		:=.T.
Local cBand		:= GetMemvar("ZW_BAND") // Bandeira 
Local cChave	:=""
default nTipo	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificacao se a linha esta deletada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cBand)
	MsgInfo("Bandeira nao Informada.")
	lRet := .F.
Else
	If lRet
		If SX5->(MsSeek(xFilial("SX5")+"ZW"))
			While !SX5->(EOF()).AND. SX5->X5_FILIAL==xFilial("SX5").AND.SX5->X5_TABELA=="ZW"
				If 	Upper(Alltrim(cBand))==Upper(AllTrim(SX5->X5_DESCRI))
					cChave:=""
					Exit
				EndIf
				cChave:=Alltrim(SX5->X5_CHAVE)
				SX5->(DBSkip())
			End
		Else
			cChave:="00"
		EndIf				
		If !Empty(cChave).AND. MsgYesNo("Bandeira nao casdastrada, incluir?")
			Reclock("SX5",.T.)
			SX5->X5_FILIAL := xFilial("SX5")
			SX5->X5_TABELA := "ZW"
			SX5->X5_CHAVE  := Soma1(cChave)
			SX5->X5_DESCRI := Upper(cBand)
			SX5->X5_DESCSPA:= Upper(cBand)
			SX5->X5_DESCENG:= Upper(cBand)
			SX5->( MsUnlock() )
		Endif
	EndIf
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³IA007ImpRel ³ Autor ³Marcos Alves           ³ Data ³08/02/17³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do relatorio 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA007ImpRel(aCedulas,nHdlECF,cString,cCaixa, dDataInno,nFechaCR)
Local lRet		:=.T.

//Verifica se náo tem TEF/DOC sem digitar
If !IA007VldTef(dDataInno)
	Return NIL
EndIf	
//Impressao do Relatorio 
nTotalCedula:=0
AEval(aCedulas, {|X| nTotalCedula+=X[3]})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CursorWait()
nRet := IFStatus(nHdlECF, "5", "")				// Verifica Cupom Fechado
If (nRet == 0 .OR. nRet == 7)
	If (nRet := IFRelGer(nHdlECF, cString)) <> 0 
		// "Não foi possível realizar a Abertura do Caixa. Erro na impressão do comprovante.", "Atenção"
		HELP(' ',1,'FRT021')
	EndIf
EndIf

CursorArrow()
U_IA223InitVar()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Folder "Reatorio"                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA007FRelatorio(cCaixaSup,nIndo,nEstou,cPDV,cCaixa,cPdv99,dDataInno,lChkPgto,nFechaCR,aCupom,oLbxRel,aCedulas,oBtnAct,cNome,nQtdVI, nValVI,nQtdSE, nValSE,nQtdIF,nValIF,nQtdPIX,nValPIX,oBtnImp,cString)
Local lRet			:=	.T.
Local cSupervisor  	:= Space(15)
Local cStringAux	:=""
Local cStringResumido	:=""
Local cStringCompleto	:=""
Local cStringMsMoney	:=""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os objetos.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFld:Refresh()

If nIndo=4 // Fechamento completo (Imprime tb o resumido)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ 19/03/15 - Verifica Permissao "Sangria/Entrada de Troco" - #5  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nFechaCR=2
		If !LJProfile(21, @cSupervisor)		// Leitura X
			lSenhaRel	:=.F.
		Else
			lSenhaRel	:=.T.
    	EndIf
		
		//Processando do fechamento - Resumido
		Processa( { ||cStringResumido:=IA007ImpCart(aCols,dDataInno,cCaixa,cNome,oLbxRel,aCupom,aCedulas,nQtdVI,nValVI,nQtdSE,nValSE,nQtdIF,nValIF)}, "Aguarde...","Gerando relatorio")

		//Processando do fechamento - Completo
		Processa( { ||cStringCompleto:=IA007Proc(cStringAux, cPDV,cCaixa,cPdv99,dDataInno,lChkPgto,nFechaCR,aCupom,oLbxRel,aCedulas,oBtnAct,cNome,@nQtdVI, @nValVI,@nQtdSE, @nValSE,@nQtdIF, @nValIF,@nQtdPIX,@nValPIX)}, "Aguarde...","Gerando relatorio")

		//Processando do fechamento - Resumido
		Processa( { ||cStringMsMoney:=IA007IMoney(aCols,dDataInno,cCaixa,cNome,oLbxRel,aCupom,aCedulas,nQtdVI,nValVI,nQtdSE,nValSE,nQtdIF,nValIF)}, "Aguarde...","Gerando relatorio")

		//Juntado o Fechamento Completo + Resumido para impressao e envio pelo email
		//cString:=cStringCompleto+cStringResumido+cStringMsMoney
		cString:=cStringMsMoney

		cNome:=	Subs(aString[IA007Pos("A5"),3,1],5)
		IA007SendFec(cCaixa,cNome,dDataInno,cStringCompleto+cStringResumido+cStringMsMoney)

    Else //Fechamento Resumido
		//Processando do fechamento - Resumido
		Processa( { ||cString:=IA007ImpCart(aCols,dDataInno,cCaixa,cNome,oLbxRel,aCupom,aCedulas,nQtdVI,nValVI,nQtdSE,nValSE,nQtdIF,nValIF)}, "Aguarde...","Gerando relatorio")

		//Processando do fechamento - Completo
		Processa( { ||cRelComp:=IA007Proc(cString,cPDV,cCaixa,cPdv99,dDataInno,lChkPgto,nFechaCR,aCupom,oLbxRel,aCedulas,oBtnAct,cNome,@nQtdVI, @nValVI,@nQtdSE, @nValSE,@nQtdIF, @nValIF,@nQtdPIX,@nValPIX)}, "Aguarde...","Gerando relatorio")
    EndIf
	oBtnImp:Enable()
Else
	oBtnImp:Disable()
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³grava os valores de dinheiro, cartao e outros digitados     ³±±
±±³          ³pelos caixa                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio SZW SZY                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA007Save(dDataInno,aCedulas,cCaixa,nQtdVI, nValVI,nQtdSE, nValSE,nQtdIF,nValIF)

//--------------------------------------Gravacao na SZY
Local lLock		:=.T.                             
Local cTime		:=Time()

dbSelectArea("SZY")
dbSetOrder(1)

lLock:=!(SZY->(dbSeek(xFilial("SZY")+DToS(dDataInno)+cCaixa)))

SZY->(RecLock("SZY", lLock))
SZY->ZY_FILIAL 	:= xFilial("SZY")
SZY->ZY_DATA 	:= dDataInno
SZY->ZY_HORA 	:= cTime
SZY->ZY_CAIXA 	:= cCaixa
SZY->ZY_QUANT 	:= nFecha
//SZY->ZY_DINH	:=aString[IA007Pos("C2"),5,1]
//SZY->ZY_NHEQUE	:=aString[IA007Pos("C3"),5,1] 
//SZY->ZY_CHEQUE	:=aString[IA007Pos("C3"),5,2]
SZY->ZY_DIN005	:=aCedulas[1,3]
SZY->ZY_DIN010	:=aCedulas[2,3]
SZY->ZY_DIN025	:=aCedulas[3,3]
SZY->ZY_DIN050	:=aCedulas[4,3]
SZY->ZY_DIN1	:=aCedulas[5,3]
SZY->ZY_DIN2	:=aCedulas[6,3]
SZY->ZY_DIN5	:=aCedulas[7,3]
SZY->ZY_DIN10	:=aCedulas[8,3]
SZY->ZY_DIN20	:=aCedulas[9,3]
SZY->ZY_DIN50	:=aCedulas[10,3]
SZY->ZY_DIN100 	:=aCedulas[11,3]

SZY->ZY_NVINNO	:=nQtdVI
SZY->ZY_VINNO	:=nValVI

SZY->ZY_CVALIM	:=nValSE
SZY->ZY_NCVALIM	:=nQtdSE

//Ifood
SZY->ZY_CVALIF	:=nValIF
SZY->ZY_NCVALIF	:=nQtdIF

SZY->(MsUnLock())  
//Atulizar o valor total em dinheiro
nTotDin:=0
AEval(aCedulas, {|X| nTotDin+=X[3]})
//aString[IA007Pos("C2"),5,1]:=nTotDin

//--------------------------------------Final Gravacao na SZY

//--------------------------------------Gravacao na SZW
lLock	:=.T.
dbSelectArea("SZW")
dbSetOrder(1)
SZW->(dbSeek(xFilial("SZW")+DToS(dDataInno)+cCaixa))
While !SZW->(Eof()).AND.SZW->ZW_FILIAL==xFilial("SZW").AND.SZW->ZW_DATA==dDataInno.AND.Subs(SZW->ZW_CAIXA,1,3)==cCaixa
	SZW->(RecLock("SZW",.F.))
	SZW->(dbDelete())
	SZW->(MsUnLock())  
	SZW->(DbSkip())
End
For nI:= 1 to Len(aCols)
	lLock	:=.T.
	If aCols[nI,5]
		Loop
	EndIf	
	dbSetOrder(1)
	SZW->(RecLock("SZW",lLock))
	SZW->ZW_FILIAL 	:= xFilial("SZW")
	SZW->ZW_DATA 	:= dDataInno
	SZW->ZW_HORA 	:= cTime
	SZW->ZW_CAIXA 	:= cCaixa
	SZW->ZW_ADM 	:= "CIELO"
	SZW->ZW_BAND 	:= aCols[nI,1] 	//Bandeira do cartão
	SZW->ZW_TIPO 	:= aCols[nI,2]	//Tipo do Cartao
	SZW->ZW_QTD 	:= aCols[nI,3]	//Quantidade de transaçoes do cartao
	SZW->ZW_VALOR	:= aCols[nI,4]	//Valor total das transacoes
	SZW->(MsUnLock())  
Next nI	
MsgInfo("Dados gravados com sucesso!!","Atenção")

Return NIl


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³			³ Autor ³Marcos Alves           ³ Data ³ 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Restaura os valores de dinheiro, cartao e outros digitados  ³±±
±±³          ³pelos caixa                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Innocencio                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA007Restaura(dDataInno,cCaixa,aCedulas,nQtdVI,nValVI,nQtdSE, nValSE,nQtdIF,nValIF,nQtdPIX,nValPIX)
Local nReg		:= 0
Local aCampos	:={}

nTotDin		:=0
nTotCart	:=0
aCols		:={}
aHeader		:={}
nUsado		:=0
//Restaura SZW
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos para o aCols das Multiplas Naturezas             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aCampos,"ZW_BAND")
aadd(aCampos,"ZW_TIPO")
aadd(aCampos,"ZW_QTD")
aadd(aCampos,"ZW_VALOR")

dbSelectArea("SX3")
dbSetOrder(2)
For nC:=1 to Len(aCampos)
	dbSeek(aCampos[nC])
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()) ,;
	               X3_CAMPO    ,;
	               X3_PICTURE  ,;
	               X3_TAMANHO  ,;
	               X3_DECIMAL  ,;
	               X3_VALID    ,;
	               X3_USADO    ,;
	               X3_TIPO     ,;
	               X3_F3	  ,;
	               X3_CONTEXT  })

Next nC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incluir Funcao Inno para validar se a Natureza ja foi digitadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader[1][6]:="U_IA007BandVld()"		 //+Alltrim(aHeader[1][6])		//X3_VALID EV_NATUREZ
aHeader[4][6]:="U_IA007ValVld()"		//X3_VALID EV_VALOR
//Identifica o numero de vezez que fez a impressao do fechamento
dbSelectArea("SZW")
dbSetOrder(1)
SZW->(dbSeek(xFilial("SZW")+DToS(dDataInno)+cCaixa))
While !SZW->(Eof()).AND.SZW->ZW_FILIAL==xFilial("SZW").AND.SZW->ZW_DATA==dDataInno.AND.Subs(SZW->ZW_CAIXA,1,3)==cCaixa
	AADD(aCols,{SZW->ZW_BAND,SZW->ZW_TIPO,SZW->ZW_QTD,SZW->ZW_VALOR,.F.})
	nTotCart+=SZW->ZW_VALOR
	SZW->(DbSkip())
End
If Empty(aCols)
	AADD(aCols,{SZW->ZW_BAND,SZW->ZW_TIPO,SZW->ZW_QTD,SZW->ZW_VALOR,.F.})
EndIf

//-----------------------------Final Restore SZW ---------------------

//Restaura SZY
aCedulas := {}
aadd(aCedulas,{0.05,0,0})
aadd(aCedulas,{0.10,0,0})
aadd(aCedulas,{0.25,0,0})
aadd(aCedulas,{0.50,0,0})
aadd(aCedulas,{1.00,0,0})
aadd(aCedulas,{2.00,0,0})
aadd(aCedulas,{5.00,0,0})
aadd(aCedulas,{10.00,0,0})
aadd(aCedulas,{20.00,0,0})
aadd(aCedulas,{50.00,0,0})
aadd(aCedulas,{100.00,0,0})

//Identifica o numero de vezez que fez a impressao do fechamento
dbSelectArea("SZY")
dbSetOrder(1)
SZY->(dbSeek(xFilial("SZY")+DToS(dDataInno)+cCaixa))

nFecha:=SZY->ZY_QUANT

//Vale Innocencio
nQtdVI:=SZY->ZY_NVINNO	
nValVI:=SZY->ZY_VINNO

//Sinal Encomenda
nValSE:=SZY->ZY_CVALIM
nQtdSE:=SZY->ZY_NCVALIM
	
//Ifood
nValIF:=SZY->ZY_CVALIF
nQtdIF:=SZY->ZY_NCVALIF

aCedulas[1,3]:=SZY->ZY_DIN005
aCedulas[1,2]:=aCedulas[1,3]/aCedulas[1,1]

aCedulas[2,3]:=SZY->ZY_DIN010
aCedulas[2,2]:=aCedulas[2,3]/aCedulas[2,1]

aCedulas[3,3]:=SZY->ZY_DIN025
aCedulas[3,2]:=aCedulas[3,3]/aCedulas[3,1]

aCedulas[4,3]:=SZY->ZY_DIN050
aCedulas[4,2]:=aCedulas[4,3]/aCedulas[4,1]

aCedulas[5,3]:=SZY->ZY_DIN1
aCedulas[5,2]:=aCedulas[5,3]/aCedulas[5,1]

aCedulas[6,3]:=SZY->ZY_DIN2
aCedulas[6,2]:=aCedulas[6,3]/aCedulas[6,1]

aCedulas[7,3]:=SZY->ZY_DIN5
aCedulas[7,2]:=aCedulas[7,3]/aCedulas[7,1]

aCedulas[8,3]:=SZY->ZY_DIN10
aCedulas[8,2]:=aCedulas[8,3]/aCedulas[8,1]

aCedulas[9,3]:=SZY->ZY_DIN20
aCedulas[9,2]:=aCedulas[9,3]/aCedulas[9,1]

aCedulas[10,3]:=SZY->ZY_DIN50
aCedulas[10,2]:=aCedulas[10,3]/aCedulas[10,1]

aCedulas[11,3]:=SZY->ZY_DIN100
aCedulas[11,2]:=aCedulas[11,3]/aCedulas[11,1]

nFecha:=SZY->ZY_QUANT

AEval(aCedulas, {|X| nTotDin+=X[3]})

IA007PIX(dDataInno,cCaixa,@nQtdPIX,@nValPIX)

Return Nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LjProfile  | Autor ³ Marcos Alves        ³ Data ³17/07/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verificar se usuario tem acesso aos processos              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LJProfile(nAcesso,cStrAcesso)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nAcesso    - Numero do Acesso do Processo                  ³±±
±±³          ³ cCaixaSup  - Nome do Caixa Superior                        ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SIGALOJA / FRONTLOJA                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³ Data/Bops/Ver ³Manutencao Efetuada                      	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLuiz Couto³03/06/05³811   ³- BOPS 80835/80856 Adicionado 3 variaveis   º±±
±±º          ³        ³      ³ estaticas para o controle da exibicao da   º±±
±±º          ³        ³      ³ tela de permissao de desconto.          	  º±±
±±ºMagh Moura³20/06/05|82880 ³- Se Loja120 nao foi compilado e permissao  º±±
±±º          ³        ³      ³ nao existir assume N (acesso negado)       º±± 
±±º          ³        ³      ³ Permissao 16(reabre caixa) em branco assumeº±±
±±º          ³        ³      ³ S (acesso liberado)                        º±±
±±ºAdrianne  ³09/08/05|85243 ³- Validacao para exibir mensagem caso o     º±±
±±º          ³        ³      ³ usuario nao tenha permissao para cancela-  º±± 
±±º          ³        ³      ³ mento manual de TEF.                       º±±   
±±ºMarcos R. ³11/08/05|84267 ³- Incluido 2 parametros na funcao LJSenhaSupº±±
±±º          ³        ³      ³ para validar a permissao do desconto.      º±± 
±±ºLuiz Couto³03/10/05|86821 ³- Alterado o parametro DEFAUL aDesc para o  º±±
±±º          ³        ³      ³ valor do desconto como sendo o nDescLoj.   º±± 
±±ºGeronimo  ³23/02/06|91876 | Corrigida ocorrencia onde qualquer descontoº±±
±±º          ³        ³      ³ era aprovado se sistema fosse configurado  º±± 
±±º          ³        ³      ³ para pedir usuario e senha e na tela de    º±± 
±±º          ³        ³      ³ aprovacao fosse clicado no botao OK sem    º±± 
±±º          ³        ³      ³ digitacao no campo senha.                  º±± 
±±ºHanna C.  ³25/04/06|096655| Retirada a funcao para fechar a janela     º±±
±±º          ³        ³      ³ oDlgSenha                                  º±± 
±±ºThiago H  ³24/04/06³95907 ³ -Correcao na aparicao da tela solicitando  º±± 
±±º          ³        ³      ³  a senha do superior na finalizacao da     º±± 
±±º          ³        ³      ³  venda.                                    º±± 
±±ºConrado Q.³05/04/07³122711³Alterada a utilização da chamada            º±±
±±º          ³        ³      ³SubStr(cUsuario,7,15) por cUserName         º±±
±±º          ³        ³      ³Alterado utilização da variavel cCaixaSup   º±±
±±º          ³        ³      ³para se adequar ao novo tamanho de 25       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IA007PswSup()

Local oGetSup										// Objeto Get com o nome do superior que informou a senha
Local OGetSenha										// Objeto Get com a senha do superior
Local oDlgSenha										// Objeto da caixa de dialogo da senha do supervisor
Local lRet		  := .F.							// Variavel que controla o retorno
Local cSenhaSup	  := Space(6)						// Senha digitada do supervisor
Local cBitMap	  := "LOGIN"						// Bitmap utilizado na caixa de dialogo
Local cCaixaAtu	  := cUserName					    // Caixa atual
Local aArea		  := GetArea()					    // Salva a area, para ser restaurada ao final da funcao
Local aPermissao  := {}							    // Array com as permissoes
Local cTitle	  := ""							    // Titulo da janela de autorizacao do supervisor
Local lDesc 	  := .F.							// Valida se houve desconto
Local lVerProfile := .F.							// Controla se verifica profile para desconto 
Local nSA6Recno	  := SA6->( Recno() )				// Variavel com o registro do SA6
Local cFormDesc   := SuperGetMV( "MV_LJFORMD",.F.,"1" )  // Caso nao exista o parametro assume "1" como DEFAULT
Local nOpcA		  := 0 								// Botao confirmar
Local nX		  := 0								// Variavel contadora para Loop
Local cCaixaSup  := Space(25)						// Caixa superior


DEFINE DIALOG oDlgSenha TITLE cTitle FROM 20, 20 TO 225,310 PIXEL 

@ 0, 0 BITMAP oBmp1 RESNAME cBitMap oF oDlgSenha SIZE 50,140 NOBORDER WHEN .F. PIXEL

@ 05,55 SAY "Caixa Atual"	PIXEL						                   // Caixa Atual
@ 15,55 MSGET cCaixaAtu WHEN .F. PIXEL SIZE 80,08

@ 30,55 SAY "Caixa Superior" PIXEL							               // Caixa Superior
@ 40,55 MSGET oGetSup VAR cCaixaSup WHEN .F. PIXEL SIZE 80,08

@ 55,55 SAY "Senha Superior" PIXEL                                          // Senha Superior
@ 65,55 MSGET oGetSenha VAR cSenhaSup PASSWORD PIXEL SIZE 40,08 VALID IA007SenhaSup(cSenhaSup,@cCaixaSup)

DEFINE SBUTTON FROM 85,75  TYPE 1 ACTION ( If(lRet:=IA007SenhaSup(cSenhaSup,@cCaixaSup),oDlgSenha:End(),)) ENABLE OF oDlgSenha
DEFINE SBUTTON FROM 85,105 TYPE 2 ACTION { || lRet := .F., oDlgSenha:End() } ENABLE OF oDlgSenha

ACTIVATE MSDIALOG oDlgSenha CENTERED 


Return lRet


Static Function IA007SenhaSup(cSenhaSup,cCaixaSup)
Local lRet	:=.F.

PswOrder(3)
PswSeek(cSenhaSup)

If !aConfig()[4]
	aReg      := PswRet()
	cCaixaSup := If(len(aReg)>0,aReg[1][2],cCaixaSup)
Endif

lRet:=Alltrim(Upper(cCaixaSup))=="MASTER"
If !lRet
	MsgInfo("Senha Invalida!!!")
EndIf	

//Return lRet
Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³I223ImpRecibo    ³Autor  ³Marcos Alves   º Data ³18/03/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impessao do vale de compra dos Funcionarios				  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA007ImpCart(aCols,dData,cCaixa,cNome,oLbxRel,aCupom,aCedulas,nQtdVI,nValVI,nQtdSE,nValSE,nQtdIF,nValIF)
Local cString :=""
Local nPos	:=0
Local nTotal:=0
Local aTipo	:={"CREDITO","DEBITO","VOUCHER"}
Local nCC	:=0
Local nCD	:=0
Local nVO	:=0

Local nQCC	:=0
Local nQCD	:=0
Local nQVO	:=0
Local nTotal:=0

AEval(aCedulas, {|X| nTotal+=X[3]})

ProcRegua(Len(aCols))
cString+="================================================"+Chr(13)+Chr(10)
cString+="v7.............Fechamento Resumido.... ........."+Chr(13)+Chr(10)
cString+="Data...........:"+dtoc(dData)+"       Hora....:"+Time()+Chr(13)+Chr(10)
cString+="Caixa..........:"+cCaixa+"-"+Subs(alltrim(cNome)+Repli(".",28),1,28)+Chr(13)+Chr(10)
cString+="================================================"+Chr(13)+Chr(10)
cString+="[Cedula]............[Qtd].............[ Valor  ]"+Chr(13)+Chr(10)
cString+="------------------------------------------------"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[1,1],"@E 999.99")+"]............["+Transform(aCedulas[1,2],"@E 999")+"].............["+Transform(aCedulas[1,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[2,1],"@E 999.99")+"]............["+Transform(aCedulas[2,2],"@E 999")+"].............["+Transform(aCedulas[2,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[3,1],"@E 999.99")+"]............["+Transform(aCedulas[3,2],"@E 999")+"].............["+Transform(aCedulas[3,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[4,1],"@E 999.99")+"]............["+Transform(aCedulas[4,2],"@E 999")+"].............["+Transform(aCedulas[4,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[5,1],"@E 999.99")+"]............["+Transform(aCedulas[5,2],"@E 999")+"].............["+Transform(aCedulas[5,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10) //+space(24)
cString+="["+Transform(aCedulas[6,1],"@E 999.99")+"]............["+Transform(aCedulas[6,2],"@E 999")+"].............["+Transform(aCedulas[6,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[7,1],"@E 999.99")+"]............["+Transform(aCedulas[7,2],"@E 999")+"].............["+Transform(aCedulas[7,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[8,1],"@E 999.99")+"]............["+Transform(aCedulas[8,2],"@E 999")+"].............["+Transform(aCedulas[8,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[9,1],"@E 999.99")+"]............["+Transform(aCedulas[9,2],"@E 999")+"].............["+Transform(aCedulas[9,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[10,1],"@E 999.99")+"]............["+Transform(aCedulas[10,2],"@E 999")+"].............["+Transform(aCedulas[10,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="["+Transform(aCedulas[11,1],"@E 999.99")+"]............["+Transform(aCedulas[11,2],"@E 999")+"].............["+Transform(aCedulas[11,3],"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="......................................----------"+Chr(13)+Chr(10)
cString+="..............................Cedulas "+"["+Transform(nTotal,"@E 9,999.99")+"]"+Chr(13)+Chr(10)
cString+="----------------------[Cartoes]-----------------"+Chr(13)+Chr(10)
cString+="Bandeira               Tipo    Quant    Valor   "+Chr(13)+Chr(10)
cString+="--------------------- -------- ----- -----------"+Chr(13)+Chr(10)
For nI:=1 to Len(aCols)
	IncProc()
	If aCols[nI,5].or. Empty(aCols[nI,1])
		Loop
	EndIf	
	cString+=Subs(Alltrim(aCols[nI,1])+Repli(".",21),1,21)+" "
	cString+=Subs(Alltrim(aTipo[Val(aCols[nI,2])])+Repli(".",8),1,8)+" "
	cString+=Transform(aCols[nI,3],"@E 99999")+" "
	cString+=Transform(aCols[nI,4],"@E 9999,999.99")
	cString+=+Chr(13)+Chr(10)

	If AllTrim(aCols[nI,2])=="1"	//Tipo do Cartao
		nQCC+=aCols[nI,3]
		nCC+=aCols[nI,4]
	ElseIf Alltrim(aCols[nI,2])=="2"	//Tipo do Cartao
		nQCD+=aCols[nI,3]
		nCD+=aCols[nI,4]
	ElseIf Alltrim(aCols[nI,2])=="3"	//Tipo do Cartao
		nQVO+=aCols[nI,3]
		nVO+=aCols[nI,4]
	EndIf
Next nI
cString+="------------------------------ ----- -----------"+Chr(13)+Chr(10)
cString+="CREDITO........................"+Transform(nQCC,"@E 99999")+" "+Transform(nCC,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="DEBITO........................."+Transform(nQCD,"@E 99999")+" "+Transform(nCD,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="VOUCHER........................"+Transform(nQVO,"@E 99999")+" "+Transform(nVO,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="................................................"+Chr(13)+Chr(10)
cString+="CARTOES........................"+Transform(nQCC+nQCD+nQVO,"@E 99999")+" "+Transform(nCC+nCD+nVO,"@E 9999,999.99")+Chr(13)+Chr(10)

cString+="-----------------------[Vales]------------------"+Chr(13)+Chr(10)
cString+="Vale Innocencio..............["+Transform(nQtdVI,"@E 99999")+"] "+Transform(nValVI,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="Sinal Encomenda..............["+Transform(nQtdSE,"@E 99999")+"] "+Transform(nValSE,"@E 9999,999.99")+Chr(13)+Chr(10)

nPos:=(44-Len("Lancado por:"))/2
cString+="                                                "+Chr(13)+Chr(10)
cString+="    ----------------------------------------    "+Chr(13)+Chr(10)
cString+=space(nPos)+"Lancado por:"+Chr(13)+Chr(10)

cAuxString:=cString

While Len(cAuxString)<>0
	nPos:=At(Chr(13)+Chr(10),cAuxString)
	cLinha:=subs(cAuxString,1,nPos)
	aadd(aCupom,cLinha)
	cAuxString:=Subs(cAuxString,nPos+2)
End	
oLbxRel:SetArray( aCupom )
oLbxRel:Refresh()

Return cString



Static Function IA007SendFec(cCaixa,cNome,dDataInno,cString )

Local lRet		:=.T.
Local nHdl		:=-1

Local nVz		:=0
Local cError	:=""
Local lSendOk 	:=.F.
Local cAccount 	:=GetMV( "MV_RELACNT" )
Local cPassword :=GetMV( "MV_RELPSW"  )
Local cServer 	:=GetMV( "MV_RELSERV" )
Local cFrom 	:=GetMV( "MV_RELACNT" )
Local cDest		:=GetPvProfString( "MAIL" , "Destinatarios" , "" , GetAdv97() )+Chr(59)
Local cMensagem	:=	subs(cString,1,600)

Local cPath 	:= "\FECHAMENTO\"	// Caminho para 
//Local cFile		:=cFile		:="RF_"+Alltrim(SM0->M0_FILIAL)+"_"+If(Empty(cCaixa),"C99",cCaixa)+"_"+Strzero(Day(dDataInno),2)+Strzero(Month(dDataInno),2)+Strzero(Year(dDataInno),4)+"_"+aString[IA007Pos("A2"),3,1]+".TXT"
//Local cFile		:="RF_"+Alltrim(SM0->M0_FILIAL)+"_"+Strzero(Year(dDataInno),4)+Strzero(Month(dDataInno),2)+Strzero(Day(dDataInno),2)+"_"+If(Empty(cCaixa),"C99",cCaixa)+"_"+aString[IA007Pos("A2"),3,1]+".TXT"
Local cFile		:="RF_"+SM0->M0_CODIGO+"_"+SM0->M0_CODFIL+"_"+Strzero(Year(dDataInno),4)+Strzero(Month(dDataInno),2)+Strzero(Day(dDataInno),2)+"_"+If(Empty(cCaixa),"C99",cCaixa)+"_"+aString[IA007Pos("A2"),3,1]+".TXT"
//Local cAssunto	:= Left(Right(cPath+cFile,33),29)+" ["+cCaixa +" - "+Alltrim(cNome)+"]"
Local cAssunto	:= cFile+" ["+cCaixa +" - "+Alltrim(cNome)+"]"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao do arquivo txt de fechamento                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdl:=MSFCreate(cPath + cFile)
fWrite(nHdl,cString)// Lote do arquivo 15
fClose(nHdl)
CursorArrow()

ProcRegua(3)
IncProc()

While !lSendOk.And.nVz<=3
	cError	:=""
	IncProc()
	lSendOk:=U_I999SendMail(,,,,cDest,cAssunto,cMensagem,cPath+cFile)
	ConOut(dtoc(Date())+" "+Time()+" Fechamento Caixa ["+cFile+"]") //
	ConOut(dtoc(Date())+" "+Time()+" Envio por e-mail para - "+cDest+"["+If(lSendOk,"OK",cError)+"]") //
	nVz++
End	

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente para periodo de Desenvolvimento   para usar com apDiff Inicio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cPath + cFile)
	cFileOld:=cPath + "RF_"+Alltrim(SM0->M0_FILIAL)+"_"+If(Empty(cCaixa),"C99",cCaixa)+"_"+Strzero(Day(dDataInno),2)+Strzero(Month(dDataInno),2)+Strzero(Year(dDataInno),4)+"_Old.TXT"
	If File(cFileOld)
        cTime2:=Subs(time(),1,2)+"_"+Subs(time(),4,2)+"_"+Subs(time(),7,2)
		cFileTime:=cPath + "RF_"+Alltrim(SM0->M0_FILIAL)+"_"+If(Empty(cCaixa),"C99",cCaixa)+"_"+Strzero(Day(dDataInno),2)+Strzero(Month(dDataInno),2)+Strzero(Year(dDataInno),4)+"_"+cTime2+".TXT"
		FRename(cFileOld,cFileTime)
    EndIf
	FRename(cPath + cFile,cFileOld)
EndIf
*/
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IA007VldTef       ³Autor  ³Marcos Alves   º Data ³07/12/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida se nao tem registro sem DOCTEF para impressao do     º±±
±±º          ³fechaento                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA007VldTef(dDataInno)
Local lRet		:=.T.
Local nDocTef	:=0

If !SuperGetMV( "MV_INNODT",.F.,.T. ) //Parametro para validar a digitação DOC e TEF dos comprovantes de recebimento de cartoes (// Caso nao exista o parametro assume .T. como DEFAULT)
	Return .T.
EndIf	

If dDataInno=dDataBase
	dbSelectArea("SL4")
	dbSetOrder(1)
	
	dbSelectArea("SL1")
	aAreaSL1 := GetArea()
	dbSetOrder(7)
	
	dbSeek(xFilial("SL1")+DtoS(dDataBase))
	//Alimentando array com as vendas dos dia (SL1)
	While !SL1->(Eof()).And.(SL1->L1_FILIAL==xFilial("SL1")).And.(SL1->L1_EMISSAO==dDatabase)
		SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
		While !SL4->(Eof()).AND.xFilial("SL4")+SL1->L1_NUM==SL4->L4_FILIAL+SL4->L4_NUM
			If AllTrim(SL4->L4_FORMA)$"CD#CC#VA"
				If Empty(SL4->L4_DOCTEF).OR.Empty(SL4->L4_AUTORIZ)
					nDocTef++
				EndIf
			EndIf	
			SL4->(DbSkip())
		End
	  	SL1->(dbSkip())
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
		While !SZS->(Eof()).AND.xFilial("SZT")+SZT->ZT_TALAO+SZT->ZT_PEDIDO==SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO
			If AllTrim(SZS->ZS_FORMA)$"CD#CC#VA"
				If Empty(SZS->ZS_DOCTEF).OR.Empty(SZS->ZS_AUTORIZ)
					nDocTef++
				EndIf
			EndIf	
			SZS->(DbSkip())
		End
	  	SZT->(dbSkip())
	End
	If nDocTef<>0
		MsgInfo("Existem "+alltrim(str(nDocTef)) +" registros sem digitação do DOCTEF/Autorizacao. Fechamento nao será impresso")
		lRet:=.F.
	EndIf	
EndIf

Return lRet


/*
Funcao : IA007PIX  
Descrição:
Atualiza a variavel de quentidade e valor de PIX na pasta Outros tela fechamento
Faz a mesma logica do fechamento.
Sintaxe
IA007PIX(nQtdPIX,nValPIX)
*/
Static Function IA007PIX(dDataInno,cCaixa,nQtdPIX,nValPIX)

nQtdPIX:=0
nValPIX:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuracao do ambiente                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA3")
dbSelectArea("SL4")
dbSelectArea("SL2")
dbSelectArea("SL1")

SL2->(dbSetOrder(1))
SL1->(dbSetOrder(7))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento das Vendas (SL1)  							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SL1->(dbSeek(xFilial("SL1")+dToS(dDataInno)))
//ProcRegua(SL1->(Reccount()))
While !SL1->(Eof()).And. SL1->L1_FILIAL+dToS(SL1->L1_EMISSAO)==xFilial()+dToS(dDataInno)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If (!Empty(cCaixa).And.Alltrim(SL1->L1_OPERADO)<>cCaixa) 
		SL1->(dbSkip())
		Loop
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contador de L1_SITUA:                                        ³
	//³ TX-Transmitido a retaguarda                                  ³
	//³ "00" - Venda Efetuada com Sucesso (Nao Transmitido)			 ³
	//³ "01" - Abertura do Cupom Nao Impressa                        ³
	//³ "04" - Impresso o Item                                       ³
	//³ "05" - Solicitado o Cancelamento do Item                     ³
	//³ "07" - Solicitado o Cancelamento do Cupom                    ³
	//³ "09" - Encerrado SL1 (Nao gerado SL4)                        ³
	//³ "10" - Encerrado a Venda                                     ³
	//³ "99" - Excluido por reimpressão                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SL1->L1_SITUA=="99"							//Exluido por reimpressão		 
		SL1->(dbSkip())
		Loop
	Else 												//Avaliar L1_SITUA="03" - Quando ocorre. 
		If SL1->L1_SITUA=="03"							//Exluido por reimpressão		 
			SL1->(dbSkip())
			Loop
		End
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao contabiliza registros deletado, somente quando cancelado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If SL1->(Deleted()) 								//processar cupons Cancelados)
		SL1->(dbSkip())
		Loop
    EndIf
	SL4->(dbSetOrder(1))
	SL4->(dbSeek(xFilial("SL4")+SL1->L1_NUM))
	nVz:=0
	While !SL4->(Eof()).And. SL4->L4_FILIAL+SL4->L4_NUM==xFilial("SL4")+SL1->L1_NUM
   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtro de vendas canceladas									 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If SL4->(Deleted())
			SL4->(dbSkip())
			Loop
	    EndIf
		If Alltrim(SL4->L4_FORMA)=="DC".And.Empty(SL4->L4_DOC)
			//"PX" - PIX
			nQtdPIX++ 					//Quantidade de PIX
			nValPIX+=SL4->L4_VALOR 	//Valor PIX
        EndIf
		SL4->(dbSkip())
	End
	SL1->(dbSkip())
End

//Sinal de Encomenda SZT/SZS --------------------------------------------------------------------------
SZS->(dbSetOrder(1))
SZT->(dbSetOrder(2))
SZT->(dbSeek(xFilial("SZT")+DtoS(dDataInno)))
While !SZT->(Eof()).And.(xFilial("SZT")+DToS(dDataInno)==SZT->ZT_FILIAL+DToS(SZT->ZT_DATA))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o caixa ativo, caso nao for geral										 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If !Empty(cCaixa).And.SZT->ZT_CAIXA<>cCaixa
		SZT->(dbSkip())
		Loop
    EndIf

	SZS->(dbSeek(xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO))        
	While !SZS->(Eof()).and. (xFilial("SZS")+SZT->ZT_TALAO+SZT->ZT_PEDIDO)==(SZS->ZS_FILIAL+SZS->ZS_TALAO+SZS->ZS_PEDIDO)
		If Alltrim(SZS->ZS_FORMA)=='DC'
			nQtdPIX++				//Quantidade de PIX
			nValPIX+=SZS->ZS_VALOR 	//Valor PIX
		EndIf			
		SZS->(dbSkip())                                              
	End
	SZT->(dbSkip())
End

Return nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³I223ImpRecibo    ³Autor  ³Marcos Alves   º Data ³18/03/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impessao do vale de compra dos Funcionarios				  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IA007IMoney(aCols,dData,cCaixa,cNome,oLbxRel,aCupom,aCedulas,nQtdVI,nValVI,nQtdSE,nValSE,nQtdIF,nValIF)
Local cString :=""
Local nPos	:=0
Local nTotal:=0
Local aTipo	:={"CREDITO","DEBITO","VOUCHER"}
Local nCC	:=0
Local nCD	:=0
Local nVO	:=0

Local nQCC	:=0
Local nQCD	:=0
Local nQVO	:=0
Local nTotal:=0

Local xString:={}

nTotCielo	:=0
nTotTicket	:=0
nTotSodexo	:=0
nTotVR		:=0
nTotBenVisa	:=0
nTotIfood	:=0

aTotCredito	:={0,0,0}
aTotDebito	:={0,0,0}
aTotVoucher	:={0,0,0}

aTotCredito[1]	:=aString[IA007Pos("G1"),3,1]
aTotCredito[2]	:=aString[IA007Pos("G1"),3,2]
aTotCredito[3]	:=aString[IA007Pos("G1"),3,4]

aTotDebito[1]	:=aString[IA007Pos("G2"),3,1]
aTotDebito[2]	:=aString[IA007Pos("G2"),3,2]
aTotDebito[3]	:=aString[IA007Pos("G2"),3,4]

aTotVoucher[1]	:=aString[IA007Pos("G3"),3,1]
aTotVoucher[2]	:=aString[IA007Pos("G3"),3,2]
aTotVoucher[3]	:=aString[IA007Pos("G3"),3,4]


//Verificar se houve sinal de encomenda em CC, CD ou VA
nPosInno1:=IA007Pos("S3")+1 // Sinal de Encomenda
nPosInno2:=IA007Pos("SR")-2 //
For nI:= nPosInno1 to nPosInno2 
	If At("CREDITO",Upper(aString[nI,3,4]))<>0
		aTotCredito[2]-=aString[nI,3,5]
		nTotCielo-=aString[nI,3,5]
	ElseIf At("DEBITO",Upper(aString[nI,3,4]))<>0
		aTotDebito[2]-=aString[nI,3,5]
		nTotCielo-=aString[nI,3,5]
	ElseIf At("VOUCHER",Upper(aString[nI,3,4]))<>0
		aTotVoucher[2]-=aString[nI,3,5]
		nTotCielo-=aString[nI,3,5]		
	EndIf
Next nI

ProcRegua(Len(aCols))
cString+="================================================"+Chr(13)+Chr(10)
cString+="v7.............Fechamento Ms Money.............."+Chr(13)+Chr(10)
cString+="Data...........:"+dtoc(dData)+"       Hora....:"+Time()+Chr(13)+Chr(10)
cString+="Caixa..........:"+cCaixa+"-"+Subs(alltrim(cNome)+Repli(".",28),1,28)+Chr(13)+Chr(10)

cString+="================================================"+Chr(13)+Chr(10)
cString+="    Numerario        Documento     Valor     S/T"+Chr(13)+Chr(10)
cString+="-------------------- ----------- ----------- ---"+Chr(13)+Chr(10)

nPosInno1:=IA007Pos("XN")+1 // Sangria
nPosInno2:=IA007Pos("XO")-1 //Despesa
For nI:= nPosInno1 to nPosInno2 
	If Upper(aString[nI,3,2])="FUNDO INICIO"
		cString+=Subs(aString[nI,3,1]+space(20),1,20)+" "
		cString+=aString[nI,3,2]+" "
		cString+=Transform(aString[nI,3,3],"@E 9999,999.99")+Chr(13)+Chr(10)
	EndIf	
Next nI
cString+="------------------------------------------------"+Chr(13)+Chr(10)

cString+="Venda Liquida.........["+Transform(aString[IA007Pos("AS"),3,1],"@E 999")+"]: "+Transform(aString[IA007Pos("AS"),3,2],"@E 9,999.99")+Chr(13)+Chr(10)
cString+="-------------[Recebimentos Vendas(A)]-----------"+Chr(13)+Chr(10)
cString+="Dinheiro..............["+Transform(aString[IA007Pos("AU"),3,1],"@E 999")+"]: "+Transform(aString[IA007Pos("AU"),3,2]	,"@E 9,999.99")+Chr(13)+Chr(10)
cString+="Cartao de credito.....["+Transform(aTotCredito[1]				,"@E 999")+"]: "+Transform(aTotCredito[2]				,"@E 9,999.99")+" "+Transform(aTotCredito[3]	,"@E 9,999.99")+Chr(13)+Chr(10)
cString+="Cartao de Debito......["+Transform(aTotDebito[1]				,"@E 999")+"]: "+Transform(aTotDebito[2]				,"@E 9,999.99")+" "+Transform(aTotDebito[3]		,"@E 9,999.99")+Chr(13)+Chr(10)
cString+="Voucher...............["+Transform(aTotVoucher[1]				,"@E 999")+"]: "+Transform(aTotVoucher[2]				,"@E 9,999.99")+" "+Transform(aTotVoucher[3]	,"@E 9,999.99")+Chr(13)+Chr(10)

cString+="Vale Innocencio.......["+Transform(aString[IA007Pos("C6"),3,1],"@E 999")+"]: "+Transform(aString[IA007Pos("C6"),3,2],"@E 9,999.99")+Chr(13)+Chr(10)
cString+="Sinal Encomenda.......["+Transform(aString[IA007Pos("G4"),3,1],"@E 999")+"]: "+Transform(aString[IA007Pos("G4"),3,2],"@E 9,999.99")+Chr(13)+Chr(10)
cString+="Ifood.................["+Transform(aString[IA007Pos("G6"),3,1],"@E 999")+"]: "+Transform(aString[IA007Pos("G6"),3,2],"@E 9,999.99")+Chr(13)+Chr(10)
cString+="Pix...................["+Transform(aString[IA007Pos("PX"),3,1],"@E 999")+"]: "+Transform(aString[IA007Pos("PX"),3,2],"@E 9,999.99")+Chr(13)+Chr(10)

cString+="------------------[Transferencias]--------------"+Chr(13)+Chr(10)
cString+="Banco                                   Valor   "+Chr(13)+Chr(10)
cString+="--------------------- -------- ----- -----------"+Chr(13)+Chr(10)


For nI:=1 to Len(aCols)
	IncProc()
	If aCols[nI,5].or. Empty(aCols[nI,1])
		Loop
	EndIf	
	cDesc:=Subs(Alltrim(aCols[nI,1])+Repli(".",21),1,21)
	If At("SODEXO",cDesc)<>0
		nTotSodexo	+=aCols[nI,4]
	ElseIf At("TICKET",cDesc)<>0		
		nTotTicket	+=aCols[nI,4]
	ElseIf At("VR",cDesc)<>0		
		nTotVR	+=aCols[nI,4]
	ElseIf At("BEN VISA",cDesc)<>0		
		nTotBenVisa	+=aCols[nI,4]
	else
		nTotCielo +=aCols[nI,4]
	EndIf
Next nI

//Valores de Ifood

cString+="CIELO..............................."+Transform(nTotCielo		,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="TICKET RESTAURANTE.................."+Transform(nTotTicket	,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="SODEXO.............................."+Transform(nTotSodexo	,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="VR.................................."+Transform(nTotVR		,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="BEN VISA............................"+Transform(nTotBenVisa	,"@E 9999,999.99")+Chr(13)+Chr(10)
cString+="IFOOD..........................["+Str(aString[IA007Pos("G6"),3,1],3)+"]"+Transform(aString[IA007Pos("G6"),3,2]		,"@E 9999,999.99")+Chr(13)+Chr(10)

cString+="---------------[Venda Funcionario]--------------"+Chr(13)+Chr(10)
cString+="Codigo Nome       Titulo        F.     Valor    "+Chr(13)+Chr(10)
cString+="------ ---------- ------------- --  ------------"+Chr(13)+Chr(10)

nPosInno1:=IA007Pos("FD")+1 // Venda funcionarios
nPosInno2:=IA007Pos("S1")-2 //Sinal de Encomenda
For nI:= nPosInno1 to nPosInno2 
	cString+=aString[nI,3,1]+" "
	cString+=aString[nI,3,2]+" "
	cString+=aString[nI,3,3]+" "
	cString+=aString[nI,3,4]+" "
	cString+=aString[nI,3,5]+" "
	cString+=Transform(aString[nI,3,6],"@E 9999,999.99")+Chr(13)+Chr(10)
Next nI

cString+="---------[Sinal de Encomenda Recebido]----------"+Chr(13)+Chr(10)
cString+="     T. Pedido   Data    Retirar   Valor        "+Chr(13)+Chr(10)
cString+="     --- ------ -------- -------- -----------   "+Chr(13)+Chr(10)

nPosInno1:=IA007Pos("S6")+1 // Sinal de encomenda Aberto
nPosInno2:=IA007Pos("A7")-3 //Indicadores Geral

For nI:= nPosInno1 to nPosInno2 
	If aString[nI,3,1]="[*]"
		cString+=aString[nI,3,1]+" "
		cString+=aString[nI,3,2]+" "
		cString+=aString[nI,3,3]+" "
		cString+=DtoC(aString[nI,3,4])+" "
		cString+=DToC(aString[nI,3,5])+" "
		cString+=Transform(aString[nI,3,6],"@E 9999,999.99")+Chr(13)+Chr(10)
	EndIf	
Next nI

cString+="----------------[Recebimento PIX]---------------"+Chr(13)+Chr(10)
cString+="Hora    Doc       Valor      Tipo (V/S )        "+Chr(13)+Chr(10)
cString+="-----  -------- -----------  ---------          "+Chr(13)+Chr(10)

nPosInno1:=IA007Pos("P3")+1 // Recebimento PIX
nPosInno2:=IA007Pos("S4")-1 //Sinal de encomenda em Aberto

For nI:= nPosInno1 to nPosInno2 
	If aString[nI,3,4]="Venda"
		cString+=aString[nI,3,1]+" "
		cString+=aString[nI,3,2]+" "
		cString+=Transform(aString[nI,3,3],"@E 9999,999.99")+" "
		cString+=aString[nI,3,4]+Chr(13)+Chr(10)
	EndIf	
Next nI


cString+="--------------[Sangria / Troco]-----------------"+Chr(13)+Chr(10)
cString+="================================================"+Chr(13)+Chr(10)
cString+="    Numerario        Documento     Valor     S/T"+Chr(13)+Chr(10)
cString+="-------------------- ----------- ----------- ---"+Chr(13)+Chr(10)

nPosInno1:=IA007Pos("XN")+1 // Sangria
nPosInno2:=IA007Pos("XO")-1 //Despesa
For nI:= nPosInno1 to nPosInno2 
	If Upper(aString[nI,3,2])<>"FUNDO INICIO"
		cString+=aString[nI,3,1]+" "
		cString+=aString[nI,3,2]+" "
		cString+=Transform(aString[nI,3,3],"@E 9999,999.99")+" "
		cString+=aString[nI,3,4]+Chr(13)+Chr(10)
	EndIf	
Next nI

cString+="-------------------[Despesas]-------------------"+Chr(13)+Chr(10)
cString+=" Titulo           Fornecedor            Valor   "+Chr(13)+Chr(10) 
cString+="--------- -------------------------- -----------"+Chr(13)+Chr(10)

nPosInno1:=IA007Pos("XQ")+1 // Recebimento PIX
nPosInno2:=IA007Pos("FB")-1 //Sinal de encomenda em Aberto

For nI:= nPosInno1 to nPosInno2 
	cString+=aString[nI,3,1]+" "
	cString+=aString[nI,3,2]+" "
	cString+=Transform(aString[nI,3,3],"@E 9999,999.99")+Chr(13)+Chr(10)
Next nI

cString+="--------------[Sinal de Encomenda]--------------"+Chr(13)+Chr(10)
cString+="T.  Ped.Cupom        Numerario         Valor    "+Chr(13)+Chr(10)
cString+="--- --- ------ ------------------------ --------"+Chr(13)+Chr(10)

nPosInno1:=IA007Pos("S3")+1 // Sinal de Encomenda
nPosInno2:=IA007Pos("SR")-2 //

For nI:= nPosInno1 to nPosInno2 
	cString+=aString[nI,3,1]+" "
	cString+=aString[nI,3,2]+" "
	cString+=aString[nI,3,3]+" "
	cString+=Subs(aString[nI,3,4],1,24)+" "
	cString+=Transform(aString[nI,3,5],"@E 9,999.99")+Chr(13)+Chr(10)
Next nI

cString+="-----------------[Saldo Final ]-----------------"+Chr(13)+Chr(10)
cString+="                             Proces.     Diverg. "+Chr(13)+Chr(10)
cString+="                            --------- ----------"+Chr(13)+Chr(10)
cString+="Dinheiro...................:"+Transform(aString[IA007Pos("C2"),3,1],"@E 9,999.99")+"  "+Transform(aString[IA007Pos("C2"),3,2],"@E 9,999.99")+Chr(13)+Chr(10)
cString+="================================================"+Chr(13)+Chr(10)


Return cString

