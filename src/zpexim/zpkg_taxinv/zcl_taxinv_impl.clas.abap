CLASS zcl_taxinv_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TAXINV_IMPL IMPLEMENTATION.


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

    DATA : lt_return TYPE TABLE OF zcus_taxinv.

    LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

      lv_del = |{ lv_del ALPHA = IN }|.
      SELECT SINGLE * FROM zcds_taxinvhed
      WHERE billingdocument = @lv_del
      INTO @DATA(ls_del1).

      Select single * from zcds_amtotal2
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


Select single * from zcds_amtotal3
      where BillingDocument = @lv_del
      INTO @DATA(ls_amt1).

data: lv_paise1 type string.
data: lv_rupees1 type string .
DATA: lv_amtwrd1 TYPE STRING.
DATA: amtintextdom TYPE char256.
lv_rupees1 = ls_amt1-grandtotal1.

data: decdig type i.
decdig = lv_rupees1 * 100.
decdig = decdig MOD 100.
if ( decdig gt 49 ).
 lv_rupees1 = lv_rupees1 + 1.
endif.


lv_amtwrd1 = ZCL_NUMTOWORDS=>ZNUMWORD( exporting iv_num = lv_rupees1
                           CHANGING rv_dec_words = lv_paise1 ).

    CONCATENATE lv_amtwrd1
                'Rupees only.'
      INTO     amtintextdom
      SEPARATED BY space.

"    CONCATENATE amtintextdom
"                lv_paise1
"                'Paise Only'
"      INTO      amtintextdom
"      SEPARATED BY space.


      INSERT VALUE zcus_taxinv(
      BillingDocument               = lv_del
      BillingDocumentDate           = ls_del1-BillingDocumentDate
      IN_EDocEInvcEWbillNmbr        = ls_del1-IN_EDocEInvcEWbillNmbr
      IN_ElectronicDocInvcRefNmbr   = ls_del1-IN_ElectronicDocInvcRefNmbr
      IN_ElectronicDocQRCodeTxt     = ls_del1-IN_ElectronicDocQRCodeTxt
      caddress1                     = ls_del1-caddress1
      caddress2                     = ls_del1-caddress2
      caddress3                     = ls_del1-caddress3
      name                          = ls_del1-name
      plantname                     = ls_del1-plantname
      plantaddr1                    = ls_del1-plantaddr1
      plantaddr2                    = ls_del1-plantaddr2
      plantaddr3                    = ls_del1-plantaddr3
      gstin                         = ls_del1-gstin
      tin                           = ls_del1-tin
      cinno                         = ls_del1-cinno
      panno                         = ls_del1-panno
      Delmode                       = ls_del1-Delmode
      Pod                           = ls_del1-Pod
      Carsealno                     = ls_del1-Carsealno
      Contno                        = ls_del1-Contno
      Vehno                         = ls_del1-Vehno
      lrno                          = ls_del1-Lrblno
      ReferenceSDDocument           = ls_del1-ReferenceSDDocument
      customername                  = ls_del1-customername
      address                       = ls_del1-address
      LUTNo                         = ls_del1-LUTNo
      LUTdt                         = ls_del1-LUTdt
      amtintext                     = amtintext
      amtintextdom                  = amtintextdom
      textfield1                    = ls_del1-Textfield1
      textfield2                    = ls_del1-Textfield2
      textfield3                    = ls_del1-Textfield3
      textfield4                    = ls_del1-Textfield4
      customernamedeltax            = ls_del1-customernamedeltax
      addressdeltax                 = ls_del1-addressdeltax
      regioncodedeltax              = ls_del1-regioncodedeltax
      regionnamedeltax              = ls_del1-regionnamedeltax
      gstindeltax                   = ls_del1-gstindeltax
      pannodeltax                   = ls_del1-pannodeltax
      gstinship                     = ls_del1-gstinship
      pannoship                     = ls_del1-pannoship
      regioncodesh                  = ls_del1-regioncodesh
      regionnamesh                  = ls_del1-regionnamesh
      Lc_Appl                       = ls_del1-lcnumber
      Lc_Open_Dt                    = ls_del1-lcdate
      Banka                         = ls_del1-lcbankname
      ShippingBill                  = ls_del1-ShippingBill
       ShippingBillDate             = ls_del1-ShippingBillDate
      PurchaseOrderByCustomer       = ls_del1-PurchaseOrderByCustomer
      pkgsum                        = ls_del1-pkgsum
      netwtsum                      = ls_del1-netwtsum
      DocumentReferenceID           = ls_del1-DocumentReferenceID
       ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
