class ZCL_DASHBOARD_VENDAS85 definition
  public
  final
  create public .

public section.

  types:
    ltt_ordem TYPE RANGE OF vbak-vbeln .
  types:
    ltt_cliente TYPE RANGE OF kna1-kunnr .
  types:
    BEGIN OF ty_relatorio,
        vbeln TYPE vbak-vbeln,
        erdat TYPE vbak-erdat,
        ernam TYPE vbak-ernam,
        netwr TYPE vbak-netwr,
        waerk TYPE vbak-waerk,
        vkorg TYPE vbak-vkorg,
        vtweg TYPE vbak-vtweg,
        spart TYPE vbak-spart,
        gbstk TYPE vbak-gbstk,
        kunnr TYPE vbak-kunnr,
        posnr TYPE vbap-posnr,
        matnr TYPE vbap-matnr,
        arktx TYPE vbap-arktx,
        abgru TYPE vbap-abgru,
        name1 TYPE kna1-name1.
    TYPES: END OF ty_relatorio .
  types:
    ltt_relatorio TYPE TABLE OF ty_relatorio with DEFAULT KEY .
  types:
    BEGIN OF ty_vbeln_posnr,
        vbeln TYPE vbap-vbeln,
        posnr TYPE vbap-posnr.
    TYPES: END OF ty_vbeln_posnr .
  types:
    ltt_vbeln_posnr TYPE TABLE OF ty_vbeln_posnr WITH DEFAULT KEY .

  methods CONSTRUCTOR
    importing
      value(RANGE_CLIENTE) type LTT_CLIENTE
      value(RANGE_ORDEM) type LTT_ORDEM .
  methods GET_RANGE_ORDEM
    returning
      value(ET_RANGE_ORDEM) type LTT_ORDEM .
  methods SET_RANGE_ORDEM
    importing
      value(IT_RANGE_ORDEM) type LTT_ORDEM .
  methods GET_RANGE_CLIENTE
    returning
      value(ET_RANGE_CLIENTE) type LTT_CLIENTE .
  methods SET_RANGE_CLIENTE
    importing
      value(IT_RANGE_CLIENTE) type LTT_CLIENTE .
  methods CONSULTAR_PLANILHA_EXCEL
    returning
      value(RT_TABELA_RELATORIO) type LTT_RELATORIO .
  methods SELECT_DADOS_SEM_EXCEL
    returning
      value(RT_TABELA_RELATORIO) type LTT_RELATORIO .
  methods GET_TABELA_RELATORIO
    returning
      value(RT_TABELA_RELATORIO) type LTT_RELATORIO .
  methods BLOQUEAR_ITEM_VENDA
    importing
      value(IS_ITEM_VENDA) type TY_RELATORIO
      !ID_CODIGO_BOTAO type SALV_DE_FUNCTION .
  methods SET_TABELA_RELATORIO
    importing
      value(IT_TABELA_RELATORIO) type LTT_RELATORIO .
  methods GET_TABELA_VBELN_POSNR
    returning
      value(RT_TABELA_VBELN_POSNR) type LTT_VBELN_POSNR .
  methods SET_TABELA_VBELN_POSNR
    importing
      value(IT_TABELA_VBELN_POSNR) type LTT_VBELN_POSNR .
  PROTECTED SECTION.
private section.

  data RANGE_ORDEM type LTT_ORDEM .
  data RANGE_CLIENTE type LTT_CLIENTE .
  data TABELA_RELATORIO type LTT_RELATORIO .
  data TABELA_VBELN_POSNR type LTT_VBELN_POSNR .

  methods SELECT_DADOS_SAP_EXCEL .
ENDCLASS.



CLASS ZCL_DASHBOARD_VENDAS85 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->BLOQUEAR_ITEM_VENDA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ITEM_VENDA                  TYPE        TY_RELATORIO
* | [--->] ID_CODIGO_BOTAO                TYPE        SALV_DE_FUNCTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bloquear_item_venda.

    DATA: ls_header TYPE bapisdh1x, "cabeçalho do documento
          lt_return TYPE STANDARD TABLE OF bapiret2, "tabela de retorno de mensagens
          lt_itens  TYPE STANDARD TABLE OF bapisditm, "tabela de dados que serão alterados
          lt_check  TYPE STANDARD TABLE OF bapisditmx, "tabela que indica as quais campos serão alterados e a operação a ser feita
          ls_item   LIKE LINE OF lt_itens,
          ls_check  LIKE LINE OF lt_check.

    DATA(ld_botao) = id_codigo_botao.

    ls_item-itm_number = is_item_venda-posnr.
    IF ld_botao EQ 'REC'.
      ls_item-reason_rej = '00'.
    ELSEIF ld_botao EQ 'LIB'.
      ls_item-reason_rej = ' '.
    ENDIF.
    APPEND ls_item TO lt_itens.

    ls_header-updateflag = 'U'.

    ls_check-itm_number = is_item_venda-posnr.
    ls_check-reason_rej = 'X'.
    ls_check-updateflag = 'U'.
    APPEND ls_check TO lt_check.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = is_item_venda-vbeln
        order_header_inx = ls_header
      TABLES
        return           = lt_return
        order_item_in    = lt_itens
        order_item_inx   = lt_check.

    READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.

    IF sy-subrc IS INITIAL AND ld_botao EQ 'REC'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = ls_return.

      MESSAGE 'Erro ao se recusar item(s)' TYPE 'E'.


    ELSEIF sy-subrc IS NOT INITIAL AND ld_botao EQ 'REC'.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      MESSAGE 'Itens recusados com sucesso' TYPE 'S'.

    ELSEIF sy-subrc IS INITIAL AND ld_botao EQ 'LIB'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
        IMPORTING
          return = ls_return.

      MESSAGE 'Erro ao se liberar item(s)' TYPE 'E'.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      MESSAGE 'Itens liberados com sucesso' TYPE 'S'.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] RANGE_CLIENTE                  TYPE        LTT_CLIENTE
