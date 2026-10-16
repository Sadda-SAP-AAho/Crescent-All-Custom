CLASS zcl_mcod_f4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES ty_gt_value_help_entry TYPE STANDARD TABLE OF zdt_mcod_tmg WITH DEFAULT KEY.

    TYPES: ty_cod TYPE RANGE OF zdt_mcod_tmg-codcode.
    TYPES: ty_codn TYPE RANGE OF zdt_mcod_tmg-codcodenam.

    METHODS get_provided_ranges
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      EXPORTING
        et_cod     TYPE ty_cod
        et_codn    TYPE ty_codn.
ENDCLASS.



CLASS ZCL_MCOD_F4 IMPLEMENTATION.


  METHOD get_provided_ranges.
    TRY.
        DATA(lt_ranges)     = io_request->get_filter( )->get_as_ranges(  ).
        LOOP AT lt_ranges REFERENCE INTO DATA(lr_range).
          CASE lr_range->name.
            WHEN 'CODCODE'.
              LOOP AT lr_range->range REFERENCE INTO DATA(lr_range_entry).
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_cod.
              ENDLOOP.
            WHEN 'CODCODENAM'.
              LOOP AT lr_range->range REFERENCE INTO lr_range_entry.
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_cod.
              ENDLOOP.
          ENDCASE.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_previous).
        "Exception handling needed - not implemented yet
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_value_help_entries TYPE STANDARD TABLE OF zdt_mcod_tmg.
    DATA ls_value_help_entry   TYPE zdt_mcod_tmg.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lo_paging) = io_request->get_paging( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lt_sort_elements) = io_request->get_sort_elements( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lv_search_expression) = io_request->get_search_expression( ). " Basic search term

    get_provided_ranges( EXPORTING io_request = io_request
                         IMPORTING et_cod      = DATA(lt_cod)
                                   et_codn     = DATA(lt_codn) ).


    IF  lt_cod IS NOT INITIAL.

      SELECT * FROM zi_codmastertable
       WHERE codcode IN @lt_cod
      INTO TABLE @DATA(lt_cod_f4).
    ELSE.
      SELECT * FROM zi_codmastertable
          WHERE codcode IN @lt_codn
         INTO TABLE @DATA(lt_codn_f4).

    ENDIF.

    IF lt_cod_f4 IS NOT INITIAL.

      LOOP AT lt_cod_f4 REFERENCE INTO DATA(lr_reason_codes).
        MOVE-CORRESPONDING lr_reason_codes->* TO ls_value_help_entry.
        INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
      ENDLOOP.

    ENDIF.

    IF lt_codn_f4 IS NOT INITIAL.

      LOOP AT lt_codn_f4 REFERENCE INTO DATA(lr_reason_codesn).
        MOVE-CORRESPONDING lr_reason_codesn->* TO ls_value_help_entry.
        INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
      ENDLOOP.

    ENDIF.
    io_response->set_data( lt_value_help_entries ).
    io_response->set_total_number_of_records( lines( lt_value_help_entries ) ).
  ENDMETHOD.
ENDCLASS.
