*&---------------------------------------------------------------------*
*& Include          ZMONITORSTATUSVENDA85_P
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  DATA(lo_relatorio) = NEW zcl_dashboard_vendas85( range_cliente = gd_cli[]
                                             range_ordem = gd_ordem[] ).

  CASE 'X'.

    WHEN p_arq.

      gt_relatorio = lo_relatorio->consultar_planilha_excel( ).

    WHEN p_sap.

      gt_relatorio = lo_relatorio->select_dados_sem_excel( ).

  ENDCASE.

  IF gt_relatorio[] IS NOT INITIAL.
    PERFORM f_gerar_alv.
  ELSE.
    MESSAGE 'Dados não encontrados. Tente novamente' TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.