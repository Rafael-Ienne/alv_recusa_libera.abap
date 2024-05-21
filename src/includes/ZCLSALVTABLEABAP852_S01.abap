*&---------------------------------------------------------------------*
*& Include          ZCLSALVTABLEABAP852_S01
*&---------------------------------------------------------------------*

TABLES: vbap.

CLASS gcl_tratar_botao_recusa DEFINITION.

  PUBLIC SECTION.
    "Ao se adicionar uma função personalizada no ALV, para o evento added_function,
    "será chamado o método on_user_command
    METHODS: on_user_command FOR EVENT added_function OF cl_salv_events IMPORTING e_salv_function.

ENDCLASS.

CLASS gcl_tratar_botao_recusa IMPLEMENTATION.
  METHOD on_user_command.
    PERFORM f_recusar USING e_salv_function.
  ENDMETHOD.
ENDCLASS.

TYPES: BEGIN OF ty_doc_venda,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         arktx  TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
         vrkme  TYPE vbap-vrkme,
         abgru  TYPE vbap-abgru.
TYPES: END OF ty_doc_venda.

DATA: gt_docs_venda TYPE STANDARD TABLE OF ty_doc_venda.

DATA: go_alv TYPE REF TO cl_salv_table.

DATA: go_tratar_botao_recusa TYPE REF TO gcl_tratar_botao_recusa.

SELECTION-SCREEN: BEGIN OF BLOCK b1.
  SELECT-OPTIONS: s_doc FOR vbap-vbeln.
SELECTION-SCREEN: END OF BLOCK b1.