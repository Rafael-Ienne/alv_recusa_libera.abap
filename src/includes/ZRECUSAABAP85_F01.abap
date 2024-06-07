*&---------------------------------------------------------------------*
*& Include          ZRECUSAABAP85_F01
*&---------------------------------------------------------------------*

*&-------------------------------------------------------------------------*
*& Form para selecionar o(s) item(s) na tabela VBAP com base no campo VBELN
*&-------------------------------------------------------------------------*
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
 WHERE vbeln IN s_vbeln.

ENDFORM.

*&-------------------------------------------------------------------------*
*& Form para estabelecer quais serão os campos do ALV
*&-------------------------------------------------------------------------*
FORM f_build_fieldcat USING VALUE(p_fieldname)  TYPE c
                            VALUE(p_field)      TYPE c
                            VALUE(p_table)      TYPE c
                            VALUE(p_coltext)    TYPE c
                            CHANGING t_fieldcat TYPE lvc_t_fcat.
  DATA: ls_fieldcat LIKE LINE OF t_fieldcat[].

  "Nome do campo dado na tabela interna
  ls_fieldcat-fieldname = p_fieldname.
  "Nome do campo na tabela transparente
  ls_fieldcat-ref_field = p_field.
  "Tabela transparente
  ls_fieldcat-ref_table = p_table.
  "Descrição que daremos para o campo no ALV.
  ls_fieldcat-coltext   = p_coltext.

  APPEND ls_fieldcat TO t_fieldcat[].
ENDFORM.

*&-------------------------------------------------------------------------------------------------*
*& Form para recusar a venda de um item usando BAPI com base no número de documento de venda(VBELN)
*&-------------------------------------------------------------------------------------------------*
FORM f_recusar_liberar_com_bapi USING p_doc_venda TYPE ty_doc_venda.

  DATA: ld_header TYPE bapisdh1x,
        lt_return TYPE STANDARD TABLE OF bapiret2,
        lt_itens  TYPE STANDARD TABLE OF bapisditm,
        lt_check  TYPE STANDARD TABLE OF bapisditmx,
        ls_item   LIKE LINE OF lt_itens,
        ls_check  LIKE LINE OF lt_check.

  ls_item-itm_number = p_doc_venda-posnr.

  IF sy-ucomm EQ 'RECUSAR'.
    ls_item-reason_rej = '00'.
  ELSE.
    ls_item-reason_rej = ''.
  ENDIF.

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

*&----------------------------------------------------------------------------*
*& Form para recusar a venda de um item com base no número de documento (VBELN)
*&----------------------------------------------------------------------------*
FORM f_recusar_ou_liberar.

  go_alv->get_selected_rows(
        IMPORTING
          et_index_rows = gt_rows "Pegando as linhas selecionadas no ALV
      ).

  IF lines( gt_rows ) GT 1.
    MESSAGE 'Selecione apenas uma linha' TYPE 'I' DISPLAY LIKE 'E'.
  ELSEIF lines( gt_rows ) IS INITIAL.
    MESSAGE 'Selecione uma linha' TYPE 'I' DISPLAY LIKE 'E'.
  ELSE.

    LOOP AT gt_rows INTO DATA(ls_row).

      READ TABLE gt_docs_venda INTO gs_doc_venda INDEX ls_row-index.

      IF sy-subrc IS INITIAL.
        PERFORM f_recusar_liberar_com_bapi USING gs_doc_venda.
      ENDIF.

      PERFORM f_selecionar_dados.
      PERFORM f_refresh_tela.

    ENDLOOP.
  ENDIF.

ENDFORM.

*&----------------------------------------------------------------------------*
*& Form para associar a variável do container à subscreen SUBTELA_TABELA
*&----------------------------------------------------------------------------*
FORM f_build_container .
  go_container = NEW cl_gui_custom_container(
      container_name              = 'SUBTELA_TABELA'
    ).
ENDFORM.

*&----------------------------------------------------------------------------*
*& Form para construir e mostrar o ALV
*&----------------------------------------------------------------------------*
FORM f_build_alv .

  go_alv = NEW cl_gui_alv_grid(
        i_parent                = go_container "Associando o ALV ao container/subscreen onde será exibido
      ).

  PERFORM f_build_fieldcat USING:
        'VBELN' 'VBELN' 'VBAP' 'Documento' CHANGING lt_fieldcat[],
        'POSNR' 'POSNR' 'VBAP' 'Item' CHANGING lt_fieldcat[],
        'MATNR' 'MATNR' 'VBAP' 'Material' CHANGING lt_fieldcat[],
        'ARKTX' 'ARKTX' 'VBAP' 'Denominação item' CHANGING lt_fieldcat[],
        'KWMENG' 'KWMENG' 'VBAP' 'Quantidade' CHANGING lt_fieldcat[],
        'VRKME' 'VRKME' 'VBAP' 'Unidade' CHANGING lt_fieldcat[],
        'ABGRU' 'ABGRU' 'VBAP' 'Motivo de recusa' CHANGING lt_fieldcat[].

  "Permite que mais de uma linha seja selecionada(para fins visuais)
  go_alv->set_ready_for_input( 1 ).
  "Ajusta o tamanho do ALV
  ls_layout-cwidth_opt = 'X'.
  "ALV zebrado ou não
  ls_layout-zebra = 'X'.

  go_alv->set_table_for_first_display(

    EXPORTING
      is_variant                    =    ls_variant
      is_layout                     =    ls_layout

    CHANGING
      it_outtab                     =     gt_docs_venda[]
      it_fieldcatalog               =     lt_fieldcat[]
    ) .

  "Titulo do ALV
  go_alv->set_gridtitle( 'Itens do documento de venda' ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_refresh_tela
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_refresh_tela .

  go_alv->refresh_table_display(

        EXCEPTIONS
          finished       = 1
          OTHERS         = 2
      ).

ENDFORM.