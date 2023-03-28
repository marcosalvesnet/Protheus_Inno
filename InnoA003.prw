/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ 		          ³ Autor ³ Marcos Alves    ³ Data ³18/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ 										                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Innocencio												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Progr.   ³ Data        Descricao								      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos    ³02/02/08³Criacao 									          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FRTCLICHE()
Local nLin
Local aCupom	:={}

If ValType(ParamIxb)=="N"
	nLin:=ParamIxb
Else
	nLin	:=40
EndIf

If cfilAnt="01"
	AAdd(aCupom, "")
	AAdd(aCupom, PADC("INNOCENCIO E CUNHA LTDA"					,nLin))	// "      INNOCENCIO E CUNHA LTDA           "
	AAdd(aCupom, PADC("AV. DEP. EMILIO CARLOS, 2075 - LIMAO"	,nLin))	// "  AV. DEP. EMILIO CARLOS, 2075 - LIMAO  "
	AAdd(aCupom, PADC("www.doceirainnocencio.com.br"			,nLin))	// "     www.doceirainnocencio.com.br       "
Else
	AAdd(aCupom, "")
	AAdd(aCupom, PADC("CONFEITARIA DOCE E FESTA"			,nLin))	// "      INNOCENCIO E CUNHA LTDA           "
	AAdd(aCupom, PADC("AV. PARADA PINTO,2262"				,nLin))	// "  AV. DEP. EMILIO CARLOS, 2075 - LIMAO  "
	AAdd(aCupom, PADC("www.doceirainnocencio.com.br"		,nLin))	// "     www.doceirainnocencio.com.br       "
EndIf

Return aCupom
