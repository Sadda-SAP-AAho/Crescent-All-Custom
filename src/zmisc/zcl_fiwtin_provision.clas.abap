CLASS zcl_fiwtin_provision DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_fiwtin_provision .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FIWTIN_PROVISION IMPLEMENTATION.


  METHOD if_fiwtin_provision~modify_disptab.
  LOOP AT ct_disptab ASSIGNING FIELD-SYMBOL(<fs_tab>).
  <fs_tab>-prctr = '0000001000'.
  ENDLOOP.
  ENDMETHOD.
ENDCLASS.
