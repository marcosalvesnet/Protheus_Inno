# Protheus_Inno
03_2023
1) Importar pedidos Ifood para o Frontloja

Os pedidos serao criados em formato .txt, atraves das ferramentas:
- MacroRecorder - Cria script de geracao do arquivo .txt
- PhaseExpress - Cria e gerencia o atalho (CTRL + Win + F) para executar o script da MacroReader

 Os itens do pedido IFOOD serao gravados na comanda 999, mas na tela de vendas, tera a identificacao do numero de pedido IFood;


Fontes Impactados:
- INNOA223 - 
	a) Tratamento para identificar a digitacao do pedido Ifood, iniciado por "*"
	b) Chama a funcao U_INNOA242(Subs(Alltrim(cCodProd),2))
- INNOA242 - 
	a) Funcao de importacao dos dados o Ifood Descrição e codigo para o SBI->BI_DESCIF
	b) Leitura do arquivo smartclient.ini; sessão INNO; variavel IFOODPATH local onde esta sendo gravado o arquivo TXT do Ifood (Ex. IFOODPATH=C:\IFOOD_TMP\)
	c) Grava os itens no SBZ
	d) Grava o CPF do cliente;

- INNOA002 - 
	a) Definir e atualiza a variavel publica 
		INNO_AIF // PATH E NOME DO ARQUIVO Nome do arquivo Ifood
		INNO_CIF // Atualiza cadastro Ifood

- INNOA222 - 
	a) Na funcao I222Grv, efetuar a gravacao da informacao do pedido Ifood na tabela SZZ->ZZ_PEDIDO

Base de Dados Impactadas:
SBI 
	a) Criado campo
		  - SBI->BI_DESCIF (C 40) - Conter a descricao do produto cadastrado no Ifood (campo - chave de pesquisa);

	b) Indices
		6 - BI_FILIAL+BI_DESCIF

SZZ
	a) Criado campo:
		- ZZ_PEDIDO (C 4) armazenara o numero do pedido Ifood, quando for lido e repassara esta informação para o campo L1_LOCALIZ, para ser 

SL1
	a) Campo atualizado
		- L1_NUMERO - campo padrao do Protheus, atualizado com o numero do pedido Ifood
		- L1_LOCALIZ  -  campo padrao do Protheus, atualizado com o numero do pedido Ifood

------------------------------------------------------------------------------------------------------------------
Roteiro de Implantacao:
1) Backup
	- RPO
	- Data
2) Atualizar dicionario de dados
	SX3
		- BI_DESCIF
		- ZZ_PEDIDO	
	SIX
		6 - BI_FILIAL+BI_DESCIF
3) Recriar arquivos
	SBI
	SZZ
4) Importacao dos cardapios
	C:\IFOOD\CARDAPIO_IFOOD.CSV(AC/DI)


5) Aplicar Patch
	INNOA223.PRW
	INNOA242.PRW
	INNOA002.PRW
	INNOA222.PRW

6) Configurar smartclint.ini
	[INNO]
	IFOODPATH=C:\IFOOD_TMP\

6) Teste Unitarios
	Im		

