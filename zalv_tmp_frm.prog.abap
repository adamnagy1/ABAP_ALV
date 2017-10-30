*&---------------------------------------------------------------------*
*&  Include           ZALV_TMP_FRM
*&---------------------------------------------------------------------*
* REUSE_ALV_GRID_DISPLAY_LVC funkciós elemből a PF-STATUS-t átmásolni,
* név egyezzen a Form  alv_pfstatus szubrutinban megadott névvel
* Szelekciós képernyőn:
* PARAMETERS: p_var1 TYPE slis_vari.
* AT SELECTION-SCREEN on VALUE-REQUEST FOR p_var1.
*  PERFORM alv_variant_f4 USING 'ALV1'
*                         CHANGING p_var1.
* TOP include-ba:
* TYPE-POOLS: slis.
* DATA: gt_alv1 TYPE TABLE OF zcba_list_alv,
*      gr_alv  TYPE REF TO cl_gui_alv_grid.


*&---------------------------------------------------------------------*
*&  Include           Z_CBA_LIST_ALV
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display.
  DATA: lv_cb_prog TYPE sy-repid,
        lv_cb_usercomm TYPE slis_formname VALUE 'ALV_USERCOMMAND',
        lv_cb_pfstatus TYPE slis_formname VALUE 'ALV_PFSTATUS',
        lt_fcat TYPE lvc_t_fcat,
        ls_variant TYPE disvariant.

  lv_cb_prog = sy-cprog.
  PERFORM alv_fcat TABLES lt_fcat.
  PERFORM alv_variant USING 'ALV1'
                      CHANGING ls_variant.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
  EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                =
*   I_BUFFER_ACTIVE                   =
    i_callback_program                = lv_cb_prog
    i_callback_pf_status_set          = lv_cb_pfstatus
    i_callback_user_command           = lv_cb_usercomm
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT_LVC                     =
    it_fieldcat_lvc                   = lt_fcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS_LVC             =
*   IT_SORT_LVC                       =
*   IT_FILTER_LVC                     =
*   IT_HYPERLINK                      =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
    i_save                            = 'X'
    is_variant                        = ls_variant
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT_LVC                      =
*   IS_REPREP_ID_LVC                  =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 =
*   I_HTML_HEIGHT_END                 =
*   IT_ALV_GRAPHICS                   =
*   IT_EXCEPT_QINFO_LVC               =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = gt_alv1
    EXCEPTIONS
      program_error                     = 1
      OTHERS                            = 2.
  IF sy-subrc <> 0.
*  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " DISPLAY_ALV
*&---------------------------------------------------------------------*
*&      Form  ALV_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_FCAT  text
*----------------------------------------------------------------------*
FORM alv_fcat TABLES pt_fcat STRUCTURE lvc_s_fcat.
  DATA: lt_fcat TYPE lvc_t_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE              =
      i_structure_name             = 'ZCBA_LIST_ALV'
*     I_CLIENT_NEVER_DISPLAY       = 'X'
*     I_BYPASSING_BUFFER           =
*     I_INTERNAL_TABNAME           =
    CHANGING
      ct_fieldcat                  = lt_fcat
    EXCEPTIONS
      inconsistent_interface       = 1
      program_error                = 2
      OTHERS                       = 3
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  pt_fcat[] = lt_fcat[].

ENDFORM.                    " ALV_FCAT

*&---------------------------------------------------------------------*
*&      Form  alv_pfstatus
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_pfstatus USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS: 'Z_ALV1'.
ENDFORM.                    "alv_pfstatus

*&---------------------------------------------------------------------*
*&      Form  alv_usercommand
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_usercommand USING uv_ucomm LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.
  IF gr_alv IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
*       ET_EXCLUDING       =
*       E_REPID            =
*       E_CALLBACK_PROGRAM =
*       E_CALLBACK_ROUTINE =
        e_grid = gr_alv
*       ET_FIELDCAT_LVC    =
*       ER_TRACE           =
*       E_FLG_NO_HTML      =
*       ES_LAYOUT_KKBLO    =
*       ES_SEL_HIDE        =
*       ET_EVENT_EXIT      =
      .
  ENDIF.
  CASE uv_ucomm.
    WHEN '&ZZ_SUM1'.
      "PERFORM process_sum1. " Termékenkénti összegzés
    WHEN '&ZZ_SUM2'.
      "PERFORM process_sum2. " vevőnkénti összegzés
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "alv_usercommand
*&---------------------------------------------------------------------*
*&      Form  ALV_VARIANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0037   text
*      <--P_LS_VARIANT  text
*----------------------------------------------------------------------*
FORM alv_variant USING uv_handle TYPE slis_handl
                 CHANGING cs_variant TYPE disvariant.
  cs_variant-report = sy-repid.
  cs_variant-handle = uv_handle.
  "cs_variant-LOG_GROUP = .
  cs_variant-username = sy-uname.
  cs_variant-variant = p_var1. " TYPE SLIS_VARI
ENDFORM.                    " ALV_VARIANT
*&---------------------------------------------------------------------*
*&      Form  ALV_VARIANT_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0141   text
*      <--P_P_VAR1  text
*----------------------------------------------------------------------*
FORM alv_variant_f4 USING uv_handle TYPE slis_handl
                    CHANGING cv_variant TYPE slis_vari.
  DATA: ls_variant TYPE disvariant.

  ls_variant-report = sy-cprog.
  ls_variant-handle = uv_handle.
*  ls_variant-LOG_GROUP
  ls_variant-username = sy-uname.
*  ls_variant-VARIANT
*  ls_variant-TEXT
*  ls_variant-DEPENDVARS

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant          = ls_variant
*     I_TABNAME_HEADER    =
*     I_TABNAME_ITEM      =
*     IT_DEFAULT_FIELDCAT =
*     I_SAVE              = ' '
      i_display_via_grid  = 'X'
    IMPORTING
*     E_EXIT              =
      es_variant          = ls_variant
    EXCEPTIONS
      not_found           = 1
      program_error       = 2
      OTHERS              = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    cv_variant = ls_variant-variant.
  ENDIF.
ENDFORM.                    " ALV_VARIANT_F4