* | [--->] RANGE_ORDEM                    TYPE        LTT_ORDEM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    me->range_cliente = range_cliente.
    me->range_ordem = range_ordem.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->CONSULTAR_PLANILHA_EXCEL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_TABELA_RELATORIO            TYPE        LTT_RELATORIO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD consultar_planilha_excel.

    DATA: lv_rc     TYPE i,
          lt_files  TYPE filetable,
          lv_action TYPE i.

    DATA: gs_vbeln_posnr LIKE LINE OF tabela_vbeln_posnr.

    FIELD-SYMBOLS: <worksheet> TYPE ANY TABLE.

    "file open dialog
    cl_gui_frontend_services=>file_open_dialog(
      EXPORTING
        file_filter             = |xlsx (*.xlsx)\|*.xlsx\|{ cl_gui_frontend_services=>filetype_all }|
      CHANGING
        file_table              = lt_files
        rc                      = lv_rc
        user_action             = lv_action ).


    IF lv_action = cl_gui_frontend_services=>action_ok.
      IF lines( lt_files ) > 0.

        "read file and GUI upload
        DATA: lv_filesize TYPE w3param-cont_len,
              lv_filetype TYPE w3param-cont_type,
              it_bin_data TYPE w3mimetabtype.

        cl_gui_frontend_services=>gui_upload(
          EXPORTING
            filename                = |{ lt_files[ 1 ]-filename }|
            filetype                = 'BIN'
          IMPORTING
            filelength              = lv_filesize
          CHANGING
            data_tab                = it_bin_data ).
*
        "solix -> xstring
        DATA(lv_bin_data) = cl_bcs_convert=>solix_to_xstring(
                              it_solix = it_bin_data ).

        "create spreadsheet ref object
        DATA(o_excel) = NEW cl_fdt_xl_spreadsheet( document_name = CONV #( lt_files[ 1 ]-filename )
        xdocument = lv_bin_data ).

        "get first worksheet name
        DATA: it_worksheet_names TYPE if_fdt_doc_spreadsheet=>t_worksheet_names.

        o_excel->if_fdt_doc_spreadsheet~get_worksheet_names( IMPORTING worksheet_names = it_worksheet_names ).

        IF lines( it_worksheet_names ) > 0.
          "first worksheet ref to itab
          DATA(o_worksheet_itab) = o_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( it_worksheet_names[ 1 ] ).

          "ref to generic field symbol (excel data)
          ASSIGN o_worksheet_itab->* TO <worksheet>.

          DATA: o_row TYPE REF TO data.
          CREATE DATA o_row LIKE LINE OF <worksheet>.
          ASSIGN o_row->* TO FIELD-SYMBOL(<row>).

          FIELD-SYMBOLS: <fs_vbeln> TYPE string,
                         <fs_posnr> TYPE string.

          CLEAR: me->tabela_vbeln_posnr[].

          LOOP AT <worksheet> ASSIGNING <row>.

            IF sy-tabix > 1.
              ASSIGN COMPONENT 1 OF STRUCTURE <row> TO <fs_vbeln>.
              ASSIGN COMPONENT 2 OF STRUCTURE <row> TO <fs_posnr>.
              gs_vbeln_posnr = VALUE #( vbeln = <fs_vbeln>
                                        posnr = <fs_posnr> ).
              APPEND gs_vbeln_posnr TO me->tabela_vbeln_posnr.
            ENDIF.
          ENDLOOP.

        ENDIF.
      ENDIF.
    ENDIF.

    me->select_dados_sap_excel( ).

    rt_tabela_relatorio = tabela_relatorio.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->GET_RANGE_CLIENTE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] ET_RANGE_CLIENTE               TYPE        LTT_CLIENTE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_range_cliente.
    et_range_cliente = me->range_cliente.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->GET_RANGE_ORDEM
