
/*
Ponto de entrada MT103FIM executado a final do recebimento de materiuais utilizado para 
 baixar Titulos com pagamento a vista
*/
User Function MT103FIM() 

Local nOpcao := PARAMIXB[1]         // Opção Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2]      // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO
Local aBaixa    := {}               //array com os dados da baixa a pagar do título³
Local cBancoA   :=""
Local cAgencA   :=""
Local cContaA   :=""
Local cHistBaixa := "PGTO VISTA - BAIXA AUTO" 

Private lMsErroAuto:=.F.

// CUSTOMIZAÇÃO
If nOpcao=3 .And. nConfirma=1
    If (SE2->E2_VENCTO==SE2->E2_EMISSAO) // Pagamento a Vista
        IB002Bco(@cBancoA,@cAgencA,@cContaA)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        //³Monta array com os dados da baixa a pagar do título³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        AADD(aBaixa, {"E2_FILIAL"       , SE2->E2_FILIAL    , Nil})
        AADD(aBaixa, {"E2_PREFIXO"      , SE2->E2_PREFIXO   , Nil})
        AADD(aBaixa, {"E2_NUM"          , SE2->E2_NUM       , Nil})
        AADD(aBaixa, {"E2_PARCELA"      , SE2->E2_PARCELA   , Nil})
        AADD(aBaixa, {"E2_TIPO"         , SE2->E2_TIPO      , Nil})
        AADD(aBaixa, {"E2_FORNECE"      , SE2->E2_FORNECE   , Nil})
        AADD(aBaixa, {"E2_HIST"         , SE2->E2_LOJA      , Nil})
        AADD(aBaixa, {"E2_LOJA"         , SE2->E2_LOJA      , Nil})
        AADD(aBaixa, {"AUTMOTBX"        , "NOR"             , Nil})
        AADD(aBaixa, {"AUTBANCO"        , cBancoA           , Nil})
        AADD(aBaixa, {"AUTAGENCIA"      , cAgencA           , Nil})
        AADD(aBaixa, {"AUTCONTA"        , cContaA           , Nil})
        AADD(aBaixa, {"AUTDTBAIXA"      , dDataBase         , Nil})
        AADD(aBaixa, {"AUTDTCREDITO"    , dDataBase         , Nil})
        AADD(aBaixa, {"AUTHIST"         , cHistBaixa        , Nil})
        AADD(aBaixa, {"AUTVLRPG"        , SE2->E2_SALDO     , Nil})

        ACESSAPERG("FIN080", .F.)
        MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)

        If lMsErroAuto
            MOSTRAERRO()
            DisarmTransaction()
            Alert("Falha nas Baixas dos Titulos - Pagamento de Instrutores " + SE2->E2_NUM)
        Else
            Alert("Titulo Baixado com sucesso :" + SE2->E2_NUM)
        EndIf
    ENDIF
EndIf
Return NIL


#INCLUDE "PROTHEUS.CH"
/*Função : Tela para digitação do banco da baixa do titulo*/

Static FUNCTION IB002Bco(cBancoA,cAgencA,cContaA)

LOCAL   oDlg     := NIL

cBancoA     := Space(Len(SA6->A6_COD))
cAgencA     := Space(Len(SA6->A6_AGENCIA))
cContaA     := Space(Len(SA6->A6_NUMCON))

DEFINE MSDIALOG oDlg FROM 0,0 TO 85,227 PIXEL TITLE "Selecione Banco - Baixa"

@ 001,003 TO 045,180 LABEL "" OF oDlg PIXEL
@ 008,006 SAY "Banco"   SIZE 15,7 PIXEL OF oDlg
@ 020,006 SAY "Agência" SIZE 20,7 PIXEL OF oDlg
@ 032,006 SAY "Conta"   SIZE 15,7 PIXEL OF oDlg
@ 008,035 MSGET cBancoA F3 "SA6" VALID ExistCpo("SA6",cBancoA) PICTURE "@!" SIZE 10,7 PIXEL OF oDlg
@ 020,035 MSGET cAgencA PICTURE "@!" WHEN .F. SIZE 10,7 PIXEL OF oDlg
@ 032,035 MSGET cContaA PICTURE "@!" WHEN .F. SIZE 10,7 PIXEL OF oDlg

DEFINE SBUTTON FROM 003,084 TYPE 1 OF oDlg ENABLE ONSTOP "Confirma" ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER 

Return

