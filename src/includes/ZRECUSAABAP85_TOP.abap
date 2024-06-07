*&---------------------------------------------------------------------*
*& Include          ZCLSALVTABLEABAP852_TOP
*&---------------------------------------------------------------------*

TABLES: vbap.

TYPES: BEGIN OF ty_doc_venda,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         arktx  TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
         vrkme  TYPE vbap-vrkme,
         abgru  TYPE vbap-abgru.
TYPES: END OF ty_doc_venda.

DATA: gt_docs_venda TYPE STANDARD TABLE OF ty_doc_venda, "Tabela interna com os dados a serem eibidos no ALV
      gs_doc_venda  LIKE LINE OF gt_docs_venda. "Estrutura da tabela interna gt_docs_venda

DATA: go_alv        TYPE REF TO cl_gui_alv_grid, "Objeto ALV
      lv_okcode_100 TYPE sy-ucomm,
      lt_fieldcat   TYPE lvc_t_fcat,
      ls_layout     TYPE lvc_s_layo,
      ls_variant    TYPE disvariant,
      go_container  TYPE REF TO cl_gui_custom_container. "Container(subscreen) onde será exibido o ALV

DATA:  gt_rows TYPE lvc_t_row.

SELECTION-SCREEN BEGIN OF SCREEN 2100 AS SUBSCREEN.

  SELECT-OPTIONS: s_vbeln FOR vbap-vbeln.

SELECTION-SCREEN END OF SCREEN 2100.