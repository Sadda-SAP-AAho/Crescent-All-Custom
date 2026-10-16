CLASS zcl_stat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES : if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_STAT IMPLEMENTATION.


METHOD if_sadl_exit_calc_element_read~calculate.
data : lt_data type STANDARD TABLE OF Z_C_RESOURCE_MASTER.


lt_data = CORRESPONDING #( it_original_data ).

loop at lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).

select SINGLE requestuuid, Resource_code  from zrsrc_mastr_head where requestuuid = @<ls_data>-Requestuuid and resource_code = @<ls_data>-Resource_code into @data(wa_data).
if sy-subrc = 0.
 <ls_data>-UpdateStatus = 'CREATED'.
  <ls_data>-statuscriticallity = 3.
 elseif sy-subrc > 0.

 <ls_data>-UpdateStatus = 'DRAFT'.
  <ls_data>-statuscriticallity = 2.
 endif.


endloop.

ct_calculated_data = CORRESPONDING #( lt_data ).
ENDMETHOD.


 METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
