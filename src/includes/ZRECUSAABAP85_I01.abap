*&---------------------------------------------------------------------*
*& Include          ZCLSALVTABLEABAP852_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CASE sy-ucomm.

    WHEN 'BTN_P'.
      PERFORM f_selecionar_dados.

    WHEN 'BACK' OR 'LEAVE' OR 'CANCEL'.
      LEAVE PROGRAM.

    WHEN 'RECUSAR'.
      PERFORM f_recusar_ou_liberar.

    WHEN 'LIBERAR'.
      PERFORM f_recusar_ou_liberar.

  ENDCASE.
ENDMODULE.