*&---------------------------------------------------------------------*
*&  Include           ZALV_TMP_SEL
*&---------------------------------------------------------------------*


* ALV selection:
PARAMETERS: p_var1 TYPE slis_vari.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_var1.
  PERFORM alv_variant_f4 USING 'ALV1'
                         CHANGING p_var1.