* +-------------------------------------------------------------------------------------------------+
* | [<-()] ET_RANGE_ORDEM                 TYPE        LTT_ORDEM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_range_ordem.
    et_range_ordem = me->range_ordem.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->GET_TABELA_RELATORIO
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_TABELA_RELATORIO            TYPE        LTT_RELATORIO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_tabela_relatorio.
    rt_tabela_relatorio = me->tabela_relatorio.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->GET_TABELA_VBELN_POSNR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_TABELA_VBELN_POSNR          TYPE        LTT_VBELN_POSNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_tabela_vbeln_posnr.
    rt_tabela_vbeln_posnr = me->tabela_vbeln_posnr.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_DASHBOARD_VENDAS85->SELECT_DADOS_SAP_EXCEL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_dados_sap_excel.

    CLEAR: tabela_relatorio[].

    SELECT vbeln, posnr, matnr, arktx, abgru
    FROM vbap
    FOR ALL ENTRIES IN @tabela_vbeln_posnr
    WHERE vbeln = @tabela_vbeln_posnr-vbeln
    AND posnr = @tabela_vbeln_posnr-posnr
    INTO CORRESPONDING FIELDS OF TABLE @me->tabela_relatorio.

    SELECT vbeln, erdat, ernam, netwr, waerk, vkorg, vtweg, spart, gbstk, kunnr
      FROM vbak
      FOR ALL ENTRIES IN @tabela_relatorio
      WHERE vbeln = @tabela_relatorio-vbeln
      INTO TABLE @DATA(lt_vbak).

    SORT lt_vbak BY vbeln ASCENDING.

    SELECT kunnr, name1
      FROM kna1
      FOR ALL ENTRIES IN @lt_vbak
      WHERE kunnr = @lt_vbak-kunnr
      INTO TABLE @DATA(lt_kna1).

    SORT lt_kna1 BY kunnr ASCENDING.

    LOOP AT tabela_relatorio ASSIGNING FIELD-SYMBOL(<fs_relatorio>).

      READ TABLE lt_vbak INTO DATA(ls_vbak) WITH KEY vbeln = <fs_relatorio>-vbeln BINARY SEARCH.

      CHECK sy-subrc IS INITIAL.

      READ TABLE lt_kna1 INTO DATA(ls_kna1) WITH KEY kunnr = ls_vbak-kunnr BINARY SEARCH.

      CHECK sy-subrc IS INITIAL.

      <fs_relatorio> = VALUE #( BASE <fs_relatorio>
                                erdat = ls_vbak-erdat
                                ernam = ls_vbak-ernam
                                netwr = ls_vbak-netwr
                                waerk = ls_vbak-waerk
                                vkorg = ls_vbak-vkorg
                                vtweg = ls_vbak-vtweg
                                spart = ls_vbak-spart
                                gbstk = ls_vbak-gbstk
                                kunnr = ls_vbak-kunnr
                                name1 = ls_kna1-name1 ).

    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->SELECT_DADOS_SEM_EXCEL
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_TABELA_RELATORIO            TYPE        LTT_RELATORIO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD select_dados_sem_excel.

    CLEAR: tabela_relatorio[].

    SELECT vbak~vbeln,
         vbak~erdat,
         vbak~ernam,
         vbak~netwr,
         vbak~waerk,
         vbak~vkorg,
         vbak~vtweg,
         vbak~spart,
         vbak~gbstk,
         vbak~kunnr,
         vbap~posnr,
         vbap~matnr,
         vbap~arktx,
         vbap~abgru
    FROM vbap
    INNER JOIN vbak
    ON vbap~vbeln = vbak~vbeln
    WHERE vbak~vbeln IN @range_ordem
    AND vbak~kunnr IN @range_cliente
    INTO CORRESPONDING FIELDS OF TABLE @tabela_relatorio.

    SELECT kunnr, name1
      FROM kna1
      FOR ALL ENTRIES IN @tabela_relatorio
      WHERE kunnr = @tabela_relatorio-kunnr
      INTO TABLE @DATA(lt_kna1).

    SORT lt_kna1 BY kunnr ASCENDING.

    LOOP AT tabela_relatorio ASSIGNING FIELD-SYMBOL(<fs_relatorio>).

      READ TABLE lt_kna1 INTO DATA(ls_kna1) WITH KEY kunnr = <fs_relatorio>-kunnr BINARY SEARCH.

      CHECK sy-subrc IS INITIAL.

      <fs_relatorio>-name1 = ls_kna1-name1.

    ENDLOOP.

    rt_tabela_relatorio = tabela_relatorio.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->SET_RANGE_CLIENTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RANGE_CLIENTE               TYPE        LTT_CLIENTE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_range_cliente.
    me->range_cliente = it_range_cliente.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->SET_RANGE_ORDEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RANGE_ORDEM                 TYPE        LTT_ORDEM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_range_ordem.
    me->range_ordem = it_range_ordem.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->SET_TABELA_RELATORIO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TABELA_RELATORIO            TYPE        LTT_RELATORIO
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_tabela_relatorio.
    me->tabela_relatorio = it_tabela_relatorio[].
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DASHBOARD_VENDAS85->SET_TABELA_VBELN_POSNR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_TABELA_VBELN_POSNR          TYPE        LTT_VBELN_POSNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_tabela_vbeln_posnr.
    me->tabela_relatorio = it_tabela_vbeln_posnr[].
  ENDMETHOD.
ENDCLASS.