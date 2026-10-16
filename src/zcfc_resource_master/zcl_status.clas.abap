CLASS zcl_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES : if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_STATUS IMPLEMENTATION.


METHOD if_sadl_exit_calc_element_read~calculate.


    TYPES:
      BEGIN OF ty_local_data,
        Requestuuid      TYPE x LENGTH 16,     " Built-in type for UUID
        IsActiveEntity   TYPE abap_boolean,     " Built-in type
        UpdateStatus     TYPE char10,    " Built-in type
      END OF ty_local_data.


    DATA lt_local_data TYPE TABLE OF ty_local_data.
    DATA ls_local_row TYPE ty_local_data.

    FIELD-SYMBOLS: <ls_original_row> TYPE any.


data : lt_data type STANDARD TABLE OF Z_C_MOTHER_CHILD.

lt_data = CORRESPONDING #( it_original_data ).


loop at lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).

select SINGLE requestuuid,mother_child_catagory from zmthr_chld_ctgry where requestuuid = @<ls_data>-Requestuuid and mother_child_catagory = @<ls_data>-Mother_child_catagory into @data(wa_data).
if sy-subrc = 0.
 <ls_data>-UpdateStatus = 'CREATED'.
  <ls_data>-StatusCriticality = 3.
 elseif sy-subrc > 0.

 <ls_data>-UpdateStatus = 'DRAFT'.
  <ls_data>-StatusCriticality = 2.
 endif.

ENDLOOP.


  ct_calculated_data = CORRESPONDING #( lt_data ).







*    LOOP AT it_original_data ASSIGNING <ls_original_row>.
*        " Clear the work area for a fresh row
*        CLEAR ls_local_row.
*
*        " Dynamically assign components (IsActiveEntity is key here)
*        ASSIGN COMPONENT 'REQUESTUUID'  OF STRUCTURE <ls_original_row> TO FIELD-SYMBOL(<fs_uuid>).
*        IF <fs_uuid> IS ASSIGNED. ls_local_row-Requestuuid = <fs_uuid>. ENDIF.
*
*        ASSIGN COMPONENT 'ISACTIVEENTITY' OF STRUCTURE <ls_original_row> TO FIELD-SYMBOL(<fs_active>).
*        IF <fs_active> IS ASSIGNED. ls_local_row-IsActiveEntity = <fs_active>. ENDIF.
*
*        " Append the locally filled structure to the table
*        APPEND ls_local_row TO lt_local_data.
*    ENDLOOP.
*
*    FIELD-SYMBOLS: <ls_local_row_fs> LIKE LINE OF lt_local_data.
*
*    " 2. Process the local, writable data
*    LOOP AT lt_local_data ASSIGNING <ls_local_row_fs>.
*      IF <ls_local_row_fs>-IsActiveEntity = abap_false.
*        <ls_local_row_fs>-UpdateStatus = 'Draft'.
*      ELSE.
*        <ls_local_row_fs>-UpdateStatus = 'Created'.
*      ENDIF.
*    ENDLOOP.

    " 3. Assign the result back to the CHANGING parameter CT_CALCULATED_DATA




  ENDMETHOD.


 METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
