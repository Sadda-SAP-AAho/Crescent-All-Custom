CLASS zcl_finalplform_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FINALPLFORM_IMPL IMPLEMENTATION.


METHOD if_rap_query_provider~select.
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'BILLINGDOCUMENT' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

    data : lt_return TYPE TABLE of zcus_finalplform.

      LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_bill) = <ls_range>-low.
      Data : lv_bill1 type vbeln.
      lv_bill = |{ lv_bill ALPHA = IN }|.
      select single * from zcds_finalplhed
      where BillingDocument = @lv_bill
      into @data(ls_bill1).

*      lv_bill1 = lv_bill.
      lv_bill1 = |{ lv_bill ALPHA = IN }|.


*      Select Single * from I_BillingDocument
*             with privileged ACCESS
*             where BillingDocument =  @lv_bill1
*             into @data(ls_billingdoc).

        data: lv_custinv type string.

         Select * from I_BillingDocumentItem
         with privileged ACCESS
         where BillingDocument =  @lv_bill1
         into table @data(lt_billingdoc).

         Delete ADJACENT DUPLICATES FROM lt_billingdoc COMPARING ReferenceSDDocument.


         Select * from I_BillingDocumentItem
         with privileged access for all entries in @lt_billingdoc
         where REFERENCESDDOCUMENT = @LT_BILLINGDOC-ReferenceSDDocument
         INTO table @DATA(LT_BILLINGDOC1).

         Delete ADJACENT DUPLICATES FROM lt_billingdoc1 COMPARING BillingDocument.


         Select DocumentReferenceID from I_BillingDocument
         with privileged access for all entries in @lt_billingdoc1
         where BillingDocument = @lt_billingdoc1-BillingDocument
         and BillingDocument <> @lv_bill1
         and AccountingTransferStatus <> 'E'
         and BillingDocumentType = 'F8'
         into table @data(lt_custinvs).

         LOOP AT lt_custinvs into data(lv_custinvs).

         IF SY-SUBRC IS INITIAL.

            CONCATENATE lv_custinvs
                        ','
                        lv_custinv
               INTO     lv_custinv
               SEPARATED BY space.

         ENDIF.

         ENDLOOP.


      INSERT VALUE zcus_finalplform(
      Billingdocument = lv_bill
      doc_ref_id      = lv_custinv
      CreationDate    = ls_bill1-CreationDate
      caddress1       = ls_bill1-caddress1
      caddress2       = ls_bill1-caddress2
      name            = ls_bill1-name
      Carsealno       = ls_bill1-Carsealno
      Findes          = ls_bill1-Findes
      PurchaseOrderByCustomer = ls_bill1-PurchaseOrderByCustomer
      cinno           = ls_bill1-cinno
      cod             = ls_bill1-Cod
      contno          = ls_bill1-Contno
      coo             = ls_bill1-Coo
      gstin           = ls_bill1-gstin
      iec             = ls_bill1-iec
      pol              = ls_bill1-pol
      pod              = ls_bill1-pod
      cusmar           = ls_bill1-cusmar
      descgoods        = ls_bill1-descgoods
      precarby         = ls_bill1-precarby
      por              = ls_bill1-por
      vesselno         = ls_bill1-Vesselcode
      ShippingBill     = ls_bill1-ShippingBill
      ShippingBillDate = ls_bill1-ShippingBillDate
      Descgoods1       = ls_bill1-Descgoods1
      Descgoods2       = ls_bill1-Descgoods2
      var3             = ls_bill1-var3
      counconsignee    = ls_bill1-counconsignee
      counbuyer        = ls_bill1-counbuyer
      custbuyer        = ls_bill1-custbuyer
      custconsignee    = ls_bill1-custconsignee
      CustomerPaymentTermsName = ls_bill1-CustomerPaymentTermsName
      ladingno         = ls_bill1-Ladingno
      sumgrosswt       = ls_bill1-sumgrosswt
      sumnetwt         = ls_bill1-sumnetwt
      sumqty           = ls_bill1-sumqty
      remarks          = ls_bill1-Remarks
      ) into TABLE lt_return.
      endloop.
      io_response->set_data( lt_return ).
      io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
