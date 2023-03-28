/*
Descrição:
Importaçao dos clientes Ifood a partir dos arquivos de pedido capturados diariamente

*/
#INCLUDE "Protheus.ch"

User Function INNOA240(cArqE,cOrigemE,nLinTitE,lTela)   
Local cPathIfood	:= ""
Local cArquivo 	:= ""
Local aFiles		:={}
Local nCount      
Local aRet        :={"",0,0,0}
Local aDados      :={}
Local aClientes   := {}

Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private cTemp      := GetTempPath() //pega caminho do temp do client
Private cArqMacro  := "INNO2CSV.XLA" // Arquivo Excel contem a macro que convertera XLSX em CSV
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema

cPathIfood:= GetPvProfString("INNO", "IFOOD"+cFilAnt,"C:\TEMP\", GetRemoteIniName()) // Local dos arquivos pedido iFood - Sintaxe: GetPvProfString(cSecao, cChave, cPadrao, cServerIni) 

//Seleciona todos os arquivos mensais de clientes que estao na pasta indicada no smartclient.ini - sessão INNO, variavel IFOOD
aFiles := Directory(cPathIfood+"PEDIDO*.*", "D")
nCount := Len( aFiles )
AutoGrLog("Importação dos dados de clientes Ifood.")
AutoGrLog("Log de processamento - Data: "+DToS(dDataBase))
//Varre os arquivos mensais, gerendo um arquivo CSV por dia (pasta)
AutoGrLog("1) Total de Arquivos Mensais para processamento: "+Str(nCount,5))
ConOut("1) Total de Arquivos Mensais para processamento: "+Str(nCount,5))
For nX := 1 to nCount
   cArq:=cPathIfood+aFiles[nX,1] 
   AutoGrLog(Repli("=",100))
   AutoGrLog("2) Processando arquivos Mensais: "+Str(nX,5)+"/"+Str(nCount,5) +" --> "+cArq)
   ConOut("2) Processando arquivos Mensais: "+Str(nX,5)+"/"+Str(nCount,5) +" --> "+cArq)
   AutoGrLog(Repli("=",100))
   
   // Converte o arquivo XLSX AAAA_MM.xlsx para
   // AAAA_MM_DD_X.INNO, gera um arquivo Txt para cada çliente (coluna)
   If !I240Conv(cArq)
      Loop
   ENDIF
   //Ler cada arquivo de cliente gerar e colocar os dados em Array
   AutoGrLog("3)        Conversão dos arquivo Mensal .XLSX -> .INNO finalizado")
   cArq		:=AllTrim(cArq)
   nPos1		:=Rat("\",cArq)
   nPos2		:=Rat(".",cArq)
   cNomeXLS	:=Subs(cArq,nPos1+1,(nPos2-npos1)-1)
   //------------- Integra----------------------
   //Seleciona os arquivos .INNO gerado.
   aFiles2 := Directory(cTemp+cNomeXLS+"*.INNO*", "D")
   nCount := Len( aFiles2 )
   AutoGrLog("4) Conversao do arquivo mensal gerou (clientes)"+Str(nCount,5)+ "Arquivos .INNO" )
   CounOut("4) Conversao do arquivo mensal gerou (clientes)"+Str(nCount,5)+ "Arquivos .INNO" )
   AutoGrLog(Repli("-",100))
   Conout(Repli("-",80))
   aDados   :={}
   For nY := 1 to nCount
      cArquivo :=aFiles2[nY,1] 
      AutoGrLog("5)Carregando dados do .INNO :"+Str(nY,5)+"/"+Str(nCount,5) +" --> "+cArquivo)
      ConOut("5)Carregando dados do .INNO :"+Str(nY,5)+"/"+Str(nCount,5) +" --> "+cArquivo)
      // Cada arquivo .INNO retona em um Array com os dados da planilha
      aRet:=I240Carga(cArquivo)
      If Len(aRet)>1
         aadd(aDados,aRet)  
      EndIf   
   Next nY
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

cFileLog := NomeAutoLog()

cPath:=""
If cFileLog <> ""
   MostraErro(cPath,cFileLog)
Endif

//WritePProString("INNO","EXCEL", cOrigem, GetRemoteIniName()) //Local onde fica os arquivos do Excel

Return aRet

/*
Funcao      : IntegraArq
Objetivos   : Faz a chamada das rotinas referentes a integração
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function I240Integra(cArq)
*-------------------------*
Local aFiles   :={}
Local cArquivo := ""
Local nCount   :=0
Local nX
Local nPos1    :=0	
Local nPos2    :=0	
Local cNomeXLS
Local aRet     :={}
Local aCliente :={}
Local adados   :={}
Local aRet:={"cArquivo",0,0,0}


cArq		:=AllTrim(cArq)
nPos1		:=Rat("\",cArq)
nPos2		:=Rat(".",cArq)
cNomeXLS	:=Subs(cArq,nPos1+1,(nPos2-npos1)-1)

//Seleciona os arquivos .INNO gerado.
aFiles := Directory(cTemp+cNomeXLS+"*.INNO*", "D")
nCount := Len( aFiles )
AutoGrLog("3)        Conversão dos arquivo .XLSX -> .INNO finalizado")
AutoGrLog("4)              Localizado "+Str(nCount,5)+ "Arquivos .INNO" )
AutoGrLog(Repli("-",100))
aDados   :={}
For nX := 1 to nCount
   cArquivo :=aFiles[nX,1] 
   AutoGrLog("5)                    processando: .INNO :"+Str(nX,5)+"/"+Str(nCount,5) +" --> "+cArquivo)
   // Cada arquivo .csv retona em um Array com os dados da planilha
   //aRet     :=I240Carga(cArquivo)
   aRet     :=I240Carga(cArquivo)
   aadd(aDados,aRet)  
Next nX

AutoGrLog(" ")
Return aDados

/*
Funcao      : convArqs
Objetivos   : converte os arquivos .xlsm para .csv
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function I240Conv(cArq)
*-------------------------*
Local oExcelApp
Local cNomeXLS  := ""
Local cFile     := ""
Local cExtensao := ""
Local i         := 1
Local j         := 1
Local aExtensao := {}
Local nPos1		:=0
Local nPos2		:=0
Local lRet     :=.T.

cArq		:=AllTrim(cArq)
nPos1		:=Rat("\",cArq)
cOrigem 	:= Subs(cArq,1,nPos1)
nPos2		:=Rat(".",cArq)
cExtensao	:=Subs(cArq,nPos2)
cNomeXLS	:=Subs(cArq,nPos1+1,(nPos2-npos1)-1)
cArq		:=cNomeXLS
cFile    := cOrigem+cNomeXLS+cExtensao

If !File(cFile)
	AutoGrLog("O arquivo "+cFile+" não foi encontrado!" ,"Arquivo")
   Return .F.
EndIf

//verifica se existe o arquivo DE .LOG na pasta temporaria e apaga
If File(cTemp+cNomeXLS+cExtensao)
	fErase(cTemp+cNomeXLS+cExtensao)
EndIf                 
   
   //Copia o arquivo XLS para o Temporario para ser executado
If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.) 
	AutoGrLog("Problemas na copia do arquivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
	Return .F.
EndIf                                       
   
   //apaga macro da pasta temporária se existir
If File(cTemp+cArqMacro)
   fErase(cTemp+cArqMacro)
EndIf

   //Copia o arquivo XLA para o Temporario para ser executado
If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.) 
   AutoGrLog("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
   //   MsgInfo("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
   Return .F.
EndIf
   
   //Exclui o arquivo antigo (se existir)
If File(cTemp+cNomeXLS+".csv")
      fErase(cTemp+cNomeXLS+".csv")
EndIf
   
   //Inicializa o objeto para executar a macro
oExcelApp := MsExcel():New()             
   //define qual o caminho da macro a ser executada
oExcelApp:WorkBooks:Open(cTemp+cArqMacro)       
   //executa a macro passando como parametro da macro o caminho e o nome do excel corrente
//oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cNomeXLS)
oExcelApp:Run(cArqMacro+'!INNOXLS2CSV',cTemp,cNomeXLS)
   //fecha a macro sem salvar
oExcelApp:WorkBooks:Close('savechanges:=False')
   //sai do arquivo e destrói o objeto
oExcelApp:Quit()
oExcelApp:Destroy()

   //Exclui o Arquivo excel da temp
fErase(cTemp+cNomeXLS+cExtensao)
fErase(cTemp+cArqMacro) //Exclui a Macro no diretorio temporario

Return lRet

/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parâmetros  : cArq - nome do arquivo que será usado      
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function I240Carga(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 0 
Local nTotLin := 0
lOCAL nLinTit := 1
Local aDados  := {cArq}
Local cFile   := cTemp + cArq 
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
If File(cFile)
   FErase(cFile)
EndIf

Return aDados

/*
Funcao      : convArqs
Objetivos   : Interpreta os dados da planila para gravar no SA1
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function I240Proc(aDados)
*-------------------------*
Local nContP,nContL,nContC
Local xValor
Local aInfo      	:={}
Local aProdutos	:={}
Local nI		      :=0
Local aClientes   :={}

For nD:=1 to Len(aDados)
   AutoGrLog(Repli("=",100))
   AutoGrLog("8) Selecionando dados do clientes :" + Str(nD,3)+"/"+Str(Len(aDados),3) +" :"+aDados[nD,2] +" de "+ aDados[nD,1])
   nI+=1
   //aRet[2]++
   aInfo          := {"","","","","","","","","","","","",""}
   lFlagEnd		   :=.F.  //Flag proxima linha - Endeereço
   lFlagComp	   :=.F. // Flag Complemento do endereço
   lFlagProdutos	:=.F. // Flag inicio dos produtos do pedido
   lFlagQuant		:=.F.
   nLinha			:=0 // Para quantidade 2 - Descrição - 3 Valor
   nP			   	:=0 // Posicao dos produtos
   // Varre todas as linhas do pedido iFood
   For nContL:=1 to Len(aDados[nD])
		xValor	:= Upper(NoAcento(AnsiToOem(AllTrim(aDados[nD,nContL]))))	//Conteúdo da linha 
      //NoAcento(AnsiToOem(AllTrim(cGet)))
      If nContL=1 //Data
         nPos:=At("_20",xValor)+1
         cAno:=Subs(xValor,nPos+2,2)
         cMes:=Subs(xValor,nPos+5,2)
         cDia:=Subs(xValor,nPos+8,2)
         cData:=cDia+"/"+cMes+"/"+cAno
         aInfo[13]:=cData
         aInfo[12]:=xValor
      ElseIf nContL=2 //Nome
         aInfo[1]:=xValor
      ElseIf nContL=3 //Pedido
         aInfo[2]:=xValor
      ElseIf nContL=5 //Hora do Pedido
         aInfo[3]=xValor
      ElseIf nContL=7 //Localizador Pedido
         aInfo[4]:=xValor
      ElseIf nContL=10 //Entrega Prevista
         //aInfo[nI,0]:=cValToChar(xValor)
      ElseIf nContL=11 //Quantos Pedidos na loja
        aInfo[5]:=If(val(subs(xValor,1,2))=0,1,val(subs(xValor,1,2)))
      ElseIf (nPos:=At("ENTREGA PARCEIRA",xValor))<>0 .Or.(nPos:=At("ENTREGAR EM",xValor))<>0 
         lFlagEnd:=.T.
      ElseIf xValor=="-----"
         Loop
      ElseIf lFlagEnd // Pegar endereço e numero
            lFlagEnd:=.F.
            cString:=xValor
            nPos:=At("-", cString)
            If nPos>0
               aInfo[6]:=AllTrim(Subs(cString,1,nPos-1)) //Endereco e Numero
            EndIf
            cString:=Subs(cString,nPos+1)
            nPos:=At("-", cString)
            If nPos>0
               aInfo[7]:=Alltrim(Subs(cString,1,nPos-1)) //Bairro
            EndIf
            cString:=Subs(cString,nPos+1)
            If !Empty(cString)
               aInfo[8]:=Alltrim(cString) //Cidade
            EndIf
      ElseIf (nPos:=At("CEP ",xValor))<>0
            lFlagComp:=.T.
            If nPos>0
               aInfo[10]:=Subs(xValor,nPos+4) //CEP
            EndIf
      ElseIf lFlagComp // Complemento do Endereco ate a palavra Concluido
            cString:=xValor
            If cString<>"CONCLUIDO" .AND. cString<>"-----"
               aInfo[9]:=aInfo[9]+cString+"/" //Complemento Endereco
            else
               lFlagComp:=.F.	
               lFlagProdutos:=.T. // Apos a palavra concluido inicia os produtos
            EndIf
      ElseIf lFlagProdutos.and. nLinha=0 // Pegar a quantidade
            cString:=xValor
            nQuant:=0
            If (nPos:=At("SUBTOTAL", cString)>0) 
               lFlagProdutos:=.F.
               Loop
            EndIf
            If (nPos:=At("VALOR TOTAL DO PEDIDO", cString)>0) 
               lFlagProdutos:=.F.
               Loop
            EndIf
            If (nPos:=At("TAXA DE ENTREGA", cString)>0)
               Aadd(aProdutos,{,,})
               nP:=Len(aProdutos)
               cDesc:=xValor //Descrição do produto
               nLinha:=3
               aProdutos[nP,2]:=cDesc
            Else	
               nPos:=At("X", cString)
               If nPos>0
                  Aadd(aProdutos,{,,})
                  nP:=Len(aProdutos)
                  nQuant:=Val(Subs(cString,1,nPos-1)) //Quantidade
                  nLinha:=2
                  aProdutos[nP,1]:=nQuant
               EndIf	
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
   aadd(aClientes,aInfo)
   //I240Inc(aInfo)
Next nD

Return aClientes


/*
Funcao      : I240Inc
Objetivos   : Inclui cliente na tabela SA1
Autor       : Marcos Alves
Data/Hora   : 21/10/2021
*/
*-------------------------*
Static Function I240Inc(aInfo)
*-------------------------*
Local lFound:=.F.
Local nFound:=0
Local cFound:=""
Local lRet	:= .T.
Local cCPf  := aInfo[11]
  
AutoGrLog("9) Analisando cadastro do cliente :" + aInfo[1] +" de "+ aInfo[13])
ConOut("9) Analisando cadastro do cliente :" + aInfo[1] +" de "+ aInfo[13])

dbSelectArea("SA1")
If !Empty(cCPf) //CPF
   AutoGrLog("10) Pesquisar CPF no SA1 :" + aInfo[11] )

	dbSetOrder(3) //A1_FILIAL+A1_CGG
	If (SA1->(dbSeek(xFilial("SA1")+cCPf)))		//Cadastro de cliente
      AutoGrLog("10) CPF localizado no SA1 :" + aInfo[11] +"  Codigo:"+SA1->A1_COD)
      lFound:=.T.
      cFound:="02" // Cliente localizado no SA1 pelo CPF
	else
      AutoGrLog("10) CPF NAO localizado no SA1 :" + aInfo[11] )
      cFound:="01" // Cliente nao localizado pelo  CPF no SA1
   EndIf
EndIf

If cFound=="" .OR. cFound=="01" // Cliente sem CPF OU Cliente com CPF, NÃO encontrado no SA1
   AutoGrLog("10) Pesquisar cliente por nome no SA1 :" + aInfo[1] )
	dbSetOrder(2) //A1_FILIAL+A1_CGG
	If SA1->(dbSeek(xFilial("SA1")+aInfo[1]))
      AutoGrLog("11) Nome cod cliente localizadi no SA1 :" + aInfo[1] +"  Codigo:"+SA1->A1_COD)
      cFound:=If(cFound=="01","03","04") // 03 - Cliente com CPF, 04 Cliente localizado pelo mas nao cadastrado o cpf no SA1
   Else
      AutoGrLog("12) Pesquisar cliente pelo primeiro nome no SA1 :" + aInfo[1] )
		cNome1:=Subs(aInfo[1],1,At(" ",aInfo[1])-1 )
		cFound:="05"
      If SA1->(dbSeek(xFilial("SA1")+cNome1))
			While cNome1==Subs(SA1->A1_NOME,1, At(" ",SA1->A1_NOME)-1).And.!SA1->(Eof())
            nFound:=1
            AutoGrLog(Repli("-",80))
            AutoGrLog("13) Validacao do NOME Ifood :"+aInfo[1])
            AutoGrLog("13) Validacao do NOME SA1...:"+SA1->A1_NOME)
				If Alltrim(SA1->A1_END)==Alltrim(aInfo[6])
               AutoGrLog("15) Validacao do ENDERECO iFood :"+aInfo[6])
               AutoGrLog("15) Validacao do ENDERECO SA1.. :"+SA1->A1_END)
					nFound++
				EndIf
				If Alltrim(SA1->A1_BAIRRO)==aInfo[7]
               AutoGrLog("16) Validacao do BAIRRO Ifood...:"+aInfo[7])
               AutoGrLog("16) Validacao do BAIRRO SA1.....:"+SA1->A1_BAIRRO)
					nFound++
				EndIf 
				If SA1->A1_CEP==aInfo[10]
               AutoGrLog("14) Validacao do CEP Ifood..: "+aInfo[10])
               AutoGrLog("14) Validacao do CEP SA1....: "+SA1->A1_CEP)

					nFound++			//cCep
				EndIf
				If nFound>3
               AutoGrLog("17) Validacao pelo primeiro nome OK - cFound 06 ")
               cFound:="06"
					EXIT
				EndIf
				SA1->(dbSkip())
			END  
      ENDIF	
	ENDIF
ENDIF

If cFound$"01#03#05" //Pesquisa pelo CPF NAO encontrou o cliente no SA1 - iNCLUIR
	nCodCli:=I240GetCod()
   AutoGrLog("18) Incluido novo cliente Ifood " +cFound+" Codigo:"+nCodCli+" - "+aInfo[1])
   ConOut("18) Incluido novo cliente Ifood " +cFound+" Codigo:"+nCodCli+" - "+aInfo[1])
   nNumCom:=ainfo[5]
   nNumCom:=If(nNumCom=0,1,nNumcom)
   SA1->(RecLock("SA1",.T.))
	SA1->A1_FILIAL	   :=xFilial("SA1")
	SA1->A1_COD		   :=nCodCli
	SA1->A1_LOJA	   :=cFilAnt
	SA1->A1_NOME	   :=aInfo[1] 			//Nome
	SA1->A1_NREDUZ	   :=aInfo[1] 			//cNomeRed
	SA1->A1_PESSOA	   :="F"
	SA1->A1_TIPO	   :="F"
	SA1->A1_END		   :=aInfo[6]				//cEnd
	SA1->A1_MUN		   :="SAO PAULO"        //aDados[8]				//cMun
	SA1->A1_EST		   :="SP"			   	//cEst
	SA1->A1_BAIRRO	   :=aInfo[7] 			   //cBairro
	SA1->A1_CEP		   :=aInfo[10]			   //cCep
	SA1->A1_PAIS	   :="105"
	SA1->A1_CGC		   :=aInfo[11]
	SA1->A1_MOEDALC	:=2
	//SA1->A1_ULTCOM	:=CTOD(cUltCompra) 		// Ultima Compra
	//SA1->A1_DTNASC	:=aCli[9]			//dNasc
	SA1->A1_TIPCLI	   :="1"
	SA1->A1_RECCOFI	:="N"
	SA1->A1_RECCSLL	:="N"
	SA1->A1_RECPIS	   :="N"
	SA1->A1_B2B		   :="2"
	SA1->A1_MSBLQL	   :="2"
	SA1->A1_ABATIMP	:="3"
	SA1->A1_PRICOM	   :=ctod(aInfo[13])	//Primeira compra
	SA1->A1_ULTCOM	   :=ctod(aInfo[13])	//Ultima compra
	SA1->A1_MCOMPRA	:=0	//Maior compra
	SA1->A1_NROCOM	   :=ainfo[5]
	SA1->A1_CONTATO   :="IFOOD"
	SA1->A1_RG		   :=Subs(aInfo[12],17,10)
   If Empty(SA1->A1_PRF_OBS)
      SA1->A1_PRF_OBS   := "  Data         Hora            Pedido   "+chr(10)
      SA1->A1_PRF_OBS   := "---------  ---------------  ------------"+chr(10)
   EndIf
   SA1->A1_PRF_OBS   :=Alltrim(SA1->A1_PRF_OBS)+ainfo[13] + " - "+ainfo[3]+" - "+ainfo[2]+cHR(10)

	SA1->(MsUnLock())
	SA1->(dbCommit())

ElseIf cFound$"02#05#04" //Pesquisa pelo CPF encontrou o cliente no SA1 - Comparar cadastro
   AutoGrLog("3) Pesquisa pelo CPF encontrou o cliente no SA1: "+aInfo[11] )
   AutoGrLog("3) Codigo cliente no SA1: "+SA1->A1_COD )
   AutoGrLog("3) Verificando diferenca no cadastro")
   cString:="# "
   If At("Cliente NFP",SA1->A1_NOME)<>0
      AutoGrLog("15) Cliente NFP  Dados Atualizados")
      ConOut("15) Cliente NFP  Dados Atualizados")
      SA1->(RecLock("SA1",.F.))
      SA1->A1_LOJA	   :=cFilAnt
      SA1->A1_NOME	   :=aInfo[1] 			//Nome
      SA1->A1_NREDUZ	   :=aInfo[1] 			//cNomeRed
      SA1->A1_PESSOA	   :="F"
      SA1->A1_TIPO	   :="F"
      SA1->A1_END		   :=aInfo[6]				//cEnd
      SA1->A1_MUN		   :="SAO PAULO"        //aDados[8]				//cMun
      SA1->A1_EST		   :="SP"			   	//cEst
      SA1->A1_BAIRRO	   :=aInfo[7] 			   //cBairro
      SA1->A1_CEP		   :=aInfo[10]			   //cCep
      SA1->A1_PAIS	   :="105"
      SA1->A1_CGC		   :=If(Empty(aInfo[11]),SA1->A1_CGC,aInfo[11]) 			//cCPF
      SA1->A1_MOEDALC	:=2
      SA1->A1_TIPCLI	   :="1"
      SA1->A1_RECCOFI	:="N"
      SA1->A1_RECCSLL	:="N"
      SA1->A1_RECPIS	   :="N"
      SA1->A1_B2B		   :="2"
      SA1->A1_MSBLQL	   :="2"
      SA1->A1_ABATIMP	:="3"
      SA1->A1_ULTCOM	   :=ctod(aInfo[13])	//Ultima compra
      SA1->A1_MCOMPRA	:=0	//Maior compra
   	SA1->A1_NROCOM	   :=If(SA1->A1_NROCOM>ainfo[5],SA1->A1_NROCOM,ainfo[5])
      SA1->A1_CONTATO   :="IFOOD"
      SA1->A1_RG		   :=RIGHT(aInfo[12],14)
   	//SA1->A1_PRF_OBS   :=Alltrim(SA1->A1_PRF_OBS)+cHR(10)+"Cliente NFP  Dados Atualizados"
	   If Empty(SA1->A1_PRF_OBS)
         SA1->A1_PRF_OBS   := "  Data         Hora            Pedido   "+chr(10)
         SA1->A1_PRF_OBS   := "---------  ---------------  ------------"+chr(10)
      EndIf
	   SA1->A1_PRF_OBS   :=Alltrim(SA1->A1_PRF_OBS)+ainfo[13] + " - "+ainfo[3]+" - "+ainfo[2]+cHR(10)
      SA1->(MsUnLock())
      SA1->(dbCommit())
   else
      AutoGrLog("17) Cliente ja cadastrado "+SA1->A1_COD+" - "+SA1->A1_NOME)
      ConOut("17) Cliente ja cadastrado "+SA1->A1_COD+" - "+SA1->A1_NOME)
      AutoGrLog(Repli("+",80))
      If SA1->A1_NOME<>aInfo[1]
         AutoGrLog("13) Validacao do NOME Ifood :"+aInfo[1])
         AutoGrLog("13) Validacao do NOME SA1...:"+SA1->A1_NOME)
         cString+="Nome / "
      ENDIF

      If SA1->A1_END<>aInfo[6]			//cEnd
         AutoGrLog("15) Validacao do ENDERECO iFood :"+aInfo[6])
         AutoGrLog("15) Validacao do ENDERECO SA1.. :"+SA1->A1_END)
         cString+="Endereco/ "
      EndIf   

      If SA1->A1_BAIRRO<>aInfo[7] 			//cBairro
         AutoGrLog("16) Validacao do BAIRRO Ifood...:"+aInfo[7])
         AutoGrLog("16) Validacao do BAIRRO SA1.....:"+SA1->A1_BAIRRO)
         cString+="Bairro /"
      ENDIF
      
      If SA1->A1_CEP<>aInfo[10]			//cCep
         AutoGrLog("14) Validacao do CEP Ifood..: "+aInfo[10])
         AutoGrLog("14) Validacao do CEP SA1....: "+SA1->A1_CEP)
         cString+="CEP /"
      ENDIF
      SA1->(RecLock("SA1",.F.))
	   If Empty(SA1->A1_PRF_OBS)
         SA1->A1_PRF_OBS   := "  Data         Hora            Pedido   "+chr(10)
         SA1->A1_PRF_OBS   := "---------  ---------------  ------------"+chr(10)
      EndIf
  
      SA1->A1_PRF_OBS   :=Alltrim(SA1->A1_PRF_OBS)+ainfo[13] + " - "+ainfo[3]+" - "+ainfo[2]+cHR(10)
      SA1->A1_OBSERV    :=cString
	   SA1->A1_PRICOM	   :=If(!Empty(SA1->A1_PRICOM).and.SA1->A1_PRICOM<ctod(aInfo[13]),SA1->A1_PRICOM,ctod(aInfo[13]))	//Primeira compra
   	SA1->A1_ULTCOM	   := If(SA1->A1_ULTCOM>ctod(aInfo[13]),SA1->A1_ULTCOM,ctod(aInfo[13]))
      SA1->A1_NROCOM	   := If( SA1->A1_NROCOM > ainfo[5] ,SA1->A1_NROCOM,ainfo[5])
	   SA1->A1_CONTATO   :="IFOOD"
	   SA1->A1_RG		   :=Subs(aInfo[12],17,10)
	   SA1->(MsUnLock())
	   SA1->(dbCommit())
   EndIf
EndIf

Return lRet


Static Function I240GetCod()
Local cQuery:=""
Local nCod:=IF(cFilAnt="01","710000","720000")

cQuery := "SELECT MAX(A1_COD)"
cQuery += "FROM "+RetSqlName("SA1")+" "
cQuery += "WHERE A1_FILIAL = '"+xFilial("SA1")+"' "
cQuery += "AND A1_COD >= '"+IF(cFilAnt="01","710000","720000")+"' "
cQuery += "AND A1_COD <= '"+IF(cFilAnt="01","719999","729999")+"' "
cQuery += "AND D_E_L_E_T_ <> '*' "

//+-----------------------
//| Cria indice temporario
//+-----------------------
//+-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
dbSelectArea("TRB")
dbGoTop()
nCod:=If(Empty(TRB->CFIELD1), nCod,TRB->CFIELD1)

dbCloseArea()

Return Soma1(nCod)


/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parâmetros  : cArq - nome do arquivo que será usado      
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function I240XCarga(cArq)
Local oCupom	
Local nHdl		:=-1
Local nInicio	:= 1
Local nLin		
Local adados   :={}
Local nLength
Local cBuffer  :=Space(500)
Local nBloco   :=0
Local nBytes   :=0
Local lLidos   :=.T.

nHdl:=FOpen(cTemp+cArq,2)
If nHdl==-1
   Return adados
EndIf

//Total de Bytes
nLength := FSEEK(nHdl, 0, 2) // 0 - Inicio; 1 - Posicao atual; 2 - Final
// Posiciona no início do arquivo
FSEEK(nHdl, 0)

While lLidos==.T.
    nBytes := FREAD(nHdl, @cBuffer, nBloco)      // Lê os bytes

End 

fClose(nHdl)
Return Nil


/*
Funcao      : I240YCarga(cArq)
Objetivos   : carrega dados do csv no array pra retorno
Parâmetros  : cArq - nome do arquivo que será usado      
Autor       : Marcos Alves
Data/Hora   : 27/10/2021
*/
*-------------------------*
Static Function I240YCarga(cArq)

Local oFile := FwFileReader():New(cTemp+cArq)
Local aAux  := {}
Local aLine := {}
Local aHead := {}

// SE NÃO, EXIBA O ERRO DE ABERTURA
If (oFile:Open())
   aAux := oFile:GetAllLines() // ACESSA TODAS AS LINHAS

   // CRIA O CABEÇALHO E DELETA DO CONJUNTO DE LINHAS
   //aHead := StrTokArr2(aAux[1], ";")
   //ADel(aAux, 1)
   //ASize(aAux, Len(aAux) - 1)

   // SEPARA O VETOR EM NÍVEL CONFORME TOKEN
   AEval(aAux, {|x| AAdd(aLine, StrTokArr2(x, ";", .T.))})
EndIf

Return aLine
