CLASS zcl_gatepass_showpo DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
  INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GATEPASS_SHOWPO IMPLEMENTATION.


 METHOD if_sadl_exit_calc_element_read~calculate.

* Check the field for your condition and return either abap_true or abap_false for the virtual field.
    DATA lt_original_data TYPE STANDARD TABLE OF  zc_gitem  WITH DEFAULT KEY.
*    DATA lt_original_data1 TYPE STANDARD TABLE OF zc_ghead WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).
   LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      <fs_original_data>-ShowPO = COND abap_boolean( WHEN <fs_original_data>-Type = 'PO'
                                                   "AND ( <fs_original_data>-Plantgateno = 'G1601' OR <fs_original_data>-Plantgateno = 'G1602' )
                                                     THEN abap_true
                                                     ELSE abap_false ).

*      <fs_original_data>-ShowPO = COND abap_boolean( WHEN <fs_original_data>-Type = 'SALES' and
*     ( <fs_original_data>-Plantgateno = 'G1601' OR <fs_original_data>-Plantgateno = 'G1602' )
*                                                     THEN abap_true
*                                                    ELSE abap_false ).
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

* Extract the field you want the field visibility to depend on
    IF iv_entity = 'ZC_GITEM'.
      LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
        CASE <fs_calc_element>.
          WHEN 'SHOWPO'.
            APPEND 'TYPE' TO et_requested_orig_elements.
        ENDCASE.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
