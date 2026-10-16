CLASS zcl_gatepass_wlpl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GATEPASS_WLPL IMPLEMENTATION.


METHOD if_sadl_exit_calc_element_read~calculate.
 DATA lt_original_data1 TYPE STANDARD TABLE OF zc_ghead WITH DEFAULT KEY.
    lt_original_data1 = CORRESPONDING #( it_original_data ).
    LOOP AT lt_original_data1 ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      <fs_original_data>-ShowWlpl = COND abap_boolean( WHEN <fs_original_data>-Type = 'SALES' and ( <fs_original_data>-Plantgateno = 'WLG01'
                                                       OR <fs_original_data>-Plantgateno = 'WLG02' OR <fs_original_data>-Plantgateno = 'WLG03' )
                                                     THEN abap_true
                                                     ELSE abap_false ).

*     <fs_original_data>-ShowWlpl = COND abap_boolean( WHEN <fs_original_data>-Type = 'SALES' and ( <fs_original_data>-Plantgateno = 'WLG01'
*                                                       OR <fs_original_data>-Plantgateno = 'G1601' OR <fs_original_data>-Plantgateno = 'G1602' )
*                                                     THEN abap_true
*                                                     ELSE abap_false ).
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_original_data1 ).

ENDMETHOD.


METHOD if_sadl_exit_calc_element_read~get_calculation_info.
* Extract the field you want the field visibility to depend on

ENDMETHOD.
ENDCLASS.
