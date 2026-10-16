CLASS zcl_draftpl_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DRAFTPL_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'DELIVERYDOCUMENT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    DATA : lt_return TYPE TABLE OF zcus_draftpl.

    LOOP AT lt_range[ name = 'DELIVERYDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

    LOOP AT lt_range[ name = 'REVISION' ]-range ASSIGNING FIELD-SYMBOL(<ls_range1>).
      DATA(lv_rev) = <ls_range1>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zvdraftpl_hdr
      WHERE deliverydocument = @lv_del and revision = @lv_rev
      INTO @DATA(ls_del1).

      SELECT SINGLE deliverydocument,deliverydocumentitem,referencesddocument,referencesddocumentitem from i_deliverydocumentitem
      with PRIVILEGED ACCESS
      where deliverydocument = @LS_DEL1-DeliveryDocument into @data(ls_salesdoc).



      select single salesdocument,salesdocumentitem,UnderlyingPurchaseOrderItem as PURCHASEORDERITEM from i_salesdocumentitem
      with PRIVILEGED ACCESS
      where salesdocument = @ls_salesdoc-ReferenceSDDocument and SalesDocumentItem = @ls_salesdoc-ReferenceSDDocumentItem
      into @data(ls_poline).


      Select * from I_BillingDocumentItem
             with privileged access
             where REFERENCESDDOCUMENT = @LS_DEL1-DeliveryDocument
             INTO table @DATA(LT_BILLINGDOC1).

      DATA: lv_custinv TYPE string.

      LOOP AT LT_BILLINGDOC1 INTO data(LS_BILLINGDOC1).

        Select single DocumentReferenceID from I_BillingDocument with privileged access
        where BillingDocument = @ls_billingdoc1-BillingDocument
          and AccountingTransferStatus <> 'E'
          and BillingDocumentType = 'F8'
        into @data(lv_custinvs).

*       IF SY-SUBRC IS INITIAL.
*
*            CONCATENATE lv_custinvs
*                        ','
*                        lv_custinv
*            INTO     lv_custinv
*            SEPARATED BY space.

*        ENDIF.

      ENDLOOP.


      INSERT VALUE zcus_draftpl(
      deliverydocument = lv_del
      pol              = ls_del1-pol
      pod              = ls_del1-pod
      coo              = ls_del1-coo
      cod              = ls_del1-cod
      cusmar           = ls_del1-cusmar
      descgoods        = ls_del1-descgoods
      descgoods1       = ls_del1-Descgoods1
      precarby         = ls_del1-precarby
      por              = ls_del1-por
      iec              = ls_del1-iec
      vesselno         = ls_del1-vesselno
      customername     = ls_del1-customername
      address          = ls_del1-address
      contno                     = ls_del1-contno
      purchaseorderbycustomer    = ls_del1-purchaseorderbycustomer
      PURCHASEORDERITEM          = ls_poline-purchaseorderitem
      customerpurchaseorderdate  = ls_del1-customerpurchaseorderdate
      incotermsclassification    = ls_del1-incotermsclassification
      incotermstransferlocation  = ls_del1-IncotermsTransferLocation
      caddress1                  = ls_del1-caddress1
      caddress2                  = ls_del1-caddress2
      caddress3                  = ls_del1-caddress3
      name                       = ls_del1-name
      placedel                   = ls_del1-placedel
      creationdate               = ls_del1-creationdate
      Revision                   = lv_rev
      textfield1                 = ls_del1-Textfield1
      textfield2                 = ls_del1-Textfield2
      var3                       = ls_del1-var3
      customer                   = ls_del1-customer
      customer1                  = ls_del1-customer1
      counbuyer                  = ls_del1-counbuyer
      counconsignee              = ls_del1-counconsignee
      buyeraddress               = ls_del1-buyeraddress
      salesnoteref               = ls_del1-Salesnoteref
      crdate                     = ls_del1-crdate
      BillingDocument            = lv_custinvs
      DocumentReferenceID        = ls_del1-DocumentReferenceID
      remarks                    = ls_del1-remarks
      zcuspodate                 = ls_del1-zcuspodate
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
