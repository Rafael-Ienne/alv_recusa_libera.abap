*&---------------------------------------------------------------------*
*& Include          ZMONITORSTATUSVENDA85_TOP
*&---------------------------------------------------------------------*
TABLES: kna1, vbak, vbap.

CLASS tratar_funcao_botao DEFINITION.

  PUBLIC SECTION.

    METHODS: on_user_command FOR EVENT added_function OF cl_salv_events IMPORTING e_salv_function.

ENDCLASS.

CLASS tratar_funcao_botao IMPLEMENTATION.

  METHOD on_user_command.
    PERFORM f_tratar_b_recusar USING e_salv_function.
  ENDMETHOD.

ENDCLASS.

"TYPES para armazenar os dados do relatório
TYPES:
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

DATA: go_alv    TYPE REF TO cl_salv_table, "objeto ALV
      go_events TYPE REF TO cl_salv_events_table. "objeto para tratar de cliques no ALV

DATA: gt_relatorio TYPE STANDARD TABLE OF ty_relatorio. "tabela onde serão armazenados os dados finais do ALV

DATA: go_tratar_botao TYPE REF TO tratar_funcao_botao.

DATA: gv_last_action TYPE sy-ucomm. "variável para armazenar código dos botões da tela de seleção

DATA:gd_cli   TYPE RANGE OF kna1-kunnr,
     gd_ordem TYPE RANGE OF vbak-vbeln. "variáveis que armazenarão os parâmetros de busca

SELECTION-SCREEN: BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_cli FOR kna1-kunnr,
                  s_ordem FOR vbak-vbeln.
  PARAMETERS: p_arq RADIOBUTTON GROUP g1 USER-COMMAND action,
              p_sap RADIOBUTTON GROUP g1 DEFAULT 'X'.
SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN.
  gv_last_action = sy-ucomm.
  gd_cli = s_cli[].
  gd_ordem = s_ordem[].
  CLEAR: s_cli[], s_ordem[]. "método para limpar o SELECT-OPTIONS

AT SELECTION-SCREEN OUTPUT.

  PERFORM f_alterar_input USING gv_last_action. "método para bloquear o input no SELECT-OPTIONS ao se escolher a opção p_arq