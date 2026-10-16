CLASS zcl_gatepass_showsales DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GATEPASS_SHOWSALES IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    " Check the field for your condition and return either abap_true or abap_false for the virtual field.
    DATA lt_original_data TYPE STANDARD TABLE OF zc_gitem WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      SELECT SINGLE type, plantgateno
        FROM zi_ghead
        WHERE id = @<fs_original_data>-id
        INTO @DATA(ls_final).

*      IF  <fs_original_data>-showsales = COND abap_boolean( WHEN ls_final-type = 'SALES'
*     " and ( ls_final-Plantgateno = 'G1601' OR ls_final-Plantgateno = 'G1602' )
*                                                      THEN abap_true
*                                                     ELSE abap_false ).
*    elseif
      <fs_original_data>-showsales = COND abap_boolean( WHEN ls_final-type = 'SALES' OR ls_final-type = 'SALES RETURN'
      " and ( ls_final-Plantgateno = 'WLG01'
      "           OR ls_final-Plantgateno = 'WLG02' OR ls_final-Plantgateno = 'WLG03' )
                                                        THEN abap_true
                                                        ELSE abap_false ).
*      ENDIF.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

* Extract the field you want the field visibility to depend on
    IF iv_entity = 'ZC_GITEM'.
      LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
        CASE <fs_calc_element>.
          WHEN 'SHOWSALES'.
            APPEND 'TYPE'        TO  et_requested_orig_elements.
        ENDCASE.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
