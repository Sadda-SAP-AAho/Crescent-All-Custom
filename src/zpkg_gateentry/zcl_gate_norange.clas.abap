CLASS zcl_gate_norange DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GATE_NORANGE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA nr_attribute     TYPE cl_numberrange_objects=>nr_attribute.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA obj_text         TYPE cl_numberrange_objects=>nr_obj_text.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_returncode    TYPE cl_numberrange_objects=>nr_returncode.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_errors        TYPE cl_numberrange_objects=>nr_errors.
    DATA nr_interval      TYPE cl_numberrange_intervals=>nr_interval.
    DATA st_interval      LIKE LINE OF nr_interval.
    DATA error            TYPE cl_numberrange_intervals=>nr_error.
    DATA error_inf        TYPE cl_numberrange_intervals=>nr_error_inf.
    DATA error_iv         TYPE cl_numberrange_intervals=>nr_error_iv.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_subobject     TYPE cl_numberrange_intervals=>nr_subobject.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_count         TYPE char10.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_count_machine TYPE char10.

**---Machine A
*    nr_attribute-buffer = ''.
*    nr_attribute-object = 'ZQRSCAN'. "object name
*    nr_attribute-domlen = 'ZDO_QRSCAN'. "domain to be used eg char 10
*    nr_attribute-percentage = '10'.
*    nr_attribute-yearind = 'X'.
*    nr_attribute-devclass = 'ZQRSCAN'. "Class where number range actually gets created
*
*    obj_text-langu = 'E'.
*    obj_text-object = 'ZQRSCAN'. "object name
*    obj_text-txt = 'QR Scan Number Range'. "long description
*    obj_text-txtshort = 'QR Scan Number Range'. "short description
*
*    TRY.
*        cl_numberrange_objects=>create( " method to create object
*          EXPORTING
*            attributes = nr_attribute
*            obj_text   = obj_text
*          IMPORTING
*            errors     = lv_errors
*            returncode = lv_returncode ).
*      CATCH cx_number_ranges INTO DATA(lx_number_range).
*    ENDTRY.
*
*
    lv_count += 1.

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lv_year) = lv_date+0(4).

    st_interval-nrrangenr  = '01'.
    st_interval-procind    = 'I'.
    st_interval-fromnumber = '1'. " starting number
    st_interval-tonumber   = '99999'. " ending number
    APPEND st_interval TO nr_interval.

    TRY.
        cl_numberrange_intervals=>create( " method to create interval
                                          EXPORTING interval  = nr_interval
                                                    object    = 'ZPO'
                                          IMPORTING error     = error
                                                    error_inf = error_inf
                                                    error_iv  = error_iv ).
      CATCH cx_nr_object_not_found INTO DATA(lx_no_obj_found). " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_number_ranges INTO DATA(cx_number_ranges). " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.
    " TODO: remove needless CLEAR (ABAP cleaner)
    CLEAR nr_interval.

    " TODO: remove needless CLEAR (ABAP cleaner)
    CLEAR: nr_attribute,
            " TODO: remove needless CLEAR (ABAP cleaner)
           obj_text,
           " TODO: remove needless CLEAR (ABAP cleaner)
           lv_errors,
           " TODO: remove needless CLEAR (ABAP cleaner)
           lv_returncode,
           " TODO: remove needless CLEAR (ABAP cleaner)
           nr_interval,
           " TODO: remove needless CLEAR (ABAP cleaner)
           st_interval,
           " TODO: remove needless CLEAR (ABAP cleaner)
           lv_count,
           " TODO: remove needless CLEAR (ABAP cleaner)
           lv_subobject,
           " TODO: remove needless CLEAR (ABAP cleaner)
           lv_count_machine.
  ENDMETHOD.
ENDCLASS.
