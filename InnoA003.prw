/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � 		          � Autor � Marcos Alves    � Data �18/01/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o � 										                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Innocencio												  ���
�������������������������������������������������������������������������Ĵ��
��� Progr.   � Data        Descricao								      ���
�������������������������������������������������������������������������Ĵ��
���Marcos    �02/02/08�Criacao 									          ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
