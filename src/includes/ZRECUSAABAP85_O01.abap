*&---------------------------------------------------------------------*
*& Module SHOW_ALV OUTPUT
*&---------------------------------------------------------------------*
MODULE show_alv OUTPUT.

  IF go_container IS NOT BOUND.

    PERFORM f_build_container.

  ENDIF.

  IF go_alv IS NOT BOUND.

    PERFORM f_build_alv.

  ELSE.

    PERFORM f_refresh_tela.

  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Module SET_PF_STATUS OUTPUT
*&---------------------------------------------------------------------*
MODULE set_pf_status OUTPUT.
  SET PF-STATUS 'STATUS9000'.
  SET TITLEBAR 'TITLE9000'.
ENDMODULE.