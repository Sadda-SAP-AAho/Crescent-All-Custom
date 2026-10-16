CLASS zcl_mmim_item_check_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mmim_item_check_data .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MMIM_ITEM_CHECK_DATA IMPLEMENTATION.


  METHOD if_mmim_item_check_data~check.

    DATA: lo_obj     TYPE REF TO object,
          ld_class   TYPE string VALUE '(SAPLMIGO)LCL_MIGO_GLOBALS=>KERNEL',
          ld_method  TYPE string VALUE 'LINE_GET',
          ld_method1 TYPE string VALUE 'GET_PT_GOITEM'.

    FIELD-SYMBOLS: <lo_kernel>   TYPE any.
*    DATA: .
*
*    ASSIGN (ld_class) TO <lo_kernel>.
*    CHECK <lo_kernel> IS ASSIGNED .
*    lo_obj ?= <lo_kernel>.
*
*    CALL METHOD lo_obj->(ld_method1)
*      IMPORTING
*        e_pt_goitem = lt_goitem.

  ENDMETHOD.
ENDCLASS.
