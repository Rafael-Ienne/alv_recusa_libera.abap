*&---------------------------------------------------------------------*
*& Include          ZCLSALVTABLEABAP852_F01
*&---------------------------------------------------------------------*

FORM f_selecionar_dados.

  SELECT vbeln
         posnr
         matnr
         arktx
         kwmeng
         vrkme
         abgru
 FROM vbap
 INTO TABLE gt_docs_venda
 WHERE vbeln IN s_doc.

ENDFORM.

FORM f_exibir_alv.
  "Instanciando a tabela ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = go_alv                        " Basis Class Simple ALV Tables
    CHANGING
      t_table        = gt_docs_venda
  ).

  "Alterando o título das colunas
  DATA: lo_columns TYPE REF TO cl_salv_columns_table,
        lo_column  TYPE REF TO cl_salv_column.

  lo_columns = go_alv->get_columns( ).

  lo_column = lo_columns->get_column( columnname = 'VBELN' ).
  lo_column->set_short_text( value = 'Doc' ).
  lo_column->set_medium_text( value = 'Documento' ).
  lo_column->set_long_text( value = 'Documento' ).

  lo_column = lo_columns->get_column( columnname = 'POSNR' ).
  lo_column->set_short_text( value = 'Itens' ).
  lo_column->set_medium_text( value = 'Itens doc.' ).
  lo_column->set_long_text( value = 'Itens documento de vendas' ).

  lo_column = lo_columns->get_column( columnname = 'MATNR' ).
  lo_column->set_short_text( value = 'Mat.' ).
  lo_column->set_medium_text( value = 'Material' ).
  lo_column->set_long_text( value = 'Material' ).

  lo_column = lo_columns->get_column( columnname = 'ARKTX' ).
  lo_column->set_short_text( value = 'Denom.' ).
  lo_column->set_medium_text( value = 'Denominação' ).
  lo_column->set_long_text( value = 'Denominação item' ).

  lo_column = lo_columns->get_column( columnname = 'KWMENG' ).
  lo_column->set_short_text( value = 'Quant.' ).
  lo_column->set_medium_text( value = 'Quantidade' ).
  lo_column->set_long_text( value = 'Quantidade ordem' ).

  lo_column = lo_columns->get_column( columnname = 'VRKME' ).
  lo_column->set_short_text( value = 'Unid.' ).
  lo_column->set_medium_text( value = 'Unidade' ).
  lo_column->set_long_text( value = 'Unidade de venda' ).

  lo_column = lo_columns->get_column( columnname = 'ABGRU' ).
  lo_column->set_short_text( value = 'M. rec.' ).
  lo_column->set_medium_text( value = 'Recusa' ).
  lo_column->set_long_text( value = 'Motivo de recusa' ).

  "Colocando uma barra de navegação para o ALV
  go_alv->set_screen_status(
    report        = sy-repid
    pfstatus      = 'STANDARD'
    set_functions = go_alv->c_functions_all
  ).

  "Garantindo a seleção múltipla de linhas
  DATA: lo_selections TYPE REF TO cl_salv_selections.
  lo_selections = go_alv->get_selections( ).
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  DATA: lo_events TYPE REF TO cl_salv_events_table.

  lo_events = go_alv->get_event( )."Obtendo a instância dos eventos do relatório
  CREATE OBJECT go_tratar_botao_recusa.
  SET HANDLER go_tratar_botao_recusa->on_user_command FOR lo_events."Adicionando a classe local à instancia de eventos do relatório

  "Mostrando a tabela ALV
  go_alv->display( ).

ENDFORM.

FORM f_recusar USING p_e_salv_function TYPE salv_de_function.

  DATA: lo_selections TYPE REF TO cl_salv_selections, "Objeto que contem as seleções de linhas
        lt_rows       TYPE salv_t_row. "Tabela que contém os indices das linhas selecionadas da tabela

  CASE p_e_salv_function.

    WHEN 'RECUSAR'.
      lo_selections = go_alv->get_selections( ).
      lt_rows = lo_selections->get_selected_rows( ).

      LOOP AT lt_rows INTO DATA(ls_row).
        READ TABLE gt_docs_venda INTO DATA(ls_doc_venda) INDEX ls_row.
        PERFORM f_recusar_com_bapi USING ls_doc_venda.
      ENDLOOP.

      PERFORM f_selecionar_dados.
      go_alv->refresh( ).

  ENDCASE.

ENDFORM.

FORM f_recusar_com_bapi USING p_doc_venda TYPE ty_doc_venda.

  DATA: ld_header TYPE bapisdh1x,
        lt_return TYPE STANDARD TABLE OF bapiret2,
        lt_itens  TYPE STANDARD TABLE OF bapisditm,
        lt_check  TYPE STANDARD TABLE OF bapisditmx,
        ls_item   LIKE LINE OF lt_itens,
        ls_check  LIKE LINE OF lt_check.

  ls_item-itm_number = p_doc_venda-posnr.
  ls_item-reason_rej = '00'.
  APPEND ls_item TO lt_itens.

  ld_header-updateflag = 'U'.

  ls_check-itm_number = p_doc_venda-posnr.
  ls_check-reason_rej = 'X'.
  ls_check-updateflag = 'U'.
  APPEND ls_check TO lt_check.


  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = p_doc_venda-vbeln
      order_header_inx = ld_header
    TABLES
      return           = lt_return[]
      order_item_in    = lt_itens[]
      order_item_inx   = lt_check[].

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.

ENDFORM.