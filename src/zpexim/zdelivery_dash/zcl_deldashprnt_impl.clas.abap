CLASS zcl_deldashprnt_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DELDASHPRNT_IMPL IMPLEMENTATION.


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

    data : lt_return TYPE TABLE of ZV_DELDASHPRNT_HDR.

      LOOP AT lt_range[ name = 'DELIVERYDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
       DATA(lv_del1) = <ls_range>-low.
      ENDLOOP.

      lv_del1 = |{ lv_del1 ALPHA = IN }|.
      SELECT SINGLE * FROM zv_deldashhdr
      WHERE DeliveryDocument = @lv_del1
      INTO @DATA(ls_del1).

      Select single * from zcds_amtwordtotal
      where DeliveryDocument = @lv_del1
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


      INSERT VALUE ZV_DELDASHPRNT_HDR(
      DeliveryDocument          = lv_del1
      CreationDate              = ls_del1-CreationDate
      CreationTime              = ls_del1-CreationTime
      GSTIN                     = ls_del1-GSTIN
      Name                      = ls_del1-name
      caddress1                 = ls_del1-caddress1
      caddress2                 = ls_del1-caddress2
      caddress3                 = ls_del1-caddress3
      Precarby                  = ls_del1-Precarby
      Por                       = ls_del1-Por
      Vesselno                  = ls_del1-Vesselno
      Contno                    = ls_del1-Contno
      Coo                       = ls_del1-Coo
      Cod                       = ls_del1-Cod
      Pol                       = ls_del1-Pol
      Pod                       = ls_del1-Pod
      Findes                    = ls_del1-Findes
      Descgoods                 = ls_del1-Descgoods
      IncoTermsClassification   = ls_del1-IncoTermsClassification
      CustomerPaymentTermsName  = ls_del1-CustomerPaymentTermsName
      Iec                       = ls_del1-iec
      var3                      = ls_del1-var3
      Plantaddr1                = ls_del1-plantaddr1
      Plantaddr2                = ls_del1-plantaddr2
      customernamesh            = ls_del1-customersh
      addresssh                 = ls_del1-addressh
      customernamebp            = ls_del1-customerbp
      addressbp                 = ls_del1-addressbp
      amtintext                 = amtintext
      salesnoteref              = ls_del1-Salesnoteref
      femadec                   = ls_del1-Femadec
      scomdec                   = ls_del1-Scomdec
      lutigst                   = ls_del1-Lutigst
      plant                     = ls_del1-plant
      cusmar                    = ls_del1-Cusmar
      zcuspodate                = ls_del1-zcuspodate
       ) into TABLE lt_return.
      io_response->set_data( lt_return ).
      io_response->set_total_number_of_records( lines( lt_return ) ).
  ENDMETHOD.
ENDCLASS.
