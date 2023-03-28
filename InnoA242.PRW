/*
Descrição:
Importaçao dos pedidos do  Ifood a partir dos arquivos TXT  capturados via MacroReade 

*/
#INCLUDE "Protheus.ch"

User Function INNOA242(cPedido)   
Local cPathIfood	:= ""
Local cArquivo      := "C:\IFOOD\CARDAPIO_IFOOD.CSV" // Arquivo gerado pelo portal Ifood, Deixa somente as colunas  PRODUTO PDV
Local aRet           :={"",0,0,0}
Local aDados        :={}
Local aClientes     := {}
Local nIFood        := 1
Local nProduto      :=0
Local nRet          := 0

Private INNO_PDV:=""

//cIfoodCarga   := GetPvProfString("INNO", "IFOODCARGA","1", GetRemoteIniName()) // Local dos arquivos pedido iFood - Sintaxe: GetPvProfString(cSecao, cChave, cPadrao, cServerIni) 

If File(cArquivo)
    //If INNO_CIF="2" // variavel atualizada em INNOA002.PRW
    //Atuliza Descrição do produto no SBI  dados so Ifood
    //cArquivo :="C:\TEMP\IFOOD_PDV.CSV" 
    aDados:=I242Carga(cArquivo)
    For nI:= 2 to Len(aDados)
        nPos:=At(",", aDados[nI])
        cCod:=Subs(aDados[nI],nPos+2)
        cCod=Strzero(Val(cCod),5)
        cDescIf:=Subs(aDados[nI],1, nPos-2)
        cDescIf:=Upper(NoAcento(AnsiToOem(AllTrim(cDescIf))))
        dbSelectArea( "SBI" )
        dbSetOrder( 1 )
        If dbSeek( xFilial("SBI")+cCod)
            SBI->(RecLock("SBI", .F.))
            SBI->BI_DESCIF  :=cDescIf
            SBI->(dbCommitAll())
            SBI->(MsUnlock())
        EndIf
    Next nI
    //Final da Atualizacao de cadastro
    FRENAME(  cArquivo,   Subs(cArquivo,1,At(".",cArquivo))+"OKk") 
EndIf

