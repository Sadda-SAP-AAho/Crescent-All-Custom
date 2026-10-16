CLASS zcl_oprn_f4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES ty_gt_value_help_entry TYPE STANDARD TABLE OF zdt_opr_tmg WITH DEFAULT KEY.

    TYPES: ty_zopn TYPE RANGE OF zdt_opr_tmg-zopn.
    TYPES: ty_zopd TYPE RANGE OF zdt_opr_tmg-zopd.

    METHODS get_provided_ranges
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      EXPORTING
        et_zopn    TYPE ty_zopn
        et_zopd    TYPE ty_zopd.
ENDCLASS.



CLASS ZCL_OPRN_F4 IMPLEMENTATION.


  METHOD get_provided_ranges.
    TRY.
        DATA(lt_ranges)     = io_request->get_filter( )->get_as_ranges(  ).
        LOOP AT lt_ranges REFERENCE INTO DATA(lr_range).
          CASE lr_range->name.
            WHEN 'OPRCODE'.
              LOOP AT lr_range->range REFERENCE INTO DATA(lr_range_entry).
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_zopn.
              ENDLOOP.
            WHEN 'OPRCODENAME'.
              LOOP AT lr_range->range REFERENCE INTO lr_range_entry.
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_zopd.
              ENDLOOP.
          ENDCASE.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_previous).
        "Exception handling needed - not implemented yet
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    TYPES: BEGIN OF ty_oprf4,
             zopn TYPE char10,
             zopd TYPE char30,
           END OF ty_oprf4.

    DATA lt_value_help_entries TYPE STANDARD TABLE OF ty_oprf4.
    DATA ls_value_help_entry   TYPE ty_oprf4.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lo_paging) = io_request->get_paging( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lt_sort_elements) = io_request->get_sort_elements( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lv_search_expression) = io_request->get_search_expression( ). " Basic search term

    DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0
    ELSE lv_page_size ).

    lv_max_rows = lv_skip + lv_page_size.
    IF lv_skip > 0.
      lv_skip = lv_skip + 1.
    ENDIF.

    get_provided_ranges( EXPORTING io_request = io_request
                         IMPORTING et_zopn     = DATA(lt_zopn)
                                   et_zopd     = DATA(lt_zopd) ).


    SELECT DISTINCT zopn,zopd
      FROM zi_tmgtableforoperatio
     WHERE zopn IN @lt_zopn AND
           zopd IN @lt_zopd
    INTO TABLE @DATA(lt_opr_f4).

    IF lt_opr_f4 IS NOT INITIAL.

      LOOP AT lt_opr_f4 REFERENCE INTO DATA(lr_reason_codes) FROM lv_skip TO lv_max_rows.
        MOVE-CORRESPONDING lr_reason_codes->* TO ls_value_help_entry.
        INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
      ENDLOOP.

    ENDIF.

    io_response->set_data( lt_value_help_entries ).
    io_response->set_total_number_of_records( lines( lt_value_help_entries ) ).
  ENDMETHOD.
ENDCLASS.
