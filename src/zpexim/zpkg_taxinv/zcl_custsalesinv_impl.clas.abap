CLASS zcl_custsalesinv_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTSALESINV_IMPL IMPLEMENTATION.


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

    DATA : lt_return TYPE TABLE OF zcus_custsales_inv.

    LOOP AT lt_range[ name = 'BILLINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      DATA(lv_del) = <ls_range>-low.
    ENDLOOP.

    lv_del = |{ lv_del ALPHA = IN }|.
    SELECT SINGLE * FROM zcds_custsample_hdr
    WHERE billingdocument = @lv_del
    INTO @DATA(ls_del1).



    INSERT VALUE zcus_custsales_inv(
    billingdocument               = lv_del
    billingdocumentdate           = ls_del1-billingdocumentdate
    incotermslocation1            = ls_del1-incotermslocation1
    incotermstransferlocation     = ls_del1-incotermstransferlocation
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
    precarby                      = ls_del1-precarby
    por                           = ls_del1-por
    coo                           = ls_del1-coo
    cod                           = ls_del1-cod
    vesselno                      = ls_del1-vesselno
    delmode                       = ls_del1-delmode
    pod                           = ls_del1-pod
    pol                           = ls_del1-pol
    findes                        = ls_del1-findes
    carsealno                     = ls_del1-carsealno
    contno                        = ls_del1-contno
    cusmar                        = ls_del1-cusmar
    vehno                         = ls_del1-vehno
    referencesddocument           = ls_del1-referencesddocument
    customername                  = ls_del1-customername
    address                       = ls_del1-address
    customernamebp                = ls_del1-customernamebp
    addressbp                     = ls_del1-addressbp
    counconsignee                 = ls_del1-counconsignee
    counbuyer                     = ls_del1-counbuyer
    purchaseorderbycustomer       = ls_del1-purchaseorderbycustomer
    customerpurchaseorderdate     = ls_del1-customerpurchaseorderdate
    salesnoteref                  = ls_del1-salesnoteref
    femadec                       = ls_del1-femadec
    scomdec                       = ls_del1-scomdec
    lutigst                       = ls_del1-lutigst
    plant                         = ls_del1-plant
    customerpaymenttermsname      = ls_del1-customerpaymenttermsname
    descgoods                     = ls_del1-descgoods
    descgoods1                    = ls_del1-descgoods1
    var3                          = ls_del1-var3
    textfield1                    = ls_del1-textfield1
    textfield2                    = ls_del1-textfield2
    textfield3                    = ls_del1-textfield3
    textfield4                    = ls_del1-textfield4
    zcuspodate                    = ls_del1-zcuspodate
    DocumentReferenceID           = ls_del1-DocumentReferenceID
     ) INTO TABLE lt_return.

    io_response->set_data( lt_return ).
    io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
