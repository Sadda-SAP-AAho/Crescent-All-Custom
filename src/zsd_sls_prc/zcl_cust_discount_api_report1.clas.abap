CLASS zcl_cust_discount_api_report1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES tt_report_out TYPE STANDARD TABLE OF zce_custdiscountreport1 WITH DEFAULT KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUST_DISCOUNT_API_REPORT1 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lt_output TYPE tt_report_out.
    DATA ls_output LIKE LINE OF lt_output.

    TRY.
        " Extract paging parameters safely
        DATA(lo_paging) = io_request->get_paging( ).
        DATA(lv_top)    = lo_paging->get_page_size( ).
        DATA(lv_skip)   = lo_paging->get_offset( ).

        " Extract filters safely
        DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).

        DATA lv_salesdoc      TYPE I_SalesDocumentItem-SalesDocument.
        DATA lv_salesdocitem  TYPE I_SalesDocumentItem-SalesDocumentItem.
        DATA lv_sold_to_party TYPE I_SalesDocument-SoldToParty.
        DATA lr_crd           TYPE RANGE OF I_SalesDocument-RequestedDeliveryDate.

        " Extract key filters
        LOOP AT lt_filters ASSIGNING FIELD-SYMBOL(<fs_filter>).
          DATA(lv_name) = to_upper( <fs_filter>-name ).

          CASE lv_name.
            WHEN 'SALESDOCUMENT'.
              READ TABLE <fs_filter>-range INTO DATA(ls_doc) INDEX 1.
              IF sy-subrc = 0 AND ls_doc-low IS NOT INITIAL.
                lv_salesdoc = |{ ls_doc-low ALPHA = IN }|.
              ENDIF.

            WHEN 'SALESDOCUMENTITEM'.
              READ TABLE <fs_filter>-range INTO DATA(ls_item) INDEX 1.
              IF sy-subrc = 0 AND ls_item-low IS NOT INITIAL.
                lv_salesdocitem = |{ ls_item-low ALPHA = IN }|.
              ENDIF.

            WHEN 'SOLDTOPARTY'.
              READ TABLE <fs_filter>-range INTO DATA(ls_sold) INDEX 1.
              IF sy-subrc = 0 AND ls_sold-low IS NOT INITIAL.
                lv_sold_to_party = |{ ls_sold-low ALPHA = IN }|.
              ENDIF.

            WHEN 'REQUESTEDDELIVERYDATE'.
              lr_crd = CORRESPONDING #( <fs_filter>-range ).
          ENDCASE.
        ENDLOOP.

        " Fetch Base Data from Sales Document Views
        SELECT
          h~SalesDocument,
          h~SalesDocumentDate,
          h~PurchaseOrderByCustomer,
          h~CustomerPurchaseOrderDate,
          h~RequestedDeliveryDate,
          h~SalesOrganization,
          h~DistributionChannel,
          h~SoldToParty,
          h~TransactionCurrency,
          i~SalesDocumentItem,
          i~Material,
          i~SalesDocumentItemText,
          i~OrderQuantity,
          i~OrderQuantityUnit,
          i~ItemGrossWeight
        FROM I_SalesDocument AS h
        INNER JOIN I_SalesDocumentItem AS i
          ON h~SalesDocument = i~SalesDocument
        WHERE ( @lv_salesdoc IS INITIAL OR h~SalesDocument = @lv_salesdoc )
          AND ( @lv_salesdocitem IS INITIAL OR i~SalesDocumentItem = @lv_salesdocitem )
          AND ( @lv_sold_to_party IS INITIAL OR h~SoldToParty = @lv_sold_to_party )
          AND i~SalesDocumentItemCategory = 'TAN'
          AND i~SalesDocumentRjcnReason IS INITIAL
        INTO TABLE @DATA(lt_sales_data).

        IF lt_sales_data IS INITIAL.
          RETURN.
        ENDIF.

        " Fetch ZPR0 Condition Prices directly via SQL (Replaces HTTP API Call)
        SELECT
          SalesDocument,
          SalesDocumentItem,
          ConditionRateValue
        FROM I_SalesDocItemPricingElement
        FOR ALL ENTRIES IN @lt_sales_data
        WHERE SalesDocument     = @lt_sales_data-SalesDocument
          AND SalesDocumentItem = @lt_sales_data-SalesDocumentItem
          AND ConditionType     = 'ZPR0'
          AND ConditionInactiveReason IS INITIAL
        INTO TABLE @DATA(lt_zpr0_prices).

        SORT lt_zpr0_prices BY SalesDocument SalesDocumentItem.

        LOOP AT lt_sales_data ASSIGNING FIELD-SYMBOL(<fs_sales>).
          CLEAR ls_output.

          ls_output-salesdocument         = <fs_sales>-SalesDocument.
          ls_output-salesdocumentitem     = <fs_sales>-SalesDocumentItem.
          ls_output-salesdocumentdate     = <fs_sales>-SalesDocumentDate.
          ls_output-purchaseorderbycust   = <fs_sales>-PurchaseOrderByCustomer.
          ls_output-customerpodate        = <fs_sales>-CustomerPurchaseOrderDate.
          ls_output-requesteddeliverydate = <fs_sales>-RequestedDeliveryDate.
          ls_output-soldtoparty           = <fs_sales>-SoldToParty.
          ls_output-material              = <fs_sales>-Material.
          ls_output-salesdocumentitemtext = <fs_sales>-SalesDocumentItemText.
          ls_output-orderquantity         = <fs_sales>-OrderQuantity.
          ls_output-orderquantityunit     = <fs_sales>-OrderQuantityUnit.
          ls_output-totalweightkg         = <fs_sales>-ItemGrossWeight.

          " Transaction Currency Key
          ls_output-transactioncurrency   = COND #( WHEN <fs_sales>-TransactionCurrency IS NOT INITIAL
                                                   THEN <fs_sales>-TransactionCurrency
                                                   ELSE 'EUR' ).

          " Unit Weight Calculation (Column K)
          IF ls_output-orderquantity > 0.
            ls_output-stdunitweight = ls_output-totalweightkg / ls_output-orderquantity.
          ENDIF.

          " Get Unit Price ZPR0 directly (Column M)
          READ TABLE lt_zpr0_prices INTO DATA(ls_price)
            WITH KEY SalesDocument     = <fs_sales>-SalesDocument
                     SalesDocumentItem = <fs_sales>-SalesDocumentItem
            BINARY SEARCH.
          IF sy-subrc = 0.
            ls_output-unitprice = ls_price-ConditionRateValue.
          ENDIF.

          " Column N: Total Price
          ls_output-totalprice    = ls_output-unitprice * ls_output-orderquantity.

          " Column O: Total Wt (MT)
          ls_output-totalweightmt = ls_output-totalweightkg / 1000.

          " Column P: Value / MT
          IF ls_output-totalweightmt > 0.
            ls_output-valuepermt = ls_output-totalprice / ls_output-totalweightmt.
          ENDIF.

          " Column Q: Discount % (Adjusted threshold for MT: 14 MT, 13 MT, 12 MT, 11 MT)
          IF ls_output-totalweightmt >= 14.
            ls_output-discountpct = 4.
          ELSEIF ls_output-totalweightmt >= 13.
            ls_output-discountpct = 3.
          ELSEIF ls_output-totalweightmt >= 12.
            ls_output-discountpct = 2.
          ELSEIF ls_output-totalweightmt >= 11.
            ls_output-discountpct = 1.
          ELSE.
            ls_output-discountpct = 0.
          ENDIF.

          " Column R: Discount Value
          IF ls_output-discountpct > 0 AND ls_output-totalweightmt > 10.
            ls_output-discountval = ( ls_output-valuepermt * ( ls_output-totalweightmt - 10 ) * ( ls_output-discountpct / 100 ) ).
          ELSE.
            ls_output-discountval = 0.
          ENDIF.

          APPEND ls_output TO lt_output.
        ENDLOOP.

        " Ensure key uniqueness
        SORT lt_output BY salesdocument salesdocumentitem.
        DELETE ADJACENT DUPLICATES FROM lt_output COMPARING salesdocument salesdocumentitem.

        " Set total record count
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( lt_output ) ).
        ENDIF.

        " Handle Paging
        IF lv_top IS NOT INITIAL AND lv_top > 0.
          DATA(lv_start) = lv_skip + 1.
          IF lv_start <= lines( lt_output ).
            DATA(lt_paged_output) = VALUE tt_report_out(
              FOR i = lv_start THEN i + 1 WHILE i <= lv_start + lv_top - 1 AND i <= lines( lt_output )
              ( lt_output[ i ] )
            ).
            io_response->set_data( lt_paged_output ).
          ELSE.
            CLEAR lt_output.
            io_response->set_data( lt_output ).
          ENDIF.
        ELSE.
          io_response->set_data( lt_output ).
        ENDIF.

      CATCH cx_root INTO DATA(lx_root).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