//No arquivo smartclient.ini; sessão INNO; variavel IFOODPATH
cPathIfood  := GetPvProfString("INNO", "IFOODPATH","C:\TEMP\", GetRemoteIniName()) // Local dos arquivos pedido iFood - Sintaxe: GetPvProfString(cSecao, cChave, cPadrao, cServerIni) 

cArquivo:=cPathIfood+"IF_TMP_"+cPedido+".TXT"
INNO_AIF[1]:=cPathIfood
INNO_AIF[2]:="IF_TMP_"+cPedido+".TXT"

// Le o arquivo TXT e coloca os dados no Array aDados
aDados:=I242Carga(cArquivo)
If Len(aDados)=0
    nRet:=1
    Return nRet
EndIf

//Recebe o array aDados e interpreta os dados (itens, CPF) do pedido e coloca no Array AxDados
axDados     := I242Proc(aDados,cPedido) // Dados dos produtos e dados do cliente
aProdutos   := axDados[1] //dados dos produtos
aInfo       := axDados[2] // dados do Cliente 11-CPF

nProduto    := Len(aProdutos)
aVendas     :={}
nValTot     := 0
cDescIf     := ""

//Grava os produtos do pedido Ifood no array aVendas (usado na rotina de venda Inno223.prw)
For nI := 1 to nProduto
    dbSelectArea("SBI")
    dbSetOrder(6)
    cDescIf     := Subs(aProdutos[nI,2],1,30)
    If SBI->(dbSeek(xFilial("SBI")+cDescIf)) //
        aadd(aVendas,{'999','000001',SBI->BI_COD,SBI->BI_DESC,aProdutos[nI,1],SBI->BI_UM,SBI->BI_PRV2,0,.F.})
    EndIf
Next nI

//Excluir os itens, caso ja tenha sido feito a leitura
dbSelectArea("SZZ")
//dbSetOrder(6) //ZZ_FILIAL+ZZ_DATA + ZZ_PEDIDO
//SZZ->(dbSeek(xFilial("SZZ")+DTOS(dDataBase)+cPedido)) 
//While SZZ->ZZ_FILIAL+DTOS(SZZ->ZZ_DATA)+SZZ->ZZ_PEDIDO==xFilial("SZZ")+DTOS(dDataBase)+cPedido.AND.SZZ->ZZ_FLAG=="0"

dbSetOrder(1) //ZZ_FILIAL+ZZ_CARTAO + ZZ_FLAG
SZZ->(dbSeek(xFilial("SZZ")+"999"+"0")) 
While SZZ->ZZ_FILIAL+SZZ->ZZ_CARTAO+SZZ->ZZ_FLAG==xFilial("SZZ")+"999"+"0"
    SZZ->(RecLock("SZZ", .F.))
    SZZ->(dbDelete())
    SZZ->(MsUnlock())
    SZZ->(dbSkip())
End

// Grava os itens no arquico SZZ (F11)
U_I222Grv(aVendas,nValTot,,nIfood,cPedido)

INNO_CPF:=If(Empty(aInfo[11]),"00000000000",aInfo[11])

nRet:=2

//Renomear o arquivo para nao processar novamente
If File(cArquivo)
    //FRENAME(  cArquivo,   cPathIfood+"IFOOD_PEDIDO_"+dTos(ddataBase)+"_"+Right(cArquivo,8)) 
    //FErase(cArquivo)
EndIf

Return nRet

/*

AutoGrLog("7) Selecionar dados para cadatro de clientes: " + Str(Len(aDados),5) + " Clientes")
ConOut("7) Selecionar dados para cadatro de clientes: " + Str(Len(aDados),5) + " Clientes")
//Seleciona os dados relevante para Inclusão de clientes SA1 e dados dos produtos
aClientes:=I240Proc(aDados)	
	
   //Incluir/Alterar clientes no SA1
   For nI:= 1 to Len(aClientes)
      I240Inc(aClientes[nI])
   Next nI   
   cArq		:=AllTrim(cArq)
   nPos1		:=Rat("\",cArq)
   cOrigem 	:= Subs(cArq,1,nPos1)
   nPos2		:=Rat(".",cArq)
   cExtensao	:=Subs(cArq,nPos2)
   If FRENAME(  cPathIfood+cNomeXLS+cExtensao,   cPathIfood+"OK_"+cNomeXLS+cExtensao) == -1
		CounOut("Erro renomerar arquivo"+cArquivo)
	else
		AutoGrLog("Renomeado...:"+ cPathIfood+"OK_"+cArquivo )
	EndIf
	
Next nX
*/


/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parâmetros  : cArq - nome do arquivo que será usado      
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function I242Carga(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 0 
Local nTotLin := 0
lOCAL nLinTit := 0
Local aDados  := {}
//Local cFile   := cTemp + cArq 
Local cFile   := cArq 
Local nHandle := 0

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
   nLin++
   //le a linha
   cLinha := Ft_FReadLn()
   //verifica se a linha está em branco, se estiver pula
   If Empty(AllTrim(StrTran(cLinha,';',''))) .Or. (nLin==1.and.cLinha=="-----")
      Ft_FSkip()
      Loop
   EndIf
   //transforma as aspas duplas em aspas simples
   cLinha := StrTran(cLinha,'"',"'")
   //cLinha := '{"'+cLinha+'"}' 
   //adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array 
   cLinha := StrTran(cLinha,';','","')
   aAdd(aDados, cLinha)
   
   //passa para a próxima linha
   FT_FSkip()
   //
EndDo

//libera o arquivo CSV
FT_FUse()             

//Exclui o arquivo csv
//If File(cFile)
//    nPos:=At(".",cFile)
//    FRENAME(  cFile,   subs(cFile,1,nPos)+"Old") 
//EndIf

Return aDados


/*
Funcao      : convArqs
Objetivos   : Interpreta os dados da planila para gravar no SA1
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function I242Proc(aDados,cPedido)
*-------------------------*
Local nContP,nContL,nContC
Local xValor
Local aInfo      	:={}
Local aProdutos 	:={}
Local nI		    :=0
Local aClientes     :={}

nI+=1
//aRet[2]++
aInfo           := {"","","","","","","","","","","","",""}
lFlagEnd	    :=.F.  //Flag proxima linha - Endeereço
lFlagComp	    :=.F. // Flag Complemento do endereço
lFlagProdutos	:=.F. // Flag inicio dos produtos do pedido
lFlagQuant		:=.F.
nLinha			:= 0 // 0= quantidade ;2=Descrição ; 3= Valor
nP			   	:= 0 // Posicao dos produtos

// Varre todas as linhas do pedido iFood
For nContL:=1 to Len(aDados)
    xValor	:= Upper(NoAcento(AnsiToOem(AllTrim(aDados[nContL]))))	//Conteúdo da linha 
    //NoAcento(AnsiToOem(AllTrim(cGet)))

    nPos:=At("PEDIDO #",xValor)
    If nPos<>0 
        cPedidoArq:=Subs(xValor,nPos+8,4)
        //Verifica se o pedido digitado e igual ao arquivo gerado
        If cPedidoArq<>cPedido
            Return {NIL,NIL}
        EndIf
    EndIF
    
    nPos:=At("ENTREGA PARCEIRA",xValor)
    If nPos<>0 .and. !lFlagProdutos
        lFlagProdutos:=.T.
        Loop
    EndIF
    
    If lFlagProdutos.and. nLinha=0
         
        If (nPos:=At("X", xValor))>0 .and. Len(xValor)<10
            Aadd(aProdutos,{,,})
            nP              :=Len(aProdutos)
            nQuant          :=Val(Subs(xValor,1,nPos-1)) //Quantidade
            aProdutos[nP,1] :=nQuant
            nLinha          :=2
        ElseIf (nPos:=At("SUBTOTAL", xValor))>0
            lFlagProdutos:=.F.
            Loop
        ElseIf (nPos:=At("VALOR TOTAL DO PEDIDO", xValor))>0
            lFlagProdutos:=.F.
            Loop
        ElseIf (nPos:=At("TAXA DE ENTREGA", xValor))>0
            lFlagProdutos:=.F.
            Loop
        EndIf
    ElseIf lFlagProdutos.and. nLinha=2 //Pegar a Descrição do produto
        cDesc:=xValor //Descrição do produto
        nLinha:=3
        aProdutos[nP,2]:=cDesc
    ElseIf lFlagProdutos.and. nLinha=3
        xValor:= StrTran(xValor,',','.')
        nValor:=Val(Subs(xValor,4)) //Valor do produto
        nLinha:=0
        aProdutos[nP,3]:=nValor
    ElseIf (nPos:=At("INCLUIR CPF NA NOTA FISCAL",xValor))<>0
        aInfo[11]:=Subs(xValor,nPos+27)
    EndIf    
Next nContL
//aadd(aClientes,aInfo)
//I240Inc(aInfo)

Return {aProdutos,aInfo}

