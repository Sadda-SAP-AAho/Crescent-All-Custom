CLASS zcl_j_1ig_badi_isd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_j1ig_isd .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_J_1IG_BADI_ISD IMPLEMENTATION.


  METHOD if_ex_j1ig_isd~fill_bapi_extension.
   data : lv_prctr TYPE prctr.

    IF sy-tcode = 'J1IG_ISDN'.

      DATA(lt_bset) = im_t_bset[].

      SORT lt_bset BY bupla.
      DELETE ADJACENT DUPLICATES FROM lt_bset COMPARING bupla.

      LOOP AT lt_bset INTO DATA(wa_bset).
        IF wa_bset-bupla = '1500'.
          DATA(lv_flag) = 'X'.
        ENDIF.
        IF wa_bset-bupla = '1000'.
          DATA(lv_flag_1) = 'X'.
        ENDIF.
        IF wa_bset-bupla = '1400'.
          DATA(lv_flag_2) = 'X'.
        ENDIF.
        CLEAR : wa_bset.
      ENDLOOP.

      if lv_flag = 'X' and lv_flag_1 = 'X'.
        lv_prctr = '0000001000'.
      elseif lv_flag = 'X' and lv_flag_2 = 'X'.
        lv_prctr = '0000001400'.
      endif.


      LOOP AT ch_t_tax INTO DATA(ls_bset).

        APPEND INITIAL LINE TO ch_t_bapiexten ASSIGNING FIELD-SYMBOL(<fs_exten>).
        <fs_exten>-valuepart1 = 'PRCTR'.
        <fs_exten>-valuepart2 = lv_prctr.
        <fs_exten>-valuepart3 = ls_bset-itemno_acc.

        CLEAR : ls_bset.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD if_ex_j1ig_isd~summarize.
  ENDMETHOD.
ENDCLASS.
