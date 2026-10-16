CLASS zcl_product_f4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
   TYPES ty_gt_value_help_entry TYPE STANDARD TABLE OF zr_product_ce WITH DEFAULT KEY.

   TYPES: ty_pr  TYPE RANGE OF zr_product_ce-Product,
          ty_prd TYPE RANGE OF zr_product_ce-productname.

   METHODS get_provided_ranges
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      EXPORTING
        et_pr      TYPE ty_pr
        et_prd     TYPE ty_prd.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRODUCT_F4 IMPLEMENTATION.


 METHOD get_provided_ranges.
    TRY.
    DATA(lt_ranges)     = io_request->get_filter( )->get_as_ranges(  ).
        LOOP AT lt_ranges REFERENCE INTO DATA(lr_range).
          CASE lr_range->name.
            WHEN 'PRODUCT'.
              LOOP AT lr_range->range REFERENCE INTO DATA(lr_range_entry).
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_pr.
              ENDLOOP.
            WHEN 'PRODUCTNAME'.
              LOOP AT lr_range->range REFERENCE INTO lr_range_entry.
                INSERT VALUE #( sign = lr_range_entry->sign option =  lr_range_entry->option
                                low  = CONV #( lr_range_entry->low )  high   = CONV #( lr_range_entry->high ) )
                                INTO TABLE et_prd.
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

    get_provided_ranges( EXPORTING io_request = io_request
                         IMPORTING et_pr      = DATA(lt_pr)
                                   et_prd     = DATA(lt_prd) ).

    if lt_pr IS NOT INITIAL.
    SELECT a~Product, b~Productname
    FROM i_product as a
    INNER JOIN i_producttext as b on b~product = a~Product and b~Language = 'E'
    GROUP BY a~Product, b~Productname
    ORDER BY a~Product DESCENDING
    INTO TABLE @DATA(lt_tab).

    LOOP AT lt_tab REFERENCE INTO DATA(lr_reason_codes).
      MOVE-CORRESPONDING lr_reason_codes->* TO ls_value_help_entry.
      INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
    ENDLOOP.
    ELSE.
    SELECT a~Product, b~Productname
    FROM i_product as a
    INNER JOIN i_producttext as b on b~product = a~Product and b~Language = 'E'
    GROUP BY a~Product, b~Productname
    INTO TABLE @DATA(lt_tab2).

    LOOP AT lt_tab2 REFERENCE INTO DATA(lr_reason_codes2).
      MOVE-CORRESPONDING lr_reason_codes2->* TO ls_value_help_entry.
      INSERT ls_value_help_entry INTO TABLE lt_value_help_entries.
    ENDLOOP.
    endif.

    io_response->set_data( lt_value_help_entries ).
    io_response->set_total_number_of_records( lines( lt_value_help_entries ) ).
  ENDMETHOD.
ENDCLASS.
