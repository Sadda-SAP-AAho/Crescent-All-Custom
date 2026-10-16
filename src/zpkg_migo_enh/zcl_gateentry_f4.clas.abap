CLASS zcl_gateentry_f4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES ty_gt_value_help_entry TYPE STANDARD TABLE OF zr_gateentry_ce WITH DEFAULT KEY.

    TYPES: ty_gp TYPE RANGE OF zr_gateentry_ce-gatepass,
           ty_po TYPE RANGE OF zr_gateentry_ce-purchaseorder.

    METHODS get_provided_ranges
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      EXPORTING
        et_gp      TYPE ty_gp
        et_po      TYPE ty_po.
ENDCLASS.



CLASS ZCL_GATEENTRY_F4 IMPLEMENTATION.


  METHOD get_provided_ranges.
    TRY.
        DATA(lt_ranges)     = io_request->get_filter( )->get_as_ranges(  ).
        LOOP AT lt_ranges REFERENCE INTO DATA(lr_range).
          CASE lr_range->name.
            WHEN 'GATEPASS'.
              LOOP AT lr_range->range REFERENCE INTO DATA(lr_range_entry).
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_gp.
              ENDLOOP.
            WHEN 'PURCHASEORDER'.
              LOOP AT lr_range->range REFERENCE INTO lr_range_entry.
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_po.
              ENDLOOP.
          ENDCASE.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_previous).
        "Exception handling needed - not implemented yet
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA lt_value_help_entries TYPE STANDARD TABLE OF zr_gateentry_ce.
    DATA ls_value_help_entry   TYPE zr_gateentry_ce.

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
                         IMPORTING et_gp      = DATA(lt_gp)
                                   et_po      = DATA(lt_po) ).

    IF  lt_gp IS NOT INITIAL.
      SELECT DISTINCT head~gatepass, item~ebeln AS purchaseorder FROM zc_ghead AS head
        INNER JOIN zc_gitem AS item
           ON head~id = item~id
        WHERE head~gatepass IS NOT INITIAL
          AND head~deleted  IS INITIAL
          AND head~cancel   IS INITIAL
          AND head~gatepass IN @lt_gp
        ORDER BY head~gatepass DESCENDING
         INTO TABLE @DATA(lt_gate).
    ELSE.
      SELECT DISTINCT head~gatepass, item~ebeln AS purchaseorder FROM zc_ghead AS head
        INNER JOIN zc_gitem AS item
           ON head~id = item~id
        WHERE head~gatepass IS NOT INITIAL
          AND head~deleted  IS INITIAL
          AND head~cancel   IS INITIAL
          AND item~ebeln IN @lt_gp
        ORDER BY head~gatepass DESCENDING
         INTO TABLE @DATA(lt_gate2).
    ENDIF.

    IF lt_gp IS NOT INITIAL.

      LOOP AT lt_gate REFERENCE INTO DATA(lr_reason_codes) from lv_skip to lv_max_rows.

        MOVE-CORRESPONDING lr_reason_codes->* TO ls_value_help_entry.
        INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
      ENDLOOP.

    ELSE.

      LOOP AT lt_gate2 REFERENCE INTO DATA(lr_reason_codes2) from lv_skip to lv_max_rows.
        MOVE-CORRESPONDING lr_reason_codes2->* TO ls_value_help_entry.
        INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
      ENDLOOP.

    ENDIF.
    io_response->set_data( lt_value_help_entries ).
    io_response->set_total_number_of_records( lines( lt_value_help_entries ) ).
  ENDMETHOD.
ENDCLASS.
