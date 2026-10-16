CLASS zcl_proinv_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PROINV_IMPL IMPLEMENTATION.


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

    DATA : lt_return TYPE TABLE OF zcus_proinv.

    LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zcds_proinvhed
      WHERE billingdocument = @lv_del
      INTO @DATA(ls_del1).

      Select single * from zcds_amtotal4
      where BillingDocument = @lv_del
      INTO @DATA(ls_amt).

data: lv_paise type string.
data: lv_rupees type string .
DATA: lv_amtwrd TYPE STRING.
DATA: amtintext TYPE char256.
lv_rupees = ls_amt-grandtotal.
lv_amtwrd = ZCL_NUMTOWORDS=>ZNUMWORD( exporting iv_num = lv_rupees
                           CHANGING rv_dec_words = lv_paise ).

    CONCATENATE lv_amtwrd
                'Rupees and'
      INTO     amtintext
      SEPARATED BY space.

    CONCATENATE amtintext
                lv_paise
                'Paise Only'
      INTO      amtintext
      SEPARATED BY space.





      INSERT VALUE zcus_proinv(
      BillingDocument               = lv_del
      BillingDocumentDate           = ls_del1-BillingDocumentDate
      IncotermsLocation1            = ls_del1-IncotermsLocation1
      incotermstransferlocation     = ls_del1-IncotermsTransferLocation
      caddress1                     = ls_del1-caddress1
      caddress2                     = ls_del1-caddress2
      caddress3                     = ls_del1-caddress3
      name                          = ls_del1-name
      plantname                     = ls_del1-plantname
      plantaddr1                    = ls_del1-plantaddr1
      plantaddr2                    = ls_del1-plantaddr2
      plantaddr3                    = ls_del1-plantaddr3
      iec                           = ls_del1-iec
      gstin                         = ls_del1-gstin
      Precarby                      = ls_del1-Precarby
      Por                           = ls_del1-Por
      Coo                           = ls_del1-Coo
      Cod                           = ls_del1-Cod
      vesselno                      = ls_del1-Vesselno
      Delmode                       = ls_del1-Delmode
      Pod                           = ls_del1-Pod
      Pol                           = ls_del1-Pol
      Findes                        = ls_del1-Findes
      Carsealno                     = ls_del1-Carsealno
      Contno                        = ls_del1-Contno
      Cusmar                        = ls_del1-Cusmar
      Vehno                         = ls_del1-Vehno
      ReferenceSDDocument           = ls_del1-ReferenceSDDocument
      customername                  = ls_del1-customername
      address                       = ls_del1-address
      customer                      = ls_del1-customer
      customer1                     = ls_del1-customer1
      counconsignee                 = ls_del1-counconsignee
      counbuyer                     = ls_del1-counbuyer
      PurchaseOrderByCustomer       = ls_del1-PurchaseOrderByCustomer
      CustomerPurchaseOrderDate     = ls_del1-CustomerPurchaseOrderDate
      salesnoteref                  = ls_del1-Salesnoteref
      amtintext                     = amtintext
      femadec                       = ls_del1-Femadec
      scomdec                       = ls_del1-Scomdec
      lutigst                       = ls_del1-Lutigst
      plant                         = ls_del1-plant
      CustomerPaymentTermsName      = ls_del1-CustomerPaymentTermsName
      descgoods                     = ls_del1-Descgoods
      descgoods1                    = ls_del1-Descgoods1
      var3                          = ls_del1-var3
      DocumentReferenceID           = ls_del1-DocumentReferenceID
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
