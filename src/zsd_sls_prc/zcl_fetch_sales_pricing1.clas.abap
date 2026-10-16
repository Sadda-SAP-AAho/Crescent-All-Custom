CLASS zcl_fetch_sales_pricing1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PRIVATE SECTION.
    " Reduced batch size to stay safely within OData local proxy URI limits
    CONSTANTS gc_batch_size TYPE i VALUE 20.

    " Component names match OData property names of A_SlsPrcgCndnRecdValidity
    TYPES: BEGIN OF ty_api_validity,
             conditionrecord TYPE c LENGTH 10,
             customer        TYPE c LENGTH 10,
             material        TYPE c LENGTH 40,
           END OF ty_api_validity.
    TYPES ty_api_validity_t TYPE STANDARD TABLE OF ty_api_validity WITH EMPTY KEY.

ENDCLASS.



CLASS ZCL_FETCH_SALES_PRICING1 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA lt_final_output TYPE STANDARD TABLE OF zcustomslspric1 WITH EMPTY KEY.
    DATA lt_paged_output TYPE STANDARD TABLE OF zcustomslspric1 WITH EMPTY KEY.
    DATA lt_api_validity TYPE ty_api_validity_t.
    DATA lt_batch_result TYPE ty_api_validity_t.
    DATA lv_error_text   TYPE string.

    IF io_request->is_data_requested( ) = abap_false
       AND io_request->is_total_numb_of_rec_requested( ) = abap_false.
      RETURN.
    ENDIF.

    TRY.

        DATA lr_cond_type TYPE RANGE OF i_slsprcgconditionrecord-conditiontype.
        DATA lr_customer  TYPE RANGE OF string.
        DATA lr_material  TYPE RANGE OF string.

        DATA lr_valid_on TYPE RANGE OF dats.

        TRY.
            DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).
            LOOP AT lt_filters ASSIGNING FIELD-SYMBOL(<fs_filter>).
              CASE to_upper( <fs_filter>-name ).
                WHEN 'CONDITIONTYPE'.
                  lr_cond_type = CORRESPONDING #( <fs_filter>-range ).
                WHEN 'CUSTOMER'.
                  lr_customer  = CORRESPONDING #( <fs_filter>-range ).
                WHEN 'PRODUCT' OR 'MATERIAL'.
                  lr_material  = CORRESPONDING #( <fs_filter>-range ).
                WHEN 'CUSTOMERREQUESTEDDELIVERYDATE'.
                  lr_valid_on  = CORRESPONDING #( <fs_filter>-range ).
              ENDCASE.
            ENDLOOP.
          CATCH cx_rap_query_filter_no_range.
            " No filters supplied; proceed with standard execution
        ENDTRY.

        " Default to ZPR0 if no specific condition type requested
        IF lr_cond_type IS INITIAL.
          lr_cond_type = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZPR0' ) ).
        ENDIF.

        IF lr_valid_on IS INITIAL.
          lr_valid_on = VALUE #( ( sign = 'I' option = 'EQ' low = sy-datum ) ).
        ENDIF.

        DATA(lv_min_date) = lr_valid_on[ 1 ]-low.
        DATA(lv_max_date) = lr_valid_on[ 1 ]-low.
        LOOP AT lr_valid_on INTO DATA(ls_valid_on_r).
          IF ls_valid_on_r-low < lv_min_date.
            lv_min_date = ls_valid_on_r-low.
          ENDIF.
          DATA(lv_high) = COND dats( WHEN ls_valid_on_r-high IS NOT INITIAL
                                     THEN ls_valid_on_r-high ELSE ls_valid_on_r-low ).
          IF lv_high > lv_max_date.
            lv_max_date = lv_high.
          ENDIF.
        ENDLOOP.

        SELECT conditionrecord,
               conditiontype,
               conditionvaliditystartdate,
               conditionvalidityenddate,
               conditioncurrency,
               conditionratevalue
          FROM i_slsprcgconditionrecord
          WHERE conditiontype IN @lr_cond_type
            AND conditionvaliditystartdate <= @lv_max_date
            AND conditionvalidityenddate   >= @lv_min_date
          INTO TABLE @DATA(lt_base_pricing).

        IF lt_base_pricing IS NOT INITIAL.

          DATA(lo_client_proxy) = cl_web_odata_client_factory=>create_v2_local_proxy(
                                    VALUE #( service_id      = 'API_SLSPRICINGCONDITIONRECORD_SRV'
                                             service_version = '0001' ) ).

          DATA(lv_total_recs) = lines( lt_base_pricing ).
          DATA(lv_from)       = 1.

          WHILE lv_from <= lv_total_recs.

            DATA(lv_to) = nmin( val1 = lv_from + gc_batch_size - 1
                                val2 = lv_total_recs ).

            DATA lt_record_range TYPE RANGE OF string.
            CLEAR lt_record_range.

            LOOP AT lt_base_pricing ASSIGNING FIELD-SYMBOL(<fs_init_base>)
                 FROM lv_from TO lv_to.
              APPEND VALUE #( sign   = 'I'
                              option = 'EQ'
                              low    = <fs_init_base>-conditionrecord ) TO lt_record_range.
            ENDLOOP.

            TRY.
                DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set(
                                     'A_SlsPrcgCndnRecdValidity'
                                   )->create_request_for_read( ).

                DATA(lo_filter_factory) = lo_request->create_filter_factory( ).
                DATA(lo_filter)         = lo_filter_factory->create_by_range(
                                            iv_property_path = 'ConditionRecord'
                                            it_range         = lt_record_range ).

                " Combine with Customer/Material filters if passed from UI
                IF lr_customer IS NOT INITIAL.
                  lo_filter = lo_filter->and( lo_filter_factory->create_by_range(
                                                iv_property_path = 'Customer'
                                                it_range         = lr_customer ) ).
                ENDIF.

                IF lr_material IS NOT INITIAL.
                  lo_filter = lo_filter->and( lo_filter_factory->create_by_range(
                                                iv_property_path = 'Material'
                                                it_range         = lr_material ) ).
                ENDIF.

                lo_request->set_filter( lo_filter ).

                DATA(lo_response) = lo_request->execute( ).

                CLEAR lt_batch_result.
                lo_response->get_business_data( IMPORTING et_business_data = lt_batch_result ).
                APPEND LINES OF lt_batch_result TO lt_api_validity.

              CATCH cx_root INTO DATA(lx_proxy_err).
                " Log or inspect proxy exception during batch execution
                lv_error_text = lx_proxy_err->get_text( ).
            ENDTRY.

            lv_from = lv_to + 1.
          ENDWHILE.

          SORT lt_api_validity BY conditionrecord.

          LOOP AT lr_valid_on INTO ls_valid_on_r.
            DATA(lv_ref_date) = ls_valid_on_r-low.

            LOOP AT lt_base_pricing ASSIGNING FIELD-SYMBOL(<fs_base>)
              WHERE conditionvaliditystartdate <= lv_ref_date
                AND conditionvalidityenddate   >= lv_ref_date.

              READ TABLE lt_api_validity ASSIGNING FIELD-SYMBOL(<fs_api>)
                WITH KEY conditionrecord = <fs_base>-conditionrecord
                BINARY SEARCH.
              IF sy-subrc = 0.

                IF lr_customer  IS NOT INITIAL AND NOT <fs_api>-customer IN lr_customer.
                  CONTINUE.
                ENDIF.
                IF lr_material  IS NOT INITIAL AND NOT <fs_api>-material IN lr_material.
                  CONTINUE.
                ENDIF.

                APPEND VALUE zcustomslspric1(
                  conditionrecord            = <fs_base>-conditionrecord
                  conditiontype              = <fs_base>-conditiontype
                  conditionvaliditystartdate = <fs_base>-conditionvaliditystartdate
                  conditionvalidityenddate   = <fs_base>-conditionvalidityenddate
                  conditioncurrency          = <fs_base>-conditioncurrency
                  conditionratevalue         = <fs_base>-conditionratevalue
                  customer                   = <fs_api>-customer
                  product                    = <fs_api>-material
                ) TO lt_final_output.
              ENDIF.
            ENDLOOP.
          ENDLOOP.

          SORT lt_final_output BY conditionrecord customer product.
          DELETE ADJACENT DUPLICATES FROM lt_final_output COMPARING ALL FIELDS.

        ENDIF.

      CATCH cx_root INTO DATA(lx_error).
        lv_error_text = lx_error->get_text( ).
        CLEAR lt_final_output.
    ENDTRY.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( lt_final_output ) ).
    ENDIF.

    IF io_request->is_data_requested( ).

      DATA(lo_paging)    = io_request->get_paging( ).
      DATA(lv_offset)    = lo_paging->get_offset( ).
      DATA(lv_page_size) = lo_paging->get_page_size( ).
      DATA(lv_total)     = lines( lt_final_output ).

      IF lv_offset < 0.
        lv_offset = 0.
      ENDIF.

      DATA(lv_last_index) = COND i(
        WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited
          THEN lv_total
        ELSE nmin( val1 = lv_offset + lv_page_size
                   val2 = lv_total ) ).

      IF lv_offset < lv_last_index.
        APPEND LINES OF lt_final_output
          FROM lv_offset + 1 TO lv_last_index
          TO lt_paged_output.
      ENDIF.

      io_response->set_data( lt_paged_output ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
