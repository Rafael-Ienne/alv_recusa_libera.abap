*&---------------------------------------------------------------------*
*& Include          ZMONITORSTATUSVENDA85_F
*&---------------------------------------------------------------------*

FORM f_gerar_alv.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = go_alv
    CHANGING
      t_table        = gt_relatorio
  ).

  go_alv->set_screen_status(
    report        = sy-repid
    pfstatus      = 'STATUS_ST'
    set_functions = cl_salv_model_base=>c_functions_all
  ).

  DATA: lo_selections TYPE REF TO cl_salv_selections.
  lo_selections = go_alv->get_selections( ).
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  go_events = go_alv->get_event( ).

  go_tratar_botao = NEW tratar_funcao_botao( ).

  SET HANDLER go_tratar_botao->on_user_command FOR go_events.

  go_alv->display( ).

ENDFORM.

FORM f_tratar_b_recusar USING e_salv_function.

  DATA: lo_selections TYPE REF TO cl_salv_selections,
        lt_rows       TYPE salv_t_row.

  CASE e_salv_function.

    WHEN 'REC' OR 'LIB'.

      lo_selections = go_alv->get_selections( ).
      lt_rows = lo_selections->get_selected_rows( ).

      IF lines( lt_rows ) EQ 0.

        MESSAGE 'Selecione ao menos uma linha para usar essa função' TYPE 'S' DISPLAY LIKE 'E'.

      ELSE.

        LOOP AT lt_rows INTO DATA(ls_row).

          READ TABLE gt_relatorio INTO DATA(gs_relatorio) INDEX ls_row.

          lo_relatorio->bloquear_item_venda( is_item_venda = gs_relatorio id_codigo_botao = e_salv_function ).

        ENDLOOP.

      ENDIF.

  ENDCASE.

ENDFORM.

FORM f_alterar_input USING iv_last_action.

  IF iv_last_action EQ 'ACTION'.

    CASE 'X'.
      WHEN p_arq.

        LOOP AT SCREEN.

          IF screen-name EQ 'S_CLI-LOW' OR screen-name EQ 'S_ORDEM-LOW' OR screen-name EQ 'S_CLI-HIGH' OR screen-name EQ 'S_ORDEM-HIGH'.
            screen-input = 0.
            MODIFY SCREEN.
          ENDIF.

        ENDLOOP.

      WHEN p_sap.

        LOOP AT SCREEN.

          IF screen-name EQ 'S_CLI-LOW' OR screen-name EQ 'S_ORDEM-LOW' OR screen-name EQ 'S_ORDEM-HIGH' OR screen-name EQ 'S_ORDEM-HIGH'.
            screen-input = 1.
            MODIFY SCREEN.
          ENDIF.

        ENDLOOP.

    ENDCASE.

  ENDIF.

ENDFORM.