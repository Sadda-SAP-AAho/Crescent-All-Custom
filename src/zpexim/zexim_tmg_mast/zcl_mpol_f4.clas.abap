CLASS zcl_mpol_f4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES ty_gt_value_help_entry TYPE STANDARD TABLE OF zdt_mpol_tmg WITH DEFAULT KEY.

    TYPES: ty_pol TYPE RANGE OF zdt_mpol_tmg-polcode.
    TYPES: ty_poln TYPE RANGE OF zdt_mpol_tmg-polcodename.

    METHODS get_provided_ranges
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      EXPORTING
        et_pol     TYPE ty_pol
        et_poln    TYPE ty_poln.
ENDCLASS.



CLASS ZCL_MPOL_F4 IMPLEMENTATION.


  METHOD get_provided_ranges.
    TRY.
        DATA(lt_ranges)     = io_request->get_filter( )->get_as_ranges(  ).
        LOOP AT lt_ranges REFERENCE INTO DATA(lr_range).
          CASE lr_range->name.
            WHEN 'POLCODE'.
              LOOP AT lr_range->range REFERENCE INTO DATA(lr_range_entry).
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_pol.
              ENDLOOP.
            WHEN 'POLCODENAME'.
              LOOP AT lr_range->range REFERENCE INTO lr_range_entry.
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_poln.
              ENDLOOP.

          ENDCASE.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_previous).
        "Exception handling needed - not implemented yet
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_value_help_entries TYPE STANDARD TABLE OF zdt_mpol_tmg.
    DATA ls_value_help_entry   TYPE zdt_mpol_tmg.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lo_paging) = io_request->get_paging( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lt_sort_elements) = io_request->get_sort_elements( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lv_search_expression) = io_request->get_search_expression( ). " Basic search term

    get_provided_ranges( EXPORTING io_request = io_request
                         IMPORTING et_pol     = DATA(lt_pol)
                                   et_poln    = DATA(lt_poln) ).

    SELECT * FROM zi_polmastertable AS head
     WHERE polcode     IN @lt_pol AND
           polcodename IN @lt_poln
    INTO TABLE @DATA(lt_pol_f4).


    IF lt_pol_f4 IS NOT INITIAL.

      LOOP AT lt_pol_f4 REFERENCE INTO DATA(lr_reason_codes).
        MOVE-CORRESPONDING lr_reason_codes->* TO ls_value_help_entry.
        INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
      ENDLOOP.

    ENDIF.
    io_response->set_data( lt_value_help_entries ).
    io_response->set_total_number_of_records( lines( lt_value_help_entries ) ).
  ENDMETHOD.
ENDCLASS.
