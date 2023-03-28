
/*
Esta função e executada no X3_RELACAO com campo E2_SITUA, e tem como objetivo reiniciar as variaveis de memoria com os dados do registro do SE2 posicionado na rotina de inclusao de 
titulos a pagar, quando o parametro (F12) do pergunte MV_par12, estiver como SIM, ou seja, faz uma copia do titulo atual.
*/
User Function IB004Copia()
Local xRet      := ""

If INCLUI .AND. MV_PAR11==1
    M->E2_PREFIXO   :=SE2->E2_PREFIXO
    M->E2_NUM       :=SE2->E2_NUM
    M->E2_PARCELA   :=SE2->E2_PARCELA
    M->E2_TIPO      :=SE2->E2_TIPO
    M->E2_NATUREZ   :=SE2->E2_NATUREZ
    M->E2_PORTADO   :=SE2->E2_PORTADO
    M->E2_FORNECE   :=SE2->E2_FORNECE
    M->E2_LOJA      :=SE2->E2_LOJA
    M->E2_NOMFOR    :=GatForn("E2_NOMFOR")
    M->E2_EMISSAO   :=dDataBase
    M->E2_VALOR     :=0
    M->E2_HIST      :=SE2->E2_HIST
EndIf

Return xRet
